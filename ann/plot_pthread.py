#!/usr/bin/env python3
"""Standalone figures for the pthread ANN benchmark.

The report should not carry every sweep as a figure.  This script keeps only
two standalone high-signal plots:

1. The global recall-latency frontier under the recall@100 constraint.
2. Thread scaling for the best representative configuration in each family.
"""

from __future__ import annotations

from pathlib import Path
import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parent
CSV = ROOT / "files" / "results" / "pthread_results.csv"
HNSW_CSV = ROOT / "files" / "results" / "pthread_hnsw_results.csv"
BEST_CSV = ROOT / "files" / "results" / "pthread_best.csv"
FINAL_CSV = ROOT / "files" / "results" / "pthread_final.csv"
FIG_DIR = ROOT / "files" / "figures"
FIG_DIR.mkdir(parents=True, exist_ok=True)

RECALL_COL = "recall@100"
TARGET_RECALL = 0.95
OUT_PREFIX = "fig_pthread_"

FAMILY_ORDER = ["Flat", "SQ8", "PQ", "FastScan", "IVF", "IVF-PQ", "HNSW"]
FAMILY_COLORS = {
    "Flat": "#2563EB",
    "SQ8": "#0F766E",
    "PQ": "#059669",
    "FastScan": "#D97706",
    "IVF": "#7C3AED",
    "IVF-PQ": "#9333EA",
    "HNSW": "#DC2626",
}
FAMILY_MARKERS = {
    "Flat": "o",
    "SQ8": "P",
    "PQ": "s",
    "FastScan": "D",
    "IVF": "^",
    "IVF-PQ": "v",
    "HNSW": "X",
}

plt.rcParams.update(
    {
        "font.family": "DejaVu Sans",
        "font.size": 9.5,
        "axes.titlesize": 11,
        "axes.labelsize": 9.5,
        "axes.linewidth": 0.8,
        "axes.edgecolor": "#334155",
        "xtick.labelsize": 8.5,
        "ytick.labelsize": 8.5,
        "legend.fontsize": 8,
        "figure.dpi": 180,
        "savefig.dpi": 320,
        "savefig.bbox": "tight",
        "savefig.pad_inches": 0.04,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
    }
)


def load_results() -> pd.DataFrame:
    if not CSV.exists():
        raise FileNotFoundError(f"Missing benchmark CSV: {CSV}")
    frames = [pd.read_csv(CSV)]
    if HNSW_CSV.exists():
        frames.append(pd.read_csv(HNSW_CSV))
    df = pd.concat(frames, ignore_index=True)
    required = {
        "experiment",
        "method",
        "nthreads",
        "param1",
        "param2",
        "latency_ms",
        RECALL_COL,
        "speedup",
    }
    missing = required.difference(df.columns)
    if missing:
        raise ValueError(f"Missing required columns: {sorted(missing)}")

    numeric_cols = [
        "nthreads",
        "param2",
        "latency_ms",
        RECALL_COL,
        "speedup",
        "index_mb",
        "build_sec",
        "encode_us",
        "lut_us",
        "scan_us",
        "select_us",
        "rerank_us",
    ]
    for col in numeric_cols:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
    df = df.dropna(subset=["experiment", "method", "nthreads", "param2", "latency_ms"])
    df["nthreads"] = df["nthreads"].astype(int)
    df["param2"] = df["param2"].astype(int)
    df["family"] = df.apply(classify_family, axis=1)
    df["config"] = df.apply(config_label, axis=1)
    return df


def classify_family(row: pd.Series) -> str:
    exp = str(row["experiment"])
    if exp.startswith("Flat"):
        return "Flat"
    if exp == "SQ8":
        return "SQ8"
    if exp == "FastScan" or exp == "Scaling":
        return "FastScan"
    if exp == "IVF-PQ":
        return "IVF-PQ"
    if exp == "IVF-HNSW":
        return "HNSW"
    if exp.startswith("IVF"):
        return "IVF"
    if exp.startswith("HNSW"):
        return "HNSW"
    return "PQ"


