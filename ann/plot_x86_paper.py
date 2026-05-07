#!/usr/bin/env python3
"""Generate all required paper figures from ARM + x86 ANN SIMD benchmark data."""
import numpy as np
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter
import os, sys, json

# --- Config ---
FIGS_DIR = "D:/Parallel-programming-NKU/ann/files/figures"
ARM_CSV  = "D:/Parallel-programming-NKU/ann/files/results/simd_results.csv"
X86_CSV  = "D:/Parallel-programming-NKU/ann/files/results/x86_results.csv"
PERF_CSV = "D:/Parallel-programming-NKU/ann/files/results/perf_summary.csv"

os.makedirs(FIGS_DIR, exist_ok=True)

plt.rcParams.update({
    'font.size': 11, 'axes.titlesize': 13, 'axes.labelsize': 12,
    'legend.fontsize': 9, 'figure.dpi': 150, 'savefig.dpi': 150,
    'savefig.bbox': 'tight', 'font.family': 'serif',
})

def save(name):
    for ext in ['png', 'pdf']:
        plt.savefig(f"{FIGS_DIR}/fig_{name}.{ext}")
    print(f"  Saved fig_{name}.png/pdf")
    plt.close()

# --- Load Data ---
arm = pd.read_csv(ARM_CSV)
x86 = pd.read_csv(X86_CSV)

# Clean x86 data: group by (method, family, M, p, block) and take mean across repeats
x86_flat = x86[x86.family == 'flat'].groupby(['method','prefetch','topk']).agg(
    latency_ms=('latency_ms','mean'), recall=('recall','mean'),
    latency_std=('latency_ms','std')).reset_index()

x86_sq8 = x86[x86.family == 'sq8'].groupby(['method','p']).agg(
    latency_ms=('latency_ms','mean'), recall=('recall','mean'),
    scan_ms=('scan_ms','mean'), rerank_ms=('rerank_ms','mean')).reset_index()

x86_pq = x86[x86.family.isin(['pq','pqsel'])].groupby(['method','family','M','p']).agg(
    latency_ms=('latency_ms','mean'), recall=('recall','mean'),
    lut_ms=('lut_ms','mean'), scan_ms=('scan_ms','mean'),
    select_ms=('select_ms','mean'), rerank_ms=('rerank_ms','mean')).reset_index()

x86_sdc = x86[x86.family == 'sdc'].groupby(['method','M','p']).agg(
    latency_ms=('latency_ms','mean'), recall=('recall','mean'),
    encode_ms=('encode_ms','mean'), scan_ms=('scan_ms','mean'),
    rerank_ms=('rerank_ms','mean')).reset_index()

x86_fs = x86[x86.family == 'fsadc'].groupby(['method','M','p','block']).agg(
    latency_ms=('latency_ms','mean'), recall=('recall','mean'),
    lut_ms=('lut_ms','mean'), scan_ms=('scan_ms','mean'),
    rerank_ms=('rerank_ms','mean')).reset_index()

# ARM data: group by method for flat
arm_flat = arm[arm.M == 0].groupby('method').agg(
    latency_ms=('latency_ms','mean'), recall=('recall','mean')).reset_index()

arm_pq = arm[arm.M > 0].copy()
arm_pq['label'] = arm_pq['method'].str.replace('PQ-ADC-M','').str.replace('-p','_')

# ============================================================
# Figure 1: Flat Speedup (dual-platform)
# ============================================================
print("Figure 1: Flat Speedup")
fig, ax = plt.subplots(figsize=(10, 6))

# ARM flat
arm_methods = ['Flat-Scalar-NoVec','Flat-AutoVec','Flat-Manual-NEON',
               'Flat-NEON-Unroll4','Flat-NEON-Unroll4-Prefetch',
               'Flat-NEON-Unroll4-Prefetch-FixedTopK']
arm_lats = {}
for m in arm_methods:
    d = arm_flat[arm_flat.method == m]
    if len(d) > 0: arm_lats[m] = d.latency_ms.values[0]

# x86 flat
x86_methods = {'Flat-Scalar': 'Flat-Scalar',
               'Flat-AutoVec': 'Flat-AutoVec',
               'Flat-SSE': 'Flat-SSE',
               'Flat-AVX': 'Flat-AVX'}
