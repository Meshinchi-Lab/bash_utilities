#!/bin/bash
#
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -t 0-1
#SBATCH --mail-type=END
#SBATCH --mail-user=jlsmith3@fredhutch.org
source /app/Lmod/lmod/lmod/init/bash
################################

#Jenny Smith
#August 4, 2017
#purpose: rename all bam files with the target barcode.


#EXAMPLE TO RUN THIS SCRIPT
#sed -i -E 's|(dir1)=.+|\1\"${newfilepath}\"|' renameRNAseqRibodepl_BAM_update.sh
#dest="/path/to/destination/folder"
#cd /fh/fast/path/to/IX/library/directories
#for dir in $(ls -1)
#do
#	o="${dir}.out"
#	e="${dir}.stderr"
#	sbatch -o $o -e $e renameRNAseqRibodepl_BAM_update.sh $dir $dest
#done


#create documentation of the copied files with Desination for records.
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)


#location of script
scriptDir="/fh/fast/meshinchi_s/workingDir/scripts"
scriptName="renameRNAseqRibodepl_BAM_update.sh"


#initial directory. this must be CHANGED every time this script is updated.
dir1="/fh/fast/meshinchi_s/workingDir/TARGET/AML_TARGET/RNA/mRNAseq/BCCA_Data_Downloads/2017July_BCCA_SOW.GSC1483__Illumina_Data"

#move to original files directory
cd $dir1

#Destination directory for renamed files. This is the second positional argument.
dest="$2"

#the IX labeled directoy is the first positional argument
dir=$1


#print/echo so that README is piped to standard out.
printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n"


#function to find the  full path for each bam file.
findpath () {
	find $1 -type f -regex "^.+\.bam$"
}


#find in the IX labeled directory the library summary file.
mappingFile=$( find $dir -type f -regex "^.+library.summary" )

len=$( echo ${mappingFile[*]} | wc -w )	#mappingFile is an array.using array notation.



#loop through the mapping files.
for mf in ${mappingFile[@]}
do
	idmap="$( cat $mf )" #read the ID mapping file
	subdir=$( echo $mf | cut -f 1,2 -d '/') #find only bams in the dir and one subdirectory at a time
	libpath=$( findpath $subdir ) #use find to get whole filepaths for each bam 

	for lib in $libpath
	do
		file=$( basename $lib )
		index=$(echo $file | sed -E "s/^.+_([A-Z]{6})_.+/\1/")

		id=$(echo "$idmap" | grep "$index" | cut -f 13 | uniq )
		original=$(echo "$idmap" | grep "$index" | cut -f 3 | uniq)

		name=$(echo $file | sed -E "s/^.+(w.+)/$id\_\1/")
		mappingFile=$( basename $mf ) #keep only the filename for printing purposes.

		if [ ! -e "$dest/$name" ]
	   	then
	   		printf "$timeStamp\tbam\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$original\t$id\t$name\n"
	   		cp "$lib" $dest/"$name"  #copy the renamed files as is to the TARGET destination directory
	   	else
	   		printf "$timeStamp\tDUPLICATE\t$dir1\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$original\t$id\t$name\n"
	   	fi
	done
done
