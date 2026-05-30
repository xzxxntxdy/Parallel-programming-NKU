#pragma once
#include "pthread_benchmark.h"
#include "ann_quant.h"
using namespace ann;
using namespace pthread_ann;

// ============================================================
// PQ-SIMD + Pthread: LUT build parallel, scan parallel (query/basesplit)
// ============================================================

// Strategy A: LUT build parallel — parallelize across sub-spaces
struct LutBuildArg {
    int tid, nthreads;
    const float* query;
    const PQIndex* idx;
    std::vector<float>* lut;  // output
};

static void* lut_build_worker(void* arg) {
    LutBuildArg* a = (LutBuildArg*)arg;
    int m = a->idx->m, ks = a->idx->ks, subdim = a->idx->subdim;
    for (int part = a->tid; part < m; part += a->nthreads) {
        const float* q = a->query + (size_t)part * subdim;
        const float* centers = &a->idx->codebooks[(size_t)part * ks * subdim];
        for (int c = 0; c < ks; c++) {
            float dot = 0;
            const float* center = centers + (size_t)c * subdim;
            for (int j = 0; j < subdim; j++) dot += center[j] * q[j];
            (*a->lut)[(size_t)part * ks + c] = dot;
        }
    }
    return NULL;
}

inline void lut_build_parallel(const PQIndex& idx, const float* query,
                                std::vector<float>& lut, int nthreads) {
    lut.assign((size_t)idx.m * idx.ks, 0);
    if (nthreads <= 0) nthreads = 1;
    std::vector<LutBuildArg> args(nthreads);
    std::vector<std::thread> threads(nthreads);
    for (int t = 0; t < nthreads; t++) {
        args[t] = {t, nthreads, query, &idx, &lut};
        threads[t] = std::thread( lut_build_worker, &args[t]);
    }
    for (int t = 0; t < nthreads; t++) threads[t].join();
}

inline void lut_build_into(const PQIndex& idx, const float* query, float* lut) {
    for (int part = 0; part < idx.m; ++part) {
        const float* q = query + static_cast<size_t>(part) * idx.subdim;
        const float* centers = &idx.codebooks[static_cast<size_t>(part) * idx.ks * idx.subdim];
        for (int c = 0; c < idx.ks; ++c) {
            float dot = 0.0f;
            const float* center = centers + static_cast<size_t>(c) * idx.subdim;
            for (int j = 0; j < idx.subdim; ++j) dot += center[j] * q[j];
            lut[static_cast<size_t>(part) * idx.ks + c] = dot;
        }
    }
}

// Strategy B: Query-parallel PQ scan
struct PqQueryArg {
    int tid, nthreads;
    const PQIndex* idx; const float* base; const float* query; const int* gt;
    size_t nq, k, p, gt_d;
    std::vector<double>* latencies; std::vector<float>* recalls;
    std::vector<QuantTiming>* timings;
};

static void* pq_query_worker(void* arg) {
    PqQueryArg* a = (PqQueryArg*)arg;
    for (size_t qi = a->tid; qi < a->nq; qi += a->nthreads) {
        long long t0 = now_us();
        QuantTiming tim;
        auto res = pq_adc_search_rerank_select_timed(*a->idx, a->base, a->query + qi * a->idx->d,
                                                       a->p, a->k, &tim);
        long long t1 = now_us();
        (*a->latencies)[qi] = (t1 - t0) / 1000.0;
        (*a->recalls)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
        if (a->timings) (*a->timings)[qi] = tim;
    }
    return NULL;
}

inline void pq_query_parallel(const PQIndex& idx, const float* base, const float* query,
                               const int* gt, size_t nq, size_t k, size_t p, size_t gt_d,
                               int nthreads, double& avg_lat, double& avg_rec,
                               TimingAvg* avg_timing = NULL) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<double> lats(nq, 0); std::vector<float> recs(nq, 0);
    std::vector<QuantTiming> timings(nq);
    std::vector<PqQueryArg> args(nthreads);
    std::vector<std::thread> threads(nthreads);
    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; t++) {
        args[t] = {t, nthreads, &idx, base, query, gt, nq, k, p, gt_d, &lats, &recs,
                   avg_timing ? &timings : NULL};
        threads[t] = std::thread( pq_query_worker, &args[t]);
    }
    for (int t = 0; t < nthreads; t++) threads[t].join();
    long long wall_t1 = now_us();
    avg_lat = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
    if (avg_timing) {
        *avg_timing = TimingAvg();
        for (size_t i = 0; i < timings.size(); ++i) add_timing(*avg_timing, timings[i]);
        scale_timing(*avg_timing, 1.0 / std::max<size_t>(1, timings.size()));
    }
}

