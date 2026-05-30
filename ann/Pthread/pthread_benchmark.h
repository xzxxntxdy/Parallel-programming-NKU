#pragma once

#include "pthread_common.h"
#include "ann_quant.h"

#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <limits>

namespace pthread_ann {

struct BenchmarkData {
    float* base;
    float* query;
    int* gt;
    size_t base_n;
    size_t dim;
    size_t query_n;
    size_t query_dim;
    size_t gt_n;
    size_t gt_dim;

    BenchmarkData()
        : base(NULL), query(NULL), gt(NULL), base_n(0), dim(0),
          query_n(0), query_dim(0), gt_n(0), gt_dim(0) {}

    ~BenchmarkData() {
        delete[] base;
        delete[] query;
        delete[] gt;
    }
};

struct BenchmarkConfig {
    bool final_only;
    bool quick;
    bool smoke;
    bool arm_quick;
    bool with_hnsw;
    bool hnsw_only;
    bool advanced_only;
    size_t nq;
    int train_sample;
    int kmeans_iters;
    double target_recall;
    int final_m;
    int final_p;
    int final_block;
    int final_threads;
    std::string data_dir;

    BenchmarkConfig()
        : final_only(true), quick(false), smoke(false), arm_quick(false),
          with_hnsw(false), hnsw_only(false), advanced_only(false),
          nq(1000), train_sample(4096), kmeans_iters(12),
          target_recall(0.95), final_m(16), final_p(500),
          final_block(64), final_threads(32) {}
};

struct TimingAvg {
    double encode_us;
    double lut_us;
    double scan_us;
    double select_us;
    double coarse_us;
    double rerank_us;

    TimingAvg()
        : encode_us(0), lut_us(0), scan_us(0), select_us(0),
          coarse_us(0), rerank_us(0) {}
};

inline void add_timing(TimingAvg& dst, const ann::QuantTiming& src) {
    dst.encode_us += src.encode_us;
    dst.lut_us += src.lut_us;
    dst.scan_us += src.scan_us;
    dst.select_us += src.select_us;
    dst.coarse_us += src.coarse_us;
    dst.rerank_us += src.rerank_us;
}

inline void scale_timing(TimingAvg& t, double inv) {
    t.encode_us *= inv;
    t.lut_us *= inv;
    t.scan_us *= inv;
    t.select_us *= inv;
    t.coarse_us *= inv;
    t.rerank_us *= inv;
}

inline std::string find_data_dir(const char* argv0) {
    std::vector<std::string> candidates;
    const char* env = std::getenv("ANN_DATA");
    if (env && env[0]) candidates.push_back(env);
    candidates.push_back("D:/Parallel-programming-NKU/anndata");
    candidates.push_back("../anndata");
    candidates.push_back("../../anndata");
    candidates.push_back("/anndata");
    candidates.push_back("/home/" + std::string(std::getenv("USER") ? std::getenv("USER") : "") + "/anndata");
    (void)argv0;

    for (size_t i = 0; i < candidates.size(); ++i) {
        std::string base_file = join_path(candidates[i], "DEEP100K.base.100k.fbin");
        std::string query_file = join_path(candidates[i], "DEEP100K.query.fbin");
        std::string gt_file = join_path(candidates[i], "DEEP100K.gt.query.100k.top100.bin");
        if (file_exists(base_file) && file_exists(query_file) && file_exists(gt_file)) {
            return candidates[i];
        }
    }
    return candidates.empty() ? std::string() : candidates[0];
}

inline BenchmarkConfig parse_config(int argc, char** argv) {
    BenchmarkConfig cfg;
    cfg.final_only = true;
    cfg.data_dir = find_data_dir(argc > 0 ? argv[0] : NULL);
    for (int i = 1; i < argc; ++i) {
        std::string arg(argv[i]);
        if (arg == "--benchmark" || arg == "--bench") {
            cfg.final_only = false;
        } else if (arg == "--final-only" || arg == "--final") {
            cfg.final_only = true;
        } else if (arg == "--quick") {
            cfg.quick = true;
            cfg.nq = 500;
            cfg.train_sample = 4096;
            cfg.kmeans_iters = 10;
        } else if (arg == "--smoke") {
            cfg.quick = true;
            cfg.smoke = true;
            cfg.nq = 50;
            cfg.train_sample = 1024;
            cfg.kmeans_iters = 6;
        } else if (arg == "--arm-quick") {
            cfg.quick = true;
            cfg.arm_quick = true;
            cfg.nq = 300;
            cfg.train_sample = 2048;
            cfg.kmeans_iters = 8;
            cfg.final_threads = 2;
        } else if (arg == "--with-hnsw") {
            cfg.with_hnsw = true;
        } else if (arg == "--hnsw-only") {
            cfg.final_only = false;
            cfg.hnsw_only = true;
            cfg.with_hnsw = true;
        } else if (arg == "--advanced-only" || arg == "--advanced") {
            cfg.final_only = false;
            cfg.advanced_only = true;
            cfg.hnsw_only = true;
            cfg.with_hnsw = true;
        } else if (arg == "--data" && i + 1 < argc) {
            cfg.data_dir = argv[++i];
        } else if (arg == "--nq" && i + 1 < argc) {
            cfg.nq = static_cast<size_t>(std::strtoull(argv[++i], NULL, 10));
        } else if (arg == "--train" && i + 1 < argc) {
            cfg.train_sample = std::atoi(argv[++i]);
        } else if (arg == "--iters" && i + 1 < argc) {
            cfg.kmeans_iters = std::atoi(argv[++i]);
        } else if (arg == "--target-recall" && i + 1 < argc) {
            cfg.target_recall = std::atof(argv[++i]);
        } else if (arg == "--final-p" && i + 1 < argc) {
            cfg.final_p = std::atoi(argv[++i]);
        } else if (arg == "--final-block" && i + 1 < argc) {
            cfg.final_block = std::atoi(argv[++i]);
        } else if (arg == "--final-threads" && i + 1 < argc) {
            cfg.final_threads = std::atoi(argv[++i]);
        } else if (arg == "--final-m" && i + 1 < argc) {
            cfg.final_m = std::atoi(argv[++i]);
        }
    }
    if (cfg.nq == 0) cfg.nq = 1;
    if (cfg.train_sample <= 0) cfg.train_sample = 1024;
    if (cfg.kmeans_iters <= 0) cfg.kmeans_iters = 5;
    if (cfg.target_recall <= 0.0 || cfg.target_recall > 1.0) cfg.target_recall = 0.95;
    if (cfg.final_m <= 0) cfg.final_m = 16;
    if (cfg.final_p <= 0) cfg.final_p = 500;
    if (cfg.final_block <= 0) cfg.final_block = 64;
    if (cfg.final_threads <= 0) cfg.final_threads = 1;
    return cfg;
}

inline void load_benchmark_data(const std::string& data_dir, BenchmarkData& data) {
    data.base = load_data<float>(join_path(data_dir, "DEEP100K.base.100k.fbin"),
                                 data.base_n, data.dim);
    data.query = load_data<float>(join_path(data_dir, "DEEP100K.query.fbin"),
                                  data.query_n, data.query_dim);
    data.gt = load_data<int>(join_path(data_dir, "DEEP100K.gt.query.100k.top100.bin"),
                             data.gt_n, data.gt_dim);
    if (data.dim != data.query_dim) {
        std::cerr << "FATAL: base dim and query dim mismatch\n";
        std::exit(1);
    }
}

class ResultWriter {
public:
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
              latency_ms(std::numeric_limits<double>::max()),
              recall(0.0), speedup(0.0), index_mb(0.0), build_sec(0.0) {}
    };

