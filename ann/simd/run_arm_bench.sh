#!/bin/bash
# ARM Kunpeng-920 ANN SIMD Benchmark — one-shot script
# Usage: bash run_arm_bench.sh
set -e

cd "$(dirname "$0")"
OUT=files/results
mkdir -p "$OUT"

echo "=== [1/5] Compile ==="
g++ main.cc -o main -O2 -fopenmp -lpthread -std=c++11
echo "OK"

echo "=== [2/5] test.sh ==="
bash test.sh 1 1 2>&1 | tee "$OUT/test_output.txt"
echo "OK"

echo "=== [3/5] Kernel Benchmarks ==="
KERNELS=(
  # Flat baseline
  "flat-neon 2000 3"
  "flat-unroll4 2000 3"
  "flat-fixed 2000 3"
  # PQ-ADC naive (comparison baseline)
  "pqsel-m16-p500 2000 3"
  "pqsel-m16-p1000 2000 3"
  "pqsel-m16-p2000 2000 3"
  "pqsel-m8-p2000 2000 3"
  "pqsel-m12-p2000 2000 3"
  # PQ-SDC
  "sdc-m16-p1000 200 1"
  "sdc-m16-p2000 200 1"
  "sdc-m8-p2000 200 1"
  "sdc-m12-p2000 200 1"
  # FastScan (block size sweep — key comparison)
  "fsadc-m16-p500-b16 2000 3"
  "fsadc-m16-p500-b32 2000 3"
  "fsadc-m16-p500-b64 2000 3"
  "fsadc-m16-p500-b128 2000 3"
  "fsadc-m16-p1000-b16 2000 3"
  "fsadc-m16-p1000-b64 2000 3"
  "fsadc-m16-p1000-b128 2000 3"
  "fsadc-m16-p1500-b32 2000 3"
  "fsadc-m16-p1500-b64 2000 3"
  "fsadc-m16-p1500-b128 2000 3"
  # SQ8
  "sq8-p1000 2000 3"
  "sq8-p2000 2000 3"
  "sq8-p5000 2000 3"
)

for args in "${KERNELS[@]}"; do
  echo "  kernel: $args"
  ./main --kernel $args 2>&1 | tail -1
done
echo "OK"

echo "=== [4/5] Perf Analysis ==="
PERF_EVENTS=cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses

perf stat -x, -e $PERF_EVENTS -o "$OUT/perf_flat_neon.csv"      ./main --kernel flat-neon 2000 3 2>&1 | tail -1
perf stat -x, -e $PERF_EVENTS -o "$OUT/perf_pq_adc.csv"         ./main --kernel pqsel-m16-p2000 2000 3 2>&1 | tail -1
perf stat -x, -e $PERF_EVENTS -o "$OUT/perf_fastscan_old.csv"   ./main --kernel fsadc-m16-p1500-b64 2000 3 2>&1 | tail -1
echo "OK"

echo "=== [5/5] Collect Results ==="
echo "Output files:"
ls -lh "$OUT"/simd_results.csv      2>/dev/null || echo "  (simd_results.csv from test.sh)"
ls -lh "$OUT"/kernel_experiments.csv 2>/dev/null || echo "  (kernel_experiments.csv from kernels)"
ls -lh "$OUT"/perf_*.csv            2>/dev/null
echo ""
echo "=== DONE ==="
echo "Copy results back with:"
echo "  scp s2412235@master_ubss1:~/Parallel-programming-NKU/ann/files/results/simd_results.csv ./files/results/"
echo "  scp s2412235@master_ubss1:~/Parallel-programming-NKU/ann/files/results/kernel_experiments.csv ./files/results/"
echo "  scp s2412235@master_ubss1:~/Parallel-programming-NKU/ann/files/results/perf_*.csv ./files/results/"
