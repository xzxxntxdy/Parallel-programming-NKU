#!/usr/bin/env python3
"""6 high-information-density figures for ANN SIMD paper."""
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.ticker import FuncFormatter
import os

FIGS = "D:/Parallel-programming-NKU/ann/files/figures"
os.makedirs(FIGS, exist_ok=True)

plt.rcParams.update({
    'font.size': 10, 'axes.titlesize': 12, 'axes.labelsize': 11,
    'legend.fontsize': 8, 'figure.dpi': 180, 'savefig.bbox': 'tight',
    'font.family': 'sans-serif',
})

def save(name):
    for ext in ['png', 'pdf']:
        plt.savefig(f"{FIGS}/fig_{name}.{ext}")
    print(f"  {name}")
    plt.close()

# ====== DATA ======
methods_order = ['Flat-Scalar','Flat-AutoVec','Flat-SIMD','Flat+Prefetch',
                 'PQ-ADC','FastScan v1','FastScan v2']
arm_lat =   [19.08, 11.88, 8.43,  7.20,  3.69,  3.12,  2.44]
arm_recall =[1.0,   1.0,   1.0,   1.0,   0.99995,0.99995,0.99995]
arm_label = ['Scalar','AutoVec','NEON','NEON+Pref','PQ-ADC\nM16-p2000','FS v1\nb64-p1500','FS v2\nb128-p1500']

x86_lat =   [3.56,  3.21,  1.49,  1.31,  1.17,  1.87,  1.06]
x86_recall =[1.0,   1.0,   1.0,   1.0,   1.0,   1.0,   1.0]
x86_label = ['Scalar','AutoVec','AVX2','AVX2+Pref','PQ-ADC\nM16-p500','FS v1\nb64-p500','FS v2\nb128-p500']

# ARM perf
perf_kernels = ['Flat-NEON', 'PQ-ADC', 'FastScan v2']
perf_ipc    = [0.96, 1.71, 1.94]
perf_l1d    = [2.70, 0.88, 0.65]
perf_llc    = [75.10, 21.67, 30.84]

# ARM time breakdown (scan/LUT+encode/select/rerank) — approximate
bd_flat   = [7.39, 0, 0, 0]  # scan only for Flat
bd_pq_adc = [3.09, 0.04, 0.20, 0.53]  # scan, LUT, select, rerank
bd_fs_v2  = [1.99, 0.05, 0.15, 0.25]  # scan, LUT+encode, select, rerank

# x86 time breakdown
x86_bd_pq_adc = [0.47, 0.009, 0.15, 0.06]  # scan, LUT, select, rerank (M16-p500)
x86_bd_fs_v2  = [0.34, 0.020, 0.12, 0.06]  # scan, LUT, select, rerank (M16-p500-b128)

# ARM PQ p-sweep data (M=16)
arm_p_vals   = [100, 500, 1000, 2000]
arm_pq_lat   = [3.69, 3.69, 3.44, 3.69]  # approximate from data
arm_pq_scan  = [3.09, 3.09, 3.07, 3.09]
arm_pq_rerank=[0.17, 0.17, 0.37, 0.60]
arm_pq_recall=[0.93, 0.996, 0.99975, 0.99995]
arm_fs_lat   = [2.16, 2.16, 2.30, 2.44]
arm_fs_recall=[0.92, 0.996, 0.99975, 0.99995]

# x86 PQ p-sweep (M=16)
x86_pq_lat =    [1.26, 1.17, 1.45, 1.28]
x86_pq_recall = [0.925,1.0,  1.0,  1.0]
x86_fs_lat =    [1.10, 1.06, 1.23, 1.20]
x86_fs_recall = [0.925,1.0,  1.0,  1.0]

# ARM M-sweep (p=2000, PQ-ADC)
arm_m_vals = [8, 12, 16]
arm_m_lat  = [2.47, 2.98, 3.69]
arm_m_rec  = [0.995, 0.99965, 0.99995]

