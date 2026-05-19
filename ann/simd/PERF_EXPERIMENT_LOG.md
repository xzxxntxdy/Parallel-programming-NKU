# Kernel Perf Experiment Log

Date: 2026-05-07

Goal: switch from course-script-only validation to direct kernel analysis, collect real perf counters, and optimize the final ANN query path.

## Environment

- Platform: ARM aarch64 / NEON
- Data: DEEP100K, `N=100000`, `d=96`, `Q=2000`, `k=10`
- Direct kernel command format:

```bash
./main --kernel <kernel> <Q> <repeat>
```

- Perf command format:

```bash
perf stat -x, -o files/results/perf_<name>.csv \
  -e cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
  ./main --kernel <kernel> 2000 3
```

## Kernel Sweep

| Step | Kernel | Q | Repeat | Latency ms/query | Recall@10 | Decision |
|---|---|---:|---:|---:|---:|---|
| Baseline | `flat-neon` | 2000 | 3 | 7.389 | 0.99995 | Exact baseline |
| Candidate | `pq-m16-p500` | 2000 | 3 | 3.011 | 0.996151 | Too much recall loss for final |
| Candidate | `pq-m16-p1000` | 2000 | 3 | 3.508 | 0.999750 | Strong speed, small recall loss |
| Candidate | `pq-m16-p2000` | 2000 | 3 | 4.450 | 0.999950 | Same recall as Flat, much faster |
| Candidate | `pq-m8-p5000` | 2000 | 3 | 5.074 | 0.999450 | Slower and lower recall than M16-p2000 |
| Optimization | `pqsel-m16-p2000` | 2000 | 3 | 3.611 | 0.999950 | Top-p heap replaced by `nth_element` |
| Perf run | `pqsel-m16-p2000` | 2000 | 3 | 3.584 | 0.999950 | Intermediate Top-p optimization |
| FastScan | `fsadc-m16-p1000-b32` | 2000 | 3 | 3.186 | 0.999750 | Faster, but recall drops |
| FastScan | `fsadc-m16-p1500-b32` | 2000 | 3 | 3.415 | 0.999950 | Recall restored |
| FastScan | `fsadc-m16-p1500-b64` | 2000 | 3 | 3.179 | 0.999950 | Final direct-kernel choice |

Final direct validation:

```text
./main --final-only
average recall: 0.99995
average latency (us): 3001.53
```

Formal course-script validation:

```text
bash test.sh 1 1
average recall: 0.99995
average latency (us): 3056.39
```

## Perf Counter Summary

From `files/results/perf_summary.csv`:

| Kernel | Cycles/query | Instructions/query | IPC | L1D miss rate | LLC miss rate | Recall@10 |
|---|---:|---:|---:|---:|---:|---:|
| `flat-neon` | 24.10M | 21.24M | 0.88 | 2.68% | 40.11% | 0.99995 |
| `pq-m16-p2000` | 12.84M | 21.66M | 1.69 | 0.60% | 17.16% | 0.99995 |
| `pqsel-m16-p2000` | 10.85M | 19.26M | 1.78 | 0.84% | 19.67% | 0.99995 |
| `fsadc-m16-p1500-b64` | 9.72M | 20.84M | 2.14 | 0.60% | 20.91% | 0.99995 |

Interpretation:

- PQ reduces memory traffic substantially compared with exact Flat scan.
- `pqsel-m16-p2000` preserves the Flat recall level while cutting cycles/query by about 55%.
- Replacing heap-based Top-p with `nth_element` reduces both cycles/query and instructions/query for `p=2000`.
- FastScan-style ADC further lowers cycles/query to 9.72M and raises IPC to 2.14 by using uint8 LUT and block-major scan.
- PQ/FastScan have far lower L1 miss rates than Flat; the remaining cost is mostly integer LUT scan, Top-p selection, and float rerank.

## Generated Perf Artifacts

- `files/results/kernel_experiments.csv`
- `files/results/perf_flat_neon_2000x3.csv`
- `files/results/perf_pq_m16_p2000_2000x3.csv`
- `files/results/perf_pqsel_m16_p2000_2000x3.csv`
- `files/results/perf_fsadc_m16_p1500_b64_2000x3.csv`
- `files/results/perf_summary.csv`
- `files/figures/fig_perf_counter_comparison.{png,pdf,svg}`
- `files/figures/fig_perf_cache_behavior.{png,pdf,svg}`
- `files/figures/fig_perf_roofline.{png,pdf,svg}`

## Current Final ANN Path

The default query path in `main.cc` now builds a `PQIndex` and a block-major FastScan code layout with:

```text
M = 16
Ks = 256
train_sample = 2048
kmeans_iters = 10
rerank p = 1500
block size = 64
scan = uint8 LUT + block-major integer accumulation
```

The query loop calls:

```cpp
ann::pq_adc_fastscan_search_rerank_timed(...)
```

Build time is reported on stderr and is not included in per-query latency.
