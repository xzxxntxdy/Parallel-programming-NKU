#include "gpu_ivf.h"

#include <cublas_v2.h>
#include <cuda_runtime.h>

#include <algorithm>
#include <cstddef>
#include <iostream>
#include <numeric>
#include <stdexcept>
#include <utility>

namespace {

void cuda_check(cudaError_t err, const char* what) {
    if (err != cudaSuccess) {
        std::cerr << "CUDA error at " << what << ": " << cudaGetErrorString(err) << "\n";
        std::exit(1);
    }
}

void cublas_check(cublasStatus_t err, const char* what) {
    if (err != CUBLAS_STATUS_SUCCESS) {
        std::cerr << "cuBLAS error at " << what << ": " << static_cast<int>(err) << "\n";
        std::exit(1);
    }
}

__global__ void dense_naive_kernel(const float* base,
                                   const float* query,
                                   float* scores,
                                   int nbase,
                                   int batch,
                                   int dim) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total = nbase * batch;
    if (idx >= total) return;
    int q = idx / nbase;
    int b = idx - q * nbase;
    float sum = 0.0f;
    const float* bv = base + b * dim;
    const float* qv = query + q * dim;
    for (int d = 0; d < dim; ++d) sum += bv[d] * qv[d];
    scores[idx] = sum;
}

__global__ void dense_tiled_kernel(const float* base,
                                   const float* query,
                                   float* scores,
                                   int nbase,
                                   int batch,
                                   int dim) {
    constexpr int BASE_TILE = 16;
    constexpr int QUERY_TILE = 16;
    constexpr int DIM_TILE = 32;
    __shared__ float s_base[BASE_TILE][DIM_TILE];
    __shared__ float s_query[QUERY_TILE][DIM_TILE];

    int bx = blockIdx.x * BASE_TILE + threadIdx.x;
    int qy = blockIdx.y * QUERY_TILE + threadIdx.y;
    int tid = threadIdx.y * blockDim.x + threadIdx.x;
    float sum = 0.0f;

    for (int d0 = 0; d0 < dim; d0 += DIM_TILE) {
        for (int e = tid; e < BASE_TILE * DIM_TILE; e += BASE_TILE * QUERY_TILE) {
            int r = e / DIM_TILE;
            int d = e - r * DIM_TILE;
            int b = blockIdx.x * BASE_TILE + r;
            int gd = d0 + d;
            s_base[r][d] = (b < nbase && gd < dim) ? base[b * dim + gd] : 0.0f;
        }
        for (int e = tid; e < QUERY_TILE * DIM_TILE; e += BASE_TILE * QUERY_TILE) {
            int r = e / DIM_TILE;
            int d = e - r * DIM_TILE;
            int q = blockIdx.y * QUERY_TILE + r;
            int gd = d0 + d;
            s_query[r][d] = (q < batch && gd < dim) ? query[q * dim + gd] : 0.0f;
        }
        __syncthreads();
        if (bx < nbase && qy < batch) {
            for (int d = 0; d < DIM_TILE; ++d) {
                sum += s_base[threadIdx.x][d] * s_query[threadIdx.y][d];
            }
        }
        __syncthreads();
    }

    if (bx < nbase && qy < batch) scores[qy * nbase + bx] = sum;
}

__global__ void ivf_candidate_kernel(const float* base,
                                     const float* query,
                                     const int* candidate_ids,
                                     float* scores,
                                     int batch,
                                     int max_candidates,
                                     int dim) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total = batch * max_candidates;
    if (idx >= total) return;
    int q = idx / max_candidates;
    int id = candidate_ids[idx];
    if (id < 0) {
        scores[idx] = -3.402823466e+38F;
        return;
    }
    const float* bv = base + id * dim;
    const float* qv = query + q * dim;
    float sum = 0.0f;
    for (int d = 0; d < dim; ++d) sum += bv[d] * qv[d];
    scores[idx] = sum;
}

__global__ void ivf_cluster_kernel(const float* base,
                                   const float* query,
                                   const int* cluster_ids,
                                   float* scores,
                                   int batch,
                                   int cluster_size,
                                   int dim) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total = batch * cluster_size;
    if (idx >= total) return;
    int q = idx / cluster_size;
    int j = idx - q * cluster_size;
    int id = cluster_ids[j];
    const float* bv = base + id * dim;
    const float* qv = query + q * dim;
    float sum = 0.0f;
    for (int d = 0; d < dim; ++d) sum += bv[d] * qv[d];
    scores[idx] = sum;
}

