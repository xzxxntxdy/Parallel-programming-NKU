#!/usr/bin/env python3
"""Paper-style figures for the ANN SIMD experiment.

Run with:
    .venv/bin/python plot_simd_paper.py
"""

from pathlib import Path

import numpy as np
import pandas as pd

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import seaborn as sns


CSV_PATH = Path("files/results/simd_results.csv")
RESULT_DIR = Path("files/results")
FIG_DIR = Path("files/figures")


PALETTE = {
    "Flat": "#4C72B0",
    "SQ8-LUT": "#55A868",
    "SQ8-U8SIMD": "#8172B3",
    "PQ-ADC": "#C44E52",
    "PQ-SDC": "#CCB974",
    "FastScan-ADC": "#DD8452",
    "FastScan-SDC": "#64B5CD",
    "SDC-Pipeline": "#937860",
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
            "axes.linewidth": 0.8,
            "grid.linewidth": 0.45,
            "grid.alpha": 0.35,
            "lines.linewidth": 1.5,
            "lines.markersize": 4.5,
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
            "svg.fonttype": "none",
        }
    )


def family(method: str) -> str:
    if method.startswith("FastScan-ADC"):
        return "FastScan-ADC"
    if method.startswith("FastScan-SDC"):
        return "FastScan-SDC"
    if method.startswith("SDC-Pipeline"):
        return "SDC-Pipeline"
    if method.startswith("PQ-SDC"):
        return "PQ-SDC"
    if method.startswith("PQ-ADC"):
        return "PQ-ADC"
    if method.startswith("SQ8-U8SIMD"):
        return "SQ8-U8SIMD"
    if method.startswith("SQ8"):
        return "SQ8-LUT"
    return "Flat"


def short_name(method: str) -> str:
    mapping = {
        "Flat-Scalar-NoVec": "Scalar",
        "Flat-AutoVec": "AutoVec",
        "Flat-Manual-NEON": "NEON",
        "Flat-NEON-AlignedHint": "Aligned hint",
        "Flat-NEON-Unroll2": "Unroll-2",
        "Flat-NEON-Unroll4": "Unroll-4",
        "Flat-NEON-Unroll4-Prefetch": "Prefetch-16",
        "Flat-NEON-Unroll4-Prefetch-FixedTopK": "Fixed Top-k",
    }
    if method.startswith("Flat-NEON-Unroll4-Prefetch-d"):
        return "Prefetch-" + method.rsplit("d", 1)[-1]
    if method.startswith("SQ8-U8SIMD-rerank-p"):
        return "SQ8-U8 p=" + method.rsplit("p", 1)[-1]
    if method.startswith("SQ8-rerank-p"):
        return "SQ8 p=" + method.rsplit("p", 1)[-1]
    if method.startswith("PQ-ADC-Select-M"):
        return method.replace("PQ-ADC-Select-", "Select ").replace("-p", ", p=")
    if method.startswith("PQ-ADC-M"):
        return method.replace("PQ-ADC-", "").replace("-p", ", p=")
    if method.startswith("PQ-SDC-M"):
        return method.replace("PQ-SDC-", "SDC ").replace("-p", ", p=").replace("-coarse", " coarse")
    if method.startswith("FastScan-ADC-M"):
        return method.replace("FastScan-ADC-", "FS-ADC ").replace("-p", ", p=").replace("-b", ", b=")
    if method.startswith("FastScan-SDC-M"):
        return method.replace("FastScan-SDC-", "FS-SDC ").replace("-p", ", p=").replace("-b", ", b=")
    if method.startswith("SDC-Pipeline"):
        return method.replace("SDC-Pipeline", "Pipe-").replace("-p", ", p=").replace("-b", ", b=")
    return mapping.get(method, method)


