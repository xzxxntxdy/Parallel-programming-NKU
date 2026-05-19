#pragma once

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <queue>
#include <utility>
#include <vector>

// --- SIMD feature detection (GCC, Clang, MSVC) ---
#ifdef _MSC_VER
  // MSVC: x64 always has SSE2; AVX/AVX2 via /arch: flag
  #if defined(__AVX2__) || defined(__AVX__)
    #define ANN_HAS_AVX 1
    #define ANN_HAS_SSE 1
  #else
    #define ANN_HAS_AVX 0
    #define ANN_HAS_SSE 1  // SSE2 baseline on x64
  #endif
  #define ANN_HAS_NEON 0
#else
  // GCC / Clang
  #if defined(__ARM_NEON) || defined(__ARM_NEON__) || defined(__aarch64__)
    #include <arm_neon.h>
    #define ANN_HAS_NEON 1
  #else
    #define ANN_HAS_NEON 0
  #endif
  #if defined(__AVX__) || defined(__AVX2__)
    #define ANN_HAS_AVX 1
  #else
    #define ANN_HAS_AVX 0
  #endif
  #if defined(__SSE__) || defined(__SSE2__)
    #define ANN_HAS_SSE 1
  #else
    #define ANN_HAS_SSE 0
  #endif
#endif

#if ANN_HAS_AVX || ANN_HAS_SSE
  #include <immintrin.h>
#endif

// GCC no-vectorize attribute
#if defined(__GNUC__) && !defined(__clang__)
  #define ANN_NOVEC __attribute__((noinline, optimize("no-tree-vectorize")))
#elif defined(_MSC_VER)
  #define ANN_NOVEC __declspec(noinline)
#else
  #define ANN_NOVEC
#endif

// __builtin_prefetch → _mm_prefetch on MSVC
#ifdef _MSC_VER
  #include <xmmintrin.h>
  #define ANN_PREFETCH(addr) _mm_prefetch((const char*)(addr), _MM_HINT_T0)
#else
  #define ANN_PREFETCH(addr) __builtin_prefetch((addr), 0, 1)
#endif

