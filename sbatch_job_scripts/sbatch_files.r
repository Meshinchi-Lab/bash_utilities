#Jenny Smith
#Original Author: Sonali Arora

#Sept 7, 2017 

#Purpose: create batch scripts for bulk processing of BAM files. 



Samples = paste0("Sample", 1:100)

lapply(Samples, function(s) {
  
  z1="#!/bin/bash"
  z2="#SBATCH -N1 -n4 -t 1-12 --mail-type=END --mail-user=sarora@fhcrc.org"
  z3 = "resultDirectory=/home/jlsmith3/count_job"
  z4="bamDir=$resultDirectory/bamfiles"
  z5= paste0("sampleName=", s)
  z6="gtfFile=/shared/biodata/ngs/Reference/iGenomes/Homo_sapiens/UCSC/hg19/Annotation/Archives/archive-2015-07-17-14-32-32/Genes/genes.gtf"
  z7 ="countDir=$resultDirectory/count_result"
  z8="module load python2"
  z9 ="module load samtools"
  z10="samtools view ${bamDir}/${sampleName}.bam | htseq-count -s no -q -i gene_id - ${gtfFile} > ${countDir}/${sampleName}.HTSeqCts.txt"
  z= c(z1, z2, z3, z4, z5, z6, z7, z8, z9, z10) 
  write.table(z, paste0(s,"_count.sh"), sep="\t", quote=FALSE, col.names=FALSE, row.names=FALSE)
})

#and finally queue them from R itself. 
q1 = list.files(pattern=".sh")
sapply(q1, function(x)  system(paste0("sbatch  ", x)) )
