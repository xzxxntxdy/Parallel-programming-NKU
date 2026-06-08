import os

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


RESULT_CSV = os.path.join("files", "results", "gpu_results_x86_cuda.csv")
OUT_DIR = os.path.join("files", "figures", "gpu_report")


METHOD_LABELS = {
    "cpu_flat": "CPU exact scan",
    "cuda_flat_naive": "CUDA naive",
    "cuda_flat_tiled": "CUDA tiled",
    "cuda_flat_cublas": "cuBLAS SGEMM",
    "cuda_ivf": "CUDA IVF compact",
    "cuda_ivf_cluster": "IVF cluster baseline",
    "cuda_ivf_cluster_grouped": "IVF grouped",
}


METHOD_COLORS = {
    "cpu_flat": "#4D4D4D",
    "cuda_flat_naive": "#D55E00",
    "cuda_flat_tiled": "#0072B2",
    "cuda_flat_cublas": "#009E73",
    "cuda_ivf": "#CC79A7",
    "cuda_ivf_cluster": "#E69F00",
    "cuda_ivf_cluster_grouped": "#56B4E9",
}


def load_results():
    df = pd.read_csv(RESULT_CSV)
    numeric_cols = [
        "nbase",
        "nq",
        "dim",
        "k",
        "batch",
        "nlist",
        "nprobe",
        "iters",
        "repeat",
        "build_ms",
        "candidate_ms",
        "compute_ms",
        "topk_ms",
        "total_ms",
        "latency_ms",
        "recall@100",
        "avg_candidates",
        "scored_pairs",
        "waste_ratio",
    ]
    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors="coerce")
    keys = ["method", "nbase", "nq", "batch", "nlist", "nprobe", "iters"]
    df = df.sort_values("latency_ms").drop_duplicates(keys, keep="first")
    return df


def style_axes(ax):
    ax.grid(True, which="major", color="#D9D9D9", linewidth=0.7, alpha=0.9)
    ax.grid(True, which="minor", color="#EEEEEE", linewidth=0.45, alpha=0.8)
    ax.set_axisbelow(True)
    for spine in ["top", "right"]:
        ax.spines[spine].set_visible(False)
    ax.spines["left"].set_color("#666666")
    ax.spines["bottom"].set_color("#666666")


def savefig(name):
    os.makedirs(OUT_DIR, exist_ok=True)
    for ext in ["pdf", "png"]:
        plt.savefig(os.path.join(OUT_DIR, f"{name}.{ext}"), bbox_inches="tight", dpi=300)
    plt.close()


def fig_frontier(df):
    full = df[(df["nbase"] == 100000) & (df["nq"] == 1000)].copy()
    fig, ax = plt.subplots(figsize=(6.2, 4.0))
    for method, g in full.groupby("method"):
        ax.scatter(
            g["latency_ms"],
            g["recall@100"],
            s=np.clip(g["avg_candidates"] / 180.0, 28, 360),
            color=METHOD_COLORS.get(method, "#333333"),
            edgecolor="white",
            linewidth=0.8,
            alpha=0.85,
            label=METHOD_LABELS.get(method, method),
        )
    feasible = full[full["recall@100"] >= 0.95].sort_values("latency_ms")
    best = feasible.iloc[0]
    ax.scatter(
        [best["latency_ms"]],
        [best["recall@100"]],
        marker="*",
        s=260,
        color="#111111",
        edgecolor="white",
        linewidth=0.8,
        zorder=5,
    )
    ax.annotate(
        f"best: {best['latency_ms']:.3f} ms, R={best['recall@100']:.3f}",
        xy=(best["latency_ms"], best["recall@100"]),
        xytext=(best["latency_ms"] + 0.035, best["recall@100"] - 0.025),
        arrowprops=dict(arrowstyle="-|>", color="#555555", lw=0.8),
        fontsize=8.5,
    )
    ax.axhline(0.95, color="#666666", linestyle="--", linewidth=1.0)
    ax.set_xlabel("Latency (ms/query)")
    ax.set_ylabel("Recall@100")
    ax.set_xlim(left=0.06)
    ax.set_ylim(0.88, 1.008)
    style_axes(ax)
    ax.legend(frameon=False, fontsize=8, loc="lower right")
    savefig("fig_gpu_01_frontier")


def fig_ivf_nprobe(df):
    g = df[
        (df["method"] == "cuda_ivf")
        & (df["nbase"] == 100000)
        & (df["nq"] == 1000)
        & (df["batch"] == 128)
    ].sort_values("nprobe")
    fig, ax1 = plt.subplots(figsize=(6.2, 3.6))
    ax2 = ax1.twinx()
    ax1.plot(g["nprobe"], g["latency_ms"], marker="o", color="#CC79A7", lw=2.0, label="Latency")
    ax2.plot(g["nprobe"], g["recall@100"], marker="s", color="#0072B2", lw=2.0, label="Recall@100")
    ax2.axhline(0.95, color="#666666", linestyle="--", linewidth=1.0)
    ax1.set_xlabel("nprobe")
    ax1.set_ylabel("Latency (ms/query)", color="#8B2E69")
    ax2.set_ylabel("Recall@100", color="#005A8C")
    ax1.tick_params(axis="y", colors="#8B2E69")
    ax2.tick_params(axis="y", colors="#005A8C")
    ax1.set_ylim(bottom=0.07)
    ax2.set_ylim(0.89, 1.005)
    style_axes(ax1)
    ax2.spines["top"].set_visible(False)
    ax2.spines["right"].set_color("#666666")
    lines = [line for line in ax1.get_lines() + ax2.get_lines() if not line.get_label().startswith("_")]
    ax1.legend(lines, [line.get_label() for line in lines], frameon=False, loc="lower right", fontsize=8)
    savefig("fig_gpu_02_ivf_nprobe")


