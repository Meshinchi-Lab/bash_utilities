#!/bin/bash


#Jenny Smith
#August 4, 2017
#purpose: rename all bam files with the target barcode.


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
dest="$2"


#create a README with input and output of files. 
if [ ! -e $dest/README.txt ]
then
	touch $dest/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dest/README.txt
fi


#move to original files directory
cd $dir1

#echo ${PWD}


findpath () {
	find $1 -type f -regex "^.+\.bam$"
}

#for dir in $(ls -1)
#do 	
#	echo $dir
#	#Loop through each IX labeled directory
#	if [[ "$dir" =~ IX* ]] 
#	then
#		subdir=$(ls -1 $dir) 
#		path=$(echo $dir/$subdir) 
#
#		mappingFile=$(echo $path/*library.summary)
#		mappingFile=$(basename $mappingFile)
#
#		idmap="$(cat $path/*library.summary)" #read the ID mapping file	
#		libsdir=$( ls -1 $path | sed -E '/^.+library.summary/d') #list subdirectories w/o mapping file included
#	
#		for lib in $libsdir 
#		do
#		   id=$(echo "$idmap" | grep "$lib" | cut -f 14 | uniq )
#		   libpath=$( findpath $path/$lib )
#
#		   file=$( basename $libpath)
#		   name=$(echo $file | sed -E "s/^.+(w.+)/$id\_\1/")
#		   
#		   if [ ! -e "$dest/$name" ]
#		   then
#		   		printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$id\t$name\n" >> $masterCopy				
#		   		printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$id\t$name\n" >> $dest/README.txt				
#		   		cp "$libpath" $dest/"$name"  #copy the summary files as is to the TARGET destination directory
#		   else
#		   		printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$lib\t$id\t$name\n" >> $duplicates			
#		   fi
#		done	
#	fi
#
#	if [[ "$dir" =~ A3* ]]
#	then 
#		
#		mappingFile=$(echo ../merged_libraries.summary)
#		mappingFile=$( basename $mappingFile )
#		idmap="$(cat ../merged_libraries.summary)"
#
#		libpath=$( findpath $dir )
#		id=$(echo "$idmap" | grep "$dir" | cut -f 10 | uniq )
#
#		file=$( basename $libpath )
#		name=$(echo $file | sed -E "s/^.+(\_2\_.+)/$id\1/") 
#
#		if [ ! -e "$dest/$name" ]
#		then
#		   	printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$dir\t$id\t$name\n" >> $masterCopy				
#		   	printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$dir\t$id\t$name\n" >> $dest/README.txt				
#		   	cp "$libpath" $dest/"$name"  #copy the summary files as is to the TARGET destination directory
#		else
#		   	printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$dir\t$id\t$name\n" >> $duplicates			
#		fi
#	fi
#done


#There are four technical replicates that got flagged as duplicates
reps=(A55671
A55678
A55665
A55673)

for lib in ${reps[@]} 
do
		echo $lib
		libpath=$( findpath $dir1 | grep "$lib" )
		path=$(echo $libpath | cut -f 1-14 -d '/')
		idmap="$(cat $path/*library.summary)" #read the ID mapping file	
		#echo $path

		id=$(echo "$idmap" | grep "$lib" | cut -f 14 | uniq )
		file=$( basename $libpath )
		name=$(echo $file | sed -E "s/^.+(w.+)/$id\_Replicate_\1/") 
		#echo $id $file $name

		mappingFile=$(echo $path/*library.summary)
		mappingFile=$( basename $mappingFile )
		#echo $mappingFile
		if [ ! -e "$dest/$name" ]
		then
		   	printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$dir\t$id\t$name\n" >> $masterCopy				
		   	printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$dir\t$id\t$name\n" >> $dest/README.txt				
		   	cp "$libpath" $dest/"$name"  #copy the summary files as is to the TARGET destination directory
		else
		   	printf "$timeStamp\tmRNAseq\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$dir\t$id\t$name\n" >> $duplicates			
		fi
done





