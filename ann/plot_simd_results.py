#!/usr/bin/env python3
import sys
from plot_simd_paper import main as paper_main

if __name__ == "__main__":
    sys.exit(paper_main())

import csv
import math
import struct
import zlib
from collections import defaultdict
from pathlib import Path


CSV_PATH = Path("files/results/simd_results.csv")
OUT_DIR = Path("files/figures")


def mean(values):
    return sum(values) / len(values)


def stdev(values):
    if len(values) < 2:
        return 0.0
    m = mean(values)
    return math.sqrt(sum((v - m) * (v - m) for v in values) / (len(values) - 1))


def load_rows(path):
    rows = []
    numeric_fields = {
        "N", "d", "Q", "k", "M", "Ks", "p", "unroll", "prefetch",
        "run_id", "latency_ms", "recall", "index_size_mb", "build_time_sec",
        "coarse_ms", "rerank_ms", "cycles", "instructions", "cpi",
        "l1_miss_rate", "llc_miss_rate",
    }
    with path.open(newline="") as fin:
        for row in csv.DictReader(fin):
            for field in numeric_fields:
                if field in row and row[field] != "":
                    row[field] = float(row[field])
            rows.append(row)
    return rows


def aggregate(rows):
    groups = defaultdict(list)
    for row in rows:
        groups[row["method"]].append(row)

    result = []
    for method, items in groups.items():
        latencies = [item["latency_ms"] for item in items]
        recalls = [item["recall"] for item in items]
        coarse = [item.get("coarse_ms", 0.0) for item in items]
        rerank = [item.get("rerank_ms", 0.0) for item in items]
        build = [item.get("build_time_sec", 0.0) for item in items]
        index_sizes = [item.get("index_size_mb", 0.0) for item in items]
        first = items[0]
        result.append({
            "method": method,
            "platform": first["platform"],
            "N": first.get("N", 0.0),
            "d": first.get("d", 0.0),
            "Q": first.get("Q", 0.0),
            "k": first.get("k", 0.0),
            "M": first.get("M", 0.0),
            "Ks": first.get("Ks", 0.0),
            "p": first.get("p", 0.0),
            "unroll": first.get("unroll", 0.0),
            "prefetch": first.get("prefetch", 0.0),
            "topk": first.get("topk", ""),
            "latency_mean": mean(latencies),
            "latency_std": stdev(latencies),
            "recall_mean": mean(recalls),
            "recall_std": stdev(recalls),
            "index_size_mb": mean(index_sizes),
            "build_time_sec": mean(build),
            "coarse_ms": mean(coarse),
            "rerank_ms": mean(rerank),
        })
    result.sort(key=lambda x: x["latency_mean"])
    return result


def save_summary(summary):
    path = Path("files/results/simd_summary.csv")
    with path.open("w", newline="") as fout:
        writer = csv.DictWriter(
            fout,
            fieldnames=[
                "method",
                "platform",
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
                "latency_mean",
                "latency_std",
                "recall_mean",
                "recall_std",
                "index_size_mb",
                "build_time_sec",
                "coarse_ms",
                "rerank_ms",
            ],
        )
        writer.writeheader()
        for row in summary:
            writer.writerow(row)


def short_label(method):
    mapping = {
        "Flat-Scalar-NoVec": "Scalar",
        "Flat-AutoVec": "Auto",
        "Flat-Manual-NEON": "NEON",
        "Flat-NEON-AlignedHint": "Aligned",
        "Flat-NEON-Unroll2": "Unroll2",
        "Flat-NEON-Unroll4": "Unroll4",
        "Flat-NEON-Unroll4-Prefetch": "Prefetch",
        "Flat-NEON-Unroll4-Prefetch-FixedTopK": "FixedTopK",
        "Flat-Manual-SSE": "SSE",
        "Flat-Manual-AVX": "AVX",
    }
    if method.startswith("Flat-NEON-Unroll4-Prefetch-d"):
        return "pf" + method.rsplit("d", 1)[-1]
    if method.startswith("SQ8-rerank-p"):
        return "SQ p" + method.rsplit("p", 1)[-1]
    if method.startswith("SQ8-U8SIMD-rerank-p"):
        return "SQ-u8 p" + method.rsplit("p", 1)[-1]
    if method.startswith("PQ-ADC-M"):
        return method.replace("PQ-ADC-", "").replace("-p", " p")
    return mapping.get(method, method.replace("Flat-", ""))


