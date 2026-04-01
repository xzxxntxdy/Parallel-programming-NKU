#include "bench_cpu_arch.h"

#if defined(__SSE2__)
#include <emmintrin.h>
#include <xmmintrin.h>
#endif

#if defined(__SSE__)
static float horizontal_add_ps(__m128 value) {
    __m128 high = _mm_movehl_ps(value, value);
    __m128 sum = _mm_add_ps(value, high);
    __m128 shuffled = _mm_shuffle_ps(sum, sum, 0x55);
    sum = _mm_add_ss(sum, shuffled);
    return _mm_cvtss_f32(sum);
}
#endif

#if defined(__SSE2__)
static double horizontal_add_pd(__m128d value) {
    __m128d high = _mm_unpackhi_pd(value, value);
    value = _mm_add_sd(value, high);
    return _mm_cvtsd_f64(value);
}
#endif

#if !defined(__SSE__)
static void matvec_extreme_f32_scalar(const float *matrix_t, const float *vector, float *out, size_t n) {
    const float * RESTRICT matrix = (const float * RESTRICT)ASSUME_ALIGNED(matrix_t, 64U);
    const float * RESTRICT vec = (const float * RESTRICT)ASSUME_ALIGNED(vector, 64U);
    float * RESTRICT dst = (float * RESTRICT)ASSUME_ALIGNED(out, 64U);
    size_t col;

    for (col = 0; col < n; ++col) {
        const float * RESTRICT column = matrix + col * n;
        float acc0 = 0.0f;
        float acc1 = 0.0f;
        float acc2 = 0.0f;
        float acc3 = 0.0f;
        float acc4 = 0.0f;
        float acc5 = 0.0f;
        float acc6 = 0.0f;
        float acc7 = 0.0f;
        size_t row = 0;

        for (; row + 8U <= n; row += 8U) {
            acc0 += column[row + 0U] * vec[row + 0U];
            acc1 += column[row + 1U] * vec[row + 1U];
            acc2 += column[row + 2U] * vec[row + 2U];
            acc3 += column[row + 3U] * vec[row + 3U];
            acc4 += column[row + 4U] * vec[row + 4U];
            acc5 += column[row + 5U] * vec[row + 5U];
            acc6 += column[row + 6U] * vec[row + 6U];
            acc7 += column[row + 7U] * vec[row + 7U];
        }

        dst[col] = ((acc0 + acc1) + (acc2 + acc3)) + ((acc4 + acc5) + (acc6 + acc7));
        for (; row < n; ++row) {
            dst[col] += column[row] * vec[row];
        }
    }
}
#endif

#if !defined(__SSE2__)
static void matvec_extreme_f64_scalar(const double *matrix_t, const double *vector, double *out, size_t n) {
    const double * RESTRICT matrix = (const double * RESTRICT)ASSUME_ALIGNED(matrix_t, 64U);
    const double * RESTRICT vec = (const double * RESTRICT)ASSUME_ALIGNED(vector, 64U);
    double * RESTRICT dst = (double * RESTRICT)ASSUME_ALIGNED(out, 64U);
    size_t col;

    for (col = 0; col < n; ++col) {
        const double * RESTRICT column = matrix + col * n;
        double acc0 = 0.0;
        double acc1 = 0.0;
        double acc2 = 0.0;
        double acc3 = 0.0;
        double acc4 = 0.0;
        double acc5 = 0.0;
        double acc6 = 0.0;
        double acc7 = 0.0;
        size_t row = 0;

        for (; row + 8U <= n; row += 8U) {
            acc0 += column[row + 0U] * vec[row + 0U];
            acc1 += column[row + 1U] * vec[row + 1U];
            acc2 += column[row + 2U] * vec[row + 2U];
            acc3 += column[row + 3U] * vec[row + 3U];
            acc4 += column[row + 4U] * vec[row + 4U];
            acc5 += column[row + 5U] * vec[row + 5U];
            acc6 += column[row + 6U] * vec[row + 6U];
            acc7 += column[row + 7U] * vec[row + 7U];
        }

        dst[col] = ((acc0 + acc1) + (acc2 + acc3)) + ((acc4 + acc5) + (acc6 + acc7));
        for (; row < n; ++row) {
            dst[col] += column[row] * vec[row];
        }
    }
}
#endif

