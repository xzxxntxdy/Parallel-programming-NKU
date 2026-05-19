/* Pthread ANN benchmark runner.

   Default mode is submission-safe: running ./main executes only the final
   selected configuration and prints recall@100 plus normalized latency.

   Full experiment mode:
     ./main --benchmark [--quick|--smoke] [--data PATH] [--nq N] [--with-hnsw]
     ./main --hnsw-only [--data PATH] [--nq N]

   The implementation reuses the SIMD-stage kernels in ann_search.h and
   ann_quant.h, then adds pthread-level query/base/pipeline parallelism.
*/

#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

#include "ann_search.h"
#include "ann_quant.h"
#include "pthread_benchmark.h"
#include "pthread_common.h"
#include "pthread_flat.h"
#include "pthread_pq.h"
#include "pthread_sq.h"
#include "pthread_sdc.h"
#include "pthread_ivf.h"
#include "pthread_hnsw.h"
#include "hnswlib/hnswlib/hnswlib.h"

using namespace ann;
using namespace hnswlib;
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

std::vector<int> rerank_values(bool reduced, bool medium) {
    if (reduced) {
        int arr[] = {100, 500, 1000};
        return std::vector<int>(arr, arr + 3);
    }
    if (medium) {
        int arr[] = {50, 100, 200, 300, 400, 450, 500, 750, 1000, 1500, 2000};
        return std::vector<int>(arr, arr + 11);
    }
    int arr[] = {50, 100, 200, 300, 400, 450, 500, 750, 1000, 1500, 2000, 5000};
    return std::vector<int>(arr, arr + 12);
}

void run_flat_experiments(const BenchmarkData& data,
                          size_t nq,
                          const std::vector<int>& threads,
                          double base_lat,
                          ResultWriter& writer) {
    struct MethodSpec {
        const char* label;
        SearchMethod method;
        size_t prefetch;
    };
    MethodSpec methods[] = {
        {"Scalar", kScalarNoVec, 0},
        {"AutoVec", kAutoVectorized, 0},
        {"SSE", kManualSse, 0},
        {"AVX2", kManualAvx, 0},
        {"NEON-Unroll4", kManualNeonUnroll4, 0},
        {"PrefetchTopK", kManualNeonUnroll4PrefetchFixedTopK, 16},
    };

    std::cout << "\n=== Flat SIMD + pthread ablation ===\n";
    for (size_t mi = 0; mi < sizeof(methods) / sizeof(methods[0]); ++mi) {
        for (size_t ti = 0; ti < threads.size(); ++ti) {
            double lat = 0.0, rec = 0.0;
            flat_query_parallel(data.base, data.query, data.gt, data.base_n, data.dim,
                                data.gt_dim, nq, kRecallAt, methods[mi].method,
                                methods[mi].prefetch, threads[ti], lat, rec);
            writer.row("Flat-Ablation", methods[mi].label, threads[ti], "method", 0,
                       lat, rec, base_lat / lat);
            std::cout << "Flat " << methods[mi].label << " t=" << threads[ti]
                      << " latency=" << lat << " ms recall=" << rec << "\n";
        }
    }

    int local_p_vals[] = {100, 200, 500};
    for (size_t pi = 0; pi < sizeof(local_p_vals) / sizeof(local_p_vals[0]); ++pi) {
        for (size_t ti = 0; ti < threads.size(); ++ti) {
            double lat = 0.0, rec = 0.0;
            flat_basesplit_parallel(data.base, data.query, data.gt, data.base_n, data.dim,
                                    data.gt_dim, nq, kRecallAt,
                                    kManualNeonUnroll4PrefetchFixedTopK, 16,
                                    threads[ti], local_p_vals[pi], lat, rec);
            writer.row("Flat-BaseSplit", "PrefetchTopK", threads[ti], "local_p",
                       local_p_vals[pi], lat, rec, base_lat / lat);
        }
    }
}

