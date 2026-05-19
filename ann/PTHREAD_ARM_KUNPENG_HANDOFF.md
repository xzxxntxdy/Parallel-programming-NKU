# ANN Pthread ARM/Kunpeng Handoff

本文档用于把当前 `ann` 目录下的 Pthread 阶段实验交接到 ARM/Kunpeng 平台继续复现。正式实验只使用已经纳入代码和 CSV 体系的路径；探索性或平台不稳定路径不作为交接主流程。

## 1. 当前完成状态

评测指标统一为 `recall@100`。最优选择规则统一为：

```text
在 recall@100 >= 0.95 的候选中，选择 latency 最小的配置。
```

当前 x86 Windows 本地已完成的结果如下。

| 实验族 | CSV | 行数 | 当前代表结果 |
|---|---:|---:|---|
| 主 CPU sweep | `files/results/pthread_results.csv` | 798 | 最优非图索引：`IVF / nl512 / nprobe=32 / threads=32`，`0.044471 ms/query`，`recall@100=0.956950` |
| HNSW 进阶 sweep | `files/results/pthread_hnsw_results.csv` | 84 | `HNSW-ToolCompare / StdAsync / ef=64 / threads=32`，`0.009739 ms/query`，`recall@100=0.954540` |
| 全局最优 | `files/results/pthread_global_best.csv` | 1 | `HNSW-ToolCompare / StdAsync / ef=64 / threads=32` |
| 提交默认路径 | `files/results/pthread_final.csv` | 1 | `HNSW-StdAsync / ef=64 / threads=32`，`9.316000 us/query`，`recall@100=0.952683` |
| oneAPI/SYCL Intel GPU O2 | `files/results/pthread_sycl_o2_2024_results.csv` | 6 | `SYCL-IVF / nlist=2048 / nprobe=80`，`0.215992 ms/query`，`recall@100=0.950600` |
| OpenMP target Intel GPU | `files/results/pthread_openmp_target_device_results.csv` | 36 | IVF strict target device：`target_initial_device=0`，best `nlist=2048 / nprobe=81 / cap=3840`，`0.186502 ms/query`，`recall@100=0.950170` |

平台后缀副本已经保留：

- `files/results/pthread_results_x86_windows.csv`
- `files/results/pthread_best_x86_windows.csv`
- `files/results/pthread_final_x86_windows.csv`
- `files/results/pthread_hnsw_results_x86_windows.csv`
- `files/results/pthread_hnsw_best_x86_windows.csv`
- `files/results/pthread_global_best_x86_windows.csv`
- `files/results/pthread_sycl_o2_2024_results_x86_windows.csv`
- `files/results/pthread_sycl_o2_2024_best_x86_windows.csv`
- `files/results/pthread_openmp_target_device_results_x86_windows.csv`
- `files/results/pthread_openmp_target_device_best_x86_windows.csv`

## 2. 要求覆盖矩阵

