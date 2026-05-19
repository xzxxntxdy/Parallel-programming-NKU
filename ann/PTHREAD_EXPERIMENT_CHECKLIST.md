# ANN Pthread 实验 Checklist

扫描时间：2026-05-13  
扫描范围：`Pthread.md`、`PTHREAD_EXPERIMENTS.md`、`main.cc`、`pthread_*.h/cc/cu`、`run_pthread_*.ps1/sh`、`plot_pthread.py`、`report/AI_APPENDIX.md`、`files/results/pthread*.csv`、`files/figures/fig_pthread_*`

标记说明：

- `[x]`：代码入口和本地 x86 结果或状态记录已经存在。
- `[ ]`：还需要实机补跑、补充实现、或在报告中明确说明边界。

## 总体验收

- [x] 评测指标统一为 `recall@100`，结果 CSV 使用 `recall@100` 列。
- [x] 最优选择规则统一为：在 `recall@100 >= 0.95` 的候选中选择最小 `latency`。
- [x] 主结果 CSV 包含 `experiment, method, nthreads, param1, param2, latency_ms, recall@100, speedup, index_mb, build_sec, encode_us, lut_us, scan_us, select_us, rerank_us, notes`。
- [x] `pthread_best.csv`、`pthread_hnsw_best.csv`、`pthread_sycl_best.csv` 等 best CSV 记录约束最优行。
- [x] `plot_pthread.py` 只保留两张高信息量图：全局 recall-latency frontier、代表性线程扩展曲线。
- [x] 没有使用合成图；图来自真实 CSV。
- [x] 最终 `test.sh` 路径已切到当前 HNSW 高召回最优结果：`HNSW-StdAsync, M=16, efConstruction=100, ef=64, threads=32`；本地全量查询 final 为 recall@100 `0.952683`、`9.316000 us/query`。
- [x] x86/ARM 脚本已添加平台后缀复制，避免后续覆盖不同平台结果：`*_x86_windows.csv`、`*_x86_linux.csv`、`*_arm.csv`。

## 基础与主线 CPU 实验

入口：`main.cc`、`pthread_benchmark.h`、`run_pthread_x86.ps1/sh`、`run_pthread_arm.sh`  
主结果：`files/results/pthread_results.csv`，当前 full x86 扫描到 798 行。

- [x] DEEP100K 数据加载：base/query/ground truth，输出平台、维度和 `metric=recall@100`。
- [x] 单线程 Flat scalar baseline，用于 speedup 归一化。
- [x] Flat-SIMD + 线程数消融：`Scalar`、`AutoVec`、`SSE`、`AVX2`、`NEON-Unroll4`、`PrefetchTopK`。
- [x] Flat query-level parallel：线程数 `1,2,4,8,16,32`，quick/smoke 使用缩小集合。
- [x] Flat base-split parallel：`local_p=100,200,500`，覆盖 top-k reduce trade-off。
- [x] SQ8 + Pthread：候选数 `p` 消融、线程数消融、rerank timing。
- [x] PQ-ADC + Pthread：`M=8,12,16`，`p=50..5000`，线程数消融。
- [x] PQ-SDC + Pthread：`M=8,12,16`，重点 `p=500/1000` 和 quick 全量记录。
- [x] FastScan + Pthread：`block=32,64,128`，`p=50..2000`，线程数消融。
- [x] FastScan scaling 专项：`FastScan-b64-p500` 下 `threads=1,2,4,8,16,32`。
- [x] SDC pipeline：`stage=1/2/3`、`batch=1,4,8,16,32,64`，覆盖流水线和 batch trade-off。
- [x] IVF-SIMD baseline + Pthread：`nlist=64,128,256,512`，`nprobe=1,2,4,8,16,32`，线程数消融。
- [x] IVF coarse/fine timing breakdown：`IVF-Breakdown` 行。
- [x] IVF-PQ：当前主扫使用 IVF 候选裁剪 + 全局 PQ `M16 p1000` rerank。
- [x] 每簇独立 PQ 的 IVF-PQ 消融已进入主扫：`IVF-PQ-Local`，当前 full x86 CSV 中 24 行，notes 标记 `per_cluster_pq_M8_p500_train64`。
- [x] Optional HNSW 基础 sweep：`--with-hnsw` 可写入主 CSV，但高级 HNSW 已拆到独立 CSV 防止覆盖。

