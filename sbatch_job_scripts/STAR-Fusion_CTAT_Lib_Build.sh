#!/bin/bash
#SBATCH --partition=campus-new
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --output=lib_build_%j.out
#SBATCH --error=lib_build_%j.err
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
################################


#Jenny Smith
# March 14, 2021


#exit script if any commands return an error
set -eou pipefail

#Define directories and scripts
#Note: downloaded the dfamscan.pl script from dfam (https://dfam.org/help/tools) and copied into /home/jlsmith3/perl5/bin for STAR to be able to find it in my PATH
STAR_FUSION_HOME="/app/software/STAR-Fusion/1.9.1-foss-2020b-Perl-5.32.0"
SCRATCH="/fh/scratch/delete90/meshinchi_s"


#Load libraries and executables
module purge
ml SAMtools/1.9-foss-2018b #gcc 7.3.0
ml HMMER/3.2.1-foss-2018b #gcc 7.3.0
ml BLAST+/2.8.1-foss-2018b #gcc 7.3.0
#ml BLAST+/2.8.1-foss-2018b #gcc 7.3.0     NOTE: BLAST+/2.10.1-gompi-2020a --> depends on gcc 9.3.0  which is incompatible with HMMER
ml STAR-Fusion/1.9.1-foss-2020b-Perl-5.32.0 #gcc 10.2.0,  STAR-Fusion version: 1.9.1


#Deine files
GENOME=$1 #path to fasta file
GTF=$2 #/path/to/gtf_file
DFAM=$3 #/path/to/Dfam.hmm or "mouse" or "human"
PFAM=${4:-current} #/path/to/Pfam-A.hmm
OUT_DIR="$SCRATCH/jlsmith3/CSU_Canine_AML/genome_refs"


## For targets other than human or mouse:
$STAR_FUSION_HOME/ctat-genome-lib-builder/prep_genome_lib.pl \
                       --genome_fa $GENOME \
                       --gtf $GTF \
                       --pfam_db $PFAM \
                       --dfam_db $DFAM
                       --output_dir $OUT_DIR
                       --CPU 4

# STAR-Fusion --genome_lib_dir /path/to/your/CTAT_resource_lib \
#             --left_fq reads_1.fq \
#             --right_fq reads_2.fq \
#             --output_dir star_fusion_outdir
