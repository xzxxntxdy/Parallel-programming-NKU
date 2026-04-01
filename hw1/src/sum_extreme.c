#include "bench_cpu_arch.h"

#if defined(__SSE2__)
#include <emmintrin.h>
#include <xmmintrin.h>
#endif

#define SUM_EXTREME_STREAMING_THRESHOLD 50000000ULL

#if defined(__SSE__)
static float horizontal_add_ps_sum(__m128 value) {
    __m128 high = _mm_movehl_ps(value, value);
    __m128 sum = _mm_add_ps(value, high);
    __m128 shuffled = _mm_shuffle_ps(sum, sum, 0x55);
    sum = _mm_add_ss(sum, shuffled);
    return _mm_cvtss_f32(sum);
}
#endif

#if defined(__SSE2__)
static double horizontal_add_pd_sum(__m128d value) {
    __m128d high = _mm_unpackhi_pd(value, value);
    value = _mm_add_sd(value, high);
    return _mm_cvtsd_f64(value);
}
#endif

static float sum_extreme_f32_streaming_impl(const float *data, size_t n) {
    const float * RESTRICT values = (const float * RESTRICT)ASSUME_ALIGNED(data, 64U);
    float acc0 = 0.0f;
    float acc1 = 0.0f;
    float acc2 = 0.0f;
    float acc3 = 0.0f;
    float acc4 = 0.0f;
    float acc5 = 0.0f;
    float acc6 = 0.0f;
    float acc7 = 0.0f;
    size_t i = 0;

    for (; i + 16U <= n; i += 16U) {
        acc0 += values[i + 0U] + values[i + 8U];
        acc1 += values[i + 1U] + values[i + 9U];
        acc2 += values[i + 2U] + values[i + 10U];
        acc3 += values[i + 3U] + values[i + 11U];
        acc4 += values[i + 4U] + values[i + 12U];
        acc5 += values[i + 5U] + values[i + 13U];
        acc6 += values[i + 6U] + values[i + 14U];
        acc7 += values[i + 7U] + values[i + 15U];
    }
    for (; i + 8U <= n; i += 8U) {
        acc0 += values[i + 0U];
        acc1 += values[i + 1U];
        acc2 += values[i + 2U];
        acc3 += values[i + 3U];
        acc4 += values[i + 4U];
        acc5 += values[i + 5U];
        acc6 += values[i + 6U];
        acc7 += values[i + 7U];
    }
    for (; i < n; ++i) {
        acc0 += values[i];
    }
    return ((acc0 + acc1) + (acc2 + acc3)) + ((acc4 + acc5) + (acc6 + acc7));
}

static double sum_extreme_f64_streaming_impl(const double *data, size_t n) {
    const double * RESTRICT values = (const double * RESTRICT)ASSUME_ALIGNED(data, 64U);
    double acc0 = 0.0;
    double acc1 = 0.0;
    double acc2 = 0.0;
    double acc3 = 0.0;
    double acc4 = 0.0;
    double acc5 = 0.0;
    double acc6 = 0.0;
    double acc7 = 0.0;
    size_t i = 0;

    for (; i + 16U <= n; i += 16U) {
        acc0 += values[i + 0U] + values[i + 8U];
        acc1 += values[i + 1U] + values[i + 9U];
        acc2 += values[i + 2U] + values[i + 10U];
        acc3 += values[i + 3U] + values[i + 11U];
        acc4 += values[i + 4U] + values[i + 12U];
        acc5 += values[i + 5U] + values[i + 13U];
        acc6 += values[i + 6U] + values[i + 14U];
        acc7 += values[i + 7U] + values[i + 15U];
    }
    for (; i + 8U <= n; i += 8U) {
        acc0 += values[i + 0U];
        acc1 += values[i + 1U];
        acc2 += values[i + 2U];
        acc3 += values[i + 3U];
        acc4 += values[i + 4U];
        acc5 += values[i + 5U];
        acc6 += values[i + 6U];
        acc7 += values[i + 7U];
    }
    for (; i < n; ++i) {
        acc0 += values[i];
    }
    return ((acc0 + acc1) + (acc2 + acc3)) + ((acc4 + acc5) + (acc6 + acc7));
}

float sum_extreme_f32(const float *data, size_t n) {
    if (n >= (size_t)SUM_EXTREME_STREAMING_THRESHOLD) {
        return sum_extreme_f32_streaming_impl(data, n);
    }
#if defined(__SSE__)
    {
        const float * RESTRICT values = (const float * RESTRICT)ASSUME_ALIGNED(data, 64U);
        __m128 acc0 = _mm_setzero_ps();
        __m128 acc1 = _mm_setzero_ps();
        __m128 acc2 = _mm_setzero_ps();
        __m128 acc3 = _mm_setzero_ps();
        size_t i = 0;
        float sum;

        for (; i + 16U <= n; i += 16U) {
            acc0 = _mm_add_ps(acc0, _mm_loadu_ps(values + i + 0U));
            acc1 = _mm_add_ps(acc1, _mm_loadu_ps(values + i + 4U));
            acc2 = _mm_add_ps(acc2, _mm_loadu_ps(values + i + 8U));
            acc3 = _mm_add_ps(acc3, _mm_loadu_ps(values + i + 12U));
        }

        sum = horizontal_add_ps_sum(_mm_add_ps(_mm_add_ps(acc0, acc1), _mm_add_ps(acc2, acc3)));
        for (; i + 4U <= n; i += 4U) {
            sum += horizontal_add_ps_sum(_mm_loadu_ps(values + i));
        }
        for (; i < n; ++i) {
            sum += values[i];
        }
        return sum;
    }
#else
    return sum_extreme_f32_streaming_impl(data, n);
#endif
}

double sum_extreme_f64(const double *data, size_t n) {
    if (n >= (size_t)SUM_EXTREME_STREAMING_THRESHOLD) {
        return sum_extreme_f64_streaming_impl(data, n);
    }
#if defined(__SSE2__)
    {
        const double * RESTRICT values = (const double * RESTRICT)ASSUME_ALIGNED(data, 64U);
        __m128d acc0 = _mm_setzero_pd();
        __m128d acc1 = _mm_setzero_pd();
        __m128d acc2 = _mm_setzero_pd();
        __m128d acc3 = _mm_setzero_pd();
        size_t i = 0;
        double sum;

        for (; i + 8U <= n; i += 8U) {
            acc0 = _mm_add_pd(acc0, _mm_loadu_pd(values + i + 0U));
            acc1 = _mm_add_pd(acc1, _mm_loadu_pd(values + i + 2U));
            acc2 = _mm_add_pd(acc2, _mm_loadu_pd(values + i + 4U));
            acc3 = _mm_add_pd(acc3, _mm_loadu_pd(values + i + 6U));
        }

        sum = horizontal_add_pd_sum(_mm_add_pd(_mm_add_pd(acc0, acc1), _mm_add_pd(acc2, acc3)));
        for (; i + 2U <= n; i += 2U) {
            sum += horizontal_add_pd_sum(_mm_loadu_pd(values + i));
        }
        for (; i < n; ++i) {
            sum += values[i];
        }
        return sum;
    }
#else
    return sum_extreme_f64_streaming_impl(data, n);
#endif
}