void run_sq_experiments(const BenchmarkData& data,
                        size_t nq,
                        const std::vector<int>& threads,
                        const std::vector<int>& pvals,
                        double base_lat,
                        ResultWriter& writer) {
    std::cout << "\n=== SQ8 + pthread p sweep ===\n";
    SQ8Index sq;
    long long t0 = now_us();
    build_sq8_index(data.base, data.base_n, data.dim, sq);
    double build_sec = (now_us() - t0) / 1000000.0;
    double index_mb = sq8_index_size_mb(sq);

    for (size_t pi = 0; pi < pvals.size(); ++pi) {
        for (size_t ti = 0; ti < threads.size(); ++ti) {
            TimingAvg tim;
            double lat = 0.0, rec = 0.0;
            sq8_query_parallel(sq, data.base, data.query, data.gt, nq, kRecallAt,
                               pvals[pi], data.gt_dim, threads[ti], false,
                               lat, rec, &tim);
            writer.row("SQ8", "SQ8-LUT", threads[ti], "p", pvals[pi], lat, rec,
                       base_lat / lat, index_mb, build_sec, &tim);
        }
    }
}

void run_pq_experiments(const BenchmarkData& data,
                        size_t nq,
                        const BenchmarkConfig& cfg,
                        const std::vector<int>& threads,
                        const std::vector<int>& pvals,
                        double base_lat,
                        ResultWriter& writer,
                        PQIndex& best_pq,
                        PQFastScanIndex& best_fast) {
    std::cout << "\n=== PQ-ADC / PQ-SDC / FastScan pthread sweeps ===\n";
    int mvals[] = {8, 12, 16};
    for (size_t mi = 0; mi < sizeof(mvals) / sizeof(mvals[0]); ++mi) {
        int m = mvals[mi];
        PQIndex pq;
        long long build_t0 = now_us();
        build_pq_index(data.base, data.base_n, data.dim, m, 256,
                       cfg.train_sample, cfg.kmeans_iters, pq);
        double build_sec = (now_us() - build_t0) / 1000000.0;
        double index_mb = pq_index_size_mb(pq);

        std::vector<float> sdc_table;
        build_pq_sdc_table(pq, sdc_table);

        if (m == 16) {
            PQFastScanIndex fast32, fast64, fast128;
            build_pq_fastscan_index(pq, 32, fast32);
            build_pq_fastscan_index(pq, 64, fast64);
            build_pq_fastscan_index(pq, 128, fast128);
            best_pq = pq;
            best_fast = fast64;

            int fs_pvals[] = {50, 100, 200, 300, 400, 450, 500, 750, 1000, 1500, 2000};
            PQFastScanIndex* fast_indices[] = {&fast32, &fast64, &fast128};
            int blocks[] = {32, 64, 128};
            for (int bi = 0; bi < 3; ++bi) {
                for (size_t pi = 0; pi < sizeof(fs_pvals) / sizeof(fs_pvals[0]); ++pi) {
                    for (size_t ti = 0; ti < threads.size(); ++ti) {
                        TimingAvg tim_fs;
                        double mae = 0.0;
                        double lat = 0.0, rec = 0.0;
                        pq_fastscan_query_parallel_timed(pq, *fast_indices[bi],
                                                         data.base, data.query, data.gt,
                                                         nq, kRecallAt, fs_pvals[pi],
                                                         data.gt_dim, threads[ti],
                                                         lat, rec, &tim_fs, &mae);
                        writer.row("FastScan", compact_param("b", blocks[bi]), threads[ti],
                                   "p", fs_pvals[pi], lat, rec, base_lat / lat,
                                   index_mb, build_sec, &tim_fs,
                                   std::string("lut_mae=") + std::to_string(mae));
                        if (blocks[bi] == 64 && threads[ti] == 1) {
                            writer.row("FS-Breakdown", "b64", 1, "p", fs_pvals[pi],
                                       tim_fs.scan_us / 1000.0, 0.0, 0.0,
                                       index_mb, build_sec, &tim_fs);
                        }
                    }
                }
            }

            int scaling_threads[] = {1, 2, 4, 8, 16, 32};
            for (size_t ti = 0; ti < sizeof(scaling_threads) / sizeof(scaling_threads[0]); ++ti) {
                double lat = 0.0, rec = 0.0;
                TimingAvg tim_fs;
                pq_fastscan_query_parallel_timed(pq, fast64, data.base, data.query, data.gt,
                                                 nq, kRecallAt, 500, data.gt_dim,
                                                 scaling_threads[ti], lat, rec, &tim_fs);
                writer.row("Scaling", "FastScan-b64-p500", scaling_threads[ti],
                           "threads", scaling_threads[ti], lat, rec, base_lat / lat,
                           index_mb, build_sec, &tim_fs);
            }

            int batch_vals[] = {1, 4, 8, 16, 32, 64};
            for (size_t bi = 0; bi < sizeof(batch_vals) / sizeof(batch_vals[0]); ++bi) {
                int stages = batch_vals[bi] < 8 ? 2 : 3;
                if (batch_vals[bi] == 1) stages = 1;
                TimingAvg tim_pipe;
                double lat = 0.0, rec = 0.0;
                pq_sdc_pipeline(pq, sdc_table, data.base, data.query, data.gt,
                                nq, kRecallAt, 1000, data.gt_dim, stages,
                                batch_vals[bi], lat, rec, &tim_pipe);
                writer.row("SDC-Pipeline", compact_param("stage", stages), stages,
                           "batch", batch_vals[bi], lat, rec, base_lat / lat,
                           index_mb, build_sec, &tim_pipe);
            }
        }

        for (size_t pi = 0; pi < pvals.size(); ++pi) {
            int p = pvals[pi];
            for (size_t ti = 0; ti < threads.size(); ++ti) {
                TimingAvg tim_adc;
                double lat = 0.0, rec = 0.0;
                pq_query_parallel(pq, data.base, data.query, data.gt, nq, kRecallAt,
                                  p, data.gt_dim, threads[ti], lat, rec, &tim_adc);
                writer.row("PQ-M", compact_param("M", m), threads[ti], "p", p,
                           lat, rec, base_lat / lat, index_mb, build_sec, &tim_adc);

                if (p == 1000 || p == 500 || cfg.quick) {
                    TimingAvg tim_sdc;
                    double sdc_lat = 0.0, sdc_rec = 0.0;
                    pq_sdc_query_parallel(pq, sdc_table, data.base, data.query, data.gt,
                                          nq, kRecallAt, p, data.gt_dim, threads[ti],
                                          sdc_lat, sdc_rec, &tim_sdc);
                    writer.row("PQ-SDC", compact_param("M", m), threads[ti], "p", p,
                               sdc_lat, sdc_rec, base_lat / sdc_lat,
                               index_mb + (double)sdc_table.size() * sizeof(float) / 1000000.0,
                               build_sec, &tim_sdc);
                }
            }
        }
    }
}

