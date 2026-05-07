# ANN SIMD Handoff

本文档用于把当前 ARM 平台上的 SIMD 阶段代码、数据采集和绘图流程转交给后续在其他平台运行的人。当前阶段只在一个平台完成并验证：OpenEuler 集群 ARM/aarch64 节点。

## 1. 当前完成状态

- 阶段：ANN / ANNS 选题的 SIMD 编程实验。
- 平台：ARM aarch64，Kunpeng-920，8 CPU，NEON/ASIMD。
- 编译器：GCC 10.3.1。
- 数据集：DEEP100K，代码默认从 `/anndata/` 读取。
- 当前最终主算法：`FastScan-ADC-M16-p1500-b64 + uint8 LUT + block scan + float rerank`。
- Flat 手写 NEON 仍作为基线保留在 `ann_search.h` 的 `Flat-Manual-NEON`，`flat_search_best` 仍可用于 Flat 对照，但当前 `main.cc` 默认查询路径已经切到 FastScan-ADC。
- 返回格式仍是 `std::priority_queue<std::pair<float, uint32_t>>`，与原始 `flat_search` 保持一致。
- 没有修改 `test.sh` 或 `qsub.sh`。
- 没有把 `test_gt` 作为答案输出，`test_gt` 只用于 recall 评估。

## 2. 关键文件

- `main.cc`
  - 读取 DEEP100K 数据。
  - 当前 2000 条 query 默认使用 `ann::pq_adc_fastscan_search_rerank_timed(...)`。
  - 支持 `./main --final-only` 跳过 benchmark，只跑最终路径。
  - 支持 `./main --kernel <kernel> <Q> <repeat>` 进行 direct-kernel 分析。
  - 额外采集 ARM 单平台 SIMD 消融数据，写入 `files/results/simd_results.csv`。

- `ann_search.h`
  - Header-only SIMD 实现。
  - 包含 scalar no-vector、auto-vectorized、manual NEON、aligned-hint、NEON unroll2/unroll4、prefetch、fixed-array top-k 等版本。
  - 包含历史 x86 SSE/AVX 代码路径；当前最终报告只使用 ARM 单平台数据。

- `ann_quant.h`
  - Header-only SQ8 和 PQ-ADC 实现。
  - SQ8 包含 min/max 量化、query LUT、Top-p 粗排、uint8 NEON 粗排探索、float rerank，并记录 coarse/rerank 分段耗时。
  - PQ-ADC 包含 KMeans codebook、base 编码、ADC LUT、Top-p 粗排、float rerank，并记录 coarse/rerank 分段耗时。
  - PQ-ADC 包含 heap Top-p、`nth_element` Top-p 和 FastScan-style ADC。
  - PQ-SDC、FastScan-style SDC 与 SDC pipeline 已补充，用于最终报告强制项。
  - 会保存 `files/indices/sq8.index` 和 `files/indices/pq_M*_Ks256.index`。

- `plot_simd_results.py`
  - 兼容入口，直接调用 `plot_simd_paper.py`。

- `plot_simd_paper.py`
  - matplotlib/seaborn 论文风格绘图脚本。
  - 读取 `files/results/simd_results.csv`。
  - 输出 `files/results/simd_summary.csv`、`files/results/simd_roofline.csv` 和 `files/figures/*.svg`、`files/figures/*.png`、`files/figures/*.pdf`。

- `requirements-plot.txt`
  - 记录绘图虚拟环境依赖版本。

- `PERF_MEASUREMENT.md`
  - 记录当前 `perf stat` 权限测试、direct-kernel 命令和真实 perf-counter roofline 产物。

- `PERF_EXPERIMENT_LOG.md`
  - 记录本轮 kernel sweep、perf counter 和最终优化结论。

- `analyze_perf_counters.py`
  - 解析 `perf stat -x,` CSV，输出 perf summary 和 perf 图。

- `analyze_simd_assembly.py`
  - 读取 `files/analysis/main_O2.s`。
  - 输出静态汇编扫描摘要；这是汇编证据，不是 runtime perf counter。

- `AI_APPENDIX.md`
  - 生成式 AI 辅助学习附录，记录设计、反馈、采纳、拒绝和验证。

