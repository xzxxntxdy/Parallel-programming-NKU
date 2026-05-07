#!/usr/bin/env python3
"""Parse perf stat outputs and produce perf-counter analysis figures."""

from pathlib import Path

import numpy as np
import pandas as pd

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import seaborn as sns


RESULT_DIR = Path("files/results")
FIG_DIR = Path("files/figures")

PERF_FILES = {
    "flat-neon": RESULT_DIR / "perf_flat_neon_2000x3.csv",
    "pq-m16-p2000": RESULT_DIR / "perf_pq_m16_p2000_2000x3.csv",
    "pqsel-m16-p2000": RESULT_DIR / "perf_pqsel_m16_p2000_2000x3.csv",
    "fsadc-m16-p1500-b64": RESULT_DIR / "perf_fsadc_m16_p1500_b64_2000x3.csv",
}


def configure_style():
    sns.set_theme(context="paper", style="whitegrid", palette="colorblind")
    plt.rcParams.update(
        {
            "figure.dpi": 140,
            "savefig.dpi": 300,
            "font.family": "DejaVu Sans",
            "font.size": 9,
            "axes.labelsize": 9,
            "axes.titlesize": 10,
            "legend.fontsize": 8,
            "xtick.labelsize": 8,
            "ytick.labelsize": 8,
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
            "svg.fonttype": "none",
        }
    )


def parse_perf_file(path: Path) -> dict:
    values = {}
    with path.open() as fin:
        for line in fin:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split(",")
            if len(parts) < 3:
                continue
            raw, event = parts[0], parts[2].replace(":u", "")
            if raw == "<not supported>":
                continue
            try:
                values[event] = float(raw)
            except ValueError:
                continue
    return values


def latest_kernel_rows() -> pd.DataFrame:
    path = RESULT_DIR / "kernel_experiments.csv"
    if not path.exists():
        raise SystemExit(f"missing {path}; run ./main --kernel ... first")
    df = pd.read_csv(path)
    df = df.sort_values("timestamp_us")
    return df.groupby("kernel", as_index=False).tail(1)


def ops_bytes(kernel: str):
    n = 100000.0
    d = 96.0
    if kernel.startswith("flat"):
        return n * d * 2.0, n * d * 4.0
    if kernel.startswith(("pq", "pqsel", "fsadc", "fssdc", "sdc")):
        m, p, ks = 16.0, 2000.0, 256.0
        if "-m" in kernel and "-p" in kernel:
            try:
                m = float(kernel.split("-m", 1)[1].split("-p", 1)[0])
                p_part = kernel.split("-p", 1)[1].split("-", 1)[0]
                p = float(p_part)
            except ValueError:
                pass
        ops = n * m + p * d * 2.0 + ks * d * 2.0
        bytes_ = n * m + p * d * 4.0 + m * ks * 4.0
        return ops, bytes_
    raise ValueError(kernel)


def build_summary() -> pd.DataFrame:
    latest = latest_kernel_rows().set_index("kernel")
    rows = []
    for kernel, path in PERF_FILES.items():
        if not path.exists() or kernel not in latest.index:
            continue
        perf = parse_perf_file(path)
        exp = latest.loc[kernel]
        queries = float(exp["Q"]) * float(exp["repeat"])
        cycles = perf.get("cycles", np.nan)
        instructions = perf.get("instructions", np.nan)
        l1_loads = perf.get("L1-dcache-loads", np.nan)
        l1_misses = perf.get("L1-dcache-load-misses", np.nan)
        llc_loads = perf.get("LLC-loads", np.nan)
        llc_misses = perf.get("LLC-load-misses", np.nan)
        ops_q, bytes_q = ops_bytes(kernel)
        latency_s = float(exp["latency_ms_mean"]) / 1000.0
        rows.append(
            {
                "kernel": kernel,
                "Q": exp["Q"],
                "repeat": exp["repeat"],
                "latency_ms": exp["latency_ms_mean"],
                "recall": exp["recall_mean"],
                "cycles": cycles,
                "instructions": instructions,
                "cycles_per_query": cycles / queries,
                "instructions_per_query": instructions / queries,
                "ipc": instructions / cycles,
                "branch_misses_per_query": perf.get("branch-misses", np.nan) / queries,
                "l1_miss_rate": l1_misses / l1_loads,
                "llc_miss_rate": llc_misses / llc_loads,
                "arithmetic_intensity": ops_q / bytes_q,
                "effective_gops": ops_q / latency_s / 1e9,
                "effective_bandwidth_gbs": bytes_q / latency_s / 1e9,
            }
        )
    summary = pd.DataFrame(rows)
    summary.to_csv(RESULT_DIR / "perf_summary.csv", index=False)
    return summary