x86_lats = {}
for name, filt in x86_methods.items():
    d = x86_flat[x86_flat.method.str.contains(filt, case=False)]
    d2 = d[d.topk == 'heap']
    if len(d2) > 0: x86_lats[name] = d2.latency_ms.min()

# Plot
x_arm = np.arange(len(arm_lats))
x_x86 = np.arange(len(x86_lats))
w = 0.35
bars1 = ax.bar(x_arm - w/2, list(arm_lats.values()), w, label='ARM Kunpeng-920 (NEON)', color='#2196F3', alpha=0.85)
bars2 = ax.bar(x_x86 + w/2, list(x86_lats.values()), w, label='x86 i9-14900HX (AVX2)', color='#FF5722', alpha=0.85)

# Speedup labels
arm_baseline = arm_lats.get('Flat-Scalar-NoVec', list(arm_lats.values())[0])
x86_baseline = x86_lats.get('Flat-Scalar', list(x86_lats.values())[0])
for i, (bar, val) in enumerate(zip(bars1, arm_lats.values())):
    ax.text(bar.get_x()+bar.get_width()/2, bar.get_height()+0.08,
            f'{arm_baseline/val:.1f}x', ha='center', fontsize=8, color='#1565C0')
for i, (bar, val) in enumerate(zip(bars2, x86_lats.values())):
    ax.text(bar.get_x()+bar.get_width()/2, bar.get_height()+0.08,
            f'{x86_baseline/val:.1f}x', ha='center', fontsize=8, color='#BF360C')

ax.set_ylabel('Latency (ms/query)')
ax.set_title('Flat Search SIMD Speedup: ARM NEON vs x86 AVX2')
ax.set_xticks(np.arange(max(len(arm_lats), len(x86_lats))))
ax.set_xticklabels(['Scalar','AutoVec','Manual\nSIMD','Unroll','Prefetch','Fixed\nTopK'], fontsize=9)
ax.legend(loc='upper right')
ax.grid(axis='y', alpha=0.3)
save('flat_speedup_dual')

# ============================================================
# Figure 2: SQ Latency-Recall (x86)
# ============================================================
print("Figure 2: SQ Latency-Recall")
fig, ax = plt.subplots(figsize=(8, 5))

sq_data = x86_sq8[x86_sq8.method.str.contains('SQ8-p') & ~x86_sq8.method.str.contains('U8SIMD')]
for _, row in sq_data.iterrows():
    ax.annotate(f"p={int(row['p'])}", (row['latency_ms'], row['recall']),
                textcoords="offset points", xytext=(8, -4), fontsize=8)

ax.scatter(sq_data['latency_ms'], sq_data['recall'], c='#2196F3', s=60, zorder=5, edgecolors='black', linewidth=0.5)
ax.plot(sq_data['latency_ms'], sq_data['recall'], '--', color='#1565C0', alpha=0.5)

# Add Flat baseline
flat_scalar = x86_flat[x86_flat.method.str.contains('Scalar')]
if len(flat_scalar) > 0:
    fl = flat_scalar.latency_ms.min()
    ax.axvline(x=fl, color='red', linestyle=':', alpha=0.6, label=f'Flat-Scalar ({fl:.1f}ms)')
    ax.legend(fontsize=9)

ax.set_xlabel('Latency (ms/query)')
ax.set_ylabel('Recall@10')
ax.set_title('SQ8 Latency-Recall Trade-off (x86 i9-14900HX)')
ax.grid(alpha=0.3)
save('sq_latency_recall_x86')

# ============================================================
# Figure 3: PQ-ADC Latency-Recall (x86, by M)
# ============================================================
print("Figure 3: PQ-ADC Latency-Recall")
fig, ax = plt.subplots(figsize=(9, 6))
colors = {8: '#2196F3', 12: '#4CAF50', 16: '#FF9800'}
markers = {8: 'o', 12: 's', 16: '^'}

for m in [8, 12, 16]:
    dm = x86_pq[(x86_pq.M == m) & (x86_pq.family == 'pqsel')]
    if len(dm) == 0: dm = x86_pq[(x86_pq.M == m)]
    ax.scatter(dm['latency_ms'], dm['recall'], c=colors[m], marker=markers[m],
               s=70, label=f'M={m}', edgecolors='black', linewidth=0.5, zorder=5)
    for _, r in dm.iterrows():
        ax.annotate(f"p={int(r['p'])}", (r['latency_ms'], r['recall']),
                    textcoords="offset points", xytext=(6, -8), fontsize=7)

