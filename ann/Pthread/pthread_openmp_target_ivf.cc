/*
 * OpenMP target-device ANN benchmark.
 *
 * This benchmark is intentionally separate from the submission CPU path. It
 * evaluates an IVF candidate-pruning path and selects the minimum latency row
 * subject to recall@100 >= target_recall. Exact flat scan is not used here
 * because recall=1.0 does not answer the trade-off goal.
 */
#include "pthread_common.h"

#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <queue>
#include <sstream>
#include <string>
#include <vector>

#if defined(_OPENMP) && !(defined(_MSC_VER) && !defined(__INTEL_LLVM_COMPILER))
#include <omp.h>
#define ANN_HAS_OPENMP_TARGET 1
#else
#define ANN_HAS_OPENMP_TARGET 0
#endif

using namespace pthread_ann;

namespace {

const size_t kRecallAt = 100;

struct TimingAvg {
    double encode_us;
    double lut_us;
    double scan_us;
    double select_us;
    double rerank_us;

    TimingAvg()
        : encode_us(0.0), lut_us(0.0), scan_us(0.0),
          select_us(0.0), rerank_us(0.0) {}
};

struct TargetIVFIndex {
    size_t n;
    size_t d;
    int nlist;
    std::vector<float> centroids;
    std::vector<std::vector<uint32_t> > lists;

    TargetIVFIndex() : n(0), d(0), nlist(0) {}
};

struct BestCandidate {
    bool valid;
    std::string experiment;
    std::string method;
    int nthreads;
    std::string param1;
    int param2;
    double latency_ms;
    double recall;
    double speedup;
    double index_mb;
    double build_sec;
    std::string notes;

    BestCandidate()
        : valid(false), nthreads(0), param2(0),
          latency_ms(std::numeric_limits<double>::max()), recall(0.0),
          speedup(0.0), index_mb(0.0), build_sec(0.0) {}
};

class CsvWriter {
public:
    CsvWriter(const std::string& path, double target_recall)
        : out_(path.c_str()), target_recall_(target_recall) {
        out_ << "experiment,method,nthreads,param1,param2,latency_ms,recall@100,speedup,"
             << "index_mb,build_sec,encode_us,lut_us,scan_us,select_us,rerank_us,notes\n";
    }

    bool good() const { return out_.good(); }

    void row(const std::string& experiment,
             const std::string& method,
             int nthreads,
             const std::string& param1,
             int param2,
             double latency_ms,
             double recall,
             double speedup,
             double index_mb,
             double build_sec,
             const TimingAvg& timing,
             const std::string& notes) {
        observe(experiment, method, nthreads, param1, param2, latency_ms,
                recall, speedup, index_mb, build_sec, notes);
        out_ << experiment << "," << method << "," << nthreads << ","
             << param1 << "," << param2 << ","
             << std::fixed << std::setprecision(6)
             << latency_ms << "," << recall << "," << speedup << ","
             << index_mb << "," << build_sec << ","
             << timing.encode_us << "," << timing.lut_us << ","
             << timing.scan_us << "," << timing.select_us << ","
             << timing.rerank_us << "," << notes << "\n";
    }

    void write_best(const std::string& path) const {
        std::ofstream out(path.c_str());
        out << "criterion,experiment,method,nthreads,param1,param2,latency_ms,recall@100,"
            << "speedup,index_mb,build_sec,notes\n";
        if (!best_.valid) return;
        out << "min latency with recall@100>=" << target_recall_ << ","
            << best_.experiment << "," << best_.method << "," << best_.nthreads << ","
            << best_.param1 << "," << best_.param2 << ","
            << std::fixed << std::setprecision(6)
            << best_.latency_ms << "," << best_.recall << "," << best_.speedup << ","
            << best_.index_mb << "," << best_.build_sec << "," << best_.notes << "\n";
    }