def fig_batch(df):
    fig, ax = plt.subplots(figsize=(6.2, 3.6))
    curves = [
        ("cuda_flat_tiled", 32, "CUDA tiled exact"),
        ("cuda_flat_cublas", 32, "cuBLAS exact"),
        ("cuda_ivf", 20, "IVF compact nprobe=20"),
    ]
    for method, nprobe, label in curves:
        g = df[
            (df["method"] == method)
            & (df["nbase"] == 100000)
            & (df["nq"] == 1000)
            & (df["nprobe"] == nprobe)
        ].sort_values("batch")
        ax.plot(
            g["batch"],
            g["latency_ms"],
            marker="o",
            lw=2.0,
            color=METHOD_COLORS.get(method, "#333333"),
            label=label,
        )
    ax.set_xscale("log", base=2)
    ax.set_xticks([16, 32, 64, 128, 256])
    ax.get_xaxis().set_major_formatter(plt.ScalarFormatter())
    ax.set_xlabel("Batch size")
    ax.set_ylabel("Latency (ms/query)")
    style_axes(ax)
    ax.legend(frameon=False, fontsize=8, loc="upper right")
    savefig("fig_gpu_03_batch")


def pick_row(df, method, nprobe=None, batch=None, nq=None):
    g = df[df["method"] == method]
    if nprobe is not None:
        g = g[g["nprobe"] == nprobe]
    if batch is not None:
        g = g[g["batch"] == batch]
    if nq is not None:
        g = g[g["nq"] == nq]
    return g.sort_values("latency_ms").iloc[0]


def fig_breakdown(df):
    rows = [
        pick_row(df, "cpu_flat"),
        pick_row(df, "cuda_flat_naive", batch=32),
        pick_row(df, "cuda_flat_tiled", batch=128),
        pick_row(df, "cuda_flat_cublas", batch=128),
        pick_row(df, "cuda_ivf", nprobe=20, batch=32, nq=1000),
        pick_row(df, "cuda_ivf_cluster", nprobe=22),
        pick_row(df, "cuda_ivf_cluster_grouped", nprobe=22),
    ]
    labels = [
        "CPU exact",
        "Naive",
        "Tiled",
        "cuBLAS",
        "IVF compact",
        "Cluster",
        "Grouped",
    ]
    compute = np.array([r["compute_ms"] / r["nq"] for _, r in enumerate(rows)])
    candidate = np.array([r["candidate_ms"] / r["nq"] for _, r in enumerate(rows)])
    topk = np.array([r["topk_ms"] / r["nq"] for _, r in enumerate(rows)])
    total = np.array([r["total_ms"] / r["nq"] for _, r in enumerate(rows)])
    other = np.maximum(total - compute - candidate - topk, 0.0)

    fig, ax = plt.subplots(figsize=(6.6, 3.8))
    x = np.arange(len(rows))
    width = 0.68
    ax.bar(x, compute, width, color="#0072B2", label="GPU/CPU distance")
    ax.bar(x, candidate, width, bottom=compute, color="#E69F00", label="IVF routing")
    ax.bar(x, topk, width, bottom=compute + candidate, color="#009E73", label="Top-k")
    ax.bar(x, other, width, bottom=compute + candidate + topk, color="#999999", label="Transfer/other")
    ax.set_xticks(x)
    ax.set_xticklabels(labels, rotation=22, ha="right")
    ax.set_ylabel("Latency component (ms/query)")
    style_axes(ax)
    ax.legend(frameon=False, fontsize=8, ncol=2, loc="upper right")
    savefig("fig_gpu_04_breakdown")


def fig_waste(df):
    probes = [16, 22, 32]
    methods = ["cuda_ivf", "cuda_ivf_cluster", "cuda_ivf_cluster_grouped"]
    width = 0.24
    fig, ax = plt.subplots(figsize=(6.2, 3.5))
    x = np.arange(len(probes))
    for i, method in enumerate(methods):
        vals = []
        for p in probes:
            g = df[(df["method"] == method) & (df["nprobe"] == p)].sort_values("latency_ms")
            vals.append(g.iloc[0]["waste_ratio"] if not g.empty else np.nan)
        ax.bar(
            x + (i - 1) * width,
            vals,
            width,
            color=METHOD_COLORS[method],
            label=METHOD_LABELS[method],
        )
    ax.set_xticks(x)
    ax.set_xticklabels([str(p) for p in probes])
    ax.set_xlabel("nprobe")
    ax.set_ylabel("Distance evaluations / useful candidates")
    style_axes(ax)
    ax.legend(frameon=False, fontsize=8, loc="upper right")
    savefig("fig_gpu_05_waste")


def main():
    plt.rcParams.update(
        {
            "font.family": "DejaVu Sans",
            "font.size": 9.5,
            "axes.titlesize": 10.5,
            "axes.labelsize": 9.5,
            "legend.fontsize": 8,
            "xtick.labelsize": 8.5,
            "ytick.labelsize": 8.5,
            "figure.facecolor": "white",
            "axes.facecolor": "white",
        }
    )
    df = load_results()
    fig_frontier(df)
    fig_ivf_nprobe(df)
    fig_batch(df)
    fig_breakdown(df)
    fig_waste(df)


if __name__ == "__main__":
    main()