def append_kernel_experiments(df: pd.DataFrame) -> pd.DataFrame:
    path = RESULT_DIR / "kernel_experiments.csv"
    if not path.exists():
        return df
    kdf = pd.read_csv(path).sort_values("timestamp_us")
    rows = []
    for _, row in kdf.groupby("kernel", as_index=False).tail(1).iterrows():
        kernel = str(row["kernel"])
        if not (kernel.startswith("pqsel-m") or kernel.startswith("fsadc-m")):
            continue
        ppos = kernel.find("-p")
        if kernel.startswith("pqsel-m"):
            m = int(kernel[7:ppos])
            p = int(kernel[ppos + 2 :])
            method = f"PQ-ADC-Select-M{m}-p{p}"
            topk = "nth_element"
        else:
            m = int(kernel.split("-m", 1)[1].split("-p", 1)[0])
            p = int(kernel.split("-p", 1)[1].split("-", 1)[0])
            block = kernel.split("-b", 1)[1] if "-b" in kernel else "32"
            method = f"FastScan-ADC-M{m}-p{p}-b{block}"
            topk = "u8lut-block"
        rows.append(
            {
                "method": method,
                "platform": "ARM-aarch64-NEON",
                "N": 100000,
                "d": 96,
                "Q": int(row["Q"]),
                "k": 10,
                "M": m,
                "Ks": 256,
                "p": p,
                "unroll": 1,
                "prefetch": 0,
                "topk": topk,
                "run_id": 1,
                "latency_ms": float(row["latency_ms_mean"]),
                "recall": float(row["recall_mean"]),
                "index_size_mb": 1.698304 if m == 16 else np.nan,
                "build_time_sec": float(row["build_time_sec"]),
                "coarse_ms": float(row["coarse_ms_mean"]),
                "rerank_ms": float(row["rerank_ms_mean"]),
                "cycles": 0,
                "instructions": 0,
                "cpi": 0,
                "l1_miss_rate": 0,
                "llc_miss_rate": 0,
            }
        )
    if not rows:
        return df
    return pd.concat([df, pd.DataFrame(rows)], ignore_index=True)


def load_data() -> pd.DataFrame:
    if not CSV_PATH.exists():
        raise SystemExit(f"missing {CSV_PATH}; run bash test.sh 1 1 first")
    df = pd.read_csv(CSV_PATH)
    df = append_kernel_experiments(df)
    df["family"] = df["method"].map(family)
    df["label"] = df["method"].map(short_name)
    for col in ["M", "Ks", "p", "unroll", "prefetch"]:
        df[col] = pd.to_numeric(df[col], errors="coerce").fillna(0)
    return df


def summarize(df: pd.DataFrame) -> pd.DataFrame:
    keys = [
        "method",
        "platform",
        "family",
        "label",
        "N",
        "d",
        "Q",
        "k",
        "M",
        "Ks",
        "p",
        "unroll",
        "prefetch",
        "topk",
    ]
    summary = (
        df.groupby(keys, dropna=False)
        .agg(
            latency_mean=("latency_ms", "mean"),
            latency_std=("latency_ms", "std"),
            recall_mean=("recall", "mean"),
            recall_std=("recall", "std"),
            index_size_mb=("index_size_mb", "mean"),
            build_time_sec=("build_time_sec", "mean"),
            coarse_ms=("coarse_ms", "mean"),
            rerank_ms=("rerank_ms", "mean"),
        )
        .reset_index()
    )
    summary[["latency_std", "recall_std"]] = summary[["latency_std", "recall_std"]].fillna(0.0)
    summary = summary.sort_values(["latency_mean", "recall_mean"], ascending=[True, False])
    RESULT_DIR.mkdir(parents=True, exist_ok=True)
    summary.to_csv(RESULT_DIR / "simd_summary.csv", index=False)
    return summary


def savefig(fig: plt.Figure, name: str):
    FIG_DIR.mkdir(parents=True, exist_ok=True)
    for ext in ("png", "pdf", "svg"):
        fig.savefig(FIG_DIR / f"{name}.{ext}", bbox_inches="tight")
    plt.close(fig)


