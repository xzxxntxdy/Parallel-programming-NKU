# AI-assisted SIMD Learning Log

## A.1 Problem Asked

本阶段目标是在 ANN / ANNS SIMD 实验中，基于 DEEP100K 的 `d=96` 内积距离，实现并比较 scalar、自动向量化和手写 SIMD 搜索，同时生成真实 CSV 与图表，便于后续报告和跨平台接手。

## A.2 Initial Design

初始框架使用 `flat_scan.h` 中的串行 Flat 搜索：

```cpp
auto res = flat_search(base, test_query + i * vecdim, base_number, vecdim, k);
```

该版本每个 query 扫描 100000 条 96 维 float 向量，使用内积距离 `1 - dot(base, query)`，返回 `std::priority_queue<std::pair<float, uint32_t>>`。

## A.3 AI Feedback Used

采纳的建议：

- SIMD 阶段应以 Flat 距离计算优化为主，不能把 HNSW 作为主提交路径。
- 在 ARM/aarch64 上使用 NEON intrinsics。
- 保留 scalar no-vector、auto-vectorized、manual SIMD 多版本对比。
- 增加 unroll4、prefetch、fixed-array top-k 消融。
- 数据和图表必须由真实运行生成，不能手填。
- 当前只能运行一个平台，因此 x86 只能提供代码路径和转交说明，不能伪造 x86 实测。

拒绝或延后的建议：

- 不把 `test_gt` 作为答案输出。
- 不修改 `test.sh` / `qsub.sh`。
- 不在当前课程集群直接运行 `./main`。
- 不伪造跨平台数据。

## A.4 Changes Made

- 新增 `ann_search.h`，实现 scalar、auto、NEON、NEON unroll4、prefetch、fixed top-k，以及 x86 SSE/AVX 接手分支。
- 新增 `ann_quant.h`，实现 SQ8 coarse+rerank 和 PQ-ADC coarse+rerank。
- 修改 `main.cc`，主查询调用 `ann::flat_search_best(...)`。
- 在 `main.cc` 中写入 `files/results/simd_results.csv`，覆盖 Flat、SQ8、PQ-ADC 参数矩阵。
- 新增 `plot_simd_results.py`，用 Python 标准库生成 SVG 和 PNG。
- 新增 `SIMD_HANDOFF.md`，说明当前 ARM 单平台结果和其他平台接手方式。
- 新增 `SIMD_COMPLETION_CHECKLIST.md`，逐项对照计划核对完成情况。

## A.5 Experimental Validation

最终通过课程要求方式运行：

```bash
bash test.sh 1 1
```

最终输出：

```text
average recall: 0.99995
average latency (us): 8168.6
```

绘图数据：

```text
files/results/simd_results.csv
files/results/simd_summary.csv
files/figures/*.svg
files/figures/*.png
```

## A.6 Reflection

手写 SIMD 明显优于 scalar 和普通自动向量化，但 unroll、prefetch、fixed top-k 在集群上受波动影响，并不是每轮都稳定获益。因此报告中应以 CSV 的 mean/std 展示消融结果，而不是只引用单次终端输出。

SQ8 在当前实现中保持高 recall，但粗排 LUT 扫描和较大的 Top-p 精排使 latency 不占优；PQ-ADC 显示了更清晰的 latency-recall trade-off，例如 M=8,p=100 延迟最低但 recall 低，M=12,p=1000 能在当前 benchmark 子集上达到 recall=1。
