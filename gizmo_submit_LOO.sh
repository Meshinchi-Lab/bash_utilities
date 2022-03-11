#!/bin/bash

JOBNAME='LOOX1'                   # change for every big job you run
MAILDOM='@fredhutch.org'
MAXARRAYSIZE=1000                   # set to 0 if not using slurm job arrays
MYSCRATCH="/fh/scratch/delete30/holland_e/user/hbolouri/LOO/${JOBNAME}"
#PARTITION='campus'
PARTITION='restart'
#SCRIPT='./LOO_genome_testcase.R'
SCRIPT='./LOO_genome.R'
STEPSIZE=4                       # number of consecutive loops in SCRIPT to run in the same job/node

username=$(id -nu)
listsize=$(${SCRIPT} listsize)   # calling SCRIPT without slurm as run time is only seconds
#listsize="3000"

mkdir -p "${MYSCRATCH}/output"

# Preparing input data serially, pass 2 parameters to SCRIPT
echo "submitting ${SCRIPT} prepare ${MYSCRATCH}..."
sbatch --dependency=singleton --job-name=${JOBNAME} --partition=${PARTITION} \
       --mail-type=FAIL --mail-user="${username}{MAILDOM}" \
       --output="${MYSCRATCH}/output/${JOBNAME}.out.prepare_(%J)" --requeue --time=0-2 \
       --wrap="${SCRIPT} prepare ${MYSCRATCH}"

depend=$(squeue --format="%A" -h -u ${username} -n ${JOBNAME} | head -n1)

# Running multiple jobs (array or standard), pass 3 parameters to each SCRIPT
if [[ $MAXARRAYSIZE -gt 1 ]]; then
    # running array jobs
    jobs=$(bc <<< "($listsize/$MAXARRAYSIZE)+1")
    arrid=0
    arrupper=$MAXARRAYSIZE
    for i in $(seq 1 $jobs); do
        if [[ $i -eq $jobs ]]; then
            arrupper=$(bc <<< "${listsize}-${arrid}")
        fi
        echo "submitting ${SCRIPT} run ${MYSCRATCH} ${STEPSIZE} ${arrid} dependent on ${depend}..."
        sbatch --array=1-${arrupper}:${STEPSIZE} --dependency=afterok:${depend} --job-name=${JOBNAME} \
               --partition=${PARTITION} --mail-type=FAIL --mail-user="${username}${MAILDOM}" \
               --output="${MYSCRATCH}/output/${JOBNAME}.out.${arrid}_%a_%A(%J)" --requeue --time=0-1 \
               --wrap="${SCRIPT} run ${MYSCRATCH} ${STEPSIZE} ${arrid}"
        arrid=$(bc <<< "${arrid}+${MAXARRAYSIZE}")
        sleep 1
    done
else
    # running standard jobs, limit the number of pending jobs to 300
    jobs=$(bc <<< "${listsize}/${STEPSIZE}")
    c=0
    for i in $(seq 1 $jobs); do
        echo "submitting ${SCRIPT} run ${MYSCRATCH} ${STEPSIZE} ${id} dependent on ${depend}..."
        id=$(bc <<< "${i}*${STEPSIZE}-${STEPSIZE}+1")
        sbatch --dependency=afterok:${depend} --job-name=${JOBNAME} \
               --mail-type=FAIL --mail-user="${username}${MAILDOM}" --partition=${PARTITION} \
               --output="${MYSCRATCH}/output/${JOBNAME}.out.${i}(%J)" --requeue --time=0-2 \
               --wrap="${SCRIPT} run ${MYSCRATCH} ${STEPSIZE} ${id}"
        ((c+=1))
        if [[ $c -gt 100 ]]; then
            # check for pending jobs 
            echo -e "wait for pending jobs to finish..."
            c=0 
            wait=1
            while [[ $wait -eq 1 ]]; do
                pending=$(squeue --state PD --format="%A" -h -u ${username} -n ${JOBNAME} | wc -l | bc)
                if [[ $pending -lt 300 ]]; then
                    wait=0
                fi
                sleep 1
            done
        fi
    done
fi

# Merge results serially, pass 2 parameters to SCRIPT
echo "submitting ${SCRIPT} concat ${MYSCRATCH} ${listsize}..."
sbatch --dependency=singleton --job-name=${JOBNAME} --partition=${PARTITION} \
       --mail-type=END,FAIL --mail-user="${username}${MAILDOM}" \
       --output="${MYSCRATCH}/output/${JOBNAME}.out.concat_(%J)" --requeue --time=0-2 \
       --wrap="${SCRIPT} concat ${MYSCRATCH} ${listsize}"

echo -e "monitor output with this command:"
echo -e "tail -f ${MYSCRATCH}/output/${JOBNAME}.out.*"
