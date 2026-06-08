#pragma once

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <queue>
#include <set>
#include <sstream>
#include <string>
#include <utility>
#include <vector>

#ifdef _MSC_VER
#include <direct.h>
#else
#include <sys/stat.h>
#include <sys/types.h>
#endif

namespace gpu_ann {

struct Dataset {
    std::vector<float> base;
    std::vector<float> query;
    std::vector<int> gt;
    size_t nbase = 0;
    size_t nq = 0;
    size_t dim = 0;
    size_t gt_dim = 0;
    bool gt_matches_current_base = true;
};

inline double now_ms() {
    using clock = std::chrono::high_resolution_clock;
    return std::chrono::duration<double, std::milli>(clock::now().time_since_epoch()).count();
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
    if (pos != std::string::npos) ensure_dir(path.substr(0, pos));
}

inline std::string find_data_dir() {
    std::vector<std::string> candidates;
    const char* env = std::getenv("ANN_DATA");
    if (env && env[0]) candidates.push_back(env);
    candidates.push_back("D:/Parallel-programming-NKU/anndata");
    candidates.push_back("../anndata");
    candidates.push_back("../../anndata");
    candidates.push_back("/anndata");
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
    if (!f) {
        std::cerr << "FATAL: short read from " << path << "\n";
        std::exit(1);
    }
    return data;
}

inline Dataset load_dataset(const std::string& data_dir, size_t nbase_limit, size_t nq_limit) {
    Dataset ds;
    size_t base_dim = 0;
    ds.base = load_bin_matrix<float>(join_path(data_dir, "DEEP100K.base.100k.fbin"), ds.nbase, base_dim);
    size_t qdim = 0;
    ds.query = load_bin_matrix<float>(join_path(data_dir, "DEEP100K.query.fbin"), ds.nq, qdim);
    size_t gt_n = 0;
    ds.gt = load_bin_matrix<int>(join_path(data_dir, "DEEP100K.gt.query.100k.top100.bin"), gt_n, ds.gt_dim);
    if (base_dim != qdim || gt_n < ds.nq) {
        std::cerr << "FATAL: inconsistent dataset dimensions\n";
        std::exit(1);
    }
    ds.dim = base_dim;
    if (nbase_limit > 0 && nbase_limit < ds.nbase) {
        ds.nbase = nbase_limit;
        ds.base.resize(ds.nbase * ds.dim);
        ds.gt_matches_current_base = false;
    }
    if (nq_limit > 0 && nq_limit < ds.nq) {
        ds.nq = nq_limit;
        ds.query.resize(ds.nq * ds.dim);
        ds.gt.resize(ds.nq * ds.gt_dim);
    }
    return ds;
}

inline float inner_product_cpu(const float* a, const float* b, size_t dim) {
    float s0 = 0.0f, s1 = 0.0f, s2 = 0.0f, s3 = 0.0f;
    size_t d = 0;
    for (; d + 4 <= dim; d += 4) {
        s0 += a[d] * b[d];
        s1 += a[d + 1] * b[d + 1];
        s2 += a[d + 2] * b[d + 2];
        s3 += a[d + 3] * b[d + 3];
    }
    float s = (s0 + s1) + (s2 + s3);
    for (; d < dim; ++d) s += a[d] * b[d];
    return s;
}

inline std::vector<uint32_t> topk_from_scores(const float* scores,
                                              const int* ids,
                                              size_t count,
                                              size_t k) {
    using Item = std::pair<float, uint32_t>;
    std::priority_queue<Item, std::vector<Item>, std::greater<Item> > heap;
    for (size_t i = 0; i < count; ++i) {
        int id = ids ? ids[i] : static_cast<int>(i);
        if (id < 0) continue;
        float score = scores[i];
        if (!std::isfinite(score)) continue;
        if (heap.size() < k) {
            heap.push(Item(score, static_cast<uint32_t>(id)));
        } else if (score > heap.top().first) {
            heap.pop();
            heap.push(Item(score, static_cast<uint32_t>(id)));
        }
    }
    std::vector<Item> tmp;
    tmp.reserve(heap.size());
    while (!heap.empty()) {
        tmp.push_back(heap.top());
        heap.pop();
    }
    std::sort(tmp.begin(), tmp.end(), [](const Item& a, const Item& b) {
        if (a.first != b.first) return a.first > b.first;
        return a.second < b.second;
    });
    std::vector<uint32_t> out;
    out.reserve(tmp.size());
    for (const Item& item : tmp) out.push_back(item.second);
    return out;
}

inline void recompute_groundtruth_for_current_base(Dataset& ds, size_t k) {
    std::vector<int> eval_gt(ds.nq * k);
    std::vector<float> scores(ds.nbase);
    for (size_t qi = 0; qi < ds.nq; ++qi) {
        const float* q = ds.query.data() + qi * ds.dim;
        for (size_t i = 0; i < ds.nbase; ++i) {
            scores[i] = inner_product_cpu(ds.base.data() + i * ds.dim, q, ds.dim);
        }
        std::vector<uint32_t> ids = topk_from_scores(scores.data(), nullptr, ds.nbase, k);
        for (size_t j = 0; j < k; ++j) {
            eval_gt[qi * k + j] = j < ids.size() ? static_cast<int>(ids[j]) : -1;
        }
    }
    ds.gt.swap(eval_gt);
    ds.gt_dim = k;
    ds.gt_matches_current_base = true;
}

inline double recall_at_k(const std::vector<std::vector<uint32_t> >& results,
                          const std::vector<int>& gt,
                          size_t gt_dim,
                          size_t k) {
    double sum = 0.0;
    for (size_t qi = 0; qi < results.size(); ++qi) {
        std::set<uint32_t> truth;
        for (size_t j = 0; j < k; ++j) truth.insert(static_cast<uint32_t>(gt[qi * gt_dim + j]));
        size_t hit = 0;
        for (uint32_t id : results[qi]) {
            if (truth.count(id)) ++hit;
        }
        sum += static_cast<double>(hit) / static_cast<double>(k);
    }
    return results.empty() ? 0.0 : sum / static_cast<double>(results.size());
}

inline std::string f6(double v) {
    std::ostringstream os;
    os << std::fixed << std::setprecision(6) << v;
    return os.str();
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
        out << '\n';
    }
    for (size_t i = 0; i < row.size(); ++i) {
        if (i) out << ',';
        out << row[i];
    }
    out << '\n';
}

}  // namespace gpu_ann