def flat_speedup(summary: pd.DataFrame):
    flat = summary[summary["family"].eq("Flat")].copy()
    order = [
        "Flat-Scalar-NoVec",
        "Flat-AutoVec",
        "Flat-Manual-NEON",
        "Flat-NEON-AlignedHint",
        "Flat-NEON-Unroll2",
        "Flat-NEON-Unroll4",
        "Flat-NEON-Unroll4-Prefetch-d4",
        "Flat-NEON-Unroll4-Prefetch-d8",
        "Flat-NEON-Unroll4-Prefetch-d16",
        "Flat-NEON-Unroll4-Prefetch-d32",
        "Flat-NEON-Unroll4-Prefetch-d64",
        "Flat-NEON-Unroll4-Prefetch-FixedTopK",
    ]
    flat = flat[flat["method"].isin(order)].copy()
    flat["order"] = flat["method"].map({m: i for i, m in enumerate(order)})
    flat = flat.sort_values("order")
    base = flat.loc[flat["method"].eq("Flat-Scalar-NoVec"), "latency_mean"].iloc[0]
    flat["speedup"] = base / flat["latency_mean"]
    flat["speedup_err"] = flat["speedup"] * (flat["latency_std"] / flat["latency_mean"].clip(lower=1e-12))

    flat = flat.sort_values("speedup", ascending=True)
    fig, ax = plt.subplots(figsize=(5.4, 4.2))
    ax.barh(
        flat["label"],
        flat["speedup"],
        xerr=flat["speedup_err"],
        color=PALETTE["Flat"],
        edgecolor="black",
        linewidth=0.35,
        capsize=2,
    )
    ax.axvline(1.0, color="0.25", linestyle="--", linewidth=0.8)
    ax.set_xlabel("Speedup over scalar")
    ax.set_ylabel("")
    ax.set_xlim(0, max(flat["speedup"] + flat["speedup_err"]) * 1.18)
    sns.despine(ax=ax)
    savefig(fig, "fig_flat_speedup")


def latency_recall(summary: pd.DataFrame):
    plot_df = summary.copy()
    fig, ax = plt.subplots(figsize=(5.2, 3.4))
    for fam, group in plot_df.groupby("family"):
        ax.errorbar(
            group["latency_mean"],
            group["recall_mean"],
            xerr=group["latency_std"],
            yerr=group["recall_std"],
            fmt="o",
            label=fam,
            color=PALETTE.get(fam, "0.4"),
            alpha=0.88,
            capsize=2,
            elinewidth=0.7,
            markeredgecolor="white",
            markeredgewidth=0.45,
        )
    ax.set_xscale("log")
    ax.set_xlabel("Latency per query (ms, log scale)")
    ax.set_ylabel("Recall@10")
    ax.set_ylim(-0.03, 1.04)
    ax.legend(frameon=False, ncol=2)
    sns.despine(ax=ax)
    savefig(fig, "fig_latency_recall")


