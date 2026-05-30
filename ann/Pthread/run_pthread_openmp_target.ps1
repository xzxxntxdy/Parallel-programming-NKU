param(
    [string]$Data = $env:ANN_DATA,
    [int]$Nq = 1000,
    [double]$BaselineMs = 3.175053,
    [string]$DeviceSelector = "level_zero:gpu",
    [string]$Csv = "files/results/pthread_openmp_target_device_results.csv",
    [string]$BestCsv = "files/results/pthread_openmp_target_device_best.csv",
    [string]$CompilerRoot = "D:/Parallel-programming-NKU/tools/conda_envs/oneapi-dpcpp-2024.2.1/Library",
    [string]$NListList = "2048",
    [string]$NProbeList = "48,64,72,80,88,96,112",
    [string]$CandidateCaps = "2048,3072,4096,6144",
    [int]$Batch = 1000,
    [int]$Iters = 12,
    [double]$TargetRecall = 0.95,
    [switch]$Spir64,
    [switch]$Spir64Gen,
    [string]$DeviceArch = "xe-lpg"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force files/results | Out-Null

if (-not $Data) {
    $Data = "D:/Parallel-programming-NKU/anndata"
}

$vsDev = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
$oneApi = "C:\Program Files (x86)\Intel\oneAPI\setvars.bat"
$compilerBin = Join-Path $CompilerRoot "bin"
$compilerInclude = Join-Path $CompilerRoot "opt/compiler/include"
$icpx = Join-Path $compilerBin "icpx.exe"
$compilerLib = Join-Path $CompilerRoot "opt/compiler/lib"
$envRoot = Split-Path -Parent $CompilerRoot
$altInclude = Join-Path $envRoot "opt/compiler/include"
$altLib = Join-Path $envRoot "opt/compiler/Library/lib"
if ((-not (Test-Path $compilerInclude)) -and (Test-Path $altInclude)) {
    New-Item -ItemType Directory -Force (Split-Path -Parent $compilerInclude) | Out-Null
    New-Item -ItemType Junction -Path $compilerInclude -Target $altInclude | Out-Null
}
if ((-not (Test-Path $compilerLib)) -and (Test-Path $altLib)) {
    New-Item -ItemType Directory -Force (Split-Path -Parent $compilerLib) | Out-Null
    New-Item -ItemType Junction -Path $compilerLib -Target $altLib | Out-Null
}
$useSetvars = $false
if (-not (Test-Path $icpx)) {
    if (-not (Test-Path $oneApi)) {
        throw "oneAPI compiler not found. Install Intel oneAPI C++ Essentials or pass -CompilerRoot."
    }
    $useSetvars = $true
    $icpx = "icpx"
}

if (-not $Spir64 -and -not $Spir64Gen) {
    $Spir64 = $true
}

$targetFlags = "-fiopenmp -fopenmp-targets=spir64"
$exeName = "pthread_openmp_target_ivf_oneapi.exe"
$logName = "pthread_openmp_target_device_x86_windows.log"
if ($Spir64Gen) {
    $targetFlags = "-fiopenmp -fopenmp-targets=spir64_gen " +
                   "-Xopenmp-target-backend=spir64_gen -device " +
                   "-Xopenmp-target-backend=spir64_gen $DeviceArch"
    $exeName = "pthread_openmp_target_ivf_spir64_gen_oneapi.exe"
    $logName = "pthread_openmp_target_device_spir64_gen_x86_windows.log"
}

$setvarsPart = ""
if ($useSetvars) {
    $setvarsPart = "`"$oneApi`" >nul && "
}

$env:PATH = "$compilerBin;" + $env:PATH
$cmd = "`"$vsDev`" -arch=x64 -host_arch=x64 >nul && " +
       $setvarsPart +
       "cd /d `"$PSScriptRoot`" && " +
       "`"$icpx`" $targetFlags -O2 -mavx2 -std=c++17 -I. " +
       "-I`"$compilerInclude`" " +
       "pthread_openmp_target_ivf.cc -o $exeName " +
       "-Xlinker /NODEFAULTLIB:libmmt.lib"
cmd /c $cmd
if ($LASTEXITCODE -ne 0) {
    throw "OpenMP target compile failed with exit code $LASTEXITCODE"
}

if (Test-Path $Csv) { Remove-Item -Force $Csv }
if (Test-Path $BestCsv) { Remove-Item -Force $BestCsv }

$env:ONEAPI_DEVICE_SELECTOR = $DeviceSelector
$env:OMP_TARGET_OFFLOAD = "MANDATORY"

$runCmd = "`".\$exeName`" --data `"$Data`" --nq $Nq --baseline-ms $BaselineMs " +
          "--target-recall $TargetRecall --batch $Batch --iters $Iters " +
          "--nlist-list `"$NListList`" --nprobe-list `"$NProbeList`" " +
          "--candidate-cap-list `"$CandidateCaps`" " +
          "--csv `"$Csv`" --best-csv `"$BestCsv`" 2>&1"
$output = cmd /c $runCmd
$runCode = $LASTEXITCODE
$output | Tee-Object "files/results/$logName"
if ($runCode -ne 0) {
    throw "OpenMP target run failed with exit code $runCode"
}

if (Test-Path $Csv) {
    $rows = Import-Csv $Csv
    $best = $rows |
        Where-Object { [double]($_.'recall@100') -ge 0.95 -and [double]($_.latency_ms) -gt 0 } |
        Sort-Object @{ Expression = { [double]$_.latency_ms }; Ascending = $true },
                    @{ Expression = { [double]($_.'recall@100') }; Ascending = $false } |
        Select-Object -First 1
    if ($best) {
        $best | Export-Csv -Path $BestCsv -NoTypeInformation -Encoding ascii
    }
    Copy-Item -Force $Csv "files/results/pthread_openmp_target_device_results_x86_windows.csv"
    if (Test-Path $BestCsv) {
        Copy-Item -Force $BestCsv "files/results/pthread_openmp_target_device_best_x86_windows.csv"
    }
}

Write-Host "DONE"
