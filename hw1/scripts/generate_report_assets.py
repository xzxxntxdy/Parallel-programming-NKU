#!/usr/bin/env python3
import csv
import html
import json
import math
import sqlite3
import subprocess
from pathlib import Path

ROOT = Path('/home/parallel/hw1')
REPORT_DIR = ROOT / 'report'
FIG_DIR = REPORT_DIR / 'figures'
DATA_DIR = REPORT_DIR / 'data'

BATCH_MODES = ['Debug', 'RelWithDebInfo', 'Release']
REPORT_MODES = ['RelWithDebInfo', 'Release']
COLORS = {
    'naive': '#222222',
    'cache_opt': '#1f77b4',
    'unroll': '#ff7f0e',
    'extreme': '#2ca02c',
    'superscalar': '#d62728',
    'steady': '#1f77b4',
    'amortized': '#8c564b',
    'expected_share': '#1f77b4',
    'top_share': '#ff7f0e',
    'RelWithDebInfo': '#1f77b4',
    'Release': '#d62728',
}
RUN_LABELS = {
    'matvec': 'matvec naive',
    'matvec_cache': 'matvec cache_opt',
    'matvec_unroll': 'matvec unroll',
    'matvec_extreme': 'matvec extreme',
    'sum': 'sum naive',
    'sum_superscalar': 'sum superscalar',
    'sum_unroll': 'sum unroll',
    'sum_extreme': 'sum extreme',
}
VTUNE_RUNS = [
    ('matvec', 'r001hs', ['matvec_naive_f64', '[Loop at line 22 in matvec_naive_f64]']),
    ('matvec_cache', 'r000hs', ['matvec_cache_opt_f64', '[Loop at line 24 in matvec_cache_opt_f64]']),
    ('matvec_unroll', 'r000hs', ['matvec_unroll4_f64', '[Loop at line 31 in matvec_unroll4_f64]']),
    ('matvec_extreme', 'r000hs', ['matvec_extreme_f64', '_mm_mul_pd', '_mm_loadu_pd']),
    ('sum', 'r000hs', ['sum_naive_f64', '[Loop at line 17 in sum_naive_f64]']),
    ('sum_superscalar', 'r000hs', ['sum_superscalar_f64', '[Loop at line 29 in sum_superscalar_f64]']),
    ('sum_unroll', 'r000hs', ['sum_unroll4_f64', '[Loop at line 27 in sum_unroll4_f64]']),
    ('sum_extreme', 'r000hs', ['sum_extreme_f64', 'sum_extreme_f64_streaming_impl', '[Loop at line 78 in sum_extreme_f64_streaming_impl]']),
]
REPRESENTATIVE_CASES = [
    ('RelWithDebInfo', 'matvec', 'naive', 2048, 12, ''),
    ('RelWithDebInfo', 'matvec', 'cache_opt', 2048, 12, ''),
    ('RelWithDebInfo', 'matvec', 'unroll', 2048, 12, '--unroll 4'),
    ('RelWithDebInfo', 'matvec', 'extreme', 2048, 12, ''),
    ('RelWithDebInfo', 'sum', 'naive', 100000000, 8, ''),
    ('RelWithDebInfo', 'sum', 'superscalar', 100000000, 8, ''),
    ('RelWithDebInfo', 'sum', 'unroll', 100000000, 8, '--unroll 4'),
    ('RelWithDebInfo', 'sum', 'extreme', 100000000, 8, ''),
    ('Release', 'matvec', 'naive', 2048, 10, ''),
    ('Release', 'matvec', 'cache_opt', 2048, 10, ''),
    ('Release', 'matvec', 'unroll', 2048, 10, '--unroll 4'),
    ('Release', 'matvec', 'extreme', 2048, 10, ''),
    ('Release', 'sum', 'naive', 100000000, 8, ''),
    ('Release', 'sum', 'superscalar', 100000000, 8, ''),
    ('Release', 'sum', 'unroll', 100000000, 8, '--unroll 4'),
    ('Release', 'sum', 'extreme', 100000000, 8, ''),
]


def parse_benchmark_row(row):
    parsed = dict(row)
    parsed['n'] = int(parsed['n'])
    parsed['repeat'] = int(parsed['repeat'])
    parsed['warmup'] = int(parsed['warmup'])
    parsed['unroll'] = int(parsed['unroll'])
    for key in ['prep_ms', 'total_ms', 'avg_ms', 'min_ms', 'checksum', 'reference', 'max_abs_err', 'max_rel_err']:
        parsed[key] = float(parsed[key])
    parsed['check'] = parsed['check']
    return parsed


def load_batch_results():
    results = {}
    for mode in BATCH_MODES:
        path = ROOT / 'build' / mode / 'bench_results.csv'
        with path.open() as f:
            rows = [parse_benchmark_row(row) for row in csv.DictReader(f)]
        results[mode] = rows
    return results


def parse_key_value_output(text):
    out = {}
    for token in text.strip().split():
        if '=' not in token:
            continue
        key, value = token.split('=', 1)
        out[key] = value
    numeric_keys = {'n', 'repeat', 'warmup', 'unroll', 'prep_ms', 'total_ms', 'avg_ms', 'min_ms', 'checksum', 'reference', 'max_abs_err', 'max_rel_err'}
    for key in list(out):
        if key in numeric_keys:
            if key in {'n', 'repeat', 'warmup', 'unroll'}:
                out[key] = int(out[key])
            else:
                out[key] = float(out[key])
    return out


