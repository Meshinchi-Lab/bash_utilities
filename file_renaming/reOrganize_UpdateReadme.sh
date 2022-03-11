#!/bin/bash


#Jenny Smith
#January 19, 2017
#purpose: Move all renamed files to their appropriate level1,level2,level3 directories and update the readme. 
#BCCA analysis miRNA pipeline: https://github.com/bcgsc/mirna


#create documentation of the copied files with Desination for records. 
timeStamp=$(date +%Y-%m-%d' '%H:%M:%S)
masterCopy="/fh/fast/meshinchi_s/workingDir/scripts/MasterCopy.txt"
duplicates="/fh/fast/meshinchi_s/workingDir/scripts/duplicateFiles.txt"


#location of script
scriptDir="${PWD}"
scriptName="$0"

#initial directory. this is a positional argument - must type the filepath on the command line. 
dir1="$1"

#directory with the reference mapping files. 
#mappingFile="/fh/fast/meshinchi_s/workingDir/reference_mapping-files/TARGET_AML_SNP_Only_mapping_file.txt"
mappingFile="N/A"

#Destination directory for renamed files. 
dir2="$2"


#change directory to the destination directory
cd $dir2



# #Levels of Directories
# 1. TARGET project
# 2. Biological Macromolecule Class (DNA/RNA, etc)
# 3. Type of Sequencing (WGS, mRNAseq, etc)
# 4. Level of Data Analysis (levels 1 through 4, and metadata)
# 5. Specific Analysis Type (Copy number, fusions, isoforms, etc)
# 6. Specific contractor/instituion + Sequencing Chemistry (eg BCCA_Illumina_data) 


######CHANGE AML TARGET barcode - Dashed to under scored
#for file in $(ls -1 *som* | grep -E "^TARGET.+-[0-9]{2}D-.+"); do cp $file ${file//D-/D_}; done
#for file in $(ls -1); do  mv $file ${file//R-/R_}; done


########################## 20 Normal BAMS #####################
#move the bam summaries to metadata directory and the bam files to level1
# for file in $(ls -1 *.*) 
# do
	# if [[ "$file" =~ ^.+\.summary ]] 
	# then
		# echo summary $file
		# mkdir -p $dir2/metadata/bam/BCCA_Illumina_data
		# mv $file $dir2/metadata/bam/BCCA_Illumina_data  #copy the file to the isoform directory
		
	# elif [[ "$file" =~ ^.+\.bam ]] 
	# then
		# echo bam $file 
		# mkdir -p $dir2/level1/bam/BCCA_Illumina_data
		# mv $file $dir2/level1/bam/BCCA_Illumina_data  #copy the file to the isoform directory
	# fi
# done

# #update the readme with the correct file destination for summary files 
# sed -i -E 's|(^.+)('$dir2')(.+gsc_library.summary$)|\1\2/metadata/bam/BCCA_Illumina_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+gsc_library.summary$)|\1\2/metadata/bam/BCCA_Illumina_data	\3|g' $masterCopy

# #update the readme with the correct file destination for BCCA bam
# sed -i -E 's|(^.+)('$dir2')(.+_[A-Z]+\.bam$)|\1\2/level1/bam/BCCA_Illumina_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+_[A-Z]+\.bam$)|\1\2/level1/bam/BCCA_Illumina_data	\3|g' $masterCopy

####################################

################### CIRCOS ###################
#move the circos plots to the properly labeled data direcory 
# for file in $(ls -1 *somaticCircos*) 
# do
	# echo circos $file
	# mkdir -p $dir2/CGI_CompleteGenomicsInc_data
	# mv $file $dir2/CGI_CompleteGenomicsInc_data  
# done

#update the readme and mastercopy with the final locations of the somaticCnv files
#update the readme with the correct file destination for summary files 
# sed -i -E 's|(^.+)('$dir2')(.+somaticCircos.png$)|\1\2/CGI_CompleteGenomicsInc_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+somaticCircos.png$)|\1\2/CGI_CompleteGenomicsInc_data	\3|g' $masterCopy
###############################################


################### CNVs and TARGET_31Jan2013 #####################
#move the CNV files to the correct data level. 
# for file in $(ls -1 *somaticCnv*) 
# do
	# echo CNV $file
	# mkdir -p $dir2/level3/CNVs/CGI_CompleteGenomicsInc_data
	# mv $file $dir2/level3/CNVs/CGI_CompleteGenomicsInc_data  
# done
################################################



