param(
    [string]$Data = $env:ANN_DATA,
    [int]$Nq = 1000,
    [int]$Device = 0,
    [double]$BaselineMs = 0.0
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force files/results | Out-Null

if (-not $Data) {
    $Data = "D:/Parallel-programming-NKU/anndata"
}

if (-not (Get-Command nvcc -ErrorAction SilentlyContinue)) {
    throw "nvcc not found. Install CUDA Toolkit or add it to PATH."
}

Write-Host "=== CUDA flat GPU benchmark ==="
nvcc -O2 -std=c++17 -I. pthread_cuda_flat.cu -o pthread_cuda_flat.exe
$runArgs = @("--data", $Data, "--nq", "$Nq", "--device", "$Device")
if ($BaselineMs -gt 0.0) {
    $runArgs += @("--baseline-ms", "$BaselineMs")
}
.\pthread_cuda_flat.exe @runArgs 2>&1 |
    Tee-Object files/results/pthread_cuda_x86_windows.log

Write-Host "DONE"
