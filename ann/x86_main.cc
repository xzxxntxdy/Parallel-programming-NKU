/* x86 ANN SIMD Benchmark — real DEEP100K data
   Compile (MSVC): cl /O2 /arch:AVX2 /EHsc /std:c++17 /Fe:x86_main.exe x86_main.cc */
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <cstdint>
#include <vector>
#include <queue>
#include <set>
#include <algorithm>
#include <chrono>
#include <string>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <random>

#ifdef _OPENMP
#include <omp.h>
#endif

#ifdef _MSC_VER
#include <direct.h>
#define MKDIR(p) _mkdir(p)
#else
#include <sys/stat.h>
#define MKDIR(p) mkdir(p, 0755)
#endif

#include "ann_search.h"
#include "ann_quant.h"
using namespace ann;

static double wall_sec() {
    using namespace std::chrono;
    return duration<double>(high_resolution_clock::now().time_since_epoch()).count();
}

// Fix: read 4-byte int from file into uint32_t, then assign to size_t
template<typename T>
T* load_data(const std::string& path, size_t& n, size_t& d) {
    std::ifstream fin(path, std::ios::binary);
    if (!fin) { fprintf(stderr, "FATAL: cannot open %s\n", path.c_str()); exit(1); }
    uint32_t n32 = 0, d32 = 0;
    fin.read((char*)&n32, 4);
    fin.read((char*)&d32, 4);
    n = n32; d = d32;
    T* data = new T[n * d];
    fin.read((char*)data, n * d * sizeof(T));
    fin.close();
    fprintf(stderr, "Loaded %s: n=%zu d=%zu\n", path.c_str(), n, d);
    return data;
}

float calc_recall(const std::priority_queue<std::pair<float, uint32_t>>& res,
                  const int* gt, size_t gt_d, size_t qid, size_t k) {
    std::set<uint32_t> gtset;
    for (size_t j = 0; j < k; ++j) gtset.insert(static_cast<uint32_t>(gt[j + qid * gt_d]));
    size_t acc = 0;
    auto copy = res;
    while (!copy.empty()) {
        if (gtset.find(copy.top().second) != gtset.end()) ++acc;
        copy.pop();
    }
    return static_cast<float>(acc) / k;
}

static double mean(const std::vector<double>& v) {
    if (v.empty()) return 0;
    double s = 0; for (double x : v) s += x; return s / v.size();
}

static void ensure_dir(const std::string& p) { if (!p.empty()) MKDIR(p.c_str()); }

// ============== Result writer ==============
struct X86Result {
    std::string method, family;
    int m, p, unroll, prefetch, block;
    std::string topk_type;
    double latency_ms, recall;
    double encode_ms, lut_ms, scan_ms, select_ms, rerank_ms;
    double build_time_sec, index_size_mb;
};

void write_csv_header(std::ofstream& f) {
    f << "method,family,M,p,unroll,prefetch,block,topk,"
      << "latency_ms,recall,encode_ms,lut_ms,scan_ms,select_ms,rerank_ms,"
      << "build_time_sec,index_size_mb\n";
}
void write_csv_row(std::ofstream& f, const X86Result& r) {
    f << r.method << "," << r.family << ","
      << r.m << "," << r.p << "," << r.unroll << "," << r.prefetch << ","
      << r.block << "," << r.topk_type << ","
      << std::fixed << std::setprecision(6)
      << r.latency_ms << "," << r.recall << ","
      << r.encode_ms << "," << r.lut_ms << "," << r.scan_ms << ","
      << r.select_ms << "," << r.rerank_ms << ","
      << r.build_time_sec << "," << r.index_size_mb << "\n";
}

