import os
from pathlib import Path

import numpy as np
import pandas as pd

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parent
RESULTS = ROOT / "files" / "results"
FIGS = ROOT / "files" / "figures" / "pthread_report"
REPORT = ROOT / "report"
FIGS.mkdir(parents=True, exist_ok=True)
REPORT.mkdir(parents=True, exist_ok=True)

TARGET_RECALL = 0.95


def read_csv(name):
    path = RESULTS / name
    if not path.exists():
        return pd.DataFrame()
    df = pd.read_csv(path)
    for col in ["latency_ms", "recall@100", "speedup", "build_sec", "nthreads",
                "param2", "encode_us", "lut_us", "scan_us", "select_us", "rerank_us"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
    return df


def setup_style():
    plt.rcParams.update({
        "figure.figsize": (7.0, 4.4),
        "figure.dpi": 140,
        "savefig.dpi": 300,
        "font.family": "DejaVu Sans",
        "axes.spines.top": False,
        "axes.spines.right": False,
        "axes.grid": True,
        "grid.alpha": 0.25,
        "axes.titleweight": "bold",
        "axes.labelsize": 10,
        "xtick.labelsize": 9,
        "ytick.labelsize": 9,
        "legend.fontsize": 8,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
    })


def clear_old_figures():
    for suffix in ("*.pdf", "*.png"):
        for path in FIGS.glob(suffix):
            if path.name.startswith("fig_pthread_report_"):
                path.unlink()


def savefig(name):
    plt.tight_layout()
    plt.savefig(FIGS / f"{name}.pdf", bbox_inches="tight")
    plt.savefig(FIGS / f"{name}.png", bbox_inches="tight")
    plt.close()


def family_of(row):
    exp = str(row.get("experiment", ""))
    method = str(row.get("method", ""))
    if exp.startswith("Flat"):
        return "Flat"
    if exp.startswith("SQ8"):
        return "SQ8"
    if exp.startswith("PQ") or exp.startswith("FastScan") or exp.startswith("SDC") or exp.startswith("FS"):
        return "PQ/SDC/FastScan"
    if exp.startswith("IVF-HNSW"):
        return "IVF-HNSW"
    if exp.startswith("IVF"):
        return "IVF/IVF-PQ"
    if exp.startswith("HNSW"):
        if "Layer0" in method:
            return "HNSW intra-query"
        return "HNSW"
    if exp.startswith("OpenMP"):
        return "OpenMP target"
    if exp.startswith("SYCL"):
        return "oneAPI/SYCL"
    if exp.startswith("OpenCL"):
        return "OpenCL"
    if exp.startswith("CUDA"):
        return "CUDA"
    return exp or "Other"


def best_under(df, target=TARGET_RECALL):
    if df.empty or "latency_ms" not in df.columns:
        return pd.Series(dtype=object)
    ok = df[(df["recall@100"] >= target) & (df["latency_ms"] > 0)]
    if ok.empty:
        return pd.Series(dtype=object)
    return ok.sort_values(["latency_ms", "recall@100"], ascending=[True, False]).iloc[0]


def load_all():
    data = {
        "x86_main": read_csv("pthread_results_x86_windows.csv"),
        "x86_hnsw": read_csv("pthread_hnsw_results_x86_windows.csv"),
        "arm_main": read_csv("pthread_results_arm.csv"),
        "arm_hnsw": read_csv("pthread_hnsw_results_arm.csv"),
        "sycl": read_csv("pthread_sycl_o2_2024_results_x86_windows.csv"),
        "openmp": read_csv("pthread_openmp_target_device_results_x86_windows.csv"),
        "opencl": read_csv("pthread_opencl_o2_results.csv"),
        "cuda": read_csv("pthread_cuda_results.csv"),
    }
    for key, df in data.items():
        if not df.empty:
            if key.startswith("x86"):
                df["platform"] = "x86 Windows"
            elif key.startswith("arm"):
                df["platform"] = "ARM Kunpeng"
            elif key == "sycl":
                df["platform"] = "x86 Intel GPU SYCL"
            elif key == "openmp":
                df["platform"] = "x86 Intel GPU OpenMP target"
            elif key == "opencl":
                df["platform"] = "x86 Intel GPU OpenCL"
            elif key == "cuda":
                df["platform"] = "CUDA optional"
            df["family"] = df.apply(family_of, axis=1)
    return data


def fig_global_frontier(data):
    def pick(df, label, family=None, exp=None, method=None):
        g = df
        if family is not None:
            g = g[g["family"] == family]
        if exp is not None:
            g = g[g["experiment"] == exp]
        if method is not None:
            g = g[g["method"] == method]
        b = best_under(g)
        if b.empty:
            return None
        return {
            "label": label,
            "latency": float(b["latency_ms"]),
            "recall": float(b["recall@100"]),
            "platform": b.get("platform", ""),
        }

    rows = [
        pick(data["x86_hnsw"], "x86 HNSW best"),
        pick(data["x86_main"], "x86 IVF best", family="IVF/IVF-PQ"),
        pick(data["x86_main"], "x86 FastScan/PQ best", family="PQ/SDC/FastScan"),
        pick(data["x86_main"], "x86 exact flat", family="Flat"),
        pick(data["arm_hnsw"], "ARM HNSW best"),
        pick(data["arm_main"], "ARM IVF best", family="IVF/IVF-PQ"),
        pick(data["arm_main"], "ARM FastScan/PQ best", family="PQ/SDC/FastScan"),
        pick(data["arm_main"], "ARM exact flat", family="Flat"),
        pick(data["openmp"], "Intel GPU OpenMP target"),
        pick(data["sycl"], "Intel GPU oneAPI/SYCL"),
    ]
    out = pd.DataFrame([r for r in rows if r is not None]).sort_values("latency", ascending=True)
    fig, ax = plt.subplots(figsize=(7.2, 4.6))
    color_map = {
        "x86 Windows": "#1f77b4",
        "ARM Kunpeng": "#d62728",
        "x86 Intel GPU SYCL": "#2ca02c",
        "x86 Intel GPU OpenMP target": "#9467bd",
    }
    colors = [color_map.get(p, "#7f7f7f") for p in out["platform"]]
    ax.barh(out["label"], out["latency"], color=colors, alpha=0.88)
    ax.invert_yaxis()
    ax.set_xscale("log")
    ax.set_xlabel("Latency per query (ms, log scale)")
    ax.set_title("Minimum Latency with Recall@100 >= 0.95")
    for y, (_, r) in enumerate(out.iterrows()):
        ax.text(r["latency"] * 1.05, y, f"{r['latency']:.4g} ms, R={r['recall']:.3f}",
                va="center", fontsize=8)
    savefig("fig_pthread_report_01_global_frontier")


def fig_family_best(data, platform_key, name, title):
    df = pd.concat([data[platform_key], data[platform_key.replace("main", "hnsw")]], ignore_index=True)
    rows = []
    for fam, g in df.groupby("family"):
        b = best_under(g)
        if not b.empty:
            rows.append(b)
    out = pd.DataFrame(rows).sort_values("latency_ms")
    fig, ax = plt.subplots()
    colors = ["#22577a" if r < 0.05 else "#38a3a5" for r in out["latency_ms"]]
    ax.barh(out["family"], out["latency_ms"], color=colors)
    ax.set_xscale("log")
    ax.set_xlabel("Best feasible latency (ms, log scale)")
    ax.set_title(title)
    for y, (_, r) in enumerate(out.iterrows()):
        ax.text(r["latency_ms"] * 1.05, y, f"{r['latency_ms']:.4g} ms, R={r['recall@100']:.3f}",
                va="center", fontsize=8)
    savefig(name)


def fig_thread_scaling(data, platform_key, name, title):
    df = data[platform_key]
    if df.empty:
        return
    picks = [
        ("Flat-Ablation", "SSE"),
        ("Flat-Ablation", "PrefetchTopK"),
        ("IVF", "nl512"),
        ("FastScan", "b64"),
        ("PQ-M", "M16"),
    ]
    fig, ax = plt.subplots()
    palette = ["#1b4965", "#5fa8d3", "#ca6702", "#9b2226", "#2a9d8f"]
    for i, (exp, method) in enumerate(picks):
        g = df[(df["experiment"] == exp) & (df["method"] == method)]
        if exp == "IVF":
            g = g[g["param2"] == 32]
        elif exp in ("FastScan", "PQ-M"):
            g = g[g["param2"].isin([500, 1000])]
            if not g.empty:
                p = 500 if 500 in set(g["param2"]) else g["param2"].iloc[0]
                g = g[g["param2"] == p]
        g = g.dropna(subset=["nthreads", "latency_ms"]).sort_values("nthreads")
        if g.empty:
            continue
        ax.plot(g["nthreads"], g["latency_ms"], marker="o", lw=1.9,
                color=palette[i % len(palette)], label=f"{exp}/{method}")
    ax.set_xlabel("Thread count")
    ax.set_ylabel("Latency per query (ms)")
    ax.set_yscale("log")
    ax.set_title(title)
    ax.legend(frameon=True)
    savefig(name)


def fig_ivf_tradeoff(data):
    fig, ax = plt.subplots()
    configs = [
        ("x86 Windows", data["x86_main"], "#1f77b4", "o"),
        ("ARM Kunpeng", data["arm_main"], "#d62728", "s"),
        ("OpenMP target", data["openmp"], "#9467bd", "D"),
        ("oneAPI/SYCL", data["sycl"], "#2ca02c", "^"),
    ]
    for label, df, color, marker in configs:
        if df.empty:
            continue
        if label in ("x86 Windows", "ARM Kunpeng"):
            g = df[(df["experiment"] == "IVF") & (df["method"] == "nl512")]
        else:
            g = df.copy()
        g = g.dropna(subset=["param2", "latency_ms", "recall@100"]).sort_values("param2")
        if g.empty:
            continue
        ax.plot(g["param2"], g["recall@100"], marker=marker, color=color, lw=1.8, label=label)
    ax.axhline(TARGET_RECALL, color="#111111", lw=1.1, ls="--")
    ax.set_xlabel("nprobe")
    ax.set_ylabel("Recall@100")
    ax.set_title("IVF nprobe Accuracy Trade-off")
    ax.legend(frameon=True)
    savefig("fig_pthread_report_04_ivf_nprobe_recall")

    fig, ax = plt.subplots()
    for label, df, color, marker in configs:
        if df.empty:
            continue
        if label in ("x86 Windows", "ARM Kunpeng"):
            g = df[(df["experiment"] == "IVF") & (df["method"] == "nl512")]
        else:
            g = df.copy()
        g = g.dropna(subset=["param2", "latency_ms", "recall@100"]).sort_values("param2")
        if g.empty:
            continue
        ax.plot(g["param2"], g["latency_ms"], marker=marker, color=color, lw=1.8, label=label)
    ax.set_xlabel("nprobe")
    ax.set_ylabel("Latency per query (ms)")
    ax.set_yscale("log")
    ax.set_title("IVF nprobe Latency Cost")
    ax.legend(frameon=True)
    savefig("fig_pthread_report_05_ivf_nprobe_latency")


def fig_hnsw_tradeoff(data):
    fig, ax = plt.subplots()
    configs = [
        ("x86 StdThread", data["x86_hnsw"], "StdThread", "#1f77b4", "o"),
        ("x86 StdAsync", data["x86_hnsw"], "StdAsync", "#5fa8d3", "^"),
        ("ARM StdThread", data["arm_hnsw"], "StdThread", "#d62728", "s"),
        ("ARM StdAsync", data["arm_hnsw"], "StdAsync", "#f4a261", "D"),
    ]
    for label, df, method, color, marker in configs:
        g = df[(df["experiment"] == "HNSW-ToolCompare") &
               (df["method"] == method) & (df["nthreads"].isin([16, 32]))]
        if not g.empty:
            best_thread = 32 if 32 in set(g["nthreads"]) else 16
            g = g[g["nthreads"] == best_thread].sort_values("param2")
            ax.plot(g["param2"], g["latency_ms"], marker=marker, color=color,
                    lw=1.8, label=f"{label}, t={best_thread}")
    ax.set_xlabel("ef")
    ax.set_ylabel("Latency per query (ms)")
    ax.set_yscale("log")
    ax.set_title("HNSW ef vs Latency")
    ax.legend(frameon=True)
    savefig("fig_pthread_report_06_hnsw_ef_latency")


def fig_hnsw_intra(data):
    rows = []
    for platform, df in [("x86", data["x86_hnsw"]), ("ARM", data["arm_hnsw"])]:
        g = df[df["experiment"].isin(["HNSW-IntraQuery", "IVF-HNSW"])]
        for (exp, method), gg in g.groupby(["experiment", "method"]):
            b = best_under(gg, target=0.0)
            if not b.empty:
                rows.append({"platform": platform, "method": method, "latency": b["latency_ms"],
                             "recall": b["recall@100"]})
    df = pd.DataFrame(rows)
    if df.empty:
        return
    df = df.sort_values(["platform", "latency"], ascending=[True, True])
    labels = df["platform"] + " / " + df["method"].str.replace("Layer0", "L0")
    fig, ax = plt.subplots(figsize=(7.4, 4.6))
    colors = np.where(df["recall"] >= TARGET_RECALL, "#2a9d8f", "#b56576")
    ax.barh(labels, df["latency"], color=colors)
    ax.set_xscale("log")
    ax.invert_yaxis()
    ax.set_xlabel("Best latency in variant (ms, log scale)")
    ax.set_title("Graph Intra-query Variants")
    for i, r in df.iterrows():
        y = list(df.index).index(i)
        ax.text(r["latency"] * 1.06, y, f"R={r['recall']:.2f}", va="center", fontsize=7)
    savefig("fig_pthread_report_07_hnsw_intra_variants")


def fig_openmp_heatmap(data):
    df = data["openmp"]
    if df.empty:
        return
    tmp = df.copy()
    tmp["cap"] = tmp["method"].str.extract(r"cap(\d+)").astype(float)
    pivot = tmp.pivot_table(index="cap", columns="param2", values="latency_ms", aggfunc="min")
    fig, ax = plt.subplots(figsize=(7.6, 4.8))
    im = ax.imshow(pivot.values, aspect="auto", origin="lower", cmap="viridis")
    ax.set_xticks(np.arange(len(pivot.columns)))
    ax.set_xticklabels([str(int(x)) for x in pivot.columns])
    ax.set_yticks(np.arange(len(pivot.index)))
    ax.set_yticklabels([str(int(x)) for x in pivot.index])
    ax.set_xlabel("nprobe")
    ax.set_ylabel("candidate_cap")
    ax.set_title("OpenMP Target IVF Tuning Latency (ms)")
    cbar = plt.colorbar(im, ax=ax)
    cbar.set_label("Latency (ms)")
    feasible = tmp[tmp["recall@100"] >= TARGET_RECALL]
    for _, r in feasible.iterrows():
        x = list(pivot.columns).index(r["param2"])
        y = list(pivot.index).index(float(r["cap"]))
        ax.scatter(x, y, s=60, facecolors="none", edgecolors="white", linewidths=1.2)
    savefig("fig_pthread_report_08_openmp_target_heatmap")


def fig_stage_breakdown(data):
    rows = []
    labels = []
    candidates = [
        ("OpenMP target IVF", best_under(data["openmp"])),
        ("SYCL IVF", best_under(data["sycl"])),
    ]
    for label, r in candidates:
        if r.empty:
            continue
        labels.append(label)
        rows.append([
            float(r.get("encode_us", 0.0) or 0.0),
            float(r.get("lut_us", 0.0) or 0.0),
            float(r.get("scan_us", 0.0) or 0.0),
            float(r.get("select_us", 0.0) or 0.0),
            float(r.get("rerank_us", 0.0) or 0.0),
        ])
    if not rows:
        return
    arr = np.array(rows)
    fig, ax = plt.subplots()
    bottom = np.zeros(arr.shape[0])
    names = ["coarse/encode", "fill/LUT", "scan", "select", "rerank"]
    colors = ["#264653", "#2a9d8f", "#e9c46a", "#f4a261", "#e76f51"]
    for i, name in enumerate(names):
        ax.bar(labels, arr[:, i], bottom=bottom, label=name, color=colors[i])
        bottom += arr[:, i]
    ax.set_ylabel("Time per query (us)")
    ax.set_title("Accelerator Path Timing Breakdown")
    ax.legend(frameon=True)
    savefig("fig_pthread_report_09_accel_breakdown")


def fig_build_latency(data):
    frames = []
    for key in ["x86_main", "x86_hnsw", "arm_main", "arm_hnsw"]:
        df = data[key]
        if not df.empty:
            frames.append(df)
    df = pd.concat(frames, ignore_index=True)
    df = df[(df["build_sec"] > 0) & (df["latency_ms"] > 0) & (df["recall@100"] >= TARGET_RECALL)]
    if df.empty:
        return
    rows = []
    for (platform, fam), g in df.groupby(["platform", "family"]):
        b = best_under(g)
        if not b.empty and b.get("build_sec", 0) > 0:
            rows.append(b)
    out = pd.DataFrame(rows)
    fig, ax = plt.subplots()
    for platform, g in out.groupby("platform"):
        ax.scatter(g["build_sec"], g["latency_ms"], s=58, alpha=0.88, label=platform)
        for _, r in g.iterrows():
            ax.annotate(r["family"], (r["build_sec"], r["latency_ms"]),
                        xytext=(5, 3), textcoords="offset points", fontsize=7)
    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("Index build time (s, log scale)")
    ax.set_ylabel("Best feasible latency (ms, log scale)")
    ax.set_title("Index Build Cost vs Selected Query Latency")
    ax.legend(frameon=True)
    savefig("fig_pthread_report_10_build_latency")


def latex_escape(s):
    return str(s).replace("_", r"\_").replace("%", r"\%").replace("&", r"\&")


def table_row(vals):
    return " & ".join(vals) + r" \\"


def generate_tables(data):
    tables = []

    summary_rows = [
        ("x86 主 CPU", "pthread_results_x86_windows.csv", len(data["x86_main"]), best_under(data["x86_main"])),
        ("x86 HNSW", "pthread_hnsw_results_x86_windows.csv", len(data["x86_hnsw"]), best_under(data["x86_hnsw"])),
        ("ARM 主 CPU", "pthread_results_arm.csv", len(data["arm_main"]), best_under(data["arm_main"])),
        ("ARM HNSW", "pthread_hnsw_results_arm.csv", len(data["arm_hnsw"]), best_under(data["arm_hnsw"])),
        ("OpenMP target", "pthread_openmp_target_device_results_x86_windows.csv", len(data["openmp"]), best_under(data["openmp"])),
        ("oneAPI/SYCL", "pthread_sycl_o2_2024_results_x86_windows.csv", len(data["sycl"]), best_under(data["sycl"])),
    ]
    lines = [
        r"\begin{table}[H]\centering\small",
        r"\caption{核心实验 CSV 与约束最优结果}",
        r"\label{tab:core_csv}",
        r"\resizebox{\textwidth}{!}{%",
        r"\begin{tabular}{llrlll}",
        r"\toprule",
        r"实验 & CSV & 行数 & 最优配置 & latency & recall@100 \\",
        r"\midrule",
    ]
    for label, csv, count, b in summary_rows:
        if b.empty:
            best = "-"
            lat = "-"
            rec = "-"
        else:
            best = f"{b.get('experiment','')}/{b.get('method','')} {b.get('param1','')}={int(b.get('param2',0))}"
            lat = f"{b['latency_ms']:.6f} ms"
            rec = f"{b['recall@100']:.6f}"
        lines.append(table_row([latex_escape(label), latex_escape(csv), str(count),
                                latex_escape(best), lat, rec]))
    lines += [r"\bottomrule", r"\end{tabular}}", r"\end{table}", ""]
    tables.append("\n".join(lines))

    final_rows = [
        ("x86 Windows", read_csv("pthread_final_x86_windows.csv")),
        ("ARM Kunpeng", read_csv("pthread_final_arm.csv")),
    ]
    lines = [
        r"\begin{table}[H]\centering\small",
        r"\caption{最终提交路径 test.sh/默认 main 结果}",
        r"\label{tab:final_path}",
        r"\resizebox{\textwidth}{!}{%",
        r"\begin{tabular}{llllrrr}",
        r"\toprule",
        r"平台 & 方法 & 线程 & 参数 & latency(us) & recall@100 & build(s) \\",
        r"\midrule",
    ]
    for platform, df in final_rows:
        if df.empty:
            continue
        r = df.iloc[0]
        lines.append(table_row([platform, latex_escape(r["method"]), str(r["nthreads"]),
                                f"{r['param1']}={r['param2']}",
                                f"{float(r['latency_us']):.3f}",
                                f"{float(r['recall@100']):.6f}",
                                f"{float(r['build_sec']):.3f}"]))
    lines += [r"\bottomrule", r"\end{tabular}}", r"\end{table}", ""]
    tables.append("\n".join(lines))

    def best_by_family(df):
        rows = []
        for fam, g in df.groupby("family"):
            b = best_under(g)
            if not b.empty:
                rows.append((fam, b))
        return sorted(rows, key=lambda x: x[1]["latency_ms"])

    for key, caption, label in [
        ("x86_main", "x86 主 sweep 中各算法族最优可行点", "tab:x86_family_best"),
        ("arm_main", "ARM quick 主 sweep 中各算法族最优可行点", "tab:arm_family_best"),
    ]:
        lines = [
            r"\begin{table}[H]\centering\small",
            rf"\caption{{{caption}}}",
            rf"\label{{{label}}}",
            r"\resizebox{\textwidth}{!}{%",
            r"\begin{tabular}{llllrr}",
            r"\toprule",
            r"算法族 & experiment & method & 参数 & latency(ms) & recall@100 \\",
            r"\midrule",
        ]
        for fam, b in best_by_family(data[key]):
            param = latex_escape(f"{b['param1']}={int(b['param2'])}")
            lines.append(table_row([latex_escape(fam), latex_escape(b["experiment"]),
                                    latex_escape(b["method"]), param,
                                    f"{b['latency_ms']:.6f}", f"{b['recall@100']:.6f}"]))
        lines += [r"\bottomrule", r"\end{tabular}}", r"\end{table}", ""]
        tables.append("\n".join(lines))

    text = "\n\n".join(tables)
    (REPORT / "pthread_report_tables.tex").write_text(text, encoding="utf-8")


def main():
    setup_style()
    clear_old_figures()
    data = load_all()
    fig_global_frontier(data)
    fig_family_best(data, "x86_main", "fig_pthread_report_02_x86_family_best",
                    "x86 Feasible Best by Algorithm Family")
    fig_family_best(data, "arm_main", "fig_pthread_report_03_arm_family_best",
                    "ARM/Kunpeng Feasible Best by Algorithm Family")
    fig_thread_scaling(data, "x86_main", "fig_pthread_report_11_x86_thread_scaling",
                       "x86 Thread Scaling")
    fig_thread_scaling(data, "arm_main", "fig_pthread_report_12_arm_thread_scaling",
                       "ARM/Kunpeng Thread Scaling")
    fig_ivf_tradeoff(data)
    fig_hnsw_tradeoff(data)
    fig_hnsw_intra(data)
    fig_openmp_heatmap(data)
    fig_stage_breakdown(data)
    fig_build_latency(data)
    generate_tables(data)
    print(f"Figures written to {FIGS}")
    print(f"Tables written to {REPORT / 'pthread_report_tables.tex'}")


if __name__ == "__main__":
    main()