def svg_header(width, height):
    return [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<style>',
        'text{font-family:Arial,Helvetica,sans-serif;font-size:12px;fill:#222}',
        '.axis{stroke:#222;stroke-width:1}',
        '.grid{stroke:#ddd;stroke-width:1}',
        '.bar{fill:#4c78a8}',
        '.point{fill:#4c78a8;stroke:#fff;stroke-width:1}',
        '.front{fill:none;stroke:#f58518;stroke-width:2}',
        '.err{stroke:#555;stroke-width:1}',
        '</style>',
    ]


def svg_footer():
    return ['</svg>']


def write_svg(path, lines):
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_png(path, width, height, pixels):
    def chunk(kind, data):
        body = kind + data
        return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body) & 0xffffffff)

    raw = bytearray()
    for y in range(height):
        raw.append(0)
        start = y * width * 3
        raw.extend(pixels[start:start + width * 3])

    data = b"".join([
        b"\x89PNG\r\n\x1a\n",
        chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)),
        chunk(b"IDAT", zlib.compress(bytes(raw), 9)),
        chunk(b"IEND", b""),
    ])
    path.write_bytes(data)


def write_pdf_image(path, width, height, pixels):
    image_data = zlib.compress(bytes(pixels), 9)
    content = f"q {width} 0 0 -{height} 0 {height} cm /Im0 Do Q\n".encode("ascii")
    objects = [
        b"<< /Type /Catalog /Pages 2 0 R >>",
        b"<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
        (
            f"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 {width} {height}] "
            f"/Resources << /XObject << /Im0 4 0 R >> >> /Contents 5 0 R >>"
        ).encode("ascii"),
        (
            f"<< /Type /XObject /Subtype /Image /Width {width} /Height {height} "
            f"/ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /FlateDecode "
            f"/Length {len(image_data)} >>\nstream\n"
        ).encode("ascii") + image_data + b"\nendstream",
        f"<< /Length {len(content)} >>\nstream\n".encode("ascii") + content + b"endstream",
    ]

    out = bytearray(b"%PDF-1.4\n")
    offsets = [0]
    for obj_id, obj in enumerate(objects, 1):
        offsets.append(len(out))
        out.extend(f"{obj_id} 0 obj\n".encode("ascii"))
        out.extend(obj)
        out.extend(b"\nendobj\n")
    xref = len(out)
    out.extend(f"xref\n0 {len(objects) + 1}\n".encode("ascii"))
    out.extend(b"0000000000 65535 f \n")
    for offset in offsets[1:]:
        out.extend(f"{offset:010d} 00000 n \n".encode("ascii"))
    out.extend(
        (
            f"trailer << /Size {len(objects) + 1} /Root 1 0 R >>\n"
            f"startxref\n{xref}\n%%EOF\n"
        ).encode("ascii")
    )
    path.write_bytes(bytes(out))