void run_ivf_experiments(const BenchmarkData& data,
                         size_t nq,
                         const BenchmarkConfig& cfg,
                         const std::vector<int>& threads,
                         double base_lat,
                         const PQIndex& pq,
                         ResultWriter& writer) {
    std::cout << "\n=== IVF / IVF-PQ pthread sweeps ===\n";
    std::vector<int> nlists;
    if (cfg.smoke || cfg.arm_quick) {
        int arr[] = {128, 256};
        nlists.assign(arr, arr + 2);
    } else if (cfg.quick) {
        int arr[] = {128, 256, 512};
        nlists.assign(arr, arr + 3);
    } else {
        int arr[] = {64, 128, 256, 512};
        nlists.assign(arr, arr + 4);
    }
    int nprobe_full[] = {1, 2, 4, 8, 16, 32};
    int nprobe_quick[] = {1, 4, 8, 16, 32};
    int nprobe_smoke[] = {1, 4, 8, 16};
    const int* nprobe_vals = nprobe_full;
    size_t nprobe_count = 6;
    if (cfg.smoke || cfg.arm_quick) {
        nprobe_vals = nprobe_smoke;
        nprobe_count = 4;
    } else if (cfg.quick) {
        nprobe_vals = nprobe_quick;
        nprobe_count = 5;
    }

    for (size_t ni = 0; ni < nlists.size(); ++ni) {
        IVFIndex ivf;
        long long build_t0 = now_us();
        build_ivf_index(data.base, data.base_n, data.dim, nlists[ni], ivf,
                        (cfg.smoke || cfg.arm_quick) ? 8 : 15);
        double build_sec = (now_us() - build_t0) / 1000000.0;
        for (size_t pi = 0; pi < nprobe_count; ++pi) {
            for (size_t ti = 0; ti < threads.size(); ++ti) {
                double lat = 0.0, rec = 0.0;
                ivf_query_parallel(ivf, data.base, data.query, data.gt, nq, kRecallAt,
                                   data.gt_dim, nprobe_vals[pi], threads[ti], lat, rec);
                writer.row("IVF", compact_param("nl", nlists[ni]), threads[ti],
                           "nprobe", nprobe_vals[pi], lat, rec, base_lat / lat,
                           0.0, build_sec);
            }
            if (nprobe_vals[pi] == 4 || nprobe_vals[pi] == 8 || nprobe_vals[pi] == 16) {
                double lat = 0.0, rec = 0.0;
                ivf_query_parallel(ivf, data.base, data.query, data.gt, nq, kRecallAt,
                                   data.gt_dim, nprobe_vals[pi], 1, lat, rec);
                writer.row("IVF-Breakdown", compact_param("nl", nlists[ni]), 1,
                           "nprobe", nprobe_vals[pi], lat, 0.0, 0.0, 0.0, build_sec);
            }
            if (nlists[ni] >= 128 && !pq.codes.empty()) {
                TimingAvg tim;
                double lat = 0.0, rec = 0.0;
                ivf_pq_query_parallel(ivf, pq, data.base, data.query, data.gt,
                                      nq, kRecallAt, data.gt_dim, nprobe_vals[pi],
                                      1000, threads[0], lat, rec, &tim);
                writer.row("IVF-PQ", compact_param("nl", nlists[ni]), threads[0],
                           "nprobe", nprobe_vals[pi], lat, rec, base_lat / lat,
                           pq_index_size_mb(pq), build_sec, &tim,
                           "global_pq_M16_p1000");
            }
        }

        if (!cfg.smoke && !cfg.arm_quick && nlists[ni] <= 128) {
            IVFIndex local_ivf = ivf;
            long long local_build_t0 = now_us();
            build_ivf_pq(local_ivf, data.base, 8, 256, 64,
                         std::max(4, cfg.kmeans_iters / 2));
            double local_build_sec = build_sec + (now_us() - local_build_t0) / 1000000.0;
            int local_pq_clusters = 0;
            for (size_t ci = 0; ci < local_ivf.pq_indices.size(); ++ci) {
                if (!local_ivf.pq_indices[ci].codes.empty()) ++local_pq_clusters;
            }
            int local_nprobe_vals[] = {4, 8, 16, 32};
            int local_threads[] = {1, 8, 32};
            for (size_t pi = 0; pi < sizeof(local_nprobe_vals) / sizeof(local_nprobe_vals[0]); ++pi) {
                for (size_t ti = 0; ti < sizeof(local_threads) / sizeof(local_threads[0]); ++ti) {
                    TimingAvg tim;
                    double lat = 0.0, rec = 0.0;
                    ivf_pq_local_query_parallel(local_ivf, data.base, data.query, data.gt,
                                                nq, kRecallAt, data.gt_dim,
                                                local_nprobe_vals[pi], 500,
                                                local_threads[ti], lat, rec, &tim);
                    writer.row("IVF-PQ-Local", compact_param("nl", nlists[ni]),
                               local_threads[ti], "nprobe", local_nprobe_vals[pi],
                               lat, rec, base_lat / lat, 0.0, local_build_sec, &tim,
                               std::string("per_cluster_pq_M8_p500_train64; pq_clusters=") +
                                   std::to_string(local_pq_clusters));
                }
            }
        }
    }
}