| 要求 | 当前覆盖方式 | 主要代码/脚本 | 主要输出 |
|---|---|---|---|
| Pthread 多线程 ANN 搜索 | Flat、SQ8、PQ、SDC、FastScan、IVF、IVF-PQ、HNSW 均进入 sweep | `main.cc`，`pthread_*.h`，`run_pthread_x86.ps1/sh`，`run_pthread_arm.sh` | `pthread_results*.csv`，`pthread_hnsw_results*.csv` |
| SIMD 结合 Pthread | Flat SIMD、PQ ADC/SDC/FastScan、IVF coarse/fine 使用已有 SIMD/自动向量化路径 | `ann_search.h`，`ann_quant.h`，`pthread_flat.h`，`pthread_pq.h`，`pthread_sdc.h`，`pthread_ivf.h` | `pthread_results*.csv` |
| 消融实验 | 线程数、`p`、`M`、FastScan block、pipeline stage/batch、`nlist/nprobe`、HNSW `ef`、HNSW intra-query 划分 | `main.cc --benchmark` | `pthread_results*.csv`，`pthread_hnsw_results*.csv` |
| trade-off 分析数据 | 每行记录 latency、recall、speedup、build time、分段耗时 | CSV 固定列结构 | `files/results/pthread*.csv` |
| 图索引查询内并行探索 | 多入口点、Layer 0 边划分、Layer 0 点划分、IVF+HNSW | `pthread_hnsw.h`，`main.cc --hnsw-only` | `pthread_hnsw_results*.csv` |
| x86 vs ARM/Kunpeng 对比 | x86 已跑完，ARM/Kunpeng 命令和后缀 CSV 已预留 | `run_pthread_x86.*`，`run_pthread_arm.sh` | `*_x86_windows.csv`，`*_arm.csv` |
| OpenMP 卸载到加速器设备 | x86 Intel GPU 已用 Level Zero strict offload 跑完，`OMP_TARGET_OFFLOAD=MANDATORY`，target 区域验证 `omp_is_initial_device()==false`，并按 `recall@100>=0.95` 调参选最小 latency | `pthread_openmp_target_ivf.cc`，`run_pthread_openmp_target.ps1` | `pthread_openmp_target_device_results_x86_windows.csv`，`pthread_openmp_target_device_best_x86_windows.csv` |
| C++ 标准线程工具对比 | `std::thread` 与 `std::async` 对比 | `pthread_hnsw.h` | `pthread_hnsw_results*.csv` |
| oneAPI/SYCL 对比 | Intel GPU O2 IVF batch sweep 已完成 | `pthread_sycl_flat.cc`，`run_pthread_oneapi.ps1` | `pthread_sycl_o2_2024_results_x86_windows.csv` |
| 其他算法优化 | SQ8、PQ-SDC、FastScan、SDC pipeline、IVF-PQ-Local、HNSW、IVF-HNSW | `pthread_*.h` | `pthread_results*.csv`，`pthread_hnsw_results*.csv` |
| AI 辅助附录 | 附录模板已预留 | `report/AI_APPENDIX.md` | 报告附录材料 |

Kunpeng 交接主流程只跑 CPU/Pthread/C++ 标准线程路径。OpenMP 进阶要求按“卸载到加速器设备”处理，已在本地 x86 Intel GPU 上完成 strict target offload；ARM/Kunpeng 端若没有可用 OpenMP target 加速器，不把普通 CPU 执行计入该要求。

## 3. Kunpeng 环境准备

数据目录必须包含：

```text
DEEP100K.base.100k.fbin
DEEP100K.query.fbin
DEEP100K.gt.query.100k.top100.bin
```

建议工具：

```bash
g++ --version
python3 --version
```

建议编译参数：

```bash
export CXX=g++
export CXXFLAGS="-O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I."
```

如果目标编译器不支持 `-mcpu=native`，使用通用 AArch64 参数：

```bash
export CXXFLAGS="-O2 -march=armv8-a -fopenmp -lpthread -std=c++11 -I."
```

Kunpeng 920 可尝试：

```bash
export CXXFLAGS="-O2 -mcpu=tsv110 -fopenmp -lpthread -std=c++11 -I."
```

若编译器不识别 `tsv110`，切回 `-mcpu=native` 或 `-march=armv8-a`。

## 4. Kunpeng 必跑流程

以下命令均在项目根目录进入 `ann` 后执行。ARM/Kunpeng 端默认使用 quick 规模作为正式 ARM 复现实验；本地 x86 才使用完整 `Nq=1000`。`--smoke` 仅用于环境检查。

### 4.1 ARM 主 CPU quick sweep

```bash
cd ann
ANN_DATA=/path/to/anndata \
CXX=g++ \
CXXFLAGS="-O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I." \
bash run_pthread_arm.sh
```

生成文件：

- `files/results/pthread_results_arm.csv`
- `files/results/pthread_best_arm.csv`
- `files/results/pthread_final_arm.csv`
- `files/results/pthread_arm_benchmark.log`
- `files/results/pthread_arm_final.log`

