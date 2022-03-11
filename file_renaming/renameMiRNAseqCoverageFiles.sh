#!/bin/bash


#Jenny Smith
#August 9, 2017
#purpose: rename all coverage files with the target barcode.


#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#main directory 
TARGET="/fh/fast/meshinchi_s/workingDir/TARGET"


#location of script
scriptDir="/fh/fast/meshinchi_s/workingDir/scripts"
scriptName="renameMiRNAseqCoverageFiles.sh"


#location of results 
resIso="$TARGET/AML_TARGET/RNA/miRNAseq/level3/isoform/2017July_BCCA_1031_Illumina_data"
resExpn="$TARGET/AML_TARGET/RNA/miRNAseq/level3/expression/2017July_BCCA_1031_Illumina_data"


#initial directory. this is a positional argument - must type the filepath on the command line. 
dir1="$1"



#Mapping File
mappingFile="BIOAPPS-7784_library.summary"



#move to original files directory
cd $dir1


findpath () {
	find $1 -type f -regex "^.+txt$" #coverage files end with .normalized
}



#Loop through each directory
for dir in $(ls -1)
do 	
	echo $dir
	path=$( findpath $dir ) #use find to get whole filepaths for each coverage file 
	#echo "$path"
	
	for lib in $(echo "$path")
	do
		file=$( basename $lib )
		library=$(echo $lib | sed -E 's|^.+(MX[0-9]+)_[A-Z]{6}_.+|\1|')
                index=$(echo $lib | sed -E 's|^.+MX[0-9]+_([A-Z]{6})_.+|\1|')
		#echo $file $library $index
		#echo $lib

		id=$(cat $mappingFile | grep -E "$library" | grep -E "$index" | cut -f 13 | uniq )
		name=$(echo $file | sed -E "s/(^.+)/$id\_\1/")
		#mappingFile=$( basename $mappingFile ) #keep only the filename for printing purposes. 
		#echo $id $name 
		
		if [[ "$file" =~ isoforms ]]
		then 
			finaldest=$resIso
		elif [[ "$file" =~ mirnas ]]
		then
			finaldest=$resExpn
                fi

		#echo $finaldest

		#create a README with input and output of files. 
		if [ ! -e $finaldest/README.txt ]
		then
			touch $finaldest/README.txt
			printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $finaldest/README.txt
		fi
		
		#copy and rename the files to the final destination directory
		if [ ! -e "$finaldest/$name" ]
		then
			printf "$timeStamp\tmRNAseq\t$dir1\t$finaldest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tmRNAseq\t$dir1\t$finaldest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $finaldest/README.txt				
			cp "$lib" $finaldest/"$name"  #copy the summary files as is to the TARGET destination directory
		else
			printf "$timeStamp\tmRNAseq\t$dir1\t$finaldest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$libID\t$id\t$name\n" >> $duplicates			
		fi

	done
done