def pareto_frontier(summary: pd.DataFrame):
    kernel_path = RESULT_DIR / "kernel_experiments.csv"
    if kernel_path.exists():
        kdf = pd.read_csv(kernel_path).sort_values("timestamp_us")
        kdf = kdf[kdf["Q"].eq(kdf["Q"].max())]
        if len(kdf) >= 3:
            points = (
                kdf.groupby("kernel", as_index=False)
                .tail(1)
                .rename(columns={"latency_ms_mean": "latency_mean", "recall_mean": "recall_mean"})
            )
            points["family"] = points["kernel"].map(lambda x: "Flat" if str(x).startswith("flat") else "PQ-ADC")

            def kernel_label(name: str) -> str:
                name = str(name)
                if name == "flat-neon":
                    return "Flat-NEON"
                if name.startswith("pqsel-m"):
                    return "PQ-select-M" + name.split("pqsel-m", 1)[1].replace("-p", " p=")
                if name.startswith("pq-m"):
                    return "PQ-M" + name.split("pq-m", 1)[1].replace("-p", " p=")
                return name

            points["label"] = points["kernel"].map(kernel_label)
        else:
            points = summary.copy()
    else:
        points = summary.copy()
    points = points.sort_values(["latency_mean", "recall_mean"], ascending=[True, False]).copy()
    frontier = []
    best = -np.inf
    for _, row in points.iterrows():
        if row["recall_mean"] > best + 1e-12:
            frontier.append(row)
            best = row["recall_mean"]
    frontier = pd.DataFrame(frontier)

    fig, ax = plt.subplots(figsize=(6.2, 3.5))
    sns.scatterplot(
        data=points,
        x="latency_mean",
        y="recall_mean",
        hue="family",
        palette=PALETTE,
        s=34,
        edgecolor="white",
        linewidth=0.45,
        ax=ax,
    )
    ax.plot(
        frontier["latency_mean"],
        frontier["recall_mean"],
        color="black",
        marker="o",
        markersize=3,
        linewidth=1.2,
        label="Pareto frontier",
    )
    front_labels = (
        frontier.sort_values(["recall_mean", "latency_mean"], ascending=[False, True])
        .head(6)
        .sort_values("latency_mean")
    )
    label_text = "Pareto frontier\n" + "\n".join(
        f"{row['label']}: {row['latency_mean']:.2f} ms, R={row['recall_mean']:.5f}"
        for _, row in front_labels.iterrows()
    )
    ax.text(
        1.02,
        0.98,
        label_text,
        transform=ax.transAxes,
        ha="left",
        va="top",
        fontsize=7.2,
        bbox={"boxstyle": "round,pad=0.28", "facecolor": "white", "edgecolor": "0.82", "linewidth": 0.6},
    )
    ax.set_xscale("log")
    ax.set_xlabel("Latency per query (ms, log scale)")
    ax.set_ylabel("Recall@10")
    ax.set_ylim(-0.03, 1.04)
    handles, labels = ax.get_legend_handles_labels()
    keep = [(h, l) for h, l in zip(handles, labels) if l != "Pareto frontier"]
    ax.legend([h for h, _ in keep], [l for _, l in keep], frameon=False, title=None, loc="lower right")
    sns.despine(ax=ax)
    savefig(fig, "fig_pareto_frontier")


def rerank_sensitivity(summary: pd.DataFrame):
    q = summary[summary["family"].isin(["SQ8-LUT", "SQ8-U8SIMD", "PQ-ADC"])].copy()
    q = q[q["p"] > 0]
    q["series"] = np.where(q["family"].eq("PQ-ADC"), "PQ M=" + q["M"].astype(int).astype(str), q["family"])
    fig, ax = plt.subplots(figsize=(5.3, 3.3))
    sns.lineplot(
        data=q.sort_values("p"),
        x="p",
        y="recall_mean",
        hue="series",
        marker="o",
        errorbar=None,
        ax=ax,
    )
    ax.set_xscale("log")
    ax.set_xlabel("Rerank candidate count p (log scale)")
    ax.set_ylabel("Recall@10")
    ax.set_ylim(-0.03, 1.04)
    ax.legend(frameon=False, title=None, ncol=2)
    sns.despine(ax=ax)
    savefig(fig, "fig_rerank_sensitivity")


def prefetch_sweep(summary: pd.DataFrame):
    pf = summary[summary["method"].str.startswith("Flat-NEON-Unroll4-Prefetch-d")].copy()
    if pf.empty:
        return
    pf = pf.sort_values("prefetch")
    fig, ax = plt.subplots(figsize=(4.4, 2.9))
    ax.errorbar(
        pf["prefetch"],
        pf["latency_mean"],
        yerr=pf["latency_std"],
        marker="o",
        color=PALETTE["Flat"],
        capsize=2,
    )
    ax.set_xlabel("Prefetch distance (vectors)")
    ax.set_ylabel("Latency per query (ms)")
    ax.set_xticks(pf["prefetch"].astype(int))
    sns.despine(ax=ax)
    savefig(fig, "fig_prefetch_sweep")


