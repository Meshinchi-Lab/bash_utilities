#!/bin/bash
set -e
BASE_BUCKET="s3://fh-pi-lastname-f/lab/user_name/project_name"

# Load the module
ml nextflow

nextflow \
    -c ~/nextflow.config \
    run \
    path-to-workflow.nf \
    --first_parameter ValueForFirstParameter \
    --second_parameter ValueForSecondParameter \
    --input_folder $BASE_BUCKET/input/ \
    --output_folder $BASE_BUCKET/output/ \
    -with-report nextflow_report.html \
    -work-dir $BASE_BUCKET/work/ \
    -resume
