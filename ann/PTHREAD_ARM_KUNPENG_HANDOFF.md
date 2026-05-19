# ANN Pthread ARM/Kunpeng Handoff

本文档交接 `ann` 目录下 Pthread 阶段在 ARM/Kunpeng 平台上的已完成实验。正式最终结果已经通过课程入口 `test.sh` 跑全量 bench；quick sweep 用于 ARM 参数选择和报告分析。

## 1. 本次运行环境

运行时间：2026-05-20 00:20 CST 左右。

平台信息：

```text
OS: OpenEuler 5.10.0-235.0.0.134.oe2203sp4.aarch64
CPU: HiSilicon Kunpeng-920
Architecture: aarch64
Cores: 8
SIMD flag: asimd / NEON
Dataset: /anndata
```

数据集文件：

```text
/anndata/DEEP100K.base.100k.fbin
/anndata/DEEP100K.query.fbin
/anndata/DEEP100K.gt.query.100k.top100.bin
```

统一指标和选择规则：

```text
metric: recall@100
best rule: 在 recall@100 >= 0.95 的候选中选择 latency 最小的配置
```

## 2. ARM quick sweep 结果

### 2.1 主 CPU sweep

命令：

```bash
cd /home/s2412235/ann
ANN_DATA=/anndata bash run_pthread_arm.sh --quick
```

说明：该脚本完成主 CPU quick sweep 后，在本机缺少 `matplotlib` 时会跳过画图，不影响 CSV 结果。当前已修复脚本，避免因为画图依赖缺失中断后续流程。

输出文件：

```text
files/results/pthread_results_arm.csv
files/results/pthread_best_arm.csv
```

规模与覆盖：

```text
queries: 500
train_sample: 4096
kmeans_iters: 10
CSV rows: 864 data rows
covered: Flat, Flat-BaseSplit, SQ8, PQ-ADC, PQ-SDC, FastScan, SDC-Pipeline, IVF, IVF-PQ, IVF-PQ-Local
```

主 CPU quick 最优非图索引：

```text
experiment: IVF
method: nl512
nthreads: 32
param: nprobe=32
latency: 0.193230 ms/query
recall@100: 0.956240
build_sec: 112.143926
```

### 2.2 HNSW / 图索引 advanced sweep

命令：

```bash
cd /home/s2412235/ann
ANN_DATA=/anndata bash run_pthread_arm.sh --quick --hnsw-only
```

输出文件：

```text
files/results/pthread_hnsw_results_arm.csv
files/results/pthread_hnsw_best_arm.csv
files/results/pthread_hnsw_arm.log
```

规模与覆盖：

```text
queries: 500
CSV rows: 84 data rows
covered: HNSW StdThread, HNSW StdAsync, Layer0MultiEntry, Layer0EdgePartition, Layer0PointPartition, IVF-HNSW
```

HNSW quick 最优：

```text
experiment: HNSW-ToolCompare
method: StdThread
nthreads: 16
param: ef=64
latency: 0.085378 ms/query
recall@100: 0.954280
build_sec: 43.279694
notes: single_index_query_parallel
```

### 2.3 ARM quick 全局最优

输出文件：

```text
files/results/pthread_global_best_arm.csv
```

全局 quick 最优同 HNSW quick 最优：

```text
HNSW-ToolCompare / StdThread / ef=64 / threads=16
latency: 0.085378 ms/query
recall@100: 0.954280
```

这说明 ARM/Kunpeng 上最终提交路径应使用 HNSW 单图 query-level parallel 的 `std::thread` 版本，而不是沿用 x86 Windows 的 `std::async / threads=32`。

## 3. 最终默认路径

已修改 `main.cc` 的 `run_final`：

```text
ARM/aarch64: HNSW-StdThread, M=16, efConstruction=100, ef=64, threads=16
x86: 保留原 HNSW-StdAsync, M=16, efConstruction=100, ef=64, threads=cfg.final_threads
```

最终路径仍然是默认无参数运行 `main` 时执行的路径，因此课程 `test.sh` 编译后会直接跑该最终算法。

## 4. test.sh 全量 bench 最终结果

