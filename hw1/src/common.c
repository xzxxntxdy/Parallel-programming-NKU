#include "bench_cpu_arch.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static volatile long double g_sink = 0.0L;

static uint64_t splitmix64_next(uint64_t *state) {
    uint64_t z;

    *state += 0x9E3779B97F4A7C15ULL;
    z = *state;
    z = (z ^ (z >> 30U)) * 0xBF58476D1CE4E5B9ULL;
    z = (z ^ (z >> 27U)) * 0x94D049BB133111EBULL;
    return z ^ (z >> 31U);
}

static long double unit_from_u64(uint64_t value) {
    const long double denom = 1.0L / (long double)UINT64_MAX;
    long double scaled = (long double)value * denom;
    return scaled - 0.5L;
}

double now_ms(void) {
    struct timespec ts;

    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0) {
        perror("clock_gettime");
        exit(EXIT_FAILURE);
    }

    return (double)ts.tv_sec * 1000.0 + (double)ts.tv_nsec / 1000000.0;
}

void *aligned_malloc_or_die(size_t alignment, size_t size) {
    void *ptr = NULL;

    if (size == 0U) {
        size = alignment;
    }
    if (posix_memalign(&ptr, alignment, size) != 0) {
        fprintf(stderr, "posix_memalign failed for %zu bytes\n", size);
        exit(EXIT_FAILURE);
    }
    memset(ptr, 0, size);
    return ptr;
}

void aligned_free(void *ptr) {
    free(ptr);
}

void fill_random_f32(float *dst, size_t n, uint64_t seed) {
    size_t i;

    for (i = 0; i < n; ++i) {
        dst[i] = (float)unit_from_u64(splitmix64_next(&seed));
    }
}

void fill_random_f64(double *dst, size_t n, uint64_t seed) {
    size_t i;

    for (i = 0; i < n; ++i) {
        dst[i] = (double)unit_from_u64(splitmix64_next(&seed));
    }
}

void transpose_f32(const float *src, float *dst, size_t n) {
    size_t row;
    size_t col;

    for (row = 0; row < n; ++row) {
        size_t src_base = row * n;
        for (col = 0; col < n; ++col) {
            dst[col * n + row] = src[src_base + col];
        }
    }
}

void transpose_blocked_f32(const float *src, float *dst, size_t n) {
    const size_t block = 32U;
    size_t row0;
    size_t col0;
    size_t row;
    size_t col;

    for (row0 = 0; row0 < n; row0 += block) {
        size_t row_max = row0 + block < n ? row0 + block : n;
        for (col0 = 0; col0 < n; col0 += block) {
            size_t col_max = col0 + block < n ? col0 + block : n;
            for (row = row0; row < row_max; ++row) {
                size_t src_base = row * n;
                for (col = col0; col < col_max; ++col) {
                    dst[col * n + row] = src[src_base + col];
                }
            }
        }
    }
}

void transpose_f64(const double *src, double *dst, size_t n) {
    size_t row;
    size_t col;

    for (row = 0; row < n; ++row) {
        size_t src_base = row * n;
        for (col = 0; col < n; ++col) {
            dst[col * n + row] = src[src_base + col];
        }
    }
}

void transpose_blocked_f64(const double *src, double *dst, size_t n) {
    const size_t block = 32U;
    size_t row0;
    size_t col0;
    size_t row;
    size_t col;

    for (row0 = 0; row0 < n; row0 += block) {
        size_t row_max = row0 + block < n ? row0 + block : n;
        for (col0 = 0; col0 < n; col0 += block) {
            size_t col_max = col0 + block < n ? col0 + block : n;
            for (row = row0; row < row_max; ++row) {
                size_t src_base = row * n;
                for (col = col0; col < col_max; ++col) {
                    dst[col * n + row] = src[src_base + col];
                }
            }
        }
    }
}

long double reference_sum_f32(const float *data, size_t n) {
    long double sum = 0.0L;
    size_t i;

    for (i = 0; i < n; ++i) {
        sum += (long double)data[i];
    }
    return sum;
}

