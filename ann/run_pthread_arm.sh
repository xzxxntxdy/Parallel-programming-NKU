#!/bin/bash
# ARM/AArch64 pthread experiment entry.
# Usage:
#   ANN_DATA=/path/to/anndata bash run_pthread_arm.sh          # default ARM quick
#   ANN_NQ=300 ANN_TRAIN=2048 ANN_ITERS=8 bash run_pthread_arm.sh --arm-quick
#   ANN_NQ=50 ANN_TRAIN=1024 ANN_ITERS=6 bash run_pthread_arm.sh --smoke
#   ANN_NQ=1000 bash run_pthread_arm.sh --full --hnsw-only
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p files/results files/figures

ADVANCED_MODE=0
if [[ " $* " == *" --hnsw-only "* || " $* " == *" --advanced-only "* || " $* " == *" --advanced "* ]]; then
    ADVANCED_MODE=1
fi

DATA_DIR="${ANN_DATA:-/home/${USER}/anndata}"
MAIN_EXTRA_ARGS=()
if [[ " $* " == *" --smoke "* ]]; then
    DEFAULT_NQ=50
    DEFAULT_TRAIN=1024
    DEFAULT_ITERS=6
elif [[ " $* " == *" --full "* ]]; then
    DEFAULT_NQ=1000
    DEFAULT_TRAIN=4096
    DEFAULT_ITERS=12
elif [[ " $* " == *" --quick "* ]]; then
    DEFAULT_NQ=500
    DEFAULT_TRAIN=4096
    DEFAULT_ITERS=10
elif [[ " $* " == *" --arm-quick "* ]]; then
    DEFAULT_NQ=300
    DEFAULT_TRAIN=2048
    DEFAULT_ITERS=8
else
    DEFAULT_NQ=300
    DEFAULT_TRAIN=2048
    DEFAULT_ITERS=8
    MAIN_EXTRA_ARGS+=("--arm-quick")
fi
NQ="${ANN_NQ:-$DEFAULT_NQ}"
TRAIN="${ANN_TRAIN:-$DEFAULT_TRAIN}"
ITERS="${ANN_ITERS:-$DEFAULT_ITERS}"
CXX="${CXX:-g++}"
CXXFLAGS="${CXXFLAGS:--O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I.}"

echo "=== [1/4] Compile for ARM ==="
"${CXX}" main.cc -o main ${CXXFLAGS}

if [[ "${ADVANCED_MODE}" -eq 1 ]]; then
    echo "=== [2/2] ARM HNSW/advanced benchmark sweep ==="
    LOG_PATH="files/results/pthread_hnsw_arm.log"
else
    echo "=== [2/4] ARM benchmark sweep ==="
    LOG_PATH="files/results/pthread_arm_benchmark.log"
fi

./main --benchmark "${MAIN_EXTRA_ARGS[@]}" "$@" --data "${DATA_DIR}" --nq "${NQ}" \
    --train "${TRAIN}" --iters "${ITERS}" \
    2>&1 | tee "${LOG_PATH}"

if [[ "${ADVANCED_MODE}" -eq 1 ]]; then
    [[ -f files/results/pthread_hnsw_results.csv ]] && cp -f files/results/pthread_hnsw_results.csv files/results/pthread_hnsw_results_arm.csv
    [[ -f files/results/pthread_hnsw_best.csv ]] && cp -f files/results/pthread_hnsw_best.csv files/results/pthread_hnsw_best_arm.csv
    echo "DONE"
    exit 0
fi

if command -v python3 >/dev/null 2>&1; then
    echo "=== [3/4] Plot figures ==="
    python3 plot_pthread.py
else
    echo "=== [3/4] Plot figures skipped: python3 not found ==="
fi

echo "=== [4/4] ARM final selected configuration ==="
./main --final-only "${MAIN_EXTRA_ARGS[@]}" "$@" --data "${DATA_DIR}" --nq "${NQ}" \
    --train "${TRAIN}" --iters "${ITERS}" \
    2>&1 | tee files/results/pthread_arm_final.log
[[ -f files/results/pthread_results.csv ]] && cp -f files/results/pthread_results.csv files/results/pthread_results_arm.csv
[[ -f files/results/pthread_best.csv ]] && cp -f files/results/pthread_best.csv files/results/pthread_best_arm.csv
[[ -f files/results/pthread_final.csv ]] && cp -f files/results/pthread_final.csv files/results/pthread_final_arm.csv

echo "DONE"
