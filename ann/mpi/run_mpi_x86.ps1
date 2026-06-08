param(
    [string]$Data = $(if ($env:ANN_DATA) { $env:ANN_DATA } else { "D:\Parallel-programming-NKU\anndata" }),
    [string]$Csv = "files\results\mpi_results_x86_windows.csv",
    [switch]$Quick,
    [switch]$Best,
    [switch]$Clean
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
if ($Best) {
    $Quick = $false
    if (-not $PSBoundParameters.ContainsKey("Csv") -and -not $env:CSV) {
        $Csv = "files\results\mpi_best_run_x86_windows.csv"
    }
}

New-Item -ItemType Directory -Force -Path (Split-Path $Csv) | Out-Null
if ($Clean -and (Test-Path $Csv)) {
    Remove-Item $Csv -Force
}

$launcher = Get-Command mpiexec -ErrorAction SilentlyContinue
if (-not $launcher) { $launcher = Get-Command mpirun -ErrorAction SilentlyContinue }
if (-not $launcher) {
    $condaMpi = Join-Path (Split-Path $PSScriptRoot -Parent) ".conda-envs\mpi\Library\bin\mpiexec.exe"
    if (Test-Path $condaMpi) { $launcher = Get-Item $condaMpi }
}
if (-not $launcher) {
    throw "mpiexec/mpirun not found. Install an MPI runtime before running MPI experiments."
}

$exe = "mpi_main.exe"
if (Test-Path $exe) {
    Remove-Item $exe -Force
}
$compiler = Get-Command mpic++ -ErrorAction SilentlyContinue
if (-not $compiler) { $compiler = Get-Command mpicxx -ErrorAction SilentlyContinue }
if (-not $compiler) { $compiler = Get-Command mpiicpx -ErrorAction SilentlyContinue }
if ($compiler) {
    & $compiler.Source -O3 -std=c++17 -fopenmp -mavx2 -mfma -I. -I.. -I../hnswlib main.cc -o $exe
    if ($LASTEXITCODE -ne 0) { throw "MPI C++ compilation failed." }
} else {
    $cl = Get-Command cl.exe -ErrorAction SilentlyContinue
    $mpiPrefix = Join-Path (Split-Path $PSScriptRoot -Parent) ".conda-envs\mpi\Library"
    $mpiInclude = Join-Path $mpiPrefix "include"
    $mpiLib = Join-Path $mpiPrefix "lib"
    $mpiBin = Join-Path $mpiPrefix "bin"
    if (-not $cl -or -not (Test-Path (Join-Path $mpiInclude "mpi.h")) -or -not (Test-Path (Join-Path $mpiLib "msmpi.lib"))) {
        throw "No mpic++ wrapper found and MSVC+MS-MPI fallback is unavailable."
    }
    $vcvars = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
    if (-not (Test-Path $vcvars)) {
        throw "MSVC found but vcvars64.bat is unavailable."
    }
    $env:PATH = "$mpiBin;$env:PATH"
    $cmd = "`"$vcvars`" && set PATH=$mpiBin;%PATH% && cl /nologo /O2 /arch:AVX2 /std:c++17 /EHsc /openmp /I. /I.. /I../hnswlib /I`"$mpiInclude`" main.cc /link /LIBPATH:`"$mpiLib`" msmpi.lib /OUT:$exe"
    cmd /c $cmd
    if ($LASTEXITCODE -ne 0) { throw "MSVC/MS-MPI compilation failed." }
}

$nq = if ($Quick) { 300 } else { 1000 }
$bases = if ($Quick) { @(10000, 25000, 50000) } else { @(25000, 50000, 100000) }
$ranks = if ($Quick) { @(1, 2, 4) } else { @(1, 2, 4, 8) }
$threadVals = if ($Quick) { @(1, 2) } else { @(1, 2, 4) }
$nprobes = if ($Quick) { @(16, 32, 64) } else { @(16, 32, 64, 128, 256) }
$repeat = if ($Quick) { 1 } else { 3 }

function Run-MpiAnn {
    param(
        [int]$Np,
        [string]$Method,
        [string]$Comm,
        [string]$ThreadModel,
        [int]$Threads,
        [int]$NBase,
        [int]$NProbe,
        [int]$Ef = 64,
        [string]$Kernel = "simd",
        [switch]$ThreadMultiple
    )
    $args = @(
        "-n", "$Np", ".\$exe"
    )
    if ($Quick) { $args += "--quick" }
    $args += @(
        "--data", $Data,
        "--csv", $Csv,
        "--method", $Method,
        "--comm", $Comm,
        "--thread-model", $ThreadModel,
        "--kernel", $Kernel,
        "--threads", "$Threads",
        "--nbase", "$NBase",
        "--nq", "$nq",
        "--nlist", "512",
        "--nprobe", "$NProbe",
        "--ef", "$Ef",
        "--repeat", "$repeat",
        "--nodes", "1",
        "--ppn", "$Np"
    )
    if ($ThreadMultiple) { $args += "--mpi-thread-multiple" }
    Write-Host "mpiexec $($args -join ' ')"
    $launcherPath = if ($launcher.Source) { $launcher.Source } else { $launcher.FullName }
    & $launcherPath @args
    if ($LASTEXITCODE -ne 0) { throw "MPI run failed for method=$Method np=$Np comm=$Comm threads=$Threads nbase=$NBase nprobe=$NProbe" }
}

if ($Best) {
    Run-MpiAnn -Np 2 -Method "hnsw" -Comm "nonblocking" -ThreadModel "openmp" -Threads 4 -NBase 100000 -NProbe 64 -Ef 64 -Kernel "simd"
    Write-Host "MPI best full-data result written to $Csv"
    exit 0
}

foreach ($nbase in $bases) {
    foreach ($np in $ranks) {
        Run-MpiAnn -Np $np -Method "flat" -Comm "blocking" -ThreadModel "stdthread" -Threads 1 -NBase $nbase -NProbe 512
        foreach ($nprobe in $nprobes) {
            Run-MpiAnn -Np $np -Method "ivf" -Comm "blocking" -ThreadModel "stdthread" -Threads 1 -NBase $nbase -NProbe $nprobe
        }
    }
}

foreach ($np in $ranks) {
    foreach ($comm in @("blocking", "nonblocking", "p2p", "onesided")) {
        Run-MpiAnn -Np $np -Method "ivf" -Comm $comm -ThreadModel "stdthread" -Threads 1 -NBase 100000 -NProbe 64
    }
    foreach ($threads in $threadVals) {
        Run-MpiAnn -Np $np -Method "ivf" -Comm "nonblocking" -ThreadModel "openmp" -Threads $threads -NBase 100000 -NProbe 64
        Run-MpiAnn -Np $np -Method "hnsw" -Comm "nonblocking" -ThreadModel "openmp" -Threads $threads -NBase 100000 -NProbe 64 -Ef 64
        Run-MpiAnn -Np $np -Method "hnsw" -Comm "nonblocking" -ThreadModel "stdthread" -Threads $threads -NBase 100000 -NProbe 64 -Ef 64
    }
    Run-MpiAnn -Np $np -Method "ivf" -Comm "nonblocking" -ThreadModel "stdthread" -Threads 1 -NBase 100000 -NProbe 64 -ThreadMultiple
    Run-MpiAnn -Np $np -Method "flat" -Comm "blocking" -ThreadModel "stdthread" -Threads 1 -NBase 100000 -NProbe 512 -Kernel "scalar"
    Run-MpiAnn -Np $np -Method "ivf" -Comm "blocking" -ThreadModel "stdthread" -Threads 1 -NBase 100000 -NProbe 64 -Kernel "scalar"
}

foreach ($np in @(2, 4, 8)) {
    foreach ($ef in @(32, 64, 128)) {
        Run-MpiAnn -Np $np -Method "multi-hnsw" -Comm "nonblocking" -ThreadModel "stdthread" -Threads 1 -NBase 100000 -NProbe 64 -Ef $ef
        foreach ($nprobe in @(16, 32, 64)) {
            Run-MpiAnn -Np $np -Method "ivf-hnsw" -Comm "nonblocking" -ThreadModel "stdthread" -Threads 1 -NBase 100000 -NProbe $nprobe -Ef $ef
        }
    }
}

Write-Host "MPI results written to $Csv"