正式命令：

```bash
cd /home/s2412235/ann
bash test.sh 2 1
```

说明：必须通过 `test.sh` 跑正式结果。`test.sh` 自动编译 `main.cc` 并提交 `qsub.sh`；不要直接运行 `./main` 作为正式结果。

本次 qsub 信息：

```text
job id: 19835.master_ubss1
compute node shown in log: master_ubss2
```

`test.o` 全量输出摘要：

```text
Platform: ARM/aarch64 NEON
Data dir: ../../anndata
DEEP100K: base=100000 dim=96 query=10000 gt_dim=100 metric=recall@100
method: HNSW-StdThread M=16 efConstruction=100 ef=64 threads=16
build time (s): 43.452
average recall: 0.95264
average latency (us): 70.88
```

`files/results/pthread_final_arm.csv` 中的精确行：

```text
method: HNSW-StdThread
nthreads: 16
ef: 64
latency_us: 70.878600
recall@100: 0.952643
build_sec: 43.452011
notes: M=16; ef_construction=100
```

归档文件：

```text
test.o
test.e
files/results/pthread_final.csv
files/results/pthread_final_arm.csv
files/results/pthread_test_full_arm.o.log
files/results/pthread_test_full_arm.e.log
```

`test.e` 中只有课程环境常见的 `pssh/pscp` 成功信息和 Authorized users 提示，没有算法错误。

## 5. 当前结果文件清单

ARM 主线：

```text
files/results/pthread_results_arm.csv
files/results/pthread_best_arm.csv
files/results/pthread_hnsw_results_arm.csv
files/results/pthread_hnsw_best_arm.csv
files/results/pthread_global_best_arm.csv
files/results/pthread_final_arm.csv
files/results/pthread_arm_benchmark.log
files/results/pthread_hnsw_arm.log
files/results/pthread_test_full_arm.o.log
files/results/pthread_test_full_arm.e.log
```

x86 对照结果仍保留在：

```text
files/results/pthread_results_x86_windows.csv
files/results/pthread_best_x86_windows.csv
files/results/pthread_final_x86_windows.csv
files/results/pthread_hnsw_results_x86_windows.csv
files/results/pthread_hnsw_best_x86_windows.csv
files/results/pthread_global_best_x86_windows.csv
files/results/pthread_sycl_o2_2024_results_x86_windows.csv
files/results/pthread_sycl_o2_2024_best_x86_windows.csv
files/results/pthread_openmp_target_device_results_x86_windows.csv
files/results/pthread_openmp_target_device_best_x86_windows.csv
```

## 6. 复现顺序

如果需要从头复现 ARM 实验，建议顺序如下：

```bash
cd /home/s2412235/ann

# 1. ARM 主 CPU quick sweep
ANN_DATA=/anndata bash run_pthread_arm.sh --quick

# 2. ARM HNSW / 图索引 quick sweep
ANN_DATA=/anndata bash run_pthread_arm.sh --quick --hnsw-only

# 3. 正式最终全量 bench
bash test.sh 2 1
```

如果当前环境的 sandbox 无法连接 `trqauthd`，需要在真实登录 shell 中运行第 3 步；不要改 `test.sh` 或 `qsub.sh`。

## 7. 报告可用结论

- ARM/Kunpeng quick sweep 中，主 CPU 非图索引最优是 `IVF nl512 nprobe=32 threads=32`，但延迟仍高于 HNSW。
- HNSW 在 ARM 上的最优工具是 `std::thread`，quick 中 `StdThread ef=64 threads=16` 优于 `StdAsync` 的候选。
- 最终 `test.sh` 全量结果达到 `recall@100=0.952643`，满足 `0.95` 目标，平均查询延迟为 `70.878600 us/query`。
- HNSW 的 query-level parallel 是本阶段 ARM 最终代表实现；Layer0 多入口、边划分、点划分和 IVF-HNSW 已进入 CSV，可在报告中作为图索引查询内并行探索和负优化分析材料。
- `run_pthread_arm.sh` 的 quick sweep 负责实验矩阵和选型；正式可提交结果以 `test.sh` 输出为准。

