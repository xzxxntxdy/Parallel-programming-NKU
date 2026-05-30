#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

DATA="${ANN_DATA:-../anndata}"
CSV="${CSV:-files/results/mpi_results_x86_linux.csv}"
MODE="${1:-full}"
mkdir -p "$(dirname "$CSV")"

if ! command -v mpic++ >/dev/null 2>&1; then
  echo "mpic++ not found. Install OpenMPI/MPICH/Intel MPI first." >&2
  exit 1
fi
if ! command -v mpiexec >/dev/null 2>&1 && ! command -v mpirun >/dev/null 2>&1; then
  echo "mpiexec/mpirun not found. Install MPI runtime first." >&2
  exit 1
fi

LAUNCHER="$(command -v mpiexec || command -v mpirun)"
mpic++ -O3 -std=c++17 -fopenmp -march=native -I. -Ihnswlib main.cc -o main

if [ "$MODE" = "quick" ]; then
  NQ=300
  BASES=(10000 25000 50000)
  RANKS=(1 2 4)
  THREADS=(1 2)
  NPROBES=(16 32 64)
  REPEAT=1
  QUICK_FLAG="--quick"
else
  NQ=1000
  BASES=(25000 50000 100000)
  RANKS=(1 2 4 8)
  THREADS=(1 2 4)
  NPROBES=(16 32 64 128 256)
  REPEAT=3
  QUICK_FLAG=""
fi

run_one() {
  local np="$1" method="$2" comm="$3" tm="$4" threads="$5" nbase="$6" nprobe="$7" ef="${8:-64}" kernel="${9:-simd}" extra="${10:-}"
  echo "mpiexec -n $np ./main --method $method --comm $comm --threads $threads --nbase $nbase --nprobe $nprobe --ef $ef"
  "$LAUNCHER" -n "$np" ./main \
    --data "$DATA" --csv "$CSV" --method "$method" --comm "$comm" \
    --thread-model "$tm" --kernel "$kernel" --threads "$threads" --nbase "$nbase" --nq "$NQ" \
    --nlist 512 --nprobe "$nprobe" --ef "$ef" --repeat "$REPEAT" \
    --nodes 1 --ppn "$np" $QUICK_FLAG $extra
}

for nbase in "${BASES[@]}"; do
  for np in "${RANKS[@]}"; do
    run_one "$np" flat blocking stdthread 1 "$nbase" 512
    for nprobe in "${NPROBES[@]}"; do
      run_one "$np" ivf blocking stdthread 1 "$nbase" "$nprobe"
    done
  done
done

for np in "${RANKS[@]}"; do
  for comm in blocking nonblocking p2p onesided; do
    run_one "$np" ivf "$comm" stdthread 1 100000 64
  done
  for threads in "${THREADS[@]}"; do
    run_one "$np" ivf nonblocking openmp "$threads" 100000 64
    run_one "$np" hnsw nonblocking openmp "$threads" 100000 64 64
    run_one "$np" hnsw nonblocking stdthread "$threads" 100000 64 64
  done
  run_one "$np" ivf nonblocking stdthread 1 100000 64 64 simd "--mpi-thread-multiple"
  run_one "$np" flat blocking stdthread 1 100000 512 64 scalar
  run_one "$np" ivf blocking stdthread 1 100000 64 64 scalar
done

for np in 2 4 8; do
  for ef in 32 64 128; do
    run_one "$np" multi-hnsw nonblocking stdthread 1 100000 64 "$ef"
    for nprobe in 16 32 64; do
      run_one "$np" ivf-hnsw nonblocking stdthread 1 100000 "$nprobe" "$ef"
    done
  done
done

echo "MPI results written to $CSV"
