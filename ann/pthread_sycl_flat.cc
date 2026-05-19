/*
 * Optional advanced benchmark: oneAPI/SYCL flat search.
 *
 * Compile on a oneAPI-capable machine:
 *   icpx -fsycl pthread_sycl_flat.cc -o pthread_sycl_flat -O2 -std=c++17 -I.
 * or:
 *   dpcpp pthread_sycl_flat.cc -o pthread_sycl_flat -O2 -std=c++17 -I.
 */
#include "pthread_common.h"

#include <sycl/sycl.hpp>

#include <algorithm>
#include <cstdint>
#include <cstdlib>
#include <exception>
#include <fstream>
#include <iostream>
#include <limits>
#include <queue>
#include <sstream>
#include <string>
#include <vector>

using namespace pthread_ann;

namespace {

const size_t kRecallAt = 100;

struct Config {
    std::string data_dir;
    std::string device;
    std::string method;
    std::string notes;
    std::string csv_path;
    std::string best_csv_path;
    std::string algo;
    std::string nprobe_list_arg;
    size_t batch_size;
    int query_block;
    int nlist;
    int kmeans_iters;
    int workgroup_size;
    int local_k;
    size_t nq;
    double baseline_ms;
    double target_recall;
    Config()
        : data_dir("../anndata"),
          device("intel-gpu"),
          method("IntelOpenCLGPU"),
          notes(""),
          csv_path("files/results/pthread_sycl_results.csv"),
          best_csv_path("files/results/pthread_sycl_best.csv"),
          algo("ivf"),
          nprobe_list_arg("76,78,80,82,84"),
          batch_size(1000),
          query_block(16),
          nlist(2048),
          kmeans_iters(12),
          workgroup_size(128),
          local_k(4),
          nq(100),
          baseline_ms(0.0),
          target_recall(0.95) {}
};

Config parse_args(int argc, char** argv) {
    Config cfg;
    for (int i = 1; i < argc; ++i) {
        std::string a(argv[i]);
        if (a == "--data" && i + 1 < argc) cfg.data_dir = argv[++i];
        else if (a == "--device" && i + 1 < argc) cfg.device = argv[++i];
        else if (a == "--method" && i + 1 < argc) cfg.method = argv[++i];
        else if (a == "--notes" && i + 1 < argc) cfg.notes = argv[++i];
        else if (a == "--csv" && i + 1 < argc) cfg.csv_path = argv[++i];
        else if (a == "--best-csv" && i + 1 < argc) cfg.best_csv_path = argv[++i];
        else if (a == "--algo" && i + 1 < argc) cfg.algo = argv[++i];
        else if (a == "--nprobe-list" && i + 1 < argc) cfg.nprobe_list_arg = argv[++i];
        else if (a == "--batch" && i + 1 < argc) cfg.batch_size = static_cast<size_t>(std::atoi(argv[++i]));
        else if (a == "--query-block" && i + 1 < argc) cfg.query_block = std::atoi(argv[++i]);
        else if (a == "--nlist" && i + 1 < argc) cfg.nlist = std::atoi(argv[++i]);
        else if (a == "--iters" && i + 1 < argc) cfg.kmeans_iters = std::atoi(argv[++i]);
        else if (a == "--workgroup-size" && i + 1 < argc) cfg.workgroup_size = std::atoi(argv[++i]);
        else if (a == "--local-k" && i + 1 < argc) cfg.local_k = std::atoi(argv[++i]);
        else if (a == "--nq" && i + 1 < argc) cfg.nq = static_cast<size_t>(std::atoi(argv[++i]));
        else if (a == "--baseline-ms" && i + 1 < argc) cfg.baseline_ms = std::atof(argv[++i]);
        else if (a == "--target-recall" && i + 1 < argc) cfg.target_recall = std::atof(argv[++i]);
    }
    if (cfg.batch_size == 0) cfg.batch_size = 1;
    if (cfg.query_block != 1 && cfg.query_block != 2 &&
        cfg.query_block != 4 && cfg.query_block != 8 &&
        cfg.query_block != 16) {
        cfg.query_block = 16;
    }
    if (cfg.nlist <= 0) cfg.nlist = 512;
    if (cfg.kmeans_iters <= 0) cfg.kmeans_iters = 12;
    if (cfg.workgroup_size != 64 && cfg.workgroup_size != 128 && cfg.workgroup_size != 256) {
        cfg.workgroup_size = 128;
    }
    if (cfg.local_k != 4 && cfg.local_k != 8 && cfg.local_k != 16) cfg.local_k = 4;
    if (cfg.target_recall <= 0.0 || cfg.target_recall > 1.0) cfg.target_recall = 0.95;
    return cfg;
}

struct AnnDeviceSelector {
    std::string mode;
    explicit AnnDeviceSelector(const std::string& mode_) : mode(mode_) {}