struct Options {
    std::string method = "cuda_flat_tiled";
    std::string data_dir = gpu_ann::find_data_dir();
    std::string csv = "files/results/gpu_results.csv";
    size_t nbase = 100000;
    size_t nq = 1000;
    size_t k = 100;
    int batch = 128;
    int nlist = 256;
    int nprobe = 32;
    int iters = 3;
    int repeat = 1;
    bool smoke = false;
};

Options parse_options(int argc, char** argv) {
    Options opt;
    for (int i = 1; i < argc; ++i) {
        std::string a = argv[i];
        auto value = [&](const std::string& name) -> const char* {
            if (i + 1 >= argc) {
                std::cerr << "Missing value for " << name << "\n";
                std::exit(2);
            }
            return argv[++i];
        };
        if (a == "--method") opt.method = value(a);
        else if (a == "--data") opt.data_dir = value(a);
        else if (a == "--csv") opt.csv = value(a);
        else if (a == "--nbase") opt.nbase = static_cast<size_t>(std::strtoull(value(a), nullptr, 10));
        else if (a == "--nq") opt.nq = static_cast<size_t>(std::strtoull(value(a), nullptr, 10));
        else if (a == "--k") opt.k = static_cast<size_t>(std::strtoull(value(a), nullptr, 10));
        else if (a == "--batch") opt.batch = std::atoi(value(a));
        else if (a == "--nlist") opt.nlist = std::atoi(value(a));
        else if (a == "--nprobe") opt.nprobe = std::atoi(value(a));
        else if (a == "--iters") opt.iters = std::atoi(value(a));
        else if (a == "--repeat") opt.repeat = std::atoi(value(a));
        else if (a == "--smoke") {
            opt.smoke = true;
            opt.nbase = 10000;
            opt.nq = 50;
            opt.batch = 32;
            opt.nlist = 64;
            opt.nprobe = 8;
            opt.iters = 2;
        }
    }
    opt.batch = std::max(1, opt.batch);
    opt.nlist = std::max(1, opt.nlist);
    opt.nprobe = std::max(1, opt.nprobe);
    opt.iters = std::max(1, opt.iters);
    opt.repeat = std::max(1, opt.repeat);
    return opt;
}

struct RunStats {
    double build_ms = 0.0;
    double candidate_ms = 0.0;
    double compute_ms = 0.0;
    double topk_ms = 0.0;
    double total_ms = std::numeric_limits<double>::infinity();
    double latency_ms = std::numeric_limits<double>::infinity();
    double recall = 0.0;
    double avg_candidates = 0.0;
    double scored_pairs = 0.0;
    double waste_ratio = 1.0;
};

std::string gpu_name() {
    cudaDeviceProp prop{};
    int device = 0;
    cuda_check(cudaGetDevice(&device), "cudaGetDevice");
    cuda_check(cudaGetDeviceProperties(&prop, device), "cudaGetDeviceProperties");
    return prop.name;
}

RunStats run_cpu_flat(const gpu_ann::Dataset& ds, const Options& opt) {
    RunStats stats;
    double total0 = gpu_ann::now_ms();
    std::vector<std::vector<uint32_t> > results(ds.nq);
    double topk_ms = 0.0;
    std::vector<float> scores(ds.nbase);
    for (size_t qi = 0; qi < ds.nq; ++qi) {
        const float* q = ds.query.data() + qi * ds.dim;
        for (size_t i = 0; i < ds.nbase; ++i) {
            scores[i] = gpu_ann::inner_product_cpu(ds.base.data() + i * ds.dim, q, ds.dim);
        }
        double top0 = gpu_ann::now_ms();
        results[qi] = gpu_ann::topk_from_scores(scores.data(), nullptr, ds.nbase, opt.k);
        topk_ms += gpu_ann::now_ms() - top0;
    }
    stats.total_ms = gpu_ann::now_ms() - total0;
    stats.compute_ms = stats.total_ms - topk_ms;
    stats.topk_ms = topk_ms;
    stats.latency_ms = stats.total_ms / static_cast<double>(ds.nq);
    stats.recall = gpu_ann::recall_at_k(results, ds.gt, ds.gt_dim, opt.k);
    stats.avg_candidates = static_cast<double>(ds.nbase);
    stats.scored_pairs = static_cast<double>(ds.nq) * static_cast<double>(ds.nbase);
    stats.waste_ratio = 1.0;
    return stats;
}

