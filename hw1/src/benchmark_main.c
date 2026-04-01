#include "bench_cpu_arch.h"

#include <errno.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef BUILD_MODE_NAME
#define BUILD_MODE_NAME "Unknown"
#endif

static const char *dtype_name(dtype_t dtype) {
    return dtype == DTYPE_F32 ? "f32" : "f64";
}

static void print_usage(const char *prog) {
    fprintf(stderr,
            "Usage: %s --task <matvec|sum> --algo <name> --n <size> --repeat <count> [options]\n"
            "Options:\n"
            "  --warmup <count>         Warmup iterations before timing (default: 2)\n"
            "  --dtype <f32|f64>        Data type (default: f64)\n"
            "  --unroll <2|4|8>         Unroll factor for algo=unroll (default: 4)\n"
            "  --build-mode <label>     Build mode label for output metadata\n"
            "  --csv                    Print one CSV row instead of key=value text\n"
            "  --help                   Show this help\n",
            prog);
}

static int parse_size_value(const char *text, size_t *value_out) {
    char *end = NULL;
    unsigned long long parsed;

    errno = 0;
    parsed = strtoull(text, &end, 10);
    if (errno != 0 || end == text || *end != '\0') {
        return 0;
    }
    *value_out = (size_t)parsed;
    return 1;
}

static int parse_int_value(const char *text, int *value_out) {
    char *end = NULL;
    long parsed;

    errno = 0;
    parsed = strtol(text, &end, 10);
    if (errno != 0 || end == text || *end != '\0' || parsed < 0L || parsed > 2147483647L) {
        return 0;
    }
    *value_out = (int)parsed;
    return 1;
}

static int parse_dtype_value(const char *text, dtype_t *dtype_out) {
    if (strcmp(text, "f32") == 0 || strcmp(text, "float") == 0) {
        *dtype_out = DTYPE_F32;
        return 1;
    }
    if (strcmp(text, "f64") == 0 || strcmp(text, "double") == 0) {
        *dtype_out = DTYPE_F64;
        return 1;
    }
    return 0;
}

static int parse_options(int argc, char **argv, benchmark_options_t *opts) {
    int i;

    opts->task = NULL;
    opts->algo = NULL;
    opts->n = 0U;
    opts->repeat = 10;
    opts->warmup = 2;
    opts->dtype = DTYPE_F64;
    opts->unroll = 4;
    opts->csv = 0;
    opts->build_mode = BUILD_MODE_NAME[0] != '\0' ? BUILD_MODE_NAME : "Unknown";

    for (i = 1; i < argc; ++i) {
        const char *arg = argv[i];

        if (strcmp(arg, "--task") == 0 && i + 1 < argc) {
            opts->task = argv[++i];
        } else if (strcmp(arg, "--algo") == 0 && i + 1 < argc) {
            opts->algo = argv[++i];
        } else if (strcmp(arg, "--n") == 0 && i + 1 < argc) {
            if (!parse_size_value(argv[++i], &opts->n)) {
                return 0;
            }
        } else if (strcmp(arg, "--repeat") == 0 && i + 1 < argc) {
            if (!parse_int_value(argv[++i], &opts->repeat)) {
                return 0;
            }
        } else if (strcmp(arg, "--warmup") == 0 && i + 1 < argc) {
            if (!parse_int_value(argv[++i], &opts->warmup)) {
                return 0;
            }
        } else if (strcmp(arg, "--dtype") == 0 && i + 1 < argc) {
            if (!parse_dtype_value(argv[++i], &opts->dtype)) {
                return 0;
            }
        } else if (strcmp(arg, "--unroll") == 0 && i + 1 < argc) {
            if (!parse_int_value(argv[++i], &opts->unroll)) {
                return 0;
            }
        } else if (strcmp(arg, "--build-mode") == 0 && i + 1 < argc) {
            opts->build_mode = argv[++i];
        } else if (strcmp(arg, "--csv") == 0) {
            opts->csv = 1;
        } else if (strcmp(arg, "--help") == 0) {
            print_usage(argv[0]);
            exit(EXIT_SUCCESS);
        } else {
            return 0;
        }
    }

    if (opts->task == NULL || opts->algo == NULL || opts->n == 0U || opts->repeat <= 0 || opts->warmup < 0) {
        return 0;
    }
    if (opts->unroll != 2 && opts->unroll != 4 && opts->unroll != 8) {
        return 0;
    }
    return 1;
}

