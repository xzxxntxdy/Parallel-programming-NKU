# ANN SIMD 实验报告要求（强制完成版，移除 OPQ / RaBitQ）

> 适用范围：并行程序设计实验，选题为 **ANN / ANNS**，阶段为 **SIMD 编程实验**。  
> 本文件只规定本次 ANN-SIMD 报告的强制要求。  
> 当前强制算法范围：**Flat-SIMD、SQ-SIMD、PQ-SDC、PQ-ADC、SDC 流水线、FastScan**。  
> **OPQ 和 RaBitQ 不作为本次报告强制要求，不需要实现、不需要实验、不需要绘图，也不需要写入主报告。**  
> 报告中的性能数据必须来自真实运行，禁止伪造。

---

## 1. 总体强制目标

SIMD 阶段报告必须围绕 ANN 查询阶段的距离计算优化展开，并完整覆盖第 3.1 节中与本次任务相关的强制内容：

1. **朴素 Flat-SIMD 距离计算**：对欧几里得距离或内积距离进行 SIMD 加速。
2. **SQ-SIMD**：Scalar Quantization，将 float32 量化为 uint8，并分析 SIMD 在 uint8 距离计算中的作用。
3. **PQ-SIMD**：Product Quantization，包含向量切分、子空间聚类、base 编码、查表距离计算。
4. **PQ-SDC**：对称距离计算，query 也进行 PQ 编码，通过预计算中心间距离表进行查表累加。
5. **PQ-ADC**：非对称距离计算，query 不编码，在线构建局部 LUT，再对 base code 查表累加。
6. **SDC 流水线并行**：批量查询场景下的生产者-消费者流水线，重叠 query 编码、查表累加、结果重排。
7. **FastScan**：作为 PQ 查表累加阶段的强制优化方向，报告必须说明原理、实现设计、实验对比和性能分析。

最终报告不能只实现 Flat-SIMD。必须把 **Flat、SQ、PQ-SDC、PQ-ADC、SDC pipeline、FastScan** 全部纳入方法、实验和分析。

不需要完成：

- OPQ / Optimized Product Quantization。
- RaBitQ。
- OPQ / RaBitQ 的代码实现、实验结果、图表、误差分析、理论复现。

---

## 2. 报告基本格式要求

报告必须满足：

- 不超过 15 页。
- 符合科技论文写作规范。
- 附 Git 项目链接。
- 包含问题描述、SIMD 算法设计、复杂度分析、实现伪代码、实验设置、结果分析、进阶要求完成情况。
- 如果使用生成式 AI，必须将对话记录作为附录，并说明 AI 只是辅助学习，不是代写代码。

建议结构：

```text
1. 摘要
2. 问题定义与评价指标
3. SIMD 算法设计
   3.1 Flat-SIMD
   3.2 SQ-SIMD
   3.3 PQ-SDC
   3.4 PQ-ADC
   3.5 SDC 流水线并行
   3.6 FastScan
4. 实现细节
5. 实验环境与实验设置
6. 实验结果与分析
7. 进阶要求完成情况
8. 总结
附录 A：AI 辅助学习记录
附录 B：关键代码、汇编、perf 输出
```

---

## 3. 问题定义与评价指标强制要求

报告必须说明 NNS、ANNS、latency 和 recall@k。

### 3.1 kNN / ANNS 定义

给定数据集：

```text
X = {x1, x2, ..., xN} ⊂ R^d
q ∈ R^d
```

kNN 目标是找到距离 query 最近的 k 个向量。ANNS 不要求返回完全精确的 kNN，只要求在较高准确率下减少查询时间。

### 3.2 recall@k

必须写出：

```text
recall@k = |KNN(q) ∩ KANN(q)| / k
```

其中：

- `KNN(q)`：精确搜索结果。
- `KANN(q)`：近似搜索结果。
- `k`：返回候选数量。

### 3.3 latency

必须记录：

- 单 query latency。
- 总 query time。
- throughput / QPS，可选但推荐。
- 对于 PQ-SDC / PQ-ADC / FastScan，需要拆分：
  - query 编码时间；
  - LUT 或中心间距离表相关时间；
  - scan 查表累加时间；
  - top-k / top-p 维护时间；
  - rerank 时间。

