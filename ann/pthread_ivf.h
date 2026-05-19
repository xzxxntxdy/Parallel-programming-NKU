#pragma once
#include "pthread_benchmark.h"
#include "ann_search.h"
#include "ann_quant.h"
#include "pthread_pq.h"
using namespace ann;
using namespace pthread_ann;

// ============================================================
// IVF: Inverted File index + SIMD + Pthread + PQ
// ============================================================

struct IVFIndex {
    size_t n, d;
    int nlist;              // number of clusters (coarse centroids)
    int nprobe;             // clusters to probe per query
    std::vector<float> centroids;           // nlist × d
    std::vector<std::vector<uint32_t>> lists;  // inverted lists: centroid → vector IDs
    // Optional PQ within each cluster (IVF-PQ)
    bool use_pq;
    int pq_m, pq_ks;
    std::vector<PQIndex> pq_indices;       // per-cluster PQ (only if use_pq)
};

// ============ Build IVF index ============
inline void build_ivf_index(const float* base, size_t n, size_t d, int nlist,
                             IVFIndex& idx, int kmeans_iters = 10) {
    idx.n = n; idx.d = d; idx.nlist = nlist; idx.nprobe = std::min(nlist, 8);
    idx.use_pq = false;

    // KMeans on base data
    idx.centroids.assign((size_t)nlist * d, 0);
    // Init: strided samples
    for (int c = 0; c < nlist; c++) {
        size_t si = (size_t)c * n / nlist;
        memcpy(&idx.centroids[(size_t)c * d], base + si * d, d * sizeof(float));
    }

    std::vector<int> assign(n);
    std::vector<int> counts(nlist);
    std::vector<double> sums(nlist * d);
    for (int iter = 0; iter < kmeans_iters; iter++) {
        std::fill(counts.begin(), counts.end(), 0);
        std::fill(sums.begin(), sums.end(), 0.0);
        for (size_t i = 0; i < n; i++) {
            const float* x = base + i * d;
            int best = 0; float best_d = 1e30f;
            for (int c = 0; c < nlist; c++) {
                const float* ct = &idx.centroids[(size_t)c * d];
                float d2 = 0;
                for (size_t j = 0; j < d; j++) { float df = x[j] - ct[j]; d2 += df * df; }
                if (d2 < best_d) { best_d = d2; best = c; }
            }
            assign[i] = best; counts[best]++;
            double* s = &sums[(size_t)best * d];
            for (size_t j = 0; j < d; j++) s[j] += x[j];
        }
        for (int c = 0; c < nlist; c++) {
            if (!counts[c]) continue;
            float inv = 1.0f / counts[c];
            for (size_t j = 0; j < d; j++) idx.centroids[(size_t)c * d + j] = (float)(sums[(size_t)c * d + j] * inv);
        }
    }

    // Build inverted lists
    idx.lists.resize(nlist);
    for (size_t i = 0; i < n; i++) idx.lists[assign[i]].push_back((uint32_t)i);
}

// ============ IVF query (SIMD inner product) ============
inline std::priority_queue<std::pair<float, uint32_t>>
ivf_search(const IVFIndex& idx, const float* base, const float* query,
            size_t k, int nprobe) {
    int np = std::min(nprobe, idx.nlist);
    // Coarse: find nearest nprobe centroids
    std::vector<std::pair<float, int>> coarse_dists(idx.nlist);
    for (int c = 0; c < idx.nlist; c++) {
        float dot = inner_product_neon(&idx.centroids[(size_t)c * idx.d], query, idx.d);
        coarse_dists[c] = {1.0f - dot, c};
    }
    if (np < idx.nlist) {
        std::nth_element(coarse_dists.begin(), coarse_dists.begin() + np, coarse_dists.end());
    } else {
        std::sort(coarse_dists.begin(), coarse_dists.end());
    }

    // Fine: scan selected clusters
    std::priority_queue<std::pair<float, uint32_t>> result;
    for (int p = 0; p < np; p++) {
        int cid = coarse_dists[p].second;
        for (uint32_t vid : idx.lists[cid]) {
            float dot = inner_product_neon(base + (size_t)vid * idx.d, query, idx.d);
            float dist = 1.0f - dot;
            if (result.size() < k) result.push({dist, vid});
            else if (dist < result.top().first) { result.push({dist, vid}); result.pop(); }
        }
    }
    return result;
}

// ============ IVF-SIMD + Pthread (2.2.1 baseline 2pts + pthread 4pts) ============

// Strategy: query-parallel IVF
struct IvfQueryArg {
    int tid, nthreads;
    const IVFIndex* idx; const float* base; const float* query; const int* gt;
    size_t nq, k, gt_d; int nprobe;
    std::vector<double>* lats; std::vector<float>* recs;
};

