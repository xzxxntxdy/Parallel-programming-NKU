/* Host-side OpenMP ANN benchmark.

   This file covers the basic OpenMP CPU requirement separately from the
   accelerator-only OpenMP target experiment.  It intentionally writes isolated
   CSV files so that the Pthread/std::thread results are not overwritten.
*/

#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

#include "ann_search.h"
#include "ann_quant.h"
#include "pthread_benchmark.h"
#include "pthread_common.h"
#include "pthread_flat.h"
#include "pthread_ivf.h"
#include "pthread_openmp_host.h"
#include "pthread_pq.h"

using namespace ann;
using namespace pthread_ann;

namespace {

const size_t kRecallAt = 100;

std::vector<int> thread_values(bool reduced) {
    if (reduced) {
        int arr[] = {1, 2, 4, 8};
        return std::vector<int>(arr, arr + 4);
    }
    int arr[] = {1, 2, 4, 8, 16, 32};
    return std::vector<int>(arr, arr + 6);
}

std::string schedule_name(bool dynamic_schedule) {
    return dynamic_schedule ? "dynamic" : "static";
}

std::string method_name_with_schedule(const std::string& base, bool dynamic_schedule) {
    return base + "-" + schedule_name(dynamic_schedule);
}

void write_openmp_host_best(const ResultWriter& writer) {
    writer.write_best("files/results/pthread_openmp_cpu_best.csv");
}

int run_openmp_host(const BenchmarkConfig& cfg, const BenchmarkData& data) {
    ensure_dir("files");
    ensure_dir("files/results");

    ResultWriter writer("files/results/pthread_openmp_cpu_results.csv", cfg.target_recall);
    if (!writer.good()) {
        std::cerr << "FATAL: cannot open files/results/pthread_openmp_cpu_results.csv\n";
        return 2;
    }

    const size_t nq = std::min(capped_queries(cfg, data), data.gt_n);
    const std::vector<int> threads = thread_values(cfg.smoke || cfg.arm_quick);
    const SearchMethod simd_method = openmp_host_default_method();
    const size_t prefetch = uses_prefetch(simd_method) ? 16 : 0;

    double base_lat = 0.0;
    double base_rec = 0.0;
    flat_query_parallel(data.base, data.query, data.gt, data.base_n, data.dim,
                        data.gt_dim, nq, kRecallAt, kScalarNoVec, 0, 1,
                        base_lat, base_rec);
    writer.row("OpenMP-CPU-Baseline", "FlatScalar-Pthread1T", 1, "method", 0,
               base_lat, base_rec, 1.0, 0.0, 0.0, NULL,
               "baseline_for_speedup_only");

    std::cout << "=== OpenMP host CPU ANN sweep ===\n";
    std::cout << "Queries: " << nq << "\n";
    std::cout << "Baseline scalar latency: " << base_lat << " ms/query\n";
    std::cout << "SIMD kernel: " << openmp_host_default_method_name() << "\n";

    bool schedules[] = {false, true};
    for (size_t si = 0; si < sizeof(schedules) / sizeof(schedules[0]); ++si) {
        bool dynamic_schedule = schedules[si];
        for (size_t ti = 0; ti < threads.size(); ++ti) {
            double lat = 0.0;
            double rec = 0.0;
            openmp_flat_query_parallel(data.base, data.query, data.gt,
                                       data.base_n, data.dim, data.gt_dim,
                                       nq, kRecallAt, simd_method, prefetch,
                                       threads[ti], dynamic_schedule, lat, rec);
            writer.row("OpenMP-CPU-Flat", method_name_with_schedule("Query", dynamic_schedule),
                       threads[ti], "schedule", dynamic_schedule ? 1 : 0,
                       lat, rec, base_lat / lat, 0.0, 0.0, NULL,
                       std::string("host_openmp_query_parallel; simd=") +
                           openmp_host_default_method_name());
        }
    }

    int local_p_values[] = {100, 500};
    int base_split_thread_values[] = {1, 8, 32};
    for (size_t pi = 0; pi < sizeof(local_p_values) / sizeof(local_p_values[0]); ++pi) {
        for (size_t si = 0; si < sizeof(schedules) / sizeof(schedules[0]); ++si) {
            bool dynamic_schedule = schedules[si];
            for (size_t ti = 0; ti < sizeof(base_split_thread_values) / sizeof(base_split_thread_values[0]); ++ti) {
                int nt = base_split_thread_values[ti];
                if ((cfg.smoke || cfg.arm_quick) && nt > 8) continue;
                double lat = 0.0;
                double rec = 0.0;
                openmp_flat_basesplit_parallel(data.base, data.query, data.gt,
                                               data.base_n, data.dim, data.gt_dim,
                                               nq, kRecallAt, simd_method, prefetch,
                                               nt, local_p_values[pi],
                                               dynamic_schedule, lat, rec);
                writer.row("OpenMP-CPU-FlatBaseSplit",
                           method_name_with_schedule("BaseSplit", dynamic_schedule),
                           nt, "local_p", local_p_values[pi],
                           lat, rec, base_lat / lat, 0.0, 0.0, NULL,
                           "host_openmp_base_partition; topk_reduce");
            }
        }
    }

    PQIndex pq;
    long long pq_build_t0 = now_us();
    build_pq_index(data.base, data.base_n, data.dim, 16, 256,
                   cfg.train_sample, cfg.kmeans_iters, pq);
    double pq_build_sec = (now_us() - pq_build_t0) / 1000000.0;
    double pq_mb = pq_index_size_mb(pq);
    int p_values[] = {500, 1000};
    for (size_t pi = 0; pi < sizeof(p_values) / sizeof(p_values[0]); ++pi) {
        for (size_t si = 0; si < sizeof(schedules) / sizeof(schedules[0]); ++si) {
            bool dynamic_schedule = schedules[si];
            for (size_t ti = 0; ti < threads.size(); ++ti) {
                TimingAvg timing;
                double lat = 0.0;
                double rec = 0.0;
                openmp_pq_adc_query_parallel(pq, data.base, data.query, data.gt,
                                             nq, kRecallAt, p_values[pi],
                                             data.gt_dim, threads[ti],
                                             dynamic_schedule, lat, rec, &timing);
                writer.row("OpenMP-CPU-PQ-ADC",
                           method_name_with_schedule("M16", dynamic_schedule),
                           threads[ti], "p", p_values[pi], lat, rec,
                           base_lat / lat, pq_mb, pq_build_sec, &timing,
                           "host_openmp_query_parallel; thread_local_lut");
            }
        }
    }

    IVFIndex ivf;
    long long ivf_build_t0 = now_us();
    build_ivf_index(data.base, data.base_n, data.dim, 512, ivf,
                    (cfg.smoke || cfg.arm_quick) ? 8 : 15);
    double ivf_build_sec = (now_us() - ivf_build_t0) / 1000000.0;
    int nprobe_values[] = {16, 32};
    for (size_t pi = 0; pi < sizeof(nprobe_values) / sizeof(nprobe_values[0]); ++pi) {
        for (size_t si = 0; si < sizeof(schedules) / sizeof(schedules[0]); ++si) {
            bool dynamic_schedule = schedules[si];
            for (size_t ti = 0; ti < threads.size(); ++ti) {
                double lat = 0.0;
                double rec = 0.0;
                openmp_ivf_query_parallel(ivf, data.base, data.query, data.gt,
                                          nq, kRecallAt, data.gt_dim,
                                          nprobe_values[pi], threads[ti],
                                          dynamic_schedule, lat, rec);
                writer.row("OpenMP-CPU-IVF",
                           method_name_with_schedule("nl512", dynamic_schedule),
                           threads[ti], "nprobe", nprobe_values[pi],
                           lat, rec, base_lat / lat, 0.0, ivf_build_sec, NULL,
                           "host_openmp_query_parallel; coarse_plus_fine_scan");
            }
        }
    }

    write_openmp_host_best(writer);
    std::cout << "Best OpenMP host candidate: " << writer.best_summary() << "\n";
    std::cout << "Results saved to files/results/pthread_openmp_cpu_results.csv\n";
    return 0;
}

}  // namespace

int main(int argc, char** argv) {
    BenchmarkConfig cfg = parse_config(argc, argv);
    cfg.final_only = false;
    print_platform();
    std::cout << "Data dir: " << cfg.data_dir << "\n";

    BenchmarkData data;
    load_benchmark_data(cfg.data_dir, data);
    std::cout << "DEEP100K: base=" << data.base_n << " dim=" << data.dim
              << " query=" << data.query_n << " gt_dim=" << data.gt_dim
              << " metric=recall@100\n";

    return run_openmp_host(cfg, data);
}
