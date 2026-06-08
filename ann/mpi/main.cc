#include "mpi_hnsw.h"

#include <mpi.h>

#include <algorithm>
#include <iostream>
#include <sstream>

using namespace mpi_ann;

namespace {

ann::SearchMethod default_simd_kernel() {
#if ANN_HAS_AVX
    return ann::kManualAvx;
#elif ANN_HAS_NEON
    return ann::kManualNeonUnroll4;
#elif ANN_HAS_SSE
    return ann::kManualSse;
#else
    return ann::kAutoVectorized;
#endif
}

ann::SearchMethod parse_kernel(const std::string& name) {
    if (name == "scalar") return ann::kScalarNoVec;
    if (name == "auto") return ann::kAutoVectorized;
    if (name == "sse") return ann::kManualSse;
    if (name == "avx") return ann::kManualAvx;
    if (name == "neon") return ann::kManualNeonUnroll4;
    return default_simd_kernel();
}

struct Options {
    std::string method = "ivf";
    std::string comm = "blocking";
    std::string thread_model = "stdthread";
    std::string kernel_name = "simd";
    ann::SearchMethod kernel = default_simd_kernel();
    std::string data_dir = find_data_dir();
    std::string csv = "files/results/mpi_results_x86_windows.csv";
    size_t nbase = 100000;
    size_t nq = 1000;
    size_t k = 100;
    int nlist = 512;
    int nprobe = 32;
    int kmeans_iters = 8;
    int threads = 1;
    int repeat = 1;
    int nodes = 1;
    int ppn = 1;
    size_t hnsw_m = 16;
    size_t ef = 64;
    size_t ef_construction = 100;
    bool quick = false;
    bool smoke = false;
    bool mpi_thread_multiple = false;
};

Options parse_options(int argc, char** argv) {
    Options opt;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        auto need_value = [&](const std::string& name) -> const char* {
            if (i + 1 >= argc) {
                std::cerr << "Missing value for " << name << "\n";
                std::exit(2);
            }
            return argv[++i];
        };
        if (a == "--method") opt.method = need_value(a);
        else if (a == "--comm") opt.comm = need_value(a);
        else if (a == "--thread-model") opt.thread_model = need_value(a);
        else if (a == "--kernel") opt.kernel_name = need_value(a);
        else if (a == "--data") opt.data_dir = need_value(a);
        else if (a == "--csv") opt.csv = need_value(a);
        else if (a == "--nbase") opt.nbase = static_cast<size_t>(std::strtoull(need_value(a), nullptr, 10));
        else if (a == "--nq") opt.nq = static_cast<size_t>(std::strtoull(need_value(a), nullptr, 10));
        else if (a == "--k") opt.k = static_cast<size_t>(std::strtoull(need_value(a), nullptr, 10));
        else if (a == "--nlist") opt.nlist = std::atoi(need_value(a));
        else if (a == "--nprobe") opt.nprobe = std::atoi(need_value(a));
        else if (a == "--iters") opt.kmeans_iters = std::atoi(need_value(a));
        else if (a == "--threads") opt.threads = std::atoi(need_value(a));
        else if (a == "--repeat") opt.repeat = std::atoi(need_value(a));
        else if (a == "--nodes") opt.nodes = std::atoi(need_value(a));
        else if (a == "--ppn") opt.ppn = std::atoi(need_value(a));
        else if (a == "--hnsw-m") opt.hnsw_m = static_cast<size_t>(std::strtoull(need_value(a), nullptr, 10));
        else if (a == "--ef") opt.ef = static_cast<size_t>(std::strtoull(need_value(a), nullptr, 10));
        else if (a == "--efc") opt.ef_construction = static_cast<size_t>(std::strtoull(need_value(a), nullptr, 10));
        else if (a == "--quick") {
            opt.quick = true;
            opt.nbase = 50000;
            opt.nq = 300;
            opt.kmeans_iters = 6;
        } else if (a == "--smoke") {
            opt.quick = true;
            opt.smoke = true;
            opt.nbase = 10000;
            opt.nq = 50;
            opt.nlist = 128;
            opt.nprobe = 16;
            opt.kmeans_iters = 4;
        } else if (a == "--mpi-thread-multiple") {
            opt.mpi_thread_multiple = true;
        }
    }
    opt.nlist = std::max(1, opt.nlist);
    opt.nprobe = std::max(1, opt.nprobe);
    opt.threads = std::max(1, opt.threads);
    opt.repeat = std::max(1, opt.repeat);
    opt.nodes = std::max(1, opt.nodes);
    opt.ppn = std::max(1, opt.ppn);
    opt.kernel = parse_kernel(opt.kernel_name);
    return opt;
}