---

## 4. 数据集与代码框架强制要求

报告中必须写明：

- 数据集：`DEEP100K`。
- 向量类型：图片向量。
- 向量维度：`d = 96`。
- `base` 和 `test_query` 类型为 `float*`。
- `test_gt` 是查询答案，只能用于准确率评估。
- 严禁直接把 `test_gt` 作为输出答案。

框架中已有朴素串行暴力搜索：

```cpp
auto res = flat_search(base, test_query + i * vecdim, base_number, vecdim, k);
```

需要自己实现更优算法并替换该调用，但返回值格式必须与框架示例一致。

新增文件要求：

- 新增代码文件必须使用 `.h`，即 header-only。
- 不建议新增需要独立编译链接的 `.cc/.cpp` 文件。

---

## 5. 运行与提交强制要求

### 5.1 正确运行方式

```bash
cd ann
bash test.sh 1 1
```

含义：

- 第一个参数 `1` 表示 SIMD 实验。
- 第二个参数 `1` 表示申请 1 个计算节点。
- SIMD 实验只能申请 1 个节点。

### 5.2 禁止事项

必须遵守：

- 不允许直接运行 `./main` 作为正式测试方式。
- 不允许修改、破解或绕过 `test.sh`。
- 不允许修改 `qsub.sh`。
- 不允许删除或修改已有标准输出。
- 不允许把大量中间文件写到 `files/` 之外。
- 不允许直接输出 `test_gt`。
- 不允许伪造实验数据。

### 5.3 qsub 管理

查看任务：

```bash
qstat
qstat -n
```

终止异常任务：

```bash
qdel num.master_ubss1
```

---

## 6. 强制算法 1：Flat-SIMD

### 6.1 必须说明的内容

Flat-SIMD 是基础算法，报告必须重点说明：

- 原始 Flat Search 对每个 query 遍历全部 base 向量。
- 距离函数是欧几里得距离或内积距离，必须与框架评价保持一致。
- SIMD 如何加速距离计算。
- `d=96` 如何被拆成 SIMD chunk。
- SIMD 浮点求和顺序变化可能带来微小误差。

### 6.2 距离公式

欧几里得距离：

```text
δ(x, y) = Σ_i (x_i - y_i)^2
```

内积距离：

```text
δ(x, y) = 1 - Σ_i x_i y_i
```

### 6.3 SIMD chunk 数值分析

对于 `d = 96`：

| SIMD ISA | 寄存器位宽 | float32 lanes | 每个向量 chunk 数 |
|---|---:|---:|---:|
| SSE / NEON | 128 bit | 4 | 96 / 4 = 24 |
| AVX / AVX2 | 256 bit | 8 | 96 / 8 = 12 |
| AVX-512 | 512 bit | 16 | 96 / 16 = 6 |

报告必须解释：理论 lane 数不等于最终 speedup，因为 Flat Search 仍受访存、top-k 维护、水平求和、分支和 cache 行为影响。

### 6.4 必做实验

必须比较：

| 方法 | 强制 |
|---|---|
| Flat-Scalar baseline | 是 |
| Flat-AutoVec，编译器自动向量化 | 是 |
| Flat-Manual-SIMD，手写 SIMD | 是 |
| Flat-Manual-SIMD + loop unroll | 是 |
| Flat-Manual-SIMD + top-k 优化 | 是 |
| Flat-Manual-SIMD + prefetch 或对齐分析 | 是 |

---

## 7. 强制算法 2：SQ-SIMD

### 7.1 必须说明的内容

SQ，即 Scalar Quantization，将原始 float32 向量逐维量化为 uint8。报告必须说明：

- float32 每维 4 字节。
- uint8 每维 1 字节。
- SQ 理论上将 base 存储压缩约 4 倍。
- 128-bit SIMD 一次可处理 16 个 uint8，而不是 4 个 float32。
- SQ 会引入量化误差，因此必须报告 recall@k。

### 7.2 数值分析

DEEP100K 中：

```text
N = 100000
d = 96
float32 base size = 100000 × 96 × 4 = 38.4 MB
uint8 base size   = 100000 × 96 × 1 = 9.6 MB
压缩比 = 4×
```

如果 SQ 使用 coarse search + float rerank，rerank 候选数为 `p`：

