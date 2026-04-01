#!/usr/bin/env bash
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_MODE=${1:-RelWithDebInfo}
EXE="$ROOT_DIR/build/$BUILD_MODE/bench_cpu_arch"

"$ROOT_DIR/scripts/build.sh" "$BUILD_MODE" >/dev/null

run_case() {
  echo "$*"
  "$EXE" "$@"
}

run_case --task matvec --algo naive --n 64 --repeat 3 --warmup 1 --dtype f32 --build-mode "$BUILD_MODE"
run_case --task matvec --algo cache_opt --n 64 --repeat 3 --warmup 1 --dtype f32 --build-mode "$BUILD_MODE"
run_case --task matvec --algo unroll --n 64 --repeat 3 --warmup 1 --dtype f32 --unroll 4 --build-mode "$BUILD_MODE"
run_case --task matvec --algo extreme --n 64 --repeat 3 --warmup 1 --dtype f32 --build-mode "$BUILD_MODE"
run_case --task matvec --algo naive --n 96 --repeat 3 --warmup 1 --dtype f64 --build-mode "$BUILD_MODE"
run_case --task matvec --algo cache_opt --n 96 --repeat 3 --warmup 1 --dtype f64 --build-mode "$BUILD_MODE"
run_case --task matvec --algo unroll --n 96 --repeat 3 --warmup 1 --dtype f64 --unroll 8 --build-mode "$BUILD_MODE"
run_case --task matvec --algo extreme --n 96 --repeat 3 --warmup 1 --dtype f64 --build-mode "$BUILD_MODE"
run_case --task sum --algo naive --n 100000 --repeat 5 --warmup 2 --dtype f32 --build-mode "$BUILD_MODE"
run_case --task sum --algo superscalar --n 100000 --repeat 5 --warmup 2 --dtype f32 --build-mode "$BUILD_MODE"
run_case --task sum --algo unroll --n 100000 --repeat 5 --warmup 2 --dtype f32 --unroll 8 --build-mode "$BUILD_MODE"
run_case --task sum --algo extreme --n 100000 --repeat 5 --warmup 2 --dtype f32 --build-mode "$BUILD_MODE"
run_case --task sum --algo naive --n 200000 --repeat 5 --warmup 2 --dtype f64 --build-mode "$BUILD_MODE"
run_case --task sum --algo superscalar --n 200000 --repeat 5 --warmup 2 --dtype f64 --build-mode "$BUILD_MODE"
run_case --task sum --algo unroll --n 200000 --repeat 5 --warmup 2 --dtype f64 --unroll 4 --build-mode "$BUILD_MODE"
run_case --task sum --algo extreme --n 200000 --repeat 5 --warmup 2 --dtype f64 --build-mode "$BUILD_MODE"

echo "All correctness checks passed for $BUILD_MODE"
