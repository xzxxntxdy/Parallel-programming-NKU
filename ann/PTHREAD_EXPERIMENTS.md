# Pthread ANN Experiments

This directory contains the Pthread stage implementation. Shared ANN kernels
that are reused from the SIMD stage stay in `ann_search.h` and `ann_quant.h`.
The SIMD report, plots, and raw SIMD outputs are under `simd/`.

## Default Submission Path

`test.sh` compiles `main.cc` and runs `./main` without arguments. Therefore the
default mode is intentionally short and uses the selected final configuration:

```bash
g++ main.cc -o main -O2 -fopenmp -lpthread -std=c++11
./main
```

The final configuration currently used by `main` is:

```text
Criterion: minimize latency among candidates with recall@100 >= 0.95
HNSW StdAsync query-level parallel search, M=16, efConstruction=100, ef=64,
threads=32 by default, threads=2 with --arm-quick
```

It writes `files/results/pthread_final.csv` and prints average recall@100,
average latency, and build time.

## Full x86 Sweep

```bash
cd ann
ANN_DATA=../anndata bash run_pthread_x86.sh
```

Useful shorter run:

```bash
ANN_DATA=../anndata ANN_NQ=500 ANN_TRAIN=4096 ANN_ITERS=10 \
    bash run_pthread_x86.sh --quick
```

Smoke test only:

```bash
ANN_DATA=../anndata ANN_NQ=50 ANN_TRAIN=1024 ANN_ITERS=6 \
    bash run_pthread_x86.sh --smoke
```

The full sweep writes `files/results/pthread_results.csv` and regenerates the
paper-style figures with `plot_pthread.py`. It also writes
`files/results/pthread_best.csv`, where the best row is selected by the
`recall@100 >= 0.95` latency-minimization criterion.

## HNSW / Advanced Graph Sweep

HNSW experiments are kept in a separate CSV so the main Pthread sweep is not
overwritten:

```bash
cd ann
ANN_DATA=../anndata ANN_NQ=1000 ANN_TRAIN=4096 ANN_ITERS=12 \
    bash run_pthread_x86.sh --hnsw-only
```

On Windows/MSVC:

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_x86.ps1 -HnswOnly -Data D:/Parallel-programming-NKU/anndata -Nq 1000
```

Outputs:

- `files/results/pthread_hnsw_results.csv`: all HNSW advanced rows.
- `files/results/pthread_hnsw_best.csv`: minimum latency row satisfying
  `recall@100 >= 0.95`.
- `files/results/pthread_hnsw_x86*.log`: platform run log.

The advanced graph sweep covers the requested difficult HNSW cases:

- `HNSW-ToolCompare`: one HNSW graph, query-level parallelism implemented with
  `std::thread` and C++ standard `std::async`. OpenMP requirement coverage is
  handled by the separate strict target-device CSV, not by host-side rows.
- `HNSW-IntraQuery`: Layer-0 multi-entry search, edge-index partition search,
  and exact Layer-0 point partition. The `nthreads` field records the number of
  entries, edge partitions, or point partitions used for one query.
- `IVF-HNSW`: nested IVF+HNSW structure. Each selected inverted list owns one
  HNSW graph; threads search selected shard graphs and merge top-k results.

The latest local x86/MSVC HNSW-only run selected:

```text
HNSW-ToolCompare / StdAsync, ef=64, threads=32,
latency=0.009739 ms/query, recall@100=0.954540
```

The default submission path now uses the HNSW high-recall winner because it is
the global minimum-latency candidate satisfying `recall@100 >= 0.95` in the
current x86 measurements. IVF remains the strongest non-graph CPU pruning
baseline in `pthread_best.csv`.

## ARM/AArch64 Sweep

```bash
cd ann
ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh
```

The ARM script compiles with:

```bash
g++ main.cc -o main -O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I.
```

Override the compiler flags if the target machine needs a different CPU option:

```bash
CXXFLAGS="-O2 -fopenmp -lpthread -std=c++11 -I." \
    ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh --arm-quick
```

ARM HNSW/advanced-only run:

```bash
ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh --hnsw-only
```

Short ARM validation run:

```bash
ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh --arm-quick --hnsw-only
```

The ARM script now also copies generic outputs to ARM-suffixed files such as
`pthread_results_arm.csv`, `pthread_best_arm.csv`, `pthread_final_arm.csv`,
`pthread_hnsw_results_arm.csv`, and `pthread_hnsw_best_arm.csv`. The complete
ARM command set is recorded in `PTHREAD_ARM_COMMANDS.md`.

## Accelerator / oneAPI Commands

Optional accelerator comparisons are isolated from the submission path and
produce their own CSV files:

```bash
cd ann
ANN_DATA=/path/to/anndata ANN_NQ=100 bash run_pthread_accelerators.sh --openmp-target
ANN_DATA=/path/to/anndata ANN_NQ=1000 bash run_pthread_accelerators.sh --cuda
ANN_DATA=/path/to/anndata ANN_NQ=100 bash run_pthread_accelerators.sh --sycl
```

Windows Intel GPU run with ordinary optimized oneAPI/SYCL `-O2` kernel. The
script defaults to the local 2024.2.1 DPC++ environment under
`tools/conda_envs/oneapi-dpcpp-2024.2.1`:

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_oneapi.ps1 -Data D:/Parallel-programming-NKU/anndata -Nq 1000 `
    -BaselineMs 4.68365 -DeviceSelector opencl:gpu `
    -Device intel-gpu -BuildProfile O2 -Backend SYCL -Algo ivf -NList 2048 `
    -NProbeList "76,78,80,82,84,88" -TargetRecall 0.95 -Batch 1000 `
    -WorkgroupSize 128 -LocalK 4 `
    -Csv files/results/pthread_sycl_o2_2024_results.csv `
    -BestCsv files/results/pthread_sycl_o2_2024_best.csv
```