void run_hnsw_experiments(const BenchmarkData& data,
                          size_t nq,
                          const std::vector<int>& threads,
                          double base_lat,
                          ResultWriter& writer) {
    std::cout << "\n=== Optional HNSW pthread query parallel sweep ===\n";
    InnerProductSpace ipspace(static_cast<int>(data.dim));
    HierarchicalNSW<float> hnsw(&ipspace, data.base_n, 16, 100);
    long long build_t0 = now_us();
    build_hnsw_index(data.base, data.base_n, data.dim, 16, 100, ipspace, hnsw);
    double build_sec = (now_us() - build_t0) / 1000000.0;
    int ef_vals[] = {16, 32, 64, 128};
    for (size_t ei = 0; ei < sizeof(ef_vals) / sizeof(ef_vals[0]); ++ei) {
        for (size_t ti = 0; ti < threads.size(); ++ti) {
            int nt = threads[ti];
            double lat = 0.0, rec = 0.0;
            hnsw_query_stdthread(hnsw, data.query, data.gt, nq, data.dim,
                                 kRecallAt, data.gt_dim, ef_vals[ei], nt,
                                 lat, rec);
            writer.row("HNSW", "StdThread-M16-efC100", nt, "ef", ef_vals[ei],
                       lat, rec, base_lat / lat, 0.0, build_sec);
        }
    }
}

