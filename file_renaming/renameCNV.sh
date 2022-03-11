#!/bin/bash


#Jenny Smith
#January 4, 2017
#Purpose: rename  cnv plots produced by Complete Genomics (GCI) for the TARGET AML project. 



#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="${PWD}"
scriptName="$0"

#directory with the CNV plots
dir1="$1" 

#directory with the reference mapping files
mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt"

#destination directory to copy the files
dir2="$2"


#change to the directory with the input files
cd  $dir1

#create a README with input and output of files. 
if [ ! -e $dir2/README.txt ]
then
	touch $dir2/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt
fi


#Iterate through all the cnvs with file extention .tsv  in the specified directory. 
for cnv in $(ls -1 *.tsv)			
do
	gs=$( echo $cnv | sed -E 's/somaticCnv[a-zA-Z]+-(GS[0-9]+.{10}).tsv/\1/') #variable to pull out the gs# from the original file name. 
	usi=$( echo $cnv |  sed -E 's/somaticCnv[a-zA-Z]+-([A-Z]+_210.{10}).tsv/\1/')

	if grep -q "$gs" $mappingFile
	then
		id=$( grep "$gs" $mappingFile | cut -f 4 -d '	') #pull out the  targetID (feild 4) and the gs# (feild 6) into a variable.
		name=$( echo $cnv | sed -E "s/(somaticCnv[a-zA-Z]+)-GS[0-9]+.{10}(.tsv)/$id-\1\2/") #regular expression to create new file name. 
		echo $gs $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$gs\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$gs\t$id\t$name\n" >> $dir2/README.txt
			cp "$cnv" $dir2/"$name"  #copy the file to the new file name.
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
		
	elif grep -q "$usi" $mappingFile
	then
		id=$( grep "$usi" $mappingFile | cut -f 4 -d '	')
		name=$(echo $cnv | sed -E "s/(somaticCnv[a-zA-Z]+)-[A-Z]+_210.{10}(.tsv)/$id-\1\2/")
		echo $usi $id $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$usi\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$usi\t$id\t$name\n" >> $dir2/README.txt
			cp $cnv $dir2/"$name"
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$usi\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	
	
	elif [[ "$cnv" =~ ^.+NormalVs.+ ]] ##TEST THIS
	then 
		name=$( echo $cnv |  sed -E 's/^([a-zA-Z]+)_(.+)(\.tsv)/\2_\1\3/' )
		echo $name
		
		if [ ! -e $dir2/$name ]
		then
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$usi\t$id\t$name\n" >> $masterCopy				
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$usi\t$id\t$name\n" >> $dir2/README.txt
			cp $cnv $dir2/"$name"
		else
			duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
			printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$usi\t$id\t$name\t$duplicateLocation\n" >> $duplicates
		fi
	
	else
		printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$N/A\t$N/A\t$file\n" >> $dir2/notMatched_CNV.txt
	fi
done



# 2017-01-30 18:44:50	cnv	/fh/fast/meshinchi_s/all_CNV_files/Oct2012_Trios	/fh/fast/meshinchi_s/workingDir/TARGET/DNA/WGS	/fh/fast/meshinchi_s/workingDir/scripts	./renameCNV.sh	/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt	somaticCnvSegmentsDiploidBeta-GS000013609-ASM-T2-N1.tsv	GS000013609-ASM-T2-N1	TARGET-20-PARUNX-09A-01D	TARGET-20-PARUNX-09A-01D-somaticCnvSegmentsDiploidBeta.tsv	/fh/fast/meshinchi_s/all_CNV_files/CNVs_14Dec2012/Dx 
# 2017-01-30 18:44:50	cnv	/fh/fast/meshinchi_s/all_CNV_files/Oct2012_Trios	/fh/fast/meshinchi_s/workingDir/TARGET/DNA/WGS	/fh/fast/meshinchi_s/workingDir/scripts	./renameCNV.sh	/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt	somaticCnvSegmentsDiploidBeta-GS000013610-ASM-T2-N1.tsv	GS000013610-ASM-T2-N1	TARGET-20-PASJGZ-09A-02D	TARGET-20-PASJGZ-09A-02D-somaticCnvSegmentsDiploidBeta.tsv	/fh/fast/meshinchi_s/all_CNV_files/CNVs_14Dec2012/Dx 



