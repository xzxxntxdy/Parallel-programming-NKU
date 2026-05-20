#!/usr/bin/env python3
"""Build a compact profiling summary for the Pthread/OpenMP ANN stage.

The SIMD report used hardware `perf` counters on ARM.  On the local Windows x86
machine we keep a comparable, always-available profiling layer based on the
stage timings already emitted by the benchmark CSVs: LUT/scan/select/rerank and
build time.  If SIMD perf-counter data is present, this script also records the
corresponding counter summary as context.
"""

from __future__ import annotations

import csv
from pathlib import Path


ROOT = Path(__file__).resolve().parent
RESULTS = ROOT / "files" / "results"
SIMD_RESULTS = ROOT / "simd" / "files" / "results"


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def num(row: dict[str, str], key: str, default: float = 0.0) -> float:
    try:
        value = row.get(key, "")
        if value is None or value == "":
            return default
        return float(value)
    except ValueError:
        return default


def best_feasible(rows: list[dict[str, str]]) -> dict[str, str] | None:
    candidates = [
        r for r in rows
        if num(r, "latency_ms") > 0 and num(r, "recall@100") >= 0.95
    ]
    if not candidates:
        return None
    return min(candidates, key=lambda r: num(r, "latency_ms"))


def best_by_experiment(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    out = []
    for exp in sorted({r.get("experiment", "") for r in rows}):
        exp_rows = [r for r in rows if r.get("experiment", "") == exp]
        best = best_feasible(exp_rows)
        if best:
            out.append(best)
    return out


def dominant_stage(row: dict[str, str]) -> tuple[str, float, float]:
    stages = {
        "encode_us": num(row, "encode_us"),
        "lut_us": num(row, "lut_us"),
        "scan_us": num(row, "scan_us"),
        "select_us": num(row, "select_us"),
        "rerank_us": num(row, "rerank_us"),
    }
    total = sum(stages.values())
    if total <= 0:
        return ("wall_time_only", 0.0, 0.0)
    name, value = max(stages.items(), key=lambda kv: kv[1])
    return (name, value, value / total)


def emit_stage_summary() -> None:
    sources = [
        ("x86_pthread_main", RESULTS / "pthread_results_x86_windows.csv"),
        ("x86_pthread_hnsw", RESULTS / "pthread_hnsw_results_x86_windows.csv"),
        ("x86_openmp_cpu", RESULTS / "pthread_openmp_cpu_results_x86_windows.csv"),
        ("x86_openmp_target", RESULTS / "pthread_openmp_target_device_results_x86_windows.csv"),
        ("x86_sycl_o2", RESULTS / "pthread_sycl_o2_2024_results_x86_windows.csv"),
        ("arm_pthread_main", RESULTS / "pthread_results_arm.csv"),
        ("arm_pthread_hnsw", RESULTS / "pthread_hnsw_results_arm.csv"),
        ("arm_openmp_cpu", RESULTS / "pthread_openmp_cpu_results_arm.csv"),
    ]

    rows_out: list[dict[str, object]] = []
    for source, path in sources:
        rows = read_csv(path)
        if not rows:
            continue
        selected = best_by_experiment(rows)
        global_best = best_feasible(rows)
        if global_best and global_best not in selected:
            selected.append(global_best)
        for r in selected:
            stage, stage_us, stage_ratio = dominant_stage(r)
            rows_out.append({
                "source": source,
                "experiment": r.get("experiment", ""),
                "method": r.get("method", ""),
                "nthreads": r.get("nthreads", ""),
                "param1": r.get("param1", ""),
                "param2": r.get("param2", ""),
                "latency_ms": num(r, "latency_ms"),
                "recall@100": num(r, "recall@100"),
                "speedup": num(r, "speedup"),
                "build_sec": num(r, "build_sec"),
                "encode_us": num(r, "encode_us"),
                "lut_us": num(r, "lut_us"),
                "scan_us": num(r, "scan_us"),
                "select_us": num(r, "select_us"),
                "rerank_us": num(r, "rerank_us"),
                "dominant_stage": stage,
                "dominant_stage_us": stage_us,
                "dominant_stage_ratio": stage_ratio,
                "notes": r.get("notes", ""),
            })

    out_path = RESULTS / "pthread_profile_summary.csv"
    fields = [
        "source", "experiment", "method", "nthreads", "param1", "param2",
        "latency_ms", "recall@100", "speedup", "build_sec",
        "encode_us", "lut_us", "scan_us", "select_us", "rerank_us",
        "dominant_stage", "dominant_stage_us", "dominant_stage_ratio", "notes",
    ]
    with out_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(rows_out)


def emit_simd_perf_context() -> None:
    rows = read_csv(SIMD_RESULTS / "perf_summary.csv")
    out_path = RESULTS / "pthread_profile_simd_perf_context.csv"
    fields = [
        "kernel", "latency_ms", "recall", "cycles_per_query",
        "instructions_per_query", "ipc", "l1_miss_rate", "llc_miss_rate",
        "effective_gops", "effective_bandwidth_gbs",
    ]
    with out_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, "") for k in fields})


def main() -> None:
    RESULTS.mkdir(parents=True, exist_ok=True)
    emit_stage_summary()
    emit_simd_perf_context()
    print(f"Wrote {RESULTS / 'pthread_profile_summary.csv'}")
    print(f"Wrote {RESULTS / 'pthread_profile_simd_perf_context.csv'}")


if __name__ == "__main__":
    main()
