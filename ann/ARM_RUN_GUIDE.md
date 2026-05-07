# ARM Kunpeng-920 服务器复现实验指南

## 前提

- 已登录 Kunpeng-920 服务器 (aarch64)
- 项目路径: `/home/s2412235/Parallel-programming-NKU/ann`
- 已安装 g++ (GCC 11.4+), perf

## 1. 同步最新代码

将本地修改的 `ann_quant.h` 和 `ann_search.h` 上传到服务器:

```bash
# 从本地上传 (在本地 Git Bash 执行)
scp ann_quant.h ann_search.h s2412235@master_ubss1:/home/s2412235/Parallel-programming-NKU/ann/

# 或在服务器上直接 pull
cd /home/s2412235/Parallel-programming-NKU
git pull
```

## 2. 编译 (服务器)

```bash
cd /home/s2412235/Parallel-programming-NKU/ann
g++ main.cc -o main -O2 -fopenmp -lpthread -std=c++11
```

## 3. 运行官方 test.sh

```bash
bash test.sh 1 1
```

预期输出格式:
```
average recall: <value>
average latency (us): <value>
```

## 4. 单独 kernel 测试 (用于 perf/详细分析)

```bash
# Flat 系列
./main --kernel flat-scalar 2000 3
./main --kernel flat-neon 2000 3
./main --kernel flat-unroll4 2000 3
./main --kernel flat-fixed 2000 3

# SQ8 系列
./main --kernel sq8-p100 2000 3
./main --kernel sq8-p500 2000 3
./main --kernel sq8-p1000 2000 3
./main --kernel sq8-p2000 2000 3
./main --kernel sq8-p5000 2000 3

# PQ-ADC 系列
./main --kernel pqsel-m16-p500 2000 3
./main --kernel pqsel-m16-p1000 2000 3
./main --kernel pqsel-m16-p2000 2000 3

# PQ-SDC 系列
./main --kernel sdc-m16-p0 200 1
./main --kernel sdc-m16-p1000 200 1
./main --kernel sdc-m16-p2000 200 1
./main --kernel sdc-m8-p1000 200 1
./main --kernel sdc-m12-p1000 200 1

# FastScan 系列 (使用更新后的 ann_quant.h)
./main --kernel fsadc-m16-p1000-b32 2000 3
./main --kernel fsadc-m16-p1500-b32 2000 3
./main --kernel fsadc-m16-p1500-b64 2000 3
./main --kernel fsadc-m16-p1000-b64 2000 3

# Pipeline 系列
./main --kernel sdc-m16-p1000 2000 3   # sequential baseline
```

## 5. Perf 分析

```bash
# Flat-NEON baseline
perf stat -x, -e cycles,instructions,branch-misses,\
L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
-o files/results/perf_flat_neon.csv \
./main --kernel flat-neon 2000 3

# FastScan (更新后)
perf stat -x, -e cycles,instructions,branch-misses,\
L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
-o files/results/perf_fastscan_new.csv \
./main --kernel fsadc-m16-p1500-b64 2000 3

# Naive PQ-ADC
perf stat -x, -e cycles,instructions,branch-misses,\
L1-dcache-loads,L1-dcache-load-misses,LLC-loads,LLC-load-misses \
-o files/results/perf_pq_adc.csv \
./main --kernel pqsel-m16-p2000 2000 3
```

## 6. 汇编分析

```bash
g++ -O2 -S main.cc -o main_arm.s
# 查看 NEON SIMD 指令
grep -E 'fmla|ldr.*q[0-9]|str.*q[0-9]|dup|fadd' main_arm.s | head -50
```

## 7. 运行 benchmark 并保存结果

```bash
# 主程序会写入 files/results/simd_results.csv
./main --final-only

# 查看结果
cat files/results/simd_results.csv
```

## 8. 生成图表

```bash
# 在服务器上安装 matplotlib (如果还没有)
pip install matplotlib numpy pandas --user

# 生成图表
cd /home/s2412235/Parallel-programming-NKU/ann
python plot_simd_paper.py
# 图表输出到 files/figures/
```

## 9. 结果传回本地

```bash
# 在本地 Git Bash 执行
scp -r s2412235@master_ubss1:/home/s2412235/Parallel-programming-NKU/ann/files/results/*.csv ./files/results/
scp -r s2412235@master_ubss1:/home/s2412235/Parallel-programming-NKU/ann/files/figures/*.png ./files/figures/
```

## 关键变更说明

本次更新的 `ann_quant.h` 将 FastScan 从旧的 part-major 布局改为 lane-major:
- 旧: codes[block][part][lane] — 内存 RMW 累加
- 新: codes[block][lane][part] — 寄存器累加 + 4-way unroll

预期 ARM 上 FastScan 性能进一步提升 (原 3.12ms → 预期 ~2.6-2.8ms)。