    explicit ResultWriter(const std::string& path, double target_recall = 0.95)
        : out_(path.c_str()), target_recall_(target_recall) {
        out_ << "experiment,method,nthreads,param1,param2,latency_ms,recall@100,speedup,"
             << "index_mb,build_sec,encode_us,lut_us,scan_us,select_us,rerank_us,notes\n";
    }

    void row(const std::string& experiment,
             const std::string& method,
             int nthreads,
             const std::string& param1,
             int param2,
             double latency_ms,
             double recall,
             double speedup,
             double index_mb = 0.0,
             double build_sec = 0.0,
             const TimingAvg* timing = NULL,
             const std::string& notes = "") {
        observe(experiment, method, nthreads, param1, param2, latency_ms, recall,
                speedup, index_mb, build_sec, notes);
        TimingAvg zero;
        const TimingAvg& t = timing ? *timing : zero;
        out_ << experiment << "," << method << "," << nthreads << ","
             << param1 << "," << param2 << ","
             << std::fixed << std::setprecision(6)
             << latency_ms << "," << recall << "," << speedup << ","
             << index_mb << "," << build_sec << ","
             << t.encode_us << "," << t.lut_us << "," << t.scan_us << ","
             << t.select_us << "," << t.rerank_us << "," << notes << "\n";
    }

    bool good() const { return out_.good(); }
    bool has_best() const { return best_.valid; }
    const BestCandidate& best() const { return best_; }

    std::string best_summary() const {
        if (!best_.valid) return "no candidate satisfies recall constraint";
        std::ostringstream oss;
        oss << best_.experiment << "/" << best_.method
            << " " << best_.param1 << "=" << best_.param2
            << " threads=" << best_.nthreads
            << " latency_ms=" << std::fixed << std::setprecision(6) << best_.latency_ms
            << " recall@100=" << std::setprecision(6) << best_.recall;
        if (!best_.notes.empty()) oss << " " << best_.notes;
        return oss.str();
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

inline void print_platform() {
    std::cout << "Platform: ";
#if defined(__aarch64__) || defined(__ARM_NEON) || defined(__ARM_NEON__)
    std::cout << "ARM/aarch64 NEON";
#elif defined(__AVX2__)
    std::cout << "x86-64 AVX2";
#elif defined(__AVX__)
    std::cout << "x86-64 AVX";
#elif defined(__x86_64__) || defined(_M_X64)
    std::cout << "x86-64";
#else
    std::cout << "unknown";
#endif
    std::cout << "\n";
}

inline size_t capped_queries(const BenchmarkConfig& cfg, const BenchmarkData& data) {
    return std::min(cfg.nq, data.query_n);
}

}  // namespace pthread_ann
