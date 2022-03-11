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
#Aug 8, 2018
#purpose: rename all counts files with the target barcode.


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
scriptDir="~/scripts/bash/scripts"
scriptName="renameRNAseqCounts_DS.AML.sh"


#initial directory. this must be CHANGED every time this script is updated.
dir1="/fh/fast/meshinchi_s/SR/ngs/illumina/rries/180725_SN367_1237_AHKHJTBCX2/analysis/STAR2/counts"


#move to original files directory
cd $dir1

#Destination directory for renamed files. This is the second positional argument.
dest="$1"


#print/echo so that README is piped to standard out.
printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" > $dest/README.txt


#find in the IX labeled directory the library summary file.
mappingFile="/home/jlsmith3/reference_mapping-files/DS_AML_AMKL_samples_submitted_to_genomics_core_Aug2018.csv"


#For loop to copy and rename the counts files
for f in $( ls *.hts)
do
		samp=$(echo $f | sed -E 's/_STAR2_hg38.hts//' | tr "_" "-" )
		id=$(cat "$mappingFile" | grep "$samp" | cut -f 2 -d "," | uniq)
		name=$(echo $f | sed -E "s/(^.+)(_STAR.+)/\1\_$id\2/")

		if [ ! -e "$dest/$name" ]
	   	then
	   		printf "$timeStamp\tbam\t"$dir1/$dir"\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$original\t$id\t$name\n" >> $dest/README.txt
	   		cp "$f" $dest/"$name"  #copy the renamed files as is to the TARGET destination directory
	   	else
	   		printf "$timeStamp\tDUPLICATE\t"$dir1/$dir"\t$dest\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$original\t$id\t$name\n" >> $dest/Duplicates.txt
	 	fi
done
