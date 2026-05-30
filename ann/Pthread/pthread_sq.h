#pragma once

#include "pthread_benchmark.h"
#include "ann_quant.h"

using namespace ann;
using namespace pthread_ann;

// ============================================================
// SQ8-SIMD + Pthread: query-parallel p sweep
// ============================================================

inline void sq8_query_parallel(const SQ8Index& idx,
                               const float* base,
                               const float* query,
                               const int* gt,
                               size_t nq,
                               size_t k,
                               size_t p,
                               size_t gt_d,
                               int nthreads,
                               bool use_u8simd,
                               double& avg_lat,
                               double& avg_rec,
                               TimingAvg* avg_timing = NULL) {
    if (nthreads <= 0) nthreads = 1;
    p = std::max(p, k);

    std::vector<float> recs(nq, 0.0f);
    std::vector<QuantTiming> timings(nq);
    std::vector<std::thread> threads(nthreads);

    struct Arg {
        int tid, nt;
        const SQ8Index* idx;
        const float* base;
        const float* query;
        const int* gt;
        size_t nq, k, p, gt_d;
        bool use_u8simd;
        std::vector<float>* recs;
        std::vector<QuantTiming>* timings;
    };
    std::vector<Arg> args(nthreads);

    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            QuantTiming tim;
            std::priority_queue<std::pair<float, uint32_t> > res =
                a->use_u8simd
                    ? sq8_search_rerank_u8simd_timed(*a->idx, a->base,
                                                     a->query + qi * a->idx->d,
                                                     a->p, a->k, &tim)
                    : sq8_search_rerank_timed(*a->idx, a->base,
                                              a->query + qi * a->idx->d,
                                              a->p, a->k, &tim);
            (*a->recs)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
            (*a->timings)[qi] = tim;
        }
        return NULL;
    };

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; ++t) {
        args[t] = {t, nthreads, &idx, base, query, gt, nq, k, p, gt_d,
                   use_u8simd, &recs, &timings};
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