void distribute_data(const Options& opt,
                     int rank,
                     int mpi_size,
                     std::vector<float>& local_base,
                     std::vector<float>& query,
                     std::vector<int>& gt,
                     size_t& global_begin,
                     size_t& local_n,
                     size_t& dim,
                     size_t& nq,
                     size_t& gt_dim,
                     double& distribute_s) {
    DataSet root_data;
    double t0 = MPI_Wtime();
    unsigned long long meta[4] = {0, 0, 0, 0};
    if (rank == 0) {
        root_data = load_dataset_root(opt.data_dir, opt.nbase, opt.nq);
        meta[0] = static_cast<unsigned long long>(root_data.base_n);
        meta[1] = static_cast<unsigned long long>(root_data.dim);
        meta[2] = static_cast<unsigned long long>(root_data.query_n);
        meta[3] = static_cast<unsigned long long>(root_data.gt_dim);
    }
    MPI_Bcast(meta, 4, MPI_UNSIGNED_LONG_LONG, 0, MPI_COMM_WORLD);
    size_t nbase = static_cast<size_t>(meta[0]);
    dim = static_cast<size_t>(meta[1]);
    nq = static_cast<size_t>(meta[2]);
    gt_dim = static_cast<size_t>(meta[3]);

    query.resize(nq * dim);
    gt.resize(nq * gt_dim);
    if (rank == 0) {
        query = root_data.query;
        gt = root_data.gt;
    }
    MPI_Bcast(query.data(), static_cast<int>(query.size()), MPI_FLOAT, 0, MPI_COMM_WORLD);
    MPI_Bcast(gt.data(), static_cast<int>(gt.size()), MPI_INT, 0, MPI_COMM_WORLD);

    std::vector<int> counts(mpi_size), displs(mpi_size);
    for (int r = 0; r < mpi_size; ++r) {
        size_t begin = 0, count = 0;
        split_range(nbase, mpi_size, r, begin, count);
        counts[r] = static_cast<int>(count * dim);
        displs[r] = static_cast<int>(begin * dim);
        if (r == rank) {
            global_begin = begin;
            local_n = count;
        }
    }
    local_base.resize(local_n * dim);
    MPI_Scatterv(rank == 0 ? root_data.base.data() : nullptr,
                 counts.data(),
                 displs.data(),
                 MPI_FLOAT,
                 local_base.data(),
                 counts[rank],
                 MPI_FLOAT,
                 0,
                 MPI_COMM_WORLD);
    distribute_s = MPI_Wtime() - t0;
}