# x86 M-sweep (p=1000)
x86_m_vals = [8, 12, 16]
x86_m_lat  = [1.15, 1.20, 1.45]
x86_m_rec  = [0.983, 0.997, 1.0]

# ================================================================
# FIG 1: Optimization Journey — dual-platform horizontal bar
# ================================================================
print("Fig 1: Optimization Journey")
fig, ax = plt.subplots(figsize=(12, 6))
y = np.arange(len(methods_order))
h = 0.35

bars_arm = ax.barh(y - h/2, arm_lat, h, label='ARM Kunpeng-920 (NEON 128b)',
                    color='#1565C0', edgecolor='white', linewidth=0.5)
bars_x86 = ax.barh(y + h/2, x86_lat, h, label='x86 i9-14900HX (AVX2 256b)',
                    color='#FF5722', edgecolor='white', linewidth=0.5)

# Speedup labels
arm_base = arm_lat[0]
x86_base = x86_lat[0]
for i, (b_a, b_x) in enumerate(zip(bars_arm, bars_x86)):
    ax.text(b_a.get_width() + 0.3, b_a.get_y() + b_a.get_height()/2,
            f'{arm_base/arm_lat[i]:.1f}×', va='center', fontsize=8, color='#0D47A1', fontweight='bold')
    ax.text(b_x.get_width() + 0.3, b_x.get_y() + b_x.get_height()/2,
            f'{x86_base/x86_lat[i]:.1f}×', va='center', fontsize=8, color='#BF360C', fontweight='bold')

# Stage separator
for i in [1, 3, 4, 5]:
    ax.axhline(y=i - 0.65, color='gray', linestyle=':', alpha=0.4, linewidth=0.8)

ax.set_yticks(y)
ax.set_yticklabels(arm_label, fontsize=9)
ax.set_xlabel('Latency (ms/query)')
ax.set_title('ANN Query Optimization Journey: From Scalar to FastScan', fontweight='bold')
ax.legend(loc='lower right', fontsize=9)
ax.invert_yaxis()
ax.set_xlim(0, max(max(arm_lat), max(x86_lat)) * 1.35)
ax.grid(axis='x', alpha=0.3)

# Annotations
ax.annotate('SIMD\nVectorization', xy=(3.5, 2), fontsize=9, ha='center',
            bbox=dict(boxstyle='round', fc='#E3F2FD', alpha=0.8))
ax.annotate('Product\nQuantization', xy=(4.5, 4), fontsize=9, ha='center',
            bbox=dict(boxstyle='round', fc='#C8E6C9', alpha=0.8))
ax.annotate('FastScan\nOptimization', xy=(5.5, 5.5), fontsize=9, ha='center',
            bbox=dict(boxstyle='round', fc='#FFE0B2', alpha=0.8))

save('01_optimization_journey')

# ================================================================
# FIG 2: Latency-Recall Pareto Frontier (dual platform)
# ================================================================
print("Fig 2: Pareto Frontier")
fig, ax = plt.subplots(figsize=(10, 7))

# ARM points
arm_data = [
    ('Flat-Scalar', 19.08, 1.0, '#E0E0E0', 'o'),
    ('Flat-NEON', 8.43, 1.0, '#90CAF9', 'o'),
    ('PQ-ADC-M8', 2.47, 0.995, '#A5D6A7', 's'),
    ('PQ-ADC-M12', 2.98, 0.99965, '#66BB6A', 's'),
    ('PQ-ADC-M16', 3.69, 0.99995, '#2E7D32', 's'),
    ('FastScan v1', 3.12, 0.99995, '#FF9800', 'D'),
    ('FastScan v2', 2.44, 0.99995, '#E65100', 'D'),
]
for name, lat, rec, color, marker in arm_data:
    ax.scatter(lat, rec, c=color, marker=marker, s=80, edgecolors='black',
               linewidth=0.5, zorder=5)
    ax.annotate(name, (lat, rec), textcoords="offset points", xytext=(6, -8),
                fontsize=7, alpha=0.9)

