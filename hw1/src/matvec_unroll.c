#include "bench_cpu_arch.h"

#define DEFINE_MATVEC_UNROLL(TYPE, SUFFIX, FACTOR) \
void matvec_unroll##FACTOR##_##SUFFIX(const TYPE *matrix_t, const TYPE *vector, TYPE *out, size_t n) { \
    size_t col; \
    size_t row; \
    for (col = 0; col < n; ++col) { \
        const TYPE *column = matrix_t + col * n; \
        TYPE acc[FACTOR] = {0}; \
        TYPE sum = 0; \
        for (row = 0; row + (size_t)(FACTOR) <= n; row += (size_t)(FACTOR)) { \
            int lane; \
            for (lane = 0; lane < (FACTOR); ++lane) { \
                acc[lane] += column[row + (size_t)lane] * vector[row + (size_t)lane]; \
            } \
        } \
        for (row = 0; row < (size_t)(FACTOR); ++row) { \
            sum += acc[row]; \
        } \
        for (row = n - (n % (size_t)(FACTOR)); row < n; ++row) { \
            sum += column[row] * vector[row]; \
        } \
        out[col] = sum; \
    } \
}

DEFINE_MATVEC_UNROLL(float, f32, 2)
DEFINE_MATVEC_UNROLL(float, f32, 4)
DEFINE_MATVEC_UNROLL(float, f32, 8)
DEFINE_MATVEC_UNROLL(double, f64, 2)
DEFINE_MATVEC_UNROLL(double, f64, 4)
DEFINE_MATVEC_UNROLL(double, f64, 8)

void matvec_unroll_f32(const float *matrix_t, const float *vector, float *out, size_t n, int unroll) {
    switch (unroll) {
        case 2:
            matvec_unroll2_f32(matrix_t, vector, out, n);
            break;
        case 8:
            matvec_unroll8_f32(matrix_t, vector, out, n);
            break;
        case 4:
        default:
            matvec_unroll4_f32(matrix_t, vector, out, n);
            break;
    }
}

void matvec_unroll_f64(const double *matrix_t, const double *vector, double *out, size_t n, int unroll) {
    switch (unroll) {
        case 2:
            matvec_unroll2_f64(matrix_t, vector, out, n);
            break;
        case 8:
            matvec_unroll8_f64(matrix_t, vector, out, n);
            break;
        case 4:
        default:
            matvec_unroll4_f64(matrix_t, vector, out, n);
            break;
    }
}
