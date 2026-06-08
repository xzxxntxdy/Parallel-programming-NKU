#pragma once

#include "ann_search.h"

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <functional>
#include <iomanip>
#include <iostream>
#include <limits>
#include <queue>
#include <set>
#include <sstream>
#include <string>
#include <thread>
#include <utility>
#include <vector>

#ifdef _OPENMP
#include <omp.h>
#endif

#ifdef _MSC_VER
#include <direct.h>
#else
#include <sys/stat.h>
#include <sys/types.h>
#endif

namespace mpi_ann {

static const uint32_t kInvalidId = std::numeric_limits<uint32_t>::max();

struct Candidate {
    float dist;
    uint32_t id;
};

struct DataSet {
    std::vector<float> base;
    std::vector<float> query;
    std::vector<int> gt;
    size_t base_n = 0;
    size_t dim = 0;
    size_t query_n = 0;
    size_t gt_dim = 0;
};

inline long long now_us() {
    auto now = std::chrono::high_resolution_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(now.time_since_epoch()).count();
}

inline bool file_exists(const std::string& path) {
    std::ifstream f(path.c_str(), std::ios::binary);
    return f.good();
}

inline std::string join_path(const std::string& a, const std::string& b) {
    if (a.empty()) return b;
    char last = a[a.size() - 1];
    if (last == '/' || last == '\\') return a + b;
#ifdef _MSC_VER
    return a + "\\" + b;
#else
    return a + "/" + b;
#endif
}

inline void ensure_dir(const std::string& path) {
    if (path.empty()) return;
#ifdef _MSC_VER
    _mkdir(path.c_str());
#else
    mkdir(path.c_str(), 0755);
#endif
}

inline void ensure_parent_dir(const std::string& path) {
    size_t pos = path.find_last_of("/\\");
    if (pos != std::string::npos) {
        ensure_dir(path.substr(0, pos));
    }
}

inline std::string find_data_dir() {
    std::vector<std::string> candidates;
    const char* env = std::getenv("ANN_DATA");
    if (env && env[0]) candidates.push_back(env);
    candidates.push_back("D:/Parallel-programming-NKU/anndata");
    candidates.push_back("../anndata");
    candidates.push_back("../../anndata");
    candidates.push_back("/anndata");
    const char* user = std::getenv("USER");
    if (user && user[0]) {
        candidates.push_back("/home/" + std::string(user) + "/anndata");
    }
    for (const std::string& dir : candidates) {
        if (file_exists(join_path(dir, "DEEP100K.base.100k.fbin")) &&
            file_exists(join_path(dir, "DEEP100K.query.fbin")) &&
            file_exists(join_path(dir, "DEEP100K.gt.query.100k.top100.bin"))) {
            return dir;
        }
    }
    return candidates.empty() ? std::string() : candidates[0];
}

template <typename T>
inline std::vector<T> load_bin_matrix(const std::string& path, size_t& n, size_t& d) {
    std::ifstream f(path.c_str(), std::ios::binary);
    if (!f) {
        std::cerr << "FATAL: cannot open " << path << "\n";
        std::exit(1);
    }
    uint32_t n32 = 0, d32 = 0;
    f.read(reinterpret_cast<char*>(&n32), sizeof(uint32_t));
    f.read(reinterpret_cast<char*>(&d32), sizeof(uint32_t));
    n = n32;
    d = d32;
    std::vector<T> data(n * d);
    f.read(reinterpret_cast<char*>(data.data()), static_cast<std::streamsize>(data.size() * sizeof(T)));
    return data;
}

inline DataSet load_dataset_root(const std::string& data_dir, size_t nbase_limit, size_t nq_limit) {
    DataSet data;
    size_t base_dim = 0;
    data.base = load_bin_matrix<float>(join_path(data_dir, "DEEP100K.base.100k.fbin"),
                                       data.base_n, base_dim);
    size_t qdim = 0;
    data.query = load_bin_matrix<float>(join_path(data_dir, "DEEP100K.query.fbin"),
                                        data.query_n, qdim);
    size_t gt_n = 0;
    data.gt = load_bin_matrix<int>(join_path(data_dir, "DEEP100K.gt.query.100k.top100.bin"),
                                   gt_n, data.gt_dim);
    if (base_dim != qdim) {
        std::cerr << "FATAL: base/query dim mismatch\n";
        std::exit(1);
    }
    data.dim = base_dim;
    if (nbase_limit > 0 && nbase_limit < data.base_n) {
        data.base_n = nbase_limit;
        data.base.resize(data.base_n * data.dim);
    }
    if (nq_limit > 0 && nq_limit < data.query_n) {
        data.query_n = nq_limit;
        data.query.resize(data.query_n * data.dim);
        data.gt.resize(data.query_n * data.gt_dim);
    }
    return data;
}

inline void split_range(size_t n, int parts, int rank, size_t& begin, size_t& count) {
    size_t base = n / static_cast<size_t>(parts);
    size_t rem = n % static_cast<size_t>(parts);
    count = base + (static_cast<size_t>(rank) < rem ? 1 : 0);
    begin = base * static_cast<size_t>(rank) + std::min<size_t>(rem, static_cast<size_t>(rank));
}

inline void push_topk(std::priority_queue<std::pair<float, uint32_t> >& heap,
                      float dist,
                      uint32_t id,
                      size_t k) {
    if (id == kInvalidId) return;
    if (heap.size() < k) {
        heap.push(std::make_pair(dist, id));
    } else if (dist < heap.top().first) {
        heap.push(std::make_pair(dist, id));
        heap.pop();
    }
}

inline void heap_to_fixed_arrays(std::priority_queue<std::pair<float, uint32_t> > heap,
                                 size_t k,
                                 float* dist_out,
                                 uint32_t* id_out) {
    std::vector<std::pair<float, uint32_t> > tmp;
    tmp.reserve(heap.size());
    while (!heap.empty()) {
        tmp.push_back(heap.top());
        heap.pop();
    }
    std::sort(tmp.begin(), tmp.end());
    for (size_t i = 0; i < k; ++i) {
        if (i < tmp.size()) {
            dist_out[i] = tmp[i].first;
            id_out[i] = tmp[i].second;
        } else {
            dist_out[i] = std::numeric_limits<float>::infinity();
            id_out[i] = kInvalidId;
        }
    }
}

inline float recall_from_heap(const std::priority_queue<std::pair<float, uint32_t> >& heap,
                              const int* gt,
                              size_t gt_dim,
                              size_t qid,
                              size_t k) {
    std::set<uint32_t> truth;
    for (size_t i = 0; i < k; ++i) {
        truth.insert(static_cast<uint32_t>(gt[qid * gt_dim + i]));
    }
    std::priority_queue<std::pair<float, uint32_t> > copy = heap;
    size_t hit = 0;
    while (!copy.empty()) {
        if (truth.count(copy.top().second)) ++hit;
        copy.pop();
    }
    return static_cast<float>(hit) / static_cast<float>(k);
}

inline void merge_rank_results(const std::vector<float>& all_dist,
                               const std::vector<uint32_t>& all_ids,
                               int mpi_size,
                               size_t nq,
                               size_t k,
                               const std::vector<int>& gt,
                               size_t gt_dim,
                               double& recall,
                               std::vector<float>* query_recalls = nullptr) {
    double sum_recall = 0.0;
    if (query_recalls) query_recalls->assign(nq, 0.0f);
    for (size_t qi = 0; qi < nq; ++qi) {
        std::priority_queue<std::pair<float, uint32_t> > merged;
        for (int r = 0; r < mpi_size; ++r) {
            size_t base = (static_cast<size_t>(r) * nq + qi) * k;
            for (size_t j = 0; j < k; ++j) {
                push_topk(merged, all_dist[base + j], all_ids[base + j], k);
            }
        }
        float rec = recall_from_heap(merged, gt.data(), gt_dim, qi, k);
        sum_recall += rec;
        if (query_recalls) (*query_recalls)[qi] = rec;
    }
    recall = nq ? sum_recall / static_cast<double>(nq) : 0.0;
}

template <typename Fn>
inline void parallel_for_queries(size_t nq, int threads, const std::string& model, Fn fn) {
    if (threads <= 1 || nq <= 1) {
        for (size_t qi = 0; qi < nq; ++qi) fn(qi);
        return;
    }
#ifdef _OPENMP
    if (model == "openmp") {
#pragma omp parallel for num_threads(threads) schedule(dynamic)
        for (long long qi = 0; qi < static_cast<long long>(nq); ++qi) {
            fn(static_cast<size_t>(qi));
        }
        return;
    }
#else
    (void)model;
#endif
    std::vector<std::thread> workers;
    workers.reserve(static_cast<size_t>(threads));
    for (int t = 0; t < threads; ++t) {
        workers.emplace_back([=, &fn]() {
            for (size_t qi = static_cast<size_t>(t); qi < nq; qi += static_cast<size_t>(threads)) {
                fn(qi);
            }
        });
    }
    for (std::thread& w : workers) w.join();
}

inline double mean(const std::vector<double>& x) {
    if (x.empty()) return 0.0;
    double sum = 0.0;
    for (double v : x) sum += v;
    return sum / static_cast<double>(x.size());
}

inline double max_value(const std::vector<double>& x) {
    return x.empty() ? 0.0 : *std::max_element(x.begin(), x.end());
}

inline std::vector<int> parse_int_list(const std::string& s) {
    std::vector<int> out;
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, ',')) {
        if (!item.empty()) out.push_back(std::atoi(item.c_str()));
    }
    return out;
}

inline void append_csv_row(const std::string& path,
                           const std::vector<std::string>& header,
                           const std::vector<std::string>& row) {
    ensure_parent_dir(path);
    bool exists = file_exists(path);
    std::ofstream out(path.c_str(), std::ios::app);
    if (!exists) {
        for (size_t i = 0; i < header.size(); ++i) {
            if (i) out << ',';
            out << header[i];
        }
        out << "\n";
    }
    for (size_t i = 0; i < row.size(); ++i) {
        if (i) out << ',';
        out << row[i];
    }
    out << "\n";
}

inline std::string f6(double x) {
    std::ostringstream os;
    os << std::fixed << std::setprecision(6) << x;
    return os.str();
}

}  // namespace mpi_ann
