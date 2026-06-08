#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

MODE="${1:-quick}"
MODE="${MODE#--}"
if [ "$MODE" != "quick" ] && [ "$MODE" != "full" ] && [ "$MODE" != "best" ]; then
  echo "Usage: $0 [quick|full|best]" >&2
  exit 2
fi

export ANN_DATA="${ANN_DATA:-/anndata}"
if [ "$MODE" = "best" ]; then
  export CSV="${CSV:-files/results/mpi_best_run_arm_kunpeng.csv}"
else
  export CSV="${CSV:-files/results/mpi_results_arm_kunpeng.csv}"
fi

bash ./run_mpi_x86.sh "$MODE"
