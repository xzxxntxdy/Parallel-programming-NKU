#pragma once
// Common utilities: thread pool, top-k merge, recall, timing, barrier
// Uses C++11 std::thread for cross-platform (MSVC + GCC)
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <vector>
#include <queue>
#include <set>
#include <algorithm>
#include <chrono>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <functional>
#include <string>
#include <fstream>
#include <sstream>

#ifdef _MSC_VER
#define NOMINMAX
#include <windows.h>
#include <intrin.h>
#include <direct.h>
#else
#include <sys/stat.h>
#include <sys/types.h>
#endif

namespace pthread_ann {

inline long long now_us() {
    auto now = std::chrono::high_resolution_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(now.time_since_epoch()).count();
}

// ============ Top-K merge ============
inline void merge_topk(std::priority_queue<std::pair<float, uint32_t>>& dst,
                       std::priority_queue<std::pair<float, uint32_t>>& src, size_t k) {
    while (!src.empty()) {
        auto v = src.top(); src.pop();
        if (dst.size() < k) dst.push(v);
        else if (v.first < dst.top().first) { dst.push(v); dst.pop(); }
    }
}

inline float calc_recall_k(const std::priority_queue<std::pair<float, uint32_t>>& res,
                           const int* gt, size_t gt_d, size_t qid, size_t k) {
    std::set<uint32_t> gtset;
    for (size_t j = 0; j < k; j++) gtset.insert(static_cast<uint32_t>(gt[j + qid * gt_d]));
    auto copy = res; size_t acc = 0;
    while (!copy.empty()) { if (gtset.count(copy.top().second)) acc++; copy.pop(); }
    return static_cast<float>(acc) / k;
}

// ============ Barrier ============
class Barrier {
    std::mutex m_; std::condition_variable cv_; int count_, n_;
public:
    Barrier(int n) : count_(0), n_(n) {}
    void wait() {
        std::unique_lock<std::mutex> lk(m_);
        count_++;
        if (count_ == n_) { count_ = 0; cv_.notify_all(); }
        else cv_.wait(lk);
    }
};

// ============ Data I/O ============
template<typename T>
T* load_data(const std::string& path, size_t& n, size_t& d) {
    std::ifstream f(path, std::ios::binary);
    if (!f) { fprintf(stderr, "FATAL: cannot open %s\n", path.c_str()); exit(1); }
    uint32_t n32=0, d32=0;
    f.read((char*)&n32, 4); f.read((char*)&d32, 4);
    n = n32; d = d32;
    T* data = new T[n * d];
    f.read((char*)data, n * d * sizeof(T));
    return data;
}

inline double mean(const std::vector<double>& v) {
    if (v.empty()) return 0; double s=0; for(double x:v) s+=x; return s/v.size();
}

inline double mean_float(const std::vector<float>& v) {
    if (v.empty()) return 0; double s=0; for(float x:v) s+=x; return s/v.size();
}

inline void ensure_dir(const std::string& p) {
#ifdef _MSC_VER
    _mkdir(p.c_str());
#else
    mkdir(p.c_str(), 0755);
#endif
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

inline std::string compact_param(const std::string& name, int value) {
    std::ostringstream os;
    os << name << value;
    return os.str();
}

} // namespace pthread_ann
