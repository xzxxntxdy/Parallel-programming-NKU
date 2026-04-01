#ifndef BENCH_CPU_ARCH_H
#define BENCH_CPU_ARCH_H

#include <stddef.h>
#include <stdint.h>

#if defined(__GNUC__) || defined(__clang__)
#define NOINLINE __attribute__((noinline))
#define RESTRICT __restrict__
#define ASSUME_ALIGNED(ptr, alignment) __builtin_assume_aligned((ptr), (alignment))
#else
#define NOINLINE
#define RESTRICT
#define ASSUME_ALIGNED(ptr, alignment) (ptr)
#endif

typedef enum {
    DTYPE_F32 = 0,
    DTYPE_F64 = 1
} dtype_t;

typedef struct {
    const char *task;
    const char *algo;
    size_t n;
    int repeat;
    int warmup;
    dtype_t dtype;
    int unroll;
    int csv;
    const char *build_mode;
} benchmark_options_t;

typedef struct {
    double prep_ms;
    double total_ms;
    double avg_ms;
    double min_ms;
    double checksum;
    double reference;
    double max_abs_err;
    double max_rel_err;
    int check_ok;
} benchmark_result_t;

double now_ms(void);
void *aligned_malloc_or_die(size_t alignment, size_t size);
void aligned_free(void *ptr);

void fill_random_f32(float *dst, size_t n, uint64_t seed);
void fill_random_f64(double *dst, size_t n, uint64_t seed);
void transpose_f32(const float *src, float *dst, size_t n);
void transpose_f64(const double *src, double *dst, size_t n);
void transpose_blocked_f32(const float *src, float *dst, size_t n);
void transpose_blocked_f64(const double *src, double *dst, size_t n);

long double reference_sum_f32(const float *data, size_t n);
long double reference_sum_f64(const double *data, size_t n);
long double checksum_f32(const float *data, size_t n);
long double checksum_f64(const double *data, size_t n);

int compare_scalar_ld(
    long double actual,
    long double reference,
    long double abs_tol,
    long double rel_tol,
    double *abs_err_out,
    double *rel_err_out
);

int compare_vector_f32(
    const float *actual,
    const float *reference,
    size_t n,
    long double abs_tol,
    long double rel_tol,
    double *max_abs_err_out,
    double *max_rel_err_out
);

int compare_vector_f64(
    const double *actual,
    const double *reference,
    size_t n,
    long double abs_tol,
    long double rel_tol,
    double *max_abs_err_out,
    double *max_rel_err_out
);

void consume_ld(long double value);

NOINLINE void matvec_naive_f32(const float *matrix, const float *vector, float *out, size_t n);
NOINLINE void matvec_naive_f64(const double *matrix, const double *vector, double *out, size_t n);

NOINLINE void matvec_cache_opt_f32(const float *matrix_t, const float *vector, float *out, size_t n);
NOINLINE void matvec_cache_opt_f64(const double *matrix_t, const double *vector, double *out, size_t n);

NOINLINE void matvec_unroll2_f32(const float *matrix_t, const float *vector, float *out, size_t n);
NOINLINE void matvec_unroll4_f32(const float *matrix_t, const float *vector, float *out, size_t n);
NOINLINE void matvec_unroll8_f32(const float *matrix_t, const float *vector, float *out, size_t n);
NOINLINE void matvec_unroll_f32(const float *matrix_t, const float *vector, float *out, size_t n, int unroll);

NOINLINE void matvec_unroll2_f64(const double *matrix_t, const double *vector, double *out, size_t n);
NOINLINE void matvec_unroll4_f64(const double *matrix_t, const double *vector, double *out, size_t n);
NOINLINE void matvec_unroll8_f64(const double *matrix_t, const double *vector, double *out, size_t n);
NOINLINE void matvec_unroll_f64(const double *matrix_t, const double *vector, double *out, size_t n, int unroll);
NOINLINE void matvec_extreme_f32(const float *matrix_t, const float *vector, float *out, size_t n);
NOINLINE void matvec_extreme_f64(const double *matrix_t, const double *vector, double *out, size_t n);

NOINLINE float sum_naive_f32(const float *data, size_t n);
NOINLINE double sum_naive_f64(const double *data, size_t n);

NOINLINE float sum_superscalar_f32(const float *data, size_t n);
NOINLINE double sum_superscalar_f64(const double *data, size_t n);

NOINLINE float sum_unroll2_f32(const float *data, size_t n);
NOINLINE float sum_unroll4_f32(const float *data, size_t n);
NOINLINE float sum_unroll8_f32(const float *data, size_t n);
NOINLINE float sum_unroll_f32(const float *data, size_t n, int unroll);

NOINLINE double sum_unroll2_f64(const double *data, size_t n);
NOINLINE double sum_unroll4_f64(const double *data, size_t n);
NOINLINE double sum_unroll8_f64(const double *data, size_t n);
NOINLINE double sum_unroll_f64(const double *data, size_t n, int unroll);
NOINLINE float sum_extreme_f32(const float *data, size_t n);
NOINLINE double sum_extreme_f64(const double *data, size_t n);

#endif