int run_hnsw_only(const BenchmarkConfig& cfg, const BenchmarkData& data) {
    ensure_dir("files");
    ensure_dir("files/results");
    ResultWriter writer("files/results/pthread_hnsw_results.csv", cfg.target_recall);
    if (!writer.good()) {
        std::cerr << "FATAL: cannot open files/results/pthread_hnsw_results.csv\n";
        return 2;
    }
    const size_t nq = std::min(capped_queries(cfg, data), data.gt_n);
    std::vector<int> threads = thread_values(cfg.smoke || cfg.arm_quick);
    double base_lat = 0.0, base_rec = 0.0;
    flat_query_parallel(data.base, data.query, data.gt, data.base_n, data.dim,
                        data.gt_dim, nq, kRecallAt, kScalarNoVec, 0, 1,
                        base_lat, base_rec);

    std::cout << "\n=== HNSW advanced-only experiments ===\n";
    std::cout << "Queries: " << nq << "\n";
    std::cout << "Selection criterion: minimize latency with recall@100 >= "
              << cfg.target_recall << "\n";

    InnerProductSpace ipspace(static_cast<int>(data.dim));
    HierarchicalNSW<float> hnsw(&ipspace, data.base_n, 16, 100);
    long long build_t0 = now_us();
    build_hnsw_index(data.base, data.base_n, data.dim, 16, 100, ipspace, hnsw);
    double build_sec = (now_us() - build_t0) / 1000000.0;

    int ef_vals[] = {32, 64, 128, 256};
    for (size_t ei = 0; ei < sizeof(ef_vals) / sizeof(ef_vals[0]); ++ei) {
        int ef = ef_vals[ei];
        for (size_t ti = 0; ti < threads.size(); ++ti) {
            int nt = threads[ti];
            double lat = 0.0, rec = 0.0;
            hnsw_query_stdthread(hnsw, data.query, data.gt, nq, data.dim,
                                 kRecallAt, data.gt_dim, ef, nt, lat, rec);
            writer.row("HNSW-ToolCompare", "StdThread", nt, "ef", ef,
                       lat, rec, base_lat / lat, 0.0, build_sec,
                       NULL, "single_index_query_parallel");

            hnsw_query_async(hnsw, data.query, data.gt, nq, data.dim,
                             kRecallAt, data.gt_dim, ef, nt, lat, rec);
            writer.row("HNSW-ToolCompare", "StdAsync", nt, "ef", ef,
                       lat, rec, base_lat / lat, 0.0, build_sec,
                       NULL, "cpp_standard_async");

        }
    }

    int entry_vals[] = {1, 2, 4, 8};
    for (size_t ei = 0; ei < sizeof(entry_vals) / sizeof(entry_vals[0]); ++ei) {
        double lat = 0.0, rec = 0.0;
        hnsw_multi_entry_layer0(hnsw, data.query, data.gt, nq, data.dim,
                                kRecallAt, data.gt_dim, 128, entry_vals[ei],
                                lat, rec);
        writer.row("HNSW-IntraQuery", "Layer0MultiEntry", entry_vals[ei],
                   "ef", 128, lat, rec, base_lat / lat, 0.0, build_sec,
                   NULL, "entry_count_as_threads; may be negative optimization");
    }

    int edge_parts[] = {1, 2, 4, 8};
    for (size_t ei = 0; ei < sizeof(edge_parts) / sizeof(edge_parts[0]); ++ei) {
        double lat = 0.0, rec = 0.0;
        hnsw_layer0_edge_partition(hnsw, data.query, data.gt, nq, data.dim,
                                   kRecallAt, data.gt_dim, 128, edge_parts[ei],
                                   lat, rec);
        writer.row("HNSW-IntraQuery", "Layer0EdgePartition", edge_parts[ei],
                   "ef", 128, lat, rec, base_lat / lat, 0.0, build_sec,
                   NULL, "level0_edge_index_partition; bottom_graph_only");
    }

    int point_parts[] = {1, 2, 4, 8};
    for (size_t pi = 0; pi < sizeof(point_parts) / sizeof(point_parts[0]); ++pi) {
        double lat = 0.0, rec = 0.0;
        hnsw_layer0_point_partition(data.base, data.query, data.gt, data.base_n,
                                    nq, data.dim, kRecallAt, data.gt_dim,
                                    point_parts[pi], lat, rec);
        writer.row("HNSW-IntraQuery", "Layer0PointPartition", point_parts[pi],
                   "partitions", point_parts[pi], lat, rec, base_lat / lat,
                   0.0, build_sec, NULL,
                   "exact_partition_of_layer0_points; scans_all_bottom_nodes");
    }

    IvfHnswIndex ivf_hnsw;
    long long nested_t0 = now_us();
    build_ivf_hnsw_index(data.base, data.base_n, data.dim, 16, 16, 100,
                         cfg.kmeans_iters, ivf_hnsw);
    double nested_build_sec = (now_us() - nested_t0) / 1000000.0;
    int nprobe_vals[] = {2, 4, 8, 16};
    for (size_t pi = 0; pi < sizeof(nprobe_vals) / sizeof(nprobe_vals[0]); ++pi) {
        for (size_t ti = 0; ti < threads.size(); ++ti) {
            double lat = 0.0, rec = 0.0;
            ivf_hnsw_query_parallel(ivf_hnsw, data.query, data.gt, nq,
                                    kRecallAt, data.gt_dim, nprobe_vals[pi],
                                    128, threads[ti], lat, rec);
            writer.row("IVF-HNSW", "nlist16-M16-efC100", threads[ti],
                       "nprobe", nprobe_vals[pi], lat, rec, base_lat / lat,
                       0.0, nested_build_sec, NULL,
                       "nested_ivf_hnsw; each query searches selected shard graphs");
        }
    }

    writer.write_best("files/results/pthread_hnsw_best.csv");
    std::cout << "HNSW advanced best: " << writer.best_summary() << "\n";
    std::cout << "Results saved to files/results/pthread_hnsw_results.csv\n";
    return 0;
}

