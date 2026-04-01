#include "bench_cpu_arch.h"

float sum_superscalar_f32(const float *data, size_t n) {
    float acc0 = 0.0f;
    float acc1 = 0.0f;
    float acc2 = 0.0f;
    float acc3 = 0.0f;
    size_t i = 0;

    for (; i + 4U <= n; i += 4U) {
        acc0 += data[i + 0U];
        acc1 += data[i + 1U];
        acc2 += data[i + 2U];
        acc3 += data[i + 3U];
    }
    for (; i < n; ++i) {
        acc0 += data[i];
    }
    return (acc0 + acc1) + (acc2 + acc3);
}

double sum_superscalar_f64(const double *data, size_t n) {
    double acc0 = 0.0;
    double acc1 = 0.0;
    double acc2 = 0.0;
    double acc3 = 0.0;
    size_t i = 0;

    for (; i + 4U <= n; i += 4U) {
        acc0 += data[i + 0U];
        acc1 += data[i + 1U];
        acc2 += data[i + 2U];
        acc3 += data[i + 3U];
    }
    for (; i < n; ++i) {
        acc0 += data[i];
    }
    return (acc0 + acc1) + (acc2 + acc3);
}