class Canvas:
    def __init__(self, width, height, bg=(255, 255, 255)):
        self.width = width
        self.height = height
        self.pixels = bytearray(bg * (width * height))

    def set_pixel(self, x, y, color):
        x = int(round(x))
        y = int(round(y))
        if 0 <= x < self.width and 0 <= y < self.height:
            idx = (y * self.width + x) * 3
            self.pixels[idx:idx + 3] = bytes(color)

    def line(self, x0, y0, x1, y1, color=(34, 34, 34), width=1):
        steps = int(max(abs(x1 - x0), abs(y1 - y0))) + 1
        if steps <= 0:
            return
        radius = max(0, width // 2)
        for i in range(steps + 1):
            t = i / steps
            x = x0 + (x1 - x0) * t
            y = y0 + (y1 - y0) * t
            for yy in range(-radius, radius + 1):
                for xx in range(-radius, radius + 1):
                    self.set_pixel(x + xx, y + yy, color)

    def rect(self, x, y, w, h, color):
        x0 = max(0, int(round(x)))
        y0 = max(0, int(round(y)))
        x1 = min(self.width, int(round(x + w)))
        y1 = min(self.height, int(round(y + h)))
        for yy in range(y0, y1):
            row = (yy * self.width + x0) * 3
            for _ in range(x0, x1):
                self.pixels[row:row + 3] = bytes(color)
                row += 3

    def circle(self, cx, cy, r, color):
        r2 = r * r
        for y in range(int(cy - r), int(cy + r) + 1):
            for x in range(int(cx - r), int(cx + r) + 1):
                if (x - cx) * (x - cx) + (y - cy) * (y - cy) <= r2:
                    self.set_pixel(x, y, color)

    def save(self, path):
        write_png(path, self.width, self.height, self.pixels)

    def save_pdf(self, path):
        write_pdf_image(path, self.width, self.height, self.pixels)


def scale(value, src0, src1, dst0, dst1):
    if abs(src1 - src0) < 1e-12:
        return (dst0 + dst1) / 2.0
    return dst0 + (value - src0) * (dst1 - dst0) / (src1 - src0)


def draw_axes(lines, left, top, right, bottom, xlabel, ylabel):
    lines.append(f'<line class="axis" x1="{left}" y1="{bottom}" x2="{right}" y2="{bottom}"/>')
    lines.append(f'<line class="axis" x1="{left}" y1="{top}" x2="{left}" y2="{bottom}"/>')
    lines.append(f'<text x="{(left + right) / 2}" y="{bottom + 48}" text-anchor="middle">{xlabel}</text>')
    lines.append(
        f'<text x="{left - 52}" y="{(top + bottom) / 2}" text-anchor="middle" transform="rotate(-90 {left - 52} {(top + bottom) / 2})">{ylabel}</text>'
    )


def plot_speedup(summary):
    order = [
        "Flat-Scalar-NoVec",
        "Flat-AutoVec",
        "Flat-Manual-SSE",
        "Flat-Manual-AVX",
        "Flat-Manual-NEON",
        "Flat-NEON-AlignedHint",
        "Flat-NEON-Unroll2",
        "Flat-NEON-Unroll4",
        "Flat-NEON-Unroll4-Prefetch",
        "Flat-NEON-Unroll4-Prefetch-FixedTopK",
        "Flat-NEON-Unroll4-Prefetch-d4",
        "Flat-NEON-Unroll4-Prefetch-d8",
        "Flat-NEON-Unroll4-Prefetch-d16",
        "Flat-NEON-Unroll4-Prefetch-d32",
        "Flat-NEON-Unroll4-Prefetch-d64",
    ]
    by_method = {row["method"]: row for row in summary}
    base = by_method["Flat-Scalar-NoVec"]["latency_mean"]
    labels = [m for m in order if m in by_method]
    speedups = [base / by_method[m]["latency_mean"] for m in labels]

    short = [short_label(label) for label in labels]

    width, height = 760, 430
    left, right, top, bottom = 78, 730, 44, 330
    ymax = max(speedups) * 1.2
    lines = svg_header(width, height)
    lines.append('<text x="380" y="24" text-anchor="middle">Flat SIMD Speedup Breakdown</text>')
    draw_axes(lines, left, top, right, bottom, "Method", "Speedup over scalar")
    for tick in range(0, int(math.ceil(ymax)) + 1):
        y = scale(tick, 0, ymax, bottom, top)
        lines.append(f'<line class="grid" x1="{left}" y1="{y:.1f}" x2="{right}" y2="{y:.1f}"/>')
        lines.append(f'<text x="{left - 8}" y="{y + 4:.1f}" text-anchor="end">{tick}</text>')
    bar_w = (right - left) / (len(short) * 1.5)
    gap = (right - left - len(short) * bar_w) / (len(short) + 1)
    for i, (label, val) in enumerate(zip(short, speedups)):
        x = left + gap + i * (bar_w + gap)
        y = scale(val, 0, ymax, bottom, top)
        lines.append(f'<rect class="bar" x="{x:.1f}" y="{y:.1f}" width="{bar_w:.1f}" height="{bottom - y:.1f}"/>')
        lines.append(f'<text x="{x + bar_w / 2:.1f}" y="{y - 6:.1f}" text-anchor="middle">{val:.2f}x</text>')
        lines.append(f'<text x="{x + bar_w / 2:.1f}" y="{bottom + 18}" text-anchor="middle">{label}</text>')
    lines.extend(svg_footer())
    write_svg(OUT_DIR / "fig_flat_speedup.svg", lines)

    canvas = Canvas(width, height)
    canvas.line(left, bottom, right, bottom, width=2)
    canvas.line(left, top, left, bottom, width=2)
    for tick in range(0, int(math.ceil(ymax)) + 1):
        y = scale(tick, 0, ymax, bottom, top)
        canvas.line(left, y, right, y, color=(224, 224, 224))
    for i, val in enumerate(speedups):
        x = left + gap + i * (bar_w + gap)
        y = scale(val, 0, ymax, bottom, top)
        canvas.rect(x, y, bar_w, bottom - y, (76, 120, 168))
    canvas.save(OUT_DIR / "fig_flat_speedup.png")
    canvas.save_pdf(OUT_DIR / "fig_flat_speedup.pdf")


def plot_latency_recall(summary):
    width, height = 760, 430
    left, right, top, bottom = 86, 710, 44, 330
    xmin = min(row["latency_mean"] - row["latency_std"] for row in summary) * 0.95
    xmax = max(row["latency_mean"] + row["latency_std"] for row in summary) * 1.05
    min_recall = min(row["recall_mean"] - row["recall_std"] for row in summary)
    ymin, ymax = max(0.0, min(0.98, min_recall - 0.05)), 1.005
    lines = svg_header(width, height)
    lines.append('<text x="380" y="24" text-anchor="middle">Latency-Recall Trade-off</text>')
    draw_axes(lines, left, top, right, bottom, "Latency per query (ms)", "Recall@10")
    for tick in range(0, 6):
        yval = ymin + tick * (ymax - ymin) / 5.0
        y = scale(yval, ymin, ymax, bottom, top)
        lines.append(f'<line class="grid" x1="{left}" y1="{y:.1f}" x2="{right}" y2="{y:.1f}"/>')
        lines.append(f'<text x="{left - 8}" y="{y + 4:.1f}" text-anchor="end">{yval:.3f}</text>')
    for tick in range(0, 6):
        xval = xmin + tick * (xmax - xmin) / 5.0
        x = scale(xval, xmin, xmax, left, right)
        lines.append(f'<line class="grid" x1="{x:.1f}" y1="{top}" x2="{x:.1f}" y2="{bottom}"/>')
        lines.append(f'<text x="{x:.1f}" y="{bottom + 18}" text-anchor="middle">{xval:.1f}</text>')
    for i, row in enumerate(summary):
        x = scale(row["latency_mean"], xmin, xmax, left, right)
        y = scale(row["recall_mean"], ymin, ymax, bottom, top)
        x0 = scale(row["latency_mean"] - row["latency_std"], xmin, xmax, left, right)
        x1 = scale(row["latency_mean"] + row["latency_std"], xmin, xmax, left, right)
        lines.append(f'<line class="err" x1="{x0:.1f}" y1="{y:.1f}" x2="{x1:.1f}" y2="{y:.1f}"/>')
        lines.append(f'<circle class="point" cx="{x:.1f}" cy="{y:.1f}" r="5"/>')
        lines.append(f'<text x="{x + 7:.1f}" y="{y - 7 - (i % 2) * 10:.1f}">{short_label(row["method"])}</text>')
    lines.extend(svg_footer())
    write_svg(OUT_DIR / "fig_latency_recall.svg", lines)

    canvas = Canvas(width, height)
    canvas.line(left, bottom, right, bottom, width=2)
    canvas.line(left, top, left, bottom, width=2)
    for tick in range(0, 6):
        yval = ymin + tick * (ymax - ymin) / 5.0
        y = scale(yval, ymin, ymax, bottom, top)
        canvas.line(left, y, right, y, color=(224, 224, 224))
    for tick in range(0, 6):
        xval = xmin + tick * (xmax - xmin) / 5.0
        x = scale(xval, xmin, xmax, left, right)
        canvas.line(x, top, x, bottom, color=(224, 224, 224))
    for row in summary:
        x = scale(row["latency_mean"], xmin, xmax, left, right)
        y = scale(row["recall_mean"], ymin, ymax, bottom, top)
        x0 = scale(row["latency_mean"] - row["latency_std"], xmin, xmax, left, right)
        x1 = scale(row["latency_mean"] + row["latency_std"], xmin, xmax, left, right)
        canvas.line(x0, y, x1, y, color=(85, 85, 85))
        canvas.circle(x, y, 5, (76, 120, 168))
    canvas.save(OUT_DIR / "fig_latency_recall.png")
    canvas.save_pdf(OUT_DIR / "fig_latency_recall.pdf")


def plot_pareto(summary):
    points = sorted(summary, key=lambda row: row["latency_mean"])
    frontier = []
    best_recall = -1.0
    for row in points:
        if row["recall_mean"] > best_recall:
            frontier.append(row)
            best_recall = row["recall_mean"]

    width, height = 760, 430
    left, right, top, bottom = 86, 710, 44, 330
    xmin = min(row["latency_mean"] for row in points) * 0.95
    xmax = max(row["latency_mean"] for row in points) * 1.05
    min_recall = min(row["recall_mean"] for row in points)
    ymin, ymax = max(0.0, min(0.98, min_recall - 0.05)), 1.005
    lines = svg_header(width, height)
    lines.append('<text x="380" y="24" text-anchor="middle">Pareto Frontier</text>')
    draw_axes(lines, left, top, right, bottom, "Latency per query (ms)", "Recall@10")
    for tick in range(0, 6):
        yval = ymin + tick * (ymax - ymin) / 5.0
        y = scale(yval, ymin, ymax, bottom, top)
        lines.append(f'<line class="grid" x1="{left}" y1="{y:.1f}" x2="{right}" y2="{y:.1f}"/>')
        lines.append(f'<text x="{left - 8}" y="{y + 4:.1f}" text-anchor="end">{yval:.3f}</text>')
    for tick in range(0, 6):
        xval = xmin + tick * (xmax - xmin) / 5.0
        x = scale(xval, xmin, xmax, left, right)
        lines.append(f'<line class="grid" x1="{x:.1f}" y1="{top}" x2="{x:.1f}" y2="{bottom}"/>')
        lines.append(f'<text x="{x:.1f}" y="{bottom + 18}" text-anchor="middle">{xval:.1f}</text>')
    if frontier:
        path = []
        for row in frontier:
            x = scale(row["latency_mean"], xmin, xmax, left, right)
            y = scale(row["recall_mean"], ymin, ymax, bottom, top)
            path.append(f'{x:.1f},{y:.1f}')
        lines.append(f'<polyline class="front" points="{" ".join(path)}"/>')
    for row in points:
        x = scale(row["latency_mean"], xmin, xmax, left, right)
        y = scale(row["recall_mean"], ymin, ymax, bottom, top)
        lines.append(f'<circle class="point" cx="{x:.1f}" cy="{y:.1f}" r="5"/>')
        lines.append(f'<text x="{x + 7:.1f}" y="{y - 7:.1f}">{short_label(row["method"])}</text>')
    lines.append('<line x1="500" y1="385" x2="535" y2="385" class="front"/>')
    lines.append('<text x="542" y="389">Pareto frontier</text>')
    lines.extend(svg_footer())
    write_svg(OUT_DIR / "fig_pareto_frontier.svg", lines)

    canvas = Canvas(width, height)
    canvas.line(left, bottom, right, bottom, width=2)
    canvas.line(left, top, left, bottom, width=2)
    for tick in range(0, 6):
        yval = ymin + tick * (ymax - ymin) / 5.0
        y = scale(yval, ymin, ymax, bottom, top)
        canvas.line(left, y, right, y, color=(224, 224, 224))
    for tick in range(0, 6):
        xval = xmin + tick * (xmax - xmin) / 5.0
        x = scale(xval, xmin, xmax, left, right)
        canvas.line(x, top, x, bottom, color=(224, 224, 224))
    if len(frontier) > 1:
        last = frontier[0]
        for row in frontier[1:]:
            x0 = scale(last["latency_mean"], xmin, xmax, left, right)
            y0 = scale(last["recall_mean"], ymin, ymax, bottom, top)
            x1 = scale(row["latency_mean"], xmin, xmax, left, right)
            y1 = scale(row["recall_mean"], ymin, ymax, bottom, top)
            canvas.line(x0, y0, x1, y1, color=(245, 133, 24), width=3)
            last = row
    for row in points:
        x = scale(row["latency_mean"], xmin, xmax, left, right)
        y = scale(row["recall_mean"], ymin, ymax, bottom, top)
        canvas.circle(x, y, 5, (76, 120, 168))
    canvas.save(OUT_DIR / "fig_pareto_frontier.png")
    canvas.save_pdf(OUT_DIR / "fig_pareto_frontier.pdf")


def quant_family(row):
    method = row["method"]
    if method.startswith("SQ8"):
        return "SQ8"
    if method.startswith("PQ-ADC-M"):
        return f"PQ-M{int(row.get('M', 0))}"
    return ""


def plot_rerank_sensitivity(summary):
    groups = defaultdict(list)
    for row in summary:
        family = quant_family(row)
        if family and row.get("p", 0) > 0:
            groups[family].append(row)
    if not groups:
        return

    width, height = 760, 430
    left, right, top, bottom = 86, 710, 44, 330
    pvals = [row["p"] for items in groups.values() for row in items]
    recalls = [row["recall_mean"] for items in groups.values() for row in items]
    xmin, xmax = min(pvals) * 0.85, max(pvals) * 1.05
    ymin, ymax = max(0.0, min(recalls) - 0.05), 1.005
    colors = ["#4c78a8", "#f58518", "#54a24b", "#b279a2"]
    rgb = [(76, 120, 168), (245, 133, 24), (84, 162, 75), (178, 121, 162)]

    lines = svg_header(width, height)
    lines.append('<text x="380" y="24" text-anchor="middle">Rerank Sensitivity</text>')
    draw_axes(lines, left, top, right, bottom, "Top-p candidates", "Recall@10")
    for tick in range(0, 6):
        yval = ymin + tick * (ymax - ymin) / 5.0
        y = scale(yval, ymin, ymax, bottom, top)
        lines.append(f'<line class="grid" x1="{left}" y1="{y:.1f}" x2="{right}" y2="{y:.1f}"/>')
        lines.append(f'<text x="{left - 8}" y="{y + 4:.1f}" text-anchor="end">{yval:.3f}</text>')
    for p in sorted(set(pvals)):
        x = scale(p, xmin, xmax, left, right)
        lines.append(f'<line class="grid" x1="{x:.1f}" y1="{top}" x2="{x:.1f}" y2="{bottom}"/>')
        lines.append(f'<text x="{x:.1f}" y="{bottom + 18}" text-anchor="middle">{int(p)}</text>')

    canvas = Canvas(width, height)
    canvas.line(left, bottom, right, bottom, width=2)
    canvas.line(left, top, left, bottom, width=2)
    for tick in range(0, 6):
        yval = ymin + tick * (ymax - ymin) / 5.0
        y = scale(yval, ymin, ymax, bottom, top)
        canvas.line(left, y, right, y, color=(224, 224, 224))
    for idx, (family, items) in enumerate(sorted(groups.items())):
        items = sorted(items, key=lambda row: row["p"])
        color = colors[idx % len(colors)]
        color_rgb = rgb[idx % len(rgb)]
        points = []
        for row in items:
            x = scale(row["p"], xmin, xmax, left, right)
            y = scale(row["recall_mean"], ymin, ymax, bottom, top)
            points.append((x, y))
            lines.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="5" fill="{color}" stroke="#fff"/>')
            canvas.circle(x, y, 5, color_rgb)
        if len(points) > 1:
            poly = " ".join(f"{x:.1f},{y:.1f}" for x, y in points)
            lines.append(f'<polyline points="{poly}" fill="none" stroke="{color}" stroke-width="2"/>')
            for a, b in zip(points, points[1:]):
                canvas.line(a[0], a[1], b[0], b[1], color=color_rgb, width=3)
        ly = 366 + idx * 17
        lines.append(f'<line x1="510" y1="{ly}" x2="540" y2="{ly}" stroke="{color}" stroke-width="2"/>')
        lines.append(f'<text x="548" y="{ly + 4}">{family}</text>')

    lines.extend(svg_footer())
    write_svg(OUT_DIR / "fig_rerank_sensitivity.svg", lines)
    canvas.save(OUT_DIR / "fig_rerank_sensitivity.png")
    canvas.save_pdf(OUT_DIR / "fig_rerank_sensitivity.pdf")


def estimate_roofline_rows(summary):
    rows = []
    for row in summary:
        method = row["method"]
        n = float(row.get("N", 100000) or 100000)
        d = float(row.get("d", 96) or 96)
        p = float(row.get("p", 0) or 0)
        m = float(row.get("M", 0) or 0)
        ks = float(row.get("Ks", 256) or 256)
        latency_s = max(row["latency_mean"] / 1000.0, 1e-12)
        if method.startswith("Flat"):
            family = "Flat"
            bytes_per_query = n * d * 4.0
            ops_per_query = n * d * 2.0
        elif method.startswith("SQ8"):
            family = "SQ8"
            bytes_per_query = n * d + p * d * 4.0
            ops_per_query = n * d + p * d * 2.0
        elif method.startswith("PQ-ADC"):
            family = "PQ"
            bytes_per_query = n * m + p * d * 4.0 + m * ks * 4.0
            ops_per_query = n * m + p * d * 2.0 + ks * d * 2.0
        else:
            continue
        arithmetic_intensity = ops_per_query / max(bytes_per_query, 1.0)
        rows.append({
            "method": method,
            "family": family,
            "latency_ms": row["latency_mean"],
            "ops_per_query": ops_per_query,
            "bytes_per_query": bytes_per_query,
            "arithmetic_intensity": arithmetic_intensity,
            "effective_gops": ops_per_query / latency_s / 1e9,
            "effective_bandwidth_gbs": bytes_per_query / latency_s / 1e9,
        })
    return rows


def save_roofline_csv(rows):
    path = Path("files/results/simd_roofline.csv")
    with path.open("w", newline="") as fout:
        writer = csv.DictWriter(
            fout,
            fieldnames=[
                "method", "family", "latency_ms", "ops_per_query",
                "bytes_per_query", "arithmetic_intensity",
                "effective_gops", "effective_bandwidth_gbs",
            ],
        )
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def plot_roofline(summary):
    rows = estimate_roofline_rows(summary)
    save_roofline_csv(rows)
    if not rows:
        return
    width, height = 760, 430
    left, right, top, bottom = 92, 710, 44, 330
    xs = [math.log10(max(row["arithmetic_intensity"], 1e-9)) for row in rows]
    ys = [math.log10(max(row["effective_gops"], 1e-9)) for row in rows]
    xmin, xmax = min(xs) - 0.08, max(xs) + 0.08
    ymin, ymax = min(ys) - 0.08, max(ys) + 0.08
    family_colors = {
        "Flat": ("#4c78a8", (76, 120, 168)),
        "SQ8": ("#54a24b", (84, 162, 75)),
        "PQ": ("#f58518", (245, 133, 24)),
    }
    lines = svg_header(width, height)
    lines.append('<text x="380" y="24" text-anchor="middle">Roofline Proxy from Measured Latency</text>')
    draw_axes(lines, left, top, right, bottom, "log10 ops/byte", "log10 effective GOPS")
    for tick in range(0, 6):
        xval = xmin + tick * (xmax - xmin) / 5.0
        x = scale(xval, xmin, xmax, left, right)
        lines.append(f'<line class="grid" x1="{x:.1f}" y1="{top}" x2="{x:.1f}" y2="{bottom}"/>')
        lines.append(f'<text x="{x:.1f}" y="{bottom + 18}" text-anchor="middle">{xval:.2f}</text>')
        yval = ymin + tick * (ymax - ymin) / 5.0
        y = scale(yval, ymin, ymax, bottom, top)
        lines.append(f'<line class="grid" x1="{left}" y1="{y:.1f}" x2="{right}" y2="{y:.1f}"/>')
        lines.append(f'<text x="{left - 8}" y="{y + 4:.1f}" text-anchor="end">{yval:.2f}</text>')

    canvas = Canvas(width, height)
    canvas.line(left, bottom, right, bottom, width=2)
    canvas.line(left, top, left, bottom, width=2)
    for row in rows:
        x = scale(math.log10(max(row["arithmetic_intensity"], 1e-9)), xmin, xmax, left, right)
        y = scale(math.log10(max(row["effective_gops"], 1e-9)), ymin, ymax, bottom, top)
        color, color_rgb = family_colors[row["family"]]
        lines.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="5" fill="{color}" stroke="#fff"/>')
        lines.append(f'<text x="{x + 7:.1f}" y="{y - 7:.1f}">{short_label(row["method"])}</text>')
        canvas.circle(x, y, 5, color_rgb)
    for idx, family in enumerate(["Flat", "SQ8", "PQ"]):
        color, _ = family_colors[family]
        ly = 364 + idx * 17
        lines.append(f'<circle cx="520" cy="{ly}" r="5" fill="{color}"/>')
        lines.append(f'<text x="532" y="{ly + 4}">{family}</text>')
    lines.extend(svg_footer())
    write_svg(OUT_DIR / "fig_roofline_proxy.svg", lines)
    canvas.save(OUT_DIR / "fig_roofline_proxy.png")
    canvas.save_pdf(OUT_DIR / "fig_roofline_proxy.pdf")


def main():
    if not CSV_PATH.exists():
        raise SystemExit(f"missing {CSV_PATH}; run bash test.sh 1 1 first")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    rows = load_rows(CSV_PATH)
    summary = aggregate(rows)
    save_summary(summary)
    plot_speedup(summary)
    plot_latency_recall(summary)
    plot_pareto(summary)
    plot_rerank_sensitivity(summary)
    plot_roofline(summary)
    print(f"wrote SVG, PNG and PDF figures to {OUT_DIR}")
    print("wrote summary to files/results/simd_summary.csv")


if __name__ == "__main__":
    main()
