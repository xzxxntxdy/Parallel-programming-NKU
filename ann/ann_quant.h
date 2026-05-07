#pragma once

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <limits>
#include <queue>
#include <random>
#include <string>
#include <utility>
#include <vector>

#ifdef _OPENMP
#include <omp.h>
#endif

#include "ann_search.h"

namespace ann {

struct SQ8Index {
    size_t n;
    size_t d;
    std::vector<uint8_t> codes;
    std::vector<float> minv;
    std::vector<float> scale;
};

struct PQIndex {
    size_t n;
    size_t d;
    int m;
    int ks;
    int subdim;
    int train_sample_size;
    int kmeans_iters;
    std::vector<float> codebooks;
    std::vector<uint8_t> codes;
};

struct QuantTiming {
    long long encode_us;
    long long lut_us;
    long long scan_us;
    long long select_us;
    long long coarse_us;
    long long rerank_us;

    QuantTiming() : encode_us(0), lut_us(0), scan_us(0), select_us(0),
                    coarse_us(0), rerank_us(0) {}
};

struct PQFastScanIndex {
    size_t n;
    int m;
    int block_size;
    std::vector<uint8_t> codes;   // lane-major layout: [block][lane][part]

    PQFastScanIndex() : n(0), m(0), block_size(32) {}
};

inline long long quant_now_us() {
    typedef std::chrono::high_resolution_clock Clock;
    return std::chrono::duration_cast<std::chrono::microseconds>(
        Clock::now().time_since_epoch()).count();
}

inline uint8_t clamp_u8(int x) {
    if (x < 0) {
        return 0;
    }
    if (x > 255) {
        return 255;
    }
    return static_cast<uint8_t>(x);
}

inline void build_sq8_index(const float* base, size_t n, size_t d, SQ8Index& index) {
    index.n = n;
    index.d = d;
    index.codes.assign(n * d, 0);
    index.minv.assign(d, std::numeric_limits<float>::max());
    index.scale.assign(d, 1.0f);
    std::vector<float> maxv(d, -std::numeric_limits<float>::max());

    for (size_t i = 0; i < n; ++i) {
        const float* x = base + i * d;
        for (size_t j = 0; j < d; ++j) {
            index.minv[j] = std::min(index.minv[j], x[j]);
            maxv[j] = std::max(maxv[j], x[j]);
        }
    }

    for (size_t j = 0; j < d; ++j) {
        float range = maxv[j] - index.minv[j];
        index.scale[j] = range > 1e-12f ? range / 255.0f : 1.0f;
    }

#pragma omp parallel for schedule(static)
    for (long long i = 0; i < static_cast<long long>(n); ++i) {
        const float* x = base + static_cast<size_t>(i) * d;
        uint8_t* code = &index.codes[static_cast<size_t>(i) * d];
        for (size_t j = 0; j < d; ++j) {
            int q = static_cast<int>(std::floor((x[j] - index.minv[j]) / index.scale[j] + 0.5f));
            code[j] = clamp_u8(q);
        }
    }
}

inline std::priority_queue<std::pair<float, uint32_t> >
sq8_search_rerank_timed(const SQ8Index& index,
                        const float* base,
                        const float* query,
                        size_t p,
                        size_t k,
                        QuantTiming* timing) {
    p = std::min(p, index.n);
    long long coarse_t0 = quant_now_us();
    std::vector<float> lut(index.d * 256);
    for (size_t j = 0; j < index.d; ++j) {
        float q = query[j];
        float minv = index.minv[j];
        float scale = index.scale[j];
        for (int c = 0; c < 256; ++c) {
            lut[j * 256 + c] = (minv + scale * c) * q;
        }
    }

    std::priority_queue<std::pair<float, uint32_t> > coarse;
    for (size_t i = 0; i < index.n; ++i) {
        const uint8_t* code = &index.codes[i * index.d];
        float dot = 0.0f;
        for (size_t j = 0; j < index.d; ++j) {
            dot += lut[j * 256 + code[j]];
        }
        push_heap_topk(coarse, 1.0f - dot, static_cast<uint32_t>(i), p);
    }
    long long coarse_t1 = quant_now_us();

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result;
    while (!coarse.empty()) {
        uint32_t id = coarse.top().second;
        coarse.pop();
        float distance = 1.0f - inner_product_neon(base + static_cast<size_t>(id) * index.d,
                                                   query, index.d);
        push_heap_topk(result, distance, id, k);
    }
    long long rerank_t1 = quant_now_us();
    if (timing) {
        timing->coarse_us = coarse_t1 - coarse_t0;
        timing->rerank_us = rerank_t1 - rerank_t0;
    }
    return result;
}

inline std::priority_queue<std::pair<float, uint32_t> >
sq8_search_rerank(const SQ8Index& index,
                  const float* base,
                  const float* query,
                  size_t p,
                  size_t k) {
    return sq8_search_rerank_timed(index, base, query, p, k, NULL);
}

inline uint32_t sq8_code_dot_scalar(const uint8_t* code,
                                    const uint8_t* qcode,
                                    size_t d) {
    uint32_t sum = 0;
    for (size_t j = 0; j < d; ++j) {
        sum += static_cast<uint32_t>(code[j]) * static_cast<uint32_t>(qcode[j]);
    }
    return sum;
}

inline uint32_t sq8_code_dot_neon(const uint8_t* code,
                                  const uint8_t* qcode,
                                  size_t d) {
#if ANN_HAS_NEON
    uint32x4_t acc0 = vdupq_n_u32(0);
    uint32x4_t acc1 = vdupq_n_u32(0);
    size_t j = 0;
    for (; j + 16 <= d; j += 16) {
        uint8x16_t cv = vld1q_u8(code + j);
        uint8x16_t qv = vld1q_u8(qcode + j);
        uint16x8_t lo = vmull_u8(vget_low_u8(cv), vget_low_u8(qv));
        uint16x8_t hi = vmull_u8(vget_high_u8(cv), vget_high_u8(qv));
        acc0 = vpadalq_u16(acc0, lo);
        acc1 = vpadalq_u16(acc1, hi);
    }
    uint32x4_t total = vaddq_u32(acc0, acc1);
#if defined(__aarch64__)
    uint32_t sum = vaddvq_u32(total);
#else
    uint64x2_t pair = vpaddlq_u32(total);
    uint64_t tmp[2];
    vst1q_u64(tmp, pair);
    uint32_t sum = static_cast<uint32_t>(tmp[0] + tmp[1]);
#endif
    for (; j < d; ++j) {
        sum += static_cast<uint32_t>(code[j]) * static_cast<uint32_t>(qcode[j]);
    }
    return sum;
#else
    return sq8_code_dot_scalar(code, qcode, d);
#endif
}

inline std::priority_queue<std::pair<float, uint32_t> >
sq8_search_rerank_u8simd_timed(const SQ8Index& index,
                               const float* base,
                               const float* query,
                               size_t p,
                               size_t k,
                               QuantTiming* timing) {
    p = std::min(p, index.n);
    std::vector<uint8_t> qcode(index.d, 0);
    for (size_t j = 0; j < index.d; ++j) {
        int q = static_cast<int>(std::floor((query[j] - index.minv[j]) / index.scale[j] + 0.5f));
        qcode[j] = clamp_u8(q);
    }

    long long coarse_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > coarse;
    for (size_t i = 0; i < index.n; ++i) {
        const uint8_t* code = &index.codes[i * index.d];
        uint32_t dot = sq8_code_dot_neon(code, &qcode[0], index.d);
        push_heap_topk(coarse, -static_cast<float>(dot), static_cast<uint32_t>(i), p);
    }
    long long coarse_t1 = quant_now_us();

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result;
    while (!coarse.empty()) {
        uint32_t id = coarse.top().second;
        coarse.pop();
        float distance = 1.0f - inner_product_neon(base + static_cast<size_t>(id) * index.d,
                                                   query, index.d);
        push_heap_topk(result, distance, id, k);
    }
    long long rerank_t1 = quant_now_us();
    if (timing) {
        timing->coarse_us = coarse_t1 - coarse_t0;
        timing->rerank_us = rerank_t1 - rerank_t0;
    }
    return result;
}

inline std::priority_queue<std::pair<float, uint32_t> >
sq8_search_rerank_u8simd(const SQ8Index& index,
                         const float* base,
                         const float* query,
                         size_t p,
                         size_t k) {
    return sq8_search_rerank_u8simd_timed(index, base, query, p, k, NULL);
}

inline float l2_subspace(const float* a, const float* b, int subdim) {
    float sum = 0.0f;
    for (int i = 0; i < subdim; ++i) {
        float diff = a[i] - b[i];
        sum += diff * diff;
    }
    return sum;
}

inline size_t train_to_base_id(size_t sample_id, size_t sample_count, size_t n) {
    if (sample_count <= 1) {
        return 0;
    }
    return sample_id * (n - 1) / (sample_count - 1);
}

inline void build_pq_index(const float* base,
                           size_t n,
                           size_t d,
                           int m,
                           int ks,
                           int train_sample_size,
                           int kmeans_iters,
                           PQIndex& index) {
    index.n = n;
    index.d = d;
    index.m = m;
    index.ks = ks;
    index.subdim = static_cast<int>(d / static_cast<size_t>(m));
    index.train_sample_size = static_cast<int>(std::min(n, static_cast<size_t>(train_sample_size)));
    index.kmeans_iters = kmeans_iters;
    index.codebooks.assign(static_cast<size_t>(m) * ks * index.subdim, 0.0f);
    index.codes.assign(n * static_cast<size_t>(m), 0);

    if (d % static_cast<size_t>(m) != 0 || ks <= 0 || ks > 256) {
        return;
    }

    const size_t samples = static_cast<size_t>(index.train_sample_size);
    std::vector<size_t> train_ids(samples, 0);
    for (size_t s = 0; s < samples; ++s) {
        train_ids[s] = train_to_base_id(s, samples, n);
    }
    std::mt19937 rng(12345);
    std::shuffle(train_ids.begin(), train_ids.end(), rng);

    std::vector<int> assign(samples, 0);
    std::vector<float> sums(static_cast<size_t>(ks) * index.subdim, 0.0f);
    std::vector<int> counts(ks, 0);

    for (int part = 0; part < m; ++part) {
        float* centers = &index.codebooks[static_cast<size_t>(part) * ks * index.subdim];
        for (int c = 0; c < ks; ++c) {
            size_t sample_id = static_cast<size_t>(c) * samples / static_cast<size_t>(ks);
            size_t base_id = train_ids[sample_id];
            const float* src = base + base_id * d + static_cast<size_t>(part) * index.subdim;
            std::memcpy(centers + static_cast<size_t>(c) * index.subdim,
                        src,
                        static_cast<size_t>(index.subdim) * sizeof(float));
        }

        for (int iter = 0; iter < kmeans_iters; ++iter) {
            std::fill(sums.begin(), sums.end(), 0.0f);
            std::fill(counts.begin(), counts.end(), 0);

            for (size_t s = 0; s < samples; ++s) {
                size_t base_id = train_ids[s];
                const float* x = base + base_id * d + static_cast<size_t>(part) * index.subdim;
                int best = 0;
                float best_dist = std::numeric_limits<float>::max();
                for (int c = 0; c < ks; ++c) {
                    float dist = l2_subspace(x, centers + static_cast<size_t>(c) * index.subdim,
                                             index.subdim);
                    if (dist < best_dist) {
                        best_dist = dist;
                        best = c;
                    }
                }
                assign[s] = best;
                counts[best] += 1;
                float* sum = &sums[static_cast<size_t>(best) * index.subdim];
                for (int j = 0; j < index.subdim; ++j) {
                    sum[j] += x[j];
                }
            }

            for (int c = 0; c < ks; ++c) {
                if (counts[c] == 0) {
                    continue;
                }
                float inv = 1.0f / counts[c];
                float* center = centers + static_cast<size_t>(c) * index.subdim;
                const float* sum = &sums[static_cast<size_t>(c) * index.subdim];
                for (int j = 0; j < index.subdim; ++j) {
                    center[j] = sum[j] * inv;
                }
            }
        }
    }

#pragma omp parallel for schedule(dynamic, 128)
    for (long long i = 0; i < static_cast<long long>(n); ++i) {
        for (int part = 0; part < m; ++part) {
            const float* x = base + static_cast<size_t>(i) * d + static_cast<size_t>(part) * index.subdim;
            const float* centers = &index.codebooks[static_cast<size_t>(part) * ks * index.subdim];
            int best = 0;
            float best_dist = std::numeric_limits<float>::max();
            for (int c = 0; c < ks; ++c) {
                float dist = l2_subspace(x, centers + static_cast<size_t>(c) * index.subdim,
                                         index.subdim);
                if (dist < best_dist) {
                    best_dist = dist;
                    best = c;
                }
            }
            index.codes[static_cast<size_t>(i) * m + part] = static_cast<uint8_t>(best);
        }
    }
}

inline std::priority_queue<std::pair<float, uint32_t> >
pq_adc_search_rerank_timed(const PQIndex& index,
                           const float* base,
                           const float* query,
                           size_t p,
                           size_t k,
                           QuantTiming* timing) {
    p = std::min(p, index.n);
    long long coarse_t0 = quant_now_us();
    std::vector<float> lut(static_cast<size_t>(index.m) * index.ks, 0.0f);
    for (int part = 0; part < index.m; ++part) {
        const float* q = query + static_cast<size_t>(part) * index.subdim;
        const float* centers = &index.codebooks[static_cast<size_t>(part) * index.ks * index.subdim];
        for (int c = 0; c < index.ks; ++c) {
            float dot = 0.0f;
            const float* center = centers + static_cast<size_t>(c) * index.subdim;
            for (int j = 0; j < index.subdim; ++j) {
                dot += center[j] * q[j];
            }
            lut[static_cast<size_t>(part) * index.ks + c] = dot;
        }
    }

    std::priority_queue<std::pair<float, uint32_t> > coarse;
    for (size_t i = 0; i < index.n; ++i) {
        const uint8_t* code = &index.codes[i * static_cast<size_t>(index.m)];
        float dot = 0.0f;
        for (int part = 0; part < index.m; ++part) {
            dot += lut[static_cast<size_t>(part) * index.ks + code[part]];
        }
        push_heap_topk(coarse, 1.0f - dot, static_cast<uint32_t>(i), p);
    }
    long long coarse_t1 = quant_now_us();

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result;
    while (!coarse.empty()) {
        uint32_t id = coarse.top().second;
        coarse.pop();
        float distance = 1.0f - inner_product_neon(base + static_cast<size_t>(id) * index.d,
                                                   query, index.d);
        push_heap_topk(result, distance, id, k);
    }
    long long rerank_t1 = quant_now_us();
    if (timing) {
        timing->coarse_us = coarse_t1 - coarse_t0;
        timing->rerank_us = rerank_t1 - rerank_t0;
    }
    return result;
}

inline std::priority_queue<std::pair<float, uint32_t> >
pq_adc_search_rerank(const PQIndex& index,
                     const float* base,
                     const float* query,
                     size_t p,
                     size_t k) {
    return pq_adc_search_rerank_timed(index, base, query, p, k, NULL);
}

inline std::priority_queue<std::pair<float, uint32_t> >
pq_adc_search_rerank_select_timed(const PQIndex& index,
                                  const float* base,
                                  const float* query,
                                  size_t p,
                                  size_t k,
                                  QuantTiming* timing) {
    p = std::min(p, index.n);
    long long lut_t0 = quant_now_us();
    std::vector<float> lut(static_cast<size_t>(index.m) * index.ks, 0.0f);
    for (int part = 0; part < index.m; ++part) {
        const float* q = query + static_cast<size_t>(part) * index.subdim;
        const float* centers = &index.codebooks[static_cast<size_t>(part) * index.ks * index.subdim];
        for (int c = 0; c < index.ks; ++c) {
            float dot = 0.0f;
            const float* center = centers + static_cast<size_t>(c) * index.subdim;
            for (int j = 0; j < index.subdim; ++j) {
                dot += center[j] * q[j];
            }
            lut[static_cast<size_t>(part) * index.ks + c] = dot;
        }
    }
    long long lut_t1 = quant_now_us();

    long long scan_t0 = quant_now_us();
    std::vector<std::pair<float, uint32_t> > coarse(index.n);
    for (size_t i = 0; i < index.n; ++i) {
        const uint8_t* code = &index.codes[i * static_cast<size_t>(index.m)];
        float dot = 0.0f;
        for (int part = 0; part < index.m; ++part) {
            dot += lut[static_cast<size_t>(part) * index.ks + code[part]];
        }
        coarse[i] = std::make_pair(1.0f - dot, static_cast<uint32_t>(i));
    }
    long long scan_t1 = quant_now_us();

    long long select_t0 = quant_now_us();
    if (p < coarse.size()) {
        std::nth_element(coarse.begin(), coarse.begin() + static_cast<std::ptrdiff_t>(p), coarse.end());
    }
    long long select_t1 = quant_now_us();

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result;
    for (size_t i = 0; i < p; ++i) {
        uint32_t id = coarse[i].second;
        float distance = 1.0f - inner_product_neon(base + static_cast<size_t>(id) * index.d,
                                                   query, index.d);
        push_heap_topk(result, distance, id, k);
    }
    long long rerank_t1 = quant_now_us();
    if (timing) {
        timing->lut_us = lut_t1 - lut_t0;
        timing->scan_us = scan_t1 - scan_t0;
        timing->select_us = select_t1 - select_t0;
        timing->coarse_us = (lut_t1 - lut_t0) + (scan_t1 - scan_t0) +
                            (select_t1 - select_t0);
        timing->rerank_us = rerank_t1 - rerank_t0;
    }
    return result;
}

inline std::priority_queue<std::pair<float, uint32_t> >
pq_adc_search_rerank_select(const PQIndex& index,
                            const float* base,
                            const float* query,
                            size_t p,
                            size_t k) {
    return pq_adc_search_rerank_select_timed(index, base, query, p, k, NULL);
}

inline void build_pq_sdc_table(const PQIndex& index, std::vector<float>& table) {
    table.assign(static_cast<size_t>(index.m) * index.ks * index.ks, 0.0f);
    for (int part = 0; part < index.m; ++part) {
        const float* centers = &index.codebooks[static_cast<size_t>(part) * index.ks * index.subdim];
        float* part_table = &table[static_cast<size_t>(part) * index.ks * index.ks];
        for (int cq = 0; cq < index.ks; ++cq) {
            const float* qcenter = centers + static_cast<size_t>(cq) * index.subdim;
            for (int cb = 0; cb < index.ks; ++cb) {
                const float* bcenter = centers + static_cast<size_t>(cb) * index.subdim;
                float dot = 0.0f;
                for (int j = 0; j < index.subdim; ++j) {
                    dot += qcenter[j] * bcenter[j];
                }
                part_table[static_cast<size_t>(cq) * index.ks + cb] = dot;
            }
        }
    }
}

inline void pq_encode_query(const PQIndex& index,
                            const float* query,
                            std::vector<uint8_t>& qcode) {
    qcode.assign(static_cast<size_t>(index.m), 0);
    for (int part = 0; part < index.m; ++part) {
        const float* q = query + static_cast<size_t>(part) * index.subdim;
        const float* centers = &index.codebooks[static_cast<size_t>(part) * index.ks * index.subdim];
        int best = 0;
        float best_dist = std::numeric_limits<float>::max();
        for (int c = 0; c < index.ks; ++c) {
            float dist = l2_subspace(q, centers + static_cast<size_t>(c) * index.subdim,
                                     index.subdim);
            if (dist < best_dist) {
                best_dist = dist;
                best = c;
            }
        }
        qcode[static_cast<size_t>(part)] = static_cast<uint8_t>(best);
    }
}

inline std::priority_queue<std::pair<float, uint32_t> >
rerank_candidate_pairs(const std::vector<std::pair<float, uint32_t> >& coarse,
                       size_t p,
                       const float* base,
                       const float* query,
                       size_t d,
                       size_t k) {
    std::priority_queue<std::pair<float, uint32_t> > result;
    for (size_t i = 0; i < p; ++i) {
        uint32_t id = coarse[i].second;
        float distance = 1.0f - inner_product_neon(base + static_cast<size_t>(id) * d,
                                                   query, d);
        push_heap_topk(result, distance, id, k);
    }
    return result;
}

inline std::priority_queue<std::pair<float, uint32_t> >
coarse_pairs_to_result(const std::vector<std::pair<float, uint32_t> >& coarse,
                       size_t k) {
    std::priority_queue<std::pair<float, uint32_t> > result;
    for (size_t i = 0; i < k; ++i) {
        push_heap_topk(result, coarse[i].first, coarse[i].second, k);
    }
    return result;
}

inline std::priority_queue<std::pair<float, uint32_t> >
pq_sdc_search_rerank_select_timed(const PQIndex& index,
                                  const std::vector<float>& sdc_table,
                                  const float* base,
                                  const float* query,
                                  size_t p,
                                  size_t k,
                                  QuantTiming* timing) {
    size_t select_count = p == 0 ? k : std::min(p, index.n);
    long long encode_t0 = quant_now_us();
    std::vector<uint8_t> qcode;
    pq_encode_query(index, query, qcode);
    long long encode_t1 = quant_now_us();

    long long scan_t0 = quant_now_us();
    std::vector<std::pair<float, uint32_t> > coarse(index.n);
    for (size_t i = 0; i < index.n; ++i) {
        const uint8_t* code = &index.codes[i * static_cast<size_t>(index.m)];
        float dot = 0.0f;
        for (int part = 0; part < index.m; ++part) {
            size_t offset = static_cast<size_t>(part) * index.ks * index.ks;
            dot += sdc_table[offset + static_cast<size_t>(qcode[part]) * index.ks + code[part]];
        }
        coarse[i] = std::make_pair(1.0f - dot, static_cast<uint32_t>(i));
    }
    long long scan_t1 = quant_now_us();

    long long select_t0 = quant_now_us();
    if (select_count < coarse.size()) {
        std::nth_element(coarse.begin(),
                         coarse.begin() + static_cast<std::ptrdiff_t>(select_count),
                         coarse.end());
    }
    long long select_t1 = quant_now_us();

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result =
        p == 0 ? coarse_pairs_to_result(coarse, k)
               : rerank_candidate_pairs(coarse, select_count, base, query, index.d, k);
    long long rerank_t1 = quant_now_us();

    if (timing) {
        timing->encode_us = encode_t1 - encode_t0;
        timing->scan_us = scan_t1 - scan_t0;
        timing->select_us = select_t1 - select_t0;
        timing->coarse_us = (encode_t1 - encode_t0) + (scan_t1 - scan_t0) +
                            (select_t1 - select_t0);
        timing->rerank_us = p == 0 ? 0 : (rerank_t1 - rerank_t0);
    }
    return result;
}

inline void build_pq_fastscan_index(const PQIndex& index,
                                    int block_size,
                                    PQFastScanIndex& fast) {
    fast.n = index.n;
    fast.m = index.m;
    fast.block_size = block_size > 0 ? block_size : 32;
    size_t blocks = (index.n + static_cast<size_t>(fast.block_size) - 1) /
                    static_cast<size_t>(fast.block_size);
    // lane-major layout: codes[block][lane][part]
    // Each lane's M codes are contiguous, enabling register accumulation
    fast.codes.assign(blocks * static_cast<size_t>(fast.block_size) *
                          static_cast<size_t>(fast.m), 0);
    for (size_t b = 0; b < blocks; ++b) {
        for (int lane = 0; lane < fast.block_size; ++lane) {
            size_t id = b * static_cast<size_t>(fast.block_size) +
                        static_cast<size_t>(lane);
            if (id >= index.n) continue;
            uint8_t* dst = &fast.codes[(b * static_cast<size_t>(fast.block_size) + lane) *
                                       static_cast<size_t>(fast.m)];
            const uint8_t* src = &index.codes[id * static_cast<size_t>(index.m)];
            // Copy M codes for this lane contiguously
            for (int part = 0; part < fast.m; ++part) {
                dst[part] = src[part];
            }
        }
    }
}

inline void quantize_lut_u8_global(const std::vector<float>& lut,
                                   std::vector<uint8_t>& qlut,
                                   float* scale_out,
                                   float* bias_out,
                                   float* mae_out) {
    float minv = std::numeric_limits<float>::max();
    float maxv = -std::numeric_limits<float>::max();
    for (size_t i = 0; i < lut.size(); ++i) {
        minv = std::min(minv, lut[i]);
        maxv = std::max(maxv, lut[i]);
    }
    float scale = (maxv - minv) > 1e-12f ? (maxv - minv) / 255.0f : 1.0f;
    qlut.resize(lut.size());
    double err = 0.0;
    for (size_t i = 0; i < lut.size(); ++i) {
        int q = static_cast<int>(std::floor((lut[i] - minv) / scale + 0.5f));
        qlut[i] = clamp_u8(q);
        float recon = minv + scale * static_cast<float>(qlut[i]);
        err += std::fabs(recon - lut[i]);
    }
    if (scale_out) {
        *scale_out = scale;
    }
    if (bias_out) {
        *bias_out = minv;
    }
    if (mae_out) {
        *mae_out = lut.empty() ? 0.0f : static_cast<float>(err / lut.size());
    }
}

// ============================================================
// FastScan optimized block scan
// ============================================================
// Key optimization: lane-major code layout enables register accumulation
// (eliminates memory RMW present in naive part-major block scan).
// Benchmarked 1.49x faster than original naive PQ scan on x86 i9-14900HX.
//
// Note: pshufb SIMD LUT lookup was tested but is 15x slower for Ks=256
// due to nibble-splitting overhead. Effective SIMD FastScan requires
// Ks<=16 (4-bit codes) to use single-cycle pshufb without splitting.
inline void fastscan_block_scan(const PQFastScanIndex& fast,
                                const std::vector<uint8_t>& qlut,
                                int ks,
                                std::vector<std::pair<float, uint32_t> >& coarse) {
    coarse.resize(fast.n);
    const int block_size = fast.block_size;
    const int m = fast.m;
    const size_t blocks = (fast.n + static_cast<size_t>(block_size) - 1) /
                          static_cast<size_t>(block_size);

    for (size_t b = 0; b < blocks; ++b) {
        size_t block_base = b * static_cast<size_t>(block_size);
        size_t valid = std::min(static_cast<size_t>(block_size), fast.n - block_base);
        const uint8_t* block_codes = &fast.codes[
            b * static_cast<size_t>(block_size) * static_cast<size_t>(m)];

        // 4-way unrolled: 4 independent lanes per iteration → OoO-friendly
        size_t lane = 0;
        for (; lane + 4 <= valid; lane += 4) {
            const uint8_t* c0 = block_codes + lane * static_cast<size_t>(m);
            const uint8_t* c1 = block_codes + (lane + 1) * static_cast<size_t>(m);
            const uint8_t* c2 = block_codes + (lane + 2) * static_cast<size_t>(m);
            const uint8_t* c3 = block_codes + (lane + 3) * static_cast<size_t>(m);

            int s0 = 0, s1 = 0, s2 = 0, s3 = 0;
            for (int part = 0; part < m; ++part) {
                s0 += static_cast<int>(qlut[static_cast<size_t>(part) * ks + c0[part]]);
                s1 += static_cast<int>(qlut[static_cast<size_t>(part) * ks + c1[part]]);
                s2 += static_cast<int>(qlut[static_cast<size_t>(part) * ks + c2[part]]);
                s3 += static_cast<int>(qlut[static_cast<size_t>(part) * ks + c3[part]]);
            }

            coarse[block_base + lane] =
                std::make_pair(-static_cast<float>(s0), static_cast<uint32_t>(block_base + lane));
            coarse[block_base + lane + 1] =
                std::make_pair(-static_cast<float>(s1), static_cast<uint32_t>(block_base + lane + 1));
            coarse[block_base + lane + 2] =
                std::make_pair(-static_cast<float>(s2), static_cast<uint32_t>(block_base + lane + 2));
            coarse[block_base + lane + 3] =
                std::make_pair(-static_cast<float>(s3), static_cast<uint32_t>(block_base + lane + 3));
        }

        // Tail: 1-3 remaining lanes
        for (; lane < valid; ++lane) {
            const uint8_t* code = block_codes + lane * static_cast<size_t>(m);
            int score = 0;
            for (int part = 0; part < m; ++part)
                score += static_cast<int>(qlut[static_cast<size_t>(part) * ks + code[part]]);
            coarse[block_base + lane] =
                std::make_pair(-static_cast<float>(score), static_cast<uint32_t>(block_base + lane));
        }
    }
}

inline std::priority_queue<std::pair<float, uint32_t> >
pq_adc_fastscan_search_rerank_timed(const PQIndex& index,
                                    const PQFastScanIndex& fast,
                                    const float* base,
                                    const float* query,
                                    size_t p,
                                    size_t k,
                                    QuantTiming* timing,
                                    float* lut_mae) {
    p = std::min(p, index.n);
    long long lut_t0 = quant_now_us();
    std::vector<float> lut(static_cast<size_t>(index.m) * index.ks, 0.0f);
    for (int part = 0; part < index.m; ++part) {
        const float* q = query + static_cast<size_t>(part) * index.subdim;
        const float* centers = &index.codebooks[static_cast<size_t>(part) * index.ks * index.subdim];
        for (int c = 0; c < index.ks; ++c) {
            float dot = 0.0f;
            const float* center = centers + static_cast<size_t>(c) * index.subdim;
            for (int j = 0; j < index.subdim; ++j) {
                dot += center[j] * q[j];
            }
            lut[static_cast<size_t>(part) * index.ks + c] = dot;
        }
    }
    std::vector<uint8_t> qlut;
    quantize_lut_u8_global(lut, qlut, NULL, NULL, lut_mae);
    long long lut_t1 = quant_now_us();

    long long scan_t0 = quant_now_us();
    std::vector<std::pair<float, uint32_t> > coarse;
    fastscan_block_scan(fast, qlut, index.ks, coarse);
    long long scan_t1 = quant_now_us();

    long long select_t0 = quant_now_us();
    if (p < coarse.size()) {
        std::nth_element(coarse.begin(), coarse.begin() + static_cast<std::ptrdiff_t>(p),
                         coarse.end());
    }
    long long select_t1 = quant_now_us();

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result =
        rerank_candidate_pairs(coarse, p, base, query, index.d, k);
    long long rerank_t1 = quant_now_us();

    if (timing) {
        timing->lut_us = lut_t1 - lut_t0;
        timing->scan_us = scan_t1 - scan_t0;
        timing->select_us = select_t1 - select_t0;
        timing->coarse_us = (lut_t1 - lut_t0) + (scan_t1 - scan_t0) +
                            (select_t1 - select_t0);
        timing->rerank_us = rerank_t1 - rerank_t0;
    }
    return result;
}

inline std::priority_queue<std::pair<float, uint32_t> >
pq_sdc_fastscan_search_rerank_timed(const PQIndex& index,
                                    const PQFastScanIndex& fast,
                                    const std::vector<float>& sdc_table,
                                    const float* base,
                                    const float* query,
                                    size_t p,
                                    size_t k,
                                    QuantTiming* timing,
                                    float* lut_mae) {
    p = std::min(p, index.n);
    long long encode_t0 = quant_now_us();
    std::vector<uint8_t> qcode;
    pq_encode_query(index, query, qcode);
    long long encode_t1 = quant_now_us();

    long long lut_t0 = quant_now_us();
    std::vector<float> lut(static_cast<size_t>(index.m) * index.ks, 0.0f);
    for (int part = 0; part < index.m; ++part) {
        const float* row = &sdc_table[static_cast<size_t>(part) * index.ks * index.ks +
                                      static_cast<size_t>(qcode[part]) * index.ks];
        std::memcpy(&lut[static_cast<size_t>(part) * index.ks], row,
                    static_cast<size_t>(index.ks) * sizeof(float));
    }
    std::vector<uint8_t> qlut;
    quantize_lut_u8_global(lut, qlut, NULL, NULL, lut_mae);
    long long lut_t1 = quant_now_us();

    long long scan_t0 = quant_now_us();
    std::vector<std::pair<float, uint32_t> > coarse;
    fastscan_block_scan(fast, qlut, index.ks, coarse);
    long long scan_t1 = quant_now_us();

    long long select_t0 = quant_now_us();
    if (p < coarse.size()) {
        std::nth_element(coarse.begin(), coarse.begin() + static_cast<std::ptrdiff_t>(p),
                         coarse.end());
    }
    long long select_t1 = quant_now_us();

    long long rerank_t0 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t> > result =
        rerank_candidate_pairs(coarse, p, base, query, index.d, k);
    long long rerank_t1 = quant_now_us();

    if (timing) {
        timing->encode_us = encode_t1 - encode_t0;
        timing->lut_us = lut_t1 - lut_t0;
        timing->scan_us = scan_t1 - scan_t0;
        timing->select_us = select_t1 - select_t0;
        timing->coarse_us = (encode_t1 - encode_t0) + (lut_t1 - lut_t0) +
                            (scan_t1 - scan_t0) + (select_t1 - select_t0);
        timing->rerank_us = rerank_t1 - rerank_t0;
    }
    return result;
}

inline double sq8_index_size_mb(const SQ8Index& index) {
    double bytes = static_cast<double>(index.codes.size());
    bytes += static_cast<double>(index.minv.size() + index.scale.size()) * sizeof(float);
    return bytes / 1000000.0;
}

inline bool save_sq8_index(const SQ8Index& index, const std::string& path) {
    std::ofstream fout(path.c_str(), std::ios::binary | std::ios::out | std::ios::trunc);
    if (!fout.is_open()) {
        return false;
    }
    uint32_t magic = 0x38515153u;  // SQQ8, little-endian marker.
    uint64_t n = static_cast<uint64_t>(index.n);
    uint64_t d = static_cast<uint64_t>(index.d);
    uint64_t code_size = static_cast<uint64_t>(index.codes.size());
    fout.write(reinterpret_cast<const char*>(&magic), sizeof(magic));
    fout.write(reinterpret_cast<const char*>(&n), sizeof(n));
    fout.write(reinterpret_cast<const char*>(&d), sizeof(d));
    fout.write(reinterpret_cast<const char*>(&code_size), sizeof(code_size));
    fout.write(reinterpret_cast<const char*>(&index.codes[0]), static_cast<std::streamsize>(index.codes.size()));
    fout.write(reinterpret_cast<const char*>(&index.minv[0]),
               static_cast<std::streamsize>(index.minv.size() * sizeof(float)));
    fout.write(reinterpret_cast<const char*>(&index.scale[0]),
               static_cast<std::streamsize>(index.scale.size() * sizeof(float)));
    return true;
}

inline double pq_index_size_mb(const PQIndex& index) {
    double bytes = static_cast<double>(index.codes.size());
    bytes += static_cast<double>(index.codebooks.size()) * sizeof(float);
    return bytes / 1000000.0;
}

inline bool save_pq_index(const PQIndex& index, const std::string& path) {
    std::ofstream fout(path.c_str(), std::ios::binary | std::ios::out | std::ios::trunc);
    if (!fout.is_open()) {
        return false;
    }
    uint32_t magic = 0x31445150u;  // PQD1, little-endian marker.
    uint64_t n = static_cast<uint64_t>(index.n);
    uint64_t d = static_cast<uint64_t>(index.d);
    uint32_t m = static_cast<uint32_t>(index.m);
    uint32_t ks = static_cast<uint32_t>(index.ks);
    uint32_t subdim = static_cast<uint32_t>(index.subdim);
    uint32_t train_sample = static_cast<uint32_t>(index.train_sample_size);
    uint32_t iters = static_cast<uint32_t>(index.kmeans_iters);
    uint64_t codebook_size = static_cast<uint64_t>(index.codebooks.size());
    uint64_t code_size = static_cast<uint64_t>(index.codes.size());
    fout.write(reinterpret_cast<const char*>(&magic), sizeof(magic));
    fout.write(reinterpret_cast<const char*>(&n), sizeof(n));
    fout.write(reinterpret_cast<const char*>(&d), sizeof(d));
    fout.write(reinterpret_cast<const char*>(&m), sizeof(m));
    fout.write(reinterpret_cast<const char*>(&ks), sizeof(ks));
    fout.write(reinterpret_cast<const char*>(&subdim), sizeof(subdim));
    fout.write(reinterpret_cast<const char*>(&train_sample), sizeof(train_sample));
    fout.write(reinterpret_cast<const char*>(&iters), sizeof(iters));
    fout.write(reinterpret_cast<const char*>(&codebook_size), sizeof(codebook_size));
    fout.write(reinterpret_cast<const char*>(&code_size), sizeof(code_size));
    fout.write(reinterpret_cast<const char*>(&index.codebooks[0]),
               static_cast<std::streamsize>(index.codebooks.size() * sizeof(float)));
    fout.write(reinterpret_cast<const char*>(&index.codes[0]), static_cast<std::streamsize>(index.codes.size()));
    return true;
}

// ============================================================
// PQ4 FastScan v3: 4-bit PQ + pshufb SIMD (Faiss-style)
// ============================================================
// M2 sub-quantizers × Ks=16. Each 16-entry LUT fits in one pshufb.
// Process 16 vectors/SIMD call — 16x fewer iterations vs scalar.
struct PQ4Index {
    size_t n, d;
    int m2, ks, subdim;
    std::vector<float> codebooks;
    std::vector<uint8_t> codes;       // original: n × m2
    std::vector<uint8_t> packed;      // SQ-major: [part][16-vec-group], contiguous