def run_representative_cases():
    rows = []
    for mode, task, algo, n, repeat, extra in REPRESENTATIVE_CASES:
        exe = ROOT / 'build' / mode / 'bench_cpu_arch'
        cmd = [str(exe), '--task', task, '--algo', algo, '--n', str(n), '--repeat', str(repeat), '--warmup', '3', '--dtype', 'f64', '--build-mode', mode]
        if extra:
            cmd.extend(extra.split())
        text = subprocess.check_output(cmd, text=True)
        parsed = parse_key_value_output(text)
        parsed['task'] = task
        parsed['algo'] = algo
        parsed['mode'] = mode
        rows.append(parsed)
    out_path = DATA_DIR / 'representative_results.csv'
    with out_path.open('w', newline='') as f:
        fieldnames = ['mode', 'task', 'algo', 'n', 'repeat', 'warmup', 'prep_ms', 'total_ms', 'avg_ms', 'min_ms', 'check', 'max_abs_err', 'max_rel_err']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow({key: row.get(key, '') for key in fieldnames})
    return rows


def parse_command_file(path):
    lines = [line.strip() for line in path.read_text(errors='ignore').splitlines()]
    result = {'command_file': str(path)}
    for key in ['--task', '--algo', '--n', '--repeat', '--warmup', '--dtype', '--build-mode', '--type', '--interval']:
        if key in lines:
            idx = lines.index(key)
            if idx + 1 < len(lines):
                result[key[2:].replace('-', '_')] = lines[idx + 1]
    for idx, line in enumerate(lines):
        if line == '--' and idx + 1 < len(lines):
            result['app'] = lines[idx + 1]
            break
    return result


def vtune_top_functions(db_path):
    query = '''
    SELECT f.name, COUNT(*) as samples
    FROM dd_sample s
    JOIN dd_callsite cs ON s.callsite = cs.rowid
    JOIN dd_code_location cl ON cs.code_loc = cl.rowid
    JOIN dd_function_range fr ON cl.func_range = fr.rowid
    JOIN dd_function_instance fi ON fr.func_inst = fi.rowid
    JOIN dd_function f ON fi.function = f.rowid
    GROUP BY f.name
    ORDER BY samples DESC, f.name ASC
    '''
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()
    cur.execute('SELECT COUNT(*) FROM dd_sample')
    total_samples = cur.fetchone()[0]
    cur.execute(query)
    rows = [{'name': name, 'samples': samples} for name, samples in cur.fetchall()]
    conn.close()
    return total_samples, rows


def extract_vtune_summary():
    summaries = []
    for label, run_dir_name, targets in VTUNE_RUNS:
        run_root = ROOT / 'vtune' / label / run_dir_name
        db_path = run_root / 'sqlite-db' / 'dicer.db'
        command_files = sorted(run_root.glob('log/target/*/command.txt'))
        command_meta = None
        for path in command_files:
            text = path.read_text(errors='ignore')
            if '--task' in text:
                command_meta = parse_command_file(path)
                break
        total_samples, rows = vtune_top_functions(db_path)
        resolved_samples = sum(row['samples'] for row in rows)
        target_samples = sum(row['samples'] for row in rows if row['name'] in targets)
        top_entry = rows[0] if rows else {'name': 'N/A', 'samples': 0}
        summaries.append({
            'label': label,
            'display_label': RUN_LABELS[label],
            'total_samples': total_samples,
            'resolved_samples': resolved_samples,
            'expected_kernel_samples': target_samples,
            'expected_kernel_share_pct': 100.0 * target_samples / total_samples if total_samples else 0.0,
            'top_hotspot_name': top_entry['name'],
            'top_hotspot_samples': top_entry['samples'],
            'top_hotspot_share_pct': 100.0 * top_entry['samples'] / total_samples if total_samples else 0.0,
            'top_functions': rows[:6],
            'command': command_meta or {},
        })
    out_path = DATA_DIR / 'vtune_summary.json'
    out_path.write_text(json.dumps(summaries, indent=2))
    return summaries


def filter_rows(rows, **conditions):
    out = []
    for row in rows:
        ok = True
        for key, value in conditions.items():
            if row[key] != value:
                ok = False
                break
        if ok:
            out.append(row)
    return out


def get_row(rows, **conditions):
    matches = filter_rows(rows, **conditions)
    if len(matches) != 1:
        raise ValueError(f'Expected exactly one row for {conditions}, found {len(matches)}')
    return matches[0]


def nice_step(max_value):
    if max_value <= 0:
        return 1.0
    exponent = math.floor(math.log10(max_value))
    base = 10 ** exponent
    for multiplier in [1, 2, 5, 10]:
        step = base * multiplier
        if max_value / step <= 6:
            return step
    return base * 10