# x86 points (lighter)
x86_data = [
    ('Flat-Scalar', 3.56, 1.0, '#E0E0E0', 'o'),
    ('Flat-AVX2', 1.49, 1.0, '#90CAF9', 'o'),
    ('PQ-ADC-M8', 1.15, 0.983, '#A5D6A7', 's'),
    ('PQ-ADC-M16', 1.17, 1.0, '#2E7D32', 's'),
    ('FastScan v1', 1.87, 1.0, '#FF9800', 'D'),
    ('FastScan v2', 1.06, 1.0, '#E65100', 'D'),
]
for name, lat, rec, color, marker in x86_data:
    ax.scatter(lat, rec, c=color, marker=marker, s=60, edgecolors='black',
               linewidth=0.5, zorder=5, alpha=0.7)
    ax.annotate(name, (lat, rec), textcoords="offset points", xytext=(6, 6),
                fontsize=6, alpha=0.7)

# Pareto lines
arm_pareto_x = [19.08, 8.43, 3.69, 2.44]
arm_pareto_y = [1.0, 1.0, 0.99995, 0.99995]
x86_pareto_x = [3.56, 1.49, 1.17, 1.06]
x86_pareto_y = [1.0, 1.0, 1.0, 1.0]
ax.plot(arm_pareto_x, arm_pareto_y, 'b--', alpha=0.4, linewidth=1.5)
ax.plot(x86_pareto_x, x86_pareto_y, 'r--', alpha=0.4, linewidth=1.5)

ax.set_xlabel('Latency (ms/query) — lower is better')
ax.set_ylabel('Recall@10 — higher is better')
ax.set_title('Pareto Frontier: ARM vs x86 Latency-Recall Landscape', fontweight='bold')
ax.legend([mpatches.Patch(color='#1565C0', alpha=0.6), mpatches.Patch(color='#FF5722', alpha=0.6)],
          ['ARM (solid)', 'x86 (lighter)'], fontsize=9)
ax.grid(alpha=0.3, linestyle='--')
ax.set_xlim(0, 21)
ax.set_ylim(0.97, 1.005)
save('02_pareto_frontier')

# ================================================================
# FIG 3: FastScan Evolution — 3 panels
# ================================================================
print("Fig 3: FastScan Evolution")
fig = plt.figure(figsize=(14, 10))

# Panel A: Code layout diagram (text-based)
ax_a = fig.add_subplot(2, 2, 1)
ax_a.set_xlim(0, 10); ax_a.set_ylim(0, 10); ax_a.axis('off')
ax_a.set_title('(a) Code Layout & Accumulation', fontweight='bold', loc='left')

# v1 diagram
ax_a.add_patch(plt.Rectangle((0.3, 5.5), 9.2, 3.8, fill=False, ec='#FF5722', lw=2, ls='--'))
ax_a.text(0.8, 8.8, 'FastScan v1 (part-major)', fontweight='bold', color='#BF360C', fontsize=10)
ax_a.text(0.8, 8.0, 'codes[block][part][lane]', fontfamily='monospace', fontsize=8)
ax_a.text(0.8, 7.2, 'for part: for lane:', fontfamily='monospace', fontsize=8)
ax_a.text(1.2, 6.5, 'scores[lane] += lut[codes[lane]]', fontfamily='monospace', fontsize=8, color='red')
ax_a.text(0.8, 5.8, '→ Memory RMW per update', fontsize=8, color='red')

