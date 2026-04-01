#!/usr/bin/env bash
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_MODE=${1:-RelWithDebInfo}
shift || true
OUT_DIR="$ROOT_DIR/build/$BUILD_MODE"
EXE="$OUT_DIR/bench_cpu_arch"

"$ROOT_DIR/scripts/build.sh" "$BUILD_MODE" >/dev/null

if [ "$#" -eq 0 ]; then
  objdump -d -S --no-show-raw-insn "$EXE" > "$OUT_DIR/bench_cpu_arch.objdump.S"
  echo "Wrote $OUT_DIR/bench_cpu_arch.objdump.S"
  exit 0
fi

for func in "$@"; do
  objdump -d -S --no-show-raw-insn --disassemble="$func" "$EXE" > "$OUT_DIR/$func.objdump.S"
  echo "Wrote $OUT_DIR/$func.objdump.S"
done
