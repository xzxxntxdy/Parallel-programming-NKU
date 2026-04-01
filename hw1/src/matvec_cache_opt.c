#include "bench_cpu_arch.h"

void matvec_cache_opt_f32(const float *matrix_t, const float *vector, float *out, size_t n) {
    size_t col;
    size_t row;

    for (col = 0; col < n; ++col) {
        const float *column = matrix_t + col * n;
        float sum = 0.0f;
        for (row = 0; row < n; ++row) {
            sum += column[row] * vector[row];
        }
        out[col] = sum;
    }
}

void matvec_cache_opt_f64(const double *matrix_t, const double *vector, double *out, size_t n) {
    size_t col;
    size_t row;

    for (col = 0; col < n; ++col) {
        const double *column = matrix_t + col * n;
        double sum = 0.0;
        for (row = 0; row < n; ++row) {
            sum += column[row] * vector[row];
        }
        out[col] = sum;
    }
}