    std::string best_summary() const {
        if (!best_.valid) return "no candidate satisfies recall constraint";
        std::ostringstream oss;
        oss << best_.experiment << "/" << best_.method
            << " " << best_.param1 << "=" << best_.param2
            << " latency_ms=" << std::fixed << std::setprecision(6) << best_.latency_ms
            << " recall@100=" << best_.recall;
        return oss.str();
    }

private:
    void observe(const std::string& experiment,
                 const std::string& method,
                 int nthreads,
                 const std::string& param1,
                 int param2,
                 double latency_ms,
                 double recall,
                 double speedup,
                 double index_mb,
                 double build_sec,
                 const std::string& notes) {
        if (latency_ms <= 0.0 || recall < target_recall_) return;
        if (best_.valid && latency_ms >= best_.latency_ms) return;
        best_.valid = true;
        best_.experiment = experiment;
        best_.method = method;
        best_.nthreads = nthreads;
        best_.param1 = param1;
        best_.param2 = param2;
        best_.latency_ms = latency_ms;
        best_.recall = recall;
        best_.speedup = speedup;
        best_.index_mb = index_mb;
        best_.build_sec = build_sec;
        best_.notes = notes;
    }

    std::ofstream out_;
    double target_recall_;
    BestCandidate best_;
};

struct Config {
    std::string data_dir;
    std::string csv_path;
    std::string best_csv;
    std::vector<int> nlists;
    std::vector<int> nprobes;
    std::vector<int> candidate_caps;
    size_t nq;
    int batch;
    int kmeans_iters;
    double baseline_ms;
    double target_recall;

    Config()
        : data_dir("../anndata"),
          csv_path("files/results/pthread_openmp_target_device_results.csv"),
          best_csv("files/results/pthread_openmp_target_device_best.csv"),
          nq(1000),
          batch(1000),
          kmeans_iters(12),
          baseline_ms(0.0),
          target_recall(0.95) {
        nlists.push_back(2048);
        int probes[] = {48, 64, 72, 80, 88, 96, 112};
        nprobes.assign(probes, probes + sizeof(probes) / sizeof(probes[0]));
        int caps[] = {2048, 3072, 4096, 6144};
        candidate_caps.assign(caps, caps + sizeof(caps) / sizeof(caps[0]));
    }
};

std::vector<int> parse_int_list(const std::string& s) {
    std::vector<int> out;
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, ',')) {
        int v = std::atoi(item.c_str());
        if (v > 0) out.push_back(v);
    }
    return out;
}

float dot_product(const float* a, const float* b, size_t d) {
    float s0 = 0.0f;
    float s1 = 0.0f;
    float s2 = 0.0f;
    float s3 = 0.0f;
    size_t j = 0;
    for (; j + 4 <= d; j += 4) {
        s0 += a[j] * b[j];
        s1 += a[j + 1] * b[j + 1];
        s2 += a[j + 2] * b[j + 2];
        s3 += a[j + 3] * b[j + 3];
    }
    float sum = (s0 + s1) + (s2 + s3);
    for (; j < d; ++j) sum += a[j] * b[j];
    return sum;
}