Windows OpenMP target Intel GPU run. This path is strict accelerator offload:
the script uses `OMP_TARGET_OFFLOAD=MANDATORY`, defaults to the local DPC++
2024.2.1 environment plus Level Zero, and benchmarks an IVF candidate-pruning
path. The target region verifies `omp_is_initial_device()==false` before the CSV
is accepted.

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_openmp_target.ps1 -Data D:/Parallel-programming-NKU/anndata `
    -Nq 1000 -BaselineMs 3.175053 `
    -NListList "2048" -NProbeList "79,80,81,82,83,84" `
    -CandidateCaps "3808,3824,3840,3856,3872,3904"
```

The OpenCL C implementation in `pthread_opencl_ivf.cc` remains available for
explicit `-Backend OpenCLC` comparison, but the default Intel GPU paths are
SYCL O2 and OpenMP target Level Zero. The results are stored separately from CPU
Pthread sweeps.

The CUDA probe is still present for machines that need it, but it is not part of
the Intel GPU comparison requested here:

```powershell
.\run_pthread_cuda.ps1 -Data D:/Parallel-programming-NKU/anndata -Nq 1000 -BaselineMs 3.175053
```

Expected outputs:

- `files/results/pthread_openmp_target_device_results.csv`
- `files/results/pthread_openmp_target_device_best.csv`
- `files/results/pthread_openmp_target_device_x86_windows.log`
- `files/results/pthread_cuda_results.csv`
- `files/results/pthread_sycl_results.csv`
- `files/results/pthread_sycl_o2_2024_results.csv`
- `files/results/pthread_opencl_o2_results.csv`

Intel oneAPI C++ Essentials 2025.x remains installed under
`C:\Program Files (x86)\Intel\oneAPI`; the stable local SYCL GPU experiment uses
the project-local DPC++ 2024.2.1 conda environment.
SYCL and OpenMP target accelerator records are kept separate from the Pthread
CPU sweep.

## Host OpenMP CPU Commands

The basic OpenMP CPU requirement is covered by a separate host-side OpenMP
benchmark, not by the OpenMP target device result.  This path uses `#pragma omp`
query-level and base-split loops, compares `static` and `dynamic` scheduling,
and writes isolated CSV files:

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_openmp_cpu.ps1 -Data D:/Parallel-programming-NKU/anndata `
    -Nq 1000 -Train 4096 -Iters 12
```

Outputs:

- `files/results/pthread_openmp_cpu_results_x86_windows.csv`
- `files/results/pthread_openmp_cpu_best_x86_windows.csv`
- `files/results/pthread_openmp_cpu_x86_windows.log`

Latest x86 OpenMP CPU best:

```text
OpenMP-CPU-IVF / nl512-dynamic / nprobe=32 / threads=32
latency=0.082060 ms/query, recall@100=0.956950
```

ARM/Kunpeng quick command:

```bash
cd ann
ANN_DATA=/anndata bash run_pthread_openmp_cpu.sh --arm-quick
```

Expected ARM outputs:

- `files/results/pthread_openmp_cpu_results_arm.csv`
- `files/results/pthread_openmp_cpu_best_arm.csv`
- `files/results/pthread_openmp_cpu_arm.log`

## Profiling Summary

SIMD-stage hardware-counter profiling is kept under `simd/files/results`.  The
Pthread/OpenMP stage now has a lightweight stage-timing summary that follows the
same analysis style and can be regenerated after new ARM results are copied
back:

```powershell
cd D:\Parallel-programming-NKU\ann
python summarize_pthread_profile.py
```

Outputs:

- `files/results/pthread_profile_summary.csv`
- `files/results/pthread_profile_simd_perf_context.csv`

On ARM/Kunpeng, optional perf-counter profiling commands are listed in
`PTHREAD_ARM_COMMANDS.md`.

## Experiment Matrix

The benchmark mode records recall@100, normalized latency per query, speedup
relative to scalar flat search, index size, build time, and a timing breakdown.

Main sweeps:

- Flat pthread query parallelism: scalar, auto-vectorized, SSE, AVX2, NEON-style
  unroll, prefetch top-k.