```text
rerank bytes = p × 96 × 4
```

例如：

| p | rerank 读取量 |
|---:|---:|
| 100 | 38.4 KB |
| 500 | 192 KB |
| 1000 | 384 KB |
| 2000 | 768 KB |
| 5000 | 1.92 MB |

### 7.3 必做实验

必须扫描：

```text
p ∈ {100, 200, 500, 1000, 2000, 5000}
```

必须报告：

- SQ coarse search latency。
- rerank latency。
- total latency。
- recall@k。
- index size。
- 与 Flat-SIMD 的 speedup。

必须绘制：

- SQ latency-recall 曲线。
- SQ p-sensitivity 曲线。

---

## 8. 强制算法 3：PQ-SDC

### 8.1 必须说明的内容

PQ-SDC，即 Product Quantization with Symmetric Distance Computation。报告必须说明：

1. base 向量被切分为 `M` 个子空间。
2. 每个子空间用 KMeans 聚类得到 `Ks` 个中心，通常 `Ks=256`。
3. base 向量每个子空间用最近中心 ID 表示。
4. query 向量也被 PQ 编码。
5. 预计算每个子空间中 `Ks × Ks` 的中心间距离表。
6. 查询距离通过查表累加得到。

### 8.2 SDC 距离计算

对每个子空间 `m`：

```text
base_code[i][m] = c_b
query_code[q][m] = c_q
D_m[c_q][c_b] = distance(center_m[c_q], center_m[c_b])
```

则：

```text
dist(q, x_i) ≈ Σ_m D_m[query_code[q][m]][base_code[i][m]]
```

### 8.3 数值分析

设：

```text
d = 96
Ks = 256
M ∈ {8, 12, 16}
subdim = d / M
```

base code 大小：

| M | subdim | 每向量 code bytes | base code size | 每 query 查表次数 |
|---:|---:|---:|---:|---:|
| 8 | 12 | 8 B | 0.8 MB | 0.8M |
| 12 | 8 | 12 B | 1.2 MB | 1.2M |
| 16 | 6 | 16 B | 1.6 MB | 1.6M |

SDC 中心间距离表大小：

```text
M × Ks × Ks × 4 bytes
```

例如：

| M | SDC distance table size |
|---:|---:|
| 8 | 8 × 256 × 256 × 4 = 2.0 MB |
| 12 | 3.0 MB |
| 16 | 4.0 MB |

### 8.4 必做实验

必须扫描：

```text
M ∈ {8, 12, 16}
p ∈ {100, 500, 1000, 2000, 5000}
```

其中 `p` 是可选 rerank 候选数。即使 SDC 本身可直接返回 Top-k，报告也必须比较：

- SDC coarse-only。
- SDC + float rerank。

必须报告：

- query PQ 编码时间。
- SDC 查表累加时间。
- top-p / top-k 时间。
- rerank 时间。
- total latency。
- recall@k。
- index size。

必须绘制：

- PQ-SDC latency-recall 曲线。
- M 对 SDC recall / latency 的影响。
- SDC coarse-only vs SDC + rerank 对比。

---

## 9. 强制算法 4：PQ-ADC

### 9.1 必须说明的内容

PQ-ADC，即 Product Quantization with Asymmetric Distance Computation。报告必须说明：

1. base 向量仍然被 PQ 编码。
2. query 向量不进行 PQ 编码。
3. 每个 query 在线计算其原始子向量到每个子空间聚类中心的距离。
4. 为该 query 生成局部 LUT。
5. base 扫描时根据 base code 查 LUT 并累加。

### 9.2 ADC 距离计算

对每个 query，构建：

```text
LUT[m][c] = distance(q_m, center_m[c])
```

对 base 向量 `x_i`：

```text
dist(q, x_i) ≈ Σ_m LUT[m][base_code[i][m]]
```

### 9.3 ADC vs SDC 必须对比

报告必须明确比较：

| 项 | SDC | ADC |
|---|---|---|
| query 是否编码 | 是 | 否 |
| 是否需要中心间距离表 | 是 | 否 |
| 是否需要每 query 构建 LUT | 否或很少 | 是 |
| 误差来源 | base 与 query 都量化 | 只量化 base |
| recall 预期 | 较低 | 通常较高 |
| 实时查询权衡 | query 编码 + 查表 | LUT 构建 + 查表 |