RunStats run_cuda_dense(const gpu_ann::Dataset& ds, const Options& opt, bool tiled) {
    RunStats best;
    float* d_base = nullptr;
    float* d_query = nullptr;
    float* d_scores = nullptr;
    size_t max_scores = static_cast<size_t>(opt.batch) * ds.nbase;
    cuda_check(cudaMalloc(&d_base, ds.base.size() * sizeof(float)), "cudaMalloc base");
    cuda_check(cudaMalloc(&d_query, static_cast<size_t>(opt.batch) * ds.dim * sizeof(float)), "cudaMalloc query");
    cuda_check(cudaMalloc(&d_scores, max_scores * sizeof(float)), "cudaMalloc scores");
    cuda_check(cudaMemcpy(d_base, ds.base.data(), ds.base.size() * sizeof(float), cudaMemcpyHostToDevice), "copy base");

    std::vector<float> host_scores(max_scores);
    cudaEvent_t ev0, ev1;
    cuda_check(cudaEventCreate(&ev0), "event create");
    cuda_check(cudaEventCreate(&ev1), "event create");

    for (int rep = 0; rep < opt.repeat; ++rep) {
        std::vector<std::vector<uint32_t> > results(ds.nq);
        RunStats stats;
        double total0 = gpu_ann::now_ms();
        for (size_t q0 = 0; q0 < ds.nq; q0 += static_cast<size_t>(opt.batch)) {
            int bsz = static_cast<int>(std::min<size_t>(opt.batch, ds.nq - q0));
            cuda_check(cudaMemcpy(d_query, ds.query.data() + q0 * ds.dim,
                                  static_cast<size_t>(bsz) * ds.dim * sizeof(float),
                                  cudaMemcpyHostToDevice), "copy query");
            cuda_check(cudaEventRecord(ev0), "event record start");
            if (tiled) {
                dim3 block(16, 16);
                dim3 grid((static_cast<int>(ds.nbase) + 15) / 16, (bsz + 15) / 16);
                dense_tiled_kernel<<<grid, block>>>(d_base, d_query, d_scores,
                                                    static_cast<int>(ds.nbase), bsz,
                                                    static_cast<int>(ds.dim));
            } else {
                int total = static_cast<int>(ds.nbase) * bsz;
                dense_naive_kernel<<<(total + 255) / 256, 256>>>(d_base, d_query, d_scores,
                                                                 static_cast<int>(ds.nbase), bsz,
                                                                 static_cast<int>(ds.dim));
            }
            cuda_check(cudaGetLastError(), "dense kernel");
            cuda_check(cudaEventRecord(ev1), "event record stop");
            cuda_check(cudaEventSynchronize(ev1), "event sync");
            float kernel_ms = 0.0f;
            cuda_check(cudaEventElapsedTime(&kernel_ms, ev0, ev1), "event elapsed");
            stats.compute_ms += kernel_ms;
            cuda_check(cudaMemcpy(host_scores.data(), d_scores,
                                  static_cast<size_t>(bsz) * ds.nbase * sizeof(float),
                                  cudaMemcpyDeviceToHost), "copy scores");
            double top0 = gpu_ann::now_ms();
            for (int q = 0; q < bsz; ++q) {
                results[q0 + q] = gpu_ann::topk_from_scores(host_scores.data() + static_cast<size_t>(q) * ds.nbase,
                                                            nullptr, ds.nbase, opt.k);
            }
            stats.topk_ms += gpu_ann::now_ms() - top0;
        }
        stats.total_ms = gpu_ann::now_ms() - total0;
        stats.latency_ms = stats.total_ms / static_cast<double>(ds.nq);
        stats.recall = gpu_ann::recall_at_k(results, ds.gt, ds.gt_dim, opt.k);
        stats.avg_candidates = static_cast<double>(ds.nbase);
        stats.scored_pairs = static_cast<double>(ds.nq) * static_cast<double>(ds.nbase);
        stats.waste_ratio = 1.0;
        if (stats.latency_ms < best.latency_ms) best = stats;
    }

    cuda_check(cudaEventDestroy(ev0), "event destroy");
    cuda_check(cudaEventDestroy(ev1), "event destroy");
    cuda_check(cudaFree(d_scores), "free scores");
    cuda_check(cudaFree(d_query), "free query");
    cuda_check(cudaFree(d_base), "free base");
    return best;
}

