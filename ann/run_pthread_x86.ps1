param(
    [string]$Data = $env:ANN_DATA,
    [int]$Nq = 0,
    [int]$Train = 0,
    [int]$Iters = 0,
    [switch]$Quick,
    [switch]$Smoke,
    [switch]$WithHnsw,
    [switch]$HnswOnly,
    [switch]$AdvancedOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force files/results, files/figures | Out-Null

if (-not $Data) {
    $Data = "D:/Parallel-programming-NKU/anndata"
}

function Copy-ResultIfExists {
    param([string]$Source, [string]$Dest)
    if (Test-Path $Source) {
        Copy-Item -Force $Source $Dest
    }
}

if ($Smoke) {
    if ($Nq -le 0) { $Nq = 50 }
    if ($Train -le 0) { $Train = 1024 }
    if ($Iters -le 0) { $Iters = 6 }
} elseif ($Quick) {
    if ($Nq -le 0) { $Nq = 500 }
    if ($Train -le 0) { $Train = 4096 }
    if ($Iters -le 0) { $Iters = 10 }
} else {
    if ($Nq -le 0) { $Nq = 1000 }
    if ($Train -le 0) { $Train = 4096 }
    if ($Iters -le 0) { $Iters = 12 }
}

$exe = ".\main_msvc.exe"
if (Get-Command cl -ErrorAction SilentlyContinue) {
    Write-Host "=== [1/4] Compile with MSVC ==="
    $vsDev = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
    if ($env:INCLUDE -match "VC\\Tools") {
        cl /nologo /EHsc /O2 /std:c++17 /openmp /I. main.cc /Fe:main_msvc.exe
    } elseif (Test-Path $vsDev) {
        $cmd = "`"$vsDev`" -arch=x64 -host_arch=x64 >nul && cd /d `"$PSScriptRoot`" && cl /nologo /EHsc /O2 /std:c++17 /openmp /I. main.cc /Fe:main_msvc.exe"
        cmd /c $cmd
    } else {
        cl /nologo /EHsc /O2 /std:c++17 /openmp /I. main.cc /Fe:main_msvc.exe
    }
} elseif (Get-Command g++ -ErrorAction SilentlyContinue) {
    Write-Host "=== [1/4] Compile with g++ ==="
    g++ main.cc -o main.exe -O2 -std=c++11 -fopenmp -I. -lpthread
    $exe = ".\main.exe"
} else {
    throw "No supported C++ compiler found. Install MSVC Build Tools or g++."
}

$advancedMode = $HnswOnly -or $AdvancedOnly
$benchArgs = @("--benchmark")
if ($Quick) { $benchArgs += "--quick" }
if ($Smoke) { $benchArgs += "--smoke" }
if ($WithHnsw) { $benchArgs += "--with-hnsw" }
if ($HnswOnly) { $benchArgs += "--hnsw-only" }
if ($AdvancedOnly) { $benchArgs += "--advanced-only" }
$benchArgs += @("--data", $Data, "--nq", "$Nq", "--train", "$Train", "--iters", "$Iters")

if ($advancedMode) {
    Write-Host "=== [2/2] HNSW/advanced benchmark sweep ==="
    $logPath = "files/results/pthread_hnsw_x86_windows.log"
} else {
    Write-Host "=== [2/4] Benchmark sweep ==="
    $logPath = "files/results/pthread_x86_windows_benchmark.log"
}
& $exe @benchArgs 2>&1 | Tee-Object $logPath

if ($advancedMode) {
    Copy-ResultIfExists "files/results/pthread_hnsw_results.csv" "files/results/pthread_hnsw_results_x86_windows.csv"
    Copy-ResultIfExists "files/results/pthread_hnsw_best.csv" "files/results/pthread_hnsw_best_x86_windows.csv"
    Write-Host "DONE"
    exit 0
}

if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "=== [3/4] Plot figures ==="
    python plot_pthread.py
} else {
    Write-Host "=== [3/4] Plot figures skipped: python not found ==="
}

Write-Host "=== [4/4] Final selected configuration ==="
$finalArgs = @("--final-only")
if ($Quick) { $finalArgs += "--quick" }
if ($Smoke) { $finalArgs += "--smoke" }
$finalArgs += @("--data", $Data, "--nq", "$Nq", "--train", "$Train", "--iters", "$Iters")
& $exe @finalArgs 2>&1 |
    Tee-Object files/results/pthread_x86_windows_final.log
Copy-ResultIfExists "files/results/pthread_results.csv" "files/results/pthread_results_x86_windows.csv"
Copy-ResultIfExists "files/results/pthread_best.csv" "files/results/pthread_best_x86_windows.csv"
Copy-ResultIfExists "files/results/pthread_final.csv" "files/results/pthread_final_x86_windows.csv"

Write-Host "DONE"