## HNSW 与图索引进阶实验

入口：`pthread_hnsw.h`、`main.cc --hnsw-only/--advanced-only`  
结果：`pthread_hnsw_results.csv` 当前 84 行，`pthread_hnsw_best.csv` 当前最优为 `HNSW-ToolCompare / StdAsync / ef=64 / threads=32`。

- [x] HNSW 单图 query-level parallel：`StdThread`。
- [x] C++ 标准库对比：`std::async`，记录为 `StdAsync`。
- [x] OpenMP 进阶要求改为 strict target device：正式结果不使用 CPU OpenMP 替代。
- [x] `ef` 消融：`32,64,128,256`。
- [x] 线程数消融：`1,2,4,8,16,32`。
- [x] Layer-0 multi-entry intra-query 探索：`HNSW-IntraQuery / Layer0MultiEntry`，entry 数 `1,2,4,8`。
- [x] IVF+HNSW 嵌套结构：`IVF-HNSW / nlist16-M16-efC100`，`nprobe=2,4,8,16`，线程数消融。
- [x] 负优化记录：Layer-0 multi-entry 和 IVF-HNSW 的 latency/recall trade-off 已进入 CSV，可在报告中如实分析。
- [x] 边划分并行已补充为 `HNSW-IntraQuery / Layer0EdgePartition`，按 level-0 邻接边序号分区，当前 HNSW CSV 中 4 行。
- [x] Layer 0 点划分并行已补充为 `HNSW-IntraQuery / Layer0PointPartition`，按 bottom-layer 点集合精确分区扫描，当前 HNSW CSV 中 4 行。

## x86 与 ARM 平台对比

- [x] x86 Windows/MSVC 主扫脚本：`run_pthread_x86.ps1`。
- [x] x86 Linux/GCC 主扫脚本：`run_pthread_x86.sh`。
- [x] x86 本地主结果已存在：`pthread_results.csv`、`pthread_best.csv`、`pthread_final.csv`。
- [x] x86 本地 HNSW advanced 结果已存在：`pthread_hnsw_results.csv`、`pthread_hnsw_best.csv`。
- [x] ARM/AArch64 脚本已预留：`run_pthread_arm.sh`，默认 `-O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I.`。
- [x] ARM quick/final/hnsw-only 命令已预留。
- [x] ARM/Kunpeng 默认 quick 主扫命令已预留在 `PTHREAD_ARM_COMMANDS.md` 和 `run_pthread_arm.sh`；本地 Windows x86 环境不能执行 ARM 实测。
- [x] ARM 实机 HNSW advanced 命令已预留，并会自动保存 `pthread_hnsw_results_arm.csv`、`pthread_hnsw_best_arm.csv`。
- [ ] 报告中需要等 ARM 实机 CSV 回传后比较 x86 vs ARM 的线程扩展、SIMD 指令差异、内存带宽/缓存行为、最优参数是否迁移。

## OpenMP target 加速器卸载与其他线程工具

- [x] 主线 CPU 中使用 C++11 `std::thread` 实现跨平台线程并行，覆盖 Flat/PQ/SQ/IVF/HNSW 多数 CPU 路径。
- [x] HNSW advanced 中保留 `std::thread`、`std::async` 对比；OpenMP 进阶要求由单独的 target-device CSV 覆盖。
- [x] OpenMP 编译路径在 x86 脚本中启用：MSVC `/openmp` 或 GCC `-fopenmp`。
- [x] OpenMP target Intel GPU 已严格卸载到加速器设备：DPC++ 2024.2.1 + `level_zero:gpu` + `OMP_TARGET_OFFLOAD=MANDATORY`。
- [x] OpenMP target 代码在 target 区域内验证 `omp_is_initial_device()==false`，正式 CSV 只记录加速器设备执行结果。
- [x] OpenMP target 已从 exact Flat 改为 IVF candidate-pruning sweep，按 `recall@100>=0.95` 下最小 latency 选优。
- [x] OpenMP target x86 Windows 正式结果：`pthread_openmp_target_device_results_x86_windows.csv`、`pthread_openmp_target_device_best_x86_windows.csv`。

