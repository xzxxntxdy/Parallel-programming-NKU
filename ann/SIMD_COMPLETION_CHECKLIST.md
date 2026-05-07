# SIMD 实际完成 Checklist

本清单逐项对照 `SIMD.md` 和 `ANN_SIMD_REPORT_REQUIREMENTS.md`，记录当前仓库中的实际代码、真实运行数据、图表产物和最终报告状态。当前报告口径为单平台 ARM/aarch64 Kunpeng-920 NEON；不再要求多平台对比。

状态口径：

- 完成：代码已实现，并且已有当前平台真实运行数据或明确产物。
- 部分完成：代码路径或分析已存在，但缺少任务书要求的实测、扫描、图表或平台数据。
- 未完成/未实测：当前仓库没有对应代码、数据或图表。

当前硬事实：

- 当前允许直接 kernel 分析：本轮可以使用 `./main --kernel <kernel> <Q> <repeat>` 与 `./main --final-only`，不再强制只通过 `test.sh`。
- 当前默认主路径：`main.cc` 构建 `PQIndex(M=16, Ks=256, train_sample=2048, iters=10)` 和 block-major FastScan code layout，查询调用 `ann::pq_adc_fastscan_search_rerank_timed(...)`。
- 当前最终算法：`FastScan-ADC-M16-p1500-b64 + uint8 LUT + block scan + float rerank`。
- 当前正式 `test.sh` 结果：`average recall: 0.99995`、`average latency (us): 3056.39`。
- 当前最终 direct-kernel perf run：`fsadc-m16-p1500-b64`，`Q=2000`、`repeat=3`，latency `3.124 ms/query`、recall `0.99995`。
- benchmark CSV 规模：Flat 使用 `Q=100`，SQ8/PQ 使用 `Q=20`，每个配置 `repeat=5`。
- kernel/perf CSV 规模：直接 kernel 使用 `Q=2000`、`repeat=3`，perf counter 已在当前 ARM 平台采集。
- 当前真实数据文件：`files/results/simd_results.csv`、`files/results/simd_summary.csv`、`files/results/kernel_experiments.csv`、`files/results/kernel_stage_experiments.csv`、`files/results/perf_summary.csv`。
- 当前图表：已使用 `.venv` 中的 matplotlib/seaborn 重画，已生成 10 组 PNG + PDF + SVG。

## 1. 算法路线总览核对

| SIMD.md 编号 | 要求 | 当前完成情况 | 证据 |
|---|---|---|---|
| A0 | `flat_scalar_baseline` | 已完成 | `ann_search.h` 的 `kScalarNoVec`；CSV `Flat-Scalar-NoVec` |
| A1 | `flat_auto_vectorized` | 已完成 | `ann_search.h` 的 `kAutoVectorized`；CSV `Flat-AutoVec` |
| A2 | `flat_manual_simd_unaligned` | 已完成 | `ann_search.h` 的 `kManualNeon`；CSV `Flat-Manual-NEON` |
| A3 | aligned load 分析 | 完成 ARM 可验证项：已加入 aligned-hint 版本和地址对齐报告 | `Flat-NEON-AlignedHint`；`files/results/alignment_report.md` |
| A4 | SIMD unroll2/4 | 已完成 unroll2 和 unroll4 | `Flat-NEON-Unroll2`、`Flat-NEON-Unroll4` |
| A5 | SIMD prefetch | 已完成 prefetch distance 扫描 | `Flat-NEON-Unroll4-Prefetch-d{4,8,16,32,64}` |
| Top-k 优化 | fixed-array top-k | 已完成 Flat benchmark；最终 PQ 主路径进一步使用 `nth_element` Top-p | `FixedTopK`、`pq_adc_search_rerank_select` |
| B1 | `sq8_coarse_rerank` | 完成算法与 ARM 实测；另补 uint8 NEON 粗排探索 | `SQ8-rerank-*`、`SQ8-U8SIMD-rerank-*` |
| C1 | `pq_adc_m8` | 完成简化版 PQ-ADC 与 ARM 实测 | `PQ-ADC-M8-p{100,500,1000,2000,5000}` |
| C2 | `pq_adc_m12` | 完成简化版 PQ-ADC 与 ARM 实测 | `PQ-ADC-M12-p{100,500,1000,2000,5000}` |
| C3 | `pq_adc_m16` | 完成 PQ-ADC 与 ARM 实测；含 heap、select 和 FastScan-style ADC | `PQ-ADC-M16-*`、`pqsel-m16-p2000`、`fsadc-m16-p1500-b64` |
| C4 | `pq_sdc` | 已完成 PQ-SDC coarse-only 与 rerank | `PQ-SDC-M{8,12,16}-*` |
| C5 | `sdc_pipeline` | 已完成 2-stage / 3-stage producer-consumer pipeline | `SDC-Pipeline{2,3}-M16-p1000-b*` |
| C6 | `fastscan_style` | 已完成 ADC/SDC FastScan-style 实现与实验；参考本地 Faiss FastScan 设计 | `FastScan-ADC-*`、`FastScan-SDC-*` |
| D1 | x86 AVX/SSE | 不纳入最终报告 | 本次用户要求单平台分析 |
| D2 | ARM NEON | 已完成并实测 | 平台为 `ARM-aarch64-NEON` |