static int checked_mul_size(size_t a, size_t b, size_t *out) {
    if (a != 0U && b > SIZE_MAX / a) {
        return 0;
    }
    *out = a * b;
    return 1;
}

static void print_result(const benchmark_options_t *opts, const benchmark_result_t *result) {
    if (opts->csv) {
        printf("%s,%s,%zu,%d,%d,%s,%d,%s,%s,%.6f,%.6f,%.6f,%.6f,%.12f,%.12f,%.6e,%.6e\n",
               opts->task,
               opts->algo,
               opts->n,
               opts->repeat,
               opts->warmup,
               dtype_name(opts->dtype),
               opts->unroll,
               opts->build_mode,
               result->check_ok ? "OK" : "FAIL",
               result->prep_ms,
               result->total_ms,
               result->avg_ms,
               result->min_ms,
               result->checksum,
               result->reference,
               result->max_abs_err,
               result->max_rel_err);
        return;
    }

    printf("task=%s algo=%s n=%zu repeat=%d warmup=%d dtype=%s unroll=%d build_mode=%s prep_ms=%.3f check=%s total_ms=%.3f avg_ms=%.3f min_ms=%.3f checksum=%.12f reference=%.12f max_abs_err=%.6e max_rel_err=%.6e\n",
           opts->task,
           opts->algo,
           opts->n,
           opts->repeat,
           opts->warmup,
           dtype_name(opts->dtype),
           opts->unroll,
           opts->build_mode,
           result->prep_ms,
           result->check_ok ? "OK" : "FAIL",
           result->total_ms,
           result->avg_ms,
           result->min_ms,
           result->checksum,
           result->reference,
           result->max_abs_err,
           result->max_rel_err);
}

static void matvec_reference_f32(
    const float *matrix,
    const float *vector,
    float *reference,
    size_t n,
    long double *max_abs_bound_out
) {
    size_t col;
    size_t row;
    long double max_abs_bound = 0.0L;

    for (col = 0; col < n; ++col) {
        long double exact = 0.0L;
        long double abs_bound = 0.0L;
        for (row = 0; row < n; ++row) {
            long double term = (long double)matrix[row * n + col] * (long double)vector[row];
            exact += term;
            abs_bound += fabsl(term);
        }
        reference[col] = (float)exact;
        if (abs_bound > max_abs_bound) {
            max_abs_bound = abs_bound;
        }
    }

    *max_abs_bound_out = max_abs_bound;
}

static void matvec_reference_f64(
    const double *matrix,
    const double *vector,
    double *reference,
    size_t n,
    long double *max_abs_bound_out
) {
    size_t col;
    size_t row;
    long double max_abs_bound = 0.0L;

    for (col = 0; col < n; ++col) {
        long double exact = 0.0L;
        long double abs_bound = 0.0L;
        for (row = 0; row < n; ++row) {
            long double term = (long double)matrix[row * n + col] * (long double)vector[row];
            exact += term;
            abs_bound += fabsl(term);
        }
        reference[col] = (double)exact;
        if (abs_bound > max_abs_bound) {
            max_abs_bound = abs_bound;
        }
    }

    *max_abs_bound_out = max_abs_bound;
}

