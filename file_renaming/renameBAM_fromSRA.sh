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

#move to original files directory
cd $dir1


#rename all bam files and copy the summary files to the destination.
for file in $(ls -1 *.gz)
do
	if [[ "$file" =~ ^.+\.bam ]]
	then
		lib=$(echo $file  | sed -E "s/(^IX[0-9]+)_.+\..+/\1/")
		index=$( echo $file | sed -E 's/^IX.+_([A-Z]+)\..+/\1/') #pull out the sequence read index/barcode
		id=$(grep "$index" $lib*.summary | cut -f 12 -d '	' | tr -d '[:space:]') #grep the target barcode using the index from the library.summary file
		name=$(echo $file  |  sed -E "s/(^IX[0-9]+)_.+_([A-Z]+\..+)/$id-\1_\2/") #new file name
		lib_index=$(echo $file  |  sed -E "s/(^IX[0-9]+)_.+_([A-Z]+)\..+/\1_\2/") #library and index of current file
		SRR=$( echo $lib*.summary)

		if [ ! -e "$dir2/$name" ] #only copy files that do not already exist
		then
			printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$runtable\t$file\t$lib_index\t$id\t$name\n" >> $masterCopy
			printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$runtable\t$file\t$lib_index\t$id\t$name\n" >> $dir2/README.txt
			cp "$file" $dir2/"$name"  #copy the file to the new file name and destination.
		else
			printf "$timeStamp\tbam\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$runtable\t$file\t$lib_index\t$id\t$name\n" >> $duplicates
		fi

	fi
done
