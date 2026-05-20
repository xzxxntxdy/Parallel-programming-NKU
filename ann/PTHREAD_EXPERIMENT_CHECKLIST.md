# ANN Pthread/OpenMP 实验 Checklist

扫描时间：2026-05-20  
扫描依据：`要求.md`、`Pthread.md`、`openmp.md`、`PTHREAD_EXPERIMENTS.md`、`main.cc`、`pthread_*.h/cc`、`run_pthread_*.ps1/sh`、`files/results/*.csv`、`simd/PERF_EXPERIMENT_LOG.md`

统一准则：

- 指标：`recall@100`。
- 最优选择：只在 `recall@100 >= 0.95` 的候选中选择最低 `latency`。
- 本地 x86 使用全量/正式规模 `Nq=1000`；ARM/Kunpeng 交接默认 quick sweep，最终路径用 `test.sh` 全量验证。
- OpenMP 分成两类：基础 OpenMP CPU 并行化，以及进阶 OpenMP target 加速器卸载。二者不能互相替代。

标记：

- `[x]` 已有代码和结果。
- `[~]` x86 已完成，ARM/Kunpeng 需要补跑。
- `[ ]` 尚缺或仅有命令预留。

## 1. 基础要求覆盖

- [x] ANN 选题数据集加载：DEEP100K base/query/ground truth，统一输出 `metric=recall@100`。
- [x] Pthread-style CPU 多线程实现：Flat、SQ8、PQ-ADC、PQ-SDC、FastScan、SDC pipeline、IVF、IVF-PQ、HNSW。
- [x] SIMD 结合：复用 `ann_search.h`、`ann_quant.h` 中 SSE/AVX/NEON/FastScan 距离核。
- [x] x86 Pthread 主 CPU sweep：`pthread_results_x86_windows.csv`，798 行。
- [x] ARM/Kunpeng Pthread 主 CPU quick sweep：`pthread_results_arm.csv`，864 行。
- [x] x86 HNSW/图索引 advanced sweep：`pthread_hnsw_results_x86_windows.csv`，84 行。
- [x] ARM/Kunpeng HNSW/图索引 advanced sweep：`pthread_hnsw_results_arm.csv`，84 行。
- [x] x86 基础 OpenMP CPU sweep 已补齐：`pthread_openmp_cpu_results_x86_windows.csv`，73 行。
- [~] ARM/Kunpeng 基础 OpenMP CPU sweep 需要补跑：命令见 `PTHREAD_ARM_KUNPENG_HANDOFF.md` 和 `PTHREAD_ARM_COMMANDS.md`。
- [x] Pthread 与 OpenMP CPU 的同平台 x86 对比已有：Pthread IVF 最优 `0.044471 ms/query`；OpenMP CPU IVF 最优 `0.082060 ms/query`，二者 recall 均为 `0.956950`。
- [~] Pthread 与 OpenMP CPU 的 ARM/Kunpeng 对比缺 OpenMP CPU 结果。

## 2. ANN 指导书分项

### 2.1 Flat-SIMD + 多线程

- [x] Pthread query-level parallel：线程数 `1,2,4,8,16,32`。
- [x] Pthread base-split parallel：`local_p=100,200,500`，覆盖 top-k reduce trade-off。
- [x] OpenMP CPU query-level parallel：static/dynamic schedule，线程数 `1,2,4,8,16,32`，x86 已跑。
- [x] OpenMP CPU base-split parallel：static/dynamic schedule，`local_p=100,500`，代表线程点 `1,8,32`，x86 已跑。
- [~] ARM OpenMP CPU Flat query/base-split 待跑。

### 2.2 PQ-SIMD + 多线程

- [x] Pthread PQ-ADC：`M=8,12,16`，候选数 `p` 与线程数消融。
- [x] Pthread PQ-SDC：`M=8,12,16`，覆盖对称查表路径。
- [x] Pthread FastScan：`block=32,64,128`，候选数与线程数消融。
- [x] Pthread SDC pipeline：`stage=1/2/3`、`batch=1,4,8,16,32,64`。
- [x] OpenMP CPU PQ-ADC：`M=16`、`p=500,1000`、static/dynamic schedule，x86 已跑。
- [~] ARM OpenMP CPU PQ-ADC 待跑。
- [x] PQ/FastScan 阶段耗时 profiling：`pthread_profile_summary.csv` 中记录 LUT、scan、select、rerank 主导阶段。

### 2.3 IVF 与 IVF-PQ

- [x] Pthread IVF-SIMD baseline + 多线程：`nlist=64,128,256,512`，`nprobe=1,2,4,8,16,32`。
- [x] Pthread IVF coarse/fine timing 记录：`IVF-Breakdown` 行。
- [x] Pthread IVF-PQ 全局 PQ：`IVF-PQ` 行，`global_pq_M16_p1000`。
- [x] Pthread IVF-PQ per-cluster PQ：`IVF-PQ-Local` 行，`per_cluster_pq_M8_p500_train64`。
- [x] OpenMP CPU IVF：`nlist=512`、`nprobe=16,32`、static/dynamic schedule，x86 已跑。
- [~] ARM OpenMP CPU IVF 待跑。
- [x] OpenMP target IVF 加速器卸载：Intel GPU，`nlist=2048`，`nprobe` 与 candidate cap sweep。

