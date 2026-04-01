# Parallel Programming NKU

This repository contains coursework for the NKU Parallel Programming course.

## Structure

- `hw1/`: CPU architecture programming homework, including source code, CMake build files, benchmark scripts, report sources, and generated figures.

## Quick Start

```bash
cd hw1
./scripts/build.sh RelWithDebInfo
./scripts/test.sh RelWithDebInfo
./scripts/run_bench.sh
```

## Profiling and Report

- VTune-ready binary: `hw1/build/RelWithDebInfo/bench_cpu_arch`
- Report source: `hw1/report/report.tex`
- Report figures: `hw1/report/figures/`