RunStats run_cuda_cublas(const gpu_ann::Dataset& ds, const Options& opt) {
    RunStats best;
    float* d_base = nullptr;
    float* d_query = nullptr;
    float* d_scores = nullptr;
    size_t max_scores = static_cast<size_t>(opt.batch) * ds.nbase;
    cuda_check(cudaMalloc(&d_base, ds.base.size() * sizeof(float)), "cudaMalloc base");
    cuda_check(cudaMalloc(&d_query, static_cast<size_t>(opt.batch) * ds.dim * sizeof(float)), "cudaMalloc query");
    cuda_check(cudaMalloc(&d_scores, max_scores * sizeof(float)), "cudaMalloc scores");
    cuda_check(cudaMemcpy(d_base, ds.base.data(), ds.base.size() * sizeof(float), cudaMemcpyHostToDevice), "copy base");

    cublasHandle_t handle = nullptr;
    cublas_check(cublasCreate(&handle), "cublasCreate");
    std::vector<float> host_scores(max_scores);
    cudaEvent_t ev0, ev1;
    cuda_check(cudaEventCreate(&ev0), "event create");
    cuda_check(cudaEventCreate(&ev1), "event create");

    for (int rep = 0; rep < opt.repeat; ++rep) {
        std::vector<std::vector<uint32_t> > results(ds.nq);
        RunStats stats;
        double total0 = gpu_ann::now_ms();
        for (size_t q0 = 0; q0 < ds.nq; q0 += static_cast<size_t>(opt.batch)) {
            int bsz = static_cast<int>(std::min<size_t>(opt.batch, ds.nq - q0));
            cuda_check(cudaMemcpy(d_query, ds.query.data() + q0 * ds.dim,
                                  static_cast<size_t>(bsz) * ds.dim * sizeof(float),
                                  cudaMemcpyHostToDevice), "copy query");
            float alpha = 1.0f;
            float beta = 0.0f;
            cuda_check(cudaEventRecord(ev0), "event record start");
            cublas_check(cublasSgemm(handle, CUBLAS_OP_T, CUBLAS_OP_N,
                                     static_cast<int>(ds.nbase), bsz, static_cast<int>(ds.dim),
                                     &alpha, d_base, static_cast<int>(ds.dim),
                                     d_query, static_cast<int>(ds.dim),
                                     &beta, d_scores, static_cast<int>(ds.nbase)),
                         "cublasSgemm");
            cuda_check(cudaEventRecord(ev1), "event record stop");
            cuda_check(cudaEventSynchronize(ev1), "event sync");
            float kernel_ms = 0.0f;
            cuda_check(cudaEventElapsedTime(&kernel_ms, ev0, ev1), "event elapsed");
            stats.compute_ms += kernel_ms;
            cuda_check(cudaMemcpy(host_scores.data(), d_scores,
                                  static_cast<size_t>(bsz) * ds.nbase * sizeof(float),
                                  cudaMemcpyDeviceToHost), "copy scores");
            double top0 = gpu_ann::now_ms();
            for (int q = 0; q < bsz; ++q) {
                results[q0 + q] = gpu_ann::topk_from_scores(host_scores.data() + static_cast<size_t>(q) * ds.nbase,
                                                            nullptr, ds.nbase, opt.k);
            }
            stats.topk_ms += gpu_ann::now_ms() - top0;
        }
        stats.total_ms = gpu_ann::now_ms() - total0;
        stats.latency_ms = stats.total_ms / static_cast<double>(ds.nq);
        stats.recall = gpu_ann::recall_at_k(results, ds.gt, ds.gt_dim, opt.k);
        stats.avg_candidates = static_cast<double>(ds.nbase);
        stats.scored_pairs = static_cast<double>(ds.nq) * static_cast<double>(ds.nbase);
        stats.waste_ratio = 1.0;
        if (stats.latency_ms < best.latency_ms) best = stats;
    }

    cuda_check(cudaEventDestroy(ev0), "event destroy");
    cuda_check(cudaEventDestroy(ev1), "event destroy");
    cublas_check(cublasDestroy(handle), "cublasDestroy");
    cuda_check(cudaFree(d_scores), "free scores");
    cuda_check(cudaFree(d_query), "free query");
    cuda_check(cudaFree(d_base), "free base");
    return best;
}

