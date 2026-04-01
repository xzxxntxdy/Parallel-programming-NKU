#!/usr/bin/env bash
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_MODE=${1:-RelWithDebInfo}
EXE="$ROOT_DIR/build/$BUILD_MODE/bench_cpu_arch"
PERF_BIN=${PERF_BIN:-perf}

cat <<MSG
perf stat example:
$PERF_BIN stat -d "$EXE" --task matvec --algo cache_opt --n 2048 --repeat 30 --warmup 3 --dtype f64 --build-mode $BUILD_MODE

Alternative extreme-kernel perf stat example:
$PERF_BIN stat -d "$EXE" --task matvec --algo extreme --n 2048 --repeat 30 --warmup 3 --dtype f64 --build-mode $BUILD_MODE

perf record example:
$PERF_BIN record -g -- "$EXE" --task sum --algo superscalar --n 100000000 --repeat 20 --warmup 3 --dtype f64 --build-mode $BUILD_MODE

Alternative extreme-kernel perf record example:
$PERF_BIN record -g -- "$EXE" --task sum --algo extreme --n 100000000 --repeat 20 --warmup 3 --dtype f64 --build-mode $BUILD_MODE

perf report example:
$PERF_BIN report
MSG
