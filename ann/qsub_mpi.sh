#!/bin/sh
#PBS -N ann_mpi
#PBS -e test.e
#PBS -o test.o
#PBS -l nodes=1:ppn=8

set -eu

PROJECT=ann
EXE=main
NP=${NP:-2}
THREADS=${THREADS:-4}
ANN_DATA=${ANN_DATA:-/home/${USER}/anndata}
CSV=${CSV:-files/results/mpi_best_run_cluster.csv}
MPIEXEC=${MPIEXEC:-/usr/local/bin/mpiexec}

cd /home/${USER}/${PROJECT}
mpic++ -O3 -std=c++17 -fopenmp -march=native -I. -Ihnswlib main.cc -o ${EXE}

NODES=$(cat "$PBS_NODEFILE" | sort | uniq)
NODE_COUNT=$(printf "%s\n" "$NODES" | wc -l | tr -d ' ')
SLOT_COUNT=$(wc -l < "$PBS_NODEFILE" | tr -d ' ')
PPN_ACTUAL=$((SLOT_COUNT / NODE_COUNT))
case "$CSV" in
    /*) RUN_CSV="$CSV" ;;
    *) RUN_CSV="/home/${USER}/${CSV}" ;;
esac
mkdir -p "$(dirname "$RUN_CSV")"

for node in $NODES; do
    scp "master_ubss1:/home/${USER}/${PROJECT}/${EXE}" "${node}:/home/${USER}/${EXE}" 1>&2
    scp -r "master_ubss1:/home/${USER}/${PROJECT}/files" "${node}:/home/${USER}/" 1>&2 || true
    scp -r "master_ubss1:/home/${USER}/${PROJECT}/hnswlib" "${node}:/home/${USER}/" 1>&2 || true
    scp -r "master_ubss1:${ANN_DATA}" "${node}:/home/${USER}/anndata" 1>&2 || true
done

"${MPIEXEC}" -np "${NP}" -machinefile "$PBS_NODEFILE" "/home/${USER}/${EXE}" \
    --data "/home/${USER}/anndata" \
    --csv "${RUN_CSV}" \
    --method hnsw \
    --comm nonblocking \
    --thread-model openmp \
    --kernel simd \
    --threads "${THREADS}" \
    --nbase 100000 \
    --nq 1000 \
    --nlist 512 \
    --nprobe 64 \
    --ef 64 \
    --repeat 3 \
    --nodes "${NODE_COUNT}" \
    --ppn "${PPN_ACTUAL}"

scp -r "/home/${USER}/files" "master_ubss1:/home/${USER}/${PROJECT}/" 2>&1
