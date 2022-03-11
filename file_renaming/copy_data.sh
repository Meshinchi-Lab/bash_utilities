#!/bin/bash


#Jenny Smith
#January 26, 2017
#Purpose: copy data files with target barcode to their destination in TARGET directory.



#create documentation of the copied files with Desination for records.
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="~/scripts/bash/scripts"
scriptName="copy_data.sh"

#directory with the original files
dir1="$1"

#directory with the reference mapping files
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/CGI_USI_file_mapping.txt"
mappingFile="NA"

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


#Copy the  miRNAseq expression/isoform.1/22/18
for file in $(ls -1 *20*) #target 20
do
  if [ ! -e $dir2/"$file" ]
  then
	 printf "$timeStamp\tmiRNAprofiling\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tNA\tNA\t$file\n" >> $dir2/README.txt #create a readme that documents the old name and new name.
	 printf "$timeStamp\tmiRNAprofiling\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tNA\tNA\t$file\n" >> $masterCopy
	 cp "$file" $dir2/$file #copy the file to the new file name.
  fi
done



###################################

#Copy the mature miRNAseq expression matrix. 7/15/2017
# for file in $(ls -1 *mimat*)
# do
# 	name=$(echo $file | sed -E 's/(^.+)/BCCA_miRNAprofiling_\1/')
# 	printf "$timeStamp\tmRNAseq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name.
# 	printf "$timeStamp\tmRNAseq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $masterCopy
# 	cp "$file" $dir2/$name #copy the file to the new file name.
# done


######### Concatenated RNAseq Files to TARGET DIRECTORY #########
#Copy the concatenated RNA-seq data files to TARGET
# for file in $(ls -1)
# do
	# name=${file/all/TARGET_AML_}
	# printf "$timeStamp\tmRNAseq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name.
	# printf "$timeStamp\tmRNAseq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $masterCopy
	# cp "$file" $dir2/$name #copy the file to the new file name.
# done
####################################


########################### CIRCOS #####################
#copy metadata from /TARGET_CIRCOS_24Dec2012/somaticCircosLegend.png
# file=$(echo $dir1/*Legend*)
# printf "$timeStamp\tcircosPlots\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $masterCopy
# printf "$timeStamp\tcircosPlots\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $dir2/README.txt
# cp $dir1/*Legend* $dir2
############################################

############## TARGET_31Jan2013 ######################
#copy the renamed files in the TARGET_31Jan2013/simplified directory to the TARGET destination dir.
# for maf in $(ls -1 *maf* )
# do

	# id=$( echo $maf | sed -E 's/^(TARGET.+)-somatic.+/\1/' )
	# gs=$( grep "$maf" $dir1/README.txt | cut -f 9 -d '	' )
	# echo $maf $id $gs

	# # if [ ! -e $dir2/$maf ]
	# # then
		# # printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$maf\n" >> $masterCopy
		# # printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$maf\n" >> $dir2/README.txt #create a readme that documents the old name and new name.
		# # cp "$maf" $dir2/"$maf"  #copy the file to the new file name.
	# # else
		# # duplicateLocation=$( grep "$maf" $dir2/README.txt | cut -f 3 -d '	' )
		# # printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$maf\t$duplicateLocation\n" >> $duplicates
	# # fi
# done

# for cnv in $(ls -1 | grep -i "cnv")
# do

	# id=$( echo $cnv |  sed -E 's/^(TARGET.+)-[a-zA-Z]+.+/\1/' )
	# gs=$( grep "$cnv" $dir1/README.txt | cut -f 9 -d '	' )
	# echo $cnv $id $gs

	# if [ ! -e $dir2/$cnv ]
	# then
		# printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$gs\t$id\t$cnv\n" >> $masterCopy
		# printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$gs\t$id\t$cnv\n" >> $dir2/README.txt #create a readme that documents the old name and new name.
		# cp "$cnv" $dir2/"$cnv"  #copy the file to the new file name.
	# else
		# duplicateLocation=$( grep "$maf" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tcnv\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$cnv\t$gs\t$id\t$cnv\t$duplicateLocation\n" >> $duplicates
	# fi
# done

# for juncs in $(ls -1 | grep -i "junc")
# do

	# id=$( echo $juncs |  sed -E 's/^(TARGET.+)-[a-zA-Z]+.+/\1/' )
	# gs=$( grep "$juncs" $dir1/README.txt | cut -f 9 -d '	' )
	# echo $juncs $id $gs

	# if [ ! -e $dir2/$juncs ]
	# then
		# printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$gs\t$id\t$juncs\n" >> $masterCopy
		# printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$gs\t$id\t$juncs\n" >> $dir2/README.txt #create a readme that documents the old name and new name.
		# cp "$juncs" $dir2/"$juncs"  #copy the file to the new file name.
	# else
		# duplicateLocation=$( grep "$juncs" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tjuncs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$juncs\t$gs\t$id\t$juncs\t$duplicateLocation\n" >> $duplicates
	# fi