void matvec_extreme_f32(const float *matrix_t, const float *vector, float *out, size_t n) {
#if defined(__SSE__)
    const float * RESTRICT matrix = (const float * RESTRICT)ASSUME_ALIGNED(matrix_t, 64U);
    const float * RESTRICT vec = (const float * RESTRICT)ASSUME_ALIGNED(vector, 64U);
    float * RESTRICT dst = (float * RESTRICT)ASSUME_ALIGNED(out, 64U);
    size_t col;

    for (col = 0; col < n; ++col) {
        const float * RESTRICT column = matrix + col * n;
        __m128 acc0 = _mm_setzero_ps();
        __m128 acc1 = _mm_setzero_ps();
        __m128 acc2 = _mm_setzero_ps();
        __m128 acc3 = _mm_setzero_ps();
        size_t row = 0;
        float sum;

        for (; row + 16U <= n; row += 16U) {
            acc0 = _mm_add_ps(acc0, _mm_mul_ps(_mm_loadu_ps(column + row + 0U), _mm_loadu_ps(vec + row + 0U)));
            acc1 = _mm_add_ps(acc1, _mm_mul_ps(_mm_loadu_ps(column + row + 4U), _mm_loadu_ps(vec + row + 4U)));
            acc2 = _mm_add_ps(acc2, _mm_mul_ps(_mm_loadu_ps(column + row + 8U), _mm_loadu_ps(vec + row + 8U)));
            acc3 = _mm_add_ps(acc3, _mm_mul_ps(_mm_loadu_ps(column + row + 12U), _mm_loadu_ps(vec + row + 12U)));
        }

        sum = horizontal_add_ps(_mm_add_ps(_mm_add_ps(acc0, acc1), _mm_add_ps(acc2, acc3)));
        for (; row + 4U <= n; row += 4U) {
            __m128 prod = _mm_mul_ps(_mm_loadu_ps(column + row), _mm_loadu_ps(vec + row));
            sum += horizontal_add_ps(prod);
        }
        for (; row < n; ++row) {
            sum += column[row] * vec[row];
        }
        dst[col] = sum;
    }
#else
    matvec_extreme_f32_scalar(matrix_t, vector, out, n);
#endif
}

void matvec_extreme_f64(const double *matrix_t, const double *vector, double *out, size_t n) {
#if defined(__SSE2__)
    const double * RESTRICT matrix = (const double * RESTRICT)ASSUME_ALIGNED(matrix_t, 64U);
    const double * RESTRICT vec = (const double * RESTRICT)ASSUME_ALIGNED(vector, 64U);
    double * RESTRICT dst = (double * RESTRICT)ASSUME_ALIGNED(out, 64U);
    size_t col;

    for (col = 0; col < n; ++col) {
        const double * RESTRICT column = matrix + col * n;
        __m128d acc0 = _mm_setzero_pd();
        __m128d acc1 = _mm_setzero_pd();
        __m128d acc2 = _mm_setzero_pd();
        __m128d acc3 = _mm_setzero_pd();
        size_t row = 0;
        double sum;

        for (; row + 8U <= n; row += 8U) {
            acc0 = _mm_add_pd(acc0, _mm_mul_pd(_mm_loadu_pd(column + row + 0U), _mm_loadu_pd(vec + row + 0U)));
            acc1 = _mm_add_pd(acc1, _mm_mul_pd(_mm_loadu_pd(column + row + 2U), _mm_loadu_pd(vec + row + 2U)));
            acc2 = _mm_add_pd(acc2, _mm_mul_pd(_mm_loadu_pd(column + row + 4U), _mm_loadu_pd(vec + row + 4U)));
            acc3 = _mm_add_pd(acc3, _mm_mul_pd(_mm_loadu_pd(column + row + 6U), _mm_loadu_pd(vec + row + 6U)));
        }

        sum = horizontal_add_pd(_mm_add_pd(_mm_add_pd(acc0, acc1), _mm_add_pd(acc2, acc3)));
        for (; row + 2U <= n; row += 2U) {
            __m128d prod = _mm_mul_pd(_mm_loadu_pd(column + row), _mm_loadu_pd(vec + row));
            sum += horizontal_add_pd(prod);
        }
        for (; row < n; ++row) {
            sum += column[row] * vec[row];
        }
        dst[col] = sum;
    }
#else
    matvec_extreme_f64_scalar(matrix_t, vector, out, n);
#endif
}