### 4.2 ARM HNSW/图索引进阶 quick sweep

```bash
cd ann
ANN_DATA=/path/to/anndata \
CXX=g++ \
CXXFLAGS="-O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I." \
bash run_pthread_arm.sh --hnsw-only
```

生成文件：

- `files/results/pthread_hnsw_results_arm.csv`
- `files/results/pthread_hnsw_best_arm.csv`
- `files/results/pthread_hnsw_arm.log`

### 4.3 生成 ARM 全局最优

```bash
cd ann
python3 - <<'PY'
import pandas as pd

paths = [
    "files/results/pthread_results_arm.csv",
    "files/results/pthread_hnsw_results_arm.csv",
]
df = pd.concat([pd.read_csv(p) for p in paths], ignore_index=True)
df["latency_ms"] = pd.to_numeric(df["latency_ms"], errors="coerce")
df["recall@100"] = pd.to_numeric(df["recall@100"], errors="coerce")
ok = df[(df["recall@100"] >= 0.95) & (df["latency_ms"] > 0)]
best = ok.sort_values(["latency_ms", "recall@100"], ascending=[True, False]).head(1)
best.to_csv("files/results/pthread_global_best_arm.csv", index=False)
print(best.to_string(index=False))
PY
```

生成文件：

- `files/results/pthread_global_best_arm.csv`

### 4.4 重新生成论文图

```bash
cd ann
python3 plot_pthread.py
```

当前绘图代码只保留两张信息量最高的图：

- `files/figures/fig_pthread_01_pareto_frontier.png`
- `files/figures/fig_pthread_01_pareto_frontier.pdf`
- `files/figures/fig_pthread_02_thread_scaling.png`
- `files/figures/fig_pthread_02_thread_scaling.pdf`

### 4.5 x86 OpenMP target 加速器卸载结果

OpenMP 进阶项不使用 CPU OpenMP 作为替代。当前正式结果来自本地 x86 Intel GPU：

```powershell
cd D:\Parallel-programming-NKU\ann
.\run_pthread_openmp_target.ps1 -Data D:/Parallel-programming-NKU/anndata `
    -Nq 1000 -BaselineMs 3.175053 `
    -NListList "2048" -NProbeList "79,80,81,82,83,84" `
    -CandidateCaps "3808,3824,3840,3856,3872,3904"