## oneAPI / SYCL / OpenCL / CUDA 进阶实验

入口：`pthread_sycl_flat.cc`、`pthread_opencl_ivf.cc`、`pthread_cuda_flat.cu`、`run_pthread_oneapi.ps1`、`run_pthread_openmp_target.ps1`、`run_pthread_cuda.ps1`

- [x] oneAPI/SYCL flat exact GPU/CPU probe：`SYCL-Flat` 行保留在 `pthread_sycl_results.csv`。
- [x] oneAPI/SYCL IVF GPU/CPU：`SYCL-IVF` 行保留在 `pthread_sycl_results.csv`。
- [x] Intel GPU batch/query-block/workgroup/local-k tune 结果已存在：`pthread_sycl_tune.csv`、`pthread_sycl_batch_tune.csv`、`pthread_sycl_blocktop_tune.csv` 等。
- [x] Intel OpenCL C O2 IVF 路径已实现：`pthread_opencl_ivf.cc`，结果在 `pthread_opencl_o2_results.csv`。
- [x] 旧版 DPC++ 2024.2.1 环境已安装在 `tools/conda_envs/oneapi-dpcpp-2024.2.1`，`run_pthread_oneapi.ps1` 默认优先使用该环境。
- [x] 普通 `-fsycl -O2` 最小 kernel 已用 2024.2.1 验证通过。
- [x] 项目 SYCL IVF smoke run 已用 2024.2.1 + `-O2` 验证通过：`pthread_sycl_smoke_2024_2_1.csv`。
- [x] 修复后的普通 `-O2` SYCL GPU 已用 2024.2.1 重跑完整 `Nq=1000` sweep：`pthread_sycl_o2_2024_results.csv` 和 `pthread_sycl_o2_2024_best.csv`。
- [x] CUDA exact flat probe 已保留：`pthread_cuda_flat.cu`、`pthread_cuda_results.csv`；若本报告聚焦 Intel GPU，可作为可选对照或不纳入主分析。
- [x] GPU 结果已按相同规则选优：`pthread_sycl_o2_2024_best.csv` 当前选择 `nprobe=80`，recall@100 `0.950600`，latency `0.215992 ms/query`。

## CSV 与结果文件核对

- [x] `pthread_results.csv`：主 CPU sweep，当前 798 行，实验族包含 `Flat-Ablation, Flat-BaseSplit, SQ8, PQ-M, PQ-SDC, FastScan, Scaling, SDC-Pipeline, IVF, IVF-PQ, IVF-PQ-Local`。
- [x] `pthread_best.csv`：主 CPU 最优行，当前为 `IVF`。
- [x] `pthread_final.csv`：提交路径输出。
- [x] `pthread_hnsw_results.csv`：HNSW advanced，当前 84 行，包含 `HNSW-ToolCompare, HNSW-IntraQuery, IVF-HNSW`；`HNSW-IntraQuery` 下包含 multi-entry、edge partition、point partition。
- [x] `pthread_hnsw_best.csv`：HNSW advanced 约束最优行。
- [x] `pthread_global_best.csv`：合并主 CPU sweep 与 HNSW advanced 后的全局约束最优行，当前为 `HNSW-ToolCompare / StdAsync / ef=64 / threads=32`。
- [x] `pthread_sycl_results.csv`：SYCL flat/IVF CPU/GPU 历史结果，当前 92 行。
- [x] `pthread_opencl_o2_results.csv`：OpenCL C O2 IVF GPU 结果，当前 6 行。
- [x] `pthread_openmp_target_device_results.csv`：OpenMP target 加速器设备卸载结果。
- [x] `pthread_openmp_target_device_best.csv`：OpenMP target 加速器设备约束最优结果，当前为 `nlist=2048,nprobe=81,cap=3840`，recall@100 `0.950170`，latency `0.186502 ms/query`。
- [x] `pthread_cuda_results.csv`：CUDA exact flat probe 结果。
- [x] x86 Windows 主扫、HNSW advanced、SYCL O2、OpenMP target device 已保存平台后缀副本：`pthread_results_x86_windows.csv`、`pthread_best_x86_windows.csv`、`pthread_final_x86_windows.csv`、`pthread_hnsw_results_x86_windows.csv`、`pthread_hnsw_best_x86_windows.csv`、`pthread_sycl_o2_2024_results_x86_windows.csv`、`pthread_openmp_target_device_results_x86_windows.csv`、`pthread_openmp_target_device_best_x86_windows.csv`。

