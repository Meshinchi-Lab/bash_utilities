#!/bin/bash


#Jenny Smith
#January 12, 2017
#purpose: rename all files with GS# to the TARGET barcode in TARGET_31Jan2013 directory


#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="${PWD}"
scriptName="$0"

#directory with the maf files. positional argument - must type the filepath on the command line. 
dir1="$1"

#directory with the reference mapping files
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt"
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/target_aml_cgi_germLineSummary_Target_Dec2014_mappingFile.txt"
mappingFile="N/A"

#destination directory to copy the files. Positional argument - must type the filepath on the command line. 
dir2="$2"


# #move all files and subdirectories out of the EXP dir. 
# mv EXP/* .
# rmdir EXP

# #create a list of the targetBarcodes from the directory names.
#must do this inside each individual (total 4) directories. could be improved. 
# for dir in $(ls -1); do if [ -d $dir ]; then echo $dir ; fi; done >> TARGET_31Jan2013/targetBarcodes.txt

# #create a directory for the simplified dir structure
# #mkdir /fh/fast/meshinchi_s/workingDir/originals/all_downloads_NotInOtherDirs/TARGET_31Jan2013/simplified
# mkdir $dir/simplified

#create directories with each of the barcodes as a name.  
#for dir in $(cat targetBarcodes.txt); do mkdir simplified/$dir; done


# #Must copy and move the original files to a simplified directory structure. There are too many subdirectories to go through each individually. 
# #copyAllFiles.sh is a script to recusively copy files without maintaining thier directory structure. 
#REPEAT THIS CODE FOR EACH PATIENT 
# for dir in $(ls -1); do if [ -d $dir ]; then dest=$(echo $dir); /fh/fast/meshinchi_s/workingDir/scripts/copyAllFiles.sh $dir ../simplified/$dest; fi; done



#create a README with input and output of files. 
if [ ! -e $dir2/README.txt ]
then
	touch $dir2/README.txt
	printf "Date\tFile_Type\tOriginal_Dir\tDestination_Dir\tScript_Dir\tScript_Name\tMapping_File\tOriginal_Filename\tOriginal_ID\tTarget_ID\tNew_Filename\n" >> $dir2/README.txt
fi

#cd into the directory with the simplified structure.
#cd /fh/fast/meshinchi_s/workingDir/originals/all_downloads_NotInOtherDirs/TARGET_31Jan2013/simplified
cd $dir1 

#rename all files inside the directories the directory's name (target barcode)
for barcode in $(cat ../targetBarcodes.txt)
do 
	cd $dir1/$barcode 
	echo $barcode
	
	for file in $(ls -1)
	do 
		#origFile=$(echo $file)
		
		if [[ "$file" =~ ^[a-zA-Z]+[-_]GS.+\.[a-z]{3,4} ]]
		then
			gs=$( echo $file | sed -E 's/^[a-zA-Z]+[-_](GS[0-9]+.+-.{2}).+/\1/')
			id=$(echo $barcode)
			name=$(echo $file |  sed -E "s/(^[a-zA-Z]+)[-_]GS[0-9]+.+-.{2}(.+)/$id\_\1\2/" )
			echo $file $gs $id $name
			
			if [ ! -e $dir1/"$name" ]
			then
				printf "$timeStamp\tfile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$gs\t$id\t$name\n" >> $masterCopy				
				printf "$timeStamp\tfile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$gs\t$id\t$name\n" >> $dir2/README.txt
				#cp "$file" $dir1/"$name"  #copy the file to the new file name and destination. 
			else
				duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
				#printf "$timeStamp\tfile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
			fi 
		
		else
			gs="N/A"
			id=$(echo $barcode)
			name=$(echo $file | sed -E "s/(^[a-z]+.+)/$id\_\1/")
			echo $file $gs $id $name
			
			if [ ! -e $dir1/"$name" ]
			then
				printf "$timeStamp\tfile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$gs\t$id\t$name\n" >> $masterCopy				
				printf "$timeStamp\tfile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$gs\t$id\t$name\n" >> $dir2/README.txt
				#cp "$file" $dir1/"$name" 
			else
				duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
				#printf "$timeStamp\tfile\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
			fi
		fi
	done
done




















# #Make Directories for new data types
# mkdir ../mobileElements
# mkdir REPORTS
# mkdir LIB
# mkdir SUMMARY

# #move the renamed files to thier appropriate location in the TARGET directory
# mv cnv* /fh/fast/meshinchi_s/workingDir/TARGET/DNA/WGS_TCS/copyNumberVariants
# mv *Cnv* /fh/fast/meshinchi_s/workingDir/TARGET/DNA/WGS_TCS/copyNumberVariants
# mv *depthOfCoverage* /fh/fast/meshinchi_s/workingDir/TARGET/DNA/WGS_TCS/copyNumberVariants
# mv *mobile* ../mobileElements/
# mv *Circos* ../circosPlots/
# mv *circos* ../circosPlots/
# mv *Junction* ../structuralVariants/
# mv *Sv* ../structuralVariants/
# mv *mobile* ../mobileElements/
# mv *lib* LIB/
# mv *summary* SUMMARY/
# mv *Summary* SUMMARY/


# #remove some unnessary files
# rm *version
# rm *externalSam*


# #update the README reports for the files
# cat README.txt | grep -E "*Cnv*" >> ../copyNumberVariants/README.txt
# cat README.txt | grep -E "*depthOfCoverage*" >> ../copyNumberVariants/README.txt











