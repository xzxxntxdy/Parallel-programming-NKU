# ANN Pthread ARM/AArch64 Command Set

These commands are prepared for the ARM machine. They are not run on the local
Windows x86 environment.

For the full ARM/Kunpeng handoff, required experiment order, CSV checklist, and
x86-vs-ARM comparison protocol, see `PTHREAD_ARM_KUNPENG_HANDOFF.md`.

## Default ARM Quick CPU Sweep

```bash
cd ann
ANN_DATA=/home/$USER/anndata \
bash run_pthread_arm.sh
```

Expected platform-specific copies:

- `files/results/pthread_results_arm.csv`
- `files/results/pthread_best_arm.csv`
- `files/results/pthread_final_arm.csv`
- `files/results/pthread_arm_benchmark.log`
- `files/results/pthread_arm_final.log`

## Default ARM Quick HNSW Advanced Sweep

```bash
cd ann
ANN_DATA=/home/$USER/anndata \
bash run_pthread_arm.sh --hnsw-only
```

Expected platform-specific copies:

- `files/results/pthread_hnsw_results_arm.csv`
- `files/results/pthread_hnsw_best_arm.csv`
- `files/results/pthread_hnsw_arm.log`

## Combined ARM Quick Sweep With Optional HNSW Baseline

```bash
cd ann
ANN_DATA=/home/$USER/anndata \
bash run_pthread_arm.sh --with-hnsw
```

Use this only if the report needs HNSW rows inside `pthread_results.csv`; the
dedicated `--hnsw-only` run is cleaner for advanced graph analysis.

## Short Validation

```bash
cd ann
ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh --arm-quick
ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh --arm-quick --hnsw-only
ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh --smoke
```

ARM/Kunpeng handoff defaults to quick mode. Use `--full` only for an additional
non-default diagnostic run:

```bash
cd ann
ANN_DATA=/home/$USER/anndata ANN_NQ=1000 ANN_TRAIN=4096 ANN_ITERS=12 \
    bash run_pthread_arm.sh --full
```

## Manual Compile And Final Path

```bash
cd ann
g++ main.cc -o main -O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I.
ANN_DATA=/home/$USER/anndata ./main --final-only --arm-quick \
    --data /home/$USER/anndata --nq 300 --train 2048 --iters 8
```

If `-mcpu=native` is unsupported on the target compiler, use:

```bash
cd ann
CXXFLAGS="-O2 -fopenmp -lpthread -std=c++11 -I." \
ANN_DATA=/home/$USER/anndata \
bash run_pthread_arm.sh
```

## Preserve Results Before Pulling Back

```bash
cd ann
ts=$(date +%Y%m%d_%H%M%S)
cp -f files/results/pthread_results_arm.csv files/results/pthread_results_arm_${ts}.csv
cp -f files/results/pthread_best_arm.csv files/results/pthread_best_arm_${ts}.csv
cp -f files/results/pthread_final_arm.csv files/results/pthread_final_arm_${ts}.csv
cp -f files/results/pthread_hnsw_results_arm.csv files/results/pthread_hnsw_results_arm_${ts}.csv
cp -f files/results/pthread_hnsw_best_arm.csv files/results/pthread_hnsw_best_arm_${ts}.csv
```

## Copy Results To x86 Workstation

From the workstation:

```bash
scp user@ARM_HOST:/path/to/ann/files/results/pthread_*_arm*.csv ./ann/files/results/
scp user@ARM_HOST:/path/to/ann/files/results/pthread_*_arm*.log ./ann/files/results/
```

After copying, rerun the report-side comparison scripts or regenerate tables
from the ARM-suffixed CSV files.
