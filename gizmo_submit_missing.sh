#!/bin/bash

JOBNAME='LOOX1'                   # change for every big job you run
MAILDOM='@fredhutch.org'
MAXARRAYSIZE=0                   # set to 0 if not using slurm job arrays
MYSCRATCH="/fh/scratch/delete30/holland_e/user/hbolouri/LOO/${JOBNAME}"
#PARTITION='campus'
PARTITION='restart'
#SCRIPT='./LOO_genome_testcase.R'
SCRIPT='./LOO_genome.R'
STEPSIZE=1                       # number of consecutive loops in SCRIPT to run in the same job/node

username=$(id -nu)
listsize=$(${SCRIPT} listsize)   # calling SCRIPT without slurm as run time is only seconds

# re-run failed jobs
jobs=$(bc <<< "${listsize}/${STEPSIZE}")
for i in $(seq 1 $jobs); do
	id=$(bc <<< "${i}*${STEPSIZE}-${STEPSIZE}+1")
	if ! [[ -f "${MYSCRATCH}/${i}-D.after.RData" ]]; then
	    echo "submitting ${SCRIPT} run ${MYSCRATCH} ${STEPSIZE} ${id}"
		sbatch --job-name=${JOBNAME} \
			   --mail-type=FAIL --mail-user="${username}${MAILDOM}" --partition=${PARTITION} \
			   --output="${MYSCRATCH}/output/${JOBNAME}.out.${i}(%J)" --requeue --time=0-2 \
			   --wrap="${SCRIPT} run ${MYSCRATCH} ${STEPSIZE} ${id}"
	fi
done

# Merge results serially, pass 2 parameters to SCRIPT
echo "submitting ${SCRIPT} concat ${MYSCRATCH} ${listsize}..."
sbatch --dependency=singleton --job-name=${JOBNAME} --partition=${PARTITION} \
       --mail-type=END,FAIL --mail-user="${username}${MAILDOM}" \
       --output="${MYSCRATCH}/output/${JOBNAME}.out.concat_(%J)" --requeue --time=0-2 \
       --wrap="${SCRIPT} concat ${MYSCRATCH} ${listsize}"

echo -e "monitor output with this command:"
echo -e "tail -f ${MYSCRATCH}/output/${JOBNAME}.out.*"