void build_target_ivf_index(const float* base,
                            size_t n,
                            size_t d,
                            int nlist,
                            int kmeans_iters,
                            TargetIVFIndex& idx) {
    idx.n = n;
    idx.d = d;
    idx.nlist = nlist;
    idx.centroids.assign(static_cast<size_t>(nlist) * d, 0.0f);
    idx.lists.assign(nlist, std::vector<uint32_t>());

    for (int c = 0; c < nlist; ++c) {
        size_t si = static_cast<size_t>(c) * n / nlist;
        std::memcpy(&idx.centroids[static_cast<size_t>(c) * d],
                    base + si * d, d * sizeof(float));
    }

    std::vector<int> assign(n, 0);
    std::vector<int> counts(nlist, 0);
    std::vector<double> sums(static_cast<size_t>(nlist) * d, 0.0);
    for (int iter = 0; iter < kmeans_iters; ++iter) {
        std::fill(counts.begin(), counts.end(), 0);
        std::fill(sums.begin(), sums.end(), 0.0);
        for (size_t i = 0; i < n; ++i) {
            const float* x = base + i * d;
            int best = 0;
            float best_dist = std::numeric_limits<float>::max();
            for (int c = 0; c < nlist; ++c) {
                const float* ct = &idx.centroids[static_cast<size_t>(c) * d];
                float dist = 0.0f;
                for (size_t j = 0; j < d; ++j) {
                    float diff = x[j] - ct[j];
                    dist += diff * diff;
                }
                if (dist < best_dist) {
                    best_dist = dist;
                    best = c;
                }
            }
            assign[i] = best;
            ++counts[best];
            double* s = &sums[static_cast<size_t>(best) * d];
            for (size_t j = 0; j < d; ++j) s[j] += x[j];
        }
        for (int c = 0; c < nlist; ++c) {
            if (counts[c] == 0) continue;
            float inv = 1.0f / static_cast<float>(counts[c]);
            for (size_t j = 0; j < d; ++j) {
                idx.centroids[static_cast<size_t>(c) * d + j] =
                    static_cast<float>(sums[static_cast<size_t>(c) * d + j]) * inv;
            }
        }
    }

    for (size_t i = 0; i < n; ++i) idx.lists[assign[i]].push_back(static_cast<uint32_t>(i));
}

Config parse_args(int argc, char** argv) {
    Config cfg;
    for (int i = 1; i < argc; ++i) {
        std::string a(argv[i]);
        if (a == "--data" && i + 1 < argc) cfg.data_dir = argv[++i];
        else if (a == "--csv" && i + 1 < argc) cfg.csv_path = argv[++i];
        else if (a == "--best-csv" && i + 1 < argc) cfg.best_csv = argv[++i];
        else if (a == "--nq" && i + 1 < argc) cfg.nq = static_cast<size_t>(std::strtoull(argv[++i], NULL, 10));
        else if (a == "--batch" && i + 1 < argc) cfg.batch = std::atoi(argv[++i]);
        else if (a == "--iters" && i + 1 < argc) cfg.kmeans_iters = std::atoi(argv[++i]);
        else if (a == "--baseline-ms" && i + 1 < argc) cfg.baseline_ms = std::atof(argv[++i]);
        else if (a == "--target-recall" && i + 1 < argc) cfg.target_recall = std::atof(argv[++i]);
        else if (a == "--nlist-list" && i + 1 < argc) cfg.nlists = parse_int_list(argv[++i]);
        else if (a == "--nprobe-list" && i + 1 < argc) cfg.nprobes = parse_int_list(argv[++i]);
        else if (a == "--candidate-cap-list" && i + 1 < argc) cfg.candidate_caps = parse_int_list(argv[++i]);
    }
    if (cfg.nlists.empty()) cfg.nlists.push_back(2048);
    if (cfg.nprobes.empty()) cfg.nprobes.push_back(80);
    if (cfg.candidate_caps.empty()) cfg.candidate_caps.push_back(4096);
    if (cfg.nq == 0) cfg.nq = 1;
    if (cfg.batch <= 0) cfg.batch = 1;
    if (cfg.kmeans_iters <= 0) cfg.kmeans_iters = 8;
    if (cfg.target_recall <= 0.0 || cfg.target_recall > 1.0) cfg.target_recall = 0.95;
    return cfg;
}

void push_topk(std::priority_queue<std::pair<float, uint32_t> >& heap,
               float distance,
               uint32_t id,
               size_t k) {
    if (heap.size() < k) {
        heap.push(std::make_pair(distance, id));
    } else if (distance < heap.top().first) {
        heap.push(std::make_pair(distance, id));
        heap.pop();
    }
}

int max_in_list(const std::vector<int>& values) {
    int m = 0;
    for (size_t i = 0; i < values.size(); ++i) m = std::max(m, values[i]);
    return m;
}