long double reference_sum_f64(const double *data, size_t n) {
    long double sum = 0.0L;
    size_t i;

    for (i = 0; i < n; ++i) {
        sum += (long double)data[i];
    }
    return sum;
}

long double checksum_f32(const float *data, size_t n) {
    long double sum = 0.0L;
    size_t i;

    for (i = 0; i < n; ++i) {
        sum += (long double)data[i];
    }
    return sum;
}

long double checksum_f64(const double *data, size_t n) {
    long double sum = 0.0L;
    size_t i;

    for (i = 0; i < n; ++i) {
        sum += (long double)data[i];
    }
    return sum;
}

int compare_scalar_ld(
    long double actual,
    long double reference,
    long double abs_tol,
    long double rel_tol,
    double *abs_err_out,
    double *rel_err_out
) {
    long double abs_err = fabsl(actual - reference);
    long double rel_base = fabsl(reference) > 1.0L ? fabsl(reference) : 1.0L;
    long double rel_err = abs_err / rel_base;
    long double limit = abs_tol + rel_tol * fabsl(reference);

    if (abs_err_out != NULL) {
        *abs_err_out = (double)abs_err;
    }
    if (rel_err_out != NULL) {
        *rel_err_out = (double)rel_err;
    }

    return abs_err <= limit;
}

int compare_vector_f32(
    const float *actual,
    const float *reference,
    size_t n,
    long double abs_tol,
    long double rel_tol,
    double *max_abs_err_out,
    double *max_rel_err_out
) {
    long double max_abs_err = 0.0L;
    long double max_rel_err = 0.0L;
    size_t i;

    for (i = 0; i < n; ++i) {
        long double abs_err = fabsl((long double)actual[i] - (long double)reference[i]);
        long double ref_abs = fabsl((long double)reference[i]);
        long double rel_base = ref_abs > 1.0L ? ref_abs : 1.0L;
        long double rel_err = abs_err / rel_base;
        long double limit = abs_tol + rel_tol * ref_abs;

        if (abs_err > max_abs_err) {
            max_abs_err = abs_err;
        }
        if (rel_err > max_rel_err) {
            max_rel_err = rel_err;
        }
        if (abs_err > limit) {
            if (max_abs_err_out != NULL) {
                *max_abs_err_out = (double)max_abs_err;
            }
            if (max_rel_err_out != NULL) {
                *max_rel_err_out = (double)max_rel_err;
            }
            return 0;
        }
    }

    if (max_abs_err_out != NULL) {
        *max_abs_err_out = (double)max_abs_err;
    }
    if (max_rel_err_out != NULL) {
        *max_rel_err_out = (double)max_rel_err;
    }
    return 1;
}

int compare_vector_f64(
    const double *actual,
    const double *reference,
    size_t n,
    long double abs_tol,
    long double rel_tol,
    double *max_abs_err_out,
    double *max_rel_err_out
) {
    long double max_abs_err = 0.0L;
    long double max_rel_err = 0.0L;
    size_t i;

    for (i = 0; i < n; ++i) {
        long double abs_err = fabsl((long double)actual[i] - (long double)reference[i]);
        long double ref_abs = fabsl((long double)reference[i]);
        long double rel_base = ref_abs > 1.0L ? ref_abs : 1.0L;
        long double rel_err = abs_err / rel_base;
        long double limit = abs_tol + rel_tol * ref_abs;

        if (abs_err > max_abs_err) {
            max_abs_err = abs_err;
        }
        if (rel_err > max_rel_err) {
            max_rel_err = rel_err;
        }
        if (abs_err > limit) {
            if (max_abs_err_out != NULL) {
                *max_abs_err_out = (double)max_abs_err;
            }
            if (max_rel_err_out != NULL) {
                *max_rel_err_out = (double)max_rel_err;
            }
            return 0;
        }
    }

    if (max_abs_err_out != NULL) {
        *max_abs_err_out = (double)max_abs_err;
    }
    if (max_rel_err_out != NULL) {
        *max_rel_err_out = (double)max_rel_err;
    }
    return 1;
}

void consume_ld(long double value) {
    g_sink += value;
}