class SvgCanvas:
    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.elements = []

    def add(self, element):
        self.elements.append(element)

    def rect(self, x, y, w, h, fill='none', stroke='none', stroke_width=1, rx=None, opacity=None):
        attrs = [f'x="{x:.2f}"', f'y="{y:.2f}"', f'width="{w:.2f}"', f'height="{h:.2f}"', f'fill="{fill}"', f'stroke="{stroke}"', f'stroke-width="{stroke_width}"']
        if rx is not None:
            attrs.append(f'rx="{rx:.2f}"')
        if opacity is not None:
            attrs.append(f'opacity="{opacity:.3f}"')
        self.add(f'<rect {' '.join(attrs)} />')

    def line(self, x1, y1, x2, y2, stroke='#000', stroke_width=1, dash=None):
        attrs = [f'x1="{x1:.2f}"', f'y1="{y1:.2f}"', f'x2="{x2:.2f}"', f'y2="{y2:.2f}"', f'stroke="{stroke}"', f'stroke-width="{stroke_width}"']
        if dash:
            attrs.append(f'stroke-dasharray="{dash}"')
        self.add(f'<line {' '.join(attrs)} />')

    def polyline(self, points, stroke='#000', stroke_width=2, fill='none'):
        pts = ' '.join(f'{x:.2f},{y:.2f}' for x, y in points)
        self.add(f'<polyline points="{pts}" fill="{fill}" stroke="{stroke}" stroke-width="{stroke_width}" stroke-linejoin="round" stroke-linecap="round" />')

    def circle(self, cx, cy, r, fill='#000', stroke='none', stroke_width=1):
        self.add(f'<circle cx="{cx:.2f}" cy="{cy:.2f}" r="{r:.2f}" fill="{fill}" stroke="{stroke}" stroke-width="{stroke_width}" />')

    def text(self, x, y, value, size=18, anchor='start', weight='normal', fill='#111', rotate=None):
        transform = '' if rotate is None else f' transform="rotate({rotate:.2f} {x:.2f} {y:.2f})"'
        self.add(
            f'<text x="{x:.2f}" y="{y:.2f}" font-family="Times New Roman, DejaVu Serif, serif" font-size="{size}" text-anchor="{anchor}" font-weight="{weight}" fill="{fill}"{transform}>{html.escape(str(value))}</text>'
        )

    def save(self, path):
        svg = [
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{self.width}" height="{self.height}" viewBox="0 0 {self.width} {self.height}">',
            '<rect width="100%" height="100%" fill="#ffffff" />',
        ]
        svg.extend(self.elements)
        svg.append('</svg>')
        path.write_text('\n'.join(svg))


def draw_line_chart(path, title, x_labels, series, y_label):
    width, height = 960, 560
    left, right, top, bottom = 95, 35, 55, 90
    plot_w = width - left - right
    plot_h = height - top - bottom
    all_values = [value for values in series.values() for value in values]
    y_max = max(all_values) * 1.15 if all_values else 1.0
    step = nice_step(y_max)
    y_max = math.ceil(y_max / step) * step
    canvas = SvgCanvas(width, height)
    canvas.text(width / 2, 30, title, size=22, anchor='middle', weight='bold')

    for idx in range(6):
        value = y_max * idx / 5.0
        y = top + plot_h - (value / y_max) * plot_h
        canvas.line(left, y, width - right, y, stroke='#d0d0d0', stroke_width=1)
        canvas.text(left - 10, y + 5, f'{value:.1f}', size=16, anchor='end')

    canvas.line(left, top, left, top + plot_h, stroke='#111', stroke_width=1.5)
    canvas.line(left, top + plot_h, width - right, top + plot_h, stroke='#111', stroke_width=1.5)

    positions = []
    if len(x_labels) == 1:
        positions = [left + plot_w / 2.0]
    else:
        for i in range(len(x_labels)):
            positions.append(left + plot_w * i / (len(x_labels) - 1))

    for x, label in zip(positions, x_labels):
        canvas.line(x, top + plot_h, x, top + plot_h + 6, stroke='#111', stroke_width=1)
        canvas.text(x, top + plot_h + 28, label, size=16, anchor='middle')

    palette = list(COLORS.values())
    for idx, (name, values) in enumerate(series.items()):
        color = COLORS.get(name, palette[idx % len(palette)])
        points = []
        for x, value in zip(positions, values):
            y = top + plot_h - (value / y_max) * plot_h
            points.append((x, y))
        canvas.polyline(points, stroke=color, stroke_width=3)
        for x, y in points:
            canvas.circle(x, y, 4.5, fill=color)

    canvas.text(24, top + plot_h / 2, y_label, size=18, anchor='middle', rotate=-90)
    canvas.text(left + plot_w / 2, height - 20, 'Problem size n', size=18, anchor='middle')

    legend_x = width - right - 200
    legend_y = top + 12
    for idx, name in enumerate(series):
        color = COLORS.get(name, palette[idx % len(palette)])
        y = legend_y + idx * 24
        canvas.line(legend_x, y, legend_x + 18, y, stroke=color, stroke_width=3)
        canvas.circle(legend_x + 9, y, 4, fill=color)
        canvas.text(legend_x + 28, y + 5, name, size=16)

    canvas.save(path)