### 2.4 HNSW 图索引进阶

- [x] 标准 HNSW query-level parallel：`StdThread`。
- [x] C++ 标准库工具对比：`StdAsync`。
- [x] `ef=32,64,128,256` 消融。
- [x] 线程数 `1,2,4,8,16,32` 消融。
- [x] Layer 0 多入口点并行：`Layer0MultiEntry`。
- [x] Layer 0 边划分并行：`Layer0EdgePartition`。
- [x] Layer 0 点划分并行：`Layer0PointPartition`。
- [x] IVF+HNSW 嵌套结构：`IVF-HNSW`。
- [x] 负优化证据已记录：查询内并行多数不优于标准 query-level HNSW。

## 3. 进阶要求覆盖

- [x] x86 与 ARM/Kunpeng 多线程 + SIMD 对比：Pthread 主线、HNSW、最终 `test.sh` 已有双平台结果。
- [~] OpenMP CPU 双平台对比：x86 已补齐，ARM/Kunpeng 待跑。
- [x] OpenMP 卸载到加速器设备：`pthread_openmp_target_ivf.cc`，`OMP_TARGET_OFFLOAD=MANDATORY`，target 区域检查 `omp_is_initial_device()==false`。
- [x] x86 OpenMP target Intel GPU 结果：`pthread_openmp_target_device_results_x86_windows.csv`，36 行；best 为 `nprobe=81, cap=3840`，`0.186502 ms/query`，`recall@100=0.950170`。
- [x] oneAPI/SYCL 对比：`pthread_sycl_o2_2024_results_x86_windows.csv`；best 为 `nprobe=80`，`0.215992 ms/query`，`recall@100=0.950600`。
- [x] C++ 标准库多线程工具对比：HNSW `StdThread` vs `StdAsync`。
- [x] 其他算法优化策略：SQ8、PQ、SDC、FastScan、IVF、IVF-PQ、HNSW、IVF-HNSW、GPU batch IVF。
- [x] 生成式 AI 辅助学习附录：报告附录已包含知识性问答。
- [x] x86 profiling 汇总：`pthread_profile_summary.csv`。
- [x] SIMD perf counter 上下文已复用：`pthread_profile_simd_perf_context.csv` 从 SIMD `perf_summary.csv` 导出。
- [~] ARM/Kunpeng Pthread/OpenMP CPU perf counter profiling 待跑；命令已写入交接文档。

## 3.1 更多探索、复杂性与一致性分析覆盖

`要求.md` 中“矩阵水平划分、垂直划分”是高斯消去示例。ANN 选题中对应的任务划分已经按以下方式完成和记录：

- [x] query-level 划分：Flat、SQ8、PQ、FastScan、IVF、HNSW 均覆盖。复杂性近似为把 $Q$ 个 query 分给 $T$ 个线程，状态完全私有，一致性最简单，主要代价是线程调度和负载不均。
- [x] base-split / 候选集合划分：Flat-BaseSplit、PQ base-split、OpenMP-CPU-FlatBaseSplit 已覆盖。每线程维护局部 top-$p$，最后 reduce 到 top-100；一致性由只读 base + 局部 heap + 主线程 merge 保证，代价是 $T \times p$ 归并。
- [x] 倒排链/簇划分：IVF query-level、IVF cluster-parallel fine scan、OpenMP-CPU-IVF、OpenMP target IVF 已覆盖。复杂性从全量 $N$ 降到约 $N \cdot nprobe/nlist$，但 list 长度不均会导致负载不均。
- [x] PQ 子空间/LUT 划分：`lut_build_parallel` 和 OpenMP/Pthread PQ 查询覆盖。LUT 构建可按子空间分配；扫描阶段因随机查表更偏 memory-bound。
- [x] FastScan block 划分：按 block 切分 code，保证一个 block 只被一个线程处理，降低共享写入和 false sharing。
- [x] HNSW 图边/点/入口划分：`Layer0EdgePartition`、`Layer0PointPartition`、`Layer0MultiEntry`、`IVF-HNSW` 已覆盖。这里的一致性难点是候选队列、visited 标记和剪枝终止条件，实验结果显示多数为负优化。
- [x] OpenMP schedule 策略：OpenMP CPU host 已比较 static/dynamic schedule；x86 结果表明 IVF dynamic schedule 最优，`0.082060 ms/query`。
- [x] 线程管理代价：Pthread/std::thread、std::async、OpenMP CPU、OpenMP target、SYCL 均有独立 CSV；HNSW 中 `StdAsync` 与 `StdThread` 的差异已记录。
- [x] cache/体系结构优化：SIMD 阶段已有 ARM perf counter；Pthread 阶段通过 `pthread_profile_summary.csv` 汇总 LUT/scan/select/rerank 主导阶段，并在报告中讨论 cache miss、随机查表、false sharing、线程私有 buffer、block-major layout。
- [~] ARM OpenMP CPU 与 ARM Pthread/OpenMP perf counter profiling 待补；不影响 x86 已补齐结论，但会让双平台 OpenMP CPU 与硬件计数器分析更完整。