double run_baseline_and_write(const BenchmarkData& data,
                              size_t nq,
                              ResultWriter& writer) {
    double lat = 0.0, rec = 0.0;
    flat_query_parallel(data.base, data.query, data.gt, data.base_n, data.dim,
                        data.gt_dim, nq, kRecallAt, kScalarNoVec, 0, 1, lat, rec);
    writer.row("Flat-Ablation", "Scalar", 1, "method", 0, lat, rec, 1.0);
    return lat;
}

int run_benchmark(const BenchmarkConfig& cfg, const BenchmarkData& data) {
    ensure_dir("files");
    ensure_dir("files/results");
    ResultWriter writer("files/results/pthread_results.csv", cfg.target_recall);
    if (!writer.good()) {
        std::cerr << "FATAL: cannot open files/results/pthread_results.csv\n";
        return 2;
    }

    const size_t nq = std::min(capped_queries(cfg, data), data.gt_n);
    std::vector<int> threads = thread_values(cfg.smoke || cfg.arm_quick);
    std::vector<int> pvals = rerank_values(cfg.smoke || cfg.arm_quick, cfg.quick);

    std::cout << "Benchmark queries: " << nq << "\n";
    std::cout << "Selection criterion: minimize latency with recall@100 >= "
              << cfg.target_recall << "\n";
    double base_lat = run_baseline_and_write(data, nq, writer);
    std::cout << "Flat Scalar 1T baseline: " << base_lat << " ms/query\n";

    run_flat_experiments(data, nq, threads, base_lat, writer);
    run_sq_experiments(data, nq, threads, pvals, base_lat, writer);

    PQIndex best_pq;
    PQFastScanIndex best_fast;
    run_pq_experiments(data, nq, cfg, threads, pvals, base_lat, writer, best_pq, best_fast);
    run_ivf_experiments(data, nq, cfg, threads, base_lat, best_pq, writer);
    if (cfg.with_hnsw) {
        run_hnsw_experiments(data, std::min<size_t>(nq, 50), threads, base_lat, writer);
    }

    writer.write_best("files/results/pthread_best.csv");
    std::cout << "\nBest candidate: " << writer.best_summary() << "\n";
    std::cout << "Results saved to files/results/pthread_results.csv\n";
    return 0;
}