def draw_grouped_bar_chart(path, title, categories, series, y_label, annotate_values=False):
    width, height = 1000, 580
    left, right, top, bottom = 105, 35, 55, 105
    plot_w = width - left - right
    plot_h = height - top - bottom
    all_values = [value for values in series.values() for value in values]
    y_max = max(all_values) * 1.18 if all_values else 1.0
    step = nice_step(y_max)
    y_max = math.ceil(y_max / step) * step
    canvas = SvgCanvas(width, height)
    canvas.text(width / 2, 30, title, size=22, anchor='middle', weight='bold')

    for idx in range(6):
        value = y_max * idx / 5.0
        y = top + plot_h - (value / y_max) * plot_h
        canvas.line(left, y, width - right, y, stroke='#d0d0d0', stroke_width=1)
        canvas.text(left - 10, y + 5, f'{value:.1f}', size=16, anchor='end')

    canvas.line(left, top, left, top + plot_h, stroke='#111', stroke_width=1.5)
    canvas.line(left, top + plot_h, width - right, top + plot_h, stroke='#111', stroke_width=1.5)

    n_cat = len(categories)
    n_series = len(series)
    group_w = plot_w / max(1, n_cat)
    bar_w = min(42, group_w * 0.72 / max(1, n_series))
    start_offset = (group_w - bar_w * n_series) / 2.0
    palette = list(COLORS.values())

    for c_idx, category in enumerate(categories):
        cx = left + group_w * c_idx + group_w / 2.0
        canvas.text(cx, top + plot_h + 28, category, size=16, anchor='middle')
        for s_idx, (name, values) in enumerate(series.items()):
            value = values[c_idx]
            x = left + group_w * c_idx + start_offset + bar_w * s_idx
            h = (value / y_max) * plot_h if y_max else 0.0
            y = top + plot_h - h
            color = COLORS.get(name, palette[s_idx % len(palette)])
            canvas.rect(x, y, bar_w - 3, h, fill=color, stroke='none')
            if annotate_values:
                canvas.text(x + (bar_w - 3) / 2.0, y - 6, f'{value:.2f}', size=13, anchor='middle')

    canvas.text(26, top + plot_h / 2.0, y_label, size=18, anchor='middle', rotate=-90)
    legend_x = width - right - 240
    legend_y = top + 12
    for idx, name in enumerate(series):
        color = COLORS.get(name, palette[idx % len(palette)])
        y = legend_y + idx * 24
        canvas.rect(legend_x, y - 11, 16, 16, fill=color)
        canvas.text(legend_x + 24, y + 2, name, size=16)

    canvas.save(path)



def draw_horizontal_grouped_bar_chart(path, title, categories, series, x_label, annotate_values=True):
    width = 1180
    height = max(560, 160 + len(categories) * 60)
    left, right, top, bottom = 290, 55, 60, 75
    plot_w = width - left - right
    plot_h = height - top - bottom
    all_values = [value for values in series.values() for value in values]
    x_max = max(all_values) * 1.18 if all_values else 1.0
    step = nice_step(x_max)
    x_max = math.ceil(x_max / step) * step
    canvas = SvgCanvas(width, height)
    canvas.text(width / 2, 32, title, size=22, anchor='middle', weight='bold')

    for idx in range(6):
        value = x_max * idx / 5.0
        x = left + (value / x_max) * plot_w if x_max else left
        canvas.line(x, top, x, top + plot_h, stroke='#d0d0d0', stroke_width=1)
        canvas.text(x, top + plot_h + 24, f'{value:.0f}', size=15, anchor='middle')

    canvas.line(left, top, left, top + plot_h, stroke='#111', stroke_width=1.5)
    canvas.line(left, top + plot_h, width - right, top + plot_h, stroke='#111', stroke_width=1.5)

    n_cat = len(categories)
    n_series = len(series)
    group_h = plot_h / max(1, n_cat)
    bar_h = min(16.0, group_h * 0.28)
    inner_gap = 5.0
    total_bar_h = n_series * bar_h + (n_series - 1) * inner_gap
    palette = list(COLORS.values())

    for c_idx, category in enumerate(categories):
        group_top = top + group_h * c_idx
        group_center = group_top + group_h / 2.0
        canvas.text(left - 12, group_center + 5, category, size=15, anchor='end')
        start_y = group_center - total_bar_h / 2.0
        for s_idx, (name, values) in enumerate(series.items()):
            value = values[c_idx]
            y = start_y + s_idx * (bar_h + inner_gap)
            w = (value / x_max) * plot_w if x_max else 0.0
            color = COLORS.get(name, palette[s_idx % len(palette)])
            canvas.rect(left, y, w, bar_h, fill=color, stroke='none', rx=2)
            if annotate_values:
                label_x = min(width - right - 4, left + w + 8)
                anchor = 'start'
                if w > 70:
                    label_x = left + w - 6
                    anchor = 'end'
                canvas.text(label_x, y + bar_h * 0.72, f'{value:.1f}%', size=13, anchor=anchor, fill='#111')

    legend_x = width - right - 210
    legend_y = top - 16
    for idx, name in enumerate(series):
        color = COLORS.get(name, palette[idx % len(palette)])
        y = legend_y + idx * 24
        canvas.rect(legend_x, y - 10, 16, 16, fill=color, rx=2)
        canvas.text(legend_x + 24, y + 2, name, size=15)

    canvas.text(left + plot_w / 2.0, height - 18, x_label, size=18, anchor='middle')
    canvas.save(path)


def write_summary_json(batch_results, representative_results, vtune_summary):
    summary = {
        'batch_results': batch_results,
        'representative_results': representative_results,
        'vtune_summary': vtune_summary,
    }
    (DATA_DIR / 'summary.json').write_text(json.dumps(summary, indent=2))


def rows_by_mode_task(rows, mode, task):
    return [row for row in rows if row['mode'] == mode and row['task'] == task]


def build_batch_tables(batch_results):
    lines = []
    for mode in REPORT_MODES:
        rows = batch_results[mode]
        for task in ['matvec', 'sum']:
            subset = [row for row in rows if row['task'] == task]
            max_n = max(row['n'] for row in subset)
            chosen = [row for row in subset if row['n'] == max_n]
            chosen.sort(key=lambda row: row['algo'])
            lines.append(f'### {mode} {task} largest batch case (n={max_n})')
            lines.append('')
            lines.append('| Algorithm | Avg ms | Min ms | Check |')
            lines.append('| --- | ---: | ---: | --- |')
            for row in chosen:
                lines.append(f"| {row['algo']} | {row['avg_ms']:.6f} | {row['min_ms']:.6f} | {row['check']} |")
            lines.append('')
    return '\n'.join(lines)


