/*
 * Optional advanced benchmark: CUDA flat exact search on NVIDIA GPU.
 *
 * This is an accelerator comparison for the Pthread report. It is separate
 * from OpenMP target offload because nvcc compiles CUDA kernels, not OpenMP
 * target regions.
 *
 * Windows:
 *   nvcc -O2 -std=c++17 -I. pthread_cuda_flat.cu -o pthread_cuda_flat.exe
 *   .\pthread_cuda_flat.exe --data D:/Parallel-programming-NKU/anndata --nq 1000
 *
 * Linux:
 *   nvcc -O2 -std=c++17 -I. pthread_cuda_flat.cu -o pthread_cuda_flat
 *   ./pthread_cuda_flat --data ../anndata --nq 1000
 */
#include "pthread_common.h"

#include <cuda_runtime.h>

#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <queue>
#include <string>
#include <vector>

using namespace pthread_ann;

namespace {

const size_t kRecallAt = 100;

struct Config {
    std::string data_dir;
    size_t nq;
    int device;
    double baseline_ms;
    Config() : data_dir("../anndata"), nq(1000), device(0), baseline_ms(0.0) {}
};

void check_cuda(cudaError_t err, const char* expr, const char* file, int line) {
    if (err != cudaSuccess) {
        std::cerr << "CUDA error at " << file << ":" << line << " for " << expr
                  << ": " << cudaGetErrorString(err) << "\n";
        std::exit(2);
    }
}

#define CHECK_CUDA(expr) check_cuda((expr), #expr, __FILE__, __LINE__)

Config parse_args(int argc, char** argv) {
    Config cfg;
    for (int i = 1; i < argc; ++i) {
        std::string a(argv[i]);
        if (a == "--data" && i + 1 < argc) cfg.data_dir = argv[++i];
        else if (a == "--nq" && i + 1 < argc) cfg.nq = static_cast<size_t>(std::atoi(argv[++i]));
        else if (a == "--device" && i + 1 < argc) cfg.device = std::atoi(argv[++i]);
        else if (a == "--baseline-ms" && i + 1 < argc) cfg.baseline_ms = std::atof(argv[++i]);
    }
    return cfg;
}

__global__ void flat_ip_distance_kernel(const float* base,
                                        const float* query,
                                        float* dist,
                                        int n,
                                        int dim) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i >= n) return;
    const float* b = base + static_cast<size_t>(i) * dim;
    float dot = 0.0f;
    for (int d = 0; d < dim; ++d) {
        dot += b[d] * query[d];
    }
    dist[i] = 1.0f - dot;
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

std::priority_queue<std::pair<float, uint32_t> >
select_topk_from_dist(const std::vector<float>& dist, size_t k) {
    std::priority_queue<std::pair<float, uint32_t> > heap;
    for (size_t i = 0; i < dist.size(); ++i) {
        push_topk(heap, dist[i], static_cast<uint32_t>(i), k);
    }
    return heap;
}

double recall_at_k(std::priority_queue<std::pair<float, uint32_t> > heap,
                   const int* gt,
                   size_t gt_d,
                   size_t qid,
                   size_t k) {
    std::vector<uint32_t> truth(k);
    for (size_t i = 0; i < k; ++i) truth[i] = static_cast<uint32_t>(gt[qid * gt_d + i]);
    std::sort(truth.begin(), truth.end());

    size_t hit = 0;
    while (!heap.empty()) {
        if (std::binary_search(truth.begin(), truth.end(), heap.top().second)) ++hit;
        heap.pop();
    }
    return static_cast<double>(hit) / static_cast<double>(k);
}

} // namespace