int run_final(const BenchmarkConfig& cfg, const BenchmarkData& data) {
    const size_t nq = cfg.quick ? capped_queries(cfg, data)
                                : std::min(data.query_n, data.gt_n);
    const int best_threads = cfg.arm_quick ? 2 : cfg.final_threads;
    const int best_m = 16;
    const int best_ef_construction = 100;
    const int best_ef = 64;

    std::cout << "=== Final pthread ANN path ===\n";
    std::cout << "selection criterion: minimize latency with recall@100 >= "
              << cfg.target_recall << "\n";
    std::cout << "method: HNSW StdAsync M=" << best_m
              << " efConstruction=" << best_ef_construction
              << " ef=" << best_ef
              << " threads=" << best_threads << "\n";

    long long build_t0 = now_us();
    InnerProductSpace ipspace(static_cast<int>(data.dim));
    HierarchicalNSW<float> hnsw(&ipspace, data.base_n, best_m, best_ef_construction);
    build_hnsw_index(data.base, data.base_n, data.dim, best_m,
                     best_ef_construction, ipspace, hnsw);
    double build_sec = (now_us() - build_t0) / 1000000.0;

    double lat = 0.0, rec = 0.0;
    hnsw_query_async(hnsw, data.query, data.gt, nq, data.dim, kRecallAt,
                     data.gt_dim, best_ef, best_threads, lat, rec);

    ensure_dir("files");
    ensure_dir("files/results");
    std::ofstream fout("files/results/pthread_final.csv");
    fout << "criterion,method,nthreads,param1,param2,latency_us,recall@100,build_sec,index_mb,notes\n";
    fout << "min latency with recall@100>=" << cfg.target_recall
         << ",HNSW-StdAsync," << best_threads << ",ef," << best_ef << ","
         << std::fixed << std::setprecision(6) << lat * 1000.0 << ","
         << rec << "," << build_sec << ",0.000000,"
         << "M=" << best_m << "; ef_construction=" << best_ef_construction << "\n";

    std::cout << "build time (s): " << std::fixed << std::setprecision(3) << build_sec << "\n";
    std::cout << "average recall: " << std::setprecision(5) << rec << "\n";
    std::cout << "average latency (us): " << std::setprecision(2) << lat * 1000.0 << "\n";
    return 0;
}

}  // namespace

int main(int argc, char** argv) {
    BenchmarkConfig cfg = parse_config(argc, argv);
    print_platform();
    std::cout << "Data dir: " << cfg.data_dir << "\n";

    BenchmarkData data;
    load_benchmark_data(cfg.data_dir, data);
    std::cout << "DEEP100K: base=" << data.base_n << " dim=" << data.dim
              << " query=" << data.query_n << " gt_dim=" << data.gt_dim
              << " metric=recall@100\n";

    if (cfg.final_only) {
        return run_final(cfg, data);
    }
    if (cfg.hnsw_only || cfg.advanced_only) {
        return run_hnsw_only(cfg, data);
    }
    return run_benchmark(cfg, data);
}
