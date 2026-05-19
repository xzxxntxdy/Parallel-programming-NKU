#pragma once

#include "pthread_benchmark.h"
#include "ann_quant.h"

#include <deque>

using namespace ann;
using namespace pthread_ann;

// ============================================================
// PQ-SDC + Pthread and batch pipeline experiments
// ============================================================

template <typename T>
class BoundedQueue {
public:
    explicit BoundedQueue(size_t capacity) : capacity_(std::max<size_t>(1, capacity)) {}

    void push(const T& item) {
        std::unique_lock<std::mutex> lk(mu_);
        not_full_.wait(lk, [&] { return q_.size() < capacity_; });
        q_.push_back(item);
        not_empty_.notify_one();
    }

    T pop() {
        std::unique_lock<std::mutex> lk(mu_);
        not_empty_.wait(lk, [&] { return !q_.empty(); });
        T item = q_.front();
        q_.pop_front();
        not_full_.notify_one();
        return item;
    }

private:
    size_t capacity_;
    std::deque<T> q_;
    std::mutex mu_;
    std::condition_variable not_empty_;
    std::condition_variable not_full_;
};

inline void pq_sdc_scan_select_qcode(const PQIndex& index,
                                     const std::vector<float>& sdc_table,
                                     const std::vector<uint8_t>& qcode,
                                     size_t p,
                                     std::vector<std::pair<float, uint32_t> >& coarse,
                                     QuantTiming* timing) {
    p = std::min(std::max<size_t>(p, 1), index.n);
    long long scan_t0 = quant_now_us();
    coarse.resize(index.n);
    for (size_t i = 0; i < index.n; ++i) {
        const uint8_t* code = &index.codes[i * static_cast<size_t>(index.m)];
        float dot = 0.0f;
        for (int part = 0; part < index.m; ++part) {
            size_t off = static_cast<size_t>(part) * index.ks * index.ks;
            dot += sdc_table[off + static_cast<size_t>(qcode[part]) * index.ks + code[part]];
        }
        coarse[i] = std::make_pair(1.0f - dot, static_cast<uint32_t>(i));
    }
    long long scan_t1 = quant_now_us();
    long long select_t0 = quant_now_us();
    if (p < coarse.size()) {
        std::nth_element(coarse.begin(), coarse.begin() + static_cast<std::ptrdiff_t>(p),
                         coarse.end());
        coarse.resize(p);
    }
    long long select_t1 = quant_now_us();
    if (timing) {
        timing->scan_us = scan_t1 - scan_t0;
        timing->select_us = select_t1 - select_t0;
        timing->coarse_us = timing->scan_us + timing->select_us;
    }
}

