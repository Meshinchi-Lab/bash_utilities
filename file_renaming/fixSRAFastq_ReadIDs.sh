#!/bin/bash
#Jenny Smith
#1/3/18

outdir="/fh/scratch/delete90/meshinchi_s/jlsmith3/seq2HLA/fq"

for file in $(ls *.gz)
do
	f=${file%.gz}

	if [[ "$file" =~ r1 ]]
	then
		echo "r1" $f
		zcat $file | sed -E 's|\.1 |/1 |' > $outdir/$f
	else
		echo "r2" $f
		zcat $file | sed -E 's|\.2 |/2 |' > $outdir/$f
	fi

	gzip -c $outdir/$f > $outdir/${file/_pass_/_pass_fixID_}

done






# zcat TARGET-20-PAEFGT-03A-01R_SRR1286874_pass_r2.fq.gz | sed -E 's|\.2 |/2 |'  > TARGET-20-PAEFGT-03A-01R_SRR1286874_pass_r2.fq &
# gzip -c TARGET-20-PAEFGT-03A-01R_SRR1286874_pass_r1.fq > TARGET-20-PAEFGT-03A-01R_SRR1286874_pass_fixID_r1.fq.gz &