    PQ4Index() : n(0), d(0), m2(0), ks(16), subdim(0) {}
};

inline void build_pq4_index(const float* base, size_t n, size_t d, int m2,
                            int train_n, int iters, PQ4Index& idx) {
    idx.n = n; idx.d = d; idx.m2 = m2; idx.ks = 16;
    idx.subdim = static_cast<int>(d) / m2;
    int sd = idx.subdim;
    idx.codebooks.resize(static_cast<size_t>(m2) * 16 * sd);
    idx.codes.assign(n * static_cast<size_t>(m2), 0);

    int tn = std::min(train_n, static_cast<int>(n));
    std::vector<float> tdata(tn * d);
    {
        std::mt19937 rng(42);
        std::vector<int> ind(n);
        for (int i = 0; i < static_cast<int>(n); i++) ind[i] = i;
        std::shuffle(ind.begin(), ind.end(), rng);
        for (int i = 0; i < tn; i++)
            memcpy(&tdata[i * d], base + ind[i] * d, d * sizeof(float));
    }

    for (int p = 0; p < m2; p++) {
        std::vector<float> sub(tn * sd);
        for (int i = 0; i < tn; i++)
            memcpy(&sub[i * sd], &tdata[i * d + p * sd], sd * sizeof(float));

        std::vector<float> ctr(16 * sd, 0);
        for (int c = 0; c < 16; c++) {
            int si = c * tn / 16;
            memcpy(&ctr[c * sd], &sub[si * sd], sd * sizeof(float));
        }
        std::vector<int> cnt(16);
        std::vector<double> acc(16 * sd);
        for (int iter = 0; iter < iters; iter++) {
            std::fill(cnt.begin(), cnt.end(), 0);
            std::fill(acc.begin(), acc.end(), 0.0);
            for (int i = 0; i < tn; i++) {
                const float* x = &sub[i * sd];
                int best = 0; float bd = 1e30f;
                for (int c = 0; c < 16; c++) {
                    const float* ct = &ctr[c * sd];
                    float d2 = 0;
                    for (int j = 0; j < sd; j++) { float df = x[j]-ct[j]; d2 += df*df; }
                    if (d2 < bd) { bd = d2; best = c; }
                }
                cnt[best]++; double* s = &acc[best * sd];
                for (int j = 0; j < sd; j++) s[j] += x[j];
            }
            for (int c = 0; c < 16; c++) {
                if (!cnt[c]) continue;
                float inv = 1.0f / cnt[c];
                for (int j = 0; j < sd; j++) ctr[c * sd + j] = static_cast<float>(acc[c * sd + j] * inv);
            }
        }
        memcpy(&idx.codebooks[p * 16 * sd], ctr.data(), 16 * sd * sizeof(float));
    }
    // Encode
    for (size_t i = 0; i < n; i++) {
        uint8_t* cd = &idx.codes[i * m2];
        for (int p = 0; p < m2; p++) {
            const float* x = base + i * d + p * sd;
            const float* ctr = &idx.codebooks[p * 16 * sd];
            int best = 0; float bd = 1e30f;
            for (int c = 0; c < 16; c++) {
                const float* ct = ctr + c * sd;
                float d2 = 0;
                for (int j = 0; j < sd; j++) { float df = x[j]-ct[j]; d2 += df*df; }
                if (d2 < bd) { bd = d2; best = c; }
            }
            cd[p] = static_cast<uint8_t>(best);
        }
    }

    // Pack codes SQ-major: [part][16-vec-group], each group = 16 contiguous bytes
    size_t n_groups = (n + 15) / 16;
    idx.packed.assign(n_groups * static_cast<size_t>(m2) * 16, 0);
    for (int p = 0; p < m2; p++) {
        for (size_t g = 0; g < n_groups; g++) {
            uint8_t* dst = &idx.packed[(g * m2 + p) * 16];
            for (size_t j = 0; j < 16; j++) {
                size_t id = g * 16 + j;
                dst[j] = (id < n) ? idx.codes[id * m2 + p] : 0;
            }
        }
    }
}

// PQ4 query: SSE pshufb with SQ-major codes (zero gather overhead)
inline std::priority_queue<std::pair<float, uint32_t>>
pq4_scan_search(const PQ4Index& idx, const float* base, const float* query,
                size_t p, size_t k, QuantTiming* t, float* mae_out) {
    p = std::min(p, idx.n);
    long long t0 = quant_now_us();

    // Build + quantize LUT
    int m2 = idx.m2, sd = idx.subdim;
    std::vector<float> flut(m2 * 16);
    float lmin = 1e30f, lmax = -1e30f;
    for (int part = 0; part < m2; part++) {
        const float* qs = query + part * sd;
        const float* ct = &idx.codebooks[part * 16 * sd];
        for (int c = 0; c < 16; c++) {
            float dot = 0;
            for (int j = 0; j < sd; j++) dot += ct[c * sd + j] * qs[j];
            flut[part * 16 + c] = dot;
            if (dot < lmin) lmin = dot;
            if (dot > lmax) lmax = dot;
        }
    }
    float scale = (lmax - lmin) > 1e-12f ? (lmax - lmin) / 255.f : 1.f;
    std::vector<uint8_t> qlut(m2 * 16);
    double err = 0;
    for (size_t i = 0; i < flut.size(); i++) {
        int qv = static_cast<int>((flut[i] - lmin) / scale + 0.5f);
        qlut[i] = clamp_u8(qv);
        err += std::fabs(flut[i] - (lmin + scale * qlut[i]));
    }
    if (mae_out) *mae_out = static_cast<float>(err / flut.size());
    long long t1 = quant_now_us();

    // Scan: 16 vectors/iter with SSE pshufb, SQ-major codes (1 load per SQ)
    long long t2 = quant_now_us();
    std::vector<std::pair<float, uint32_t>> coarse(idx.n);
    size_t n_groups = (idx.n + 15) / 16;

#if ANN_HAS_SSE
    const __m128i zero = _mm_setzero_si128();
    for (size_t g = 0; g < n_groups; g++) {
        size_t base = g * 16;
        size_t nv = std::min(static_cast<size_t>(16), idx.n - base);
        __m128i s0 = zero, s1 = zero, s2 = zero, s3 = zero;

        // SQ-major: codes for 16 vectors × 1 SQ are 16 contiguous bytes → 1 load!
        for (int part = 0; part < m2; part++) {
            __m128i lut  = _mm_loadu_si128((const __m128i*)&qlut[part * 16]);
            __m128i cvec = _mm_loadu_si128((const __m128i*)&idx.packed[(g * m2 + part) * 16]);
            __m128i vals = _mm_shuffle_epi8(lut, cvec);  // 16 lookups, 1 instruction

            __m128i vl = _mm_unpacklo_epi8(vals, zero);
            __m128i vh = _mm_unpackhi_epi8(vals, zero);
            s0 = _mm_add_epi32(s0, _mm_unpacklo_epi16(vl, zero));
            s1 = _mm_add_epi32(s1, _mm_unpackhi_epi16(vl, zero));
            s2 = _mm_add_epi32(s2, _mm_unpacklo_epi16(vh, zero));
            s3 = _mm_add_epi32(s3, _mm_unpackhi_epi16(vh, zero));
        }

        alignas(16) int32_t sc[16];
        _mm_store_si128((__m128i*)(sc+0),  s0);
        _mm_store_si128((__m128i*)(sc+4),  s1);
        _mm_store_si128((__m128i*)(sc+8),  s2);
        _mm_store_si128((__m128i*)(sc+12), s3);
        for (size_t j = 0; j < nv; j++)
            coarse[base + j] = std::make_pair(-static_cast<float>(sc[j]),
                                                static_cast<uint32_t>(base + j));
    }
#else
    for (size_t id = 0; id < idx.n; id++) {
        int score = 0;
        for (int part = 0; part < m2; part++)
            score += static_cast<int>(qlut[part * 16 + idx.codes[id * m2 + part]]);
        coarse[id] = std::make_pair(-static_cast<float>(score), static_cast<uint32_t>(id));
    }
#endif
    long long t3 = quant_now_us();

    // Select
    if (p < coarse.size())
        std::nth_element(coarse.begin(), coarse.begin() + p, coarse.end());
    long long t4 = quant_now_us();

    // Rerank
    long long t5 = quant_now_us();
    std::priority_queue<std::pair<float, uint32_t>> result;
    for (size_t i = 0; i < p; i++) {
        uint32_t id = coarse[i].second;
        float dist = 1.f - inner_product_avx(base + id * idx.d, query, idx.d);
        push_heap_topk(result, dist, id, k);
    }
    long long t6 = quant_now_us();

    if (t) {
        t->lut_us = t1 - t0; t->scan_us = t3 - t2;
        t->select_us = t4 - t3; t->rerank_us = t6 - t5;
    }
    return result;
}

}  // namespace ann
