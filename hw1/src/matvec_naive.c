#include "bench_cpu_arch.h"

void matvec_naive_f32(const float *matrix, const float *vector, float *out, size_t n) {
    size_t col;
    size_t row;

    for (col = 0; col < n; ++col) {
        float sum = 0.0f;
        for (row = 0; row < n; ++row) {
            sum += matrix[row * n + col] * vector[row];
        }
        out[col] = sum;
    }
}

void matvec_naive_f64(const double *matrix, const double *vector, double *out, size_t n) {
    size_t col;
    size_t row;

    for (col = 0; col < n; ++col) {
        double sum = 0.0;
        for (row = 0; row < n; ++row) {
            sum += matrix[row * n + col] * vector[row];
        }
        out[col] = sum;
    }
}
