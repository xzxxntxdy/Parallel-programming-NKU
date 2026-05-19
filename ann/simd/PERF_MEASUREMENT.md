# Perf Measurement Note

## Current Environment

`perf` is installed:

```text
/usr/bin/perf
```

Smoke test on a local process succeeds:

```bash
perf stat -e cycles,instructions true
```

Observed result:

```text
227927 cycles:u
135948 instructions:u
```

This means the OS allows user-space hardware performance counter sampling for local processes.

## Current Direct-Kernel Policy

The user has allowed direct execution for kernel analysis. Therefore the project now supports:

```bash
./main --kernel <kernel> <Q> <repeat>
./main --final-only
```

This makes `perf stat` valid for the actual ANN kernel process.

## Previous Course-Script Limitation

The original course rule required running the program through:

```bash
bash test.sh 1 1
```

and forbids direct `./main` execution on the course cluster. Wrapping `perf stat` around `bash test.sh 1 1` would measure the local submission/decompression/qsub wrapper process, not necessarily the actual compute-node `main` process. Therefore, it is not a valid source for runtime `cycles`, `instructions`, CPI, or cache-miss data for the ANN kernel.

## What Is Needed for Real Perf-Based Roofline

Real perf-counter roofline requires one of the following:

1. Permission to run the compiled binary directly on a controlled local node with:

```bash
perf stat -e cycles,instructions,cache-references,cache-misses ./main
```

2. Permission to modify or wrap the batch job so `perf stat` runs inside the compute-node job around the real `main` process.

Now that direct kernel execution is allowed, real perf-counter measurements have been collected for:

- `flat-neon`
- `pq-m16-p2000`
- `pqsel-m16-p2000`
- `fsadc-m16-p1500-b64`

The parsed results are in:

```text
files/results/perf_summary.csv
files/figures/fig_perf_counter_comparison.{png,pdf,svg}
files/figures/fig_perf_cache_behavior.{png,pdf,svg}
files/figures/fig_perf_roofline.{png,pdf,svg}
```

Detailed experiment notes are in `PERF_EXPERIMENT_LOG.md`.