// ============== Flat ==============
X86Result bench_flat(const float* base, const float* query, const int* gt,
                     size_t N, size_t d, size_t gt_d, size_t nq, size_t k,
                     SearchMethod method, const std::string& name,
                     int unroll, int prefetch, const std::string& topk) {
    X86Result r;
    r.method = name; r.family = "flat";
    r.m = 0; r.p = 0; r.unroll = unroll; r.prefetch = prefetch; r.block = 0;
    r.topk_type = topk;
    std::vector<double> lats, recalls;
    size_t eff_pf = prefetch > 0 ? static_cast<size_t>(prefetch) : 16;
    for (size_t qi = 0; qi < nq; ++qi) {
        double t0 = wall_sec();
        auto res = flat_search_method(base, query + qi * d, N, d, k, method, eff_pf);
        lats.push_back((wall_sec() - t0) * 1000.0);
        recalls.push_back(calc_recall(res, gt, gt_d, qi, k));
    }
    r.latency_ms = mean(lats); r.recall = mean(recalls);
    r.encode_ms = r.lut_ms = r.scan_ms = r.select_ms = r.rerank_ms = 0;
    r.build_time_sec = 0;
    r.index_size_mb = static_cast<double>(N) * d * sizeof(float) / 1e6;
    return r;
}

// ============== SQ8 ==============
X86Result bench_sq8(const float* base, const float* query, const int* gt,
                    size_t N, size_t d, size_t gt_d, size_t nq, size_t k, int p,
                    const std::string& name, bool use_u8simd) {
    X86Result r;
    r.method = name; r.family = use_u8simd ? "sq8u8" : "sq8";
    r.m = 0; r.p = p; r.unroll = 1; r.prefetch = 0; r.block = 0; r.topk_type = "heap";
    SQ8Index idx;
    double t0 = wall_sec();
    build_sq8_index(base, N, d, idx);
    r.build_time_sec = wall_sec() - t0;
    r.index_size_mb = sq8_index_size_mb(idx);
    std::vector<double> lats, coarse_t, rerank_t, recalls;
    for (size_t qi = 0; qi < nq; ++qi) {
        QuantTiming tim;
        double t1 = wall_sec();
        auto res = use_u8simd
            ? sq8_search_rerank_u8simd_timed(idx, base, query + qi * d, (size_t)p, k, &tim)
            : sq8_search_rerank_timed(idx, base, query + qi * d, (size_t)p, k, &tim);
        lats.push_back((wall_sec() - t1) * 1000.0);
        coarse_t.push_back(tim.coarse_us / 1000.0);
        rerank_t.push_back(tim.rerank_us / 1000.0);
        recalls.push_back(calc_recall(res, gt, gt_d, qi, k));
    }
    r.latency_ms = mean(lats); r.recall = mean(recalls);
    r.encode_ms = 0; r.lut_ms = 0;
    r.scan_ms = mean(coarse_t); r.select_ms = 0; r.rerank_ms = mean(rerank_t);
    return r;
}

// ============== PQ-ADC (nth_element select) ==============
X86Result bench_pq_adc(const float* base, const float* query, const int* gt,
                       size_t N, size_t d, size_t gt_d, size_t nq, size_t k,
                       int m, int p, bool use_select) {
    X86Result r;
    {
        std::ostringstream nm;
        nm << (use_select ? "PQ-ADC-sel-M" : "PQ-ADC-M") << m << "-p" << p;
        r.method = nm.str();
    }
    r.family = use_select ? "pqsel" : "pq";
    r.m = m; r.p = p; r.unroll = 1; r.prefetch = 0; r.block = 0; r.topk_type = "nth";

    PQIndex idx;
    double t0 = wall_sec();
    build_pq_index(base, N, d, m, 256, 2048, 10, idx);
    r.build_time_sec = wall_sec() - t0;
    r.index_size_mb = pq_index_size_mb(idx);

    std::vector<double> lats, lut_t, scan_t, select_t, rerank_t, recalls;
    for (size_t qi = 0; qi < nq; ++qi) {
        QuantTiming tim;
        double t1 = wall_sec();
        auto res = use_select
            ? pq_adc_search_rerank_select_timed(idx, base, query + qi * d, (size_t)p, k, &tim)
            : pq_adc_search_rerank_timed(idx, base, query + qi * d, (size_t)p, k, &tim);
        double t2 = wall_sec();
        lats.push_back((t2 - t1) * 1000.0);
        lut_t.push_back(tim.lut_us / 1000.0);
        scan_t.push_back(tim.scan_us / 1000.0);
        select_t.push_back(tim.select_us / 1000.0);
        rerank_t.push_back(tim.rerank_us / 1000.0);
        recalls.push_back(calc_recall(res, gt, gt_d, qi, k));
    }
    r.latency_ms = mean(lats); r.recall = mean(recalls);
    r.encode_ms = 0; r.lut_ms = mean(lut_t);
    r.scan_ms = mean(scan_t); r.select_ms = mean(select_t);
    r.rerank_ms = mean(rerank_t);
    return r;
}

