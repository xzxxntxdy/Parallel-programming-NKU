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
    std::vector<uint8_t> codes;

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
    fast.codes.assign(blocks * static_cast<size_t>(fast.m) *
                          static_cast<size_t>(fast.block_size),
                      0);
    for (size_t b = 0; b < blocks; ++b) {
        for (int part = 0; part < fast.m; ++part) {
            uint8_t* dst = &fast.codes[(b * static_cast<size_t>(fast.m) + part) *
                                       static_cast<size_t>(fast.block_size)];
            for (int lane = 0; lane < fast.block_size; ++lane) {
                size_t id = b * static_cast<size_t>(fast.block_size) +
                            static_cast<size_t>(lane);
                if (id < index.n) {
                    dst[lane] = index.codes[id * static_cast<size_t>(index.m) + part];
                }
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

inline void fastscan_block_scan(const PQFastScanIndex& fast,
                                const std::vector<uint8_t>& qlut,
                                int ks,
                                std::vector<std::pair<float, uint32_t> >& coarse) {
    coarse.resize(fast.n);
    const int block_size = fast.block_size;
    const size_t blocks = (fast.n + static_cast<size_t>(block_size) - 1) /
                          static_cast<size_t>(block_size);
    std::vector<int> scores(static_cast<size_t>(block_size), 0);
    for (size_t b = 0; b < blocks; ++b) {
        std::fill(scores.begin(), scores.end(), 0);
        size_t block_base = b * static_cast<size_t>(block_size);
        size_t valid = std::min(static_cast<size_t>(block_size), fast.n - block_base);
        for (int part = 0; part < fast.m; ++part) {
            const uint8_t* codes = &fast.codes[(b * static_cast<size_t>(fast.m) + part) *
                                               static_cast<size_t>(block_size)];
            const uint8_t* lut = &qlut[static_cast<size_t>(part) * ks];
            for (size_t lane = 0; lane < valid; ++lane) {
                scores[lane] += static_cast<int>(lut[codes[lane]]);
            }
        }
        for (size_t lane = 0; lane < valid; ++lane) {
            uint32_t id = static_cast<uint32_t>(block_base + lane);
            coarse[block_base + lane] =
                std::make_pair(-static_cast<float>(scores[lane]), id);
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

}  // namespace ann