def config_label(row: pd.Series) -> str:
    exp = str(row["experiment"])
    method = str(row["method"])
    param1 = str(row["param1"])
    param2 = int(row["param2"])
    if exp.startswith("Flat"):
        return method if param1 == "method" else f"{method}, {param1}={param2}"
    if exp == "SQ8":
        return f"SQ8, p={param2}"
    if exp == "PQ-M":
        return f"PQ-{method}, p={param2}"
    if exp == "PQ-SDC":
        return f"SDC-{method}, p={param2}"
    if exp == "FastScan":
        return f"FS-{method}, p={param2}"
    if exp == "Scaling":
        return method
    if exp == "SDC-Pipeline":
        return f"{method}, batch={param2}"
    if exp == "IVF":
        return f"IVF-{method}, nprobe={param2}"
    if exp == "IVF-PQ":
        return f"IVF-PQ-{method}, nprobe={param2}"
    if exp == "IVF-HNSW":
        return f"IVF-HNSW, nprobe={param2}"
    if exp == "HNSW-ToolCompare":
        return f"{method}, ef={param2}"
    if exp == "HNSW-IntraQuery":
        return f"{method}, {param1}={param2}"
    if exp == "HNSW":
        return f"HNSW, ef={param2}"
    return f"{method}, {param1}={param2}"


def clean_old_outputs() -> None:
    for path in FIG_DIR.glob(f"{OUT_PREFIX}*.png"):
        path.unlink()
    for path in FIG_DIR.glob(f"{OUT_PREFIX}*.pdf"):
        path.unlink()


def candidate_rows(df: pd.DataFrame) -> pd.DataFrame:
    keep = df[
        (df["latency_ms"] > 0)
        & (df[RECALL_COL] > 0)
        & (df[RECALL_COL] <= 1.000001)
        & (~df["experiment"].str.contains("Breakdown", case=False, na=False))
    ].copy()
    return keep.reset_index(drop=True)


def constrained_best(df: pd.DataFrame, target: float = TARGET_RECALL) -> pd.Series:
    ok = candidate_rows(df)
    ok = ok[ok[RECALL_COL] >= target]
    if ok.empty:
        raise ValueError(f"No candidate satisfies recall@100 >= {target}")
    return ok.sort_values(["latency_ms", RECALL_COL], ascending=[True, False]).iloc[0]


def best_by_family(df: pd.DataFrame, target: float = TARGET_RECALL) -> pd.DataFrame:
    rows = []
    cand = candidate_rows(df)
    for family in FAMILY_ORDER:
        sub = cand[(cand["family"] == family) & (cand[RECALL_COL] >= target)]
        if sub.empty:
            continue
        rows.append(sub.sort_values(["latency_ms", RECALL_COL], ascending=[True, False]).iloc[0])
    if not rows:
        return cand.iloc[:0].copy()
    return pd.DataFrame(rows).reset_index(drop=True)


def pareto_front(df: pd.DataFrame) -> pd.DataFrame:
    if df.empty:
        return df.copy()
    ordered = df.sort_values(["latency_ms", RECALL_COL], ascending=[True, False])
    rows = []
    best_recall = -np.inf
    for _, row in ordered.iterrows():
        recall = float(row[RECALL_COL])
        if recall > best_recall + 1e-12:
            rows.append(row)
            best_recall = recall
    return pd.DataFrame(rows)


def style_axis(ax: plt.Axes) -> None:
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.grid(True, color="#CBD5E1", linewidth=0.65, alpha=0.75)
    ax.set_axisbelow(True)


def save_figure(fig: plt.Figure, stem: str) -> None:
    for ext in ("png", "pdf"):
        fig.savefig(FIG_DIR / f"{OUT_PREFIX}{stem}.{ext}")
    print(f"saved {OUT_PREFIX}{stem}.png/.pdf")
    plt.close(fig)