// ============== PQ-SDC ==============
X86Result bench_pq_sdc(const float* base, const float* query, const int* gt,
                       size_t N, size_t d, size_t gt_d, size_t nq, size_t k,
                       int m, int p) {
    X86Result r;
    {
        std::ostringstream nm;
        nm << "PQ-SDC-M" << m << (p == 0 ? "-coarse" : ("-p" + std::to_string(p)));
        r.method = nm.str();
    }
    r.family = "sdc"; r.m = m; r.p = p; r.unroll = 1; r.prefetch = 0; r.block = 0;
    r.topk_type = p == 0 ? "coarse-only" : "nth-rerank";

    PQIndex idx;
    double t0 = wall_sec();
    build_pq_index(base, N, d, m, 256, 2048, 10, idx);
    std::vector<float> sdc_table;
    build_pq_sdc_table(idx, sdc_table);
    r.build_time_sec = wall_sec() - t0;
    r.index_size_mb = pq_index_size_mb(idx);

    std::vector<double> lats, enc_t, scan_t, select_t, rerank_t, recalls;
    for (size_t qi = 0; qi < nq; ++qi) {
        QuantTiming tim;
        double t1 = wall_sec();
        auto res = pq_sdc_search_rerank_select_timed(idx, sdc_table, base, query + qi * d, (size_t)p, k, &tim);
        double t2 = wall_sec();
        lats.push_back((t2 - t1) * 1000.0);
        enc_t.push_back(tim.encode_us / 1000.0);
        scan_t.push_back(tim.scan_us / 1000.0);
        select_t.push_back(tim.select_us / 1000.0);
        rerank_t.push_back(tim.rerank_us / 1000.0);
        recalls.push_back(calc_recall(res, gt, gt_d, qi, k));
    }
    r.latency_ms = mean(lats); r.recall = mean(recalls);
    r.encode_ms = mean(enc_t); r.lut_ms = 0;
    r.scan_ms = mean(scan_t); r.select_ms = mean(select_t);
    r.rerank_ms = mean(rerank_t);
    return r;
}