### 9.4 必做实验

必须扫描：

```text
M ∈ {8, 12, 16}
p ∈ {100, 500, 1000, 2000, 5000}
```

必须报告：

- ADC LUT 构建时间。
- ADC 查表累加时间。
- top-p / top-k 时间。
- rerank 时间。
- total latency。
- recall@k。
- index size。

必须绘制：

- PQ-ADC latency-recall 曲线。
- ADC vs SDC 的同图对比。
- ADC LUT 构建时间占比。

---

## 10. 强制算法 5：SDC 流水线并行

### 10.1 必须说明的内容

SDC 在批量查询场景下可用生产者-消费者模型做流水线并行。报告必须说明：

- SDC 需要对 query 进行 PQ 编码。
- query 编码阶段可以与前一批 query 的查表累加阶段重叠。
- 还可以单独设置结果重排或 rerank 阶段。

### 10.2 推荐流水线结构

```text
Stage 1: Query PQ encoding
Stage 2: SDC table lookup scan
Stage 3: Top-k merge / rerank / reorder
```

批量查询时：

```text
Batch t     : Stage 2 scan
Batch t + 1 : Stage 1 encode
Batch t - 1 : Stage 3 reorder
```

### 10.3 必做实验

必须比较：

| 方法 | 强制 |
|---|---|
| SDC sequential | 是 |
| SDC pipeline, 2 stages | 是 |
| SDC pipeline, 3 stages | 是 |

必须扫描：

```text
batch_size ∈ {1, 4, 8, 16, 32, 64}
```

必须报告：

- latency per query。
- throughput。
- query encoding time。
- scan time。
- reorder / rerank time。
- pipeline speedup。
- 不同 batch size 下的性能变化。

必须绘制：

- batch size vs throughput。
- batch size vs latency。
- sequential SDC vs pipeline SDC。
- pipeline stage time breakdown。

---

## 11. 强制算法 6：FastScan

### 11.1 必须说明的内容

FastScan 是 PQ 查表累加阶段的优化方向。报告必须说明：

- 普通 PQ-ADC / PQ-SDC 的瓶颈在于大量 LUT 查表和累加。
- LUT 查表可能受 cache、随机访问、指令调度影响。
- FastScan 的核心思想是让查表累加更适合 SIMD 和 cache/register 层级。
- 需要解释其与普通 PQ 扫描的区别。

### 11.2 报告中必须覆盖的 FastScan 设计点

至少覆盖以下内容：

1. **LUT 量化**：将 float LUT 转为低比特或整数 LUT，降低寄存器和 cache 压力。
2. **SIMD register lookup**：尽量用 SIMD shuffle / permute / table lookup 在寄存器中完成查表。
3. **block scan**：按 block 组织 code，使多个候选共享 LUT 加载。
4. **累加方式优化**：减少标量查表、分支和内存访问。
5. **与 naive PQ scan 对比**：必须说明 FastScan 优化的是 scan 阶段，而不是 PQ 训练阶段。

### 11.3 最低实现要求

FastScan 必须有实验。允许实现简化版本，但必须满足：

- 输入仍是 PQ code。
- 输出仍是近似距离或 Top-p / Top-k。
- 至少对一个固定配置实现，例如：

```text
M = 8
Ks = 256
p ∈ {100, 500, 1000, 2000}
```

如果完整论文版 FastScan 难度过高，必须实现一个“FastScan-style”版本，例如：

- LUT 量化为 uint8 / int16。
- code 分 block 存储。
- SIMD 批量处理多个候选。
- 与 naive PQ-ADC scan 逐项对比。

不能只写文献综述，必须有实际实验或可运行的简化实现。

### 11.4 必做实验

必须比较：

| 方法 | 强制 |
|---|---|
| Naive PQ-ADC scan | 是 |
| Naive PQ-SDC scan | 是 |
| FastScan-style ADC | 是 |
| FastScan-style SDC，可选但推荐 | 推荐 |

必须报告：

- scan time。
- total query time。
- recall@k。
- LUT 量化误差。
- index/code layout 变化。
- SIMD 指令或汇编差异。

必须绘制：