# done
###########################################################


############ MAFs from May2013/ ###########################
# for maf in $(ls -1 *.tsv )
# do

	# id=$( echo $maf | sed -E 's/^.+_(TARGET.+)_[A-Za-z].+/\1/' )
	# gs=$( grep "$id" $mappingFile | cut -f 6 -d '	' | tr -d '[:space:]' )
	# name=$( echo $maf | sed -E 's/(^.+)_(TARGET.+)_([A-Za-z].+)/\2-\1_\3/')
	# echo $maf $id $gs

	# if [ ! -e $dir2/$name ]
	# then
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\n" >> $masterCopy
		# printf "$timeStamp\tMAF_SNVs_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\n" >> $dir2/README.txt #create a readme that documents the old name and new name.
		# cp "$maf" $dir2/"$name"  #copy the file to the new file name.
	# else
		# duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\t$gs\t$id\t$name\t$duplicateLocation\n" >> $duplicates
	# fi
# done
#################################################################


################################# MAFs from TARGET_Dec2014 ######################
#Copy MAF files - CGI
#/fh/fast/meshinchi_s/workingDir/originals/TARGET_Dec2014/CGI/MAFs
# for maf in $(ls -1 somatic*)
# do
	# id=$(echo $maf | sed -E 's/^.+_(TARGET.+D)_.+/\1/' )
	# name=$( echo $maf |  sed -E 's/^([a-zA-Z]+)_(.+)(\.maf.txt)/\2_\1\3/' )
	# name=$( echo $maf |  sed -E 's/^([a-zA-Z]+)_(.+)_([a-zA-Z]+\.tsv)/\2-\1_\3/' )
	# echo $id $name

	# if [[ ! -e "$dir2/$name" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\tN/A\t$id\t$name\n" >> $masterCopy
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\tN/A\t$id\t$name\n" >> $dir2/README.txt
		# cp "$maf" $dir2/"$name"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$name" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$maf\tN/A\t$id\t$name\t$duplicateLocation\n" >> $duplicates

	# fi
# done
#################################################################################

############### Induction Failure #######################################
#Copy induction failure RNA-seq and WGS
# for file in $(ls -1 *somatic*bed )
# do

	# id=$( echo $file | sed -E 's/^(T.+D)\..+/\1/')

	# if [[ ! -e "$dir2/$file" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $masterCopy
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\t$duplicateLocation\n" >> $duplicates

	# fi
# done

#copy these into the metadata folder.
#X:\fast\meshinchi_s\induction_failure\WGS\CN_LOH_analysis\V2_somatic_analysis
# for file in $(ls -1 *.pdf )
# do
	# id=$( echo $file | sed -E 's/^(T.+D)\..+/\1/')
	# if [[ ! -e "$dir2/$file" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $masterCopy
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\t$duplicateLocation\n" >> $duplicates

	# fi
# done

#copy the bed files into level3 beds??
# for file in $(ls -1 *.bed)
# do
	# id=$( echo $file | sed -E 's/^(T.+D)\..+/\1/')
	# if [[ ! -e "$dir2/$file" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $masterCopy
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\t$duplicateLocation\n" >> $duplicates

	# fi
# done


# for file in $(ls -1 *.vcf)
# do
	# id=$( echo $file | sed -E 's/^(T.+R)\..+/\1/')

	# if [[ ! -e "$dir2/$file" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $masterCopy
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\t$duplicateLocation\n" >> $duplicates

	# fi
# done

#####################################################


################ miRNAseq_exp_1Aug2014 ###################
#copy all isoform and miRNAseq expression data
# for file in $(ls -1 *.txt)
# do
	# id=$( echo $file | sed -E 's/^(T.+R)\..+/\1/')

	# if [[ ! -e "$dir2/$file" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tmiRNAprofiling\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $masterCopy
		# printf "$timeStamp\tmiRNAprofiling\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tmiRNAprofiling\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\t$duplicateLocation\n" >> $duplicates

	# fi
# done
##################################################################



################### RNASeq_Exp_1Aug2014 and RNASeq_MAFs_1Aug2014 ##############
# for file in $(ls -1 TARGET*)
# do
	# id=$( echo $file | sed -E 's/^(T.+R)\..+/\1/')

	# if [[ ! -e "$dir2/$file" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tmRNAseq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $masterCopy
		# printf "$timeStamp\tmRNAseq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tmRNAseq\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\t$duplicateLocation\n" >> $duplicates
	# fi
# done


#########################################################################

############## TARGET_Dec2014/DNAme #####################
# for file in $(ls -1 TARGET*)
# do
	# id=$( echo $file | sed -E 's/^(T.+D)\_.+\..+/\1/')

	# if [[ ! -e "$dir2/$file" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tDNA_methylation\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $masterCopy
		# printf "$timeStamp\tDNA_methylation\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tDNA_methylation\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\t$duplicateLocation\n" >> $duplicates
	# fi