static int run_sum_benchmark_f32(const benchmark_options_t *opts, benchmark_result_t *result) {
    size_t bytes;
    float *data;
    long double reference;
    long double abs_bound = 0.0L;
    long double actual = 0.0L;
    long double abs_tol;
    long double rel_tol = 1.0e-4L;
    int iter;
    size_t i;

    if (!checked_mul_size(opts->n, sizeof(float), &bytes)) {
        fprintf(stderr, "Requested n is too large for f32 sum\n");
        return 0;
    }

    data = (float *)aligned_malloc_or_die(64U, bytes);
    fill_random_f32(data, opts->n, 0x1234ABCDEFULL);
    for (i = 0; i < opts->n; ++i) {
        abs_bound += fabsl((long double)data[i]);
    }
    reference = reference_sum_f32(data, opts->n);
    abs_tol = fmaxl(1.0e-6L, abs_bound * 1.0e-5L);

    for (iter = 0; iter < opts->warmup; ++iter) {
        if (strcmp(opts->algo, "naive") == 0) {
            actual = (long double)sum_naive_f32(data, opts->n);
        } else if (strcmp(opts->algo, "superscalar") == 0) {
            actual = (long double)sum_superscalar_f32(data, opts->n);
        } else if (strcmp(opts->algo, "unroll") == 0) {
            actual = (long double)sum_unroll_f32(data, opts->n, opts->unroll);
        } else if (strcmp(opts->algo, "extreme") == 0) {
            actual = (long double)sum_extreme_f32(data, opts->n);
        } else {
            fprintf(stderr, "Unknown sum algo: %s\n", opts->algo);
            aligned_free(data);
            return 0;
        }
        consume_ld(actual);
    }

    for (iter = 0; iter < opts->repeat; ++iter) {
        double start_ms = now_ms();
        if (strcmp(opts->algo, "naive") == 0) {
            actual = (long double)sum_naive_f32(data, opts->n);
        } else if (strcmp(opts->algo, "superscalar") == 0) {
            actual = (long double)sum_superscalar_f32(data, opts->n);
        } else if (strcmp(opts->algo, "unroll") == 0) {
            actual = (long double)sum_unroll_f32(data, opts->n, opts->unroll);
        } else if (strcmp(opts->algo, "extreme") == 0) {
            actual = (long double)sum_extreme_f32(data, opts->n);
        } else {
            fprintf(stderr, "Unknown sum algo: %s\n", opts->algo);
            aligned_free(data);
            return 0;
        }
        {
            double elapsed_ms = now_ms() - start_ms;
            result->total_ms += elapsed_ms;
            if (iter == 0 || elapsed_ms < result->min_ms) {
                result->min_ms = elapsed_ms;
            }
        }
        consume_ld(actual);
    }

    result->avg_ms = result->total_ms / (double)opts->repeat;
    result->checksum = (double)actual;
    result->reference = (double)reference;
    result->check_ok = compare_scalar_ld(actual, reference, abs_tol, rel_tol, &result->max_abs_err, &result->max_rel_err);
    aligned_free(data);
    return 1;
}

static int run_sum_benchmark_f64(const benchmark_options_t *opts, benchmark_result_t *result) {
    size_t bytes;
    double *data;
    long double reference;
    long double abs_bound = 0.0L;
    long double actual = 0.0L;
    long double abs_tol;
    long double rel_tol = 1.0e-12L;
    int iter;
    size_t i;

    if (!checked_mul_size(opts->n, sizeof(double), &bytes)) {
        fprintf(stderr, "Requested n is too large for f64 sum\n");
        return 0;
    }

    data = (double *)aligned_malloc_or_die(64U, bytes);
    fill_random_f64(data, opts->n, 0x9876FEDCBAULL);
    for (i = 0; i < opts->n; ++i) {
        abs_bound += fabsl((long double)data[i]);
    }
    reference = reference_sum_f64(data, opts->n);
    abs_tol = fmaxl(1.0e-12L, abs_bound * 1.0e-12L);

    for (iter = 0; iter < opts->warmup; ++iter) {
        if (strcmp(opts->algo, "naive") == 0) {
            actual = (long double)sum_naive_f64(data, opts->n);
        } else if (strcmp(opts->algo, "superscalar") == 0) {
            actual = (long double)sum_superscalar_f64(data, opts->n);
        } else if (strcmp(opts->algo, "unroll") == 0) {
            actual = (long double)sum_unroll_f64(data, opts->n, opts->unroll);
        } else if (strcmp(opts->algo, "extreme") == 0) {
            actual = (long double)sum_extreme_f64(data, opts->n);
        } else {
            fprintf(stderr, "Unknown sum algo: %s\n", opts->algo);
            aligned_free(data);
            return 0;
        }
        consume_ld(actual);
    }

    for (iter = 0; iter < opts->repeat; ++iter) {
        double start_ms = now_ms();
        if (strcmp(opts->algo, "naive") == 0) {
            actual = (long double)sum_naive_f64(data, opts->n);
        } else if (strcmp(opts->algo, "superscalar") == 0) {
            actual = (long double)sum_superscalar_f64(data, opts->n);
        } else if (strcmp(opts->algo, "unroll") == 0) {
            actual = (long double)sum_unroll_f64(data, opts->n, opts->unroll);
        } else if (strcmp(opts->algo, "extreme") == 0) {
            actual = (long double)sum_extreme_f64(data, opts->n);
        } else {
            fprintf(stderr, "Unknown sum algo: %s\n", opts->algo);
            aligned_free(data);
            return 0;
        }
        {
            double elapsed_ms = now_ms() - start_ms;
            result->total_ms += elapsed_ms;
            if (iter == 0 || elapsed_ms < result->min_ms) {
                result->min_ms = elapsed_ms;
            }
        }
        consume_ld(actual);
    }

    result->avg_ms = result->total_ms / (double)opts->repeat;
    result->checksum = (double)actual;
    result->reference = (double)reference;
    result->check_ok = compare_scalar_ld(actual, reference, abs_tol, rel_tol, &result->max_abs_err, &result->max_rel_err);
    aligned_free(data);
    return 1;
}