static void* ivf_query_worker(void* arg) {
    IvfQueryArg* a = (IvfQueryArg*)arg;
    for (size_t qi = a->tid; qi < a->nq; qi += a->nthreads) {
        long long t0 = now_us();
        auto res = ivf_search(*a->idx, a->base, a->query + qi * a->idx->d, a->k, a->nprobe);
        long long t1 = now_us();
        (*a->lats)[qi] = (t1 - t0) / 1000.0;
        (*a->recs)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
    }
    return NULL;
}

inline void ivf_query_parallel(const IVFIndex& idx, const float* base, const float* query,
                                const int* gt, size_t nq, size_t k, size_t gt_d, int nprobe,
                                int nthreads, double& avg_lat, double& avg_rec) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<double> lats(nq, 0); std::vector<float> recs(nq, 0);
    std::vector<IvfQueryArg> args(nthreads);
    std::vector<std::thread> threads(nthreads);
    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; t++) {
        args[t] = {t, nthreads, &idx, base, query, gt, nq, k, gt_d, nprobe, &lats, &recs};
        threads[t] = std::thread( ivf_query_worker, &args[t]);
    }
    for (int t = 0; t < nthreads; t++) threads[t].join();
    long long wall_t1 = now_us();
    avg_lat = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
}

// Strategy: cluster-parallel fine scan (for single query)
struct IvfClusterArg {
    int tid, nthreads;
    const IVFIndex* idx; const float* base; const float* query;
    size_t k;
    std::vector<int>* probe_ids;  // top-nprobe cluster IDs
    std::priority_queue<std::pair<float, uint32_t>>* local_result;
};

static void* ivf_cluster_worker(void* arg) {
    IvfClusterArg* a = (IvfClusterArg*)arg;
    for (size_t pi = a->tid; pi < a->probe_ids->size(); pi += a->nthreads) {
        int cid = (*a->probe_ids)[pi];
        for (uint32_t vid : a->idx->lists[cid]) {
            float dot = inner_product_neon(a->base + (size_t)vid * a->idx->d, a->query, a->idx->d);
            float dist = 1.0f - dot;
            auto& h = *a->local_result;
            if (h.size() < a->k) h.push({dist, vid});
            else if (dist < h.top().first) { h.push({dist, vid}); h.pop(); }
        }
    }
    return NULL;
}

// ============ IVF-PQ: build PQ per cluster ============
inline void build_ivf_pq(IVFIndex& idx, const float* base, int m, int ks, int train_n, int iters) {
    idx.use_pq = true; idx.pq_m = m; idx.pq_ks = ks;
    idx.pq_indices.resize(idx.nlist);
    for (int c = 0; c < idx.nlist; c++) {
        size_t nc = idx.lists[c].size();
        if (nc < (size_t)train_n) continue; // skip small clusters
        // Extract cluster vectors
        std::vector<float> cluster_data(nc * idx.d);
        for (size_t i = 0; i < nc; i++)
            memcpy(&cluster_data[i * idx.d], base + (size_t)idx.lists[c][i] * idx.d, idx.d * sizeof(float));
        build_pq_index(cluster_data.data(), nc, idx.d, m, ks, train_n, iters, idx.pq_indices[c]);
    }
}

// ============ IVF-PQ query ============
inline std::priority_queue<std::pair<float, uint32_t>>
ivf_pq_search(const IVFIndex& idx, const float* base, const float* query,
               size_t k, int nprobe, size_t rerank_p) {
    int np = std::min(nprobe, idx.nlist);
    std::vector<std::pair<float, int>> coarse(idx.nlist);
    for (int c = 0; c < idx.nlist; c++) {
        float dot = inner_product_neon(&idx.centroids[(size_t)c * idx.d], query, idx.d);
        coarse[c] = {1.0f - dot, c};
    }
    if (np < idx.nlist) {
        std::nth_element(coarse.begin(), coarse.begin() + np, coarse.end());
    } else {
        std::sort(coarse.begin(), coarse.end());
    }

    // PQ coarse search across probed clusters
    std::priority_queue<std::pair<float, uint32_t>> coarse_heap;
    for (int p = 0; p < np; p++) {
        int cid = coarse[p].second;
        if (!idx.use_pq || cid >= (int)idx.pq_indices.size()) {
            // No PQ for this cluster — exact scan
            for (uint32_t vid : idx.lists[cid]) {
                float dot = inner_product_neon(base + (size_t)vid * idx.d, query, idx.d);
                float d = 1.0f - dot;
                if (coarse_heap.size() < rerank_p) coarse_heap.push({d, vid});
                else if (d < coarse_heap.top().first) { coarse_heap.push({d, vid}); coarse_heap.pop(); }
            }
            continue;
        }
        // PQ-ADC scan for this cluster
        const PQIndex& pq_idx = idx.pq_indices[cid];
        QuantTiming tim;
        auto local_heap = pq_adc_search_rerank_select_timed(pq_idx, base, query, rerank_p, 1, &tim);
        // Accumulate into coarse_heap
        while (!local_heap.empty()) {
            auto pr = local_heap.top(); local_heap.pop();
            if (coarse_heap.size() < rerank_p) coarse_heap.push(pr);
            else if (pr.first < coarse_heap.top().first) { coarse_heap.push(pr); coarse_heap.pop(); }
        }
    }
    return coarse_heap;
}