############# MAFs from TARGET DIR to Correct Data Level ####################
# for file in $(ls -1 TARGET*)
# do
	# echo somatic $file
	# mkdir -p $dir2/level3/SNVs/CGI_CompleteGenomicsInc_data
	# mv $file $dir2/level3/SNVs/CGI_CompleteGenomicsInc_data
# done

#update readme
# sed -i -E 's|(^.+)('$dir2')(.+somaticFiltered.+\.tsv$)|\1\2/level3/SNVs/CGI_CompleteGenomicsInc_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+somaticFiltered.+\.tsv$)|\1\2/level3/SNVs/CGI_CompleteGenomicsInc_data	\3|g' $masterCopy

# sed -i -E 's|(^.+)('$dir2')(.+somaticVcf.+\.txt$)|\1\2/level3/SNVs/CGI_CompleteGenomicsInc_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+somaticVcf.+\.txt$)|\1\2/level3/SNVs/CGI_CompleteGenomicsInc_data	\3|g' $masterCopy

# sed -i -E 's|(^.+)('$dir2')(.+NormalVs.+\.txt$)|\1\2/level3/SNVs/CGI_CompleteGenomicsInc_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+NormalVs.+\.txt$)|\1\2/level3/SNVs/CGI_CompleteGenomicsInc_data	\3|g' $masterCopy
#####################################################	


############# Juncs from TARGET DIR to Correct Data Level ####################
# for file in $(ls -1 *somatic*)
# do
	# echo somatic $file
	# mkdir -p $dir2/level3/fusion/CGI_CompleteGenomicsInc_data
	# mv $file $dir2/level3/fusion/CGI_CompleteGenomicsInc_data
# done

# for file in $(ls -1 TARGET* | grep -v "somatic" )
# do	
	# echo level2 $file 
	# mkdir -p $dir2/level2/fusion/CGI_CompleteGenomicsInc_data
	# mv $file $dir2/level2/fusion/CGI_CompleteGenomicsInc_data
# done 

#update readme
# sed -i -E 's|(^.+)('$dir2')(.+somatic.+Junctions.+\.tsv$)|\1\2/level3/fusion/CGI_CompleteGenomicsInc_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+somatic.+Junctions.+\.tsv$)|\1\2/level3/fusion/CGI_CompleteGenomicsInc_data	\3|g' $masterCopy
# sed -i -E 's|(^.+)('$dir2')(.+Junction.+\.tsv$)|\1\2/level2/fusion/CGI_CompleteGenomicsInc_data	\3|g' README_level2.txt

#####################################################	





############## miRNAv19 and miRNAv19_2 ########################