namespace ann {

enum SearchMethod {
    kScalarNoVec = 0,
    kAutoVectorized = 1,
    kManualNeon = 2,
    kManualNeonAligned = 3,
    kManualNeonUnroll2 = 4,
    kManualNeonUnroll4 = 5,
    kManualNeonUnroll4PrefetchHeap = 6,
    kManualNeonUnroll4PrefetchFixedTopK = 7,
    kManualSse = 8,
    kManualAvx = 9
};

inline const char* method_name(SearchMethod method) {
    switch (method) {
    case kScalarNoVec:
        return "Flat-Scalar-NoVec";
    case kAutoVectorized:
        return "Flat-AutoVec";
    case kManualNeon:
        return "Flat-Manual-NEON";
    case kManualNeonAligned:
        return "Flat-NEON-AlignedHint";
    case kManualNeonUnroll2:
        return "Flat-NEON-Unroll2";
    case kManualNeonUnroll4:
        return "Flat-NEON-Unroll4";
    case kManualNeonUnroll4PrefetchHeap:
        return "Flat-NEON-Unroll4-Prefetch";
    case kManualNeonUnroll4PrefetchFixedTopK:
        return "Flat-NEON-Unroll4-Prefetch-FixedTopK";
    case kManualSse:
        return "Flat-Manual-SSE";
    case kManualAvx:
        return "Flat-Manual-AVX";
    default:
        return "Unknown";
    }
}

#if ANN_HAS_SSE
inline float horizontal_sum_sse(__m128 v) {
    float tmp[4];
    _mm_storeu_ps(tmp, v);
    return tmp[0] + tmp[1] + tmp[2] + tmp[3];
}
#endif

#if ANN_HAS_AVX
inline float horizontal_sum_avx(__m256 v) {
    __m128 low = _mm256_castps256_ps128(v);
    __m128 high = _mm256_extractf128_ps(v, 1);
    return horizontal_sum_sse(_mm_add_ps(low, high));
}
#endif

#if ANN_HAS_NEON
inline float horizontal_sum_neon(float32x4_t v) {
#if defined(__aarch64__)
    return vaddvq_f32(v);
#else
    float32x2_t low = vget_low_f32(v);
    float32x2_t high = vget_high_f32(v);
    float32x2_t sum = vpadd_f32(low, high);
    sum = vpadd_f32(sum, sum);
    return vget_lane_f32(sum, 0);
#endif
}
#endif

inline bool is_aligned_to(const void* ptr, size_t bytes) {
    return (reinterpret_cast<std::uintptr_t>(ptr) % bytes) == 0;
}

static ANN_NOVEC float inner_product_scalar_novec(const float* a,
                                                  const float* b,
                                                  size_t dim) {
    float sum = 0.0f;
    for (size_t d = 0; d < dim; ++d) {
        sum += a[d] * b[d];
    }
    return sum;
}

inline float inner_product_auto(const float* a, const float* b, size_t dim) {
    float sum0 = 0.0f;
    float sum1 = 0.0f;
    float sum2 = 0.0f;
    float sum3 = 0.0f;
    size_t d = 0;
    for (; d + 4 <= dim; d += 4) {
        sum0 += a[d] * b[d];
        sum1 += a[d + 1] * b[d + 1];
        sum2 += a[d + 2] * b[d + 2];
        sum3 += a[d + 3] * b[d + 3];
    }
    float result = (sum0 + sum1) + (sum2 + sum3);
    for (; d < dim; ++d) {
        result += a[d] * b[d];
    }
    return result;
}

inline float inner_product_sse(const float* a, const float* b, size_t dim) {
#if ANN_HAS_SSE
    __m128 sum0 = _mm_setzero_ps();
    __m128 sum1 = _mm_setzero_ps();
    __m128 sum2 = _mm_setzero_ps();
    __m128 sum3 = _mm_setzero_ps();

    size_t d = 0;
    for (; d + 16 <= dim; d += 16) {
        sum0 = _mm_add_ps(sum0, _mm_mul_ps(_mm_loadu_ps(a + d), _mm_loadu_ps(b + d)));
        sum1 = _mm_add_ps(sum1, _mm_mul_ps(_mm_loadu_ps(a + d + 4), _mm_loadu_ps(b + d + 4)));
        sum2 = _mm_add_ps(sum2, _mm_mul_ps(_mm_loadu_ps(a + d + 8), _mm_loadu_ps(b + d + 8)));
        sum3 = _mm_add_ps(sum3, _mm_mul_ps(_mm_loadu_ps(a + d + 12), _mm_loadu_ps(b + d + 12)));
    }

    __m128 total = _mm_add_ps(_mm_add_ps(sum0, sum1), _mm_add_ps(sum2, sum3));
    float result = horizontal_sum_sse(total);
    for (; d < dim; ++d) {
        result += a[d] * b[d];
    }
    return result;
#else
    return inner_product_auto(a, b, dim);
#endif
}

inline float inner_product_avx(const float* a, const float* b, size_t dim) {
#if ANN_HAS_AVX
    __m256 sum0 = _mm256_setzero_ps();
    __m256 sum1 = _mm256_setzero_ps();

    size_t d = 0;
    for (; d + 16 <= dim; d += 16) {
        sum0 = _mm256_add_ps(sum0, _mm256_mul_ps(_mm256_loadu_ps(a + d), _mm256_loadu_ps(b + d)));
        sum1 = _mm256_add_ps(sum1, _mm256_mul_ps(_mm256_loadu_ps(a + d + 8), _mm256_loadu_ps(b + d + 8)));
    }

    float result = horizontal_sum_avx(_mm256_add_ps(sum0, sum1));
    for (; d < dim; ++d) {
        result += a[d] * b[d];
    }
    return result;
#else
    return inner_product_sse(a, b, dim);
#endif
}

inline float inner_product_neon(const float* a, const float* b, size_t dim) {
#if ANN_HAS_NEON
    float32x4_t sum = vdupq_n_f32(0.0f);
    size_t d = 0;
    for (; d + 4 <= dim; d += 4) {
        sum = vmlaq_f32(sum, vld1q_f32(a + d), vld1q_f32(b + d));
    }
    float result = horizontal_sum_neon(sum);
    for (; d < dim; ++d) {
        result += a[d] * b[d];
    }
    return result;
#else
    return inner_product_auto(a, b, dim);
#endif
}

inline float inner_product_neon_aligned_hint(const float* a, const float* b, size_t dim) {
#if ANN_HAS_NEON
    if (!is_aligned_to(a, 16) || !is_aligned_to(b, 16)) {
        return inner_product_neon(a, b, dim);
    }
#if defined(__GNUC__)
    a = static_cast<const float*>(__builtin_assume_aligned(a, 16));
    b = static_cast<const float*>(__builtin_assume_aligned(b, 16));
#endif
    return inner_product_neon(a, b, dim);
#else
    return inner_product_auto(a, b, dim);
#endif
}

inline float inner_product_neon_unroll2(const float* a, const float* b, size_t dim) {
#if ANN_HAS_NEON
    float32x4_t sum0 = vdupq_n_f32(0.0f);
    float32x4_t sum1 = vdupq_n_f32(0.0f);

    size_t d = 0;
    for (; d + 8 <= dim; d += 8) {
        sum0 = vmlaq_f32(sum0, vld1q_f32(a + d), vld1q_f32(b + d));
        sum1 = vmlaq_f32(sum1, vld1q_f32(a + d + 4), vld1q_f32(b + d + 4));
    }

    float result = horizontal_sum_neon(vaddq_f32(sum0, sum1));
    for (; d < dim; ++d) {
        result += a[d] * b[d];
    }
    return result;
#else
    return inner_product_auto(a, b, dim);
#endif
}

inline float inner_product_neon_unroll4(const float* a, const float* b, size_t dim) {
#if ANN_HAS_NEON
    float32x4_t sum0 = vdupq_n_f32(0.0f);
    float32x4_t sum1 = vdupq_n_f32(0.0f);
    float32x4_t sum2 = vdupq_n_f32(0.0f);
    float32x4_t sum3 = vdupq_n_f32(0.0f);

    size_t d = 0;
    for (; d + 16 <= dim; d += 16) {
        sum0 = vmlaq_f32(sum0, vld1q_f32(a + d), vld1q_f32(b + d));
        sum1 = vmlaq_f32(sum1, vld1q_f32(a + d + 4), vld1q_f32(b + d + 4));
        sum2 = vmlaq_f32(sum2, vld1q_f32(a + d + 8), vld1q_f32(b + d + 8));
        sum3 = vmlaq_f32(sum3, vld1q_f32(a + d + 12), vld1q_f32(b + d + 12));
    }

    float32x4_t total = vaddq_f32(vaddq_f32(sum0, sum1), vaddq_f32(sum2, sum3));
    float result = horizontal_sum_neon(total);
    for (; d < dim; ++d) {
        result += a[d] * b[d];
    }
    return result;
#else
    return inner_product_auto(a, b, dim);
#endif
}

inline float ip_distance(const float* base, const float* query, size_t dim, SearchMethod method) {
    switch (method) {
    case kScalarNoVec:
        return 1.0f - inner_product_scalar_novec(base, query, dim);
    case kAutoVectorized:
        return 1.0f - inner_product_auto(base, query, dim);
    case kManualNeon:
        return 1.0f - inner_product_neon(base, query, dim);
    case kManualNeonAligned:
        return 1.0f - inner_product_neon_aligned_hint(base, query, dim);
    case kManualNeonUnroll2:
        return 1.0f - inner_product_neon_unroll2(base, query, dim);
    case kManualNeonUnroll4:
    case kManualNeonUnroll4PrefetchHeap:
    case kManualNeonUnroll4PrefetchFixedTopK:
        return 1.0f - inner_product_neon_unroll4(base, query, dim);
    case kManualSse:
        return 1.0f - inner_product_sse(base, query, dim);
    case kManualAvx:
        return 1.0f - inner_product_avx(base, query, dim);
    default:
        return 1.0f - inner_product_auto(base, query, dim);
    }
}

inline void push_heap_topk(std::priority_queue<std::pair<float, uint32_t> >& heap,
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

class FixedTopK {
public:
    explicit FixedTopK(size_t k) : k_(k), worst_(0) {
        items_.reserve(k);
    }

    void push(float distance, uint32_t id) {
        if (k_ == 0) {
            return;
        }
        if (items_.size() < k_) {
            items_.push_back(std::make_pair(distance, id));
            if (items_.size() == k_) {
                recompute_worst();
            }
            return;
        }
        if (distance >= items_[worst_].first) {
            return;
        }
        items_[worst_] = std::make_pair(distance, id);
        recompute_worst();
    }

    std::priority_queue<std::pair<float, uint32_t> > to_queue() const {
        std::priority_queue<std::pair<float, uint32_t> > heap;
        for (size_t i = 0; i < items_.size(); ++i) {
            heap.push(items_[i]);
        }
        return heap;
    }

private:
    void recompute_worst() {
        worst_ = 0;
        for (size_t i = 1; i < items_.size(); ++i) {
            if (items_[worst_].first < items_[i].first) {
                worst_ = i;
            }
        }
    }

    size_t k_;
    size_t worst_;
    std::vector<std::pair<float, uint32_t> > items_;
};

inline bool uses_prefetch(SearchMethod method) {
    return method == kManualNeonUnroll4PrefetchHeap ||
           method == kManualNeonUnroll4PrefetchFixedTopK;
}

inline bool uses_fixed_topk(SearchMethod method) {
    return method == kManualNeonUnroll4PrefetchFixedTopK;
}

inline std::priority_queue<std::pair<float, uint32_t> >
flat_search_method(const float* base,
                   const float* query,
                   size_t base_number,
                   size_t vecdim,
                   size_t k,
                   SearchMethod method,
                   size_t prefetch_distance = 16) {
    if (uses_fixed_topk(method)) {
        FixedTopK topk(k);
        for (size_t i = 0; i < base_number; ++i) {
            if (uses_prefetch(method) && prefetch_distance > 0 &&
                i + prefetch_distance < base_number) {
                ANN_PREFETCH(base + (i + prefetch_distance) * vecdim);
            }
            float distance = ip_distance(base + i * vecdim, query, vecdim, method);
            topk.push(distance, static_cast<uint32_t>(i));
        }
        return topk.to_queue();
    }

    std::priority_queue<std::pair<float, uint32_t> > heap;
    for (size_t i = 0; i < base_number; ++i) {
            if (uses_prefetch(method) && prefetch_distance > 0 &&
            i + prefetch_distance < base_number) {
            ANN_PREFETCH(base + (i + prefetch_distance) * vecdim);
        }

        float distance = ip_distance(base + i * vecdim, query, vecdim, method);
        push_heap_topk(heap, distance, static_cast<uint32_t>(i), k);
    }
    return heap;
}

inline std::priority_queue<std::pair<float, uint32_t> >
flat_search_best(const float* base,
                 const float* query,
                 size_t base_number,
                 size_t vecdim,
                 size_t k) {
    return flat_search_method(base, query, base_number, vecdim, k,
                              kManualNeon);
}

}  // namespace ann