- `SIMD_COMPLETION_CHECKLIST.md`
  - 逐项对照 `SIMD.md` 的完成清单。

- `files/results/simd_results.csv`
  - 原始实验数据，每个配置 5 次重复；Flat 每次取前 100 条 query，SQ/PQ 每次取前 20 条 query。

- `files/results/simd_summary.csv`
  - 绘图脚本聚合后的 mean/std。

- `files/results/kernel_experiments.csv`
  - direct-kernel 实验日志；当前关键实验使用 `Q=2000`、`repeat=3`。

- `files/results/perf_summary.csv`
  - 当前 ARM 平台 runtime perf counter 汇总。

- `files/figures/`
  - `fig_flat_speedup.svg`
  - `fig_flat_speedup.png`
  - `fig_flat_speedup.pdf`
  - `fig_latency_recall.svg`
  - `fig_latency_recall.png`
  - `fig_latency_recall.pdf`
  - `fig_pq_method_matrix.svg`
  - `fig_pq_method_matrix.png`
  - `fig_pq_method_matrix.pdf`
  - `fig_rerank_sensitivity.svg/png/pdf`
  - `fig_roofline_proxy.svg/png/pdf`
  - `fig_prefetch_sweep.svg/png/pdf`
  - `fig_coarse_rerank_breakdown.svg/png/pdf`
  - `fig_perf_counter_comparison.svg/png/pdf`
  - `fig_perf_cache_behavior.svg/png/pdf`
  - `fig_perf_roofline.svg/png/pdf`

## 3. 当前真实结果

当前最终直接输出，2000 条 query：

```text
average recall: 0.99995
average latency (us): 3056.39
```

命令：

```bash
./main --final-only
```

说明：PQ/FastScan index 构建耗时打印到 stderr，不计入每条 query 的计时窗口。最终性能已通过 `bash test.sh 1 1` 实测；direct-kernel/final-only 用于参数扫描和 perf 分析。

消融实验配置：每个配置重复 5 次，`k=10`；Flat 使用 `Q=100`，SQ/PQ 使用 `Q=20`。

| method | latency mean ms | latency std ms | recall |
|---|---:|---:|---:|
| PQ-ADC-M8-p100 | 1.330 | 0.011 | 0.650 |
| PQ-ADC-M8-p500 | 1.755 | 0.049 | 0.930 |
| SQ8-U8SIMD-rerank-p100 | 2.529 | 0.017 | 0.015 |
| PQ-ADC-M16-p500 | 2.881 | 0.008 | 1.000 |
| PQ-ADC-M8-p5000 | 5.121 | 0.261 | 1.000 |
| Flat-NEON-Unroll4-Prefetch-d4 | 5.796 | 0.021 | 1.000 |
| Flat-Manual-NEON | 6.586 | 1.092 | 1.000 |
| SQ8-rerank-p100 | 17.356 | 0.169 | 1.000 |

说明：benchmark 矩阵用于观察参数趋势，最终 2000-query 输出以 `bash test.sh 1 1` 为准。当前代码保留 `Flat-Manual-NEON` 作为精确基线；主提交路径已经切到 FastScan-ADC。

direct-kernel 关键结果，来自 `files/results/kernel_experiments.csv`：

| kernel | Q | repeat | latency mean ms | recall |
|---|---:|---:|---:|---:|
| flat-neon | 2000 | 3 | 7.389 | 0.99995 |
| pq-m16-p500 | 2000 | 3 | 3.011 | 0.996151 |
| pq-m16-p1000 | 2000 | 3 | 3.508 | 0.999750 |
| pq-m16-p2000 | 2000 | 3 | 4.450 | 0.999950 |
| pq-m8-p5000 | 2000 | 3 | 5.074 | 0.999450 |
| pqsel-m16-p2000 | 2000 | 3 | 3.584 | 0.999950 |
| fsadc-m16-p1500-b64 | 2000 | 3 | 3.124 | 0.999950 |

perf counter 关键结果，来自 `files/results/perf_summary.csv`：

| kernel | cycles/query | inst/query | IPC | L1D miss rate | LLC miss rate |
|---|---:|---:|---:|---:|---:|
| flat-neon | 24.10M | 21.24M | 0.882 | 2.681% | 40.11% |
| pq-m16-p2000 | 12.84M | 21.66M | 1.687 | 0.599% | 17.16% |
| pqsel-m16-p2000 | 10.85M | 19.26M | 1.775 | 0.840% | 19.67% |
| fsadc-m16-p1500-b64 | 9.72M | 20.84M | 2.144 | 0.595% | 20.91% |