inline void ivf_select_probe_ids(const IVFIndex& idx,
                                 const float* query,
                                 int nprobe,
                                 std::vector<int>& probe_ids) {
    int np = std::min(nprobe, idx.nlist);
    std::vector<std::pair<float, int> > coarse(idx.nlist);
    for (int c = 0; c < idx.nlist; ++c) {
        float dist = ip_distance(&idx.centroids[static_cast<size_t>(c) * idx.d],
                                 query, idx.d, kManualNeonUnroll4);
        coarse[c] = std::make_pair(dist, c);
    }
    if (np < idx.nlist) {
        std::nth_element(coarse.begin(), coarse.begin() + np, coarse.end());
    } else {
        std::sort(coarse.begin(), coarse.end());
    }
    probe_ids.resize(np);
    for (int i = 0; i < np; ++i) probe_ids[i] = coarse[i].second;
}

inline std::priority_queue<std::pair<float, uint32_t> >
ivf_pq_global_search_timed(const IVFIndex& ivf,
                           const PQIndex& pq,
                           const float* base,
                           const float* query,
                           size_t k,
                           int nprobe,
                           size_t rerank_p,
                           QuantTiming* timing) {
    rerank_p = std::min(std::max(rerank_p, k), pq.n);
    long long coarse_t0 = quant_now_us();
    std::vector<int> probe_ids;
    ivf_select_probe_ids(ivf, query, nprobe, probe_ids);
    long long coarse_t1 = quant_now_us();

    long long lut_t0 = quant_now_us();
    std::vector<float> lut(static_cast<size_t>(pq.m) * pq.ks, 0.0f);
    lut_build_into(pq, query, &lut[0]);
    long long lut_t1 = quant_now_us();

    long long scan_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > candidates;
    for (size_t pi = 0; pi < probe_ids.size(); ++pi) {
        const std::vector<uint32_t>& list = ivf.lists[probe_ids[pi]];
        for (size_t li = 0; li < list.size(); ++li) {
            uint32_t id = list[li];
            const uint8_t* code = &pq.codes[static_cast<size_t>(id) * pq.m];
            float dot = 0.0f;
            for (int part = 0; part < pq.m; ++part) {
                dot += lut[static_cast<size_t>(part) * pq.ks + code[part]];
            }
            push_heap_topk(candidates, 1.0f - dot, id, rerank_p);
        }
    }
    long long scan_t1 = quant_now_us();

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result;
    while (!candidates.empty()) {
        uint32_t id = candidates.top().second;
        candidates.pop();
        float dist = ip_distance(base + static_cast<size_t>(id) * pq.d,
                                 query, pq.d, kManualNeonUnroll4);
        push_heap_topk(result, dist, id, k);
    }
    long long rerank_t1 = quant_now_us();

    if (timing) {
        timing->coarse_us = coarse_t1 - coarse_t0;
        timing->lut_us = lut_t1 - lut_t0;
        timing->scan_us = scan_t1 - scan_t0;
        timing->rerank_us = rerank_t1 - rerank_t0;
    }
    return result;
}

