param(
    [string]$Data = $env:ANN_DATA,
    [int]$Nq = 1000,
    [double]$BaselineMs = 3.175053,
    [string]$DeviceSelector = "opencl:gpu",
    [ValidateSet("intel-gpu", "gpu", "cpu", "default")]
    [string]$Device = "intel-gpu",
    [ValidateSet("SafeO2", "O2", "O0")]
    [string]$BuildProfile = "O2",
    [ValidateSet("Auto", "SYCL", "OpenCLC")]
    [string]$Backend = "Auto",
    [string]$OneApiRoot = "",
    [switch]$ProbeDevice,
    [string]$Csv = "files/results/pthread_sycl_results.csv",
    [string]$BestCsv = "files/results/pthread_sycl_best.csv",
    [ValidateSet("ivf", "flat")]
    [string]$Algo = "ivf",
    [int]$NList = 2048,
    [string]$NProbeList = "76,78,80,82,84",
    [int]$Iters = 12,
    [double]$TargetRecall = 0.95,
    [int]$Batch = 1000,
    [ValidateSet(1, 2, 4, 8, 16)]
    [int]$QueryBlock = 16,
    [ValidateSet(64, 128, 256)]
    [int]$WorkgroupSize = 128,
    [ValidateSet(4, 8, 16)]
    [int]$LocalK = 4
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
New-Item -ItemType Directory -Force files/results | Out-Null

if (-not $Data) {
    $Data = "D:/Parallel-programming-NKU/anndata"
}

$vsDev = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
$repoRoot = Split-Path -Parent $PSScriptRoot
$localOneApi2024 = Join-Path $repoRoot "tools\conda_envs\oneapi-dpcpp-2024.2.1\Library"
if (-not $OneApiRoot) {
    if (Test-Path (Join-Path $localOneApi2024 "bin\icpx.exe")) {
        $OneApiRoot = $localOneApi2024
    } else {
        $OneApiRoot = "C:\Program Files (x86)\Intel\oneAPI"
    }
}
$OneApiRoot = (Resolve-Path $OneApiRoot).Path

$condaIpx = Join-Path $OneApiRoot "bin\icpx.exe"
$oneApiSetvars = Join-Path $OneApiRoot "setvars.bat"
$usingCondaLayout = Test-Path $condaIpx
$usingOneApiLayout = Test-Path $oneApiSetvars

if ($usingCondaLayout) {
    $icpx = $condaIpx
    $compilerBin = Split-Path -Parent $icpx
    $compilerLib = Join-Path $OneApiRoot "lib"
    $pathFragments = @(
        $compilerBin,
        (Join-Path $OneApiRoot "lib"),
        (Join-Path $OneApiRoot "compiler\lib")
    )
} elseif ($usingOneApiLayout) {
    $compilerRoot = Join-Path $OneApiRoot "compiler"
    $compilerDirs = Get-ChildItem $compilerRoot -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName "bin\icpx.exe") } |
        Sort-Object Name -Descending
    if (-not $compilerDirs) {
        throw "No icpx.exe found under $compilerRoot"
    }
    $icpx = Join-Path $compilerDirs[0].FullName "bin\icpx.exe"
    $compilerBin = Split-Path -Parent $icpx
    $compilerLib = Join-Path $compilerDirs[0].FullName "lib"
    $componentBins = Get-ChildItem $OneApiRoot -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName "bin") } |
        Sort-Object Name -Descending |
        ForEach-Object { Join-Path $_.FullName "bin" }
    $pathFragments = @($compilerBin, $compilerLib) + $componentBins
} else {
    throw "Unsupported oneAPI root: $OneApiRoot. Expected a conda Library root with bin\icpx.exe or a oneAPI root with setvars.bat."
}
$pathFragments = $pathFragments | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique
$pathPrefix = ($pathFragments -join ";")
$compilerVersion = (& $icpx --version | Select-Object -First 1)

$compilerAvoidsSyclO2Crash = $compilerVersion -match "2024\.2\.1"
$useOpenCLC = ($Backend -eq "OpenCLC") -or
               ($Backend -eq "Auto" -and -not $compilerAvoidsSyclO2Crash -and
                $BuildProfile -eq "O2" -and $Algo -eq "ivf" -and $Device -ne "cpu")
if ($useOpenCLC -and $Algo -ne "ivf") {
    throw "OpenCLC backend currently supports only -Algo ivf."
}
if ($useOpenCLC -and $Device -eq "cpu") {
    throw "OpenCLC backend is the Intel GPU OpenCL C path; use -Backend SYCL for CPU."
}

