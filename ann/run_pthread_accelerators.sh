#!/bin/bash
# Optional accelerator comparisons for the advanced requirements.
# These benchmarks are not part of test.sh and require suitable toolchains.
#
# OpenMP target example:
#   ANN_DATA=/path/to/anndata bash run_pthread_accelerators.sh --openmp-target
#
# oneAPI/SYCL example:
#   ANN_DATA=/path/to/anndata ONEAPI_DEVICE_SELECTOR=opencl:gpu \
#       bash run_pthread_accelerators.sh --sycl
#
# CUDA example:
#   ANN_DATA=/path/to/anndata bash run_pthread_accelerators.sh --cuda
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p files/results

DATA_DIR="${ANN_DATA:-../anndata}"
NQ="${ANN_NQ:-100}"
MODE="${1:-all}"
BASELINE_MS="${ANN_BASELINE_MS:-0}"

if [[ "${MODE}" == "all" || "${MODE}" == "--openmp-target" ]]; then
    CXX_OFFLOAD="${CXX_OFFLOAD:-g++}"
    CXX_OFFLOAD_FLAGS="${CXX_OFFLOAD_FLAGS:--O2 -fopenmp -std=c++11 -I.}"
    OPENMP_NLIST="${ANN_OPENMP_NLIST:-2048}"
    OPENMP_NPROBES="${ANN_OPENMP_NPROBES:-48,64,72,80,88,96,112}"
    OPENMP_CAPS="${ANN_OPENMP_CAPS:-2048,3072,4096,6144}"
    OPENMP_BATCH="${ANN_OPENMP_BATCH:-1000}"
    OPENMP_TARGET_RECALL="${ANN_TARGET_RECALL:-0.95}"
    echo "=== OpenMP target IVF benchmark ==="
    "${CXX_OFFLOAD}" pthread_openmp_target_ivf.cc -o pthread_openmp_target_ivf ${CXX_OFFLOAD_FLAGS}
    OMP_TARGET_OFFLOAD=MANDATORY ./pthread_openmp_target_ivf \
        --data "${DATA_DIR}" --nq "${NQ}" --baseline-ms "${BASELINE_MS}" \
        --target-recall "${OPENMP_TARGET_RECALL}" --batch "${OPENMP_BATCH}" \
        --nlist-list "${OPENMP_NLIST}" --nprobe-list "${OPENMP_NPROBES}" \
        --candidate-cap-list "${OPENMP_CAPS}" \
        2>&1 | tee files/results/pthread_openmp_target_device.log
fi

if [[ "${MODE}" == "all" || "${MODE}" == "--cuda" ]]; then
    if ! command -v nvcc >/dev/null 2>&1; then
        echo "nvcc not found; install CUDA Toolkit or add it to PATH."
        exit 3
    fi
    CUDA_FLAGS="${CUDA_FLAGS:--O2 -std=c++17 -I.}"
    echo "=== CUDA flat GPU benchmark ==="
    nvcc pthread_cuda_flat.cu -o pthread_cuda_flat ${CUDA_FLAGS}
    ./pthread_cuda_flat --data "${DATA_DIR}" --nq "${NQ}" --baseline-ms "${BASELINE_MS}" \
        2>&1 | tee files/results/pthread_cuda.log
fi

if [[ "${MODE}" == "all" || "${MODE}" == "--sycl" ]]; then
    if command -v icpx >/dev/null 2>&1; then
        SYCL_CXX="${SYCL_CXX:-icpx}"
    elif command -v dpcpp >/dev/null 2>&1; then
        SYCL_CXX="${SYCL_CXX:-dpcpp}"
    else
        echo "SYCL compiler not found; install oneAPI or set SYCL_CXX."
        exit 3
    fi
    SYCL_FLAGS="${SYCL_FLAGS:--O2 -fsycl -fno-sycl-early-optimizations -std=c++17 -I.}"
    SYCL_DEVICE="${ANN_SYCL_DEVICE:-intel-gpu}"
    SYCL_METHOD="${ANN_SYCL_METHOD:-IntelOpenCLGPU}"
    SYCL_NOTES="${ANN_SYCL_NOTES:-linux_oneapi; build=SafeO2}"
    SYCL_ALGO="${ANN_SYCL_ALGO:-ivf}"
    SYCL_NLIST="${ANN_SYCL_NLIST:-512}"
    SYCL_NPROBE_LIST="${ANN_SYCL_NPROBE_LIST:-24,28,29,30,31,32,34}"
    SYCL_TARGET_RECALL="${ANN_TARGET_RECALL:-0.95}"
    echo "=== oneAPI/SYCL benchmark ==="
    "${SYCL_CXX}" pthread_sycl_flat.cc -o pthread_sycl_flat ${SYCL_FLAGS}
    ./pthread_sycl_flat --data "${DATA_DIR}" --nq "${NQ}" \
        --baseline-ms "${BASELINE_MS}" --device "${SYCL_DEVICE}" \
        --method "${SYCL_METHOD}" --notes "${SYCL_NOTES}" \
        --algo "${SYCL_ALGO}" --nlist "${SYCL_NLIST}" \
        --nprobe-list "${SYCL_NPROBE_LIST}" --target-recall "${SYCL_TARGET_RECALL}" \
        2>&1 | tee files/results/pthread_sycl.log
fi

echo "DONE"