#http://askubuntu.com/questions/76785/how-to-escape-file-path-in-sed
#move the isoform/miRNA epxression data to correct directories. 
for file in $(ls -1 *.*) 
do
	if [[ "$file" = README.txt || "$file" =~ ^BCCA_.+README.+ || "$file" =~ ^.+VERSION.+ || "$file" =~ ^.+DESC.+ ]] #temporary until it can be determined as identical
	then
		echo bcca $file
		mkdir -p $dir2/metadata/BCCA_Illumina_data
		mv $file $dir2/metadata/BCCA_Illumina_data
	
	elif [[ "$file" =~ ^.+\.jpg || "$file" =~ ^.+\.csv ]] #QC graphs and library summaries
	then
		echo QC $file
		mkdir -p $dir2/metadata/BCCA_Illumina_data
		mv $file $dir2/metadata/BCCA_Illumina_data	
		
	elif [[ "$file" =~ ^TARGET.+-tcga.+iso.+ ]] #place the isoform count data into the correct directory.
	then
		echo tcga isoforms $file ###THESE ARE THE SAME AS THE .isoform.quantification.txt!! #level3 duplicates!
		mkdir -p $dir2/level3/isoform/BCCA_Illumina_data
		mv $file $dir2/level3/isoform/BCCA_Illumina_data  #copy the file to the isoform directory

		
	elif [[ "$file" =~ ^TARGET.+-.+iso.+ ]]
	then
		echo isoforms $file 
		mkdir -p $dir2/level2/isoform/BCCA_Illumina_data
		mv $file $dir2/level2/isoform/BCCA_Illumina_data  #copy the file to the isoform directory
	
	elif [[ "$file" =~  ^.+mirnas.+ ]]
	then 
		echo tcga mirnas $file ###THESE ARE THE SAME AS THE .mirna.quantification.txt!! #level3 duplicates!
		mkdir -p $dir2/level3/expression/BCCA_Illumina_data
		mv $file $dir2/level3/expression/BCCA_Illumina_data
		
	
	elif [[ "$file" =~ ^.+miRNA.+ || "$file" =~ ^.+mirna_species.+ ]]
	then
		echo miRNA level2 $file
		mkdir -p $dir2/level2/expression/BCCA_Illumina_data
		mv $file $dir2/level2/expression/BCCA_Illumina_data
		
		
	elif [[ "$file" =~ ^.+exp.+  ]] #expression matrices
	then
		echo expression matirx $file
		mkdir -p $dir2/level3/expression/BCCA_Illumina_data
		mv $file $dir2/level3/expression/BCCA_Illumina_data  #copy the file to the new file name and isoform or express destination. 
	
	
	elif [[ "$file" =~ ^.+\.report ]] #adapter report files
	then	
		echo report files  $file 
		mkdir -p $dir2/level1/bam/BCCA_Illumina_data
		mv $file $dir2/level1/bam/BCCA_Illumina_data  #copy the file to the new file name and isoform or express destination.
	
	
	elif [[ "$file" =~ ^.+\.gz ]] #bed files and wig files
	then 
		echo .gz bed files $file
		mkdir -p $dir2/level1/bed/BCCA_Illumina_data
		mv $file $dir2/level1/bed/BCCA_Illumina_data
	
	
	elif [[ "$file" =~ ^.+crossmapped.+ ]] #crossmapped file is used for miRNA expression analysis.
	then
		echo crossmapped $file
		mkdir -p $dir2/level2/expression/BCCA_Illumina_data
		mv $file $dir2/level2/expression/BCCA_Illumina_data


	else
		echo other $file
		mkdir -p $dir2/level2/repetitiveRNAs/BCCA_Illumina_data
		mv $file $dir2/level2/repetitiveRNAs/BCCA_Illumina_data
	
	fi
done
#########################################################################

# update the readme with the correct file destination. 
#first step is to grep the lines from the original readme and then use sed to update each

#DONE
# sed -i -E 's|(^.+)('$dir2')(.+tcga.+isoforms.txt$)|\1\2/level3/isoform/BCCA_Illumina_data	\3|g' README.txt  #regex to update destination directory.
# sed -i -E 's|(^.+)('$dir2')(.+tcga.+isoforms.txt$)|\1\2/level3/isoform/BCCA_Illumina_data	\3|g' $MasterCopy

#DONE
# sed -i -E 's|(^.+)('$dir2')(.+TARGET.+mirnas.+$)|\1\2/level3/expression/BCCA_Illumina_data	\3|ig' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+TARGET.+mirnas.+$)|\1\2/level3/expression/BCCA_Illumina_data	\3|ig' $MasterCopy

#DONE
# sed -i -E 's|(^.+)('$dir2')(.+-isoforms.txt$)|\1\2/level2/isoform/BCCA_Illumina_data	\3|g' README.txt  #regex to update destination directory.
# sed -i -E 's|(^.+)('$dir2')(.+-isoforms.txt$)|\1\2/level2/isoform/BCCA_Illumina_data	\3|g' $MasterCopy

#DONE
# sed -i -E 's|(^.+)('$dir2')(.+TARGET.+mirna_species.+$)|\1\2/level2/expression/BCCA_Illumina_data	\3|ig' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+TARGET.+mirna_species.+$)|\1\2/level2/expression/BCCA_Illumina_data	\3|ig' $MasterCopy

#DONE
# sed -i -E 's|(^.+)('$dir2')(.+TARGET.+miRNA.+$)|\1\2/level2/expression/BCCA_Illumina_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+TARGET.+miRNA.+$)|\1\2/level2/expression/BCCA_Illumina_data	\3|g' $MasterCopy


# sed -i -E 's|(^.+)('$dir2')(.+matrix.+$)|\1\2\/level3\/expression/BCCA_Illumina_data	\3|g' README.txt 
# sed -i -E 's|(^.+)('$dir2')(.+matrix.+$)|\1\2\/level3\/expression/BCCA_Illumina_data	\3|g' $MasterCopy

# sed -i -E 's|(^.+)('$dir2')(.+\.gz$)|\1\2/level1/bed/BCCA_Illumina_data	\3|g' README.txt
# sed -i -E 's|(^.+)('$dir2')(.+\.gz$)|\1\2/level1/bed/BCCA_Illumina_data	\3|g' $MasterCopy
###############################################################################