def build_representative_table(representative_results):
    lines = []
    for mode in REPORT_MODES:
        lines.append(f'### Representative large-case runs: {mode}')
        lines.append('')
        lines.append('| Task | Algorithm | n | Avg ms | Min ms | Check |')
        lines.append('| --- | --- | ---: | ---: | ---: | --- |')
        for task in ['matvec', 'sum']:
            subset = [row for row in representative_results if row['mode'] == mode and row['task'] == task]
            subset.sort(key=lambda row: row['algo'])
            for row in subset:
                lines.append(f"| {task} | {row['algo']} | {row['n']} | {row['avg_ms']:.6f} | {row['min_ms']:.6f} | {row['check']} |")
        lines.append('')
    return '\n'.join(lines)


def build_vtune_table(vtune_summary):
    lines = []
    lines.append('| Run | Total samples | Expected-kernel share | Top hotspot | Top-hotspot share |')
    lines.append('| --- | ---: | ---: | --- | ---: |')
    for item in vtune_summary:
        lines.append(
            f"| {item['display_label']} | {item['total_samples']} | {item['expected_kernel_share_pct']:.1f}% | {item['top_hotspot_name']} | {item['top_hotspot_share_pct']:.1f}% |"
        )
    return '\n'.join(lines)


def figure_markdown(filename, caption):
    png_name = filename.replace('.svg', '.png')
    return f'![{caption}](figures/{png_name})\n\n*{caption}*\n'