ax.set_xlabel('Latency (ms/query)')
ax.set_ylabel('Recall@10')
ax.set_title('PQ-ADC Latency-Recall by Subspace Count M (x86)')
ax.legend(fontsize=10)
ax.grid(alpha=0.3)
save('pq_adc_latency_recall_x86')

# ============================================================
# Figure 4: ADC vs SDC Comparison
# ============================================================
print("Figure 4: ADC vs SDC")
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

# M=16 comparison
adc_m16 = x86_pq[(x86_pq.M == 16) & (x86_pq.p > 0)].sort_values('p')
sdc_m16 = x86_sdc[(x86_sdc.M == 16) & (x86_sdc.p > 0)].sort_values('p')

ax1.plot(adc_m16['p'], adc_m16['latency_ms'], 'o-', color='#2196F3', ms=8, label='ADC (M=16)')
ax1.plot(sdc_m16['p'], sdc_m16['latency_ms'], 's--', color='#FF5722', ms=8, label='SDC (M=16)')
ax1.set_xlabel('Rerank p')
ax1.set_ylabel('Latency (ms/query)')
ax1.set_title('Latency Comparison (M=16, x86)')
ax1.legend(); ax1.grid(alpha=0.3)
ax1.set_xscale('log')

ax2.plot(adc_m16['p'], adc_m16['recall'], 'o-', color='#2196F3', ms=8, label='ADC (M=16)')
ax2.plot(sdc_m16['p'], sdc_m16['recall'], 's--', color='#FF5722', ms=8, label='SDC (M=16)')
ax2.set_xlabel('Rerank p')
ax2.set_ylabel('Recall@10')
ax2.set_title('Recall Comparison (M=16, x86)')
ax2.legend(); ax2.grid(alpha=0.3)
ax2.set_xscale('log')

plt.suptitle('PQ-ADC vs PQ-SDC: Latency and Recall', fontsize=14, y=1.02)
save('adc_vs_sdc_x86')

# ============================================================
# Figure 5: PQ Time Breakdown (x86)
# ============================================================
print("Figure 5: PQ Time Breakdown")
fig, ax = plt.subplots(figsize=(10, 6))

pq_breakdown = x86_pq[(x86_pq.M == 16) & (x86_pq.family == 'pqsel') & (x86_pq.p.isin([500,1000,2000]))].copy()
if len(pq_breakdown) < 3:
    pq_breakdown = x86_pq[(x86_pq.M == 16) & (x86_pq.p.isin([500,1000,2000]))]

x_pos = np.arange(len(pq_breakdown))
w = 0.6

b1 = ax.bar(x_pos, pq_breakdown['lut_ms'].values, w, label='LUT Build', color='#E3F2FD')
b2 = ax.bar(x_pos, pq_breakdown['scan_ms'].values, w, bottom=pq_breakdown['lut_ms'].values,
            label='Scan', color='#90CAF9')
bottom2 = pq_breakdown['lut_ms'].values + pq_breakdown['scan_ms'].values
b3 = ax.bar(x_pos, pq_breakdown['select_ms'].values, w, bottom=bottom2,
            label='Select (nth_element)', color='#42A5F5')
bottom3 = bottom2 + pq_breakdown['select_ms'].values
b4 = ax.bar(x_pos, pq_breakdown['rerank_ms'].values, w, bottom=bottom3,
            label='Rerank', color='#1565C0')

for i, (_, row) in enumerate(pq_breakdown.iterrows()):
    ax.text(i, row['latency_ms']+0.05, f"{row['latency_ms']:.1f}ms\nrecall={row['recall']:.3f}",
            ha='center', fontsize=9, fontweight='bold')

ax.set_xticks(x_pos)
ax.set_xticklabels([f"M=16, p={int(p)}" for p in pq_breakdown['p']])
ax.set_ylabel('Latency (ms/query)')
ax.set_title('PQ-ADC Time Breakdown (x86 i9-14900HX)')
ax.legend(loc='upper right', fontsize=9)
ax.grid(axis='y', alpha=0.3)
save('pq_time_breakdown_x86')

# ============================================================
# Figure 6: FastScan Comparison (x86)
# ============================================================
print("Figure 6: FastScan Comparison")
fig, ax = plt.subplots(figsize=(10, 6))