// Strategy C: Base-split PQ scan with local top-p + merge
struct PqBaseSplitArg {
    int tid, nthreads;
    const PQIndex* idx; const float* base; const float* query; const int* gt;
    size_t N, d, nq, k, p, gt_d;
    size_t base_start, base_end;
    std::vector<std::vector<std::pair<float, uint32_t>>>* local_results; // this thread: [qi][candidates]
    const std::vector<float>* lut;  // shared pre-built LUTs [qi][m][ks]
};

static void* pq_basesplit_worker(void* arg) {
    PqBaseSplitArg* a = (PqBaseSplitArg*)arg;
    int m = a->idx->m, ks = a->idx->ks;
    for (size_t qi = 0; qi < a->nq; qi++) {
        std::priority_queue<std::pair<float, uint32_t>> heap;
        const float* lut = &(*a->lut)[qi * m * ks];
        for (size_t i = a->base_start; i < a->base_end; i++) {
            const uint8_t* code = &a->idx->codes[i * m];
            float dot = 0;
            for (int part = 0; part < m; part++)
                dot += lut[(size_t)part * ks + code[part]];
            float d = 1.0f - dot;
            if (heap.size() < a->p) heap.push({d, (uint32_t)i});
            else if (d < heap.top().first) { heap.push({d, (uint32_t)i}); heap.pop(); }
        }
        auto& loc = (*a->local_results)[qi];
        while (!heap.empty()) { loc.push_back(heap.top()); heap.pop(); }
    }
    return NULL;
}

inline void pq_basesplit_parallel(const PQIndex& idx, const float* base, const float* query,
                                   const int* gt, size_t N, size_t d, size_t nq, size_t k, size_t p,
                                   size_t gt_d, int nthreads, double& avg_lat, double& avg_rec) {
    if (nthreads <= 0) nthreads = 1;
    p = std::max(p, k);
    size_t chunk = (N + nthreads - 1) / nthreads;

    // Pre-build LUTs for all queries
    std::vector<float> all_luts(nq * static_cast<size_t>(idx.m) * idx.ks);
    for (size_t qi = 0; qi < nq; qi++) {
        float* lut = &all_luts[qi * static_cast<size_t>(idx.m) * idx.ks];
        lut_build_into(idx, query + qi * d, lut);
    }

    std::vector<std::vector<std::vector<std::pair<float, uint32_t>>>> local_results(
        nthreads, std::vector<std::vector<std::pair<float, uint32_t>>>(nq));
    std::vector<PqBaseSplitArg> args(nthreads);
    std::vector<std::thread> threads(nthreads);

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; t++) {
        size_t start = t * chunk, end = std::min(start + chunk, N);
        args[t] = {t, nthreads, &idx, base, query, gt, N, d, nq, k, p, gt_d,
                   start, end, &local_results[t], &all_luts};
        threads[t] = std::thread( pq_basesplit_worker, &args[t]);
    }
    for (int t = 0; t < nthreads; t++) threads[t].join();

    // Merge + rerank per query
    std::vector<float> recs;
    for (size_t qi = 0; qi < nq; qi++) {
        std::priority_queue<std::pair<float, uint32_t>> merged;
        for (int t = 0; t < nthreads; ++t) {
            for (auto& pr : local_results[t][qi]) {
                if (merged.size() < p) merged.push(pr);
                else if (pr.first < merged.top().first) { merged.push(pr); merged.pop(); }
            }
        }
        // Rerank: exact distance for merged top-p
        std::priority_queue<std::pair<float, uint32_t>> final_result;
        while (!merged.empty()) {
            uint32_t id = merged.top().second; merged.pop();
            float dot = inner_product_neon(base + id * d, query + qi * d, d);
            float dist = 1.0f - dot;
            if (final_result.size() < k) final_result.push({dist, id});
            else if (dist < final_result.top().first) { final_result.push({dist, id}); final_result.pop(); }
        }
        recs.push_back(calc_recall_k(final_result, gt, gt_d, qi, k));
    }
    long long wall_t1 = now_us();
    avg_lat = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}