# v2 diagram
ax_a.add_patch(plt.Rectangle((0.3, 0.5), 9.2, 4.3, fill=False, ec='#4CAF50', lw=2))
ax_a.text(0.8, 4.3, 'FastScan v2 (lane-major)', fontweight='bold', color='#1B5E20', fontsize=10)
ax_a.text(0.8, 3.5, 'codes[block][lane][part]', fontfamily='monospace', fontsize=8)
ax_a.text(0.8, 2.7, 'for lane:               // 4-way unrolled', fontfamily='monospace', fontsize=8)
ax_a.text(1.2, 2.0, 'int s = 0;              // register!', fontfamily='monospace', fontsize=8, color='green')
ax_a.text(1.2, 1.3, 'for part: s += lut[code[part]]', fontfamily='monospace', fontsize=8, color='green')
ax_a.text(0.8, 0.6, '→ Zero memory RMW, OoO-friendly', fontsize=8, color='green')

# Panel B: Latency comparison
ax_b = fig.add_subplot(2, 2, 2)
kernels = ['Naive\nPQ-ADC', 'FastScan\nv1', 'FastScan\nv2']
arm_vals = [3.69, 3.12, 2.44]
x86_vals = [1.17, 1.87, 1.06]
x = np.arange(3); w = 0.3
ax_b.bar(x - w/2, arm_vals, w, label='ARM', color='#1565C0')
ax_b.bar(x + w/2, x86_vals, w, label='x86', color='#FF5722')
for i, (av, xv) in enumerate(zip(arm_vals, x86_vals)):
    ax_b.text(i, av+0.05, f'{av:.2f}', ha='center', fontsize=8, fontweight='bold', color='#0D47A1')
    ax_b.text(i, xv+0.05, f'{xv:.2f}', ha='center', fontsize=8, fontweight='bold', color='#BF360C')
for i, (av, xv) in enumerate(zip(arm_vals, x86_vals)):
    vs_naive_a = 3.69/av; vs_naive_x = 1.17/xv
    if i > 0:
        ax_b.annotate(f'{vs_naive_a:.2f}×', (i-w/2, av/2), ha='center', fontsize=7, color='white', fontweight='bold')
        ax_b.annotate(f'{vs_naive_x:.2f}×', (i+w/2, xv/2), ha='center', fontsize=7, color='white', fontweight='bold')
ax_b.set_xticks(x); ax_b.set_xticklabels(kernels, fontsize=9)
ax_b.set_ylabel('Latency (ms)'); ax_b.set_title('(b) FastScan Latency Evolution', fontweight='bold', loc='left')
ax_b.legend(fontsize=8); ax_b.grid(axis='y', alpha=0.3)

# Panel C: Scan time breakdown (ARM)
ax_c = fig.add_subplot(2, 2, 3)
bd_labels = ['Scan/LUT', 'Select', 'Rerank']
bd_naive = [3.09, 0.20, 0.53]
bd_fs    = [1.99, 0.15, 0.25]
xb = np.arange(3); wb = 0.35
ax_c.bar(xb - wb/2, bd_naive, wb, label='Naive PQ-ADC (ARM)', color=['#90CAF9','#64B5F6','#1565C0'])
ax_c.bar(xb + wb/2, bd_fs,    wb, label='FastScan v2 (ARM)', color=['#A5D6A7','#66BB6A','#2E7D32'])
for i in range(3):
    ax_c.text(i-wb/2, bd_naive[i]+0.03, f'{bd_naive[i]:.2f}', ha='center', fontsize=7, color='#0D47A1')
    ax_c.text(i+wb/2, bd_fs[i]+0.03,    f'{bd_fs[i]:.2f}',    ha='center', fontsize=7, color='#1B5E20')
ax_c.set_xticks(xb); ax_c.set_xticklabels(bd_labels, fontsize=9)
ax_c.set_ylabel('Time (ms)'); ax_c.set_title('(c) ARM Scan Phase Breakdown', fontweight='bold', loc='left')
ax_c.legend(fontsize=8); ax_c.grid(axis='y', alpha=0.3)