## 2. SQ8 计划核对

| SIMD.md 要求 | 当前状态 |
|---|---|
| per-dimension min/max | 已实现，见 `build_sq8_index` |
| `uint8_t` codes | 已实现，`SQ8Index::codes` |
| query LUT / 粗排 | 已实现，`sq8_search_rerank` 每 query 构建 `d x 256` LUT |
| Top-p 候选 | 已实现，使用 heap 保留 Top-p |
| float rerank | 已实现，候选回原始 float base 精排 |
| 参数扫描 `p={100,200,500,1000,2000,5000,10000}` | 已完成，CSV 有 7 组 SQ8 |
| 记录 latency / recall / index_size / build_time | 已完成，见 `files/results/simd_results.csv` |
| 粗排/精排分段计时 | 已完成，CSV 记录 `coarse_ms` 和 `rerank_ms` |
| SQ8 uint8 SIMD 粗排 | 已完成探索版，见 `SQ8-U8SIMD-rerank-*`；速度快但 recall 明显低于 LUT 版本 |
| SQ8 index 落盘 `files/indices/sq8.index` | 已完成 |

## 3. PQ-ADC 计划核对

| SIMD.md 要求 | 当前状态 |
|---|---|
| `PQIndex` | 已实现，见 `ann_quant.h` |
| `M={8,12,16}` | 已完成 |
| `Ks=256` | 已完成 |
| subdim=`96/M` | 已实现 |
| 简化 KMeans codebook | 已实现，当前为 2048 个训练样本、`mt19937(12345)` 固定 seed 打乱、迭代 10 次 |
| base 编码 | 已实现，所有 100000 条 base 都编码 |
| ADC LUT | 已实现，每 query 构建 `M x Ks` LUT |
| Top-p | 已实现，包含 heap 版和 `nth_element` select 版 |
| float rerank | 已实现 |
| 参数扫描 `p={100,500,1000,2000,5000}` | 已完成，3 个 M 共 15 组 |
| build_time / index_size | 已记录 |
| PQ index 落盘 `files/indices/pq_M*_Ks256.index` | 已完成 |
| ADC 固定展开/SIMD 优化 | 完成当前平台探索：`nth_element` Top-p + FastScan-style uint8 LUT + block-major scan |

## 4. 重复测量核对

当前 `files/results/simd_results.csv` 共 391 行，字段中 `k=10`；SQ/PQ/SDC/FastScan/Pipeline 已补充 `coarse_ms` 和 `rerank_ms`。该课程式 benchmark CSV 中 perf/cycles 字段仍为 0，真实 perf counter 已单独写入 `files/results/perf_summary.csv`：

```text
1 header
8 Flat methods x 5 runs = 40
5 prefetch-distance configs x 5 runs = 25
7 SQ8-LUT configs x 5 runs = 35
7 SQ8-U8SIMD configs x 5 runs = 35
15 PQ-ADC configs x 5 runs = 75
18 PQ-SDC configs x 5 runs = 90
6 FastScan configs x 5 runs = 30
12 SDC pipeline configs x 5 runs = 60
total = 391
```