## 推荐重跑命令

Windows x86 主扫：

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_x86.ps1 -Data D:/Parallel-programming-NKU/anndata -Nq 1000
```

Windows x86 HNSW advanced：

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_x86.ps1 -HnswOnly -Data D:/Parallel-programming-NKU/anndata -Nq 1000
```

Linux/x86 主扫：

```bash
cd ann
ANN_DATA=../anndata ANN_NQ=1000 ANN_TRAIN=4096 ANN_ITERS=12 bash run_pthread_x86.sh
```

ARM 主扫：

```bash
cd ann
ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh
```

ARM HNSW advanced：

```bash
cd ann
ANN_DATA=/home/$USER/anndata bash run_pthread_arm.sh --hnsw-only
```

完整 ARM 命令集合见 `PTHREAD_ARM_COMMANDS.md`。

oneAPI/SYCL Intel GPU 普通 O2 IVF sweep，默认使用本地 2024.2.1：

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_oneapi.ps1 -Data D:/Parallel-programming-NKU/anndata -Nq 1000 `
    -BaselineMs 3.175053 -DeviceSelector opencl:gpu -Device intel-gpu `
    -BuildProfile O2 -Backend SYCL -Algo ivf -NList 2048 `
    -NProbeList "76,78,80,82,84,88" -TargetRecall 0.95 `
    -Csv files/results/pthread_sycl_o2_2024_results.csv `
    -BestCsv files/results/pthread_sycl_o2_2024_best.csv
```

oneAPI/SYCL CPU target：

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_oneapi.ps1 -Data D:/Parallel-programming-NKU/anndata -Nq 1000 `
    -BaselineMs 3.175053 -DeviceSelector opencl:cpu -Device cpu `
    -BuildProfile O2 -Backend SYCL -Algo ivf -NList 512 `
    -NProbeList "24,28,29,30,31,32,34" -TargetRecall 0.95
```

OpenMP target Intel GPU strict device offload：

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_openmp_target.ps1 -Data D:/Parallel-programming-NKU/anndata `
    -Nq 1000 -BaselineMs 3.175053 `
    -NListList "2048" -NProbeList "79,80,81,82,83,84" `
    -CandidateCaps "3808,3824,3840,3856,3872,3904"
```

CUDA optional probe：

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_cuda.ps1 -Data D:/Parallel-programming-NKU/anndata -Nq 1000 -BaselineMs 3.175053
```

## 报告分析 Checklist

- [ ] 对 Flat、SQ8、PQ-ADC、PQ-SDC、FastScan、SDC pipeline、IVF、IVF-PQ、HNSW 分别说明算法策略。
- [ ] 对每个实验族给出核心消融变量：线程数、`p`、`M`、FastScan block、pipeline batch/stage、`nlist/nprobe`、`ef`、entry count、workgroup/local-k。
- [ ] 对 `recall@100 >= 0.95` 的可行区域和不可行区域分开分析，避免只看 latency。
- [ ] 对负优化做专门分析：base-split top-p reduce、PQ memory-bound、FastScan block size、IVF coarse/fine 不均衡、HNSW intra-query、OpenMP target IVF 仍慢于 CPU 最优路径。
- [ ] 对 x86 vs ARM 给出同算法同参数的横向对比，不要只列单个平台。
- [ ] 对 Pthread/std::thread、std::async、oneAPI/SYCL、OpenCL C、OpenMP target device、CUDA 的工具差异做公平说明。
- [ ] 对 GPU 慢于 CPU 的情况解释数据搬运、kernel 粒度、coarse/top-k host 部分、集成 GPU 带宽与调度开销。
- [x] 报告表格从 CSV 生成；当前不输出 LaTeX 表格文件。
- [x] 图只使用 `fig_pthread_01_pareto_frontier.*` 和 `fig_pthread_02_thread_scaling.*`，其余大矩阵用报告表格或文字总结。
- [x] AI 辅助附录模板存在：`report/AI_APPENDIX.md`。
- [ ] 最终提交前导出完整对话记录，作为 AI 附录材料。
