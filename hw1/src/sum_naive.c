#include "bench_cpu_arch.h"

float sum_naive_f32(const float *data, size_t n) {
    float sum = 0.0f;
    size_t i;

    for (i = 0; i < n; ++i) {
        sum += data[i];
    }
    return sum;
}

double sum_naive_f64(const double *data, size_t n) {
    double sum = 0.0;
    size_t i;

    for (i = 0; i < n; ++i) {
        sum += data[i];
    }
    return sum;
}