说明：

- 当前没有显式 warmup 行；CSV 是每个配置重复 5 次的结果。
- Flat benchmark 用 `Q=100` 是为了控制整体耗时。
- SQ8/PQ benchmark 用 `Q=20`，因为构建和参数矩阵较重。
- 当前最终输出仍对前 `2000` 条 query 计时并打印平均 recall/latency。
- 直接 kernel 实验使用 `Q=2000`、`repeat=3`，写入 `files/results/kernel_experiments.csv`。

当前 direct-kernel 关键结果：

| kernel | latency mean ms | recall |
|---|---:|---:|
| flat-neon | 7.389 | 0.99995 |
| pq-m16-p500 | 3.011 | 0.996151 |
| pq-m16-p1000 | 3.508 | 0.999750 |
| pq-m16-p2000 | 4.450 | 0.999950 |
| pq-m8-p5000 | 5.074 | 0.999450 |
| pqsel-m16-p2000 | 3.584 | 0.999950 |
| fsadc-m16-p1500-b64 | 3.124 | 0.999950 |

## 5. 最终测试输出

当前源代码最终路径为 `FastScan-ADC-M16-p1500-b64 + float rerank`。正式运行：

```bash
bash test.sh 1 1
```

当前输出：

```text
average recall: 0.99995
average latency (us): 3056.39
```

PQ/FastScan index 构建耗时打印到 stderr，不计入每条 query 的计时窗口。最终性能已通过 `test.sh` 实测；direct-kernel 结果用于参数扫描和 perf 分析。

## 6. 图表核对

已由 `plot_simd_paper.py` 和 `analyze_perf_counters.py` 基于真实 CSV 生成；`plot_simd_results.py` 保留为兼容入口。当前共 10 组图，每组都有 `.png`、`.pdf`、`.svg`：

- `files/figures/fig_flat_speedup.png`
- `files/figures/fig_latency_recall.png`
- `files/figures/fig_pq_method_matrix.png`
- `files/figures/fig_rerank_sensitivity.png`
- `files/figures/fig_roofline_proxy.png`
- `files/figures/fig_prefetch_sweep.png`
- `files/figures/fig_coarse_rerank_breakdown.png`
- `files/figures/fig_perf_counter_comparison.png`
- `files/figures/fig_perf_cache_behavior.png`
- `files/figures/fig_perf_roofline.png`

PNG 文件已用 `file` 命令验证为有效 PNG。
PDF 文件已用 `file` 命令验证为有效 PDF。

已修复：

- `fig_pareto_frontier.*` 因信息量不足已删除。
- 新增 `fig_pq_method_matrix.*`，同时展示 ADC/SDC/FastScan/pipeline 的 latency、recall 和 speedup。
- `fig_perf_roofline.*` 已去掉点位重叠标签，改用右侧 summary box。

## 7. 当前关键结果摘要

来自 `files/results/simd_summary.csv`：

| method | latency mean ms | recall |
|---|---:|---:|
| PQ-ADC-M8-p100 | 1.330 | 0.650 |
| PQ-ADC-M8-p500 | 1.755 | 0.930 |
| SQ8-U8SIMD-rerank-p100 | 2.529 | 0.015 |
| PQ-ADC-M16-p500 | 2.881 | 1.000 |
| PQ-ADC-M8-p5000 | 5.121 | 1.000 |
| Flat-NEON-Unroll4-Prefetch-d4 | 5.796 | 1.000 |
| Flat-Manual-NEON | 6.586 | 1.000 |
| SQ8-rerank-p100 | 17.356 | 1.000 |

说明：本表的 query 数为 benchmark 矩阵设置，Flat 为 100 条 query，SQ/PQ 为 20 条 query，`k=10`；当前最终输出仍使用前 2000 条 query。

来自 `files/results/perf_summary.csv` 的 ARM direct-kernel perf 结果：