static int run_sum_benchmark(const benchmark_options_t *opts, benchmark_result_t *result) {
    result->prep_ms = 0.0;
    result->total_ms = 0.0;
    result->avg_ms = 0.0;
    result->min_ms = 0.0;
    result->checksum = 0.0;
    result->reference = 0.0;
    result->max_abs_err = 0.0;
    result->max_rel_err = 0.0;
    result->check_ok = 0;

    if (opts->dtype == DTYPE_F32) {
        return run_sum_benchmark_f32(opts, result);
    }
    return run_sum_benchmark_f64(opts, result);
}

static int run_matvec_benchmark_f32(const benchmark_options_t *opts, benchmark_result_t *result) {
    size_t matrix_elems;
    size_t matrix_bytes;
    size_t vector_bytes;
    float *matrix;
    float *matrix_t = NULL;
    float *vector;
    float *output;
    float *reference;
    long double max_abs_bound = 0.0L;
    long double abs_tol;
    long double rel_tol = 2.0e-4L;
    int iter;

    if (!checked_mul_size(opts->n, opts->n, &matrix_elems) ||
        !checked_mul_size(matrix_elems, sizeof(float), &matrix_bytes) ||
        !checked_mul_size(opts->n, sizeof(float), &vector_bytes)) {
        fprintf(stderr, "Requested n is too large for f32 matvec\n");
        return 0;
    }

    matrix = (float *)aligned_malloc_or_die(64U, matrix_bytes);
    vector = (float *)aligned_malloc_or_die(64U, vector_bytes);
    output = (float *)aligned_malloc_or_die(64U, vector_bytes);
    reference = (float *)aligned_malloc_or_die(64U, vector_bytes);

    fill_random_f32(matrix, matrix_elems, 0x1111222233334444ULL);
    fill_random_f32(vector, opts->n, 0x5555666677778888ULL);
    matvec_reference_f32(matrix, vector, reference, opts->n, &max_abs_bound);
    abs_tol = fmaxl(1.0e-6L, max_abs_bound * 2.0e-5L);

    if (strcmp(opts->algo, "cache_opt") == 0 || strcmp(opts->algo, "unroll") == 0) {
        double prep_start_ms;
        matrix_t = (float *)aligned_malloc_or_die(64U, matrix_bytes);
        prep_start_ms = now_ms();
        transpose_f32(matrix, matrix_t, opts->n);
        result->prep_ms = now_ms() - prep_start_ms;
    } else if (strcmp(opts->algo, "extreme") == 0) {
        double prep_start_ms;
        matrix_t = (float *)aligned_malloc_or_die(64U, matrix_bytes);
        prep_start_ms = now_ms();
        transpose_blocked_f32(matrix, matrix_t, opts->n);
        result->prep_ms = now_ms() - prep_start_ms;
    } else if (strcmp(opts->algo, "naive") != 0) {
        fprintf(stderr, "Unknown matvec algo: %s\n", opts->algo);
        aligned_free(reference);
        aligned_free(output);
        aligned_free(vector);
        aligned_free(matrix);
        return 0;
    }

    for (iter = 0; iter < opts->warmup; ++iter) {
        if (strcmp(opts->algo, "naive") == 0) {
            matvec_naive_f32(matrix, vector, output, opts->n);
        } else if (strcmp(opts->algo, "cache_opt") == 0) {
            matvec_cache_opt_f32(matrix_t, vector, output, opts->n);
        } else if (strcmp(opts->algo, "unroll") == 0) {
            matvec_unroll_f32(matrix_t, vector, output, opts->n, opts->unroll);
        } else {
            matvec_extreme_f32(matrix_t, vector, output, opts->n);
        }
        consume_ld((long double)output[iter % opts->n]);
    }

    for (iter = 0; iter < opts->repeat; ++iter) {
        double start_ms = now_ms();
        if (strcmp(opts->algo, "naive") == 0) {
            matvec_naive_f32(matrix, vector, output, opts->n);
        } else if (strcmp(opts->algo, "cache_opt") == 0) {
            matvec_cache_opt_f32(matrix_t, vector, output, opts->n);
        } else if (strcmp(opts->algo, "unroll") == 0) {
            matvec_unroll_f32(matrix_t, vector, output, opts->n, opts->unroll);
        } else {
            matvec_extreme_f32(matrix_t, vector, output, opts->n);
        }
        {
            double elapsed_ms = now_ms() - start_ms;
            result->total_ms += elapsed_ms;
            if (iter == 0 || elapsed_ms < result->min_ms) {
                result->min_ms = elapsed_ms;
            }
        }
        consume_ld((long double)output[(size_t)iter % opts->n]);
    }

    result->avg_ms = result->total_ms / (double)opts->repeat;
    result->checksum = (double)checksum_f32(output, opts->n);
    result->reference = (double)checksum_f32(reference, opts->n);
    result->check_ok = compare_vector_f32(output, reference, opts->n, abs_tol, rel_tol, &result->max_abs_err, &result->max_rel_err);

    aligned_free(matrix_t);
    aligned_free(reference);
    aligned_free(output);
    aligned_free(vector);
    aligned_free(matrix);
    return 1;
}

