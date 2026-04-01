#!/usr/bin/env bash
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_MODE=${1:-RelWithDebInfo}
BUILD_DIR="$ROOT_DIR/build/$BUILD_MODE"
GENERATOR=${CMAKE_GENERATOR:-Unix Makefiles}
JOBS=${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)}

case "$BUILD_MODE" in
  Debug|Release|RelWithDebInfo) ;;
  *)
    echo "Unsupported build mode: $BUILD_MODE" >&2
    exit 1
    ;;
esac

cmake -S "$ROOT_DIR" -B "$BUILD_DIR" -G "$GENERATOR" -DCMAKE_BUILD_TYPE="$BUILD_MODE"
cmake --build "$BUILD_DIR" -- -j"$JOBS"

echo "Built $BUILD_DIR/bench_cpu_arch"
