#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

TS="${TS:-$(date +%Y%m%d_%H%M%S)}"
ANN_DATA="${ANN_DATA:-/home/${USER}/anndata}"
RESULT_DIR="${RESULT_DIR:-files/results}"
mkdir -p "$RESULT_DIR"

if ! command -v qsub >/dev/null 2>&1; then
  echo "qsub not found; run this script on the ARM/Kunpeng PBS login node." >&2
  exit 1
fi

submit_one() {
  local nodespec="$1"
  local np="$2"
  local threads="$3"
  local label="$4"
  local csv="$RESULT_DIR/mpi_qsub_${label}_${TS}.csv"
  local out="$RESULT_DIR/mpi_qsub_${label}_${TS}.o"
  local err="$RESULT_DIR/mpi_qsub_${label}_${TS}.e"
  qsub -N "ann_${label}" \
    -o "$out" \
    -e "$err" \
    -l "nodes=${nodespec}" \
    -v "NP=${np},THREADS=${threads},CSV=${csv},ANN_DATA=${ANN_DATA}" \
    qsub_mpi.sh
}

JOB_LOG="$RESULT_DIR/mpi_qsub_jobs_${TS}.txt"
{
  echo "timestamp=$TS"
  echo "ANN_DATA=$ANN_DATA"
  echo "These jobs run full-data HNSW nonblocking OpenMP SIMD."
  echo
  echo "node1_p2t4=$(submit_one "1:ppn=8" 2 4 "node1_p2t4")"
  echo "node1_p4t2=$(submit_one "1:ppn=8" 4 2 "node1_p4t2")"
  echo "node2_p4t2=$(submit_one "2:ppn=4" 4 2 "node2_p4t2")"
  echo "node2_p8t1=$(submit_one "2:ppn=8" 8 1 "node2_p8t1")"
} | tee "$JOB_LOG"

echo "Submitted qsub supplement jobs. Track with: qstat"
echo "Job log: $JOB_LOG"
