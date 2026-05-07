# SIMD Assembly Static Summary

This file is generated from `files/analysis/main_O2.s` and is a static assembly scan, not a runtime perf counter result.

| pattern | static count |
|---|---:|
| neon_fmla_or_vmla | 15 |
| float_mul | 45 |
| float_add | 1717 |
| vector_load_ld1 | 0 |
| load_ldr | 1925 |
| prefetch_prfm | 2 |
| horizontal_add | 17 |
| branch | 2220 |

Notes:

- `prefetch_prfm` confirms whether the compiler emitted ARM prefetch instructions for the prefetch variants.
- `neon_fmla_or_vmla`, `vector_load_ld1`, and `horizontal_add` are used as coarse evidence that packed NEON code is present.
- Runtime `cycles`, `instructions`, CPI and cache-miss rates still require `perf stat` on a platform where direct profiling is allowed.