    int operator()(const sycl::device& dev) const {
        std::string name = dev.get_info<sycl::info::device::name>();
        std::string vendor = dev.get_info<sycl::info::device::vendor>();
        bool intel = vendor.find("Intel") != std::string::npos ||
                     name.find("Intel") != std::string::npos;

        if (mode == "intel-gpu") return dev.is_gpu() && intel ? 1000 : -1;
        if (mode == "gpu") return dev.is_gpu() ? 900 : -1;
        if (mode == "cpu") return dev.is_cpu() ? 800 : -1;
        if (mode == "default") return 1;
        return -1;
    }
};

sycl::queue make_queue(const std::string& mode) {
    auto async_handler = [](sycl::exception_list exceptions) {
        for (std::exception_ptr const& e : exceptions) {
            try {
                std::rethrow_exception(e);
            } catch (const sycl::exception& ex) {
                std::cerr << "SYCL async exception: " << ex.what() << "\n";
            }
        }
    };
    return sycl::queue(AnnDeviceSelector(mode), async_handler,
                       sycl::property::queue::in_order());
}

std::string csv_quote(const std::string& s) {
    std::string out = "\"";
    for (size_t i = 0; i < s.size(); ++i) {
        if (s[i] == '"') out += "\"\"";
        else out += s[i];
    }
    out += "\"";
    return out;
}

bool needs_header(const std::string& path) {
    std::ifstream in(path.c_str(), std::ios::binary);
    if (!in.good()) return true;
    in.seekg(0, std::ios::end);
    return in.tellg() == std::streampos(0);
}

std::vector<int> parse_int_list(const std::string& text) {
    std::vector<int> values;
    std::stringstream ss(text);
    std::string item;
    while (std::getline(ss, item, ',')) {
        int v = std::atoi(item.c_str());
        if (v > 0) values.push_back(v);
    }
    if (values.empty()) values.push_back(32);
    std::sort(values.begin(), values.end());
    values.erase(std::unique(values.begin(), values.end()), values.end());
    return values;
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

std::priority_queue<std::pair<float, uint32_t> >
select_topk_from_dist_ptr(const float* dist, size_t n, size_t k) {
    std::priority_queue<std::pair<float, uint32_t> > heap;
    for (size_t i = 0; i < n; ++i) {
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

struct SimpleIVFIndex {
    size_t n;
    size_t d;
    int nlist;
    std::vector<float> centroids;
    std::vector<std::vector<uint32_t> > lists;
};

void build_simple_ivf_index(const float* base,
                            size_t n,
                            size_t d,
                            int nlist,
                            int kmeans_iters,
                            SimpleIVFIndex& idx) {
    idx.n = n;
    idx.d = d;
    idx.nlist = std::min<int>(nlist, static_cast<int>(n));
    idx.centroids.assign(static_cast<size_t>(idx.nlist) * d, 0.0f);
    idx.lists.assign(idx.nlist, std::vector<uint32_t>());

    for (int c = 0; c < idx.nlist; ++c) {
        size_t si = static_cast<size_t>(c) * n / idx.nlist;
        std::copy(base + si * d, base + (si + 1) * d,
                  idx.centroids.begin() + static_cast<size_t>(c) * d);
    }

    std::vector<int> assign(n, 0);
    std::vector<int> counts(idx.nlist, 0);
    std::vector<double> sums(static_cast<size_t>(idx.nlist) * d, 0.0);
    for (int iter = 0; iter < kmeans_iters; ++iter) {
        std::fill(counts.begin(), counts.end(), 0);
        std::fill(sums.begin(), sums.end(), 0.0);
        for (size_t i = 0; i < n; ++i) {
            const float* x = base + i * d;
            int best = 0;
            float best_dist = std::numeric_limits<float>::max();
            for (int c = 0; c < idx.nlist; ++c) {
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
            counts[best]++;
            double* s = &sums[static_cast<size_t>(best) * d];
            for (size_t j = 0; j < d; ++j) s[j] += x[j];
        }
        for (int c = 0; c < idx.nlist; ++c) {
            if (counts[c] == 0) continue;
            double inv = 1.0 / static_cast<double>(counts[c]);
            for (size_t j = 0; j < d; ++j) {
                idx.centroids[static_cast<size_t>(c) * d + j] =
                    static_cast<float>(sums[static_cast<size_t>(c) * d + j] * inv);
            }
        }
    }

    for (size_t i = 0; i < n; ++i) {
        idx.lists[assign[i]].push_back(static_cast<uint32_t>(i));
    }
}

void select_probe_ids(const SimpleIVFIndex& idx,
                      const float* query,
                      int nprobe,
                      std::vector<int>& probe_ids) {
    int np = std::min(nprobe, idx.nlist);
    std::vector<std::pair<float, int> > coarse(idx.nlist);
    for (int c = 0; c < idx.nlist; ++c) {
        const float* ct = &idx.centroids[static_cast<size_t>(c) * idx.d];
        float dot = 0.0f;
        for (size_t d = 0; d < idx.d; ++d) dot += ct[d] * query[d];
        coarse[c] = std::make_pair(1.0f - dot, c);
    }
    if (np < idx.nlist) {
        std::nth_element(coarse.begin(), coarse.begin() + np, coarse.end());
    } else {
        std::sort(coarse.begin(), coarse.end());
    }
    probe_ids.resize(np);
    for (int i = 0; i < np; ++i) probe_ids[i] = coarse[i].second;
}

size_t max_candidates_for_nprobe(const SimpleIVFIndex& idx, int nprobe) {
    std::vector<size_t> sizes;
    sizes.reserve(idx.lists.size());
    for (size_t i = 0; i < idx.lists.size(); ++i) sizes.push_back(idx.lists[i].size());
    std::sort(sizes.begin(), sizes.end(), std::greater<size_t>());
    size_t limit = std::min<size_t>(static_cast<size_t>(std::min(nprobe, idx.nlist)), sizes.size());
    size_t total = 0;
    for (size_t i = 0; i < limit; ++i) total += sizes[i];
    return std::max<size_t>(total, kRecallAt);
}

void submit_ivf_block_top4_scan(sycl::queue& q,
                                const float* base_dev,
                                const uint32_t* flat_ids_dev,
                                const uint32_t* list_offsets_dev,
                                const int* probe_ids_dev,
                                const float* query_dev,
                                float* partial_dist_dev,
                                uint32_t* partial_id_dev,
                                int batch_count,
                                int nprobe,
                                int probe_stride,
                                int query_stride,
                                int workgroup_size,
                                int dim) {
    sycl::range<2> global(static_cast<size_t>(batch_count),
                          static_cast<size_t>(workgroup_size));
    sycl::range<2> local(1, static_cast<size_t>(workgroup_size));
    q.submit([&](sycl::handler& h) {
        h.parallel_for(sycl::nd_range<2>(global, local), [=](sycl::nd_item<2> item) {
            int qi = static_cast<int>(item.get_group(0));
            int lid = static_cast<int>(item.get_local_id(1));
            float d0 = 3.402823466e+38F;
            float d1 = 3.402823466e+38F;
            float d2 = 3.402823466e+38F;
            float d3 = 3.402823466e+38F;
            uint32_t i0 = 0;
            uint32_t i1 = 0;
            uint32_t i2 = 0;
            uint32_t i3 = 0;

            for (int pi = 0; pi < nprobe; ++pi) {
                int cid = probe_ids_dev[qi * probe_stride + pi];
                uint32_t begin = list_offsets_dev[cid];
                uint32_t end = list_offsets_dev[cid + 1];
                uint32_t list_size = end - begin;
                for (uint32_t pos = static_cast<uint32_t>(lid);
                     pos < list_size;
                     pos += static_cast<uint32_t>(workgroup_size)) {
                    uint32_t vid = flat_ids_dev[begin + pos];
                    const float* b = base_dev + static_cast<size_t>(vid) * dim;
                    float dot = 0.0f;
                    for (int d = 0; d < dim; ++d) {
                        dot += b[d] * query_dev[d * query_stride + qi];
                    }
                    float dist = 1.0f - dot;
                    if (dist < d0) {
                        d3 = d2; i3 = i2;
                        d2 = d1; i2 = i1;
                        d1 = d0; i1 = i0;
                        d0 = dist; i0 = vid;
                    } else if (dist < d1) {
                        d3 = d2; i3 = i2;
                        d2 = d1; i2 = i1;
                        d1 = dist; i1 = vid;
                    } else if (dist < d2) {
                        d3 = d2; i3 = i2;
                        d2 = dist; i2 = vid;
                    } else if (dist < d3) {
                        d3 = dist; i3 = vid;
                    }
                }
            }

            int out_base = (qi * workgroup_size + lid) * 4;
            partial_dist_dev[out_base] = d0;
            partial_id_dev[out_base] = i0;
            partial_dist_dev[out_base + 1] = d1;
            partial_id_dev[out_base + 1] = i1;
            partial_dist_dev[out_base + 2] = d2;
            partial_id_dev[out_base + 2] = i2;
            partial_dist_dev[out_base + 3] = d3;
            partial_id_dev[out_base + 3] = i3;
        });
    });
}

std::priority_queue<std::pair<float, uint32_t> >
select_topk_from_candidates(const float* dist,
                            const uint32_t* ids,
                            size_t count,
                            size_t k) {
    std::priority_queue<std::pair<float, uint32_t> > heap;
    for (size_t i = 0; i < count; ++i) {
        push_topk(heap, dist[i], ids[i], k);
    }
    return heap;
}

#ifndef ANN_SYCL_IVF_ONLY
template<int QBlock>
void submit_batched_scan(sycl::queue& q,
                         const float* base_dev,
                         const float* query_dev,
                         float* dist_dev,
                         int batch_count,
                         int query_stride,
                         int base_count,
                         int dim) {
    const int query_blocks = (batch_count + QBlock - 1) / QBlock;
    q.submit([&](sycl::handler& h) {
        h.parallel_for(sycl::range<2>(query_blocks, base_count),
                       [=](sycl::id<2> idx) {
            const int qb = static_cast<int>(idx[0]) * QBlock;
            const int bi = static_cast<int>(idx[1]);
            sycl::vec<float, QBlock> acc(0.0f);

            const int base_offset = bi * dim;
            for (int d = 0; d < dim; ++d) {
                const float bv = base_dev[base_offset + d];
                sycl::vec<float, QBlock> qv(0.0f);
#pragma unroll
                for (int t = 0; t < QBlock; ++t) {
                    const int qi = qb + t;
                    if (qi < batch_count) qv[t] = query_dev[d * query_stride + qi];
                }
                acc += bv * qv;
            }

#pragma unroll
            for (int t = 0; t < QBlock; ++t) {
                const int qi = qb + t;
                if (qi < batch_count) dist_dev[qi * base_count + bi] = 1.0f - acc[t];
            }
        });
    });
}

void submit_batched_scan_dispatch(sycl::queue& q,
                                  const float* base_dev,
                                  const float* query_dev,
                                  float* dist_dev,
                                  int batch_count,
                                  int query_stride,
                                  int base_count,
                                  int dim,
                                  int query_block) {
    if (query_block == 1) {
        submit_batched_scan<1>(q, base_dev, query_dev, dist_dev, batch_count, query_stride, base_count, dim);
    } else if (query_block == 2) {
        submit_batched_scan<2>(q, base_dev, query_dev, dist_dev, batch_count, query_stride, base_count, dim);
    } else if (query_block == 8) {
        submit_batched_scan<8>(q, base_dev, query_dev, dist_dev, batch_count, query_stride, base_count, dim);
    } else if (query_block == 16) {
        submit_batched_scan<16>(q, base_dev, query_dev, dist_dev, batch_count, query_stride, base_count, dim);
    } else {
        submit_batched_scan<4>(q, base_dev, query_dev, dist_dev, batch_count, query_stride, base_count, dim);
    }
}
#endif

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
        return 2;
    }

    size_t nq = std::min(cfg.nq, std::min(query_n, gt_n));
    if (cfg.algo == "ivf" || cfg.algo == "ivf-sweep") {
        if (cfg.local_k != 4) {
            std::cerr << "INFO: Intel GPU IVF O2 path uses local_k=4; overriding --local-k "
                      << cfg.local_k << "\n";
            cfg.local_k = 4;
        }
        sycl::queue q = make_queue(cfg.device);
        std::string device_name = q.get_device().get_info<sycl::info::device::name>();
        std::string device_vendor = q.get_device().get_info<sycl::info::device::vendor>();
        if (base_n > static_cast<size_t>(std::numeric_limits<int>::max()) ||
            base_d > static_cast<size_t>(std::numeric_limits<int>::max()) ||
            cfg.batch_size > static_cast<size_t>(std::numeric_limits<int>::max())) {
            std::cerr << "FATAL: SYCL IVF path expects int-sized dimensions\n";
            return 2;
        }

        long long build_t0 = now_us();
        SimpleIVFIndex ivf;
        build_simple_ivf_index(base, base_n, base_d, cfg.nlist, cfg.kmeans_iters, ivf);
        double build_sec = static_cast<double>(now_us() - build_t0) / 1000000.0;

        std::vector<uint32_t> list_offsets(static_cast<size_t>(ivf.nlist) + 1, 0);
        for (int c = 0; c < ivf.nlist; ++c) {
            list_offsets[static_cast<size_t>(c) + 1] =
                list_offsets[static_cast<size_t>(c)] +
                static_cast<uint32_t>(ivf.lists[c].size());
        }
        std::vector<uint32_t> flat_ids(list_offsets.back());
        for (int c = 0; c < ivf.nlist; ++c) {
            std::copy(ivf.lists[c].begin(), ivf.lists[c].end(),
                      flat_ids.begin() + list_offsets[static_cast<size_t>(c)]);
        }

        std::vector<int> nprobe_values = parse_int_list(cfg.nprobe_list_arg);
        for (size_t i = 0; i < nprobe_values.size(); ++i) {
            nprobe_values[i] = std::min(nprobe_values[i], ivf.nlist);
        }
        nprobe_values.erase(std::unique(nprobe_values.begin(), nprobe_values.end()),
                            nprobe_values.end());
        int max_nprobe = nprobe_values.empty() ? std::min(32, ivf.nlist)
                                               : nprobe_values.back();

        const size_t batch_size = std::min(cfg.batch_size, nq);
        const size_t base_total = base_n * base_d;
        const size_t query_batch_total = batch_size * base_d;
        const size_t max_candidate_capacity = max_candidates_for_nprobe(ivf, max_nprobe);
        const size_t partial_capacity = static_cast<size_t>(cfg.workgroup_size) *
                                        static_cast<size_t>(cfg.local_k);
        const size_t partial_total = batch_size * partial_capacity;

        std::vector<float> query_batch(query_batch_total);
        std::vector<uint32_t> out_id_host(partial_total);
        std::vector<float> dist_host(partial_total);
        std::vector<int> batch_probe_ids(batch_size * static_cast<size_t>(max_nprobe));
        std::vector<int> probe_ids;

        float* base_dev = sycl::malloc_device<float>(base_total, q);
        float* query_dev = sycl::malloc_device<float>(query_batch_total, q);
        uint32_t* flat_ids_dev = sycl::malloc_device<uint32_t>(flat_ids.size(), q);
        uint32_t* list_offsets_dev = sycl::malloc_device<uint32_t>(list_offsets.size(), q);
        int* probe_ids_dev = sycl::malloc_device<int>(batch_probe_ids.size(), q);
        float* dist_dev = sycl::malloc_device<float>(partial_total, q);
        uint32_t* out_ids_dev = sycl::malloc_device<uint32_t>(partial_total, q);
        if (!base_dev || !query_dev || !flat_ids_dev || !list_offsets_dev ||
            !probe_ids_dev || !dist_dev || !out_ids_dev) {
            std::cerr << "FATAL: SYCL IVF USM allocation failed\n";
            if (base_dev) sycl::free(base_dev, q);
            if (query_dev) sycl::free(query_dev, q);
            if (flat_ids_dev) sycl::free(flat_ids_dev, q);
            if (list_offsets_dev) sycl::free(list_offsets_dev, q);
            if (probe_ids_dev) sycl::free(probe_ids_dev, q);
            if (dist_dev) sycl::free(dist_dev, q);
            if (out_ids_dev) sycl::free(out_ids_dev, q);
            delete[] base;
            delete[] query;
            delete[] gt;
            return 3;
        }
        q.memcpy(base_dev, base, base_total * sizeof(float)).wait();
        q.memcpy(flat_ids_dev, flat_ids.data(), flat_ids.size() * sizeof(uint32_t));
        q.memcpy(list_offsets_dev, list_offsets.data(), list_offsets.size() * sizeof(uint32_t));
        q.wait();

        {
            size_t warm_bs = std::min(batch_size, nq);
            for (size_t local_q = 0; local_q < warm_bs; ++local_q) {
                const float* qptr = query + local_q * base_d;
                for (size_t d = 0; d < base_d; ++d) {
                    query_batch[d * batch_size + local_q] = qptr[d];
                }
                select_probe_ids(ivf, qptr, max_nprobe, probe_ids);
                std::copy(probe_ids.begin(), probe_ids.end(),
                          batch_probe_ids.begin() + local_q * static_cast<size_t>(max_nprobe));
            }
            q.memcpy(query_dev, query_batch.data(), query_batch_total * sizeof(float));
            q.memcpy(probe_ids_dev, batch_probe_ids.data(), warm_bs * static_cast<size_t>(max_nprobe) * sizeof(int));
            q.wait();
            submit_ivf_block_top4_scan(q,
                                       base_dev,
                                       flat_ids_dev,
                                       list_offsets_dev,
                                       probe_ids_dev,
                                       query_dev,
                                       dist_dev,
                                       out_ids_dev,
                                       static_cast<int>(warm_bs),
                                       max_nprobe,
                                       max_nprobe,
                                       static_cast<int>(batch_size),
                                       cfg.workgroup_size,
                                       static_cast<int>(base_d));
            q.memcpy(dist_host.data(), dist_dev, warm_bs * partial_capacity * sizeof(float)).wait();
        }

        bool header = needs_header(cfg.csv_path);
        std::ofstream out(cfg.csv_path.c_str(), std::ios::app);
        if (header) {
            out << "experiment,method,nthreads,param1,param2,latency_ms,recall@100,speedup,"
                << "index_mb,build_sec,encode_us,lut_us,scan_us,select_us,rerank_us,notes\n";
        }

        bool best_valid = false;
        int best_nprobe = 0;
        double best_latency = std::numeric_limits<double>::max();
        double best_recall = 0.0;
        double best_speedup = 0.0;
        std::string best_method;
        std::string best_notes;

        for (size_t npi = 0; npi < nprobe_values.size(); ++npi) {
            int nprobe = nprobe_values[npi];
            double recall_sum = 0.0;
            double select_us_sum = 0.0;
            long long t0 = now_us();

            for (size_t batch_begin = 0; batch_begin < nq; batch_begin += batch_size) {
                size_t bs = std::min(batch_size, nq - batch_begin);
                for (size_t local_q = 0; local_q < bs; ++local_q) {
                    size_t qi = batch_begin + local_q;
                    const float* qptr = query + qi * base_d;
                    for (size_t d = 0; d < base_d; ++d) {
                        query_batch[d * batch_size + local_q] = qptr[d];
                    }
                    select_probe_ids(ivf, qptr, nprobe, probe_ids);
                    std::copy(probe_ids.begin(), probe_ids.end(),
                              batch_probe_ids.begin() + local_q * static_cast<size_t>(max_nprobe));
                }

                q.memcpy(query_dev, query_batch.data(), query_batch_total * sizeof(float));
                q.memcpy(probe_ids_dev, batch_probe_ids.data(),
                         bs * static_cast<size_t>(max_nprobe) * sizeof(int));
                q.wait();
                submit_ivf_block_top4_scan(q,
                                           base_dev,
                                           flat_ids_dev,
                                           list_offsets_dev,
                                           probe_ids_dev,
                                           query_dev,
                                           dist_dev,
                                           out_ids_dev,
                                           static_cast<int>(bs),
                                           nprobe,
                                           max_nprobe,
                                           static_cast<int>(batch_size),
                                           cfg.workgroup_size,
                                           static_cast<int>(base_d));
                q.memcpy(dist_host.data(), dist_dev, bs * partial_capacity * sizeof(float));
                q.memcpy(out_id_host.data(), out_ids_dev, bs * partial_capacity * sizeof(uint32_t));
                q.wait();

                for (size_t local_q = 0; local_q < bs; ++local_q) {
                    size_t qi = batch_begin + local_q;
                    long long select_t0 = now_us();
                    std::priority_queue<std::pair<float, uint32_t> > heap =
                        select_topk_from_candidates(dist_host.data() + local_q * partial_capacity,
                                                    out_id_host.data() + local_q * partial_capacity,
                                                    partial_capacity,
                                                    kRecallAt);
                    select_us_sum += static_cast<double>(now_us() - select_t0);
                    recall_sum += recall_at_k(heap, gt, gt_d, qi, kRecallAt);
                }
            }

            double total_us = static_cast<double>(now_us() - t0);
            double latency_ms = total_us / 1000.0 / static_cast<double>(nq);
            double recall = recall_sum / static_cast<double>(nq);
            double select_us = select_us_sum / static_cast<double>(nq);
            double scan_us = latency_ms * 1000.0 - select_us;
            if (scan_us < 0.0) scan_us = 0.0;
            double speedup = cfg.baseline_ms > 0.0 ? cfg.baseline_ms / latency_ms : 0.0;

            std::string method = cfg.method + "-IVF-nl" + std::to_string(ivf.nlist);
            std::string notes = cfg.notes;
            if (!notes.empty()) notes += "; ";
            notes += "selector=" + cfg.device + "; vendor=" + device_vendor + "; device=" + device_name;
            notes += "; target_recall=" + std::to_string(cfg.target_recall);
            notes += "; batch=" + std::to_string(batch_size);
            notes += "; candidate_capacity=" + std::to_string(max_candidate_capacity);
            notes += "; query_layout=dim_major; flat_lists_gpu=1";
            notes += "; gpu_block_topk=1; workgroup=" + std::to_string(cfg.workgroup_size);
            notes += "; local_k=" + std::to_string(cfg.local_k);
            notes += "; partial_candidates=" + std::to_string(partial_capacity);
            notes += "; coarse_host=1; final_topk_host=1; usm_device=1";

            out << "SYCL-IVF," << method << ",0,nprobe," << nprobe
                << "," << latency_ms
                << "," << recall
                << "," << speedup
                << ",0," << build_sec
                << ",0,0," << scan_us
                << "," << select_us
                << ",0," << csv_quote(notes) << "\n";

            std::cout << "SYCL IVF search: nq=" << nq
                      << " device=" << device_name
                      << " nlist=" << ivf.nlist
                      << " nprobe=" << nprobe
                      << " latency_ms=" << latency_ms
                      << " recall@100=" << recall
                      << " speedup=" << speedup << std::endl;

            if (recall >= cfg.target_recall && latency_ms < best_latency) {
                best_valid = true;
                best_nprobe = nprobe;
                best_latency = latency_ms;
                best_recall = recall;
                best_speedup = speedup;
                best_method = method;
                best_notes = notes;
            }
        }

        std::ofstream best_out(cfg.best_csv_path.c_str());
        best_out << "criterion,experiment,method,nthreads,param1,param2,latency_ms,recall@100,"
                 << "speedup,index_mb,build_sec,notes\n";
        if (best_valid) {
            best_out << "min latency with recall@100>=" << cfg.target_recall
                     << ",SYCL-IVF," << best_method << ",0,nprobe," << best_nprobe
                     << "," << best_latency
                     << "," << best_recall
                     << "," << best_speedup
                     << ",0," << build_sec
                     << "," << csv_quote(best_notes) << "\n";
            std::cout << "SYCL IVF best: nprobe=" << best_nprobe
                      << " latency_ms=" << best_latency
                      << " recall@100=" << best_recall << std::endl;
        } else {
            best_out << "min latency with recall@100>=" << cfg.target_recall
                     << ",NONE,,,,,0,0,0,0," << build_sec
                     << ",\"no candidate satisfies recall constraint\"\n";
            std::cout << "SYCL IVF best: no candidate satisfies recall@100 >= "
                      << cfg.target_recall << std::endl;
        }

        sycl::free(base_dev, q);
        sycl::free(query_dev, q);
        sycl::free(flat_ids_dev, q);
        sycl::free(list_offsets_dev, q);
        sycl::free(probe_ids_dev, q);
        sycl::free(dist_dev, q);
        sycl::free(out_ids_dev, q);
        delete[] base;
        delete[] query;
        delete[] gt;
        return 0;
    }

#ifdef ANN_SYCL_IVF_ONLY
    std::cerr << "FATAL: this binary was compiled with ANN_SYCL_IVF_ONLY; use --algo ivf "
              << "or rebuild without that define for flat exact search\n";
    delete[] base;
    delete[] query;
    delete[] gt;
    return 2;
#else
    sycl::queue q = make_queue(cfg.device);
    std::string device_name = q.get_device().get_info<sycl::info::device::name>();
    std::string device_vendor = q.get_device().get_info<sycl::info::device::vendor>();
    if (base_n > static_cast<size_t>(std::numeric_limits<int>::max()) ||
        base_d > static_cast<size_t>(std::numeric_limits<int>::max()) ||
        cfg.batch_size > static_cast<size_t>(std::numeric_limits<int>::max())) {
        std::cerr << "FATAL: SYCL batched path expects int-sized dimensions\n";
        return 2;
    }

    const size_t batch_size = std::min(cfg.batch_size, nq);
    const size_t base_total = base_n * base_d;
    const size_t query_batch_total = batch_size * base_d;
    const size_t dist_batch_total = batch_size * base_n;
    std::vector<float> query_batch(query_batch_total);
    std::vector<float> dist_batch(dist_batch_total);

    long long build_t0 = now_us();
    float* base_dev = sycl::malloc_device<float>(base_total, q);
    float* query_dev = sycl::malloc_device<float>(query_batch_total, q);
    float* dist_dev = sycl::malloc_device<float>(dist_batch_total, q);
    if (!base_dev || !query_dev || !dist_dev) {
        std::cerr << "FATAL: SYCL USM allocation failed\n";
        if (base_dev) sycl::free(base_dev, q);
        if (query_dev) sycl::free(query_dev, q);
        if (dist_dev) sycl::free(dist_dev, q);
        delete[] base;
        delete[] query;
        delete[] gt;
        return 3;
    }
    q.memcpy(base_dev, base, base_total * sizeof(float)).wait();
    double build_sec = static_cast<double>(now_us() - build_t0) / 1000000.0;

    size_t warmup_bs = std::min(batch_size, nq);
    for (size_t d = 0; d < base_d; ++d) {
        for (size_t qi = 0; qi < warmup_bs; ++qi) {
            query_batch[d * batch_size + qi] = query[qi * base_d + d];
        }
    }
    q.memcpy(query_dev, query_batch.data(), query_batch_total * sizeof(float)).wait();
    submit_batched_scan_dispatch(q, base_dev, query_dev, dist_dev,
                                 static_cast<int>(warmup_bs),
                                 static_cast<int>(batch_size),
                                 static_cast<int>(base_n),
                                 static_cast<int>(base_d),
                                 cfg.query_block);
    q.memcpy(dist_batch.data(), dist_dev, warmup_bs * base_n * sizeof(float)).wait();

    double recall_sum = 0.0;
    double select_us_sum = 0.0;
    long long t0 = now_us();

    for (size_t batch_begin = 0; batch_begin < nq; batch_begin += batch_size) {
        size_t bs = std::min(batch_size, nq - batch_begin);
        for (size_t d = 0; d < base_d; ++d) {
            for (size_t local_q = 0; local_q < bs; ++local_q) {
                query_batch[d * batch_size + local_q] =
                    query[(batch_begin + local_q) * base_d + d];
            }
        }
        q.memcpy(query_dev, query_batch.data(), query_batch_total * sizeof(float)).wait();
        submit_batched_scan_dispatch(q, base_dev, query_dev, dist_dev,
                                     static_cast<int>(bs),
                                     static_cast<int>(batch_size),
                                     static_cast<int>(base_n),
                                     static_cast<int>(base_d),
                                     cfg.query_block);
        q.memcpy(dist_batch.data(), dist_dev, bs * base_n * sizeof(float)).wait();

        for (size_t local_q = 0; local_q < bs; ++local_q) {
            size_t qi = batch_begin + local_q;
            long long select_t0 = now_us();
            std::priority_queue<std::pair<float, uint32_t> > heap =
                select_topk_from_dist_ptr(dist_batch.data() + local_q * base_n, base_n, kRecallAt);
            select_us_sum += static_cast<double>(now_us() - select_t0);
            recall_sum += recall_at_k(heap, gt, gt_d, qi, kRecallAt);
        }
    }

    double total_us = static_cast<double>(now_us() - t0);
    double latency_ms = total_us / 1000.0 / static_cast<double>(nq);
    double recall = recall_sum / static_cast<double>(nq);
    double select_us = select_us_sum / static_cast<double>(nq);
    double scan_us = latency_ms * 1000.0 - select_us;
    if (scan_us < 0.0) scan_us = 0.0;
    double speedup = cfg.baseline_ms > 0.0 ? cfg.baseline_ms / latency_ms : 0.0;

    bool header = needs_header(cfg.csv_path);
    std::ofstream out(cfg.csv_path.c_str(), std::ios::app);
    if (header) {
        out << "experiment,method,nthreads,param1,param2,latency_ms,recall@100,speedup,"
            << "index_mb,build_sec,encode_us,lut_us,scan_us,select_us,rerank_us,notes\n";
    }
    std::string notes = cfg.notes;
    if (!notes.empty()) notes += "; ";
    notes += "selector=" + cfg.device + "; vendor=" + device_vendor + "; device=" + device_name;
    notes += "; batch=" + std::to_string(batch_size);
    notes += "; query_block=" + std::to_string(cfg.query_block);
    notes += "; query_layout=dim_major; warmup_excluded=1; usm_device=1";
    out << "SYCL-Flat," << cfg.method << ",0,device,0,"
        << latency_ms
        << "," << recall
        << "," << speedup
        << ",0," << build_sec << ",0,0," << scan_us
        << "," << select_us
        << ",0," << csv_quote(notes) << "\n";

    std::cout << "SYCL flat search: nq=" << nq
              << " device=" << device_name
              << " latency_ms=" << latency_ms
              << " recall@100=" << recall
              << " speedup=" << speedup << std::endl;

    sycl::free(base_dev, q);
    sycl::free(query_dev, q);
    sycl::free(dist_dev, q);
    delete[] base;
    delete[] query;
    delete[] gt;
    return 0;
#endif
}