def figure_pareto(df: pd.DataFrame, target: float = TARGET_RECALL) -> None:
    cand = candidate_rows(df)
    best = constrained_best(df, target)
    family_best = best_by_family(df, target)
    front = pareto_front(cand)

    fig, ax = plt.subplots(figsize=(7.2, 4.6))
    for family in FAMILY_ORDER:
        sub = cand[cand["family"] == family]
        if sub.empty:
            continue
        ax.scatter(
            sub["latency_ms"],
            sub[RECALL_COL],
            s=26,
            alpha=0.45,
            marker=FAMILY_MARKERS.get(family, "o"),
            color=FAMILY_COLORS.get(family, "#64748B"),
            edgecolor="white",
            linewidth=0.35,
            label=family,
        )

    if not front.empty:
        ax.plot(
            front["latency_ms"],
            front[RECALL_COL],
            color="#111827",
            linewidth=1.25,
            alpha=0.85,
            label="Pareto frontier",
        )

    ax.axhline(target, color="#DC2626", linestyle="--", linewidth=1.0)
    ax.text(
        0.995,
        target + 0.004,
        "recall@100 = 0.95",
        transform=ax.get_yaxis_transform(),
        ha="right",
        va="bottom",
        color="#991B1B",
        fontsize=8.5,
    )

    ax.scatter(
        [best["latency_ms"]],
        [best[RECALL_COL]],
        s=150,
        marker="*",
        color="#FBBF24",
        edgecolor="#111827",
        linewidth=0.7,
        zorder=5,
        label="Selected best",
    )
    ax.annotate(
        f"{best['family']} / {best['config']}\n"
        f"{best['latency_ms']*1000:.1f} us, R={best[RECALL_COL]:.3f}",
        (best["latency_ms"], best[RECALL_COL]),
        xytext=(12, -24),
        textcoords="offset points",
        fontsize=8,
        arrowprops=dict(arrowstyle="-", color="#334155", lw=0.8),
        bbox=dict(boxstyle="round,pad=0.25", fc="white", ec="#CBD5E1", lw=0.6),
    )

    for _, row in family_best.iterrows():
        if row.name == best.name:
            continue
        ax.annotate(
            row["family"],
            (row["latency_ms"], row[RECALL_COL]),
            xytext=(5, 5),
            textcoords="offset points",
            fontsize=7.6,
            color="#334155",
        )

    ax.set_xscale("log")
    ax.set_xlabel("Latency (ms/query, log scale)")
    ax.set_ylabel("Recall@100")
    ax.set_ylim(0.2, 1.02)
    ax.set_title("Recall-Latency Frontier Under the Target Constraint")
    style_axis(ax)
    ax.legend(ncol=4, frameon=False, loc="lower right")
    save_figure(fig, "01_pareto_frontier")


def track_for_row(df: pd.DataFrame, row: pd.Series) -> pd.DataFrame:
    mask = (
        (df["experiment"] == row["experiment"])
        & (df["method"] == row["method"])
        & (df["param1"] == row["param1"])
        & (df["param2"] == row["param2"])
    )
    track = candidate_rows(df[mask]).sort_values("nthreads").copy()
    return track


def representative_tracks(df: pd.DataFrame, target: float = TARGET_RECALL) -> list[pd.DataFrame]:
    tracks: list[pd.DataFrame] = []
    family_best = best_by_family(df, target)
    for family in ["Flat", "SQ8", "PQ", "FastScan", "IVF", "HNSW"]:
        sub = family_best[family_best["family"] == family]
        if sub.empty:
            continue
        track = track_for_row(df, sub.iloc[0])
        if len(track) >= 2:
            tracks.append(track)
    return tracks


def figure_scaling(df: pd.DataFrame, target: float = TARGET_RECALL) -> None:
    tracks = representative_tracks(df, target)
    if not tracks:
        return

    fig, ax = plt.subplots(figsize=(7.2, 4.3))
    for track in tracks:
        first = track.iloc[0]
        family = first["family"]
        label = f"{family}: {first['config']}"
        ax.plot(
            track["nthreads"],
            track["latency_ms"],
            marker=FAMILY_MARKERS.get(family, "o"),
            markersize=5,
            linewidth=1.55,
            color=FAMILY_COLORS.get(family, "#64748B"),
            label=label,
        )

    ax.set_xscale("log", base=2)
    ax.set_yscale("log")
    ax.set_xticks(sorted({int(t) for tr in tracks for t in tr["nthreads"]}))
    ax.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax.set_xlabel("Pthread count")
    ax.set_ylabel("Latency (ms/query, log scale)")
    ax.set_title("Thread Scaling of Representative High-Recall Configurations")
    style_axis(ax)
    ax.legend(frameon=False, loc="best")
    save_figure(fig, "02_thread_scaling")


def main() -> None:
    clean_old_outputs()
    df = load_results()
    print(f"Loaded {len(df)} combined rows from {CSV} and optional {HNSW_CSV.name}")
    best = constrained_best(df, TARGET_RECALL)
    print(
        "Selected best: "
        f"{best['family']} / {best['config']} / threads={int(best['nthreads'])} / "
        f"{best['latency_ms']*1000:.1f} us / recall={best[RECALL_COL]:.4f}"
    )

    figure_pareto(df, TARGET_RECALL)
    figure_scaling(df, TARGET_RECALL)
    print(f"Figures written to {FIG_DIR}")


if __name__ == "__main__":
    main()
