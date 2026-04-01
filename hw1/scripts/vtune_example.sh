#!/usr/bin/env bash
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_MODE=${1:-RelWithDebInfo}
EXE="$ROOT_DIR/build/$BUILD_MODE/bench_cpu_arch"
RESULT_DIR="$ROOT_DIR/build/$BUILD_MODE/vtune_hotspots_matvec"

cat <<MSG
VTune CLI template for the Linux target:

vtune -collect hotspots \
  -result-dir "$RESULT_DIR" \
  -- "$EXE" --task matvec --algo cache_opt --n 2048 --repeat 50 --warmup 3 --dtype f64 --build-mode $BUILD_MODE

Alternative extreme-kernel VTune run:

vtune -collect hotspots \
  -result-dir "$ROOT_DIR/build/$BUILD_MODE/vtune_hotspots_matvec_extreme" \
  -- "$EXE" --task matvec --algo extreme --n 2048 --repeat 50 --warmup 3 --dtype f64 --build-mode $BUILD_MODE

VTune CLI template for the sum kernel:

vtune -collect hotspots \
  -result-dir "$ROOT_DIR/build/$BUILD_MODE/vtune_hotspots_sum" \
  -- "$EXE" --task sum --algo superscalar --n 100000000 --repeat 30 --warmup 3 --dtype f64 --build-mode $BUILD_MODE

Alternative extreme-kernel VTune run:

vtune -collect hotspots \
  -result-dir "$ROOT_DIR/build/$BUILD_MODE/vtune_hotspots_sum_extreme" \
  -- "$EXE" --task sum --algo extreme --n 100000000 --repeat 30 --warmup 3 --dtype f64 --build-mode $BUILD_MODE

If you are profiling a container on a Linux host, run the container with ptrace support such as:
  docker run --cap-add=SYS_PTRACE -it <image>
MSG
