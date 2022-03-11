#!/bin/bash
#SBATCH --partition=campus
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -o agfusion.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

set -e
set -x

#Load the module
ml Python/3.6.5-foss-2016b-fh3

#TARGET AML Directory
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"

#Output directory
# outdir="$TARGET/AML_TARGET/RNA/mRNAseq/analysis/2018.02.07_NCI_C.Nguyen_FusionPipeline/agfusion_ensembl.74"
outdir="/home/jlsmith3/RNA_seq_Analysis/2018.03.21_CBF-GLIS_DEGs_Comprehensive/"

#Location of Fusion file list
# fusions="$TARGET/AML_TARGET/RNA/mRNAseq/analysis/2018.02.07_NCI_C.Nguyen_FusionPipeline/TARGET_AML_1031_Starfusion_inTopHapFmt_ForAGFusion.txt"
fusions="/home/jlsmith3/RNA_seq_Analysis/2018.03.21_CBF-GLIS_DEGs_Comprehensive/TARGET_AML_1031_CBFGLIS_Starfusion_inTopHapFormat_ForAGFusion.txt"


#Location of Genome Libraries
genome="$TARGET/Reference_Data/GRCh37/agfusion/agfusion.homo_sapiens.74.db"


agfusion batch \
  -f $fusions \
  -a  tophatfusion \
  -o $outdir/agfusion_star_v1.2 \
  -db $genome 2> agfusion_v1.2_Ensembl.74.stderr


agfusion batch \
    -f $fusions \
    -a  tophatfusion \
    -o $outdir/agfusion_star_noncanon_v1.2 \
    -db $genome \
    -nc 2> agfusion_noncanon_v1.2_Ensembl.74.stderr


#Single Example
# agfusion annotate \
#   --gene5prime CBFA2T3 \
#   --gene3prime GLIS2 \
#   --junction5prime 88945678  \
#   --junction3prime  4384802 \
#   -db  agfusion.homo_sapiens.75.db \
#   -o CBFA2T3.GLIS2_allTx \
#   --noncanonical