// ============== FastScan-ADC ==============
X86Result bench_fastscan(const float* base, const float* query, const int* gt,
                          size_t N, size_t d, size_t gt_d, size_t nq, size_t k,
                          int m, int p, int block) {
    X86Result r;
    {
        std::ostringstream nm;
        nm << "FastScan-ADC-M" << m << "-p" << p << "-b" << block;
        r.method = nm.str();
    }
    r.family = "fsadc"; r.m = m; r.p = p; r.unroll = 1; r.prefetch = 0;
    r.block = block; r.topk_type = "u8lut-block";

    PQIndex idx;
    PQFastScanIndex fast;
    double t0 = wall_sec();
    build_pq_index(base, N, d, m, 256, 2048, 10, idx);
    build_pq_fastscan_index(idx, block, fast);
    r.build_time_sec = wall_sec() - t0;
    r.index_size_mb = pq_index_size_mb(idx) + static_cast<double>(fast.codes.size()) / 1e6;

    std::vector<double> lats, lut_t, scan_t, select_t, rerank_t, recalls;
    for (size_t qi = 0; qi < nq; ++qi) {
        QuantTiming tim; float mae;
        double t1 = wall_sec();
        auto res = pq_adc_fastscan_search_rerank_timed(idx, fast, base, query + qi * d, (size_t)p, k, &tim, &mae);
        double t2 = wall_sec();
        lats.push_back((t2 - t1) * 1000.0);
        lut_t.push_back(tim.lut_us / 1000.0);
        scan_t.push_back(tim.scan_us / 1000.0);
        select_t.push_back(tim.select_us / 1000.0);
        rerank_t.push_back(tim.rerank_us / 1000.0);
        recalls.push_back(calc_recall(res, gt, gt_d, qi, k));
    }
    r.latency_ms = mean(lats); r.recall = mean(recalls);
    r.encode_ms = 0; r.lut_ms = mean(lut_t);
    r.scan_ms = mean(scan_t); r.select_ms = mean(select_t);
    r.rerank_ms = mean(rerank_t);
    return r;
}