void precompute_probes(const TargetIVFIndex& ivf,
                       const float* queries,
                       size_t nq,
                       int max_probe,
                       std::vector<int>& probes) {
    const int np = std::min(max_probe, ivf.nlist);
    probes.assign(nq * static_cast<size_t>(np), 0);
    for (size_t qi = 0; qi < nq; ++qi) {
        std::vector<std::pair<float, int> > coarse(ivf.nlist);
        const float* q = queries + qi * ivf.d;
        for (int c = 0; c < ivf.nlist; ++c) {
            const float* ct = &ivf.centroids[static_cast<size_t>(c) * ivf.d];
            float dot = dot_product(ct, q, ivf.d);
            coarse[c] = std::make_pair(1.0f - dot, c);
        }
        if (np < ivf.nlist) {
            std::nth_element(coarse.begin(), coarse.begin() + np, coarse.end());
        } else {
            std::sort(coarse.begin(), coarse.end());
        }
        std::sort(coarse.begin(), coarse.begin() + np);
        for (int p = 0; p < np; ++p) probes[qi * static_cast<size_t>(np) + p] = coarse[p].second;
    }
}

void fill_candidates(const TargetIVFIndex& ivf,
                     const std::vector<int>& probes,
                     int max_probe,
                     int nprobe,
                     int candidate_cap,
                     size_t q_begin,
                     size_t q_count,
                     std::vector<int>& candidate_ids,
                     std::vector<int>& candidate_counts,
                     double& avg_candidates) {
    candidate_ids.assign(q_count * static_cast<size_t>(candidate_cap), -1);
    candidate_counts.assign(q_count, 0);
    long long total_candidates = 0;
    for (size_t bi = 0; bi < q_count; ++bi) {
        size_t qi = q_begin + bi;
        int count = 0;
        for (int p = 0; p < nprobe && p < max_probe && count < candidate_cap; ++p) {
            int cid = probes[qi * static_cast<size_t>(max_probe) + p];
            const std::vector<uint32_t>& list = ivf.lists[cid];
            for (size_t li = 0; li < list.size() && count < candidate_cap; ++li) {
                candidate_ids[bi * static_cast<size_t>(candidate_cap) + count] =
                    static_cast<int>(list[li]);
                ++count;
            }
        }
        candidate_counts[bi] = count;
        total_candidates += count;
    }
    avg_candidates = q_count ? static_cast<double>(total_candidates) / q_count : 0.0;
}

struct EvalResult {
    double latency_ms;
    double recall;
    double avg_candidates;
    TimingAvg timing;
    int target_initial_device;

    EvalResult()
        : latency_ms(0.0), recall(0.0), avg_candidates(0.0),
          target_initial_device(1) {}
};

