/* ARM NEON v3 FastScan benchmark — upload with ann_quant.h */
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <algorithm>
#include <chrono>
#include <fstream>
#include <cstring>
#include <cstdint>
#include <set>
#include <sys/stat.h>
#include <sys/time.h>

#include "ann_search.h"
#include "ann_quant.h"
using namespace ann;

static long long now_us() {
    struct timeval tv; gettimeofday(&tv, NULL);
    return tv.tv_sec * 1000000LL + tv.tv_usec;
}

float calc_recall(const std::priority_queue<std::pair<float, uint32_t>>& res,
                  const int* gt, size_t gt_d, size_t qid, size_t k) {
    std::set<uint32_t> gtset;
    for (size_t j=0; j<k; j++) gtset.insert((uint32_t)gt[j+qid*gt_d]);
    auto cp=res; size_t acc=0;
    while(!cp.empty()){if(gtset.count(cp.top().second))acc++;cp.pop();}
    return (float)acc/k;
}

int main() {
    const std::string D = "/anndata";
    size_t bn,bd,qn,qd,gn,gd;

    auto loadf = [](const std::string& p, size_t& n, size_t& d) {
        std::ifstream f(p, std::ios::binary);
        uint32_t n32=0,d32=0;
        f.read((char*)&n32,4); f.read((char*)&d32,4); n=n32; d=d32;
        float* buf = new float[n*d];
        f.read((char*)buf, n*d*sizeof(float)); f.close();
        return buf;
    };
    auto loadi = [](const std::string& p, size_t& n, size_t& d) {
        std::ifstream f(p, std::ios::binary);
        uint32_t n32=0,d32=0;
        f.read((char*)&n32,4); f.read((char*)&d32,4); n=n32; d=d32;
        int* buf = new int[n*d];
        f.read((char*)buf, n*d*sizeof(int)); f.close();
        return buf;
    };

    float* base = loadf(D+"/DEEP100K.base.100k.fbin", bn, bd);
    float* query = loadf(D+"/DEEP100K.query.fbin", qn, qd);
    int* gt = loadi(D+"/DEEP100K.gt.query.100k.top100.bin", gn, gd);

    const size_t N=bn, d=bd, nq=200, k=10;
    printf("=== ARM FastScan v3 Benchmark ===\n");
    printf("N=%zu d=%zu nq=%zu k=%zu\n\n", N, d, nq, k);

    // === v2 baseline: FastScan with Ks=256, lane-major ===
    printf("Training PQ (M=16, Ks=256) for v2 baseline...\n");
    PQIndex idx_v2;
    build_pq_index(base, N, d, 16, 256, 2048, 10, idx_v2);
    PQFastScanIndex fsi;
    build_pq_fastscan_index(idx_v2, 128, fsi);

    long long t0 = now_us();
    float avg_recall = 0;
    for (size_t qi=0; qi<nq; qi++) {
        QuantTiming tim; float mae;
        auto res = pq_adc_fastscan_search_rerank_timed(idx_v2, fsi, base, query+qi*d, 500, k, &tim, &mae);
        avg_recall += calc_recall(res, gt, gd, qi, k);
    }
    long long t1 = now_us();
    printf("FastScan v2 (M=16 Ks=256):  latency=%.3f ms  recall=%.4f\n",
           (t1-t0)/1000.0/nq, avg_recall/nq);

    // === v3: PQ4 with Ks=16, pshufb/NEON vtbl ===
    printf("Training PQ4 (M=32, Ks=16) for v3...\n");
    PQ4Index idx_v3;
    build_pq4_index(base, N, d, 32, 2048, 10, idx_v3);

    t0 = now_us();
    avg_recall = 0;
    for (size_t qi=0; qi<nq; qi++) {
        QuantTiming tim; float mae;
        auto res = pq4_scan_search(idx_v3, base, query+qi*d, 500, k, &tim, &mae);
        avg_recall += calc_recall(res, gt, gd, qi, k);
    }
    t1 = now_us();
    printf("FastScan v3 (M=32 Ks=16):    latency=%.3f ms  recall=%.4f\n",
           (t1-t0)/1000.0/nq, avg_recall/nq);

    // === Detailed timing for v3 ===
    printf("\n=== v3 per-phase timing (first 10 queries) ===\n");
    for (int qi=0; qi<10; qi++) {
        QuantTiming tim; float mae;
        pq4_scan_search(idx_v3, base, query+qi*d, 500, k, &tim, &mae);
        printf("q%d  lut=%lld scan=%lld sel=%lld rerank=%lld  mae=%.4f\n",
               qi, tim.lut_us, tim.scan_us, tim.select_us, tim.rerank_us, mae);
    }

    delete[] base; delete[] query; delete[] gt;
    printf("\nDone.\n");
    return 0;
}
