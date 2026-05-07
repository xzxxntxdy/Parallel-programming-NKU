/* ARM: scan Ks=16 with different M to find recall-sweet-spot */
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
    std::set<uint32_t> gts; for(size_t j=0;j<k;j++) gts.insert((uint32_t)gt[j+qid*gt_d]);
    auto cp=res; size_t acc=0;
    while(!cp.empty()){if(gts.count(cp.top().second))acc++;cp.pop();}
    return (float)acc/k;
}

int main() {
    std::string D="/anndata"; size_t bn,bd,qn,qd,gn,gd;
    auto loadf=[&](const std::string& p,size_t& n,size_t& d)->float*{
        std::ifstream f(p,std::ios::binary); uint32_t n32=0,d32=0;
        f.read((char*)&n32,4);f.read((char*)&d32,4);n=n32;d=d32;
        float*b=new float[n*d];f.read((char*)b,n*d*4);f.close();return b;};
    auto loadi=[&](const std::string& p,size_t& n,size_t& d)->int*{
        std::ifstream f(p,std::ios::binary); uint32_t n32=0,d32=0;
        f.read((char*)&n32,4);f.read((char*)&d32,4);n=n32;d=d32;
        int*b=new int[n*d];f.read((char*)b,n*d*4);f.close();return b;};
    float *base=loadf(D+"/DEEP100K.base.100k.fbin",bn,bd);
    float *q=loadf(D+"/DEEP100K.query.fbin",qn,qd);
    int *gt=loadi(D+"/DEEP100K.gt.query.100k.top100.bin",gn,gd);
    const size_t N=bn, nq=20, k=10;

    printf("=== ARM Ks=16 M-sweep ===\nN=%zu nq=%zu\n\n", N, nq);

    // Baseline: current v2 (Ks=256, M=16)
    PQIndex idx256; build_pq_index(base,N,bd,16,256,2048,10,idx256);
    PQFastScanIndex fsi; build_pq_fastscan_index(idx256,64,fsi);
    long long t0=now_us(); float rec=0;
    for(size_t qi=0;qi<nq;qi++){QuantTiming t;float m;auto r=pq_adc_fastscan_search_rerank_timed(idx256,fsi,base,q+qi*bd,1500,k,&t,&m);rec+=calc_recall(r,gt,gd,qi,k);}
    long long t1=now_us();
    printf("v2 Ks=256 M=16      latency=%.1f us  recall=%.4f  code=16B\n", (double)(t1-t0)/nq, rec/nq);

    // Sweep Ks=16: try smaller M, and M=24 with higher p
    int M_vals[] = {12, 16, 24, 32};
    for(int mi=0; mi<4; mi++){
        int M2=M_vals[mi];
        PQ4Index idx; build_pq4_index(base,N,bd,M2,2048,10,idx);
        // Try p that gives best recall for each M
        int p_test = (M2 <= 16) ? 2000 : 500;
        t0=now_us(); rec=0;
        for(size_t qi=0;qi<nq;qi++){QuantTiming t;float m;auto r=pq4_scan_search(idx,base,q+qi*bd,p_test,k,&t,&m);rec+=calc_recall(r,gt,gd,qi,k);}
        t1=now_us();
        int code_bytes = (M2 + 1) / 2;
        printf("v3 Ks=16 M=%-2d p=%-5d latency=%.1f us  recall=%.4f  code=%dB\n", M2, p_test, (double)(t1-t0)/nq, rec/nq, code_bytes);
    }

    // M=24 p-sweep to find recall recovery point
    printf("\n=== M=24 p-sweep ===\n");
    PQ4Index idx24; build_pq4_index(base,N,bd,24,2048,10,idx24);
    for(int p_val: {1000,2000,5000}){
        t0=now_us(); rec=0;
        for(size_t qi=0;qi<nq;qi++){QuantTiming t;float m;auto r=pq4_scan_search(idx24,base,q+qi*bd,p_val,k,&t,&m);rec+=calc_recall(r,gt,gd,qi,k);}
        t1=now_us();
        printf("M=24 p=%-5d  latency=%.1f us  recall=%.4f\n", p_val, (double)(t1-t0)/nq, rec/nq);
    }

    // M=32 with lower p
    printf("\n=== M=32 low-p ===\n");
    PQ4Index idx32; build_pq4_index(base,N,bd,32,2048,10,idx32);
    for(int p_val: {100, 250, 500}){
        t0=now_us(); rec=0;
        for(size_t qi=0;qi<nq;qi++){QuantTiming t;float m;auto r=pq4_scan_search(idx32,base,q+qi*bd,p_val,k,&t,&m);rec+=calc_recall(r,gt,gd,qi,k);}
        t1=now_us();
        printf("M=32 p=%-5d  latency=%.1f us  recall=%.4f\n", p_val, (double)(t1-t0)/nq, rec/nq);
    }

    delete[] base; delete[] q; delete[] gt;
    printf("\nDone.\n"); return 0;
}
