#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

TS="${TS:-$(date +%Y%m%d_%H%M%S)}"
export ANN_DATA="${ANN_DATA:-/anndata}"
RESULT_DIR="${RESULT_DIR:-files/results}"
mkdir -p "$RESULT_DIR"

ENV_FILE="$RESULT_DIR/mpi_arm_env_${TS}.txt"
{
  echo "timestamp=$(date -Iseconds)"
  echo "hostname=$(hostname)"
  echo "pwd=$(pwd)"
  echo "ANN_DATA=$ANN_DATA"
  echo "mpicxx=$(command -v mpic++ || true)"
  echo "mpiexec=$(command -v mpiexec || command -v mpirun || true)"
  echo
  echo "===== lscpu ====="
  lscpu || true
  echo
  echo "===== mpic++ --version ====="
  mpic++ --version || true
  echo
  echo "===== MPI launcher version ====="
  (mpiexec --version || mpirun --version || true) 2>&1
} > "$ENV_FILE"

echo "[1/4] ARM quick sweep"
ANN_DATA="$ANN_DATA" CSV="$RESULT_DIR/mpi_results_arm_quick_${TS}.csv" \
  bash run_mpi_arm_kunpeng.sh --quick

echo "[2/4] ARM full-data best run"
ANN_DATA="$ANN_DATA" CSV="$RESULT_DIR/mpi_best_run_arm_${TS}.csv" \
  bash run_mpi_arm_kunpeng.sh --best

if [ "${RUN_FULL_SWEEP:-0}" = "1" ]; then
  echo "[3/4] ARM optional full sweep"
  ANN_DATA="$ANN_DATA" CSV="$RESULT_DIR/mpi_results_arm_full_${TS}.csv" \
    bash run_mpi_arm_kunpeng.sh --full
else
  echo "[3/4] Skip ARM full sweep; quick is used for screening and full-data best is used for final validation."
fi

echo "[4/4] ARM perf profiling for best run"
if command -v perf >/dev/null 2>&1; then
  LAUNCHER="$(command -v mpiexec || command -v mpirun)"
  if [ ! -x ./main ]; then
    mpic++ -O3 -std=c++17 -fopenmp -march=native -I. -Ihnswlib main.cc -o main
  fi
  perf stat -e cycles,instructions,cache-references,cache-misses \
    -o "$RESULT_DIR/mpi_perf_arm_best_${TS}.txt" \
    "$LAUNCHER" -n 2 ./main \
      --data "$ANN_DATA" \
      --csv "$RESULT_DIR/mpi_perf_arm_best_${TS}.csv" \
      --method hnsw \
      --comm nonblocking \
      --thread-model openmp \
      --kernel simd \
      --threads 4 \
      --nbase 100000 \
      --nq 1000 \
      --nlist 512 \
      --nprobe 64 \
      --ef 64 \
      --repeat 3 \
      --nodes 1 \
      --ppn 8
else
  echo "perf not found; skip perf profiling." | tee "$RESULT_DIR/mpi_perf_arm_best_${TS}.txt"
fi

cat > "$RESULT_DIR/mpi_arm_complete_${TS}.txt" <<EOF
ARM MPI supplement finished.
timestamp=$TS
env=$ENV_FILE
quick=$RESULT_DIR/mpi_results_arm_quick_${TS}.csv
best=$RESULT_DIR/mpi_best_run_arm_${TS}.csv
full=$RESULT_DIR/mpi_results_arm_full_${TS}.csv
full_sweep_run=${RUN_FULL_SWEEP:-0}
perf_csv=$RESULT_DIR/mpi_perf_arm_best_${TS}.csv
perf_stat=$RESULT_DIR/mpi_perf_arm_best_${TS}.txt
EOF

echo "ARM MPI supplement finished. Summary: $RESULT_DIR/mpi_arm_complete_${TS}.txt"
