#pragma once
#include "pthread_common.h"
#include "ann_search.h"
using namespace ann;
using namespace pthread_ann;

// ============================================================
// Flat-SIMD + Pthread: query-parallel & base-split strategies
// ============================================================

// Strategy A: Query-level parallel — each thread handles a range of queries
struct FlatQueryArg {
    int tid, nthreads;
    const float* base; const float* query; const int* gt;
    size_t N, d, gt_d, nq, k;
    SearchMethod method; size_t pf_dist;
    std::vector<double>* latencies;  // output: per-query latency
    std::vector<float>* recalls;     // output: per-query recall
};

static void* flat_query_worker(void* arg) {
    FlatQueryArg* a = (FlatQueryArg*)arg;
    for (size_t qi = a->tid; qi < a->nq; qi += a->nthreads) {
        long long t0 = now_us();
        auto res = flat_search_method(a->base, a->query + qi * a->d, a->N, a->d, a->k,
                                       a->method, a->pf_dist);
        long long t1 = now_us();
        (*a->latencies)[qi] = (t1 - t0) / 1000.0;
        (*a->recalls)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
    }
    return NULL;
}

inline void flat_query_parallel(const float* base, const float* query, const int* gt,
                                 size_t N, size_t d, size_t gt_d, size_t nq, size_t k,
                                 SearchMethod method, size_t pf_dist, int nthreads,
                                 double& avg_latency_ms, double& avg_recall) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<double> latencies(nq, 0);
    std::vector<float> recalls(nq, 0);
    std::vector<FlatQueryArg> args(nthreads);
    std::vector<std::thread> threads(nthreads);
    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; t++) {
        args[t] = {t, nthreads, base, query, gt, N, d, gt_d, nq, k, method, pf_dist, &latencies, &recalls};
        threads[t] = std::thread( flat_query_worker, &args[t]);
    }
    for (int t = 0; t < nthreads; t++) threads[t].join();
    long long wall_t1 = now_us();
    avg_latency_ms = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_recall = mean_float(recalls);
}

// Strategy B: Base-partition parallel — each thread scans a portion of base,
// maintains local top-p heap, then merge across threads per query.
struct FlatBaseSplitArg {
    int tid, nthreads;
    const float* base; const float* query; const int* gt;
    size_t N, d, gt_d, nq, k;
    size_t base_start, base_end;    // portion of base this thread handles
    SearchMethod method; size_t pf_dist; size_t local_p;  // local top-p per thread
    std::vector<std::vector<std::pair<float, uint32_t>>>* local_results; // this thread: [qi][candidates]
};

static void* flat_basesplit_worker(void* arg) {
    FlatBaseSplitArg* a = (FlatBaseSplitArg*)arg;
    for (size_t qi = 0; qi < a->nq; qi++) {
        std::priority_queue<std::pair<float, uint32_t>> heap;
        const float* q = a->query + qi * a->d;
        for (size_t i = a->base_start; i < a->base_end; i++) {
            if (uses_prefetch(a->method) && a->pf_dist > 0 &&
                i + a->pf_dist < a->base_end) {
                ANN_PREFETCH(a->base + (i + a->pf_dist) * a->d);
            }
            float dist = ip_distance(a->base + i * a->d, q, a->d, a->method);
            if (heap.size() < a->local_p) heap.push({dist, (uint32_t)i});
            else if (dist < heap.top().first) { heap.push({dist, (uint32_t)i}); heap.pop(); }
        }
        auto& loc = (*a->local_results)[qi];
        while (!heap.empty()) { loc.push_back(heap.top()); heap.pop(); }
    }
    return NULL;
}

inline void flat_basesplit_parallel(const float* base, const float* query, const int* gt,
                                     size_t N, size_t d, size_t gt_d, size_t nq, size_t k,
                                     SearchMethod method, size_t pf_dist, int nthreads,
                                     size_t local_p, double& avg_latency_ms, double& avg_recall) {
    if (nthreads <= 0) nthreads = 1;
    local_p = std::max(local_p, k);
    size_t chunk = (N + nthreads - 1) / nthreads;

    std::vector<std::vector<std::vector<std::pair<float, uint32_t>>>> local_results(
        nthreads, std::vector<std::vector<std::pair<float, uint32_t>>>(nq));
    std::vector<FlatBaseSplitArg> args(nthreads);
    std::vector<std::thread> threads(nthreads);

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; t++) {
        size_t start = t * chunk, end = std::min(start + chunk, N);
        args[t] = {t, nthreads, base, query, gt, N, d, gt_d, nq, k,
                   start, end, method, pf_dist, local_p, &local_results[t]};
        threads[t] = std::thread( flat_basesplit_worker, &args[t]);
    }
    for (int t = 0; t < nthreads; t++) threads[t].join();

    // Merge + rerank per query
    std::vector<float> recalls;
    for (size_t qi = 0; qi < nq; qi++) {
        // Merge local heaps into one top-k
        std::priority_queue<std::pair<float, uint32_t>> merged;
        for (int t = 0; t < nthreads; ++t) {
            for (auto& p : local_results[t][qi]) {
                if (merged.size() < k) merged.push(p);
                else if (p.first < merged.top().first) { merged.push(p); merged.pop(); }
            }
        }
        recalls.push_back(calc_recall_k(merged, gt, gt_d, qi, k));
    }
    long long wall_t1 = now_us();
    avg_latency_ms = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_recall = mean_float(recalls);
}

// ============ Batch run helper ============
struct FlatBenchResult {
    std::string name; double latency_ms, recall; int nthreads;
    double speedup_vs_scalar;
};

inline FlatBenchResult bench_flat_pthread(const float* base, const float* query, const int* gt,
                                           size_t N, size_t d, size_t gt_d, size_t nq, size_t k,
                                           SearchMethod method, size_t pf_dist, int nthreads,
                                           const std::string& strategy, // "query" or "basesplit"
                                           size_t local_p = 100) {
    FlatBenchResult r;
    r.name = strategy + "-t" + std::to_string(nthreads);
    r.nthreads = nthreads;
    if (strategy == "query") {
        flat_query_parallel(base, query, gt, N, d, gt_d, nq, k, method, pf_dist, nthreads, r.latency_ms, r.recall);
    } else {
        flat_basesplit_parallel(base, query, gt, N, d, gt_d, nq, k, method, pf_dist, nthreads, local_p, r.latency_ms, r.recall);
    }
    return r;
}