# Panel D: Scan time breakdown (x86)
ax_d = fig.add_subplot(2, 2, 4)
x86_bd_naive = [0.47, 0.15, 0.06]
x86_bd_fs    = [0.34, 0.12, 0.06]
ax_d.bar(xb - wb/2, x86_bd_naive, wb, label='Naive PQ-ADC (x86)', color=['#FFCC80','#FF9800','#E65100'])
ax_d.bar(xb + wb/2, x86_bd_fs,    wb, label='FastScan v2 (x86)', color=['#A5D6A7','#66BB6A','#2E7D32'])
for i in range(3):
    ax_d.text(i-wb/2, x86_bd_naive[i]+0.01, f'{x86_bd_naive[i]:.2f}', ha='center', fontsize=7, color='#BF360C')
    ax_d.text(i+wb/2, x86_bd_fs[i]+0.01,    f'{x86_bd_fs[i]:.2f}',    ha='center', fontsize=7, color='#1B5E20')
ax_d.set_xticks(xb); ax_d.set_xticklabels(bd_labels, fontsize=9)
ax_d.set_ylabel('Time (ms)'); ax_d.set_title('(d) x86 Scan Phase Breakdown', fontweight='bold', loc='left')
ax_d.legend(fontsize=8); ax_d.grid(axis='y', alpha=0.3)

plt.tight_layout()
save('03_fastscan_evolution')

# ================================================================
# FIG 4: PQ Parameter Sensitivity (dual platform)
# ================================================================
print("Fig 4: PQ Parameter Sensitivity")
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# (a) M-sweep latency
ax = axes[0,0]
ax.plot(arm_m_vals, arm_m_lat, 'o-', color='#1565C0', ms=10, label='ARM PQ-ADC')
ax.plot(x86_m_vals, x86_m_lat, 's--', color='#FF5722', ms=10, label='x86 PQ-ADC')
for m, lat, rec in zip(arm_m_vals, arm_m_lat, arm_m_rec):
    ax.annotate(f'rec={rec:.4f}', (m, lat), textcoords="offset points", xytext=(5,10), fontsize=7)
for m, lat, rec in zip(x86_m_vals, x86_m_lat, x86_m_rec):
    ax.annotate(f'rec={rec:.3f}', (m, lat), textcoords="offset points", xytext=(5,-12), fontsize=7)
ax.set_xlabel('M (subspaces)'); ax.set_ylabel('Latency (ms)')
ax.set_title('(a) Subspace Count M Sensitivity', fontweight='bold')
ax.legend(fontsize=8); ax.grid(alpha=0.3)
ax.set_xticks([8,12,16])

# (b) p-sweep latency+recall (ARM, M=16)
ax = axes[0,1]
ax2 = ax.twinx()
l1 = ax.plot(arm_p_vals, arm_pq_lat, 'o-', color='#1565C0', ms=8, label='PQ-ADC latency')
l2 = ax.plot(arm_p_vals, arm_fs_lat, 'D-', color='#FF5722', ms=8, label='FastScan v2 latency')
l3 = ax2.plot(arm_p_vals, arm_pq_recall, 's--', color='#64B5F6', ms=8, label='PQ-ADC recall')
l4 = ax2.plot(arm_p_vals, arm_fs_recall, '^--', color='#FFAB91', ms=8, label='FastScan recall')
ax.set_xlabel('Rerank p'); ax.set_ylabel('Latency (ms)')
ax2.set_ylabel('Recall@10'); ax.set_title('(b) ARM p-Sweep (M=16)', fontweight='bold')
lns = l1+l2+l3+l4; labs = [l.get_label() for l in lns]
ax.legend(lns, labs, fontsize=7, loc='center right')
ax.grid(alpha=0.3)

