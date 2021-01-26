#!/bin/bash

#SBATCH --ntasks=1 
#SBATCH -J "gpu_log_test" 
#SBATCH --mem-per-cpu='10000' 
#SBATCH --time="10:00:00" 
#SBATCH --gres=gpu:1 
#SBATCH --partition=ml

LMOD_DIR=/usr/share/lmod/lmod/libexec/
LMOD_CMD=/usr/share/lmod/lmod/libexec/lmod
module () {
    eval `$LMOD_CMD sh "$@"`
}
ml () {
    eval $($LMOD_DIR/ml_cmd "$@")
}


LOGMAINDIR=~/gpu_log/logs/$(date +%Y-%m-%d-%H:%M:%S)/
LOGDIR=$LOGMAINDIR/nvidia-$(hostname)/
mkdir -p $LOGDIR
LOGPATH=$LOGDIR/gpu_usage.csv
echo $LOGPATH

ml TensorFlow

srun -n1 --gres=gpu:1 --mem-per-cpu=10000 CHANGEMEHERE &
PROC_ID=$!

while kill -0 "$PROC_ID" >/dev/null 2>&1; do
    if [[ -e $LOGPATH ]]; then
        nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --id=$CUDA_VISIBLE_DEVICES --format=csv,noheader >> $LOGPATH
    else
        nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --id=$CUDA_VISIBLE_DEVICES --format=csv >> $LOGPATH
    fi
    echo ""
    tail -n1 $LOGPATH
    sleep 1
done