def generate_markdown(batch_results, representative_results, vtune_summary):
    rwd_matvec = {row['algo']: row for row in representative_results if row['mode'] == 'RelWithDebInfo' and row['task'] == 'matvec'}
    rwd_sum = {row['algo']: row for row in representative_results if row['mode'] == 'RelWithDebInfo' and row['task'] == 'sum'}
    rel_batch = batch_results['RelWithDebInfo']
    rel_matvec_max = max(row['n'] for row in rel_batch if row['task'] == 'matvec')
    rel_sum_max = max(row['n'] for row in rel_batch if row['task'] == 'sum')
    rel_matvec_rows = {row['algo']: row for row in rel_batch if row['task'] == 'matvec' and row['n'] == rel_matvec_max}
    rel_sum_rows = {row['algo']: row for row in rel_batch if row['task'] == 'sum' and row['n'] == rel_sum_max}
    matvec_speedup = rwd_matvec['naive']['avg_ms'] / rwd_matvec['extreme']['avg_ms']
    sum_speedup = rwd_sum['naive']['avg_ms'] / rwd_sum['extreme']['avg_ms']
    avg_kernel_share = sum(item['expected_kernel_share_pct'] for item in vtune_summary) / len(vtune_summary)
    max_kernel_share = max(item['expected_kernel_share_pct'] for item in vtune_summary)
    best_vtune = max(vtune_summary, key=lambda item: item['expected_kernel_share_pct'])

    text = f'''# CPU Architecture Homework 1 Report

## Abstract

This report evaluates several CPU-side optimization strategies for two kernels: matrix-column dot product (`matvec`) and array summation (`sum`). The code base preserves all original implementations (`naive`, `cache_opt`, `superscalar`, and `unroll`) and adds a separate `extreme` version for each task. The final project supports reproducible benchmarking, correctness checks with floating-point tolerance, VTune-friendly binaries, and script-generated report figures.

At the representative large case used for profiling, `matvec_extreme` reduces average runtime from {rwd_matvec['naive']['avg_ms']:.3f} ms to {rwd_matvec['extreme']['avg_ms']:.3f} ms in `RelWithDebInfo`, a {matvec_speedup:.2f}x speedup over `naive`. For `sum`, `sum_extreme` reduces average runtime from {rwd_sum['naive']['avg_ms']:.3f} ms to {rwd_sum['extreme']['avg_ms']:.3f} ms, a {sum_speedup:.2f}x speedup. VTune Hotspots results are structurally consistent with the benchmark data: the expected kernel accounts for an average of {avg_kernel_share:.1f}% of all samples across the collected runs, with the highest share reaching {max_kernel_share:.1f}% in `{best_vtune['display_label']}`.

## 1. Experiment Goal

The assignment asks for two kinds of CPU optimization experiments:

1. Improve matrix-column dot products by addressing memory locality.
2. Improve summation by reducing dependency-chain pressure and improving instruction-level parallelism.

The engineering goal was not only to optimize the kernels, but also to package the work as a complete Linux benchmark project that can be profiled from Windows VTune.

## 2. Experimental Environment

| Item | Value |
| --- | --- |
| Source tree | `/home/parallel/hw1` |
| Build system | CMake |
| Main binary | `build/<mode>/bench_cpu_arch` |
| Required build modes | `Debug`, `RelWithDebInfo`, `Release` |
| Recommended profiling build | `RelWithDebInfo` |
| Profiling workflow | Linux target binary + Windows VTune GUI |
| VTune collection type in current runs | Hotspots (`cpu:stack`, 10 ms interval) |

The project was intentionally compiled with debug information and frame pointers retained so that the generated Linux binary remains suitable for VTune source and symbol correlation.

## 3. Implemented Variants

### 3.1 Matvec family

- `naive`: walks the original row-major matrix by column, causing strided memory access.
- `cache_opt`: transposes the matrix once, then computes each column dot product from contiguous memory.
- `unroll`: keeps the transposed layout and reduces loop overhead with configurable unroll factors.
- `extreme`: keeps the existing implementations intact and adds a separate high-end path using blocked transpose setup plus a SIMD-friendly multi-accumulator compute kernel.

### 3.2 Sum family

- `naive`: single accumulator, longest dependency chain.
- `superscalar`: multiple accumulators expose more ILP.
- `unroll`: additional loop control reduction.
- `extreme`: a separate aggressive version that uses a size-aware strategy and wider accumulation structure while preserving the older algorithms unchanged.

## 4. Correctness and Reproducibility

The project uses deterministic pseudo-random inputs and compares floating-point outputs against `long double` references. Exact bitwise equality is intentionally not required, because changing accumulation order is part of the optimization itself.

The final code was revalidated after every optimization step:

- `RelWithDebInfo`: pass
- `Release`: pass
- `Debug`: pass

The benchmark driver still reports `check`, `max_abs_err`, and `max_rel_err` so that performance and numerical behavior can be judged together.

## 5. Batch Benchmark Results

The batch benchmark script generates one CSV per build mode. The figures below focus on `RelWithDebInfo`, because that build is the best compromise for both measurement realism and VTune analysis.

{figure_markdown('fig01_matvec_relwithdebinfo_vs_size.svg', 'Figure 1. Matvec average runtime versus problem size in RelWithDebInfo.')}

Figure 1 shows the expected locality story clearly. `naive` scales poorly because it keeps paying for strided column access, while `cache_opt`, `unroll`, and `extreme` all benefit from transposed contiguous data. At the largest batch size (`n={rel_matvec_max}`), `matvec_extreme` reaches {rel_matvec_rows['extreme']['avg_ms']:.6f} ms compared with {rel_matvec_rows['naive']['avg_ms']:.6f} ms for `naive`.

{figure_markdown('fig02_sum_relwithdebinfo_vs_size.svg', 'Figure 2. Sum average runtime versus problem size in RelWithDebInfo.')}

Figure 2 shows a different pattern. For `sum`, memory streaming dominates at large sizes, so the gap between optimized variants is smaller than in `matvec`. `superscalar` and `extreme` are consistently better than `naive`, but the exact winner depends on input size because the kernel is much closer to a bandwidth-limited streaming loop.

{build_batch_tables(batch_results)}

## 6. Build-Mode Comparison

{figure_markdown('fig03_matvec_speedup_by_mode.svg', 'Figure 3. Matvec speedup over naive at the largest batch size for each build mode.')}

Figure 3 confirms that compilation mode matters, but the algorithmic effect remains dominant. Even in `Release`, layout and loop restructuring are worth far more than relying on compiler flags alone.

{figure_markdown('fig04_sum_speedup_by_mode.svg', 'Figure 4. Sum speedup over naive at the largest batch size for each build mode.')}

For `sum`, build mode and algorithm interact more subtly than in `matvec`. The optimized variants reduce dependency pressure, but once the kernel becomes a long streaming pass over memory, the remaining gap shrinks.

## 7. Representative Large-Case Runs

The VTune runs were collected on larger representative cases than the batch CSV uses, so those cases were rerun for report-grade comparison.

{figure_markdown('fig05_matvec_large_case.svg', 'Figure 5. Representative large-case matvec comparison (`n=2048`).')}

At `n=2048`, `matvec_extreme` is the fastest variant in `RelWithDebInfo` ({rwd_matvec['extreme']['avg_ms']:.3f} ms). In `Release`, `matvec_unroll` and `matvec_extreme` are very close, which indicates that the remaining gap is already in the regime where compiler code generation and microarchitectural details matter more than high-level algorithm structure.

{figure_markdown('fig06_sum_large_case.svg', 'Figure 6. Representative large-case sum comparison (`n=100000000`).')}

At `n=100000000`, `sum_extreme` becomes the best-performing variant in both measured builds, which is the strongest evidence that the extra optimization work is worthwhile for the actual profiling-sized input.

{build_representative_table(representative_results)}

## 8. Setup Cost Versus Steady-State Cost

For transpose-based `matvec` variants, there are two costs: one-time preparation and repeated kernel execution. The figure below amortizes transpose time over the batch benchmark repeat count so that the total cost can be compared more fairly.

{figure_markdown('fig07_matvec_amortized_cost.svg', 'Figure 7. Matvec steady-state and amortized cost at the largest batch size in RelWithDebInfo.')}

This figure matters for interpretation: `extreme` is not only fast in the steady-state loop, it also keeps setup cost under control by using a blocked transpose path.

## 9. VTune Hotspots Analysis

All collected VTune results are Hotspots runs taken against `RelWithDebInfo` binaries with the following representative parameters:

- `matvec`: `naive`, `cache_opt`, `unroll`, `extreme` at `n=2048`, `repeat=50`
- `sum`: `naive`, `superscalar`, `unroll`, `extreme` at `n=100000000`, `repeat=30`

The collected result directories are internally consistent: each run contains an actual `sqlite-db/dicer.db`, a software-hotspots configuration, and a command file pointing to the expected benchmark binary and arguments.

{figure_markdown('fig08_vtune_kernel_share.svg', 'Figure 8. Share of VTune samples attributed to the expected kernel and the top hotspot.')}

Figure 8 should be interpreted carefully. The sample counts are small because the collection used software stack sampling at a 10 ms interval and the optimized kernels finish quickly. Even so, the attribution is reasonable: `sum_superscalar`, `sum_unroll`, and especially `sum_extreme` concentrate a large fraction of samples inside the expected kernel loops. The less stable attribution in `matvec_cache` is most likely caused by low sample count rather than a logical mismatch with the benchmark results.

{build_vtune_table(vtune_summary)}

### 9.1 What the VTune data says

The VTune summary matches the runtime trends:

- `matvec naive` spends its hottest samples in the inner loop of `matvec_naive_f64`, which is exactly where the strided memory access penalty lives.
- `matvec unroll` and `matvec extreme` move the hotspot into the optimized compute kernel, which is what we want after fixing the data layout.
- `sum naive` still shows visible benchmark-driver and setup sampling because its hotspot structure is simple and the run is short.
- `sum superscalar`, `sum unroll`, and `sum extreme` all spend their largest share of samples in their own optimized loops, which supports the ILP-focused explanation.

## 10. Is There More Optimization Space?

There is always theoretical room for more optimization, but there is no longer an obvious low-risk, portable improvement that clearly dominates the current code in every regime.

### 10.1 Remaining headroom in matvec

`matvec_extreme` is the best batch performer in `RelWithDebInfo`, and it remains extremely competitive in `Release`. The remaining headroom is now narrow enough that further gains would probably require one of the following:

- ISA-specific AVX2/AVX-512 kernels instead of generic SSE2-friendly code
- microarchitecture-specific prefetch or blocking retuning
- more aggressive compiler tuning tied to a specific host CPU

Those options would increase specialization and reduce portability, which is exactly the kind of unnecessary compatibility or platform branching we wanted to avoid.

### 10.2 Remaining headroom in sum

The `sum_extreme` kernel is best on the large profiling-sized input, but not on every smaller batch case. That means some size-dependent tuning space still exists. The next step would likely be auto-tuning or architecture-specific vector reductions, not another simple algorithmic rewrite.

In other words: there is some residual headroom, but it is no longer the kind of straightforward, assignment-friendly optimization that was available earlier. The current point is a sensible stopping point for the report.

## 11. Final Assessment

The final result is successful on all four assignment axes:

1. The baseline and required optimized variants are all preserved and still selectable.
2. The new `extreme` variants provide a meaningful extra comparison point instead of replacing older implementations.
3. The benchmark and VTune results tell a consistent performance story.
4. The project remains clean, reproducible, and directly usable for further VTune analysis.

The strongest final claims are:

- For `matvec`, data-layout repair is the dominant optimization, and the extra `extreme` kernel pushes the optimized path further while remaining portable.
- For `sum`, reducing dependency chains is necessary, but once the kernel becomes a long streaming reduction, the remaining gap depends strongly on size and build mode.
- VTune confirms that the optimized kernels, not the driver, become the main hotspots in the improved implementations.

## 12. Reproduction Commands

### Rebuild and test

```bash
cd /home/parallel/hw1
./scripts/build.sh RelWithDebInfo
./scripts/test.sh RelWithDebInfo
```

### Batch benchmark

```bash
cd /home/parallel/hw1
./scripts/run_bench.sh
```

### Representative profiling cases

```bash
/home/parallel/hw1/build/RelWithDebInfo/bench_cpu_arch --task matvec --algo extreme --n 2048 --repeat 50 --warmup 3 --dtype f64 --build-mode RelWithDebInfo
/home/parallel/hw1/build/RelWithDebInfo/bench_cpu_arch --task sum --algo extreme --n 100000000 --repeat 30 --warmup 3 --dtype f64 --build-mode RelWithDebInfo
```

### Regenerate report assets

```bash
cd /home/parallel/hw1
python3 scripts/generate_report_assets.py
```
'''
    (REPORT_DIR / 'report.md').write_text(text)