// ============== MAIN ==============
int main() {
    const size_t k = 10;
    const std::string DATA = "D:/Parallel-programming-NKU/anndata";

    size_t base_n, base_d, query_n, query_d, gt_n, gt_d;
    float* base = load_data<float>(DATA + "/DEEP100K.base.100k.fbin", base_n, base_d);
    float* query = load_data<float>(DATA + "/DEEP100K.query.fbin", query_n, query_d);
    int* gt = load_data<int>(DATA + "/DEEP100K.gt.query.100k.top100.bin", gt_n, gt_d);

    if (base_n != 100000 || base_d != 96) {
        fprintf(stderr, "ERROR: N=%zu d=%zu\n", base_n, base_d); return 1;
    }
    const size_t N = base_n, d = base_d;
    const size_t bench_q = 100;  // benchmark queries
    const int repeat = 3;

    printf("=== x86 ANN SIMD Benchmark (FastScan optimized) ===\n");
    printf("CPU: Intel Core i9-14900HX\n");
    printf("Compiler: MSVC 19.43 /O2 /arch:AVX2\n");
    printf("SIMD: AVX2 SSE\n");
    printf("N=%zu d=%zu bench_queries=%zu k=%zu repeat=%d\n\n", N, d, bench_q, k, repeat);

    ensure_dir("files");
    ensure_dir("files/results");
    std::ofstream fout("files/results/x86_results.csv");
    write_csv_header(fout);

    // ==================== 1. FLAT ====================
    printf("=== 1. Flat Search ===\n");
    auto run_flat = [&](SearchMethod m, const char* name, int unr, int pf, const char* tk) {
        // warmup
        bench_flat(base, query, gt, N, d, gt_d, 5, k, m, name, unr, pf, tk);
        for (int rep = 0; rep < repeat; ++rep) {
            auto r = bench_flat(base, query, gt, N, d, gt_d, bench_q, k, m, name, unr, pf, tk);
            write_csv_row(fout, r);
        }
        auto r = bench_flat(base, query, gt, N, d, gt_d, bench_q, k, m, name, unr, pf, tk);
        printf("  %-40s %8.3f ms  recall=%.6f\n", name, r.latency_ms, r.recall);
    };

    run_flat(kScalarNoVec,    "Flat-Scalar",     1, 0,  "heap");
    run_flat(kAutoVectorized, "Flat-AutoVec",     1, 0,  "heap");
    run_flat(kManualSse,      "Flat-SSE",         1, 0,  "heap");
    run_flat(kManualAvx,      "Flat-AVX",         1, 0,  "heap");
    int pf_vals[] = {4, 8, 16, 32, 64};
    for (int pf : pf_vals) {
        char buf[64]; snprintf(buf, sizeof(buf), "Flat-AVX-prefetch%d", pf);
        run_flat(kManualAvx, buf, 1, pf, "heap");
    }

    // ==================== 2. SQ8 ====================
    printf("\n=== 2. SQ8 ===\n");
    int sq_p_vals[] = {100, 200, 500, 1000, 2000, 5000};
    for (int p : sq_p_vals) {
        for (int rep = 0; rep < repeat; ++rep) {
            char buf[64]; snprintf(buf, sizeof(buf), "SQ8-p%d", p);
            auto r = bench_sq8(base, query, gt, N, d, gt_d, bench_q, k, p, buf, false);
            write_csv_row(fout, r);
        }
        char buf[64]; snprintf(buf, sizeof(buf), "SQ8-p%d", p);
        auto r = bench_sq8(base, query, gt, N, d, gt_d, bench_q, k, p, buf, false);
        printf("  %-16s %7.3f ms  recall=%.6f  coarse=%7.3f ms  rerank=%6.3f ms\n",
               buf, r.latency_ms, r.recall, r.scan_ms, r.rerank_ms);
    }

    // ==================== 3. PQ-ADC ====================
    printf("\n=== 3. PQ-ADC (Ks=256) ===\n");
    int pq_m_vals[] = {8, 12, 16};
    int pq_p_vals[] = {100, 500, 1000, 2000, 5000};
    for (int m : pq_m_vals) {
        for (int p : pq_p_vals) {
            for (int rep = 0; rep < repeat; ++rep) {
                auto r = bench_pq_adc(base, query, gt, N, d, gt_d, bench_q, k, m, p, true);
                write_csv_row(fout, r);
            }
            auto r = bench_pq_adc(base, query, gt, N, d, gt_d, bench_q, k, m, p, true);
            printf("  PQ-ADC-M%d-p%-5d  %7.3f ms  recall=%.6f  lut=%5.3f scan=%6.3f rerank=%5.3f\n",
                   m, p, r.latency_ms, r.recall, r.lut_ms, r.scan_ms, r.rerank_ms);
        }
    }

    // ==================== 4. PQ-SDC ====================
    printf("\n=== 4. PQ-SDC (Ks=256) ===\n");
    int sdc_p_vals[] = {0, 100, 500, 1000, 2000, 5000};
    for (int m : pq_m_vals) {
        for (int p : sdc_p_vals) {
            for (int rep = 0; rep < repeat; ++rep) {
                auto r = bench_pq_sdc(base, query, gt, N, d, gt_d, bench_q, k, m, p);
                write_csv_row(fout, r);
            }
            auto r = bench_pq_sdc(base, query, gt, N, d, gt_d, bench_q, k, m, p);
            printf("  PQ-SDC-M%d-%-10s %7.3f ms  recall=%.6f\n",
                   m, (p==0?"coarse":("p"+std::to_string(p)).c_str()), r.latency_ms, r.recall);
        }
    }

    // ==================== 5. FastScan ====================
    printf("\n=== 5. FastScan (lane-major + register accumulation) ===\n");
    int fs_blocks[] = {16, 32, 64, 128};
    int fs_p_vals[] = {500, 1000, 1500, 2000};
    for (int p : fs_p_vals) {
        for (int blk : fs_blocks) {
            for (int rep = 0; rep < repeat; ++rep) {
                auto r = bench_fastscan(base, query, gt, N, d, gt_d, bench_q, k, 16, p, blk);
                write_csv_row(fout, r);
            }
            auto r = bench_fastscan(base, query, gt, N, d, gt_d, bench_q, k, 16, p, blk);
            printf("  FastScan-M16-p%d-b%-3d %7.3f ms  recall=%.6f  scan=%6.3f lut=%5.3f\n",
                   p, blk, r.latency_ms, r.recall, r.scan_ms, r.lut_ms);
        }
    }

    fout.close();
    printf("\n=== Results saved to files/results/x86_results.csv ===\n");

    delete[] base; delete[] query; delete[] gt;
    return 0;
}