static int run_matvec_benchmark_f64(const benchmark_options_t *opts, benchmark_result_t *result) {
    size_t matrix_elems;
    size_t matrix_bytes;
    size_t vector_bytes;
    double *matrix;
    double *matrix_t = NULL;
    double *vector;
    double *output;
    double *reference;
    long double max_abs_bound = 0.0L;
    long double abs_tol;
    long double rel_tol = 1.0e-12L;
    int iter;

    if (!checked_mul_size(opts->n, opts->n, &matrix_elems) ||
        !checked_mul_size(matrix_elems, sizeof(double), &matrix_bytes) ||
        !checked_mul_size(opts->n, sizeof(double), &vector_bytes)) {
        fprintf(stderr, "Requested n is too large for f64 matvec\n");
        return 0;
    }

    matrix = (double *)aligned_malloc_or_die(64U, matrix_bytes);
    vector = (double *)aligned_malloc_or_die(64U, vector_bytes);
    output = (double *)aligned_malloc_or_die(64U, vector_bytes);
    reference = (double *)aligned_malloc_or_die(64U, vector_bytes);

    fill_random_f64(matrix, matrix_elems, 0xABCDEF0123456789ULL);
    fill_random_f64(vector, opts->n, 0x1029384756ULL);
    matvec_reference_f64(matrix, vector, reference, opts->n, &max_abs_bound);
    abs_tol = fmaxl(1.0e-12L, max_abs_bound * 1.0e-12L);

    if (strcmp(opts->algo, "cache_opt") == 0 || strcmp(opts->algo, "unroll") == 0) {
        double prep_start_ms;
        matrix_t = (double *)aligned_malloc_or_die(64U, matrix_bytes);
        prep_start_ms = now_ms();
        transpose_f64(matrix, matrix_t, opts->n);
        result->prep_ms = now_ms() - prep_start_ms;
    } else if (strcmp(opts->algo, "extreme") == 0) {
        double prep_start_ms;
        matrix_t = (double *)aligned_malloc_or_die(64U, matrix_bytes);
        prep_start_ms = now_ms();
        transpose_blocked_f64(matrix, matrix_t, opts->n);
        result->prep_ms = now_ms() - prep_start_ms;
    } else if (strcmp(opts->algo, "naive") != 0) {
        fprintf(stderr, "Unknown matvec algo: %s\n", opts->algo);
        aligned_free(reference);
        aligned_free(output);
        aligned_free(vector);
        aligned_free(matrix);
        return 0;
    }

    for (iter = 0; iter < opts->warmup; ++iter) {
        if (strcmp(opts->algo, "naive") == 0) {
            matvec_naive_f64(matrix, vector, output, opts->n);
        } else if (strcmp(opts->algo, "cache_opt") == 0) {
            matvec_cache_opt_f64(matrix_t, vector, output, opts->n);
        } else if (strcmp(opts->algo, "unroll") == 0) {
            matvec_unroll_f64(matrix_t, vector, output, opts->n, opts->unroll);
        } else {
            matvec_extreme_f64(matrix_t, vector, output, opts->n);
        }
        consume_ld((long double)output[iter % opts->n]);
    }

    for (iter = 0; iter < opts->repeat; ++iter) {
        double start_ms = now_ms();
        if (strcmp(opts->algo, "naive") == 0) {
            matvec_naive_f64(matrix, vector, output, opts->n);
        } else if (strcmp(opts->algo, "cache_opt") == 0) {
            matvec_cache_opt_f64(matrix_t, vector, output, opts->n);
        } else if (strcmp(opts->algo, "unroll") == 0) {
            matvec_unroll_f64(matrix_t, vector, output, opts->n, opts->unroll);
        } else {
            matvec_extreme_f64(matrix_t, vector, output, opts->n);
        }
        {
            double elapsed_ms = now_ms() - start_ms;
            result->total_ms += elapsed_ms;
            if (iter == 0 || elapsed_ms < result->min_ms) {
                result->min_ms = elapsed_ms;
            }
        }
        consume_ld((long double)output[(size_t)iter % opts->n]);
    }

    result->avg_ms = result->total_ms / (double)opts->repeat;
    result->checksum = (double)checksum_f64(output, opts->n);
    result->reference = (double)checksum_f64(reference, opts->n);
    result->check_ok = compare_vector_f64(output, reference, opts->n, abs_tol, rel_tol, &result->max_abs_err, &result->max_rel_err);

    aligned_free(matrix_t);
    aligned_free(reference);
    aligned_free(output);
    aligned_free(vector);
    aligned_free(matrix);
    return 1;
}

