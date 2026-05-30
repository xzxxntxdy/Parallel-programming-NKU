#pragma once

#include "ann_search.h"
#include "ann_quant.h"
#include "pthread_benchmark.h"
#include "pthread_flat.h"
#include "pthread_ivf.h"
#include "pthread_pq.h"

#include <omp.h>

namespace pthread_ann {

inline SearchMethod openmp_host_default_method() {
#if defined(__aarch64__) || defined(__ARM_NEON) || defined(__ARM_NEON__)
    return kManualNeonUnroll4PrefetchFixedTopK;
#else
    return kManualSse;
#endif
}

inline const char* openmp_host_default_method_name() {
#if defined(__aarch64__) || defined(__ARM_NEON) || defined(__ARM_NEON__)
    return "NEON-PrefetchTopK";
#else
    return "SSE";
#endif
}

inline void openmp_flat_query_parallel(const float* base,
                                       const float* query,
                                       const int* gt,
                                       size_t n,
                                       size_t d,
                                       size_t gt_d,
                                       size_t nq,
                                       size_t k,
                                       SearchMethod method,
                                       size_t pf_dist,
                                       int nthreads,
                                       bool dynamic_schedule,
                                       double& avg_latency_ms,
                                       double& avg_recall) {
    if (nthreads <= 0) nthreads = 1;
    const int qn = static_cast<int>(nq);
    std::vector<float> recalls(nq, 0.0f);

    long long wall_t0 = now_us();
    if (dynamic_schedule) {
#pragma omp parallel for schedule(dynamic, 8) num_threads(nthreads)
        for (int qi = 0; qi < qn; ++qi) {
            std::priority_queue<std::pair<float, uint32_t> > res =
                flat_search_method(base, query + static_cast<size_t>(qi) * d,
                                   n, d, k, method, pf_dist);
            recalls[qi] = calc_recall_k(res, gt, gt_d, qi, k);
        }
    } else {
#pragma omp parallel for schedule(static) num_threads(nthreads)
        for (int qi = 0; qi < qn; ++qi) {
            std::priority_queue<std::pair<float, uint32_t> > res =
                flat_search_method(base, query + static_cast<size_t>(qi) * d,
                                   n, d, k, method, pf_dist);
            recalls[qi] = calc_recall_k(res, gt, gt_d, qi, k);
        }
    }
    long long wall_t1 = now_us();
    avg_latency_ms = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_recall = mean_float(recalls);
}

inline void openmp_flat_basesplit_parallel(const float* base,
                                           const float* query,
                                           const int* gt,
                                           size_t n,
                                           size_t d,
                                           size_t gt_d,
                                           size_t nq,
                                           size_t k,
                                           SearchMethod method,
                                           size_t pf_dist,
                                           int nthreads,
                                           size_t local_p,
                                           bool dynamic_schedule,
                                           double& avg_latency_ms,
                                           double& avg_recall) {
    if (nthreads <= 0) nthreads = 1;
    local_p = std::max(local_p, k);
    const int ni = static_cast<int>(n);
    std::vector<float> recalls(nq, 0.0f);

    long long wall_t0 = now_us();
    for (size_t qi = 0; qi < nq; ++qi) {
        std::vector<std::priority_queue<std::pair<float, uint32_t> > > local(nthreads);
        const float* q = query + qi * d;

        if (dynamic_schedule) {
#pragma omp parallel num_threads(nthreads)
            {
                int tid = omp_get_thread_num();
                std::priority_queue<std::pair<float, uint32_t> >& heap = local[tid];
#pragma omp for schedule(dynamic, 1024)
                for (int ii = 0; ii < ni; ++ii) {
                    size_t i = static_cast<size_t>(ii);
                    if (uses_prefetch(method) && pf_dist > 0 && i + pf_dist < n) {
                        ANN_PREFETCH(base + (i + pf_dist) * d);
                    }
                    float dist = ip_distance(base + i * d, q, d, method);
                    push_heap_topk(heap, dist, static_cast<uint32_t>(i), local_p);
                }
            }
        } else {
#pragma omp parallel num_threads(nthreads)
            {
                int tid = omp_get_thread_num();
                std::priority_queue<std::pair<float, uint32_t> >& heap = local[tid];
#pragma omp for schedule(static)
                for (int ii = 0; ii < ni; ++ii) {
                    size_t i = static_cast<size_t>(ii);
                    if (uses_prefetch(method) && pf_dist > 0 && i + pf_dist < n) {
                        ANN_PREFETCH(base + (i + pf_dist) * d);
                    }
                    float dist = ip_distance(base + i * d, q, d, method);
                    push_heap_topk(heap, dist, static_cast<uint32_t>(i), local_p);
                }
            }
        }

        std::priority_queue<std::pair<float, uint32_t> > merged;
        for (int t = 0; t < nthreads; ++t) {
            while (!local[t].empty()) {
                std::pair<float, uint32_t> pr = local[t].top();
                local[t].pop();
                push_heap_topk(merged, pr.first, pr.second, k);
            }
        }
        recalls[qi] = calc_recall_k(merged, gt, gt_d, qi, k);
    }
    long long wall_t1 = now_us();
    avg_latency_ms = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_recall = mean_float(recalls);
}

inline void openmp_pq_adc_query_parallel(const PQIndex& idx,
                                         const float* base,
                                         const float* query,
                                         const int* gt,
                                         size_t nq,
                                         size_t k,
                                         size_t p,
                                         size_t gt_d,
                                         int nthreads,
                                         bool dynamic_schedule,
                                         double& avg_latency_ms,
                                         double& avg_recall,
                                         TimingAvg* avg_timing = NULL) {
    if (nthreads <= 0) nthreads = 1;
    p = std::max(p, k);
    const int qn = static_cast<int>(nq);
    std::vector<float> recalls(nq, 0.0f);
    std::vector<QuantTiming> timings(nq);

    long long wall_t0 = now_us();
    if (dynamic_schedule) {
#pragma omp parallel for schedule(dynamic, 8) num_threads(nthreads)
        for (int qi = 0; qi < qn; ++qi) {
            QuantTiming tim;
            std::priority_queue<std::pair<float, uint32_t> > res =
                pq_adc_search_rerank_select_timed(idx, base,
                    query + static_cast<size_t>(qi) * idx.d, p, k, &tim);
            recalls[qi] = calc_recall_k(res, gt, gt_d, qi, k);
            timings[qi] = tim;
        }
    } else {
#pragma omp parallel for schedule(static) num_threads(nthreads)
        for (int qi = 0; qi < qn; ++qi) {
            QuantTiming tim;
            std::priority_queue<std::pair<float, uint32_t> > res =
                pq_adc_search_rerank_select_timed(idx, base,
                    query + static_cast<size_t>(qi) * idx.d, p, k, &tim);
            recalls[qi] = calc_recall_k(res, gt, gt_d, qi, k);
            timings[qi] = tim;
        }
    }
    long long wall_t1 = now_us();
    avg_latency_ms = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_recall = mean_float(recalls);
    if (avg_timing) {
        *avg_timing = TimingAvg();
        for (size_t i = 0; i < timings.size(); ++i) add_timing(*avg_timing, timings[i]);
        scale_timing(*avg_timing, 1.0 / std::max<size_t>(1, timings.size()));
    }
}

inline void openmp_ivf_query_parallel(const IVFIndex& idx,
                                      const float* base,
                                      const float* query,
                                      const int* gt,
                                      size_t nq,
                                      size_t k,
                                      size_t gt_d,
                                      int nprobe,
                                      int nthreads,
                                      bool dynamic_schedule,
                                      double& avg_latency_ms,
                                      double& avg_recall) {
    if (nthreads <= 0) nthreads = 1;
    const int qn = static_cast<int>(nq);
    std::vector<float> recalls(nq, 0.0f);

    long long wall_t0 = now_us();
    if (dynamic_schedule) {
#pragma omp parallel for schedule(dynamic, 8) num_threads(nthreads)
        for (int qi = 0; qi < qn; ++qi) {
            std::priority_queue<std::pair<float, uint32_t> > res =
                ivf_search(idx, base, query + static_cast<size_t>(qi) * idx.d,
                           k, nprobe);
            recalls[qi] = calc_recall_k(res, gt, gt_d, qi, k);
        }
    } else {
#pragma omp parallel for schedule(static) num_threads(nthreads)
        for (int qi = 0; qi < qn; ++qi) {
            std::priority_queue<std::pair<float, uint32_t> > res =
                ivf_search(idx, base, query + static_cast<size_t>(qi) * idx.d,
                           k, nprobe);
            recalls[qi] = calc_recall_k(res, gt, gt_d, qi, k);
        }
    }
    long long wall_t1 = now_us();
    avg_latency_ms = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_recall = mean_float(recalls);
}

}  // namespace pthread_ann