# Best FastScan vs best PQ-ADC at similar recall
fs_best = x86_fs[x86_fs.recall == 1.0].sort_values('latency_ms').head(10)
pq_best = x86_pq[(x86_pq.recall >= 0.999) & (x86_pq.M == 16)].sort_values('latency_ms').head(5)

methods_fs = [f"FS-b{r['block']:.0f}" for _, r in fs_best.iterrows()]
methods_pq = [f"ADC-p{r['p']:.0f}" for _, r in pq_best.iterrows()]

x_all = np.arange(len(methods_fs) + len(methods_pq))
lats_fs = fs_best['latency_ms'].values
lats_pq = pq_best['latency_ms'].values
all_lats = np.concatenate([lats_fs, lats_pq])
all_methods = methods_fs + methods_pq
colors = ['#FF5722']*len(fs_best) + ['#2196F3']*len(pq_best)

ax.bar(x_all, all_lats, color=colors, alpha=0.85, edgecolor='black', linewidth=0.5)

# Speedup labels
pq_ref = lats_pq[0] if len(lats_pq) > 0 else all_lats[-1]
for i, (bar_h, name) in enumerate(zip(all_lats, all_methods)):
    if i < len(fs_best):
        ax.text(i, bar_h+0.02, f'{pq_ref/bar_h:.2f}x\n{bar_h:.1f}ms',
                ha='center', fontsize=7, fontweight='bold', color='#BF360C')
    else:
        ax.text(i, bar_h+0.02, f'{bar_h:.1f}ms', ha='center', fontsize=7, color='#1565C0')

ax.set_xticks(x_all)
ax.set_xticklabels(all_methods, fontsize=7, rotation=30, ha='right')
ax.set_ylabel('Latency (ms/query)')
ax.set_title('FastScan vs Naive PQ-ADC (M=16, recall=1.0, x86)')
ax.grid(axis='y', alpha=0.3)

# Legend
from matplotlib.patches import Patch
legend_elements = [Patch(facecolor='#FF5722', label='FastScan-ADC'),
                   Patch(facecolor='#2196F3', label='PQ-ADC')]
ax.legend(handles=legend_elements, fontsize=10)
save('fastscan_comparison_x86')

# ============================================================
# Figure 7: ARM vs x86 Scatter (latency comparison)
# ============================================================
print("Figure 7: ARM vs x86 Comparison")
fig, ax = plt.subplots(figsize=(9, 6))

# Compare flat methods that exist on both platforms
comparisons = [
    ('Flat-Scalar', 'Flat-Scalar-NoVec', 'Scalar'),
    ('Flat-AutoVec', 'Flat-AutoVec', 'AutoVec'),
    ('Flat-SSE/NEON', 'Flat-Manual-NEON', 'Manual SIMD'),
]

for x86_name, arm_name, label in comparisons:
    x86_val = 0; arm_val = 0
    if x86_name == 'Flat-SSE/NEON':
        x86_d = x86_flat[x86_flat.method.str.contains('Flat-SSE', case=False)]
        if len(x86_d) == 0: x86_d = x86_flat[x86_flat.method.str.contains('Flat-AVX', case=False)]
        d2 = x86_d[x86_d.topk == 'heap'] if 'topk' in x86_d.columns else x86_d
        x86_val = d2.latency_ms.min() if len(d2) > 0 else 0
    else:
        x86_d = x86_flat[x86_flat.method.str.contains(x86_name, case=False)]
        d2 = x86_d[x86_d.topk == 'heap'] if 'topk' in x86_d.columns else x86_d
        x86_val = d2.latency_ms.min() if len(d2) > 0 else 0

    arm_d = arm_flat[arm_flat.method == arm_name]
    arm_val = arm_d.latency_ms.values[0] if len(arm_d) > 0 else 0

    if x86_val > 0 and arm_val > 0:
        ax.scatter(arm_val, x86_val, s=120, label=label, edgecolors='black', linewidth=0.8, zorder=5)
        ax.annotate(f'{label}\nARM:{arm_val:.1f}ms\nx86:{x86_val:.1f}ms',
                    (arm_val, x86_val), textcoords="offset points",
                    xytext=(10, -5), fontsize=8)

# Add PQ comparison
ax.scatter([3.73], [2.45], s=120, marker='s', color='#4CAF50',
           label='PQ-SDC M=16', edgecolors='black', linewidth=0.8, zorder=5)