| kernel | cycles/query | inst/query | IPC | L1D miss rate | LLC miss rate |
|---|---:|---:|---:|---:|---:|
| flat-neon | 24.10M | 21.24M | 0.882 | 2.681% | 40.11% |
| pq-m16-p2000 | 12.84M | 21.66M | 1.687 | 0.599% | 17.16% |
| pqsel-m16-p2000 | 10.85M | 19.26M | 1.775 | 0.840% | 19.67% |
| fsadc-m16-p1500-b64 | 9.72M | 20.84M | 2.144 | 0.595% | 20.91% |

结论：FastScan-ADC 在保持 `recall=0.99995` 的同时，把 cycles/query 相对 Flat-NEON 降到约 40%，IPC 约提升 2.4x。

## 8. 任务书最终检查清单的实际状态

### 代码

| 检查项 | 状态 | 说明 |
|---|---|---|
| `main.cc` 能直接运行主程序 | 完成 | 支持默认运行、`--final-only`、`--kernel` |
| 新增文件都是 `.h` | 完成 | 新增核心代码为 `ann_search.h`、`ann_quant.h` |
| 没有修改 `test.sh` / `qsub.sh` | 完成 | 未修改禁改脚本 |
| 没有直接使用 `test_gt` 作为答案 | 完成 | `test_gt` 只用于 recall 评估 |
| 输出格式未破坏 | 完成 | 保留课程输出，同时额外写 CSV 到 `files/results/` |
| 最终算法与主结果一致 | 完成 | 当前主路径是 `FastScan-ADC-M16-p1500-b64`，并已通过 `test.sh` |
| 参数固定或可解释 | 完成 | repeat、Q、SQ/PQ/SDC/FastScan 参数写在 `main.cc` |
| 不会无限写文件/死循环 | 完成 | 只写固定 CSV 和图表文件 |

### 实验

| 检查项 | 状态 | 说明 |
|---|---|---|
| baseline | 完成 | `Flat-Scalar-NoVec` |
| manual SIMD | 完成 | `Flat-Manual-NEON`、`Flat-NEON-Unroll4` |
| auto-vectorization | 完成 | `Flat-AutoVec` |
| hand SIMD vs auto SIMD | 完成 | CSV/summary 可比较 |
| x86 vs ARM | 不要求 | 用户要求单平台分析 |
| 至少两个优化消融 | 完成 | aligned-hint、unroll2/4、prefetch sweep、fixed top-k |
| SQ 或 PQ latency-recall | 完成 | SQ8 与 PQ-ADC 都有真实 CSV |
| perf counters 或合理替代 | 完成 ARM direct-kernel | `perf stat` 已采集 flat、pq、pq-select、fsadc；详见 `perf_summary.csv` |
| 汇编分析 | 完成 | `files/analysis/main_O2.s`、`files/analysis/simd_assembly_summary.md` |
| 重复运行统计 | 完成 | 每配置 5 次，summary 有 mean/std |

### 图表

| 检查项 | 状态 | 说明 |
|---|---|---|
| speedup 图 | 完成 | `fig_flat_speedup.png` / `.svg` |
| latency-recall 图 | 完成 | `fig_latency_recall.png` / `.svg` |
| PQ 方法矩阵 | 完成 | `fig_pq_method_matrix.png` / `.svg` |
| x86 vs ARM | 不要求 | 单平台报告不包含该图 |
| perf counter breakdown | 完成 ARM direct-kernel | 已生成 `fig_perf_counter_comparison.*` 和 `fig_perf_cache_behavior.*` |
| roofline 或 rerank sensitivity | 完成 | 已生成 proxy roofline、真实 perf roofline 和 rerank sensitivity |
| 所有图来自真实 CSV | 完成 | benchmark 图读取 `simd_results.csv`/`kernel_experiments.csv`，perf 图读取 `perf_summary.csv` |
| PNG 输出 | 完成 | 10 个论文风格 PNG，300dpi 保存 |
| PDF 图 | 完成 | 10 个 PDF 均验证为 PDF 1.4 |

### 报告/交接

| 检查项 | 状态 | 说明 |
|---|---|---|
| 转交任务 md | 完成 | `SIMD_HANDOFF.md` |
| AI 对话附录 | 完成初稿 | `AI_APPENDIX.md`，最终提交前建议学生按真实对话再确认 |
| 进阶要求逐项回应 | 完成当前平台口径 | 已覆盖 Flat/SQ/PQ-SDC/PQ-ADC/SDC pipeline/FastScan/perf/汇编 |
| 不超过 15 页最终报告 | 完成初稿 | `ANN_SIMD_FINAL_REPORT.md` |

