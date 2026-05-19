#!/bin/bash
# Linux/x86 pthread experiment entry.
# Usage:
#   ANN_DATA=/path/to/anndata bash run_pthread_x86.sh
#   ANN_NQ=500 bash run_pthread_x86.sh --quick --with-hnsw
#   ANN_NQ=50 bash run_pthread_x86.sh --smoke
#   ANN_NQ=1000 bash run_pthread_x86.sh --hnsw-only
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p files/results files/figures

ADVANCED_MODE=0
if [[ " $* " == *" --hnsw-only "* || " $* " == *" --advanced-only "* || " $* " == *" --advanced "* ]]; then
    ADVANCED_MODE=1
fi

DATA_DIR="${ANN_DATA:-../anndata}"
if [[ " $* " == *" --smoke "* ]]; then
    DEFAULT_NQ=50
    DEFAULT_TRAIN=1024
    DEFAULT_ITERS=6
elif [[ " $* " == *" --quick "* ]]; then
    DEFAULT_NQ=500
    DEFAULT_TRAIN=4096
    DEFAULT_ITERS=10
else
    DEFAULT_NQ=1000
    DEFAULT_TRAIN=4096
    DEFAULT_ITERS=12
fi
NQ="${ANN_NQ:-$DEFAULT_NQ}"
TRAIN="${ANN_TRAIN:-$DEFAULT_TRAIN}"
ITERS="${ANN_ITERS:-$DEFAULT_ITERS}"
CXX="${CXX:-g++}"
CXXFLAGS="${CXXFLAGS:--O2 -march=native -fopenmp -lpthread -std=c++11 -I.}"

echo "=== [1/4] Compile for x86 ==="
"${CXX}" main.cc -o main ${CXXFLAGS}

if [[ "${ADVANCED_MODE}" -eq 1 ]]; then
    echo "=== [2/2] HNSW/advanced benchmark sweep ==="
    LOG_PATH="files/results/pthread_hnsw_x86.log"
else
    echo "=== [2/4] Full benchmark sweep ==="
    LOG_PATH="files/results/pthread_x86_benchmark.log"
fi

./main --benchmark "$@" --data "${DATA_DIR}" --nq "${NQ}" \
    --train "${TRAIN}" --iters "${ITERS}" \
    2>&1 | tee "${LOG_PATH}"

if [[ "${ADVANCED_MODE}" -eq 1 ]]; then
    [[ -f files/results/pthread_hnsw_results.csv ]] && cp -f files/results/pthread_hnsw_results.csv files/results/pthread_hnsw_results_x86_linux.csv
    [[ -f files/results/pthread_hnsw_best.csv ]] && cp -f files/results/pthread_hnsw_best.csv files/results/pthread_hnsw_best_x86_linux.csv
    echo "DONE"
    exit 0
fi

if command -v python3 >/dev/null 2>&1; then
    echo "=== [3/4] Plot figures ==="
    python3 plot_pthread.py
else
    echo "=== [3/4] Plot figures skipped: python3 not found ==="
fi

echo "=== [4/4] Final selected configuration ==="
./main --final-only "$@" --data "${DATA_DIR}" --nq "${NQ}" \
    --train "${TRAIN}" --iters "${ITERS}" \
    2>&1 | tee files/results/pthread_x86_final.log
[[ -f files/results/pthread_results.csv ]] && cp -f files/results/pthread_results.csv files/results/pthread_results_x86_linux.csv
[[ -f files/results/pthread_best.csv ]] && cp -f files/results/pthread_best.csv files/results/pthread_best_x86_linux.csv
[[ -f files/results/pthread_final.csv ]] && cp -f files/results/pthread_final.csv files/results/pthread_final_x86_linux.csv

echo "DONE"
