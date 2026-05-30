#!/bin/sh
#PBS -N ann_mpi
#PBS -e test.e
#PBS -o test.o
#PBS -l nodes=2:ppn=8

set -eu

PROJECT=ann
EXE=main
NP=${NP:-8}
ANN_DATA=${ANN_DATA:-/home/${USER}/anndata}
CSV=${CSV:-files/results/mpi_results_cluster.csv}

cd /home/${USER}/${PROJECT}
mpic++ -O3 -std=c++17 -fopenmp -march=native -I. -Ihnswlib main.cc -o ${EXE}

NODES=$(cat "$PBS_NODEFILE" | sort | uniq)
for node in $NODES; do
    scp "master_ubss1:/home/${USER}/${PROJECT}/${EXE}" "${node}:/home/${USER}/${EXE}" 1>&2
    scp -r "master_ubss1:/home/${USER}/${PROJECT}/hnswlib" "${node}:/home/${USER}/" 1>&2 || true
    scp -r "master_ubss1:${ANN_DATA}" "${node}:/home/${USER}/anndata" 1>&2 || true
done

/usr/local/bin/mpiexec -np "${NP}" -machinefile "$PBS_NODEFILE" "/home/${USER}/${EXE}" \
    --data "/home/${USER}/anndata" \
    --csv "${CSV}" \
    --method ivf \
    --comm nonblocking \
    --thread-model openmp \
    --kernel simd \
    --threads 2 \
    --nbase 100000 \
    --nq 1000 \
    --nlist 512 \
    --nprobe 64 \
    --repeat 3 \
    --nodes 2 \
    --ppn 8

scp -r "/home/${USER}/files" "master_ubss1:/home/${USER}/${PROJECT}/" 2>&1