```

脚本默认配置：

- 编译器：`tools/conda_envs/oneapi-dpcpp-2024.2.1/Library/bin/icpx.exe`
- target：`-fiopenmp -fopenmp-targets=spir64`
- 设备选择：`ONEAPI_DEVICE_SELECTOR=level_zero:gpu`
- 强制卸载：`OMP_TARGET_OFFLOAD=MANDATORY`
- 设备端验证：target 区域内 `omp_is_initial_device()==false`
- 最优选择：`recall@100>=0.95` 下最小 latency，当前为 `nprobe=81 / candidate_cap=3840`

已生成文件：

- `files/results/pthread_openmp_target_device_results.csv`
- `files/results/pthread_openmp_target_device_best.csv`
- `files/results/pthread_openmp_target_device_results_x86_windows.csv`
- `files/results/pthread_openmp_target_device_best_x86_windows.csv`
- `files/results/pthread_openmp_target_device_x86_windows.log`

## 5. 环境连通性检查

仅用于上机前快速确认编译、数据路径和运行入口；ARM quick 主流程见第 4 节。

```bash
cd ann
ANN_DATA=/path/to/anndata bash run_pthread_arm.sh --arm-quick
ANN_DATA=/path/to/anndata bash run_pthread_arm.sh --arm-quick --hnsw-only
```

如果只想验证默认提交路径：

```bash
cd ann
g++ main.cc -o main -O2 -mcpu=native -fopenmp -lpthread -std=c++11 -I.
ANN_DATA=/path/to/anndata ./main --final-only --arm-quick --data /path/to/anndata --nq 300 --train 2048 --iters 8
```

## 6. ARM 回传与归档

在 ARM/Kunpeng 机器上先加时间戳备份：

```bash
cd ann
ts=$(date +%Y%m%d_%H%M%S)
cp -f files/results/pthread_results_arm.csv files/results/pthread_results_arm_${ts}.csv
cp -f files/results/pthread_best_arm.csv files/results/pthread_best_arm_${ts}.csv
cp -f files/results/pthread_final_arm.csv files/results/pthread_final_arm_${ts}.csv
cp -f files/results/pthread_hnsw_results_arm.csv files/results/pthread_hnsw_results_arm_${ts}.csv
cp -f files/results/pthread_hnsw_best_arm.csv files/results/pthread_hnsw_best_arm_${ts}.csv
cp -f files/results/pthread_global_best_arm.csv files/results/pthread_global_best_arm_${ts}.csv
```

从 x86 工作站拉回：

```bash
scp user@KUNPENG_HOST:/path/to/ann/files/results/pthread_*_arm*.csv ./ann/files/results/
scp user@KUNPENG_HOST:/path/to/ann/files/results/pthread_*_arm*.log ./ann/files/results/
```

## 7. 报告对比口径

正式对比使用平台后缀 CSV，避免覆盖不同平台结果。

| 对比项 | x86 文件 | ARM/Kunpeng 文件 |
|---|---|---|
| 主 CPU sweep | `pthread_results_x86_windows.csv` | `pthread_results_arm.csv` |
| 主 CPU 最优 | `pthread_best_x86_windows.csv` | `pthread_best_arm.csv` |
| 默认提交路径 | `pthread_final_x86_windows.csv` | `pthread_final_arm.csv` |
| HNSW 进阶 | `pthread_hnsw_results_x86_windows.csv` | `pthread_hnsw_results_arm.csv` |
| HNSW 最优 | `pthread_hnsw_best_x86_windows.csv` | `pthread_hnsw_best_arm.csv` |
| 全局最优 | `pthread_global_best_x86_windows.csv` | `pthread_global_best_arm.csv` |

报告分析时按以下顺序组织：

1. 先比较同算法同参数在 x86 与 ARM/Kunpeng 上的线程扩展性。
2. 再比较 `recall@100 >= 0.95` 可行区间内的 latency frontier。
3. 对负优化或收益不明显的策略，只分析 CSV 中正式 sweep 的真实结果，不单独扩展平台不稳定路径。
4. 最终结论使用 `pthread_global_best_*.csv`，不要只使用 HNSW，也不要只使用主 CPU sweep。

## 8. 交接验收清单

ARM/Kunpeng 跑完后，确认以下文件存在且非空：

```text
files/results/pthread_results_arm.csv
files/results/pthread_best_arm.csv
files/results/pthread_final_arm.csv
files/results/pthread_hnsw_results_arm.csv
files/results/pthread_hnsw_best_arm.csv
files/results/pthread_global_best_arm.csv
files/results/pthread_arm_benchmark.log
files/results/pthread_hnsw_arm.log
files/results/pthread_arm_final.log
files/figures/fig_pthread_01_pareto_frontier.png
files/figures/fig_pthread_02_thread_scaling.png
```

验收规则：

- `pthread_results_arm.csv` 必须包含 Flat、SQ8、PQ、PQ-SDC、FastScan、SDC-Pipeline、IVF、IVF-PQ、IVF-PQ-Local。
- `pthread_hnsw_results_arm.csv` 必须包含 `HNSW-ToolCompare`、`HNSW-IntraQuery`、`IVF-HNSW`。
- `pthread_best_arm.csv`、`pthread_hnsw_best_arm.csv`、`pthread_global_best_arm.csv` 必须来自 `recall@100 >= 0.95` 的候选。
- `pthread_final_arm.csv` 是提交路径验证结果，报告中应和 `pthread_global_best_arm.csv` 一起说明。
- ARM/Kunpeng 端 quick 结果可用于 ARM 平台正式表格；`--smoke` 结果不得用于正式表格和结论。