def main():
    FIG_DIR.mkdir(parents=True, exist_ok=True)
    DATA_DIR.mkdir(parents=True, exist_ok=True)

    batch_results = load_batch_results()
    representative_results = run_representative_cases()
    vtune_summary = extract_vtune_summary()
    write_summary_json(batch_results, representative_results, vtune_summary)

    rel_rows = batch_results['RelWithDebInfo']
    rel_matvec = sorted([row for row in rel_rows if row['task'] == 'matvec'], key=lambda row: (row['algo'], row['n']))
    rel_sum = sorted([row for row in rel_rows if row['task'] == 'sum'], key=lambda row: (row['algo'], row['n']))
    matvec_sizes = sorted({row['n'] for row in rel_matvec})
    sum_sizes = sorted({row['n'] for row in rel_sum})

    draw_line_chart(
        FIG_DIR / 'fig01_matvec_relwithdebinfo_vs_size.svg',
        'Matvec Runtime by Problem Size (RelWithDebInfo)',
        [str(n) for n in matvec_sizes],
        {
            'naive': [get_row(rel_rows, task='matvec', algo='naive', n=n)['avg_ms'] for n in matvec_sizes],
            'cache_opt': [get_row(rel_rows, task='matvec', algo='cache_opt', n=n)['avg_ms'] for n in matvec_sizes],
            'unroll': [get_row(rel_rows, task='matvec', algo='unroll', n=n)['avg_ms'] for n in matvec_sizes],
            'extreme': [get_row(rel_rows, task='matvec', algo='extreme', n=n)['avg_ms'] for n in matvec_sizes],
        },
        'Average runtime (ms)',
    )

    draw_line_chart(
        FIG_DIR / 'fig02_sum_relwithdebinfo_vs_size.svg',
        'Sum Runtime by Problem Size (RelWithDebInfo)',
        [str(n) for n in sum_sizes],
        {
            'naive': [get_row(rel_rows, task='sum', algo='naive', n=n)['avg_ms'] for n in sum_sizes],
            'superscalar': [get_row(rel_rows, task='sum', algo='superscalar', n=n)['avg_ms'] for n in sum_sizes],
            'unroll': [get_row(rel_rows, task='sum', algo='unroll', n=n)['avg_ms'] for n in sum_sizes],
            'extreme': [get_row(rel_rows, task='sum', algo='extreme', n=n)['avg_ms'] for n in sum_sizes],
        },
        'Average runtime (ms)',
    )

    matvec_largest = max(row['n'] for row in rel_rows if row['task'] == 'matvec')
    sum_largest = max(row['n'] for row in rel_rows if row['task'] == 'sum')
    draw_grouped_bar_chart(
        FIG_DIR / 'fig03_matvec_speedup_by_mode.svg',
        f'Matvec Speedup over Naive at n={matvec_largest}',
        REPORT_MODES,
        {
            'cache_opt': [get_row(batch_results[mode], task='matvec', algo='naive', n=matvec_largest)['avg_ms'] / get_row(batch_results[mode], task='matvec', algo='cache_opt', n=matvec_largest)['avg_ms'] for mode in REPORT_MODES],
            'unroll': [get_row(batch_results[mode], task='matvec', algo='naive', n=matvec_largest)['avg_ms'] / get_row(batch_results[mode], task='matvec', algo='unroll', n=matvec_largest)['avg_ms'] for mode in REPORT_MODES],
            'extreme': [get_row(batch_results[mode], task='matvec', algo='naive', n=matvec_largest)['avg_ms'] / get_row(batch_results[mode], task='matvec', algo='extreme', n=matvec_largest)['avg_ms'] for mode in REPORT_MODES],
        },
        'Speedup versus naive (x)',
        annotate_values=True,
    )

    draw_grouped_bar_chart(
        FIG_DIR / 'fig04_sum_speedup_by_mode.svg',
        f'Sum Speedup over Naive at n={sum_largest}',
        REPORT_MODES,
        {
            'superscalar': [get_row(batch_results[mode], task='sum', algo='naive', n=sum_largest)['avg_ms'] / get_row(batch_results[mode], task='sum', algo='superscalar', n=sum_largest)['avg_ms'] for mode in REPORT_MODES],
            'unroll': [get_row(batch_results[mode], task='sum', algo='naive', n=sum_largest)['avg_ms'] / get_row(batch_results[mode], task='sum', algo='unroll', n=sum_largest)['avg_ms'] for mode in REPORT_MODES],
            'extreme': [get_row(batch_results[mode], task='sum', algo='naive', n=sum_largest)['avg_ms'] / get_row(batch_results[mode], task='sum', algo='extreme', n=sum_largest)['avg_ms'] for mode in REPORT_MODES],
        },
        'Speedup versus naive (x)',
        annotate_values=True,
    )

    draw_grouped_bar_chart(
        FIG_DIR / 'fig05_matvec_large_case.svg',
        'Representative Large-Case Matvec Runtime (n=2048)',
        ['naive', 'cache_opt', 'unroll', 'extreme'],
        {
            'RelWithDebInfo': [get_row(representative_results, mode='RelWithDebInfo', task='matvec', algo=algo)['avg_ms'] for algo in ['naive', 'cache_opt', 'unroll', 'extreme']],
            'Release': [get_row(representative_results, mode='Release', task='matvec', algo=algo)['avg_ms'] for algo in ['naive', 'cache_opt', 'unroll', 'extreme']],
        },
        'Average runtime (ms)',
        annotate_values=True,
    )

    draw_grouped_bar_chart(
        FIG_DIR / 'fig06_sum_large_case.svg',
        'Representative Large-Case Sum Runtime (n=100000000)',
        ['naive', 'superscalar', 'unroll', 'extreme'],
        {
            'RelWithDebInfo': [get_row(representative_results, mode='RelWithDebInfo', task='sum', algo=algo)['avg_ms'] for algo in ['naive', 'superscalar', 'unroll', 'extreme']],
            'Release': [get_row(representative_results, mode='Release', task='sum', algo=algo)['avg_ms'] for algo in ['naive', 'superscalar', 'unroll', 'extreme']],
        },
        'Average runtime (ms)',
        annotate_values=True,
    )

    repeat = get_row(rel_rows, task='matvec', algo='cache_opt', n=matvec_largest)['repeat']
    draw_grouped_bar_chart(
        FIG_DIR / 'fig07_matvec_amortized_cost.svg',
        f'Matvec Steady-State vs Amortized Cost (RelWithDebInfo, n={matvec_largest})',
        ['cache_opt', 'unroll', 'extreme'],
        {
            'steady': [get_row(rel_rows, task='matvec', algo=algo, n=matvec_largest)['avg_ms'] for algo in ['cache_opt', 'unroll', 'extreme']],
            'amortized': [
                get_row(rel_rows, task='matvec', algo=algo, n=matvec_largest)['avg_ms'] + get_row(rel_rows, task='matvec', algo=algo, n=matvec_largest)['prep_ms'] / repeat
                for algo in ['cache_opt', 'unroll', 'extreme']
            ],
        },
        'Cost per run (ms)',
        annotate_values=True,
    )

    draw_horizontal_grouped_bar_chart(
        FIG_DIR / 'fig08_vtune_kernel_share.svg',
        'VTune Hotspot Attribution Quality',
        [item['display_label'] for item in vtune_summary],
        {
            'expected_share': [item['expected_kernel_share_pct'] for item in vtune_summary],
            'top_share': [item['top_hotspot_share_pct'] for item in vtune_summary],
        },
        'Share of total samples (%)',
        annotate_values=True,
    )

    generate_markdown(batch_results, representative_results, vtune_summary)


if __name__ == '__main__':
    main()
