param(
    [string]$Data = "",
    [string]$Csv = "files/results/gpu_results_x86_cuda.csv",
    [switch]$Quick,
    [switch]$BestOnly,
    [switch]$Append
)

$ErrorActionPreference = "Stop"

if ($Data -eq "") {
    if ($env:ANN_DATA) {
        $Data = $env:ANN_DATA
    } else {
        $Data = "D:/Parallel-programming-NKU/anndata"
    }
}

if ($Quick -and $Csv -eq "files/results/gpu_results_x86_cuda.csv") {
    $Csv = "files/results/gpu_quick.csv"
}

New-Item -ItemType Directory -Force -Path "files/results" | Out-Null
New-Item -ItemType Directory -Force -Path "files/figures/gpu_report" | Out-Null
New-Item -ItemType Directory -Force -Path "build" | Out-Null

if (-not (Get-Command nvcc -ErrorAction SilentlyContinue)) {
    throw "nvcc was not found. Install CUDA Toolkit or run from a CUDA-enabled developer shell."
}

$ExePath = "build/gpu_ann.exe"

Write-Host "Compiling $ExePath ..."
& nvcc --allow-unsupported-compiler -O3 -std=c++17 -I. main.cu -lcublas -o $ExePath
if ($LASTEXITCODE -ne 0) { throw "nvcc failed" }

if (-not $Append -and (Test-Path $Csv)) {
    Remove-Item -LiteralPath $Csv -Force
}

function Run-GpuAnn {
    param([string[]]$AnnArgs)
    Write-Host "$ExePath $($AnnArgs -join ' ')"
    & ".\$ExePath" @AnnArgs
    if ($LASTEXITCODE -ne 0) {
        throw "gpu_ann.exe failed: $($AnnArgs -join ' ')"
    }
}

if ($BestOnly) {
    Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", "cuda_ivf",
        "--nbase", "100000", "--nq", "1000", "--batch", "32",
        "--nlist", "256", "--nprobe", "20", "--iters", "3", "--repeat", "5")
    exit 0
}

if ($Quick) {
    foreach ($method in @("cuda_flat_naive", "cuda_flat_tiled", "cuda_flat_cublas",
                         "cuda_ivf", "cuda_ivf_cluster", "cuda_ivf_cluster_grouped")) {
        Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", $method,
            "--nbase", "10000", "--nq", "50", "--batch", "32",
            "--nlist", "64", "--nprobe", "8", "--iters", "2", "--repeat", "1")
    }
    exit 0
}

# Exact matrix multiplication baseline and kernel-level optimizations.
foreach ($batch in @("16", "32", "64", "128", "256")) {
    Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", "cuda_flat_tiled",
        "--nbase", "100000", "--nq", "1000", "--batch", $batch,
        "--nlist", "256", "--nprobe", "32", "--iters", "3", "--repeat", "3")
    Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", "cuda_flat_cublas",
        "--nbase", "100000", "--nq", "1000", "--batch", $batch,
        "--nlist", "256", "--nprobe", "32", "--iters", "3", "--repeat", "3")
}

foreach ($batch in @("32", "128")) {
    Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", "cuda_flat_naive",
        "--nbase", "100000", "--nq", "1000", "--batch", $batch,
        "--nlist", "256", "--nprobe", "32", "--iters", "3", "--repeat", "3")
}

# CPU exact scan is run on the full base set and a smaller query sample. Latency is per query.
Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", "cpu_flat",
    "--nbase", "100000", "--nq", "100", "--batch", "1",
    "--nlist", "256", "--nprobe", "32", "--iters", "3", "--repeat", "1")

# IVF recall/latency sweep on the full dataset.
foreach ($nprobe in @("12", "16", "18", "20", "22", "24", "32", "48", "64", "96", "128")) {
    Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", "cuda_ivf",
        "--nbase", "100000", "--nq", "1000", "--batch", "128",
        "--nlist", "256", "--nprobe", $nprobe, "--iters", "3", "--repeat", "3")
}

# Batch-size sweep around the threshold region.
foreach ($batch in @("32", "64", "128", "256")) {
    Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", "cuda_ivf",
        "--nbase", "100000", "--nq", "1000", "--batch", $batch,
        "--nlist", "256", "--nprobe", "20", "--iters", "3", "--repeat", "3")
}

# IVF cluster-matrix baseline and query grouping strategy. These runs use the same full base
# but a 300-query sample because the baseline intentionally launches many cluster-level kernels.
foreach ($method in @("cuda_ivf_cluster", "cuda_ivf_cluster_grouped")) {
    foreach ($nprobe in @("16", "22", "32")) {
        Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", $method,
            "--nbase", "100000", "--nq", "300", "--batch", "128",
            "--nlist", "256", "--nprobe", $nprobe, "--iters", "3", "--repeat", "1")
    }
}

# Final verification row under the report objective: minimum latency with recall@100 >= 0.95.
Run-GpuAnn @("--data", $Data, "--csv", $Csv, "--method", "cuda_ivf",
    "--nbase", "100000", "--nq", "1000", "--batch", "32",
    "--nlist", "256", "--nprobe", "20", "--iters", "3", "--repeat", "5")