- naive PQ vs FastScan scan time。
- naive PQ vs FastScan latency-recall。
- FastScan 的 scan time breakdown。

---

## 12. 强制实验矩阵

### 12.1 Flat-SIMD 实验矩阵

| ID | 方法 | 强制 |
|---|---|---|
| F0 | Flat-Scalar | 是 |
| F1 | Flat-AutoVec | 是 |
| F2 | Flat-Manual-SIMD | 是 |
| F3 | Flat-Manual-SIMD + unroll | 是 |
| F4 | Flat-Manual-SIMD + top-k optimization | 是 |
| F5 | Flat-Manual-SIMD + prefetch/alignment analysis | 是 |

### 12.2 SQ 实验矩阵

| ID | p | 强制 |
|---|---:|---|
| SQ100 | 100 | 是 |
| SQ200 | 200 | 是 |
| SQ500 | 500 | 是 |
| SQ1000 | 1000 | 是 |
| SQ2000 | 2000 | 是 |
| SQ5000 | 5000 | 是 |

### 12.3 PQ-SDC 实验矩阵

| ID | M | p | 强制 |
|---|---:|---:|---|
| SDC8-100 | 8 | 100 | 是 |
| SDC8-500 | 8 | 500 | 是 |
| SDC8-1000 | 8 | 1000 | 是 |
| SDC8-2000 | 8 | 2000 | 是 |
| SDC8-5000 | 8 | 5000 | 是 |
| SDC12-1000 | 12 | 1000 | 是 |
| SDC16-1000 | 16 | 1000 | 是 |

### 12.4 PQ-ADC 实验矩阵

| ID | M | p | 强制 |
|---|---:|---:|---|
| ADC8-100 | 8 | 100 | 是 |
| ADC8-500 | 8 | 500 | 是 |
| ADC8-1000 | 8 | 1000 | 是 |
| ADC8-2000 | 8 | 2000 | 是 |
| ADC8-5000 | 8 | 5000 | 是 |
| ADC12-1000 | 12 | 1000 | 是 |
| ADC16-1000 | 16 | 1000 | 是 |

### 12.5 SDC Pipeline 实验矩阵

| ID | batch size | stages | 强制 |
|---|---:|---:|---|
| PIPE1 | 1 | sequential | 是 |
| PIPE4 | 4 | 2-stage | 是 |
| PIPE8 | 8 | 2-stage | 是 |
| PIPE16 | 16 | 3-stage | 是 |
| PIPE32 | 32 | 3-stage | 是 |
| PIPE64 | 64 | 3-stage | 是 |

### 12.6 FastScan 实验矩阵

| ID | 方法 | 强制 |
|---|---|---|
| FS0 | Naive PQ-ADC | 是 |
| FS1 | FastScan-style PQ-ADC | 是 |
| FS2 | Naive PQ-SDC | 是 |
| FS3 | FastScan-style PQ-SDC | 推荐 |

---

## 13. 进阶要求强制完成项

### 13.1 手写 SIMD vs 自动向量化

必须比较：

| 版本 | 说明 |
|---|---|
| Scalar | 朴素循环或禁用自动向量化 |
| Auto-vectorized | 编译器 `-O2` 自动向量化 |
| Manual SIMD | 手写 NEON / SSE / AVX intrinsics |

必须分析：

- latency。
- speedup。
- 汇编指令差异。
- packed SIMD 指令数量。
- scalar 指令是否残留。
- cycles、instructions、CPI。

### 13.2 x86 vs ARM SIMD 对比

必须比较至少两个平台或 ISA。如果硬件条件有限，需说明限制，并至少完成本地 x86 与集群 ARM / NEON 的可复现实验。

报告必须分析：

- SIMD 位宽。
- float lane 数。
- FMA 支持。
- load/store 指令。
- cache 和内存带宽。
- 编译器生成代码差异。
- 为什么同一算法在不同平台速度不同。

### 13.3 其他优化策略

至少强制完成以下 3 项：

- loop unroll。
- top-k 维护优化。
- prefetch 或 alignment 分析。

推荐补充：

- query 向量预加载。
- AoS / SoA 数据布局对比。
- cache blocking。
- block scan。

### 13.4 AI 辅助学习附录