- Flat base-split parallelism: local merge candidate count.
- SQ8: rerank candidate count and thread count.
- PQ-ADC: `M=8/12/16`, rerank candidate count, thread count.
- PQ-SDC: symmetric-distance scan with the same rerank/thread sweep.
- PQ FastScan: block size `32/64/128`, rerank candidate count, thread count.
- SDC pipeline: encode, scan, rerank staging and batch-size sweep.
- IVF: `nlist`, `nprobe`, and thread-count sweep.
- IVF-PQ: IVF candidate pruning plus global PQ rerank.
- Optional HNSW: enable with `--with-hnsw`.
- Advanced-only HNSW: `--hnsw-only`, which writes separate HNSW CSV files.
- Host OpenMP CPU: Flat query-level/base-split, PQ-ADC, IVF, static/dynamic
  schedule comparison in `pthread_openmp_host.cc`.
- Optional OpenMP target offload and oneAPI/SYCL flat-search probes in
  `pthread_openmp_target_ivf.cc` and `pthread_sycl_flat.cc`.
- Optional CUDA exact flat-search probe in `pthread_cuda_flat.cu`, retained but
  not used for the Intel GPU comparison.

Use the CSV together with the generated figures for the final trade-off analysis:
latency versus recall, memory/build cost, scaling efficiency, and stage
bottlenecks.

## Current Local Snapshot

`--quick` is now a medium-size screening run, not a smoke test. Its x86 defaults
are `nq=500`, `train=4096`, and `iters=10`; use `--smoke` only for the old
`nq=50` sanity check. Local x86 final numbers use the full `Nq=1000` scripts.
ARM/Kunpeng scripts default to `--arm-quick` scale for the handoff runs.

Observed trade-offs from this snapshot:

- Flat scan remains the recall ceiling. The latest x86/MSVC full sweep reached
  recall@100 `1.0`; the best Flat/SSE 32-thread row measured
  `0.130451 ms/query`, but it still scans the full base.
- IVF is the strongest non-graph pruning path. The regenerated full benchmark
  contains 798 rows, including the per-cluster `IVF-PQ-Local` ablation. Its best
  non-HNSW row is `IVF, nl512, nprobe=32, threads=32`, with recall@100
  `0.956950` and `0.044471 ms/query` on the 1000-query benchmark subset.
- The latest default final run now uses HNSW because the graph path is the
  global minimum-latency candidate under the recall constraint. Over all loaded
  queries it measured recall@100 `0.952683` and `9.316 us/query` with 32
  threads.
- The HNSW advanced-only local run contains 84 rows: 48 tool-comparison rows,
  4 Layer-0 multi-entry rows, 4 Layer-0 edge-partition rows, 4 exact Layer-0
  point-partition rows, and 24 IVF-HNSW rows. The fastest row satisfying
  recall@100 `>= 0.95` is `HNSW-ToolCompare/StdAsync`, `ef=64`, `threads=32`,
  with `0.009739 ms/query` and recall@100 `0.954540`.
- Layer-0 multi-entry, edge partition, and exact point partition are retained
  as intra-query parallelization studies. They are useful negative-optimization
  evidence because higher recall or more partitions do not translate into the
  lowest latency.
- IVF-HNSW remains a high-accuracy graph-pruning ablation. It is more accurate
  than the fastest HNSW row for some settings but slower than the single-index
  HNSW high-recall winner.
- oneAPI/SYCL Intel OpenCL GPU now has a plain `-O2` 2024.2.1 result, so it is
  evaluated with the same selection rule as the Pthread path: minimize latency
  subject to recall@100 `>= 0.95`. With `nlist=2048`, the latest local sweep
  over `nprobe=76,78,80,82,84,88` selected `nprobe=80`, with recall@100
  `0.950600`, `0.215992 ms/query`, and `21.68x` versus the single-thread scalar
  flat baseline from this run. The exact flat GPU rows remain in
  `pthread_sycl_results.csv` as an upper-bound/implementation ablation and
  should not be used as the threshold-constrained best result.
- oneAPI/SYCL CPU-target IVF was also measured locally with `nq=1000` and the
  same candidate list. The latest CPU-selector sweep selected `nprobe=34`, with
  recall@100 `0.95966` and `0.074290 ms/query`. This high-end i9 CPU remains
  faster than the integrated Intel GPU for this workload, mainly because coarse
  selection and final top-k are still on the host and the scanned IVF candidate
  sets are small.
- OpenMP target Intel GPU offload now uses an IVF candidate-pruning path, not
  exact Flat scan. It is measured locally with DPC++ 2024.2.1,
  `ONEAPI_DEVICE_SELECTOR=level_zero:gpu`, and `OMP_TARGET_OFFLOAD=MANDATORY`.
  The benchmark verifies device execution with `target_initial_device=0`. The
  latest full-query tuning sweep has 36 rows over `nprobe` and `candidate_cap`;
  the selected row in `pthread_openmp_target_device_best.csv` is
  `nlist=2048, nprobe=81, candidate_cap=3840`, with recall@100 `0.950170`,
  `0.186502 ms/query`, and `17.02x` versus the single-thread scalar flat
  baseline from this run.
