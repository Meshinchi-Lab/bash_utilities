#!/usr/bin/env nextflow

// Define the input BAM files in a sample sheet and genomic location
bams_ch = Channel.fromPath(file(params.sample_sheet).readLines())
region = params.region

// define the output directory . does this need to exist already?
params.output_folder = "./subsets/"

//Define Samtools command line processes to run on each bam file in the sample sheet.
process bam_by_region {

	publishDir "$params.output_folder/"

	// use biocontainers repo on quay.io
	//container "quay.io/biocontainers/samtools:1.9--h46bd0b3_0"
	container "biocontainers/samtools:v1.9-4-deb_cv1"
	cpus 4
	memory "30 GB"

	// if process fails, retry running it
	errorStrategy "retry"

	// declare the input type (file) and its variable name (bam)
	input:
	each file(bam) from bams_ch

	//define output files to save to the output_folder
	output:
	file "*${region}.ba*"

	"""
	set -eou pipefail;

	samtools index -b -@ 4 $bam;
	samtools view -h -b  $bam "$region" | samtools sort -@ 4 -o "${bam.baseName}_chr${region}.bam" -O BAM -T ${bam.baseName} -;
	samtools index -b "${bam.baseName}_chr${region}.bam"
	"""

}