## 4. 当前关键结果

### x86 Windows

- Pthread 主 CPU 非图最优：`IVF nl512 nprobe=32 threads=32`，`0.044471 ms/query`，`recall@100=0.956950`。
- Pthread/HNSW 全局 sweep 最优：`HNSW-ToolCompare StdAsync ef=64 threads=32`，`0.009739 ms/query`，`recall@100=0.954540`。
- Pthread final 全量：`HNSW-StdAsync ef=64 threads=32`，`9.316 us/query`，`recall@100=0.952683`。
- OpenMP CPU host 最优：`OpenMP-CPU-IVF nl512-dynamic nprobe=32 threads=32`，`0.082060 ms/query`，`recall@100=0.956950`。
- OpenMP target Intel GPU 最优：`OpenMP-Target-IVF nprobe=81 cap=3840`，`0.186502 ms/query`，`recall@100=0.950170`。
- oneAPI/SYCL Intel GPU 最优：`SYCL-IVF nprobe=80`，`0.215992 ms/query`，`recall@100=0.950600`。

### ARM/Kunpeng

- Pthread 主 CPU 非图最优：`IVF nl512 nprobe=32 threads=32`，`0.193230 ms/query`，`recall@100=0.956240`。
- Pthread/HNSW quick 最优：`HNSW-ToolCompare StdThread ef=64 threads=16`，`0.085378 ms/query`，`recall@100=0.954280`。
- Pthread final `test.sh` 全量：`HNSW-StdThread ef=64 threads=16`，`70.878600 us/query`，`recall@100=0.952643`。
- OpenMP CPU host：待补跑。
- OpenMP target 加速器：Kunpeng 机器未确认有可用 accelerator/offload compiler；默认不作为 ARM 必跑项。

## 5. CSV 文件核对

- [x] `pthread_results_x86_windows.csv`
- [x] `pthread_best_x86_windows.csv`
- [x] `pthread_final_x86_windows.csv`
- [x] `pthread_hnsw_results_x86_windows.csv`
- [x] `pthread_hnsw_best_x86_windows.csv`
- [x] `pthread_global_best_x86_windows.csv`
- [x] `pthread_openmp_cpu_results_x86_windows.csv`
- [x] `pthread_openmp_cpu_best_x86_windows.csv`
- [x] `pthread_openmp_target_device_results_x86_windows.csv`
- [x] `pthread_openmp_target_device_best_x86_windows.csv`
- [x] `pthread_sycl_o2_2024_results_x86_windows.csv`
- [x] `pthread_sycl_o2_2024_best_x86_windows.csv`
- [x] `pthread_results_arm.csv`
- [x] `pthread_best_arm.csv`
- [x] `pthread_final_arm.csv`
- [x] `pthread_hnsw_results_arm.csv`
- [x] `pthread_hnsw_best_arm.csv`
- [x] `pthread_global_best_arm.csv`
- [ ] `pthread_openmp_cpu_results_arm.csv`
- [ ] `pthread_openmp_cpu_best_arm.csv`
- [x] `pthread_profile_summary.csv`
- [x] `pthread_profile_simd_perf_context.csv`

## 6. x86 已补齐命令记录

基础 OpenMP CPU host：

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_openmp_cpu.ps1 -Data D:/Parallel-programming-NKU/anndata `
    -Nq 1000 -Train 4096 -Iters 12
```

profiling 汇总：

```powershell
cd D:\Parallel-programming-NKU\ann
python summarize_pthread_profile.py
```

## 7. ARM/Kunpeng 待补命令

OpenMP CPU host quick：

```bash
cd ann
ANN_DATA=/anndata bash run_pthread_openmp_cpu.sh --arm-quick
```

Pthread/OpenMP CPU perf counter profiling，如果 `perf` 可用：

```bash
cd ann
perf stat -x, -o files/results/pthread_perf_hnsw_arm.csv \
  -e cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
  ./main --final-only --arm-quick --data /anndata --nq 300 --train 2048 --iters 8

perf stat -x, -o files/results/openmp_cpu_perf_arm.csv \
  -e cycles,instructions,branch-misses,L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
  ./openmp_cpu --benchmark --arm-quick --data /anndata --nq 300 --train 2048 --iters 8
```

回传后在 x86 本地运行：

```powershell
cd D:\Parallel-programming-NKU\ann
python summarize_pthread_profile.py
```