如果使用 AI，必须记录：

- 自己的初始设计。
- 提问内容。
- AI 建议。
- 自己采纳或拒绝的理由。
- 修改后的实现。
- 实验验证。

不能让 AI 直接代写完整程序后提交。

---

## 14. 强制图表清单

报告必须至少包含以下图表：

1. **Flat-SIMD speedup 图**：Scalar、AutoVec、Manual SIMD、Unroll、Top-k 优化。
2. **SQ latency-recall 曲线**：不同 `p`。
3. **PQ-SDC latency-recall 曲线**：不同 `M` 和 `p`。
4. **PQ-ADC latency-recall 曲线**：不同 `M` 和 `p`。
5. **ADC vs SDC 对比图**：同一 `M,p` 下比较 latency 和 recall。
6. **SDC pipeline 图**：batch size vs throughput / latency。
7. **FastScan 对比图**：naive PQ scan vs FastScan-style scan。
8. **PQ scan time breakdown 图**：LUT/query 编码、scan、top-k、rerank。
9. **x86 vs ARM SIMD 对比图**。
10. **perf counter 或汇编分析图/表**：cycles、instructions、CPI、cache miss 或关键指令数量。
11. **Pareto frontier 图**：展示 latency-recall 非支配配置。

不需要包含：

- OPQ 量化误差图。
- RaBitQ 距离误差图。
- OPQ / RaBitQ latency-recall 图。

---

## 15. 数值分析强制要求

### 15.1 Flat 数值分析

必须写出：

```text
N = 100000
d = 96
float32 = 4 bytes
base size = 100000 × 96 × 4 = 38.4 MB
per-query Flat scan reads ≈ 38.4 MB
inner-product multiply-add count = 100000 × 96 = 9.6M
```

### 15.2 SQ 数值分析

必须写出：

```text
SQ uint8 base size = 100000 × 96 × 1 = 9.6 MB
compression ratio = 4×
rerank bytes = p × 96 × 4
```

### 15.3 PQ-SDC / PQ-ADC 数值分析

必须写出：

```text
M = number of subspaces
Ks = 256
subdim = 96 / M
base code size = N × M bytes
ADC LUT size = M × Ks × 4 bytes
SDC table size = M × Ks × Ks × 4 bytes
scan lookup count = N × M
```

必须给表：

| M | subdim | base code size | ADC LUT size | SDC table size | lookup count/query |
|---:|---:|---:|---:|---:|---:|
| 8 | 12 | 0.8 MB | 8 KB | 2.0 MB | 0.8M |
| 12 | 8 | 1.2 MB | 12 KB | 3.0 MB | 1.2M |
| 16 | 6 | 1.6 MB | 16 KB | 4.0 MB | 1.6M |

### 15.4 FastScan 数值分析

必须分析：

- naive PQ scan 每个候选需要 `M` 次 LUT lookup 和 `M` 次累加。
- FastScan-style 是否降低 LUT 访存、减少 scalar 查表或提升 SIMD 并行度。
- LUT 量化是否引入额外 recall 损失。
- scan time 是否成为主要瓶颈。

---

## 16. 性能剖析强制要求

### 16.1 perf

如果环境允许，使用：

```bash
perf stat -e cycles,instructions,branches,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses ./main
```

如果服务器不允许直接运行 `./main`，则 perf 分析放在本地补充实验中完成，正式测试仍使用 `test.sh`。

报告至少需要给出：

- cycles。
- instructions。
- CPI。
- branch miss 或 cache miss。

### 16.2 汇编分析

必须生成或查看汇编：

```bash
g++ -O2 -S main.cc -o main.s
objdump -d main > main.dump
```

报告需要分析：

- 是否出现 SIMD packed 指令。
- 是否仍有 scalar multiply/add。
- load 是否 aligned / unaligned。
- 是否有 FMA。
- 循环是否展开。
- FastScan 是否减少标量查表或改善指令结构。

---

## 17. 结果表模板

### 17.1 主结果表