ax.annotate('PQ-SDC M=16\nARM:3.73ms\nx86:2.45ms',
            (3.73, 2.45), textcoords="offset points", xytext=(10, -5), fontsize=8)

max_val = max(max(arm_flat.latency_ms.max(), 1), max(x86_flat.latency_ms.max(), 1))
ax.plot([0, max_val*1.1], [0, max_val*1.1], 'k--', alpha=0.3, label='y=x')
ax.set_xlabel('ARM Kunpeng-920 Latency (ms)')
ax.set_ylabel('x86 i9-14900HX Latency (ms)')
ax.set_title('Cross-Platform Latency Comparison')
ax.legend(fontsize=8, loc='upper left')
ax.grid(alpha=0.3)
save('cross_platform_comparison')

# ============================================================
# Figure 8: Prefetch Sensitivity (x86)
# ============================================================
print("Figure 8: Prefetch Sensitivity")
fig, ax = plt.subplots(figsize=(8, 5))

pf_data_heap = x86_flat[(x86_flat.method.str.contains('prefetch')) & (x86_flat.topk == 'heap')]
pf_data_ftk = x86_flat[(x86_flat.method.str.contains('prefetch')) & (x86_flat.topk == 'fixed-array')]

if len(pf_data_heap) > 0:
    ax.plot(pf_data_heap['prefetch'], pf_data_heap['latency_ms'], 'o-', color='#2196F3',
            ms=8, label='Heap TopK')
if len(pf_data_ftk) > 0:
    ax.plot(pf_data_ftk['prefetch'], pf_data_ftk['latency_ms'], 's--', color='#FF5722',
            ms=8, label='Fixed-Array TopK')

ax.set_xlabel('Prefetch Distance')
ax.set_ylabel('Latency (ms/query)')
ax.set_title('Prefetch Distance Sensitivity (Flat-AVX, x86)')
ax.legend()
ax.grid(alpha=0.3)
save('prefetch_sensitivity_x86')

# ============================================================
# Figure 9: FastScan Block Size Sensitivity
# ============================================================
print("Figure 9: FastScan Block Size Sensitivity")
fig, ax = plt.subplots(figsize=(9, 6))

for p in [500, 1000, 1500]:
    dp = x86_fs[(x86_fs.p == p) & (x86_fs.recall >= 0.999)]
    if len(dp) > 0:
        ax.plot(dp['block'], dp['latency_ms'], 'o-', ms=8, label=f'p={p}')

ax.set_xlabel('Block Size')
ax.set_ylabel('Latency (ms/query)')
ax.set_title('FastScan Block Size Sensitivity (M=16, x86)')
ax.legend()
ax.grid(alpha=0.3)
save('fastscan_block_sensitivity_x86')

# ============================================================
# Figure 10: Rerank p Sensitivity
# ============================================================
print("Figure 10: Rerank p Sensitivity")
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

# SQ8
sq = x86_sq8[~x86_sq8.method.str.contains('U8SIMD')]
if len(sq) > 0:
    ax1.plot(sq['p'], sq['latency_ms'], 'o-', color='#2196F3', ms=8, label='Total')
    ax1.plot(sq['p'], sq['scan_ms'], 's-', color='#90CAF9', ms=6, label='Coarse/Scan')
    ax1.plot(sq['p'], sq['rerank_ms'], '^-', color='#1565C0', ms=6, label='Rerank')
    ax1.set_xlabel('Rerank p'); ax1.set_ylabel('Latency (ms)')
    ax1.set_title('SQ8: p-Sensitivity (x86)')
    ax1.legend(); ax1.grid(alpha=0.3)
    ax1.set_xscale('log')

# PQ-ADC M=16
pq16 = x86_pq[(x86_pq.M == 16) & (x86_pq.p > 0)]
if len(pq16) > 0:
    ax2.plot(pq16['p'], pq16['latency_ms'], 'o-', color='#FF5722', ms=8, label='Total')
    ax2.plot(pq16['p'], pq16['scan_ms'], 's-', color='#FFAB91', ms=6, label='Scan')
    ax2.plot(pq16['p'], pq16['rerank_ms'], '^-', color='#BF360C', ms=6, label='Rerank')
    ax2.set_xlabel('Rerank p'); ax2.set_ylabel('Latency (ms)')
    ax2.set_title('PQ-ADC M=16: p-Sensitivity (x86)')
    ax2.legend(); ax2.grid(alpha=0.3)
    ax2.set_xscale('log')