RunStats run_cuda_ivf(const gpu_ann::Dataset& ds, const Options& opt) {
    double build0 = gpu_ann::now_ms();
    gpu_ann::IvfIndex index = gpu_ann::build_ivf(ds.base, ds.nbase, ds.dim, opt.nlist, opt.iters);
    double build_ms = gpu_ann::now_ms() - build0;

    RunStats best;
    best.build_ms = build_ms;
    float* d_base = nullptr;
    float* d_query = nullptr;
    int* d_candidates = nullptr;
    float* d_scores = nullptr;
    size_t candidate_capacity = 1;
    size_t score_capacity = 1;
    cuda_check(cudaMalloc(&d_base, ds.base.size() * sizeof(float)), "cudaMalloc base");
    cuda_check(cudaMalloc(&d_query, static_cast<size_t>(opt.batch) * ds.dim * sizeof(float)), "cudaMalloc query");
    cuda_check(cudaMalloc(&d_candidates, candidate_capacity * sizeof(int)), "cudaMalloc candidates");
    cuda_check(cudaMalloc(&d_scores, score_capacity * sizeof(float)), "cudaMalloc scores");
    cuda_check(cudaMemcpy(d_base, ds.base.data(), ds.base.size() * sizeof(float), cudaMemcpyHostToDevice), "copy base");

    cudaEvent_t ev0, ev1;
    cuda_check(cudaEventCreate(&ev0), "event create");
    cuda_check(cudaEventCreate(&ev1), "event create");

    for (int rep = 0; rep < opt.repeat; ++rep) {
        std::vector<std::vector<uint32_t> > results(ds.nq);
        RunStats stats;
        stats.build_ms = build_ms;
        double total0 = gpu_ann::now_ms();
        double candidate_sum = 0.0;
        double scored_sum = 0.0;
        for (size_t q0 = 0; q0 < ds.nq; q0 += static_cast<size_t>(opt.batch)) {
            int bsz = static_cast<int>(std::min<size_t>(opt.batch, ds.nq - q0));
            double cand0 = gpu_ann::now_ms();
            std::vector<std::vector<int> > per_query(bsz);
            size_t max_candidates = 0;
            for (int q = 0; q < bsz; ++q) {
                per_query[q] = gpu_ann::collect_ivf_candidates(index, ds.query.data() + (q0 + q) * ds.dim, opt.nprobe);
                max_candidates = std::max(max_candidates, per_query[q].size());
                candidate_sum += static_cast<double>(per_query[q].size());
            }
            max_candidates = std::max<size_t>(1, max_candidates);
            std::vector<int> candidate_host(static_cast<size_t>(bsz) * max_candidates, -1);
            for (int q = 0; q < bsz; ++q) {
                std::copy(per_query[q].begin(), per_query[q].end(),
                          candidate_host.begin() + static_cast<size_t>(q) * max_candidates);
            }
            stats.candidate_ms += gpu_ann::now_ms() - cand0;

            size_t needed = static_cast<size_t>(bsz) * max_candidates;
            scored_sum += static_cast<double>(needed);
            if (needed > candidate_capacity) {
                cuda_check(cudaFree(d_candidates), "free candidates grow");
                cuda_check(cudaMalloc(&d_candidates, needed * sizeof(int)), "cudaMalloc candidates grow");
                candidate_capacity = needed;
            }
            if (needed > score_capacity) {
                cuda_check(cudaFree(d_scores), "free scores grow");
                cuda_check(cudaMalloc(&d_scores, needed * sizeof(float)), "cudaMalloc scores grow");
                score_capacity = needed;
            }
            cuda_check(cudaMemcpy(d_query, ds.query.data() + q0 * ds.dim,
                                  static_cast<size_t>(bsz) * ds.dim * sizeof(float),
                                  cudaMemcpyHostToDevice), "copy query");
            cuda_check(cudaMemcpy(d_candidates, candidate_host.data(),
                                  needed * sizeof(int), cudaMemcpyHostToDevice), "copy candidates");
            cuda_check(cudaEventRecord(ev0), "event start");
            ivf_candidate_kernel<<<(static_cast<int>(needed) + 255) / 256, 256>>>(
                d_base, d_query, d_candidates, d_scores, bsz,
                static_cast<int>(max_candidates), static_cast<int>(ds.dim));
            cuda_check(cudaGetLastError(), "ivf candidate kernel");
            cuda_check(cudaEventRecord(ev1), "event stop");
            cuda_check(cudaEventSynchronize(ev1), "event sync");
            float kernel_ms = 0.0f;
            cuda_check(cudaEventElapsedTime(&kernel_ms, ev0, ev1), "event elapsed");
            stats.compute_ms += kernel_ms;
            std::vector<float> host_scores(needed);
            cuda_check(cudaMemcpy(host_scores.data(), d_scores, needed * sizeof(float), cudaMemcpyDeviceToHost),
                       "copy ivf scores");
            double top0 = gpu_ann::now_ms();
            for (int q = 0; q < bsz; ++q) {
                results[q0 + q] = gpu_ann::topk_from_scores(
                    host_scores.data() + static_cast<size_t>(q) * max_candidates,
                    candidate_host.data() + static_cast<size_t>(q) * max_candidates,
                    max_candidates, opt.k);
            }
            stats.topk_ms += gpu_ann::now_ms() - top0;
        }
        stats.total_ms = gpu_ann::now_ms() - total0;
        stats.latency_ms = stats.total_ms / static_cast<double>(ds.nq);
        stats.recall = gpu_ann::recall_at_k(results, ds.gt, ds.gt_dim, opt.k);
        stats.avg_candidates = candidate_sum / static_cast<double>(ds.nq);
        stats.scored_pairs = scored_sum;
        stats.waste_ratio = candidate_sum > 0.0 ? scored_sum / candidate_sum : 1.0;
        if (stats.latency_ms < best.latency_ms) best = stats;
    }

    cuda_check(cudaEventDestroy(ev0), "event destroy");
    cuda_check(cudaEventDestroy(ev1), "event destroy");
    cuda_check(cudaFree(d_scores), "free scores");
    cuda_check(cudaFree(d_candidates), "free candidates");
    cuda_check(cudaFree(d_query), "free query");
    cuda_check(cudaFree(d_base), "free base");
    return best;
}

