# ANN SIMD 单平台实验报告

## 摘要

本实验针对 DEEP100K 上的 ANN 查询阶段优化距离计算。实现并实测了 Flat-SIMD、SQ8-SIMD、PQ-SDC、PQ-ADC、SDC pipeline 和 FastScan-style PQ 扫描。最终提交路径为 `FastScan-ADC-M16-p1500-b64`：在 ARM/aarch64 Kunpeng-920 NEON 平台上，通过 `bash test.sh 1 1` 得到 `recall@10 = 0.99995`、平均查询延迟 `3056.39 us/query`。相比 Flat-NEON direct-kernel perf 基线，最终 kernel 的 cycles/query 从 `24.10M` 降至 `9.72M`，IPC 从 `0.88` 提升至 `2.14`。

OPQ 与 RaBitQ 按 `ANN_SIMD_REPORT_REQUIREMENTS.md` 要求不作为本次强制范围，主报告不实现、不绘图、不分析其误差。

## 1. 问题定义与指标

给定数据集 \(X=\{x_1,\dots,x_N\}\subset R^d\) 和查询向量 \(q\)，kNN 目标是找到距离最近的 \(k\) 个向量。ANNS 允许近似结果，以更低 latency 换取足够高的准确率。

本项目采用框架一致的内积距离：

\[
\delta(q,x)=1-\sum_i q_i x_i
\]

评价指标为：

\[
recall@k = \frac{|KNN(q)\cap KANN(q)|}{k}
\]

实验报告单 query latency、平均 recall@10、coarse/scan 时间、rerank 时间，以及 perf counter 中的 cycles/query、instructions/query、IPC 和 cache miss rate。

## 2. 数据与平台

| 项目 | 设置 |
|---|---|
| 数据集 | DEEP100K |
| base | 100000 vectors |
| query | 前 2000 条用于最终输出 |
| 维度 | d = 96 |
| k | 10 |
| 平台 | ARM aarch64 Kunpeng-920 |
| SIMD | NEON/ASIMD |
| 编译 | `g++ main.cc -O2 -fopenmp -lpthread -std=c++11` |
| 正式命令 | `bash test.sh 1 1` |

`test_gt` 只用于 recall 评估，没有作为答案输出。

## 3. 算法设计

### 3.1 Flat-SIMD

Flat search 遍历全部 base 向量并计算内积距离。实现包括 scalar no-vector、compiler autovec、manual NEON、aligned hint、unroll2/4、prefetch sweep 和 fixed-array top-k。Flat-SIMD 是精确基线，recall 接近 1，但需要读取约 \(100000\times 96\times 4=38.4\) MB/query 的 float base。

### 3.2 SQ8-SIMD

SQ8 对每维做 min/max 量化，把 base 从 float32 压缩为 uint8。实现了两条路径：

- `SQ8-rerank-p*`：float query LUT + Top-p + float rerank。
- `SQ8-U8SIMD-rerank-p*`：query 也量化为 uint8，用 NEON 做 uint8 dot 探索。

SQ8-LUT recall 高但 LUT/scan 开销大；uint8 SIMD 版本速度快，但当前量化误差明显，主要作为误差/速度对照。

### 3.3 PQ-SDC

PQ 将 96 维向量切成 \(M\) 个子空间，每个子空间 KMeans 得到 `Ks=256` 个中心，base 编码为 `M` 个 uint8 code。SDC 会把 query 也编码为 PQ code，并预计算中心间内积表：

\[
D_m[c_q,c_b]=\langle C_m[c_q], C_m[c_b]\rangle
\]

查询时累加：

\[
score(q,x_i)\approx \sum_m D_m[qcode_m][basecode_{i,m}]
\]

实验覆盖 `M={8,12,16}` 和 `p={0,100,500,1000,2000,5000}`，其中 `p=0` 表示 coarse-only，`p>0` 表示 SDC coarse + float rerank。

### 3.4 PQ-ADC

ADC 不编码 query，而是每条 query 在线构建 LUT：

\[
LUT_m[c]=\langle q_m,C_m[c]\rangle
\]

base scan 时对 PQ code 查表累加。相比 SDC，ADC 只量化 base，recall 通常更高。实现包括 heap Top-p 和 `nth_element` Top-p。`pqsel-m16-p2000` 是中间优化版本。

### 3.5 SDC Pipeline

SDC pipeline 将 batch 查询分成：

1. query PQ 编码；
2. SDC table lookup scan + Top-p；
3. float rerank。

实现了 2-stage 和 3-stage producer-consumer 版本，使用 bounded queue 控制 batch in-flight 数量，扫描 `batch_size={1,4,8,16,32,64}`。实验显示当前单节点单查询负载下，pipeline 的吞吐收益有限，主要原因是 scan 阶段占主导，query 编码阶段较短。

### 3.6 FastScan-Style

参考本地 Faiss FastScan 实现中的思路：

- `faiss/tests/test_fast_scan.py` 中 `pq4_pack_LUT` / `pq4_pack_codes` 展示了 LUT 与 code packing；
- `faiss/faiss/IndexIVFFastScan.cpp` 展示了 uint8 LUT、packed code 和 block scan 的组织。

本项目实现简化版 FastScan-style：

1. 输入仍是 PQ code；
2. 每 query 将 float LUT 全局量化为 uint8 LUT；
3. PQ code 按 block 重新组织为 block-major / part-major layout；
4. block 内使用整数 LUT 累加得到近似 score；
5. 对 Top-p 候选做原始 float rerank。