plt.suptitle('Rerank Candidate Count Sensitivity', fontsize=14, y=1.02)
save('rerank_sensitivity_x86')

# ============================================================
# Figure 11: Pareto Frontier (x86)
# ============================================================
print("Figure 11: Pareto Frontier")
fig, ax = plt.subplots(figsize=(10, 7))

# All x86 methods
all_x86 = []

# Flat
for _, r in x86_flat.iterrows():
    if r['topk'] == 'heap' and 'prefetch' not in r['method'].lower():
        all_x86.append(('Flat', r['latency_ms'], r['recall'], '#E91E63', 'o'))

# SQ8
for _, r in sq.iterrows():
    all_x86.append(('SQ8', r['latency_ms'], r['recall'], '#2196F3', 's'))

# PQ-ADC
for _, r in x86_pq.iterrows():
    if r['M'] in [8, 12, 16]:
        all_x86.append((f"PQ-ADC-M{r['M']:.0f}", r['latency_ms'], r['recall'],
                         {8:'#4CAF50',12:'#FF9800',16:'#9C27B0'}[r['M']], '^'))

# FastScan
for _, r in x86_fs.iterrows():
    all_x86.append(('FastScan', r['latency_ms'], r['recall'], '#FF5722', 'D'))

for name, lat, rec, color, marker in all_x86:
    ax.scatter(lat, rec, c=color, marker=marker, s=40, alpha=0.7, edgecolors='none')

# Compute and plot Pareto frontier
points = sorted([(l, r) for _, l, r, _, _ in all_x86], key=lambda x: x[0])
pareto = []
max_recall = -1
for lat, rec in points:
    if rec > max_recall:
        pareto.append((lat, rec))
        max_recall = rec
if len(pareto) > 1:
    pareto_lats, pareto_recs = zip(*pareto)
    ax.plot(pareto_lats, pareto_recs, 'k-', linewidth=2, alpha=0.5, label='Pareto Frontier')

# Annotate key points
key_points = [
    ('Flat-AVX', 2.74, 1.0),
    ('FastScan\nM16-p500-b64', 1.87, 1.0),
    ('PQ-ADC\nM16-p5000', 2.38, 1.0),
]
for name, lat, rec in key_points:
    ax.annotate(name, (lat, rec), textcoords="offset points",
                xytext=(10, -10), fontsize=8, fontweight='bold',
                arrowprops=dict(arrowstyle='->', color='gray', lw=0.8))

ax.set_xlabel('Latency (ms/query)')
ax.set_ylabel('Recall@10')
ax.set_title('Pareto Frontier: Latency-Recall Trade-off (x86 i9-14900HX)')
ax.legend(fontsize=8)
ax.grid(alpha=0.3)
save('pareto_frontier_x86')

# ============================================================
# Figure 12: M-Sensitivity for PQ (x86)
# ============================================================
print("Figure 12: M-Sensitivity")
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

for p_val in [1000, 2000, 5000]:
    dp = x86_pq[(x86_pq.p == p_val)]
    if len(dp) > 0:
        ax1.plot(dp['M'], dp['latency_ms'], 'o-', ms=8, label=f'p={p_val}')
ax1.set_xlabel('M (subspace count)'); ax1.set_ylabel('Latency (ms)')
ax1.set_title('PQ-ADC: M vs Latency'); ax1.legend(); ax1.grid(alpha=0.3)
ax1.set_xticks([8, 12, 16])

for p_val in [1000, 2000, 5000]:
    dp = x86_pq[(x86_pq.p == p_val)]
    if len(dp) > 0:
        ax2.plot(dp['M'], dp['recall'], 'o-', ms=8, label=f'p={p_val}')
ax2.set_xlabel('M (subspace count)'); ax2.set_ylabel('Recall@10')
ax2.set_title('PQ-ADC: M vs Recall'); ax2.legend(); ax2.grid(alpha=0.3)
ax2.set_xticks([8, 12, 16])

plt.suptitle('PQ-ADC Subspace Count (M) Sensitivity (x86)', fontsize=14, y=1.02)
save('pq_m_sensitivity_x86')

print("\n=== All figures generated ===")
print(f"Output directory: {FIGS_DIR}")