inline void pq_sdc_query_parallel(const PQIndex& idx,
                                  const std::vector<float>& sdc_table,
                                  const float* base,
                                  const float* query,
                                  const int* gt,
                                  size_t nq,
                                  size_t k,
                                  size_t p,
                                  size_t gt_d,
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
        const PQIndex* idx;
        const std::vector<float>* table;
        const float* base;
        const float* query;
        const int* gt;
        size_t nq, k, p, gt_d;
        std::vector<float>* recs;
        std::vector<QuantTiming>* timings;
    };
    std::vector<Arg> args(nthreads);

    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            QuantTiming tim;
            auto res = pq_sdc_search_rerank_select_timed(*a->idx, *a->table, a->base,
                                                         a->query + qi * a->idx->d,
                                                         a->p, a->k, &tim);
            (*a->recs)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
            (*a->timings)[qi] = tim;
        }
        return NULL;
    };

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; ++t) {
        args[t] = {t, nthreads, &idx, &sdc_table, base, query, gt, nq, k, p, gt_d,
                   &recs, &timings};
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

inline void pq_sdc_fastscan_query_parallel(const PQIndex& idx,
                                           const PQFastScanIndex& fast,
                                           const std::vector<float>& sdc_table,
                                           const float* base,
                                           const float* query,
                                           const int* gt,
                                           size_t nq,
                                           size_t k,
                                           size_t p,
                                           size_t gt_d,
                                           int nthreads,
                                           double& avg_lat,
                                           double& avg_rec,
                                           TimingAvg* avg_timing = NULL,
                                           double* avg_lut_mae = NULL) {
    if (nthreads <= 0) nthreads = 1;
    std::vector<float> recs(nq, 0.0f);
    std::vector<QuantTiming> timings(nq);
    std::vector<float> maes(nq, 0.0f);
    std::vector<std::thread> threads(nthreads);

    struct Arg {
        int tid, nt;
        const PQIndex* idx;
        const PQFastScanIndex* fast;
        const std::vector<float>* table;
        const float* base;
        const float* query;
        const int* gt;
        size_t nq, k, p, gt_d;
        std::vector<float>* recs;
        std::vector<QuantTiming>* timings;
        std::vector<float>* maes;
    };
    std::vector<Arg> args(nthreads);

    auto worker = [](void* ptr) -> void* {
        Arg* a = static_cast<Arg*>(ptr);
        for (size_t qi = a->tid; qi < a->nq; qi += a->nt) {
            QuantTiming tim; float mae = 0.0f;
            auto res = pq_sdc_fastscan_search_rerank_timed(*a->idx, *a->fast, *a->table,
                                                           a->base, a->query + qi * a->idx->d,
                                                           a->p, a->k, &tim, &mae);
            (*a->recs)[qi] = calc_recall_k(res, a->gt, a->gt_d, qi, a->k);
            (*a->timings)[qi] = tim;
            (*a->maes)[qi] = mae;
        }
        return NULL;
    };

    long long wall_t0 = now_us();
    for (int t = 0; t < nthreads; ++t) {
        args[t] = {t, nthreads, &idx, &fast, &sdc_table, base, query, gt, nq, k, p,
                   gt_d, &recs, &timings, &maes};
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

struct EncodedJob {
    bool stop;
    size_t qi;
    std::vector<uint8_t> qcode;
    EncodedJob() : stop(false), qi(0) {}
};

struct ScannedJob {
    bool stop;
    size_t qi;
    std::vector<std::pair<float, uint32_t> > coarse;
    ScannedJob() : stop(false), qi(0) {}
};

inline void pq_sdc_pipeline(const PQIndex& idx,
                            const std::vector<float>& sdc_table,
                            const float* base,
                            const float* query,
                            const int* gt,
                            size_t nq,
                            size_t k,
                            size_t p,
                            size_t gt_d,
                            int stages,
                            size_t queue_capacity,
                            double& avg_lat,
                            double& avg_rec,
                            TimingAvg* avg_timing = NULL) {
    if (stages <= 1) {
        pq_sdc_query_parallel(idx, sdc_table, base, query, gt, nq, k, p, gt_d,
                              1, avg_lat, avg_rec, avg_timing);
        return;
    }

    std::vector<float> recs(nq, 0.0f);
    TimingAvg sum;
    std::mutex timing_mu;
    long long wall_t0 = now_us();

    if (stages == 2) {
        BoundedQueue<EncodedJob> q(queue_capacity);
        std::thread encoder([&] {
            for (size_t qi = 0; qi < nq; ++qi) {
                EncodedJob job; job.qi = qi;
                long long t0 = quant_now_us();
                pq_encode_query(idx, query + qi * idx.d, job.qcode);
                long long t1 = quant_now_us();
                {
                    std::lock_guard<std::mutex> lk(timing_mu);
                    sum.encode_us += t1 - t0;
                }
                q.push(job);
            }
            EncodedJob stop; stop.stop = true; q.push(stop);
        });
        std::thread scanner([&] {
            for (;;) {
                EncodedJob job = q.pop();
                if (job.stop) break;
                QuantTiming tim;
                std::vector<std::pair<float, uint32_t> > coarse;
                pq_sdc_scan_select_qcode(idx, sdc_table, job.qcode, p, coarse, &tim);
                long long r0 = quant_now_us();
                auto res = rerank_candidate_pairs(coarse, std::min(p, coarse.size()),
                                                  base, query + job.qi * idx.d, idx.d, k);
                long long r1 = quant_now_us();
                tim.rerank_us = r1 - r0;
                recs[job.qi] = calc_recall_k(res, gt, gt_d, job.qi, k);
                std::lock_guard<std::mutex> lk(timing_mu);
                add_timing(sum, tim);
            }
        });
        encoder.join();
        scanner.join();
    } else {
        BoundedQueue<EncodedJob> enc_q(queue_capacity);
        BoundedQueue<ScannedJob> scan_q(queue_capacity);
        std::thread encoder([&] {
            for (size_t qi = 0; qi < nq; ++qi) {
                EncodedJob job; job.qi = qi;
                long long t0 = quant_now_us();
                pq_encode_query(idx, query + qi * idx.d, job.qcode);
                long long t1 = quant_now_us();
                {
                    std::lock_guard<std::mutex> lk(timing_mu);
                    sum.encode_us += t1 - t0;
                }
                enc_q.push(job);
            }
            EncodedJob stop; stop.stop = true; enc_q.push(stop);
        });
        std::thread scanner([&] {
            for (;;) {
                EncodedJob job = enc_q.pop();
                if (job.stop) {
                    ScannedJob stop; stop.stop = true; scan_q.push(stop);
                    break;
                }
                QuantTiming tim;
                ScannedJob out; out.qi = job.qi;
                pq_sdc_scan_select_qcode(idx, sdc_table, job.qcode, p, out.coarse, &tim);
                {
                    std::lock_guard<std::mutex> lk(timing_mu);
                    add_timing(sum, tim);
                }
                scan_q.push(out);
            }
        });
        std::thread reranker([&] {
            for (;;) {
                ScannedJob job = scan_q.pop();
                if (job.stop) break;
                long long t0 = quant_now_us();
                auto res = rerank_candidate_pairs(job.coarse, std::min(p, job.coarse.size()),
                                                  base, query + job.qi * idx.d, idx.d, k);
                long long t1 = quant_now_us();
                recs[job.qi] = calc_recall_k(res, gt, gt_d, job.qi, k);
                std::lock_guard<std::mutex> lk(timing_mu);
                sum.rerank_us += t1 - t0;
            }
        });
        encoder.join();
        scanner.join();
        reranker.join();
    }

    long long wall_t1 = now_us();
    avg_lat = (wall_t1 - wall_t0) / 1000.0 / std::max<size_t>(1, nq);
    avg_rec = mean_float(recs);
    if (avg_timing) {
        *avg_timing = sum;
        scale_timing(*avg_timing, 1.0 / std::max<size_t>(1, nq));
    }
}
