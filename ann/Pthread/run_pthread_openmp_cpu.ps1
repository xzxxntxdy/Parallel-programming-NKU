param(
    [string]$Data = $env:ANN_DATA,
    [int]$Nq = 0,
    [int]$Train = 0,
    [int]$Iters = 0,
    [switch]$Quick,
    [switch]$Smoke
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force files/results | Out-Null

if (-not $Data) {
    $Data = "D:/Parallel-programming-NKU/anndata"
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

$exe = ".\openmp_cpu_msvc.exe"
if (Get-Command cl -ErrorAction SilentlyContinue) {
    Write-Host "=== [1/2] Compile OpenMP CPU with MSVC ==="
    $vsDev = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
    if ($env:INCLUDE -match "VC\\Tools") {
        cl /nologo /EHsc /O2 /std:c++17 /openmp /I. pthread_openmp_host.cc /Fe:openmp_cpu_msvc.exe
    } elseif (Test-Path $vsDev) {
        $cmd = "`"$vsDev`" -arch=x64 -host_arch=x64 >nul && cd /d `"$PSScriptRoot`" && cl /nologo /EHsc /O2 /std:c++17 /openmp /I. pthread_openmp_host.cc /Fe:openmp_cpu_msvc.exe"
        cmd /c $cmd
    } else {
        cl /nologo /EHsc /O2 /std:c++17 /openmp /I. pthread_openmp_host.cc /Fe:openmp_cpu_msvc.exe
    }
} elseif (Get-Command g++ -ErrorAction SilentlyContinue) {
    Write-Host "=== [1/2] Compile OpenMP CPU with g++ ==="
    g++ pthread_openmp_host.cc -o openmp_cpu.exe -O2 -std=c++11 -fopenmp -I. -lpthread
    $exe = ".\openmp_cpu.exe"
} else {
    throw "No supported C++ compiler found. Install MSVC Build Tools or g++."
}

$args = @("--benchmark")
if ($Quick) { $args += "--quick" }
if ($Smoke) { $args += "--smoke" }
$args += @("--data", $Data, "--nq", "$Nq", "--train", "$Train", "--iters", "$Iters")

Write-Host "=== [2/2] Run OpenMP host CPU sweep ==="
& $exe @args 2>&1 | Tee-Object files/results/pthread_openmp_cpu_x86_windows.log

if (Test-Path files/results/pthread_openmp_cpu_results.csv) {
    Copy-Item -Force files/results/pthread_openmp_cpu_results.csv files/results/pthread_openmp_cpu_results_x86_windows.csv
}
if (Test-Path files/results/pthread_openmp_cpu_best.csv) {
    Copy-Item -Force files/results/pthread_openmp_cpu_best.csv files/results/pthread_openmp_cpu_best_x86_windows.csv
}

Write-Host "DONE"