inline std::priority_queue<std::pair<float, uint32_t> >
ivf_pq_local_search_timed(const IVFIndex& ivf,
                          const float* base,
                          const float* query,
                          size_t k,
                          int nprobe,
                          size_t rerank_p,
                          QuantTiming* timing) {
    rerank_p = std::max(rerank_p, k);
    long long coarse_t0 = quant_now_us();
    std::vector<int> probe_ids;
    ivf_select_probe_ids(ivf, query, nprobe, probe_ids);
    long long coarse_t1 = quant_now_us();

    std::priority_queue<std::pair<float, uint32_t> > candidates;
    long long lut_us = 0;
    long long scan_us = 0;
    for (size_t pi = 0; pi < probe_ids.size(); ++pi) {
        int cid = probe_ids[pi];
        const std::vector<uint32_t>& list = ivf.lists[cid];
        if (list.empty()) continue;

        const bool has_local_pq =
            ivf.use_pq &&
            cid >= 0 &&
            cid < static_cast<int>(ivf.pq_indices.size()) &&
            !ivf.pq_indices[cid].codes.empty() &&
            ivf.pq_indices[cid].n == list.size();

        if (!has_local_pq) {
            long long scan_t0 = quant_now_us();
            for (size_t li = 0; li < list.size(); ++li) {
                uint32_t id = list[li];
                float dist = ip_distance(base + static_cast<size_t>(id) * ivf.d,
                                         query, ivf.d, kManualNeonUnroll4);
                push_heap_topk(candidates, dist, id, rerank_p);
            }
            scan_us += quant_now_us() - scan_t0;
            continue;
        }

        const PQIndex& pq = ivf.pq_indices[cid];
        long long lut_t0 = quant_now_us();
        std::vector<float> lut(static_cast<size_t>(pq.m) * pq.ks, 0.0f);
        lut_build_into(pq, query, &lut[0]);
        lut_us += quant_now_us() - lut_t0;

        long long scan_t0 = quant_now_us();
        for (size_t li = 0; li < list.size(); ++li) {
            const uint8_t* code = &pq.codes[li * static_cast<size_t>(pq.m)];
            float dot = 0.0f;
            for (int part = 0; part < pq.m; ++part) {
                dot += lut[static_cast<size_t>(part) * pq.ks + code[part]];
            }
            push_heap_topk(candidates, 1.0f - dot, list[li], rerank_p);
        }
        scan_us += quant_now_us() - scan_t0;
    }

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result;
    while (!candidates.empty()) {
        uint32_t id = candidates.top().second;
        candidates.pop();
        float dist = ip_distance(base + static_cast<size_t>(id) * ivf.d,
                                 query, ivf.d, kManualNeonUnroll4);
        push_heap_topk(result, dist, id, k);
    }
    long long rerank_t1 = quant_now_us();

    if (timing) {
        timing->coarse_us = coarse_t1 - coarse_t0;
        timing->lut_us = lut_us;
        timing->scan_us = scan_us;
        timing->rerank_us = rerank_t1 - rerank_t0;
    }
    return result;
}

inline void ivf_pq_query_parallel(const IVFIndex& ivf,
                                  const PQIndex& pq,
                                  const float* base,
                                  const float* query,
                                  const int* gt,
                                  size_t nq,
                                  size_t k,
                                  size_t gt_d,
                                  int nprobe,
                                  size_t rerank_p,
                                  int nthreads,
                                  double& avg_lat,
                                  double& avg_rec,
                                  TimingAvg* avg_timing = NULL) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<float> recs(nq, 0.0f);
    std::vector<QuantTiming> timings(nq);
    std::vector<std::thread> threads(nthreads);

    struct Arg {
        int tid, nt;
        const IVFIndex* ivf;
        const PQIndex* pq;
        const float* base;
        const float* query;
        const int* gt;
        size_t nq, k, gt_d, rerank_p;
        int nprobe;
        std::vector<float>* recs;
        std::vector<QuantTiming>* timings;
    };
    std::vector<Arg> args(nthreads);

    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            QuantTiming tim;
            auto res = ivf_pq_global_search_timed(*a->ivf, *a->pq, a->base,
                                                  a->query + qi * a->pq->d,
                                                  a->k, a->nprobe, a->rerank_p, &tim);
            (*a->recs)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
            (*a->timings)[qi] = tim;
        }
        return NULL;
    };

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; ++t) {
        args[t] = {t, nthreads, &ivf, &pq, base, query, gt, nq, k, gt_d,
                   rerank_p, nprobe, &recs, &timings};
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
}

inline void ivf_pq_local_query_parallel(const IVFIndex& ivf,
                                        const float* base,
                                        const float* query,
                                        const int* gt,
                                        size_t nq,
                                        size_t k,
                                        size_t gt_d,
                                        int nprobe,
                                        size_t rerank_p,
                                        int nthreads,
                                        double& avg_lat,
                                        double& avg_rec,
                                        TimingAvg* avg_timing = NULL) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<float> recs(nq, 0.0f);
    std::vector<QuantTiming> timings(nq);
    std::vector<std::thread> threads(nthreads);

    struct Arg {
        int tid, nt;
        const IVFIndex* ivf;
        const float* base;
        const float* query;
        const int* gt;
        size_t nq, k, gt_d, rerank_p;
        int nprobe;
        std::vector<float>* recs;
        std::vector<QuantTiming>* timings;
    };
    std::vector<Arg> args(nthreads);

    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            QuantTiming tim;
            auto res = ivf_pq_local_search_timed(*a->ivf,
                                                 a->base,
                                                 a->query + qi * a->ivf->d,
                                                 a->k,
                                                 a->nprobe,
                                                 a->rerank_p,
                                                 &tim);
            (*a->recs)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
            (*a->timings)[qi] = tim;
        }
        return NULL;
    };

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; ++t) {
        args[t] = {t, nthreads, &ivf, base, query, gt, nq, k, gt_d,
                   rerank_p, nprobe, &recs, &timings};
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
}