## 4. 在当前平台运行

课程脚本仍可用于兼容验证：

```bash
cd /home/s2412235/Parallel-programming-NKU/ann
bash test.sh 1 1
```

本轮 kernel/perf 优化允许直接运行，推荐先编译：

```bash
g++ main.cc -o main -O2 -fopenmp -lpthread -std=c++11
```

只跑最终路径：

```bash
./main --final-only
```

跑单个 kernel：

```bash
./main --kernel flat-neon 2000 3
./main --kernel pq-m16-p2000 2000 3
./main --kernel pqsel-m16-p2000 2000 3
./main --kernel fsadc-m16-p1500-b64 2000 3
```

运行后检查：

```bash
sed -n '1,80p' test.o
sed -n '1,120p' test.e
sed -n '1,80p' files/results/simd_results.csv
tail -n 20 files/results/kernel_experiments.csv
```

`test.e` 中可能出现下面两类集群脚本告警，当前观察不影响主程序输出：

```text
AttributeError: module 'version' has no attribute 'VERSION'
/parallel_hw/ann/1/s2412235_1.log: Permission denied
```

## 5. 绘图流程

已在项目内配置 `.venv`，当前版本：

```text
numpy==2.0.2
pandas==2.3.3
matplotlib==3.9.4
seaborn==0.13.2
```

