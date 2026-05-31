#!/bin/sh
#PBS -N ann_mpi
#PBS -e files/results/qsub_mpi.e
#PBS -o files/results/qsub_mpi.o
#PBS -l nodes=1:ppn=8

set -eu

MASTER=${MASTER:-master_ubss1}
PROJECT_DIR=${PROJECT_DIR:-/home/${USER}/Parallel-programming-NKU/ann}
EXE=main
NP=${NP:-2}
THREADS=${THREADS:-4}
ANN_DATA=${ANN_DATA:-/home/${USER}/anndata}
CSV=${CSV:-files/results/mpi_best_run_cluster.csv}
MPIEXEC=${MPIEXEC:-/usr/local/bin/mpiexec}
MPICXX=${MPICXX:-/usr/local/bin/mpic++}
PERF=${PERF:-0}
PERF_OUT=${PERF_OUT:-files/results/mpi_perf_arm_best.txt}
JOB_ID_SAFE=$(printf "%s" "${PBS_JOBID:-manual}" | tr '.:' '__')
WORK_ROOT=${WORK_ROOT:-/home/${USER}/ann_mpi_work_${JOB_ID_SAFE}}
PROJECT_BASENAME=$(basename "$PROJECT_DIR")
RUN_DIR="$WORK_ROOT/$PROJECT_BASENAME"
LOCAL_RUN_DIR="/home/${USER}/ann_mpi_run_${JOB_ID_SAFE}"
LOCAL_DATA="/home/${USER}/anndata"

mkdir -p "$WORK_ROOT"
if [ ! -d "$RUN_DIR" ]; then
    scp -r "${MASTER}:${PROJECT_DIR}" "$WORK_ROOT/" 1>&2
fi
cd "$RUN_DIR"
"${MPICXX}" -O3 -std=c++17 -fopenmp -march=native -I. -Ihnswlib main.cc -o ${EXE}

NODES=$(cat "$PBS_NODEFILE" | sort | uniq)
NODE_COUNT=$(printf "%s\n" "$NODES" | wc -l | tr -d ' ')
SLOT_COUNT=$(wc -l < "$PBS_NODEFILE" | tr -d ' ')
PPN_ACTUAL=$((SLOT_COUNT / NODE_COUNT))
case "$CSV" in
    /*) RUN_CSV="$CSV" ;;
    *) RUN_CSV="${PROJECT_DIR}/${CSV}" ;;
esac
RUN_CSV_DIR=$(dirname "$RUN_CSV")
ssh "$MASTER" "mkdir -p '$RUN_CSV_DIR'" 1>&2
case "$PERF_OUT" in
    /*) RUN_PERF_OUT="$PERF_OUT" ;;
    *) RUN_PERF_OUT="${PROJECT_DIR}/${PERF_OUT}" ;;
esac
RUN_PERF_DIR=$(dirname "$RUN_PERF_OUT")
ssh "$MASTER" "mkdir -p '$RUN_PERF_DIR'" 1>&2

for node in $NODES; do
    ssh "$node" "mkdir -p '$LOCAL_RUN_DIR' '$LOCAL_DATA'" 1>&2
    scp "${RUN_DIR}/${EXE}" "${node}:${LOCAL_RUN_DIR}/${EXE}" 1>&2
    for data_file in DEEP100K.base.100k.fbin DEEP100K.query.fbin DEEP100K.gt.query.100k.top100.bin; do
        if ! ssh "$node" "test -f '$LOCAL_DATA/$data_file'" 1>&2; then
            scp "${MASTER}:${ANN_DATA}/${data_file}" "${node}:${LOCAL_DATA}/" 1>&2
        fi
    done
done

LOCAL_CSV="${LOCAL_RUN_DIR}/result.csv"
RUN_CMD="${MPIEXEC} -np ${NP} -machinefile ${PBS_NODEFILE} ${LOCAL_RUN_DIR}/${EXE} --data ${LOCAL_DATA} --csv ${LOCAL_CSV} --method hnsw --comm nonblocking --thread-model openmp --kernel simd --threads ${THREADS} --nbase 100000 --nq 1000 --nlist 512 --nprobe 64 --ef 64 --repeat 3 --nodes ${NODE_COUNT} --ppn ${PPN_ACTUAL}"
echo "RUN_CMD=$RUN_CMD" 1>&2

if [ "$PERF" = "1" ] && command -v perf >/dev/null 2>&1; then
    LOCAL_PERF_OUT="${LOCAL_RUN_DIR}/perf.txt"
    set +e
    perf stat -e cycles,instructions,cache-references,cache-misses \
        -o "$LOCAL_PERF_OUT" \
        sh -c "$RUN_CMD"
    PERF_RC=$?
    set -e
    if [ "$PERF_RC" -ne 0 ]; then
        {
            echo "perf stat failed with exit code $PERF_RC on $(hostname)."
            echo "A normal best-run CSV is generated below for completeness."
        } >> "$LOCAL_PERF_OUT"
        if [ ! -f "$LOCAL_CSV" ]; then
            sh -c "$RUN_CMD"
        fi
    fi
    scp "$LOCAL_PERF_OUT" "${MASTER}:${RUN_PERF_OUT}" 1>&2
else
    sh -c "$RUN_CMD"
    if [ "$PERF" = "1" ]; then
        echo "perf not found on compute node $(hostname)" > "${LOCAL_RUN_DIR}/perf.txt"
        scp "${LOCAL_RUN_DIR}/perf.txt" "${MASTER}:${RUN_PERF_OUT}" 1>&2
    fi
fi

scp "${LOCAL_CSV}" "${MASTER}:${RUN_CSV}" 1>&2