| Method | Recall@k | Latency/query | Speedup | Index size | Notes |
|---|---:|---:|---:|---:|---|
| Flat-Scalar | 1.000 | 待填 | 1.00× | 38.4 MB | baseline |
| Flat-AutoVec | 待填 | 待填 | 待填 | 38.4 MB | compiler |
| Flat-Manual-SIMD | 待填 | 待填 | 待填 | 38.4 MB | hand SIMD |
| SQ-SIMD + rerank | 待填 | 待填 | 待填 | 9.6 MB | p=待填 |
| PQ-SDC | 待填 | 待填 | 待填 | 待填 | M=待填 |
| PQ-SDC + rerank | 待填 | 待填 | 待填 | 待填 | M,p=待填 |
| PQ-ADC | 待填 | 待填 | 待填 | 待填 | M=待填 |
| PQ-ADC + rerank | 待填 | 待填 | 待填 | 待填 | M,p=待填 |
| SDC Pipeline | 待填 | 待填 | 待填 | 待填 | batch=待填 |
| FastScan-style | 待填 | 待填 | 待填 | 待填 | M,p=待填 |

### 17.2 PQ 阶段耗时分解表

| Method | query encode | LUT build | scan | top-k/top-p | rerank | total |
|---|---:|---:|---:|---:|---:|---:|
| PQ-SDC | 待填 | 待填 | 待填 | 待填 | 待填 | 待填 |
| PQ-ADC | 待填 | 待填 | 待填 | 待填 | 待填 | 待填 |
| FastScan-style ADC | 待填 | 待填 | 待填 | 待填 | 待填 | 待填 |

---

## 18. 最终提交前检查清单

### 18.1 代码检查

- [ ] 能通过 `bash test.sh 1 1`。
- [ ] 没有直接依赖 `./main` 作为正式测试方式。
- [ ] 没有修改 `test.sh` / `qsub.sh`。
- [ ] 没有直接输出 `test_gt`。
- [ ] 新增文件是 `.h`。
- [ ] 输出格式未破坏。
- [ ] 不会死循环。
- [ ] 不会向 `files/` 外大量写文件。

### 18.2 算法检查

- [ ] Flat-SIMD 已完成。
- [ ] SQ-SIMD 已完成。
- [ ] PQ-SDC 已完成。
- [ ] PQ-ADC 已完成。
- [ ] SDC pipeline 已完成。
- [ ] FastScan-style 已完成。
- [ ] OPQ 不需要完成。
- [ ] RaBitQ 不需要完成。

### 18.3 实验检查

- [ ] Flat scalar / auto-vectorized / manual SIMD 对比。
- [ ] loop unroll 消融。
- [ ] top-k 优化消融。
- [ ] prefetch 或 alignment 分析。
- [ ] SQ p 参数扫描。
- [ ] PQ-SDC M,p 参数扫描。
- [ ] PQ-ADC M,p 参数扫描。
- [ ] ADC vs SDC 对比。
- [ ] SDC pipeline batch size 扫描。
- [ ] FastScan vs naive PQ 对比。
- [ ] x86 vs ARM 对比。
- [ ] perf 或汇编分析。
- [ ] AI 附录，如果使用了 AI。

### 18.4 图表检查

- [ ] Flat speedup 图。
- [ ] SQ latency-recall 图。
- [ ] PQ-SDC latency-recall 图。
- [ ] PQ-ADC latency-recall 图。
- [ ] ADC vs SDC 图。
- [ ] SDC pipeline 图。
- [ ] FastScan 对比图。
- [ ] PQ 耗时分解图。
- [ ] x86 vs ARM 图。
- [ ] perf / 汇编分析图表。
- [ ] Pareto frontier 图。

---

## 19. 最终写作原则

1. 不要只写“SIMD 更快”，必须说明为什么快。
2. 不要只贴终端输出，必须整理成表格和图。
3. 对 Flat，要解释 SIMD lane、访存、水平求和和 top-k 开销。
4. 对 SQ，要解释量化压缩和 recall 损失。
5. 对 PQ-SDC，要解释 query 编码和中心间距离表。
6. 对 PQ-ADC，要解释 query 不编码、局部 LUT 和 recall 优势。
7. 对 SDC pipeline，要解释吞吐率提升来自阶段重叠。
8. 对 FastScan，要解释它优化的是 PQ scan 查表累加阶段。
9. OPQ 和 RaBitQ 不需要写入主报告，避免占用篇幅。
10. 所有结论必须有真实实验数据支撑。