def coarse_rerank_breakdown(summary: pd.DataFrame):
    q = summary[(summary["family"].isin(["SQ8-LUT", "SQ8-U8SIMD", "PQ-ADC"])) & (summary["p"] > 0)].copy()
    q = q.sort_values(["recall_mean", "latency_mean"], ascending=[False, True]).head(14)
    q["other_ms"] = (q["latency_mean"] - q["coarse_ms"] - q["rerank_ms"]).clip(lower=0)
    q = q.sort_values("latency_mean", ascending=False)
    y = np.arange(len(q))
    fig, ax = plt.subplots(figsize=(6.5, 3.9))
    ax.barh(y, q["coarse_ms"], label="Coarse scan", color="#4C72B0")
    ax.barh(y, q["rerank_ms"], left=q["coarse_ms"], label="Float rerank", color="#C44E52")
    ax.barh(y, q["other_ms"], left=q["coarse_ms"] + q["rerank_ms"], label="Other", color="0.75")
    ax.set_yticks(y)
    ax.set_yticklabels(q["label"])
    ax.set_xlabel("Latency per query (ms)")
    ax.legend(frameon=False, ncol=3, loc="lower right")
    sns.despine(ax=ax)
    savefig(fig, "fig_coarse_rerank_breakdown")


def pq_method_matrix(summary: pd.DataFrame):
    keep = summary[
        summary["family"].isin(["PQ-ADC", "PQ-SDC", "FastScan-ADC", "FastScan-SDC", "SDC-Pipeline"])
    ].copy()
    if keep.empty:
        return
    preferred = [
        "PQ-ADC-M16-p1000",
        "PQ-ADC-M16-p2000",
        "PQ-ADC-Select-M16-p2000",
        "PQ-SDC-M16-coarse",
        "PQ-SDC-M16-p1000",
        "PQ-SDC-M16-p2000",
        "FastScan-ADC-M16-p1000",
        "FastScan-ADC-M16-p2000",
        "FastScan-ADC-M16-p1000-b32",
        "FastScan-ADC-M16-p1500-b64",
        "FastScan-ADC-M16-p2000-b32",
        "FastScan-SDC-M16-p1000",
        "FastScan-SDC-M16-p2000",
        "SDC-Pipeline2-M16-p1000-b16",
        "SDC-Pipeline3-M16-p1000-b16",
        "SDC-Pipeline2-M16-p1000-b64",
        "SDC-Pipeline3-M16-p1000-b64",
    ]
    q = keep[keep["method"].isin(preferred)].copy()
    if q.empty:
        q = keep.sort_values(["recall_mean", "latency_mean"], ascending=[False, True]).head(14).copy()
    q["order"] = q["method"].map({m: i for i, m in enumerate(preferred)}).fillna(999)
    q = q.sort_values(["order", "latency_mean"])
    q["scan_part"] = q["coarse_ms"].fillna(0).clip(lower=0)
    q["rerank_part"] = q["rerank_ms"].fillna(0).clip(lower=0)
    q["other_part"] = (q["latency_mean"] - q["scan_part"] - q["rerank_part"]).clip(lower=0)

    fig, axes = plt.subplots(
        1,
        3,
        figsize=(8.4, max(3.6, 0.28 * len(q))),
        gridspec_kw={"width_ratios": [1.15, 0.85, 0.7]},
        sharey=True,
    )
    y = np.arange(len(q))
    axes[0].barh(y, q["scan_part"], color="#4C72B0", label="coarse/scan")
    axes[0].barh(y, q["rerank_part"], left=q["scan_part"], color="#C44E52", label="rerank")
    axes[0].barh(
        y,
        q["other_part"],
        left=q["scan_part"] + q["rerank_part"],
        color="0.75",
        label="other",
    )
    axes[0].set_yticks(y)
    axes[0].set_yticklabels(q["label"])
    axes[0].invert_yaxis()
    axes[0].set_xlabel("Latency/query (ms)")
    axes[0].legend(frameon=False, fontsize=7, loc="lower left", bbox_to_anchor=(0.0, 1.01), ncol=3)

    axes[1].barh(y, q["recall_mean"], color=q["family"].map(PALETTE).fillna("0.5"))
    axes[1].set_xlim(max(0.0, q["recall_mean"].min() - 0.01), 1.001)
    axes[1].set_xlabel("Recall@10")

    speed_base = float(summary.loc[summary["method"].eq("Flat-Manual-NEON"), "latency_mean"].iloc[0])
    q["speedup_vs_neon"] = speed_base / q["latency_mean"]
    axes[2].barh(y, q["speedup_vs_neon"], color="0.35")
    axes[2].axvline(1.0, color="0.2", linestyle="--", linewidth=0.8)
    axes[2].set_xlabel("Speedup vs NEON")

    for ax in axes:
        sns.despine(ax=ax)
        ax.grid(axis="x", alpha=0.25)
    savefig(fig, "fig_pq_method_matrix")