# done

###################################################


############## TARGET_Dec2014/validation #####################
# for file in $(ls -1 TARGET*)
# do
	# id=$( echo $file | sed -E 's/^(T.+D)\_.+\..+/\1/')

	# if [[ ! -e "$dir2/$file" ]]
	# then
		# echo new $file
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $masterCopy
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# echo dup $file
		# duplicateLocation=$( grep "$file" $dir2/README.txt | cut -f 3 -d '	' )
		# printf "$timeStamp\tMAF_SNVs\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\t$id\t$file\t$duplicateLocation\n" >> $duplicates
	# fi
# done
##############################################################################


#############  TARGET_Dec2014 BCGSC_CNV_calls_13Sept2016/ BCCA.Files ####################
#Iterate through all target named files and copy into the specified directory.
#/fh/fast/meshinchi_s/workingDir/originals/TARGET_Dec2014/BCCA.files/BCGSC_CNV_calls_13Sept2016
# for file in $(ls -1 *.*)
# do
	# name=$(echo $file  |  sed -E "s/^([a-z]+_[0-9]{2})__(.+_[A-Za-z]+)(\..+)/\2_\1\3/")

	# if [[ "$file" =~ .+TARGET.+ && ! -e "$dir2/$name" ]]
	# then
		# printf "$timeStamp\tCNV\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $masterCopy
		# printf "$timeStamp\tCNV\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$name"  #copy the file to the new file name and destination.

	# elif [[ -e "$dir2/$name" ]]
	# then
		# printf "$timeStamp\tCNV\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $duplicates
	# elif [[ "$file" =~ WT1.+ && ! -e "$dir2/$file"]] ##ADD NORMALIZATION FILE? HOW TO ASSOCIATE W DATA?
	# then
		# printf "$timeStamp\tCNV\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $masterCopy
		# printf "$timeStamp\tCNV\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$name\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$name"  #copy the file to the new file name and destination.

	# fi
# done


#Copy files for the BCCA SNVs from TCS sequencing
#/fh/fast/meshinchi_s/workingDir/originals/TARGET_Dec2014/BCCA.files/Leandro_discovery
#/fh/fast/meshinchi_s/workingDir/originals/TARGET_Dec2014/BCCA.files/Leandro_validation
#note: somatic = level3, normal or tumor = level2 ?
#https://wiki.nci.nih.gov/display/TCGA/TCGA+Variant+Call+Format+%28VCF%29+1.1+Specification
# for file in $(ls -1 *.*)
# do
	# if [[ "$file" =~ ^TARGET.+ && ! -e "$dir2/$file" ]]
	# then
		# printf "$timeStamp\tMAF_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $masterCopy
		# printf "$timeStamp\tMAF_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $dir2/README.txt
		# cp "$file" $dir2/"$file"  #copy the file to the new file name and destination.

	# else
		# printf "$timeStamp\tMAF_VCF\t$dir1\t$dir2\t$scriptDir\t$scriptName\t$mappingFile\t$file\tN/A\tN/A\t$file\n" >> $duplicates

	# fi
# done

#check for redundancies in the two cohorts - none found.
#1. make list of validation cohort barcodes
#for file in $(ls -1 *.*); do if [[ "$file" =~ ^TARGET.+ ]] ; then barcode=$( echo $file | sed -E 's/^(TARGET-20-[A-Z]{6}-[0-9].{6}).+/\1/'); echo $barcode; fi; done | sort | uniq > cohort_USI.txt
#2. check list for redundancies
#for file in $(ls -1 *.*) ; do barcode=$( echo $file | sed -E 's/^(TARGET-20-[A-Z]{6}-[0-9].{6}).+/\1/'); echo $barcode; if grep "$barcode" cohort_USI.txt ; then echo $file >> Redundant_MAFs.txt; fi; done
##########################################################


#Clinical Data locations
# ./LANDSCAPE_PAPER/Validation_SNV_indels_clinical_annotated_Apr2016.xlsx
# ./LANDSCAPE_PAPER/ValidationDx_SNV_indels_clinical_annotated_Apr2016.txt
# ./LANDSCAPE_PAPER/Target_AML_ClinicalData_June2015_v1.xlsx
# ./LANDSCAPE_PAPER/Validation_SNV_indels_clinical_annotated_9Apr2016.txt
# ./LANDSCAPE_PAPER/Validation_SNV_indels_clinical_annotated_Sept2016.xlsx
# ./TARGET_Dec2014/Clinical
# ./TARGET_Dec2014/Clinical/TARGET_AML_ClinicalDataSet_20140512.txt
# ./TARGET_Dec2014/Clinical/TARGET_AML_ClinicalDataSet_20140512.xlsx