EvalResult eval_ivf_target(const TargetIVFIndex& ivf,
                           const float* base,
                           const float* queries,
                           const int* gt,
                           size_t nq,
                           size_t k,
                           size_t gt_d,
                           const std::vector<int>& probes,
                           int max_probe,
                           int nprobe,
                           int candidate_cap,
                           int batch,
                           double coarse_us_per_query) {
    EvalResult result;
    const size_t base_total = ivf.n * ivf.d;
    const float* base_ptr = base;
    double recall_sum = 0.0;
    double fill_us_sum = 0.0;
    double scan_us_sum = 0.0;
    double select_us_sum = 0.0;
    double candidate_sum = 0.0;

#if ANN_HAS_OPENMP_TARGET
    int target_initial_device = 1;
#pragma omp target map(from: target_initial_device)
    {
        target_initial_device = omp_is_initial_device() ? 1 : 0;
    }
    result.target_initial_device = target_initial_device;
    if (target_initial_device != 0) {
        std::cerr << "FATAL: OpenMP target region did not execute on an accelerator device\n";
        return result;
    }
#else
    std::cerr << "FATAL: OpenMP target support is not enabled\n";
    return result;
#endif

    long long wall_t0 = now_us();
#if ANN_HAS_OPENMP_TARGET
#pragma omp target data map(to: base_ptr[0:base_total])
#endif
    {
        for (size_t q_begin = 0; q_begin < nq; q_begin += static_cast<size_t>(batch)) {
            size_t q_count = std::min(static_cast<size_t>(batch), nq - q_begin);
            std::vector<int> candidate_ids;
            std::vector<int> candidate_counts;
            double batch_avg_candidates = 0.0;

            long long fill_t0 = now_us();
            fill_candidates(ivf, probes, max_probe, nprobe, candidate_cap,
                            q_begin, q_count, candidate_ids, candidate_counts,
                            batch_avg_candidates);
            fill_us_sum += static_cast<double>(now_us() - fill_t0);
            candidate_sum += batch_avg_candidates * q_count;

            std::vector<float> distances(q_count * static_cast<size_t>(candidate_cap),
                                         std::numeric_limits<float>::infinity());
            const float* query_ptr = queries + q_begin * ivf.d;
            const int* cand_ptr = candidate_ids.data();
            const int* count_ptr = candidate_counts.data();
            float* dist_ptr = distances.data();
            const long long total = static_cast<long long>(q_count) * candidate_cap;
            const int cap = candidate_cap;
            const size_t dim = ivf.d;

            long long scan_t0 = now_us();
#if ANN_HAS_OPENMP_TARGET
#pragma omp target teams distribute parallel for map(to: query_ptr[0:q_count * dim], cand_ptr[0:q_count * static_cast<size_t>(cap)], count_ptr[0:q_count]) map(from: dist_ptr[0:q_count * static_cast<size_t>(cap)])
#endif
            for (long long idx = 0; idx < total; ++idx) {
                const long long local_q = idx / cap;
                const int j = static_cast<int>(idx - local_q * cap);
                if (j >= count_ptr[local_q]) {
                    dist_ptr[idx] = 3.4e38f;
                    continue;
                }
                const int id = cand_ptr[idx];
                const float* b = base_ptr + static_cast<size_t>(id) * dim;
                const float* q = query_ptr + static_cast<size_t>(local_q) * dim;
                float dot = 0.0f;
                for (size_t d = 0; d < dim; ++d) dot += b[d] * q[d];
                dist_ptr[idx] = 1.0f - dot;
            }
            scan_us_sum += static_cast<double>(now_us() - scan_t0);

            long long select_t0 = now_us();
            for (size_t bi = 0; bi < q_count; ++bi) {
                std::priority_queue<std::pair<float, uint32_t> > heap;
                const int count = candidate_counts[bi];
                const size_t offset = bi * static_cast<size_t>(candidate_cap);
                for (int j = 0; j < count; ++j) {
                    push_topk(heap, distances[offset + j],
                              static_cast<uint32_t>(candidate_ids[offset + j]), k);
                }
                recall_sum += calc_recall_k(heap, gt, gt_d, q_begin + bi, k);
            }
            select_us_sum += static_cast<double>(now_us() - select_t0);
        }
    }
    double wall_us = static_cast<double>(now_us() - wall_t0);
    double total_us = wall_us + coarse_us_per_query * static_cast<double>(nq);
    result.latency_ms = total_us / 1000.0 / static_cast<double>(nq);
    result.recall = recall_sum / static_cast<double>(nq);
    result.avg_candidates = candidate_sum / static_cast<double>(nq);
    result.timing.encode_us = coarse_us_per_query;
    result.timing.lut_us = fill_us_sum / static_cast<double>(nq);
    result.timing.scan_us = scan_us_sum / static_cast<double>(nq);
    result.timing.select_us = select_us_sum / static_cast<double>(nq);
    return result;
}

} // namespace

