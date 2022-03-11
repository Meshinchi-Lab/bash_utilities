#!/bin/bash


#Jenny Smith
#December 28, 2018
#purpose: rename all SRA BAM/Fastqs

#create documentation of the copied files with Desination for records.
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="${PWD}"
scriptName="$0"


#initial directory. this is a positional argument - must type the filepath on the command line.
dir1="$1"

#Destination directory for renamed files.
dir2="$2"

#directory with the reference mapping file.
#Must be the runtable downloaded from run selector tool on dbGaP
runtable="$3"
# /fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/analysis/2018.12.13_seq2HLA/SraRunTable_HighDepth.txt

#move to original files directory
cd $dir1


#rename all bam files and copy the summary files to the destination.
for file in $(ls -1 *.gz)
do

		lib=$(echo $file  | sed -E "s/(SRR.+[0-9])_.+/\1/")
		id=$(grep -E "$lib" $runtable | cut -f 25 -d '	' ) #grep the target barcode using the index from the library.summary file
		name=${file/pass_/pass_r}
		name=${id}_${name%.fastq.gz}.fq.gz

		echo $name
		# create a README with input and output of files.
		if [ ! -e $dir2/README.txt ]
		then
			printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" > $dir2/README.txt
		fi

		if [ ! -e "$dir2/$name" ] #only copy files that do not already exist
		then
			printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$runtable\t$file\t$lib_index\t$id\t$name\n" >> $masterCopy
			printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$runtable\t$file\t$lib_index\t$id\t$name\n" >> $dir2/README.txt
			mv "$file" $dir2/"$name"  #copy the file to the new file name and destination.
		else
			printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$runtable\t$file\t$lib_index\t$id\t$name\n" >> $duplicates
		fi

done
