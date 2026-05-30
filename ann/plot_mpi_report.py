#!/usr/bin/env python3
import csv
import math
import argparse
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
import numpy as np


ROOT = Path(__file__).resolve().parent
CSV = ROOT / "files" / "results" / "mpi_results_x86_windows.csv"
FIG_DIR = ROOT / "files" / "figures" / "mpi_report"
TABLE_DIR = ROOT / "files" / "results"
OUT_TAG = "x86_windows"


def load_rows():
    with CSV.open(newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))
    for r in rows:
        for key in [
            "mpi_size",
            "nthreads",
            "nbase",
            "nq",
            "k",
            "nlist",
            "nprobe",
            "ef",
            "latency_ms",
            "recall@100",
            "build_sec",
            "distribute_ms",
            "search_ms",
            "comm_ms",
            "merge_ms",
            "total_ms",
            "work_imbalance",
            "mpi_thread_required",
            "mpi_thread_provided",
        ]:
            r[key] = float(r[key]) if "." in r[key] else int(r[key])
    return rows


def full100(rows):
    return [r for r in rows if r["nbase"] == 100000 and r["nq"] == 1000]


def best(rows, key_fn):
    out = {}
    for r in rows:
        key = key_fn(r)
        if key not in out or r["latency_ms"] < out[key]["latency_ms"]:
            out[key] = r
    return out


def valid(rows):
    return [r for r in rows if r["recall@100"] >= 0.95]


def savefig(name):
    FIG_DIR.mkdir(parents=True, exist_ok=True)
    for ext in ["pdf", "png"]:
        plt.savefig(FIG_DIR / f"{name}.{ext}", bbox_inches="tight", dpi=260)
    plt.close()


def setup_style():
    plt.rcParams.update({
        "font.size": 9.5,
        "axes.labelsize": 10,
        "axes.titlesize": 11,
        "legend.fontsize": 8.5,
        "xtick.labelsize": 8.5,
        "ytick.labelsize": 8.5,
        "figure.figsize": (6.6, 4.3),
        "axes.grid": True,
        "grid.alpha": 0.22,
        "axes.spines.top": False,
        "axes.spines.right": False,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
    })


def write_csv(path, rows, fields):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, "") for k in fields})


def table_outputs(rows):
    suffix = OUT_TAG
    f100 = full100(rows)
    best_method = sorted(
        best(valid(f100), lambda r: r["method"]).values(),
        key=lambda r: r["latency_ms"],
    )
    fields = [
        "method",
        "kernel",
        "mpi_size",
        "nthreads",
        "thread_model",
        "comm",
        "nprobe",
        "ef",
        "latency_ms",
        "recall@100",
        "build_sec",
        "search_ms",
        "comm_ms",
        "merge_ms",
        "work_imbalance",
        "notes",
    ]
    write_csv(TABLE_DIR / f"mpi_best_by_method_{suffix}.csv", best_method, fields)

    mpi_best = sorted(
        [r for r in valid(f100) if r["mpi_size"] >= 2],
        key=lambda r: r["latency_ms"],
    )[:12]
    write_csv(TABLE_DIR / f"mpi_best_parallel_{suffix}.csv", mpi_best, fields)

    comm = best(
        [
            r
            for r in f100
            if r["method"] == "ivf"
            and r["kernel"] == "simd"
            and r["thread_model"] == "stdthread"
            and r["nthreads"] == 1
            and r["nprobe"] == 64
            and "mpi-thread" not in r["notes"]
        ],
        lambda r: (r["mpi_size"], r["comm"]),
    )
    write_csv(TABLE_DIR / f"mpi_comm_compare_{suffix}.csv",
              sorted(comm.values(), key=lambda r: (r["mpi_size"], r["comm"])),
              fields)

    simd = best(
        [
            r
            for r in f100
            if r["method"] in {"flat", "ivf"}
            and r["comm"] == "blocking"
            and r["thread_model"] == "stdthread"
            and r["nthreads"] == 1
            and (r["method"] == "flat" or r["nprobe"] == 64)
        ],
        lambda r: (r["method"], r["mpi_size"], r["kernel"]),
    )
    write_csv(TABLE_DIR / f"mpi_simd_compare_{suffix}.csv",
              sorted(simd.values(), key=lambda r: (r["method"], r["mpi_size"], r["kernel"])),
              fields)