// ============ FastScan variant ============
inline void pq_fastscan_query_parallel(const PQIndex& idx, const PQFastScanIndex& fsi,
                                        const float* base, const float* query, const int* gt,
                                        size_t nq, size_t k, size_t p, size_t gt_d,
                                        int nthreads, double& avg_lat, double& avg_rec) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<double> lats(nq, 0); std::vector<float> recs(nq, 0);
    std::vector<std::thread> threads(nthreads);

    struct FSArg { int tid, nt; const PQIndex* idx; const PQFastScanIndex* fsi;
        const float* base; const float* query; const int* gt;
        size_t nq, k, p, gt_d; std::vector<double>* lats; std::vector<float>* recs; };
        // Per-query timings are intentionally not shared here; use the timed overload below.
    std::vector<FSArg> args(nthreads);

    auto worker = [](void* a_) -> void* {
        FSArg* a = (FSArg*)a_;
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            long long t0 = now_us(); QuantTiming tim; float mae;
            auto res = pq_adc_fastscan_search_rerank_timed(*a->idx, *a->fsi, a->base,
                                                             a->query + qi * a->idx->d, a->p, a->k, &tim, &mae);
            long long t1 = now_us();
            (*a->lats)[qi] = (t1 - t0) / 1000.0;
            (*a->recs)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
        }
        return NULL;
    };

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; t++) {
        args[t] = {t, nthreads, &idx, &fsi, base, query, gt, nq, k, p, gt_d, &lats, &recs};
        threads[t] = std::thread( worker, &args[t]);
    }
    for (int t = 0; t < nthreads; t++) threads[t].join();
    long long wall_t1 = now_us();
    avg_lat = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}

inline void pq_fastscan_query_parallel_timed(const PQIndex& idx, const PQFastScanIndex& fsi,
                                             const float* base, const float* query, const int* gt,
                                             size_t nq, size_t k, size_t p, size_t gt_d,
                                             int nthreads, double& avg_lat, double& avg_rec,
                                             TimingAvg* avg_timing, double* avg_lut_mae = NULL) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<float> recs(nq, 0);
    std::vector<QuantTiming> timings(nq);
    std::vector<float> maes(nq, 0.0f);
    std::vector<std::thread> threads(nthreads);

    struct FSArg { int tid, nt; const PQIndex* idx; const PQFastScanIndex* fsi;
        const float* base; const float* query; const int* gt;
        size_t nq, k, p, gt_d; std::vector<float>* recs;
        std::vector<QuantTiming>* timings; std::vector<float>* maes; };
    std::vector<FSArg> args(nthreads);

    auto worker = [](void* a_) -> void* {
        FSArg* a = (FSArg*)a_;
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            QuantTiming tim; float mae = 0.0f;
            auto res = pq_adc_fastscan_search_rerank_timed(*a->idx, *a->fsi, a->base,
                                                           a->query + qi * a->idx->d,
                                                           a->p, a->k, &tim, &mae);
            (*a->recs)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
            (*a->timings)[qi] = tim;
            (*a->maes)[qi] = mae;
        }
        return NULL;
    };

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; ++t) {
        args[t] = {t, nthreads, &idx, &fsi, base, query, gt, nq, k, p, gt_d,
                   &recs, &timings, &maes};
        threads[t] = std::thread(worker, &args[t]);
    }
    for (int t = 0; t < nthreads; ++t) threads[t].join();
    long long wall_t1 = now_us();

    avg_lat = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
    if (avg_timing) {
        *avg_timing = TimingAvg();
        for (size_t i = 0; i < timings.size(); ++i) add_timing(*avg_timing, timings[i]);
        scale_timing(*avg_timing, 1.0 / std::max<size_t>(1, timings.size()));
    }
    if (avg_lut_mae) {
        double s = 0.0;
        for (size_t i = 0; i < maes.size(); ++i) s += maes[i];
        *avg_lut_mae = s / std::max<size_t>(1, maes.size());
    }
}