static int run_matvec_benchmark(const benchmark_options_t *opts, benchmark_result_t *result) {
    result->prep_ms = 0.0;
    result->total_ms = 0.0;
    result->avg_ms = 0.0;
    result->min_ms = 0.0;
    result->checksum = 0.0;
    result->reference = 0.0;
    result->max_abs_err = 0.0;
    result->max_rel_err = 0.0;
    result->check_ok = 0;

    if (opts->dtype == DTYPE_F32) {
        return run_matvec_benchmark_f32(opts, result);
    }
    return run_matvec_benchmark_f64(opts, result);
}

int main(int argc, char **argv) {
    benchmark_options_t opts;
    benchmark_result_t result;
    int ok;

    if (!parse_options(argc, argv, &opts)) {
        print_usage(argv[0]);
        return EXIT_FAILURE;
    }

    if (strcmp(opts.task, "sum") == 0) {
        ok = run_sum_benchmark(&opts, &result);
    } else if (strcmp(opts.task, "matvec") == 0) {
        ok = run_matvec_benchmark(&opts, &result);
    } else {
        fprintf(stderr, "Unknown task: %s\n", opts.task);
        return EXIT_FAILURE;
    }

    if (!ok) {
        return EXIT_FAILURE;
    }

    print_result(&opts, &result);
    return result.check_ok ? EXIT_SUCCESS : EXIT_FAILURE;
}