def plot_pareto(rows):
    f100 = full100(rows)
    colors = {
        "flat": "#4C78A8",
        "ivf": "#F58518",
        "hnsw": "#54A24B",
        "multi-hnsw": "#B279A2",
        "ivf-hnsw": "#E45756",
    }
    markers = {"flat": "s", "ivf": "o", "hnsw": "^", "multi-hnsw": "D", "ivf-hnsw": "v"}
    plt.figure()
    ax = plt.gca()
    for method in ["flat", "ivf", "hnsw", "multi-hnsw", "ivf-hnsw"]:
        data = [r for r in f100 if r["method"] == method]
        ax.scatter(
            [r["latency_ms"] for r in data],
            [r["recall@100"] for r in data],
            s=[32 + 8 * r["mpi_size"] for r in data],
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
    ax.set_title("Recall-latency frontier on full DEEP100K")
    ax.set_ylim(0.89, 1.004)
    ax.legend(ncol=3, frameon=False, loc="lower right")
    savefig("fig_mpi_01_pareto_frontier")


def plot_best_methods(rows):
    best_method = sorted(best(valid(full100(rows)), lambda r: r["method"]).values(),
                         key=lambda r: r["latency_ms"])
    labels = [r["method"] for r in best_method]
    x = np.arange(len(labels))
    lat = [r["latency_ms"] for r in best_method]
    rec = [r["recall@100"] for r in best_method]
    plt.figure(figsize=(6.4, 3.9))
    ax = plt.gca()
    bars = ax.bar(x, lat, color="#4C78A8", width=0.62)
    ax.set_ylabel("Best latency (ms/query)")
    ax.set_xticks(x)
    ax.set_xticklabels(labels, rotation=15, ha="right")
    ax.set_title("Best configuration of each algorithm family")
    ax2 = ax.twinx()
    ax2.plot(x, rec, color="#E45756", marker="o", linewidth=1.4)
    ax2.set_ylabel("Recall@100")
    ax2.set_ylim(0.94, 1.005)
    for b, r in zip(bars, best_method):
        ax.text(b.get_x() + b.get_width() / 2, b.get_height() * 1.02,
                f"P{int(r['mpi_size'])}T{int(r['nthreads'])}",
                ha="center", va="bottom", fontsize=8)
    savefig("fig_mpi_02_best_by_method")


def plot_ivf_tradeoff(rows):
    data = [
        r for r in full100(rows)
        if r["method"] == "ivf"
        and r["kernel"] == "simd"
        and r["comm"] == "blocking"
        and r["thread_model"] == "stdthread"
        and r["nthreads"] == 1
        and r["nprobe"] in {16, 32, 64, 128, 256}
    ]
    data = best(data, lambda r: (r["mpi_size"], r["nprobe"])).values()
    plt.figure()
    ax = plt.gca()
    palette = {1: "#4C78A8", 2: "#F58518", 4: "#54A24B", 8: "#B279A2"}
    for p in [1, 2, 4, 8]:
        rs = sorted([r for r in data if r["mpi_size"] == p], key=lambda r: r["nprobe"])
        ax.plot([r["recall@100"] for r in rs], [r["latency_ms"] for r in rs],
                marker="o", linewidth=1.4, color=palette[p], label=f"{p} ranks")
        for r in rs:
            ax.text(r["recall@100"], r["latency_ms"], str(int(r["nprobe"])),
                    fontsize=7, ha="left", va="bottom", color=palette[p])
    ax.axvline(0.95, color="#333333", linestyle="--", linewidth=1.0)
    ax.set_xlabel("Recall@100")
    ax.set_ylabel("Latency (ms/query)")
    ax.set_title("IVF nprobe trade-off under MPI data partitioning")
    ax.legend(frameon=False)
    savefig("fig_mpi_03_ivf_nprobe_tradeoff")


def plot_process_breakdown(rows):
    comm_best = best(
        [
            r for r in full100(rows)
            if r["method"] == "ivf"
            and r["kernel"] == "simd"
            and r["thread_model"] == "stdthread"
            and r["nthreads"] == 1
            and r["nprobe"] == 64
        ],
        lambda r: r["mpi_size"],
    )
    rs = [comm_best[p] for p in sorted(comm_best)]
    x = np.arange(len(rs))
    search = np.array([r["search_ms"] / r["nq"] for r in rs])
    comm = np.array([r["comm_ms"] / r["nq"] for r in rs])
    merge = np.array([r["merge_ms"] / r["nq"] for r in rs])
    plt.figure(figsize=(6.2, 3.8))
    ax = plt.gca()
    ax.bar(x, search, color="#4C78A8", label="local search")
    ax.bar(x, comm, bottom=search, color="#F58518", label="result communication")
    ax.bar(x, merge, bottom=search + comm, color="#54A24B", label="global merge")
    ax.set_xticks(x)
    ax.set_xticklabels([str(int(r["mpi_size"])) for r in rs])
    ax.set_xlabel("MPI ranks")
    ax.set_ylabel("Stage time (ms/query)")
    ax.set_title("IVF stage breakdown at nprobe=64")
    ax.legend(frameon=False)
    savefig("fig_mpi_04_process_breakdown")


def plot_comm(rows):
    data = best(
        [
            r for r in full100(rows)
            if r["method"] == "ivf"
            and r["kernel"] == "simd"
            and r["thread_model"] == "stdthread"
            and r["nthreads"] == 1
            and r["nprobe"] == 64
        ],
        lambda r: (r["mpi_size"], r["comm"]),
    )
    ranks = [1, 2, 4, 8]
    comms = ["blocking", "nonblocking", "p2p", "onesided"]
    x = np.arange(len(ranks))
    width = 0.18
    colors = ["#4C78A8", "#F58518", "#54A24B", "#B279A2"]
    plt.figure(figsize=(6.6, 3.8))
    ax = plt.gca()
    for i, c in enumerate(comms):
        vals = [data[(p, c)]["latency_ms"] for p in ranks]
        ax.bar(x + (i - 1.5) * width, vals, width, label=c, color=colors[i])
    ax.set_xticks(x)
    ax.set_xticklabels([str(p) for p in ranks])
    ax.set_xlabel("MPI ranks")
    ax.set_ylabel("Latency (ms/query)")
    ax.set_title("Communication method comparison for IVF")
    ax.legend(frameon=False, ncol=2)
    savefig("fig_mpi_05_comm_methods")


def plot_hybrid_heatmap(rows):
    data = best(
        [
            r for r in full100(rows)
            if r["method"] in {"ivf", "hnsw"}
            and r["thread_model"] == "openmp"
            and r["kernel"] == "simd"
            and (r["method"] == "hnsw" or r["nprobe"] == 64)
        ],
        lambda r: (r["method"], r["nthreads"], r["mpi_size"]),
    )
    ranks = [1, 2, 4, 8]
    labels = []
    matrix = []
    for method in ["ivf", "hnsw"]:
        for t in [1, 2, 4]:
            labels.append(f"{method} T{t}")
            matrix.append([data[(method, t, p)]["latency_ms"] for p in ranks])
    matrix = np.array(matrix)
    plt.figure(figsize=(6.2, 4.2))
    ax = plt.gca()
    im = ax.imshow(matrix, cmap="YlGnBu_r", norm=LogNorm(vmin=matrix.min(), vmax=matrix.max()))
    ax.set_xticks(np.arange(len(ranks)))
    ax.set_xticklabels([str(p) for p in ranks])
    ax.set_yticks(np.arange(len(labels)))
    ax.set_yticklabels(labels)
    ax.set_xlabel("MPI ranks")
    ax.set_title("OpenMP hybrid latency heatmap")
    for i in range(matrix.shape[0]):
        for j in range(matrix.shape[1]):
            ax.text(j, i, f"{matrix[i, j]:.3f}", ha="center", va="center", fontsize=7.5)
    cbar = plt.colorbar(im, ax=ax, fraction=0.045, pad=0.03)
    cbar.set_label("ms/query")
    ax.grid(False)
    savefig("fig_mpi_06_openmp_hybrid_heatmap")


def plot_simd(rows):
    data = best(
        [
            r for r in full100(rows)
            if r["method"] in {"flat", "ivf"}
            and r["comm"] == "blocking"
            and r["thread_model"] == "stdthread"
            and r["nthreads"] == 1
            and (r["method"] == "flat" or r["nprobe"] == 64)
        ],
        lambda r: (r["method"], r["mpi_size"], r["kernel"]),
    )
    labels = []
    speedup = []
    for method in ["flat", "ivf"]:
        for p in [1, 2, 4, 8]:
            labels.append(f"{method}\nP{p}")
            speedup.append(data[(method, p, "scalar")]["latency_ms"] /
                            data[(method, p, "simd")]["latency_ms"])
    x = np.arange(len(labels))
    plt.figure(figsize=(6.8, 3.7))
    ax = plt.gca()
    colors = ["#4C78A8"] * 4 + ["#F58518"] * 4
    ax.bar(x, speedup, color=colors, width=0.62)
    ax.axhline(1.0, color="#333333", linewidth=0.9)
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.set_ylabel("Speedup over scalar")
    ax.set_title("SIMD contribution inside MPI ranks")
    savefig("fig_mpi_07_simd_speedup")


def plot_graph(rows):
    data = [r for r in valid(full100(rows)) if r["method"] in {"hnsw", "multi-hnsw", "ivf-hnsw"}]
    best_graph = sorted(best(data, lambda r: r["method"]).values(), key=lambda r: r["latency_ms"])
    labels = [r["method"] for r in best_graph]
    x = np.arange(len(labels))
    plt.figure(figsize=(6.0, 3.6))
    ax = plt.gca()
    bars = ax.bar(x, [r["latency_ms"] for r in best_graph],
                  color=["#54A24B", "#B279A2", "#E45756"], width=0.58)
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.set_ylabel("Best latency (ms/query)")
    ax.set_title("Graph-index variants at recall@100 >= 0.95")
    for b, r in zip(bars, best_graph):
        ax.text(b.get_x() + b.get_width() / 2, b.get_height() * 1.03,
                f"R={r['recall@100']:.3f}\\nP{int(r['mpi_size'])}",
                ha="center", va="bottom", fontsize=8)
    savefig("fig_mpi_08_graph_variants")


def main():
    global CSV, FIG_DIR, OUT_TAG
    parser = argparse.ArgumentParser(description="Generate MPI ANN report figures and summary tables.")
    parser.add_argument("--csv", default=str(CSV), help="Input MPI result CSV.")
    parser.add_argument("--tag", default="", help="Output suffix, e.g. arm_kunpeng.")
    parser.add_argument("--fig-dir", default="", help="Output figure directory.")
    args = parser.parse_args()
    CSV = Path(args.csv)
    if not CSV.is_absolute():
        CSV = ROOT / CSV
    if args.tag:
        OUT_TAG = args.tag
    else:
        stem = CSV.stem
        OUT_TAG = stem.replace("mpi_results_", "") if stem.startswith("mpi_results_") else stem
    if args.fig_dir:
        FIG_DIR = Path(args.fig_dir)
        if not FIG_DIR.is_absolute():
            FIG_DIR = ROOT / FIG_DIR
    elif OUT_TAG != "x86_windows":
        FIG_DIR = ROOT / "files" / "figures" / f"mpi_report_{OUT_TAG}"
    setup_style()
    rows = load_rows()
    table_outputs(rows)
    plot_pareto(rows)
    plot_best_methods(rows)
    plot_ivf_tradeoff(rows)
    plot_process_breakdown(rows)
    plot_comm(rows)
    plot_hybrid_heatmap(rows)
    plot_simd(rows)
    plot_graph(rows)
    print(f"wrote figures to {FIG_DIR}")


if __name__ == "__main__":
    main()
