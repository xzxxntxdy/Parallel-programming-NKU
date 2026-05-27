import asyncio
import csv
import statistics
import time
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import Callable

import matplotlib.pyplot as plt


REPEATS = 5

WAIT_TASKS = 2000
WAIT_SECONDS = 0.005
WAIT_THREAD_WORKERS = (50, 100, 500)

CPU_TASKS = 80
CPU_ITERATIONS = 120_000
CPU_THREAD_WORKERS = 8


def measure(fn: Callable[[], object]) -> float:
    start = time.perf_counter()
    fn()
    return time.perf_counter() - start


def summarize(key: str, label: str, group: str, samples: list[float]) -> dict[str, float | str]:
    return {
        "group": group,
        "key": key,
        "label": label,
        "repeats": REPEATS,
        "mean_s": statistics.mean(samples),
        "stdev_s": statistics.stdev(samples) if len(samples) > 1 else 0.0,
        "min_s": min(samples),
        "max_s": max(samples),
    }


async def async_wait_task() -> None:
    await asyncio.sleep(WAIT_SECONDS)


async def run_async_wait_tasks() -> None:
    await asyncio.gather(*(async_wait_task() for _ in range(WAIT_TASKS)))


def blocking_wait_task() -> None:
    time.sleep(WAIT_SECONDS)


def run_serial_wait_tasks() -> None:
    for _ in range(WAIT_TASKS):
        blocking_wait_task()


def run_threaded_wait_tasks(workers: int) -> None:
    with ThreadPoolExecutor(max_workers=workers) as pool:
        list(pool.map(lambda _: blocking_wait_task(), range(WAIT_TASKS)))


def wait_benchmarks() -> list[dict[str, float | str]]:
    scenarios: list[tuple[str, str, Callable[[], object]]] = [
        ("serial-wait", "Serial wait", run_serial_wait_tasks),
        *(
            (
                f"threadpool-wait-{workers}",
                f"ThreadPool wait {workers}",
                lambda workers=workers: run_threaded_wait_tasks(workers),
            )
            for workers in WAIT_THREAD_WORKERS
        ),
        ("asyncio-wait", "asyncio wait", lambda: asyncio.run(run_async_wait_tasks())),
    ]

    rows: list[dict[str, float | str]] = []
    for key, label, fn in scenarios:
        fn()
        samples = [measure(fn) for _ in range(REPEATS)]
        rows.append(summarize(key, label, "wait_bound", samples))
    return rows


def cpu_work(iterations: int = CPU_ITERATIONS) -> int:
    value = 0x12345678
    for i in range(iterations):
        value = ((value * 1664525) + i + 1013904223) & 0xFFFFFFFF
    return value


async def async_cpu_worker() -> int:
    return cpu_work()


async def run_async_cpu_tasks() -> list[int]:
    return await asyncio.gather(*(async_cpu_worker() for _ in range(CPU_TASKS)))


def run_serial_cpu_tasks() -> list[int]:
    return [cpu_work() for _ in range(CPU_TASKS)]


def run_threaded_cpu_tasks() -> list[int]:
    with ThreadPoolExecutor(max_workers=CPU_THREAD_WORKERS) as pool:
        return list(pool.map(lambda _: cpu_work(), range(CPU_TASKS)))


def cpu_benchmarks() -> list[dict[str, float | str]]:
    scenarios: list[tuple[str, str, Callable[[], object]]] = [
        ("serial-cpu", "Serial CPU", run_serial_cpu_tasks),
        ("asyncio-cpu", "asyncio CPU", lambda: asyncio.run(run_async_cpu_tasks())),
        (f"threadpool-cpu-{CPU_THREAD_WORKERS}", f"ThreadPool CPU {CPU_THREAD_WORKERS}", run_threaded_cpu_tasks),
    ]

    rows: list[dict[str, float | str]] = []
    for key, label, fn in scenarios:
        fn()
        samples = [measure(fn) for _ in range(REPEATS)]
        rows.append(summarize(key, label, "cpu_bound", samples))
    return rows


