#!/usr/bin/env python3
import argparse
import csv
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
import numpy as np


ROOT = Path(__file__).resolve().parent
RESULT_DIR = ROOT / "files" / "results"
FIG_DIR = ROOT / "files" / "figures" / "mpi_report"

NUMERIC = {
    "mpi_size", "nodes", "ppn", "nthreads", "nbase", "nq", "k", "nlist",
    "nprobe", "ef", "latency_ms", "recall@100", "build_sec",
    "distribute_ms", "search_ms", "comm_ms", "merge_ms", "total_ms",
    "work_imbalance", "mpi_thread_required", "mpi_thread_provided",
}


def setup_style():
    plt.rcParams.update({
        "font.size": 9.2,
        "axes.labelsize": 9.6,
        "axes.titlesize": 10.4,
        "legend.fontsize": 8.2,
        "xtick.labelsize": 8.2,
        "ytick.labelsize": 8.2,
        "figure.figsize": (6.4, 4.0),
        "axes.grid": True,
        "grid.alpha": 0.22,
        "axes.spines.top": False,
        "axes.spines.right": False,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
    })


def read_csv(path, platform, scale_label):
    rows = []
    with Path(path).open(newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            for key in NUMERIC:
                if key in row and row[key] != "":
                    row[key] = float(row[key]) if "." in row[key] else int(row[key])
            row["platform_tag"] = platform
            row["scale_label"] = scale_label
            rows.append(row)
    return rows


def selected_scale(rows):
    nbase = max(r["nbase"] for r in rows)
    nq = max(r["nq"] for r in rows)
    return [r for r in rows if r["nbase"] == nbase and r["nq"] == nq]


def valid(rows):
    return [r for r in rows if r["recall@100"] >= 0.95]


def best(rows, key_fn):
    out = {}
    for r in rows:
        key = key_fn(r)
        if key not in out or r["latency_ms"] < out[key]["latency_ms"]:
            out[key] = r
    return out


def savefig(name):
    FIG_DIR.mkdir(parents=True, exist_ok=True)
    for ext in ("pdf", "png"):
        plt.savefig(FIG_DIR / f"{name}.{ext}", bbox_inches="tight", dpi=260)
    plt.close()


def write_summary(rows_by_platform):
    fields = [
        "platform_tag", "scale_label", "method", "kernel", "mpi_size",
        "nthreads", "thread_model", "comm", "nprobe", "ef", "latency_ms",
        "recall@100", "build_sec", "search_ms", "comm_ms", "merge_ms",
        "work_imbalance", "notes",
    ]
    out = []
    for platform, rows in rows_by_platform.items():
        scale = selected_scale(rows)
        candidates = valid(scale) if platform == "x86 full" else scale
        for r in sorted(best(candidates, lambda x: x["method"]).values(),
                        key=lambda x: x["latency_ms"]):
            out.append(r)
    with (RESULT_DIR / "mpi_report_platform_best.csv").open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for r in out:
            writer.writerow({k: r.get(k, "") for k in fields})


def plot_x86_pareto(rows):
    rows = selected_scale(rows)
    colors = {
        "flat": "#4C78A8",
        "ivf": "#F58518",
        "hnsw": "#54A24B",
        "multi-hnsw": "#B279A2",
        "ivf-hnsw": "#E45756",
    }
    markers = {"flat": "s", "ivf": "o", "hnsw": "^", "multi-hnsw": "D", "ivf-hnsw": "v"}
    plt.figure(figsize=(6.6, 4.1))
    ax = plt.gca()
    for method in ["flat", "ivf", "hnsw", "multi-hnsw", "ivf-hnsw"]:
        data = [r for r in rows if r["method"] == method]
        ax.scatter(
            [r["latency_ms"] for r in data],
            [r["recall@100"] for r in data],
            s=[30 + 7 * r["mpi_size"] for r in data],
            c=colors[method],
            marker=markers[method],
            edgecolor="white",
            linewidth=0.45,
            alpha=0.82,
            label=method,
        )
    ax.axhline(0.95, color="#333333", linestyle="--", linewidth=1.0)
    ax.set_xscale("log")
    ax.set_xlabel("Latency (ms/query, log scale)")
    ax.set_ylabel("Recall@100")
    ax.set_title("x86 full-scale recall-latency frontier")
    ax.set_ylim(0.89, 1.004)
    ax.legend(ncol=3, frameon=False, loc="lower right")
    savefig("fig_mpi_01_pareto_frontier")


def plot_platform_best(rows_by_platform):
    methods = ["flat", "ivf", "hnsw", "multi-hnsw", "ivf-hnsw"]
    platforms = ["x86 full", "ARM quick"]
    values = {p: [] for p in platforms}
    recalls = {p: [] for p in platforms}
    labels = {p: [] for p in platforms}
    for p in platforms:
        rows = selected_scale(rows_by_platform[p])
        candidates = valid(rows) if p == "x86 full" else rows
        by_method = best(candidates, lambda r: r["method"])
        for m in methods:
            r = by_method.get(m)
            values[p].append(np.nan if r is None else r["latency_ms"])
            recalls[p].append(np.nan if r is None else r["recall@100"])
            labels[p].append("" if r is None else f"P{int(r['mpi_size'])}T{int(r['nthreads'])}")
    x = np.arange(len(methods))
    width = 0.36
    plt.figure(figsize=(6.8, 3.8))
    ax = plt.gca()
    b1 = ax.bar(x - width / 2, values["x86 full"], width, color="#4C78A8", label="x86 full 100k/1000")
    b2 = ax.bar(x + width / 2, values["ARM quick"], width, color="#F58518", label="ARM quick 50k/300")
    ax.set_yscale("log")
    ax.set_xticks(x)
    ax.set_xticklabels(methods, rotation=15, ha="right")
    ax.set_ylabel("Best latency (ms/query, log scale)")
    ax.set_title("Best algorithm-family latency by platform scale")
    for bars, p in [(b1, "x86 full"), (b2, "ARM quick")]:
        for i, b in enumerate(bars):
            if np.isfinite(b.get_height()):
                ax.text(b.get_x() + b.get_width() / 2, b.get_height() * 1.08,
                        f"{labels[p][i]}\nR={recalls[p][i]:.3f}",
                        ha="center", va="bottom", fontsize=6.8)
    ax.legend(frameon=False)
    savefig("fig_mpi_02_platform_best_by_method")


def plot_x86_ivf_tradeoff(rows):
    data = [
        r for r in selected_scale(rows)
        if r["method"] == "ivf" and r["kernel"] == "simd"
        and r["comm"] == "blocking" and r["thread_model"] == "stdthread"
        and r["nthreads"] == 1 and r["nprobe"] in {16, 32, 64, 128, 256}
    ]
    data = best(data, lambda r: (r["mpi_size"], r["nprobe"])).values()
    palette = {1: "#4C78A8", 2: "#F58518", 4: "#54A24B", 8: "#B279A2"}
    plt.figure(figsize=(6.3, 3.8))
    ax = plt.gca()
    for p in [1, 2, 4, 8]:
        rs = sorted([r for r in data if r["mpi_size"] == p], key=lambda r: r["nprobe"])
        if not rs:
            continue
        ax.plot([r["recall@100"] for r in rs], [r["latency_ms"] for r in rs],
                marker="o", linewidth=1.4, color=palette[p], label=f"{p} ranks")
        for r in rs:
            ax.text(r["recall@100"], r["latency_ms"], str(int(r["nprobe"])),
                    fontsize=7, ha="left", va="bottom", color=palette[p])
    ax.axvline(0.95, color="#333333", linestyle="--", linewidth=1.0)
    ax.set_xlabel("Recall@100")
    ax.set_ylabel("Latency (ms/query)")
    ax.set_title("x86 IVF nprobe trade-off")
    ax.legend(frameon=False)
    savefig("fig_mpi_03_x86_ivf_nprobe_tradeoff")


def plot_arm_ivf_tradeoff(rows):
    data = [
        r for r in selected_scale(rows)
        if r["method"] == "ivf" and r["kernel"] == "simd"
        and r["comm"] == "blocking" and r["thread_model"] == "stdthread"
        and r["nthreads"] == 1
    ]
    data = best(data, lambda r: (r["mpi_size"], r["nprobe"])).values()
    palette = {1: "#4C78A8", 2: "#F58518", 4: "#54A24B"}
    plt.figure(figsize=(6.3, 3.8))
    ax = plt.gca()
    for p in [1, 2, 4]:
        rs = sorted([r for r in data if r["mpi_size"] == p], key=lambda r: r["nprobe"])
        if not rs:
            continue
        ax.plot([r["recall@100"] for r in rs], [r["latency_ms"] for r in rs],
                marker="o", linewidth=1.4, color=palette[p], label=f"{p} ranks")
        for r in rs:
            ax.text(r["recall@100"], r["latency_ms"], str(int(r["nprobe"])),
                    fontsize=7, ha="left", va="bottom", color=palette[p])
    ax.set_xlabel("Raw recall@100 against 100k ground truth")
    ax.set_ylabel("Latency (ms/query)")
    ax.set_title("ARM quick IVF trend on 50k base")
    ax.legend(frameon=False)
    savefig("fig_mpi_04_arm_ivf_quick_tradeoff")


def plot_comm_methods(rows_by_platform):
    comms = ["blocking", "nonblocking", "p2p", "onesided"]
    vals = {p: [] for p in rows_by_platform}
    comm_pct = {p: [] for p in rows_by_platform}
    for p, rows in rows_by_platform.items():
        scale = selected_scale(rows)
        for comm in comms:
            cand = [
                r for r in scale
                if r["method"] == "ivf" and r["kernel"] == "simd"
                and r["nprobe"] == 64 and r["thread_model"] == "stdthread"
                and r["nthreads"] == 1 and r["mpi_size"] == 4 and r["comm"] == comm
            ]
            r = min(cand, key=lambda x: x["latency_ms"])
            vals[p].append(r["latency_ms"])
            comm_pct[p].append(100.0 * r["comm_ms"] / max(r["total_ms"], 1e-9))
    x = np.arange(len(comms))
    width = 0.36
    plt.figure(figsize=(6.3, 3.7))
    ax = plt.gca()
    ax.bar(x - width / 2, vals["x86 full"], width, color="#4C78A8", label="x86 latency")
    ax.bar(x + width / 2, vals["ARM quick"], width, color="#F58518", label="ARM latency")
    ax.set_xticks(x)
    ax.set_xticklabels(comms, rotation=12, ha="right")
    ax.set_ylabel("Latency at 4 ranks (ms/query)")
    ax.set_title("Communication mode comparison at 4 ranks")
    ax2 = ax.twinx()
    ax2.plot(x, comm_pct["x86 full"], marker="o", color="#1B4F72", linewidth=1.2, label="x86 comm%")
    ax2.plot(x, comm_pct["ARM quick"], marker="s", color="#A04000", linewidth=1.2, label="ARM comm%")
    ax2.set_ylabel("Communication share (%)")
    h1, l1 = ax.get_legend_handles_labels()
    h2, l2 = ax2.get_legend_handles_labels()
    ax.legend(h1 + h2, l1 + l2, frameon=False, ncol=2, loc="upper left")
    savefig("fig_mpi_05_comm_methods")


def plot_stage_breakdown(rows_by_platform):
    entries = []
    labels = []
    for p in ["x86 full", "ARM quick"]:
        scale = selected_scale(rows_by_platform[p])
        for rank in [1, 2, 4]:
            cand = [
                r for r in scale
                if r["method"] == "ivf" and r["kernel"] == "simd"
                and r["nprobe"] == 64 and r["thread_model"] == "stdthread"
                and r["nthreads"] == 1 and r["mpi_size"] == rank
                and r["comm"] in {"blocking", "nonblocking", "onesided"}
            ]
            r = min(cand, key=lambda x: x["latency_ms"])
            total = max(r["search_ms"] + r["comm_ms"] + r["merge_ms"], 1e-9)
            entries.append([100 * r["search_ms"] / total,
                            100 * r["comm_ms"] / total,
                            100 * r["merge_ms"] / total])
            labels.append(("x86" if p == "x86 full" else "ARM") + f"\nP{rank}")
    arr = np.array(entries)
    x = np.arange(len(labels))
    plt.figure(figsize=(6.4, 3.8))
    ax = plt.gca()
    ax.bar(x, arr[:, 0], color="#4C78A8", label="search")
    ax.bar(x, arr[:, 1], bottom=arr[:, 0], color="#F58518", label="comm")
    ax.bar(x, arr[:, 2], bottom=arr[:, 0] + arr[:, 1], color="#54A24B", label="merge")
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.set_ylim(0, 100)
    ax.set_ylabel("Stage share (%)")
    ax.set_title("IVF nprobe=64 stage composition")
    ax.legend(frameon=False, ncol=3, loc="upper center")
    savefig("fig_mpi_06_stage_breakdown")


def plot_hybrid_heatmap(rows_by_platform):
    rows_labels = []
    matrix = []
    ranks = [1, 2, 4]
    for platform in ["x86 full", "ARM quick"]:
        scale = selected_scale(rows_by_platform[platform])
        short = "x86" if platform == "x86 full" else "ARM"
        for method in ["ivf", "hnsw"]:
            thread_values = [1, 2, 4] if platform == "x86 full" else [1, 2]
            for t in thread_values:
                vals = []
                for rank in ranks:
                    cand = [
                        r for r in scale
                        if r["method"] == method and r["thread_model"] == "openmp"
                        and r["kernel"] == "simd" and r["nthreads"] == t
                        and r["mpi_size"] == rank and (method == "hnsw" or r["nprobe"] == 64)
                    ]
                    vals.append(np.nan if not cand else min(cand, key=lambda x: x["latency_ms"])["latency_ms"])
                if any(np.isfinite(vals)):
                    rows_labels.append(f"{short} {method} T{t}")
                    matrix.append(vals)
    matrix = np.array(matrix, dtype=float)
    finite = matrix[np.isfinite(matrix)]
    plt.figure(figsize=(6.4, 4.5))
    ax = plt.gca()
    im = ax.imshow(matrix, cmap="YlGnBu_r", norm=LogNorm(vmin=finite.min(), vmax=finite.max()))
    ax.set_xticks(np.arange(len(ranks)))
    ax.set_xticklabels([str(r) for r in ranks])
    ax.set_yticks(np.arange(len(rows_labels)))
    ax.set_yticklabels(rows_labels)
    ax.set_xlabel("MPI ranks")
    ax.set_title("OpenMP hybrid latency across platforms")
    for i in range(matrix.shape[0]):
        for j in range(matrix.shape[1]):
            if np.isfinite(matrix[i, j]):
                ax.text(j, i, f"{matrix[i, j]:.3f}", ha="center", va="center", fontsize=7.0)
    cbar = plt.colorbar(im, ax=ax, fraction=0.045, pad=0.03)
    cbar.set_label("ms/query")
    ax.grid(False)
    savefig("fig_mpi_07_openmp_hybrid_heatmap")


def plot_simd_speedup(rows_by_platform):
    labels = []
    x86 = []
    arm = []
    for method in ["flat", "ivf"]:
        for rank in [1, 2, 4]:
            labels.append(f"{method}\nP{rank}")
            for platform, target in [("x86 full", x86), ("ARM quick", arm)]:
                scale = selected_scale(rows_by_platform[platform])
                sim = [
                    r for r in scale
                    if r["method"] == method and r["kernel"] == "simd"
                    and r["comm"] == "blocking" and r["thread_model"] == "stdthread"
                    and r["nthreads"] == 1 and r["mpi_size"] == rank
                    and (method == "flat" or r["nprobe"] == 64)
                ]
                sca = [
                    r for r in scale
                    if r["method"] == method and r["kernel"] == "scalar"
                    and r["comm"] == "blocking" and r["thread_model"] == "stdthread"
                    and r["nthreads"] == 1 and r["mpi_size"] == rank
                    and (method == "flat" or r["nprobe"] == 64)
                ]
                target.append(np.nan if not sim or not sca else
                              min(sca, key=lambda x: x["latency_ms"])["latency_ms"] /
                              min(sim, key=lambda x: x["latency_ms"])["latency_ms"])
    x = np.arange(len(labels))
    width = 0.36
    plt.figure(figsize=(6.7, 3.7))
    ax = plt.gca()
    ax.bar(x - width / 2, x86, width, color="#4C78A8", label="x86 AVX2")
    ax.bar(x + width / 2, arm, width, color="#F58518", label="ARM NEON")
    ax.axhline(1.0, color="#333333", linewidth=0.9)
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.set_ylabel("Speedup over scalar")
    ax.set_title("SIMD contribution inside MPI ranks")
    ax.legend(frameon=False)
    savefig("fig_mpi_08_simd_speedup")


def plot_graph_variants(rows_by_platform):
    methods = ["hnsw", "multi-hnsw", "ivf-hnsw"]
    platforms = ["x86 full", "ARM quick"]
    vals = {p: [] for p in platforms}
    recalls = {p: [] for p in platforms}
    for p in platforms:
        scale = selected_scale(rows_by_platform[p])
        candidates = valid(scale) if p == "x86 full" else scale
        by_method = best([r for r in candidates if r["method"] in methods], lambda r: r["method"])
        for m in methods:
            r = by_method[m]
            vals[p].append(r["latency_ms"])
            recalls[p].append(r["recall@100"])
    x = np.arange(len(methods))
    width = 0.36
    plt.figure(figsize=(6.2, 3.7))
    ax = plt.gca()
    b1 = ax.bar(x - width / 2, vals["x86 full"], width, color="#54A24B", label="x86 full")
    b2 = ax.bar(x + width / 2, vals["ARM quick"], width, color="#B279A2", label="ARM quick")
    ax.set_xticks(x)
    ax.set_xticklabels(methods)
    ax.set_ylabel("Best latency (ms/query)")
    ax.set_title("Graph-index variants across platform scales")
    for bars, p in [(b1, "x86 full"), (b2, "ARM quick")]:
        for i, b in enumerate(bars):
            ax.text(b.get_x() + b.get_width() / 2, b.get_height() * 1.03,
                    f"R={recalls[p][i]:.3f}", ha="center", va="bottom", fontsize=7)
    ax.legend(frameon=False)
    savefig("fig_mpi_09_graph_variants")


def main():
    global FIG_DIR
    parser = argparse.ArgumentParser()
    parser.add_argument("--x86-csv", default=str(RESULT_DIR / "mpi_results_x86_windows.csv"))
    parser.add_argument("--arm-csv", default=str(RESULT_DIR / "mpi_results_arm_kunpeng.csv"))
    parser.add_argument("--fig-dir", default=str(FIG_DIR))
    args = parser.parse_args()

    FIG_DIR = Path(args.fig_dir)
    if not FIG_DIR.is_absolute():
        FIG_DIR = ROOT / FIG_DIR

    setup_style()
    rows_by_platform = {
        "x86 full": read_csv(args.x86_csv, "x86 full", "100k base / 1000 queries"),
        "ARM quick": read_csv(args.arm_csv, "ARM quick", "50k base / 300 queries"),
    }
    write_summary(rows_by_platform)
    plot_x86_pareto(rows_by_platform["x86 full"])
    plot_platform_best(rows_by_platform)
    plot_x86_ivf_tradeoff(rows_by_platform["x86 full"])
    plot_arm_ivf_tradeoff(rows_by_platform["ARM quick"])
    plot_comm_methods(rows_by_platform)
    plot_stage_breakdown(rows_by_platform)
    plot_hybrid_heatmap(rows_by_platform)
    plot_simd_speedup(rows_by_platform)
    plot_graph_variants(rows_by_platform)
    print(f"wrote figures to {FIG_DIR}")
    print(f"wrote summary to {RESULT_DIR / 'mpi_report_platform_best.csv'}")


if __name__ == "__main__":
    main()