## 9. 当前不纳入报告的项目

这些项目不纳入当前单平台报告：

1. x86 vs ARM 真实跨平台实验：用户已明确本轮只做单平台分析。
2. OPQ / RaBitQ：`ANN_SIMD_REPORT_REQUIREMENTS.md` 已明确移除，不需要实现和实验。

## 10. 已完成产物核对

| 产物 | 状态 |
|---|---|
| `main.cc` | 已接入 `--kernel`、`--final-only`、FastScan-ADC 主路径和 benchmark CSV 生成 |
| `ann_search.h` | 已实现 Flat scalar/autovec/NEON/aligned-hint/unroll2/unroll4/prefetch/fixed top-k/SSE/AVX 路径 |
| `ann_quant.h` | 已实现 SQ8-LUT、SQ8-U8SIMD、PQ-ADC、PQ-SDC、FastScan-style ADC/SDC，含分段计时和索引保存 |
| `.venv/` | 已配置 Python 绘图环境，包含 numpy/pandas/matplotlib/seaborn |
| `requirements-plot.txt` | 已记录绘图依赖版本 |
| `plot_simd_paper.py` | 已实现 matplotlib/seaborn 论文风格 SVG/PNG/PDF 绘图 |
| `plot_simd_results.py` | 已保留为兼容入口，直接调用 `plot_simd_paper.py` |
| `analyze_perf_counters.py` | 已解析 perf CSV，生成 perf summary 与 perf 图 |
| `PERF_MEASUREMENT.md` | 已记录 perf 环境测试结果、直接 kernel 命令和真实 roofline 产物 |
| `PERF_EXPERIMENT_LOG.md` | 已记录 kernel/perf 优化过程和实验结果 |
| `ANN_SIMD_FINAL_REPORT.md` | 已完成最终报告初稿 |
| `analyze_simd_assembly.py` | 已生成静态汇编指令扫描 |
| `SIMD_HANDOFF.md` | 已写转交说明 |
| `AI_APPENDIX.md` | 已写 AI 辅助学习附录初稿 |
| `files/results/simd_results.csv` | 已生成真实 ARM 数据，391 行 |
| `files/results/simd_summary.csv` | 已生成 mean/std 汇总，43 行 |
| `files/results/simd_roofline.csv` | 已生成 roofline proxy 数据，43 行 |
| `files/results/kernel_experiments.csv` | 已生成 direct-kernel 实验日志 |
| `files/results/kernel_stage_experiments.csv` | 已生成 direct-kernel stage breakdown 日志 |
| `files/results/perf_summary.csv` | 已生成 ARM perf-counter 汇总 |
| `files/results/alignment_report.md` | 已生成地址对齐分析 |
| `files/analysis/simd_assembly_summary.md` | 已生成静态汇编分析 |
| `files/indices/sq8.index` | 已保存 SQ8 索引 |
| `files/indices/pq_M{8,12,16}_Ks256.index` | 已保存 PQ 索引 |
| `files/figures/*.png` | 已生成 10 张 PNG |
| `files/figures/*.svg` | 已生成 10 张 SVG |
| `files/figures/*.pdf` | 已生成 10 张 PDF |

## 11. 可交付结论

可以如实写入报告/交接文档的结论：

- Flat-SIMD、SQ8、PQ-ADC 三条主线均已有代码和 ARM 平台真实数据。
- 当前最终路径使用 `FastScan-ADC-M16-p1500-b64 + float rerank`，`test.sh` 结果为 `average recall: 0.99995`、`average latency (us): 3056.39`。
- runtime perf counters 已在 ARM direct-kernel 模式采集；FastScan-ADC 将 cycles/query 从 Flat-NEON 的约 24.10M 降到约 9.72M。
- 当前 PNG/SVG/PDF 绘图已重构为 matplotlib/seaborn 论文风格，适合用于报告插图。
- OPQ/RaBitQ 不纳入本次报告；x86 多平台对比也不纳入当前单平台分析。