def write_csv(path: Path, rows: list[dict[str, float | str]]) -> None:
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def plot_group(path: Path, title: str, rows: list[dict[str, float | str]], colors: list[str]) -> None:
    labels = [str(row["label"]) for row in rows]
    means = [float(row["mean_s"]) for row in rows]
    stdevs = [float(row["stdev_s"]) for row in rows]

    fig, ax = plt.subplots(figsize=(8.6, 4.7))
    bars = ax.bar(labels, means, yerr=stdevs, capsize=4, color=colors, edgecolor="#111827", linewidth=0.6)
    ax.set_ylabel("Elapsed time (s)")
    ax.set_title(title)
    ax.grid(axis="y", linestyle="--", alpha=0.28)
    ax.set_axisbelow(True)

    for bar, value in zip(bars, means):
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            value,
            f"{value:.3f}s",
            ha="center",
            va="bottom",
            fontsize=9,
        )

    fig.tight_layout()
    fig.savefig(path.with_suffix(".pdf"))
    fig.savefig(path.with_suffix(".png"), dpi=240)
    plt.close(fig)


def plot_combined(path: Path, wait_rows: list[dict[str, float | str]], cpu_rows: list[dict[str, float | str]]) -> None:
    fig, axes = plt.subplots(1, 2, figsize=(12.2, 4.7))
    configs = [
        (
            axes[0],
            wait_rows,
            ["#9CA3AF", "#64748B", "#3B82F6", "#60A5FA", "#10B981"],
            f"Wait-bound: {WAIT_TASKS} tasks, {WAIT_SECONDS * 1000:.0f} ms each",
        ),
        (
            axes[1],
            cpu_rows,
            ["#9CA3AF", "#F97316", "#3B82F6"],
            f"CPU-bound: {CPU_TASKS} tasks, {CPU_ITERATIONS:,} Python-loop iterations",
        ),
    ]

    for ax, rows, colors, title in configs:
        labels = [
            str(row["label"])
            .replace("ThreadPool ", "Threads\n")
            .replace("asyncio ", "asyncio\n")
            .replace("Serial ", "Serial\n")
            for row in rows
        ]
        means = [float(row["mean_s"]) for row in rows]
        stdevs = [float(row["stdev_s"]) for row in rows]
        bars = ax.bar(labels, means, yerr=stdevs, capsize=4, color=colors, edgecolor="#111827", linewidth=0.6)
        ax.set_title(title)
        ax.set_ylabel("Elapsed time (s)")
        ax.grid(axis="y", linestyle="--", alpha=0.28)
        ax.set_axisbelow(True)
        for bar, value in zip(bars, means):
            ax.text(
                bar.get_x() + bar.get_width() / 2,
                value,
                f"{value:.3f}s",
                ha="center",
                va="bottom",
                fontsize=8.5,
            )

    fig.tight_layout()
    fig.savefig(path.with_suffix(".pdf"))
    fig.savefig(path.with_suffix(".png"), dpi=240)
    plt.close(fig)


def main() -> None:
    plt.rcParams.update(
        {
            "font.size": 10,
            "axes.spines.top": False,
            "axes.spines.right": False,
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
        }
    )

    output_dir = Path("figures")
    output_dir.mkdir(exist_ok=True)

    wait_rows = wait_benchmarks()
    cpu_rows = cpu_benchmarks()

    write_csv(output_dir / "wait_benchmark.csv", wait_rows)
    write_csv(output_dir / "cpu_bound_benchmark.csv", cpu_rows)
    write_csv(output_dir / "experiment_benchmarks.csv", wait_rows + cpu_rows)

    plot_group(
        output_dir / "wait_benchmark",
        f"{WAIT_TASKS} wait tasks, {WAIT_SECONDS * 1000:.0f} ms each, mean of {REPEATS} runs",
        wait_rows,
        ["#9CA3AF", "#64748B", "#3B82F6", "#60A5FA", "#10B981"],
    )
    plot_group(
        output_dir / "cpu_bound_benchmark",
        f"{CPU_TASKS} CPU-bound tasks, mean of {REPEATS} runs",
        cpu_rows,
        ["#9CA3AF", "#F97316", "#3B82F6"],
    )
    plot_combined(output_dir / "experiment_benchmarks", wait_rows, cpu_rows)

    for row in wait_rows + cpu_rows:
        print(f"{row['key']}: mean={float(row['mean_s']):.4f}s, stdev={float(row['stdev_s']):.4f}s")


if __name__ == "__main__":
    main()