def estimate_roofline(summary: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for _, row in summary.iterrows():
        n = float(row["N"])
        d = float(row["d"])
        p = float(row["p"])
        m = float(row["M"])
        ks = float(row["Ks"] if row["Ks"] else 256)
        latency_s = max(float(row["latency_mean"]) / 1000.0, 1e-12)
        if row["family"] == "Flat":
            bytes_q = n * d * 4.0
            ops_q = n * d * 2.0
        elif row["family"].startswith("SQ8"):
            bytes_q = n * d + p * d * 4.0
            ops_q = n * d + p * d * 2.0
        elif row["family"] == "PQ-ADC":
            bytes_q = n * m + p * d * 4.0 + m * ks * 4.0
            ops_q = n * m + p * d * 2.0 + ks * d * 2.0
        else:
            continue
        rows.append(
            {
                "method": row["method"],
                "family": row["family"],
                "label": row["label"],
                "latency_ms": row["latency_mean"],
                "bytes_per_query": bytes_q,
                "ops_per_query": ops_q,
                "arithmetic_intensity": ops_q / bytes_q,
                "effective_gops": ops_q / latency_s / 1e9,
                "effective_bandwidth_gbs": bytes_q / latency_s / 1e9,
            }
        )
    roof = pd.DataFrame(rows)
    roof.to_csv(RESULT_DIR / "simd_roofline.csv", index=False)
    return roof


def roofline_proxy(summary: pd.DataFrame):
    roof = estimate_roofline(summary)
    fig, ax = plt.subplots(figsize=(5.2, 3.4))
    sns.scatterplot(
        data=roof,
        x="arithmetic_intensity",
        y="effective_gops",
        hue="family",
        palette=PALETTE,
        s=34,
        edgecolor="white",
        linewidth=0.45,
        ax=ax,
    )
    xs = np.logspace(np.log10(max(roof["arithmetic_intensity"].min() * 0.8, 1e-3)), np.log10(roof["arithmetic_intensity"].max() * 1.2), 100)
    for bw in (10, 20, 40):
        ax.plot(xs, xs * bw, linestyle="--", linewidth=0.75, color="0.45", alpha=0.75)
        ax.text(xs[-1], xs[-1] * bw, f"{bw} GB/s", fontsize=7, va="center", ha="right", color="0.35")
    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("Arithmetic intensity (estimated ops/byte)")
    ax.set_ylabel("Effective throughput (GOPS)")
    ax.legend(frameon=False, title=None)
    sns.despine(ax=ax)
    savefig(fig, "fig_roofline_proxy")


def main():
    configure_style()
    df = load_data()
    summary = summarize(df)
    flat_speedup(summary)
    latency_recall(summary)
    pq_method_matrix(summary)
    rerank_sensitivity(summary)
    prefetch_sweep(summary)
    coarse_rerank_breakdown(summary)
    roofline_proxy(summary)
    print(f"wrote paper-style figures to {FIG_DIR}")
    print(f"wrote summary to {RESULT_DIR / 'simd_summary.csv'}")
    print(f"wrote roofline proxy data to {RESULT_DIR / 'simd_roofline.csv'}")


if __name__ == "__main__":
    main()