RunStats run_cuda_ivf_cluster(const gpu_ann::Dataset& ds, const Options& opt, bool grouped) {
    double build0 = gpu_ann::now_ms();
    gpu_ann::IvfIndex index = gpu_ann::build_ivf(ds.base, ds.nbase, ds.dim, opt.nlist, opt.iters);
    double build_ms = gpu_ann::now_ms() - build0;

    RunStats best;
    best.build_ms = build_ms;
    float* d_base = nullptr;
    float* d_query = nullptr;
    int* d_cluster_ids = nullptr;
    float* d_scores = nullptr;
    size_t id_capacity = 1;
    size_t score_capacity = 1;
    cuda_check(cudaMalloc(&d_base, ds.base.size() * sizeof(float)), "cudaMalloc base");
    cuda_check(cudaMalloc(&d_query, static_cast<size_t>(opt.batch) * ds.dim * sizeof(float)), "cudaMalloc query");
    cuda_check(cudaMalloc(&d_cluster_ids, id_capacity * sizeof(int)), "cudaMalloc cluster ids");
    cuda_check(cudaMalloc(&d_scores, score_capacity * sizeof(float)), "cudaMalloc cluster scores");
    cuda_check(cudaMemcpy(d_base, ds.base.data(), ds.base.size() * sizeof(float), cudaMemcpyHostToDevice), "copy base");

    cudaEvent_t ev0, ev1;
    cuda_check(cudaEventCreate(&ev0), "event create");
    cuda_check(cudaEventCreate(&ev1), "event create");

    for (int rep = 0; rep < opt.repeat; ++rep) {
        std::vector<std::vector<uint32_t> > results(ds.nq);
        RunStats stats;
        stats.build_ms = build_ms;
        double total0 = gpu_ann::now_ms();

        double cand0 = gpu_ann::now_ms();
        std::vector<std::vector<int> > all_probes(ds.nq);
        std::vector<size_t> order(ds.nq);
        for (size_t qi = 0; qi < ds.nq; ++qi) {
            all_probes[qi] = gpu_ann::top_probe_ids(index, ds.query.data() + qi * ds.dim, opt.nprobe);
            order[qi] = qi;
        }
        if (grouped) {
            std::sort(order.begin(), order.end(), [&](size_t a, size_t b) {
                int ca = all_probes[a].empty() ? 0 : all_probes[a][0];
                int cb = all_probes[b].empty() ? 0 : all_probes[b][0];
                if (ca != cb) return ca < cb;
                return a < b;
            });
        }
        stats.candidate_ms += gpu_ann::now_ms() - cand0;

        double candidate_sum = 0.0;
        std::vector<float> query_batch(static_cast<size_t>(opt.batch) * ds.dim);
        for (size_t p0 = 0; p0 < order.size(); p0 += static_cast<size_t>(opt.batch)) {
            int bsz = static_cast<int>(std::min<size_t>(opt.batch, order.size() - p0));
            for (int q = 0; q < bsz; ++q) {
                size_t qi = order[p0 + static_cast<size_t>(q)];
                std::copy(ds.query.begin() + static_cast<std::ptrdiff_t>(qi * ds.dim),
                          ds.query.begin() + static_cast<std::ptrdiff_t>((qi + 1) * ds.dim),
                          query_batch.begin() + static_cast<std::ptrdiff_t>(static_cast<size_t>(q) * ds.dim));
            }
            cuda_check(cudaMemcpy(d_query, query_batch.data(),
                                  static_cast<size_t>(bsz) * ds.dim * sizeof(float),
                                  cudaMemcpyHostToDevice), "copy query batch");

            cand0 = gpu_ann::now_ms();
            std::vector<unsigned char> selected(static_cast<size_t>(bsz) * index.nlist, 0);
            std::vector<int> unique_clusters;
            unique_clusters.reserve(static_cast<size_t>(bsz) * opt.nprobe);
            for (int q = 0; q < bsz; ++q) {
                size_t qi = order[p0 + static_cast<size_t>(q)];
                for (int c : all_probes[qi]) {
                    selected[static_cast<size_t>(q) * index.nlist + c] = 1;
                    unique_clusters.push_back(c);
                }
            }
            std::sort(unique_clusters.begin(), unique_clusters.end());
            unique_clusters.erase(std::unique(unique_clusters.begin(), unique_clusters.end()),
                                  unique_clusters.end());
            stats.candidate_ms += gpu_ann::now_ms() - cand0;

            std::vector<std::vector<int> > batch_ids(bsz);
            std::vector<std::vector<float> > batch_scores(bsz);
            for (int c : unique_clusters) {
                const std::vector<int>& ids = index.lists[c];
                if (ids.empty()) continue;
                size_t list_size = ids.size();
                if (list_size > id_capacity) {
                    cuda_check(cudaFree(d_cluster_ids), "free cluster ids grow");
                    cuda_check(cudaMalloc(&d_cluster_ids, list_size * sizeof(int)), "cudaMalloc cluster ids grow");
                    id_capacity = list_size;
                }
                size_t needed = static_cast<size_t>(bsz) * list_size;
                if (needed > score_capacity) {
                    cuda_check(cudaFree(d_scores), "free cluster scores grow");
                    cuda_check(cudaMalloc(&d_scores, needed * sizeof(float)), "cudaMalloc cluster scores grow");
                    score_capacity = needed;
                }
                cuda_check(cudaMemcpy(d_cluster_ids, ids.data(), list_size * sizeof(int),
                                      cudaMemcpyHostToDevice), "copy cluster ids");
                cuda_check(cudaEventRecord(ev0), "event start");
                ivf_cluster_kernel<<<(static_cast<int>(needed) + 255) / 256, 256>>>(
                    d_base, d_query, d_cluster_ids, d_scores, bsz,
                    static_cast<int>(list_size), static_cast<int>(ds.dim));
                cuda_check(cudaGetLastError(), "ivf cluster kernel");
                cuda_check(cudaEventRecord(ev1), "event stop");
                cuda_check(cudaEventSynchronize(ev1), "event sync");
                float kernel_ms = 0.0f;
                cuda_check(cudaEventElapsedTime(&kernel_ms, ev0, ev1), "event elapsed");
                stats.compute_ms += kernel_ms;
                stats.scored_pairs += static_cast<double>(needed);

                std::vector<float> host_scores(needed);
                cuda_check(cudaMemcpy(host_scores.data(), d_scores, needed * sizeof(float),
                                      cudaMemcpyDeviceToHost), "copy cluster scores");
                for (int q = 0; q < bsz; ++q) {
                    if (!selected[static_cast<size_t>(q) * index.nlist + c]) continue;
                    size_t old = batch_scores[q].size();
                    batch_scores[q].resize(old + list_size);
                    batch_ids[q].resize(old + list_size);
                    std::copy(host_scores.begin() + static_cast<std::ptrdiff_t>(static_cast<size_t>(q) * list_size),
                              host_scores.begin() + static_cast<std::ptrdiff_t>((static_cast<size_t>(q) + 1) * list_size),
                              batch_scores[q].begin() + static_cast<std::ptrdiff_t>(old));
                    std::copy(ids.begin(), ids.end(), batch_ids[q].begin() + static_cast<std::ptrdiff_t>(old));
                    candidate_sum += static_cast<double>(list_size);
                }
            }

            double top0 = gpu_ann::now_ms();
            for (int q = 0; q < bsz; ++q) {
                size_t qi = order[p0 + static_cast<size_t>(q)];
                results[qi] = gpu_ann::topk_from_scores(batch_scores[q].data(),
                                                        batch_ids[q].data(),
                                                        batch_scores[q].size(), opt.k);
            }
            stats.topk_ms += gpu_ann::now_ms() - top0;
        }
        stats.total_ms = gpu_ann::now_ms() - total0;
        stats.latency_ms = stats.total_ms / static_cast<double>(ds.nq);
        stats.recall = gpu_ann::recall_at_k(results, ds.gt, ds.gt_dim, opt.k);
        stats.avg_candidates = candidate_sum / static_cast<double>(ds.nq);
        stats.waste_ratio = candidate_sum > 0.0 ? stats.scored_pairs / candidate_sum : 1.0;
        if (stats.latency_ms < best.latency_ms) best = stats;
    }

    cuda_check(cudaEventDestroy(ev0), "event destroy");
    cuda_check(cudaEventDestroy(ev1), "event destroy");
    cuda_check(cudaFree(d_scores), "free cluster scores");
    cuda_check(cudaFree(d_cluster_ids), "free cluster ids");
    cuda_check(cudaFree(d_query), "free query");
    cuda_check(cudaFree(d_base), "free base");
    return best;
}

}  // namespace