void gather_results(const Options& opt,
                    int rank,
                    int mpi_size,
                    size_t nq,
                    size_t k,
                    const std::vector<float>& local_dist,
                    const std::vector<uint32_t>& local_ids,
                    std::vector<float>& all_dist,
                    std::vector<uint32_t>& all_ids) {
    int count = static_cast<int>(nq * k);
    if (rank == 0) {
        all_dist.assign(static_cast<size_t>(mpi_size) * count, std::numeric_limits<float>::infinity());
        all_ids.assign(static_cast<size_t>(mpi_size) * count, kInvalidId);
    }

    if (opt.comm == "nonblocking") {
        MPI_Request reqs[2];
        MPI_Igather(local_dist.data(), count, MPI_FLOAT,
                    rank == 0 ? all_dist.data() : nullptr, count, MPI_FLOAT,
                    0, MPI_COMM_WORLD, &reqs[0]);
        MPI_Igather(local_ids.data(), count, MPI_UNSIGNED,
                    rank == 0 ? all_ids.data() : nullptr, count, MPI_UNSIGNED,
                    0, MPI_COMM_WORLD, &reqs[1]);
        MPI_Waitall(2, reqs, MPI_STATUSES_IGNORE);
    } else if (opt.comm == "p2p") {
        if (rank == 0) {
            std::copy(local_dist.begin(), local_dist.end(), all_dist.begin());
            std::copy(local_ids.begin(), local_ids.end(), all_ids.begin());
            for (int r = 1; r < mpi_size; ++r) {
                MPI_Recv(all_dist.data() + static_cast<size_t>(r) * count, count, MPI_FLOAT,
                         r, 100, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                MPI_Recv(all_ids.data() + static_cast<size_t>(r) * count, count, MPI_UNSIGNED,
                         r, 101, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            }
        } else {
            MPI_Send(local_dist.data(), count, MPI_FLOAT, 0, 100, MPI_COMM_WORLD);
            MPI_Send(local_ids.data(), count, MPI_UNSIGNED, 0, 101, MPI_COMM_WORLD);
        }
    } else if (opt.comm == "onesided") {
        MPI_Win win_dist, win_ids;
        MPI_Win_create(rank == 0 ? all_dist.data() : nullptr,
                       rank == 0 ? static_cast<MPI_Aint>(all_dist.size() * sizeof(float)) : 0,
                       sizeof(float), MPI_INFO_NULL, MPI_COMM_WORLD, &win_dist);
        MPI_Win_create(rank == 0 ? all_ids.data() : nullptr,
                       rank == 0 ? static_cast<MPI_Aint>(all_ids.size() * sizeof(uint32_t)) : 0,
                       sizeof(uint32_t), MPI_INFO_NULL, MPI_COMM_WORLD, &win_ids);
        MPI_Win_fence(0, win_dist);
        MPI_Win_fence(0, win_ids);
        MPI_Put(local_dist.data(), count, MPI_FLOAT, 0,
                static_cast<MPI_Aint>(rank) * count, count, MPI_FLOAT, win_dist);
        MPI_Put(local_ids.data(), count, MPI_UNSIGNED, 0,
                static_cast<MPI_Aint>(rank) * count, count, MPI_UNSIGNED, win_ids);
        MPI_Win_fence(0, win_ids);
        MPI_Win_fence(0, win_dist);
        MPI_Win_free(&win_ids);
        MPI_Win_free(&win_dist);
    } else {
        MPI_Gather(local_dist.data(), count, MPI_FLOAT,
                   rank == 0 ? all_dist.data() : nullptr, count, MPI_FLOAT,
                   0, MPI_COMM_WORLD);
        MPI_Gather(local_ids.data(), count, MPI_UNSIGNED,
                   rank == 0 ? all_ids.data() : nullptr, count, MPI_UNSIGNED,
                   0, MPI_COMM_WORLD);
    }
}

std::string method_label(const Options& opt) {
    std::ostringstream os;
    os << opt.method << "-comm=" << opt.comm
       << "-tm=" << opt.thread_model
       << "-kernel=" << opt.kernel_name
       << "-nl=" << opt.nlist
       << "-npb=" << opt.nprobe
       << "-ef=" << opt.ef;
    return os.str();
}

}  // namespace

int main(int argc, char** argv) {
    Options opt = parse_options(argc, argv);
    int required = opt.mpi_thread_multiple ? MPI_THREAD_MULTIPLE : MPI_THREAD_FUNNELED;
    int provided = MPI_THREAD_SINGLE;
    MPI_Init_thread(&argc, &argv, required, &provided);

    int rank = 0, mpi_size = 1;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &mpi_size);

    std::vector<float> local_base, query;
    std::vector<int> gt;
    size_t global_begin = 0, local_n = 0, dim = 0, nq = 0, gt_dim = 0;
    double distribute_s = 0.0;
    distribute_data(opt, rank, mpi_size, local_base, query, gt,
                    global_begin, local_n, dim, nq, gt_dim, distribute_s);

    if (rank == 0) {
        std::cout << "MPI ANN method=" << opt.method
                  << " comm=" << opt.comm
                  << " kernel=" << opt.kernel_name
                  << " ranks=" << mpi_size
                  << " threads=" << opt.threads
                  << " nbase=" << opt.nbase
                  << " nq=" << nq
                  << " dim=" << dim << "\n";
    }

    double build_t0 = MPI_Wtime();
    LocalIVFIndex ivf;
    LocalHNSWIndex hnsw;
    LocalIVFHNSWIndex ivf_hnsw;
    if (opt.method == "ivf") {
        build_local_ivf(local_base, dim, static_cast<uint32_t>(global_begin),
                        opt.nlist, opt.kmeans_iters, opt.kernel, ivf);
    } else if (opt.method == "hnsw" || opt.method == "multi-hnsw") {
        build_local_hnsw(local_base, dim, static_cast<uint32_t>(global_begin),
                         opt.hnsw_m, opt.ef_construction, hnsw);
    } else if (opt.method == "ivf-hnsw") {
        build_local_ivf_hnsw(local_base, dim, static_cast<uint32_t>(global_begin),
                             opt.nlist, opt.kmeans_iters, opt.hnsw_m,
                             opt.ef_construction, opt.kernel, ivf_hnsw);
    }
    double local_build_s = MPI_Wtime() - build_t0;
    double build_s = 0.0;
    MPI_Reduce(&local_build_s, &build_s, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

    double best_latency_ms = std::numeric_limits<double>::infinity();
    double best_recall = 0.0;
    double best_search_s = 0.0, best_comm_s = 0.0, best_merge_s = 0.0, best_total_s = 0.0;
    double best_local_work = 0.0;

    for (int rep = 0; rep < opt.repeat; ++rep) {
        MPI_Barrier(MPI_COMM_WORLD);
        double total_t0 = MPI_Wtime();
        double local_work = 0.0;
        std::vector<float> local_dist;
        std::vector<uint32_t> local_ids;

        double search_t0 = MPI_Wtime();
        if (opt.method == "flat") {
            search_local_flat_batch(local_base, dim, static_cast<uint32_t>(global_begin),
                                    query, nq, opt.k, opt.kernel, opt.threads, opt.thread_model,
                                    local_dist, local_ids);
            local_work = static_cast<double>(local_n);
        } else if (opt.method == "hnsw" || opt.method == "multi-hnsw") {
            search_local_hnsw_batch(hnsw, query, nq, opt.k, opt.ef,
                                    opt.threads, opt.thread_model, local_dist, local_ids);
            local_work = static_cast<double>(local_n);
        } else if (opt.method == "ivf-hnsw") {
            search_local_ivf_hnsw_batch(ivf_hnsw, query, nq, opt.k, opt.nprobe, opt.ef,
                                        opt.kernel, opt.threads, opt.thread_model,
                                        local_dist, local_ids, local_work);
        } else {
            search_local_ivf_batch(ivf, local_base, query, nq, opt.k, opt.nprobe,
                                   opt.kernel, opt.threads, opt.thread_model,
                                   local_dist, local_ids, local_work);
        }
        double local_search_s = MPI_Wtime() - search_t0;

        std::vector<float> all_dist;
        std::vector<uint32_t> all_ids;
        double comm_t0 = MPI_Wtime();
        gather_results(opt, rank, mpi_size, nq, opt.k, local_dist, local_ids, all_dist, all_ids);
        double comm_s = MPI_Wtime() - comm_t0;

        double recall = 0.0;
        double merge_s = 0.0;
        if (rank == 0) {
            double merge_t0 = MPI_Wtime();
            merge_rank_results(all_dist, all_ids, mpi_size, nq, opt.k, gt, gt_dim, recall);
            merge_s = MPI_Wtime() - merge_t0;
        }
        double total_s = MPI_Wtime() - total_t0;

        double max_search_s = 0.0, max_comm_s = 0.0, max_work = 0.0, min_work = 0.0;
        MPI_Reduce(&local_search_s, &max_search_s, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
        MPI_Reduce(&comm_s, &max_comm_s, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
        MPI_Reduce(&local_work, &max_work, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
        MPI_Reduce(&local_work, &min_work, 1, MPI_DOUBLE, MPI_MIN, 0, MPI_COMM_WORLD);

        if (rank == 0) {
            double latency_ms = total_s * 1000.0 / static_cast<double>(std::max<size_t>(1, nq));
            if (latency_ms < best_latency_ms) {
                best_latency_ms = latency_ms;
                best_recall = recall;
                best_search_s = max_search_s;
                best_comm_s = max_comm_s;
                best_merge_s = merge_s;
                best_total_s = total_s;
                best_local_work = min_work > 0.0 ? max_work / min_work : 0.0;
            }
        }
    }

    if (rank == 0) {
        std::vector<std::string> header = {
            "experiment", "method", "kernel", "platform", "mpi_size", "nodes", "ppn",
            "nthreads", "thread_model", "comm", "nbase", "nq", "k",
            "nlist", "nprobe", "ef", "latency_ms", "recall@100",
            "build_sec", "distribute_ms", "search_ms", "comm_ms", "merge_ms",
            "total_ms", "work_imbalance", "mpi_thread_required",
            "mpi_thread_provided", "notes"
        };
        std::vector<std::string> row = {
            "MPI-ANN",
            opt.method,
            opt.kernel_name,
            "x86_or_cluster",
            std::to_string(mpi_size),
            std::to_string(opt.nodes),
            std::to_string(opt.ppn),
            std::to_string(opt.threads),
            opt.thread_model,
            opt.comm,
            std::to_string(opt.nbase),
            std::to_string(nq),
            std::to_string(opt.k),
            std::to_string(opt.nlist),
            std::to_string(opt.nprobe),
            std::to_string(opt.ef),
            f6(best_latency_ms),
            f6(best_recall),
            f6(build_s),
            f6(distribute_s * 1000.0),
            f6(best_search_s * 1000.0),
            f6(best_comm_s * 1000.0),
            f6(best_merge_s * 1000.0),
            f6(best_total_s * 1000.0),
            f6(best_local_work),
            std::to_string(required),
            std::to_string(provided),
            method_label(opt) + ";" + (opt.quick ? (opt.smoke ? "smoke" : "quick") : "full")
        };
        append_csv_row(opt.csv, header, row);
        std::cout << "RESULT latency_ms=" << best_latency_ms
                  << " recall@100=" << best_recall
                  << " build_sec=" << build_s
                  << " search_ms=" << best_search_s * 1000.0
                  << " comm_ms=" << best_comm_s * 1000.0
                  << " merge_ms=" << best_merge_s * 1000.0
                  << " csv=" << opt.csv << "\n";
    }

    MPI_Finalize();
    return 0;
}
