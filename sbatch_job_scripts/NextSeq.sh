#!/bin/bash
#
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -o  NextSeq.%j.out
#SBATCH -t 0-1
#SBATCH --mail-type=END,FAIL 
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

module load SAMtools/1.4.1-foss-2016b


#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)


#location of script
scriptDir="~/scripts/sbatch_jobs"
scriptName="NextSeq.sh"

#print/echo so that README is piped to standard out.  
printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" 

#Scratch for sorted bams 
#mkdir -p "$DELETE30/meshinchi_s/2017July_BCCA_NextSeq_Illumina_data"
scratch="$DELETE30/meshinchi_s/2017July_BCCA_NextSeq_Illumina_data"

#directory that contains the IX labeled directories. 
dir=$1

#Destination directory 
dest=$2

#Function to identify the locations of the BAMs
findpath () {
	find $1 -type f -regex "^.+\.bam$"
}

#find in the IX labeled directory the library summary file. 
mappingFiles=$( find $dir -type f -regex "^.+library.summary" )
mappingFile=$(echo "$mappingFiles" | head -1 ) #once, merged, only need one mapping file with lib and index 


#find the bams in the diretory 
filePaths=$(findpath $dir )


indices=""
for bam in $(echo "$filePaths")
do	
	file=$(basename $bam)
	prefix=$(echo $file | sed -E 's/^(.+[A-Z]{6})_with.+/\1/' )
 	index=$(echo $prefix | cut -f 3 -d "_" )
	indices="$indices $index"
	samtools sort -@ 4 -o "$scratch/${file%.bam}.srt.bam" -O BAM -T $prefix "$bam" 
done 



#Merge the sorted bam files by matching indices
indexList=$( echo $indices | tr " " "\n" | sort | uniq )
sortedFiles=$( findpath $scratch )


#For loop to merge the sorted bams
for idx in $(echo $indexList)
do
	id=$(cat "$mappingFile" | grep "$idx" | cut -f 13 | uniq ) #target barcode 
	original=$(cat "$mappingFile" | grep "$idx" | cut -f 3 | uniq) #bcca identifier 
	
	bams=$(echo "$sortedFiles" | grep "$idx" )
	bamArray=($bams)
	
	sampleName=$( basename "$(echo ${bamArray[1]})" )
	outfile=$(echo $sampleName | sed -E "s/^.+(_with.+)/$id\_merged\1/") 
	
	samtools merge "$dest/$outfile" ${bamArray[1]} ${bamArray[2]} ${bamArray[3]} ${bamArray[4]} 	
	printf "$timeStamp\tbam\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$sampleName\t$original\t$id\t$outfile\n" 				
done
 

#wait