def savefig(fig, name):
    for ext in ("png", "pdf", "svg"):
        fig.savefig(FIG_DIR / f"{name}.{ext}", bbox_inches="tight")
    plt.close(fig)


def plot_counter_comparison(df: pd.DataFrame):
    plot_df = df.melt(
        id_vars=["kernel"],
        value_vars=["cycles_per_query", "instructions_per_query"],
        var_name="metric",
        value_name="value",
    )
    plot_df["value_million"] = plot_df["value"] / 1e6
    plot_df["metric"] = plot_df["metric"].map(
        {
            "cycles_per_query": "Cycles/query",
            "instructions_per_query": "Instructions/query",
        }
    )
    fig, ax = plt.subplots(figsize=(5.2, 3.1))
    sns.barplot(data=plot_df, x="kernel", y="value_million", hue="metric", ax=ax)
    ax.set_xlabel("")
    ax.set_ylabel("Million events per query")
    ax.tick_params(axis="x", rotation=15)
    ax.legend(frameon=False, title=None)
    sns.despine(ax=ax)
    savefig(fig, "fig_perf_counter_comparison")


def plot_cache_behavior(df: pd.DataFrame):
    plot_df = df.melt(
        id_vars=["kernel"],
        value_vars=["l1_miss_rate", "llc_miss_rate"],
        var_name="metric",
        value_name="miss_rate",
    )
    plot_df["metric"] = plot_df["metric"].map(
        {
            "l1_miss_rate": "L1D miss rate",
            "llc_miss_rate": "LLC miss rate",
        }
    )
    fig, ax = plt.subplots(figsize=(5.2, 3.1))
    sns.barplot(data=plot_df, x="kernel", y="miss_rate", hue="metric", ax=ax)
    ax.set_xlabel("")
    ax.set_ylabel("Miss rate")
    ax.tick_params(axis="x", rotation=15)
    ax.legend(frameon=False, title=None)
    sns.despine(ax=ax)
    savefig(fig, "fig_perf_cache_behavior")


def plot_perf_roofline(df: pd.DataFrame):
    fig, ax = plt.subplots(figsize=(6.5, 3.8))
    colors = sns.color_palette("colorblind", n_colors=len(df))
    for idx, (_, row) in enumerate(df.sort_values("cycles_per_query", ascending=False).iterrows(), start=1):
        color = colors[idx - 1]
        size = 45 + 32 * float(row["ipc"])
        ax.scatter(
            row["arithmetic_intensity"],
            row["effective_gops"],
            s=size,
            color=color,
            edgecolor="white",
            linewidth=0.55,
            zorder=3,
        )
    xs = np.logspace(np.log10(df["arithmetic_intensity"].min() * 0.8), np.log10(df["arithmetic_intensity"].max() * 1.3), 100)
    for bw in (10, 20, 40):
        ax.plot(xs, xs * bw, linestyle="--", color="0.45", linewidth=0.75)
    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("Estimated arithmetic intensity (ops/byte)")
    ax.set_ylabel("Effective throughput (GOPS)")
    table_df = df.sort_values("cycles_per_query", ascending=False)[
        ["kernel", "ipc", "cycles_per_query", "llc_miss_rate", "effective_gops"]
    ].copy()
    table_df["cycles_per_query"] = table_df["cycles_per_query"] / 1e6
    table_text = "Kernel summary\n" + "\n".join(
        f"[{i}] {r.kernel}: IPC {r.ipc:.2f}, cyc/q {r.cycles_per_query:.1f}M, "
        f"GOPS {r.effective_gops:.2f}, LLC {100*r.llc_miss_rate:.1f}%"
        for i, r in enumerate(table_df.itertuples(), start=1)
    )
    ax.text(
        1.02,
        0.98,
        table_text,
        transform=ax.transAxes,
        ha="left",
        va="top",
        fontsize=7,
        bbox={"boxstyle": "round,pad=0.28", "facecolor": "white", "edgecolor": "0.82", "linewidth": 0.6},
    )
    ax.text(
        0.02,
        0.98,
        "Dashed guide lines: 10 / 20 / 40 GB/s",
        transform=ax.transAxes,
        ha="left",
        va="top",
        fontsize=7,
        color="0.35",
    )
    sns.despine(ax=ax)
    savefig(fig, "fig_perf_roofline")


def main():
    configure_style()
    FIG_DIR.mkdir(parents=True, exist_ok=True)
    summary = build_summary()
    plot_counter_comparison(summary)
    plot_cache_behavior(summary)
    plot_perf_roofline(summary)
    print(f"wrote {RESULT_DIR / 'perf_summary.csv'}")
    print("wrote perf counter figures")


if __name__ == "__main__":
    main()
