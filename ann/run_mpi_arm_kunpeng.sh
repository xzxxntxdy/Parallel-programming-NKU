#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

MODE="quick"
if [ "${1:-}" = "--full" ] || [ "${1:-}" = "full" ]; then
  MODE="full"
fi

export ANN_DATA="${ANN_DATA:-/anndata}"
export CSV="${CSV:-files/results/mpi_results_arm_kunpeng.csv}"

bash ./run_mpi_x86.sh "$MODE"