$exeName = "pthread_sycl_flat_oneapi.exe"
if ($useOpenCLC) {
    $exeName = "pthread_opencl_ivf.exe"
    $openclInclude = Join-Path $OneApiRoot "include"
    $openclLib = Join-Path $OneApiRoot "lib"
    if (-not (Test-Path $openclInclude) -or -not (Test-Path (Join-Path $openclLib "OpenCL.lib"))) {
        $systemOneApi = "C:\Program Files (x86)\Intel\oneAPI"
        $systemVersionBins = Get-ChildItem $systemOneApi -Directory -ErrorAction SilentlyContinue |
            Where-Object { Test-Path (Join-Path $_.FullName "include\CL\cl.h") } |
            Sort-Object Name -Descending
        if (-not $systemVersionBins) {
            throw "OpenCL headers/libs not found under $OneApiRoot or $systemOneApi"
        }
        $openclInclude = Join-Path $systemVersionBins[0].FullName "include"
        $openclLib = Join-Path $systemVersionBins[0].FullName "lib"
    }
    $cmd = "`"$vsDev`" -arch=x64 -host_arch=x64 >nul && " +
           "set `"PATH=$pathPrefix;!PATH!`" && " +
           "set `"LIB=$openclLib;$compilerLib;!LIB!`" && " +
           "cd /d `"$PSScriptRoot`" && " +
           "cl /nologo /O2 /std:c++17 /EHsc /I. /I`"$openclInclude`" pthread_opencl_ivf.cc " +
           "/link /LIBPATH:`"$openclLib`" OpenCL.lib /OUT:$exeName"
} else {
    $compileOpt = "-O2"
    $extraFlagList = @()
    if ($BuildProfile -eq "SafeO2") {
        $compileOpt = "-O2"
        $extraFlagList += "-fno-sycl-early-optimizations"
    } elseif ($BuildProfile -eq "O0") {
        $compileOpt = "-O0"
    }
    if ($Algo -eq "ivf") {
        $extraFlagList += "-DANN_SYCL_IVF_ONLY=1"
    }
    $extraFlags = $extraFlagList -join " "

    $cmd = "`"$vsDev`" -arch=x64 -host_arch=x64 >nul && " +
           "set `"PATH=$pathPrefix;!PATH!`" && " +
           "set `"LIB=$compilerLib;!LIB!`" && " +
           "cd /d `"$PSScriptRoot`" && " +
           "`"$icpx`" -fsycl $compileOpt $extraFlags -std=c++17 -I. pthread_sycl_flat.cc -o $exeName"
}
cmd /v:on /c $cmd
if ($LASTEXITCODE -ne 0) {
    throw "oneAPI/OpenCL compile failed with exit code $LASTEXITCODE"
}

$env:PATH = "$pathPrefix;" + $env:PATH
$env:ONEAPI_DEVICE_SELECTOR = $DeviceSelector

$syclLs = Join-Path $compilerBin "sycl-ls.exe"
if ($ProbeDevice -and (Test-Path $syclLs)) {
    $deviceOutput = cmd /c "`"$syclLs`" --ignore-device-selectors 2>&1"
    $deviceOutput | Tee-Object files/results/pthread_sycl_devices.log
} else {
    "device_probe=skipped; compiler=$compilerVersion; oneapi_root=$OneApiRoot" |
        Tee-Object files/results/pthread_sycl_devices.log
}

$method = "IntelOpenCLGPU-BatchedUSM"
if ($useOpenCLC) {
    $method = "IntelOpenCLGPU-OpenCLC"
} elseif ($Device -eq "cpu") {
    $method = "IntelOpenCLCPU-BatchedUSM"
} elseif ($Device -eq "default") {
    $method = "DefaultQueue-BatchedUSM"
} elseif ($Device -eq "gpu") {
    $method = "OpenCLGPU-BatchedUSM"
}

$backendName = if ($useOpenCLC) { "OpenCLC" } else { "SYCL" }
$notes = "windows_oneapi; selector_env=$DeviceSelector; build=$BuildProfile; backend=$backendName; compiler=$compilerVersion"
if ($useOpenCLC) {
    $notes = "windows_opencl_c; host_build=O2; cl_build=default_optimized; compiler=$compilerVersion"
}
$runCmd = "`".\$exeName`" --data `"$Data`" --nq $Nq --baseline-ms $BaselineMs " +
          "--device $Device --method $method --notes `"$notes`" --csv `"$Csv`" " +
          "--best-csv `"$BestCsv`" --algo $Algo --nlist $NList --iters $Iters " +
          "--nprobe-list `"$NProbeList`" --target-recall $TargetRecall " +
          "--batch $Batch --query-block $QueryBlock " +
          "--workgroup-size $WorkgroupSize --local-k $LocalK 2>&1"
$output = cmd /c $runCmd
$runCode = $LASTEXITCODE
$runLog = if ($useOpenCLC) { "files/results/pthread_opencl_x86_windows.log" } else { "files/results/pthread_sycl_x86_windows.log" }
$output | Tee-Object $runLog
if ($runCode -ne 0) {
    throw "oneAPI/OpenCL run failed with exit code $runCode"
}

Write-Host "DONE"