int main(int argc, char** argv) {
    Options opt = parse_options(argc, argv);
    gpu_ann::Dataset ds = gpu_ann::load_dataset(opt.data_dir, opt.nbase, opt.nq);
    opt.nbase = ds.nbase;
    opt.nq = ds.nq;
    if (!ds.gt_matches_current_base || ds.gt_dim < opt.k) {
        double gt0 = gpu_ann::now_ms();
        gpu_ann::recompute_groundtruth_for_current_base(ds, opt.k);
        std::cout << "Evaluation ground truth recomputed for current base subset in "
                  << (gpu_ann::now_ms() - gt0) << " ms\n";
    }

    std::string device = gpu_name();
    std::cout << "GPU ANN method=" << opt.method
              << " device=" << device
              << " nbase=" << ds.nbase
              << " nq=" << ds.nq
              << " dim=" << ds.dim
              << " batch=" << opt.batch
              << " nprobe=" << opt.nprobe << "\n";

    RunStats stats;
    if (opt.method == "cpu_flat") {
        stats = run_cpu_flat(ds, opt);
    } else if (opt.method == "cuda_flat_naive") {
        stats = run_cuda_dense(ds, opt, false);
    } else if (opt.method == "cuda_flat_tiled") {
        stats = run_cuda_dense(ds, opt, true);
    } else if (opt.method == "cuda_flat_cublas") {
        stats = run_cuda_cublas(ds, opt);
    } else if (opt.method == "cuda_ivf") {
        stats = run_cuda_ivf(ds, opt);
    } else if (opt.method == "cuda_ivf_cluster") {
        stats = run_cuda_ivf_cluster(ds, opt, false);
    } else if (opt.method == "cuda_ivf_cluster_grouped") {
        stats = run_cuda_ivf_cluster(ds, opt, true);
    } else {
        std::cerr << "Unknown method: " << opt.method << "\n";
        return 2;
    }

    std::vector<std::string> header = {
        "experiment", "method", "device", "nbase", "nq", "dim", "k", "batch",
        "nlist", "nprobe", "iters", "repeat", "build_ms", "candidate_ms",
        "compute_ms", "topk_ms", "total_ms", "latency_ms", "recall@100",
        "avg_candidates", "scored_pairs", "waste_ratio", "notes"
    };
    std::vector<std::string> row = {
        "GPU-ANN", opt.method, device, std::to_string(ds.nbase), std::to_string(ds.nq),
        std::to_string(ds.dim), std::to_string(opt.k), std::to_string(opt.batch),
        std::to_string(opt.nlist), std::to_string(opt.nprobe), std::to_string(opt.iters),
        std::to_string(opt.repeat), gpu_ann::f6(stats.build_ms), gpu_ann::f6(stats.candidate_ms),
        gpu_ann::f6(stats.compute_ms), gpu_ann::f6(stats.topk_ms), gpu_ann::f6(stats.total_ms),
        gpu_ann::f6(stats.latency_ms), gpu_ann::f6(stats.recall), gpu_ann::f6(stats.avg_candidates),
        gpu_ann::f6(stats.scored_pairs), gpu_ann::f6(stats.waste_ratio),
        opt.smoke ? "smoke" : "full"
    };
    gpu_ann::append_csv_row(opt.csv, header, row);

    std::cout << "RESULT latency_ms=" << stats.latency_ms
              << " recall@100=" << stats.recall
              << " build_ms=" << stats.build_ms
              << " compute_ms=" << stats.compute_ms
              << " topk_ms=" << stats.topk_ms
              << " csv=" << opt.csv << "\n";
    return 0;
}