int main(int argc, char** argv) {
    Config cfg = parse_args(argc, argv);
    ensure_dir("files");
    ensure_dir("files/results");

    size_t base_n = 0, base_d = 0, query_n = 0, query_d = 0, gt_n = 0, gt_d = 0;
    float* base = load_data<float>(join_path(cfg.data_dir, "DEEP100K.base.100k.fbin"), base_n, base_d);
    float* query = load_data<float>(join_path(cfg.data_dir, "DEEP100K.query.fbin"), query_n, query_d);
    int* gt = load_data<int>(join_path(cfg.data_dir, "DEEP100K.gt.query.100k.top100.bin"), gt_n, gt_d);
    if (base_d != query_d || gt_d < kRecallAt) {
        std::cerr << "FATAL: incompatible data dimensions\n";
        delete[] base;
        delete[] query;
        delete[] gt;
        return 2;
    }

#if ANN_HAS_OPENMP_TARGET
    int devices = omp_get_num_devices();
    if (devices <= 0) {
        std::cerr << "FATAL: no OpenMP target device is visible\n";
        delete[] base;
        delete[] query;
        delete[] gt;
        return 3;
    }
#else
    int devices = -1;
    std::cerr << "FATAL: this compiler does not enable OpenMP target support\n";
    delete[] base;
    delete[] query;
    delete[] gt;
    return 3;
#endif

    const size_t nq = std::min(cfg.nq, std::min(query_n, gt_n));
    CsvWriter writer(cfg.csv_path, cfg.target_recall);
    if (!writer.good()) {
        std::cerr << "FATAL: cannot open " << cfg.csv_path << "\n";
        delete[] base;
        delete[] query;
        delete[] gt;
        return 4;
    }

    std::cout << "OpenMP target IVF benchmark: nq=" << nq
              << " devices=" << devices
              << " target_recall=" << cfg.target_recall << "\n";

    for (size_t ni = 0; ni < cfg.nlists.size(); ++ni) {
        TargetIVFIndex ivf;
        long long build_t0 = now_us();
        build_target_ivf_index(base, base_n, base_d, cfg.nlists[ni], cfg.kmeans_iters, ivf);
        double build_sec = static_cast<double>(now_us() - build_t0) / 1000000.0;

        int max_probe = std::min(max_in_list(cfg.nprobes), ivf.nlist);
        std::vector<int> probes;
        long long coarse_t0 = now_us();
        precompute_probes(ivf, query, nq, max_probe, probes);
        double coarse_us_per_query =
            static_cast<double>(now_us() - coarse_t0) / static_cast<double>(nq);

        for (size_t pi = 0; pi < cfg.nprobes.size(); ++pi) {
            int nprobe = std::min(cfg.nprobes[pi], ivf.nlist);
            for (size_t ci = 0; ci < cfg.candidate_caps.size(); ++ci) {
                int cap = std::max(static_cast<int>(kRecallAt), cfg.candidate_caps[ci]);
                EvalResult r = eval_ivf_target(ivf, base, query, gt, nq, kRecallAt,
                                               gt_d, probes, max_probe, nprobe,
                                               cap, cfg.batch, coarse_us_per_query);
                if (r.target_initial_device != 0) {
                    delete[] base;
                    delete[] query;
                    delete[] gt;
                    return 5;
                }
                double speedup = cfg.baseline_ms > 0.0 ? cfg.baseline_ms / r.latency_ms : 0.0;
                std::ostringstream method;
                method << "LevelZero-IVF-nl" << cfg.nlists[ni] << "-cap" << cap;
                std::ostringstream notes;
                notes << "openmp_target_accelerator_device;target_initial_device=0"
                      << ";batch=" << cfg.batch
                      << ";avg_candidates=" << static_cast<int>(r.avg_candidates + 0.5)
                      << ";coarse_us_in_encode;candidate_fill_us_in_lut";
                writer.row("OpenMP-Target-IVF", method.str(), 0, "nprobe", nprobe,
                           r.latency_ms, r.recall, speedup, 0.0, build_sec,
                           r.timing, notes.str());
                std::cout << method.str() << " nprobe=" << nprobe
                          << " latency=" << r.latency_ms
                          << " recall=" << r.recall
                          << " avg_candidates=" << r.avg_candidates << "\n";
            }
        }
    }

    writer.write_best(cfg.best_csv);
    std::cout << "OpenMP target best: " << writer.best_summary() << "\n";
    std::cout << "Results saved to " << cfg.csv_path << "\n";

    delete[] base;
    delete[] query;
    delete[] gt;
    return 0;
}
