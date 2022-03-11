#!/bin/bash
set -e
BASE_BUCKET="s3://fh-pi-meshinchi-s/SR"
SCRATCH="$DELETE90/Nextflow"


# Load the module
ml nextflow

#Execute the next flow workflow
nextflow -c ~/nextflow.config run \
     $SCRATCH/subset_BAM_byChr.nf \
    --sample_sheet $SCRATCH/example_bams.txt \
    --region 10 \
    --output_folder $BASE_BUCKET/subset_BAMs/ \
    -with-report nextflow_report.html \
    -work-dir $BASE_BUCKET/work/ \
    -resume