# (c) Coarse vs rerank breakdown (ARM)
ax = axes[1,0]
arm_p_s = [500, 1000, 2000]
arm_scan_s = [3.09, 3.07, 3.09]
arm_rerank_s = [0.17, 0.37, 0.60]
arm_fs_scan_s = [1.99, 2.00, 2.02]
arm_fs_rerank_s = [0.16, 0.30, 0.44]
x_s = np.arange(3); w_s = 0.35
ax.bar(x_s - w_s/2, arm_scan_s, w_s, label='PQ-ADC Scan', color='#90CAF9')
ax.bar(x_s - w_s/2, arm_rerank_s, w_s, bottom=arm_scan_s, label='PQ-ADC Rerank', color='#1565C0')
ax.bar(x_s + w_s/2, arm_fs_scan_s, w_s, label='FastScan Scan', color='#A5D6A7')
ax.bar(x_s + w_s/2, arm_fs_rerank_s, w_s, bottom=arm_fs_scan_s, label='FastScan Rerank', color='#2E7D32')
ax.set_xticks(x_s); ax.set_xticklabels([f'p={p}' for p in arm_p_s])
ax.set_ylabel('Time (ms)'); ax.set_title('(c) ARM Coarse vs Rerank (M=16)', fontweight='bold')
ax.legend(fontsize=7); ax.grid(axis='y', alpha=0.3)

# (d) Coarse vs rerank breakdown (x86)
ax = axes[1,1]
x86_p_s = [500, 1000, 2000]
x86_scan_s = [0.47, 0.54, 0.45]
x86_rerank_s = [0.06, 0.12, 0.20]
x86_fs_scan_s = [0.34, 0.35, 0.35]
x86_fs_rerank_s = [0.06, 0.06, 0.06]
ax.bar(x_s - w_s/2, x86_scan_s, w_s, label='PQ-ADC Scan', color='#FFCC80')
ax.bar(x_s - w_s/2, x86_rerank_s, w_s, bottom=x86_scan_s, label='PQ-ADC Rerank', color='#FF9800')
ax.bar(x_s + w_s/2, x86_fs_scan_s, w_s, label='FastScan Scan', color='#A5D6A7')
ax.bar(x_s + w_s/2, x86_fs_rerank_s, w_s, bottom=x86_fs_scan_s, label='FastScan Rerank', color='#2E7D32')
ax.set_xticks(x_s); ax.set_xticklabels([f'p={p}' for p in x86_p_s])
ax.set_ylabel('Time (ms)'); ax.set_title('(d) x86 Coarse vs Rerank (M=16)', fontweight='bold')
ax.legend(fontsize=7); ax.grid(axis='y', alpha=0.3)

plt.tight_layout()
save('04_pq_sensitivity')

# ================================================================
# FIG 5: Microarchitecture Analysis
# ================================================================
print("Fig 5: Microarchitecture")
fig, axes = plt.subplots(1, 3, figsize=(14, 5))

# (a) IPC
ax = axes[0]
colors_ipc = ['#90CAF9', '#66BB6A', '#FF9800']
ax.bar(perf_kernels, perf_ipc, color=colors_ipc, edgecolor='black', linewidth=0.5)
for i, v in enumerate(perf_ipc):
    ax.text(i, v+0.03, f'{v:.2f}', ha='center', fontweight='bold', fontsize=11)
ax.set_ylabel('IPC'); ax.set_title('(a) Instructions Per Cycle', fontweight='bold')
ax.grid(axis='y', alpha=0.3); ax.set_ylim(0, max(perf_ipc)*1.2)

# (b) L1D Miss Rate
ax = axes[1]
ax.bar(perf_kernels, perf_l1d, color=colors_ipc, edgecolor='black', linewidth=0.5)
for i, v in enumerate(perf_l1d):
    ax.text(i, v+0.05, f'{v:.2f}%', ha='center', fontweight='bold', fontsize=11)
ax.set_ylabel('L1D Miss Rate (%)'); ax.set_title('(b) L1 Data Cache Miss', fontweight='bold')
ax.grid(axis='y', alpha=0.3)

# (c) LLC Miss Rate
ax = axes[2]
ax.bar(perf_kernels, perf_llc, color=colors_ipc, edgecolor='black', linewidth=0.5)
for i, v in enumerate(perf_llc):
    ax.text(i, v+1, f'{v:.1f}%', ha='center', fontweight='bold', fontsize=11)
