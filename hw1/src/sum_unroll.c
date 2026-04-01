#include "bench_cpu_arch.h"

#define DEFINE_SUM_UNROLL(TYPE, SUFFIX, FACTOR) \
TYPE sum_unroll##FACTOR##_##SUFFIX(const TYPE *data, size_t n) { \
    TYPE acc[FACTOR] = {0}; \
    TYPE sum = 0; \
    size_t i = 0; \
    for (; i + (size_t)(FACTOR) <= n; i += (size_t)(FACTOR)) { \
        int lane; \
        for (lane = 0; lane < (FACTOR); ++lane) { \
            acc[lane] += data[i + (size_t)lane]; \
        } \
    } \
    for (i = 0; i < (size_t)(FACTOR); ++i) { \
        sum += acc[i]; \
    } \
    for (i = n - (n % (size_t)(FACTOR)); i < n; ++i) { \
        sum += data[i]; \
    } \
    return sum; \
}

DEFINE_SUM_UNROLL(float, f32, 2)
DEFINE_SUM_UNROLL(float, f32, 4)
DEFINE_SUM_UNROLL(float, f32, 8)
DEFINE_SUM_UNROLL(double, f64, 2)
DEFINE_SUM_UNROLL(double, f64, 4)
DEFINE_SUM_UNROLL(double, f64, 8)

float sum_unroll_f32(const float *data, size_t n, int unroll) {
    switch (unroll) {
        case 2:
            return sum_unroll2_f32(data, n);
        case 8:
            return sum_unroll8_f32(data, n);
        case 4:
        default:
            return sum_unroll4_f32(data, n);
    }
}

double sum_unroll_f64(const double *data, size_t n, int unroll) {
    switch (unroll) {
        case 2:
            return sum_unroll2_f64(data, n);
        case 8:
            return sum_unroll8_f64(data, n);
        case 4:
        default:
            return sum_unroll4_f64(data, n);
    }
}