如果在新平台重新配置：

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements-plot.txt
```

先通过 `test.sh` 或 direct-kernel 生成真实 CSV，再运行 benchmark 绘图：

```bash
.venv/bin/python plot_simd_paper.py
```

输出：

```text
files/results/simd_summary.csv
files/results/simd_roofline.csv
files/figures/fig_flat_speedup.svg
files/figures/fig_flat_speedup.png
files/figures/fig_flat_speedup.pdf
files/figures/fig_latency_recall.svg
files/figures/fig_latency_recall.png
files/figures/fig_latency_recall.pdf
files/figures/fig_pq_method_matrix.svg
files/figures/fig_pq_method_matrix.png
files/figures/fig_pq_method_matrix.pdf
files/figures/fig_rerank_sensitivity.svg
files/figures/fig_rerank_sensitivity.png
files/figures/fig_rerank_sensitivity.pdf
files/figures/fig_roofline_proxy.svg
files/figures/fig_roofline_proxy.png
files/figures/fig_roofline_proxy.pdf
files/figures/fig_prefetch_sweep.svg
files/figures/fig_prefetch_sweep.png
files/figures/fig_prefetch_sweep.pdf
files/figures/fig_coarse_rerank_breakdown.svg
files/figures/fig_coarse_rerank_breakdown.png
files/figures/fig_coarse_rerank_breakdown.pdf
```

脚本依赖 matplotlib/seaborn，输出为论文风格图；PNG 为 300dpi，PDF/SVG 为矢量优先。

perf counter 图生成流程：

```bash
perf stat -x, -e cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses -o files/results/perf_flat_neon_2000x3.csv ./main --kernel flat-neon 2000 3
perf stat -x, -e cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses -o files/results/perf_pq_m16_p2000_2000x3.csv ./main --kernel pq-m16-p2000 2000 3
perf stat -x, -e cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses -o files/results/perf_pqsel_m16_p2000_2000x3.csv ./main --kernel pqsel-m16-p2000 2000 3
perf stat -x, -e cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses -o files/results/perf_fsadc_m16_p1500_b64_2000x3.csv ./main --kernel fsadc-m16-p1500-b64 2000 3
.venv/bin/python analyze_perf_counters.py
```

输出：

```text
files/results/perf_summary.csv
files/figures/fig_perf_counter_comparison.svg/png/pdf
files/figures/fig_perf_cache_behavior.svg/png/pdf
files/figures/fig_perf_roofline.svg/png/pdf
```

汇编静态分析流程：

```bash
mkdir -p files/analysis
g++ main.cc -O2 -fopenmp -lpthread -std=c++11 -S -o files/analysis/main_O2.s
python3 analyze_simd_assembly.py
```

输出：

```text
files/analysis/main_O2.s
files/analysis/assembly_instruction_counts.csv
files/analysis/simd_assembly_summary.md
```

注意：这只是静态汇编扫描；`cycles/instructions/CPI/cache miss` 已通过上面的 direct-kernel `perf stat` 流程采集。

## 6. 进阶完成状态

在“当前只能使用一个平台”的限制下，已完成以下进阶项：

- 手写 SIMD vs 编译器自动向量化：已完成。CSV 包含 `Flat-Scalar-NoVec`、`Flat-AutoVec`、`Flat-Manual-NEON`。
- 其他优化策略：已完成。实现并记录 aligned-hint、`unroll2/4`、prefetch distance sweep、`fixed-array top-k`。
- SQ8 coarse + rerank：已完成。扫描 `p={100,200,500,1000,2000,5000,10000}`。
- SQ8 uint8 SIMD 粗排：已完成探索版。速度显著快于 LUT SQ8，但 recall 明显较低，报告中应作为对比而非推荐方案。
- PQ-ADC + rerank：已完成。扫描 `M={8,12,16}`、`p={100,500,1000,2000,5000}`。
- PQ-select 优化：已完成。`pqsel-m16-p2000` 使用 `nth_element` 选择 Top-p，是中间优化路径。
- PQ-SDC：已完成。包含 coarse-only、rerank 和 M/p 扫描。
- SDC pipeline：已完成。包含 2-stage、3-stage 和 batch size 扫描。
- FastScan-style：已完成。包含 ADC/SDC 简化实现；最终主路径为 `fsadc-m16-p1500-b64`。
- 自由分析：已完成。生成 speedup、latency-recall、PQ method matrix、rerank sensitivity、roofline proxy、prefetch sweep、coarse/rerank breakdown、perf counter、cache behavior、perf roofline 十类图，并同时输出 SVG、PNG、PDF。
- 汇编分析：已完成静态汇编扫描，见 `files/analysis/simd_assembly_summary.md`。
- perf 权限：`perf stat` 在当前环境可运行，已对 direct-kernel 采集 cycles/instructions/cache counters，详见 `PERF_MEASUREMENT.md` 和 `PERF_EXPERIMENT_LOG.md`。
- AI 辅助学习附录：已完成，见 `AI_APPENDIX.md`。
- x86 vs ARM：本轮不要求，多平台内容不写入最终主报告。

## 7. 在其他平台接手

### 7.1 数据准备

当前代码默认读取：

```text
/anndata/DEEP100K.query.fbin
/anndata/DEEP100K.gt.query.100k.top100.bin
/anndata/DEEP100K.base.100k.fbin
```

如果其他平台没有 `/anndata/`，有两种做法：

1. 把 DEEP100K 文件放到同样的 `/anndata/` 路径。
2. 临时修改 `main.cc` 中的 `data_path`，但提交回课程集群前要改回 `/anndata/`。

### 7.2 编译运行

课程提交兼容流程：

```bash
bash test.sh 1 1
```

direct-kernel 分析或非课程平台复现实验可以用：

```bash
g++ main.cc -o main -O2 -fopenmp -lpthread -std=c++11
./main --final-only
./main --kernel fsadc-m16-p1500-b64 2000 3
.venv/bin/python plot_simd_paper.py
```

### 7.3 单平台口径

本轮最终报告只写 ARM 单平台。`ann_search.h` 中保留的 SSE/AVX 代码路径不作为主报告结果，不生成 x86 vs ARM 图，也不在 checklist 中列为未完成项。

## 8. 提交前检查

- 新增参与编译的 C++ 文件只有 `.h`。
- `test.sh` / `qsub.sh` 没有改动。
- `flat_scan.h` 没有改动。
- `test.o` 保留两行官方输出。
- `files/results/simd_results.csv` 来自真实运行，不手填。
- `files/figures/*.svg` 和 `files/figures/*.png` 由 `plot_simd_paper.py` 生成。
- `files/figures/*.pdf` 由 `plot_simd_paper.py` 生成。
- 如果换了最终算法，报告应和 `main.cc` 的默认查询路径保持一致；`flat_search_best` 现在只是 Flat 基线入口。