ax.set_ylabel('LLC Miss Rate (%)'); ax.set_title('(c) Last-Level Cache Miss', fontweight='bold')
ax.grid(axis='y', alpha=0.3)

plt.suptitle('ARM Kunpeng-920 Perf Counter Analysis', fontweight='bold', fontsize=13, y=1.02)
plt.tight_layout()
save('05_microarchitecture')

# ================================================================
# FIG 6: Time Breakdown Stacked Bars
# ================================================================
print("Fig 6: Time Breakdown")
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))

# ARM breakdown
stages = ['Scan/LUT', 'Select', 'Rerank', 'Other']
arm_flat_bd   = [7.39, 0.00, 0.00, 0.00]
arm_pqadc_bd  = [3.09, 0.20, 0.53, 0.02]
arm_fsv2_bd   = [1.99, 0.15, 0.25, 0.05]
x_pos_arm = np.arange(3); w = 0.5

colors_bd = ['#2196F3', '#FF9800', '#4CAF50', '#9E9E9E']
b_arm_flat = ax1.bar(x_pos_arm[0], arm_flat_bd[0], w, color=colors_bd[0], label=stages[0])
for j in range(1,4):
    ax1.bar(x_pos_arm[0], arm_flat_bd[j], w, bottom=sum(arm_flat_bd[:j]), color=colors_bd[j])
for i in range(1,3):
    bd = arm_pqadc_bd if i==1 else arm_fsv2_bd
    for j in range(4):
        ax1.bar(x_pos_arm[i], bd[j], w, bottom=sum(bd[:j]) if j>0 else 0, color=colors_bd[j])
for i, bd in enumerate([arm_flat_bd, arm_pqadc_bd, arm_fsv2_bd]):
    ax1.text(i, sum(bd)+0.1, f'{sum(bd):.1f}ms', ha='center', fontweight='bold', fontsize=9)

ax1.set_xticks(x_pos_arm)
ax1.set_xticklabels(['Flat-NEON', 'PQ-ADC\nM16-p2000', 'FastScan v2\nM16-p1500-b128'])
ax1.set_ylabel('Latency (ms)'); ax1.set_title('ARM Kunpeng-920', fontweight='bold')
ax1.legend(fontsize=8, loc='upper right'); ax1.grid(axis='y', alpha=0.3)

# x86 breakdown
x86_flat_bd  = [1.49, 0.00, 0.00, 0.00]
x86_pqadc_bd = [0.47, 0.15, 0.06, 0.01]
x86_fsv2_bd  = [0.34, 0.12, 0.06, 0.01]
for j in range(4):
    ax2.bar(x_pos_arm[0], x86_flat_bd[j], w, bottom=sum(x86_flat_bd[:j]), color=colors_bd[j])
for i in range(1,3):
    bd = x86_pqadc_bd if i==1 else x86_fsv2_bd
    for j in range(4):
        ax2.bar(x_pos_arm[i], bd[j], w, bottom=sum(bd[:j]) if j>0 else 0, color=colors_bd[j])
for i, bd in enumerate([x86_flat_bd, x86_pqadc_bd, x86_fsv2_bd]):
    ax2.text(i, sum(bd)+0.03, f'{sum(bd):.2f}ms', ha='center', fontweight='bold', fontsize=9)

ax2.set_xticks(x_pos_arm)
ax2.set_xticklabels(['Flat-AVX2', 'PQ-ADC\nM16-p500', 'FastScan v2\nM16-p500-b128'])
ax2.set_ylabel('Latency (ms)'); ax2.set_title('x86 i9-14900HX', fontweight='bold')
ax2.legend(fontsize=8, loc='upper right'); ax2.grid(axis='y', alpha=0.3)

plt.suptitle('Query Time Breakdown by Phase', fontweight='bold', fontsize=13, y=1.02)
plt.tight_layout()
save('06_time_breakdown')

print("\n=== All 6 figures generated ===")
