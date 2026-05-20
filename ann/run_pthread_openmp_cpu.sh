#!/bin/bash
# Host-side OpenMP CPU ANN experiment.
# This is separate from OpenMP target offload.  It satisfies the basic OpenMP
# CPU-parallel comparison requirement and writes OpenMP-specific CSV files.
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p files/results

DATA_DIR="${ANN_DATA:-/home/${USER}/anndata}"
EXTRA_ARGS=()
ARCH="$(uname -m || true)"
if [[ "${ARCH}" == "aarch64" || "${ARCH}" == arm* ]]; then
    PLATFORM_SUFFIX="arm"
    DEFAULT_MODE="arm-quick"
else
    PLATFORM_SUFFIX="x86_linux"
    DEFAULT_MODE="full"
fi
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
    EXTRA_ARGS+=("--arm-quick")
elif [[ "${DEFAULT_MODE}" == "arm-quick" ]]; then
    DEFAULT_NQ=300
    DEFAULT_TRAIN=2048
    DEFAULT_ITERS=8
    EXTRA_ARGS+=("--arm-quick")
else
    DEFAULT_NQ=1000
    DEFAULT_TRAIN=4096
    DEFAULT_ITERS=12
fi

NQ="${ANN_NQ:-$DEFAULT_NQ}"
TRAIN="${ANN_TRAIN:-$DEFAULT_TRAIN}"
ITERS="${ANN_ITERS:-$DEFAULT_ITERS}"
CXX="${CXX:-g++}"
CXXFLAGS="${CXXFLAGS:--O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I.}"

echo "=== [1/2] Compile OpenMP host CPU ==="
"${CXX}" pthread_openmp_host.cc -o openmp_cpu ${CXXFLAGS}

echo "=== [2/2] Run OpenMP host CPU sweep ==="
./openmp_cpu --benchmark "${EXTRA_ARGS[@]}" "$@" --data "${DATA_DIR}" \
    --nq "${NQ}" --train "${TRAIN}" --iters "${ITERS}" \
    2>&1 | tee "files/results/pthread_openmp_cpu_${PLATFORM_SUFFIX}.log"

[[ -f files/results/pthread_openmp_cpu_results.csv ]] && \
    cp -f files/results/pthread_openmp_cpu_results.csv "files/results/pthread_openmp_cpu_results_${PLATFORM_SUFFIX}.csv"
[[ -f files/results/pthread_openmp_cpu_best.csv ]] && \
    cp -f files/results/pthread_openmp_cpu_best.csv "files/results/pthread_openmp_cpu_best_${PLATFORM_SUFFIX}.csv"

echo "DONE"