最终选择 `FastScan-ADC-M16-p1500-b64`，其中 `M=16`、`p=1500`、block size `64`。

## 4. 关键实验结果

### 4.1 最终 `test.sh` 输出

正式运行：

```bash
bash test.sh 1 1
```

输出：

```text
average recall: 0.99995
average latency (us): 3056.39
```

`test.e` 中仍有课程环境自身的 `pssh/pscp version.VERSION` 和 `/parallel_hw/... Permission denied` 提示，但主程序完成，且 `files/results/simd_results.csv` 已写出 391 行真实 benchmark 数据。

### 4.2 Kernel 扫描

| kernel | Q | repeat | latency ms/query | recall@10 | 结论 |
|---|---:|---:|---:|---:|---|
| `flat-neon` | 2000 | 3 | 7.389 | 0.99995 | 精确基线 |
| `pq-m16-p2000` | 2000 | 3 | 4.450 | 0.99995 | ADC heap Top-p |
| `pqsel-m16-p2000` | 2000 | 3 | 3.584 | 0.99995 | `nth_element` Top-p |
| `fsadc-m16-p1000-b32` | 2000 | 3 | 3.186 | 0.99975 | 更快但 recall 略降 |
| `fsadc-m16-p1500-b32` | 2000 | 3 | 3.415 | 0.99995 | recall 达标 |
| `fsadc-m16-p1500-b64` | 2000 | 3 | 3.179 | 0.99995 | 最终 direct-kernel 选择 |
| `fsadc-m16-p1500-b128` | 2000 | 3 | 3.293 | 0.99995 | block 过大略慢 |

### 4.3 SDC / FastScan / Pipeline 摘要

| method | latency ms/query | recall@10 | coarse/scan ms | rerank ms |
|---|---:|---:|---:|---:|
| `PQ-SDC-M8-p2000` | 2.526 | 0.925 | 2.054 | 0.470 |
| `PQ-SDC-M16-p1000` | 3.687 | 0.995 | 3.406 | 0.280 |
| `PQ-SDC-M16-p2000` | 3.949 | 1.000 | 3.421 | 0.528 |
| `FastScan-ADC-M16-p1000` | 2.925 | 1.000 | 2.661 | 0.262 |
| `FastScan-ADC-M16-p1500-b64` | 3.124 | 0.99995 | 2.747 | 0.376 |
| `FastScan-SDC-M16-p1000` | 3.118 | 0.995 | 2.829 | 0.286 |
| `SDC-Pipeline3-M16-p1000-b16` | 3.501 | 0.995 | 3.405 | 0.258 |

说明：表中 benchmark 矩阵的部分结果使用 `Q=20`，用于参数消融；最终性能以 `test.sh` 和 Q=2000 direct-kernel 为准。

### 4.4 perf counter

| kernel | cycles/query | inst/query | IPC | L1D miss | LLC miss | recall |
|---|---:|---:|---:|---:|---:|---:|
| `flat-neon` | 24.10M | 21.24M | 0.88 | 2.68% | 40.11% | 0.99995 |
| `pq-m16-p2000` | 12.84M | 21.66M | 1.69 | 0.60% | 17.16% | 0.99995 |
| `pqsel-m16-p2000` | 10.85M | 19.26M | 1.78 | 0.84% | 19.67% | 0.99995 |
| `fsadc-m16-p1500-b64` | 9.72M | 20.84M | 2.14 | 0.60% | 20.91% | 0.99995 |

FastScan-style 的主要收益来自 uint8 LUT 和 block-major scan 降低 scan 阶段 cycles，并提升 IPC。最终 kernel 比 Flat-NEON 少约 59.7% cycles/query。

## 5. 图表产物

已生成 PNG/PDF/SVG：

- `fig_flat_speedup.*`
- `fig_latency_recall.*`
- `fig_pq_method_matrix.*`
- `fig_rerank_sensitivity.*`
- `fig_roofline_proxy.*`
- `fig_prefetch_sweep.*`
- `fig_coarse_rerank_breakdown.*`
- `fig_perf_counter_comparison.*`
- `fig_perf_cache_behavior.*`
- `fig_perf_roofline.*`

原 `fig_pareto_frontier.*` 因信息量不足已删除，替换为 `fig_pq_method_matrix.*`。`fig_perf_roofline.*` 已改为右侧 summary box，不再在点附近堆叠文字。

## 6. 结论

本实验完成了单平台 ARM 上的 Flat、SQ8、PQ-SDC、PQ-ADC、SDC pipeline 和 FastScan-style 全流程实现与真实实验。最终 `FastScan-ADC-M16-p1500-b64` 在保持 `recall@10=0.99995` 的同时，把 `test.sh` 平均延迟降到 `3056.39 us/query`。perf counter 表明，优化后的 kernel cycles/query 低于 Flat-NEON 和普通 PQ-ADC，IPC 明显提高，说明查表扫描和 Top-p 选择已成为比原始 float 全量扫描更适合当前 ARM CPU 的执行形态。

## 附录：复现实验命令

```bash
cd /home/s2412235/Parallel-programming-NKU/ann
g++ main.cc -o main -O2 -fopenmp -lpthread -std=c++11
./main --kernel fsadc-m16-p1500-b64 2000 3
perf stat -x, -e cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses -o files/results/perf_fsadc_m16_p1500_b64_2000x3.csv ./main --kernel fsadc-m16-p1500-b64 2000 3
.venv/bin/python analyze_perf_counters.py
.venv/bin/python plot_simd_paper.py
bash test.sh 1 1
```
