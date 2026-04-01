#!/usr/bin/env bash
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
MODES=${*:-"Debug RelWithDebInfo Release"}
DTYPE=${DTYPE:-f64}
MATVEC_SIZES=${MATVEC_SIZES:-"256 512 1024 1536"}
SUM_SIZES=${SUM_SIZES:-"1000000 5000000 20000000"}
MATVEC_REPEAT=${MATVEC_REPEAT:-8}
SUM_REPEAT=${SUM_REPEAT:-20}
WARMUP=${WARMUP:-2}

CSV_HEADER='task,algo,n,repeat,warmup,dtype,unroll,build_mode,check,prep_ms,total_ms,avg_ms,min_ms,checksum,reference,max_abs_err,max_rel_err'

for mode in $MODES; do
  OUT_DIR="$ROOT_DIR/build/$mode"
  EXE="$OUT_DIR/bench_cpu_arch"
  CSV_FILE="$OUT_DIR/bench_results.csv"

  "$ROOT_DIR/scripts/build.sh" "$mode"
  printf '%s\n' "$CSV_HEADER" > "$CSV_FILE"

  for n in $MATVEC_SIZES; do
    for algo in naive cache_opt unroll extreme; do
      "$EXE" --task matvec --algo "$algo" --n "$n" --repeat "$MATVEC_REPEAT" --warmup "$WARMUP" --dtype "$DTYPE" --unroll 4 --build-mode "$mode" --csv >> "$CSV_FILE"
    done
  done

  for n in $SUM_SIZES; do
    for algo in naive superscalar unroll extreme; do
      "$EXE" --task sum --algo "$algo" --n "$n" --repeat "$SUM_REPEAT" --warmup "$WARMUP" --dtype "$DTYPE" --unroll 4 --build-mode "$mode" --csv >> "$CSV_FILE"
    done
  done

  echo "Wrote $CSV_FILE"
done