int main(int argc, char** argv) {
    Config cfg = parse_args(argc, argv);
    ensure_dir("files");
    ensure_dir("files/results");

    int device_count = 0;
    CHECK_CUDA(cudaGetDeviceCount(&device_count));
    if (device_count <= 0) {
        std::cerr << "FATAL: no CUDA device found\n";
        return 2;
    }
    if (cfg.device < 0 || cfg.device >= device_count) cfg.device = 0;
    CHECK_CUDA(cudaSetDevice(cfg.device));
    cudaDeviceProp prop;
    CHECK_CUDA(cudaGetDeviceProperties(&prop, cfg.device));

    size_t base_n = 0, base_d = 0, query_n = 0, query_d = 0, gt_n = 0, gt_d = 0;
    float* base = load_data<float>(join_path(cfg.data_dir, "DEEP100K.base.100k.fbin"), base_n, base_d);
    float* query = load_data<float>(join_path(cfg.data_dir, "DEEP100K.query.fbin"), query_n, query_d);
    int* gt = load_data<int>(join_path(cfg.data_dir, "DEEP100K.gt.query.100k.top100.bin"), gt_n, gt_d);
    if (base_d != query_d || gt_d < kRecallAt) {
        std::cerr << "FATAL: incompatible data dimensions\n";
        return 2;
    }

    size_t nq = std::min(cfg.nq, std::min(query_n, gt_n));
    std::vector<float> dist(base_n);

    float* d_base = NULL;
    float* d_query = NULL;
    float* d_dist = NULL;
    CHECK_CUDA(cudaMalloc(&d_base, base_n * base_d * sizeof(float)));
    CHECK_CUDA(cudaMalloc(&d_query, base_d * sizeof(float)));
    CHECK_CUDA(cudaMalloc(&d_dist, base_n * sizeof(float)));
    CHECK_CUDA(cudaMemcpy(d_base, base, base_n * base_d * sizeof(float), cudaMemcpyHostToDevice));

    const int block = 256;
    const int grid = static_cast<int>((base_n + block - 1) / block);
    double recall_sum = 0.0;
    double select_us_sum = 0.0;
    double transfer_kernel_us_sum = 0.0;

    CHECK_CUDA(cudaDeviceSynchronize());
    long long t0 = now_us();
    for (size_t qi = 0; qi < nq; ++qi) {
        long long scan_t0 = now_us();
        CHECK_CUDA(cudaMemcpy(d_query, query + qi * query_d,
                              base_d * sizeof(float), cudaMemcpyHostToDevice));
        flat_ip_distance_kernel<<<grid, block>>>(d_base, d_query, d_dist,
                                                 static_cast<int>(base_n),
                                                 static_cast<int>(base_d));
        CHECK_CUDA(cudaGetLastError());
        CHECK_CUDA(cudaMemcpy(dist.data(), d_dist, base_n * sizeof(float),
                              cudaMemcpyDeviceToHost));
        transfer_kernel_us_sum += static_cast<double>(now_us() - scan_t0);

        long long select_t0 = now_us();
        std::priority_queue<std::pair<float, uint32_t> > heap =
            select_topk_from_dist(dist, kRecallAt);
        select_us_sum += static_cast<double>(now_us() - select_t0);
        recall_sum += recall_at_k(heap, gt, gt_d, qi, kRecallAt);
    }
    CHECK_CUDA(cudaDeviceSynchronize());
    double total_us = static_cast<double>(now_us() - t0);

    double latency_ms = total_us / 1000.0 / static_cast<double>(nq);
    double recall = recall_sum / static_cast<double>(nq);
    double scan_us = transfer_kernel_us_sum / static_cast<double>(nq);
    double select_us = select_us_sum / static_cast<double>(nq);
    double speedup = cfg.baseline_ms > 0.0 ? cfg.baseline_ms / latency_ms : 0.0;

    std::ofstream out("files/results/pthread_cuda_results.csv");
    out << "experiment,method,nthreads,param1,param2,latency_ms,recall@100,speedup,"
        << "index_mb,build_sec,encode_us,lut_us,scan_us,select_us,rerank_us,notes\n";
    out << "CUDA-Flat,ExactGPU,0,device," << cfg.device
        << "," << latency_ms
        << "," << recall
        << "," << speedup
        << ",0,0,0,0," << scan_us
        << "," << select_us
        << ",0,\"" << prop.name << "\"\n";

    std::cout << "CUDA flat exact search: nq=" << nq
              << " device=" << prop.name
              << " latency_ms=" << latency_ms
              << " recall@100=" << recall
              << " speedup=" << speedup
              << " scan_transfer_us=" << scan_us
              << " select_us=" << select_us << "\n";

    CHECK_CUDA(cudaFree(d_base));
    CHECK_CUDA(cudaFree(d_query));
    CHECK_CUDA(cudaFree(d_dist));
    delete[] base;
    delete[] query;
    delete[] gt;
    return 0;
}
