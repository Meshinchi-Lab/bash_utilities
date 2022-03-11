#!/bin/bash

#Jenny Smith 
#Purpose: recursively find working directories in R and .Rmd analysis scripts, 
# and create a new github repository with a name matching the data analysis directory on fast drive

#exit script if any commands return an error
set -eou pipefail
DATE=$(date +%F)

#Define main input/output directories 
GITREPO_HOME="/home/jlsmith3/github_repos"
SCRIPTS_DIRS="/home/jlsmith3/scripts/RNAseq_Analysis/Analysis
/home/jlsmith3/scripts/RNAseq_Analysis/Waterfallplots_Expression_Distribution
/home/jlsmith3/scripts/RNAseq_Analysis/Concatenation
/home/jlsmith3/scripts/RNAseq_Analysis/BatchEffect
/home/jlsmith3/scripts/survival_analysis
/home/jlsmith3/scripts/nanostring_analysis
/home/jlsmith3/scripts/miRNAseq_analysis"


#Loop through each directory which contains the R scripts to be added to the repositories. 
for SCRIPTS in $(echo "$SCRIPTS_DIRS")
do 
    SCRIPT_DIR=$(basename $SCRIPTS)

    #Use find to recursively grep the working directory (output directory) for each of the  R scripts 
    file_paths=$(find $SCRIPTS -regextype posix-extended -not -regex ".+0{2,4}_.+|.+[Oo]ld.+|.+\\._[A-Za-z].+" \( -iname "*.Rmd" -o -iname "*.R" \) -exec grep -EHi "root.dir|setwd|here\\(" {} \;) 
    #remove those filepaths that were called `setwd(path)` or `setwd(out)` as those paths were called in code chuncks of Rmd files for temp work.
    #and remove those with #setwd() which were commented out, and those with SCRATCH as workingdirs which were chunks of temp work
    file_paths=$(echo "$file_paths" | grep -Eiv ".Rmd.+setwd\((path|out)|#|SCRATCH" )
    n=$(echo "$file_paths" | wc -l )
    echo "Found $n Rmd and R files."

    #Separate the R script filename and the working directory paths
    rfiles=$(echo "$file_paths" | cut -d : -f 1)
    analysis_dirs=$( echo "$file_paths" | sed -E "s/.+(root.dir|setwd|here).{0,3}(.+)$/\2/" | sed -E  "s/^.+(20[12][0-26-9]\.[0-9]{1,2}.+|0000|20[1-2][0-26-9][A-Za-z]{3,}|SequencingDataMatrix|DNAnexus)/\1/")
    clean_dirs=$(echo "$analysis_dirs" | tr -d ")" | tr -d "\"" | tr -d "\'" | tr -d $'\r' |cut -f 1 -d "," | sed -E "s/\/$//")
    echo "completed cleaning the filepaths grepped from the R scripts."

    #Create an array to hold the R script filenames and thier cleaned directory name the script will be saved at
    # https://opensource.com/article/18/5/you-dont-know-bash-intro-bash-arrays
    #https://linuxhint.com/simulate-bash-array-of-arrays/
    declare -a RFILES=( $(echo "$rfiles") )
    declare -a DIRS=( $(echo "$clean_dirs") )

    echo "Starting to copy the R files to their new directories"
    #Loop through rows of the arrays and create a directory from $clean_dirs, and make a copy of the R script file there
    for i in ${!DIRS[@]};
    do
        file="${RFILES[$i]}";
        dir="${DIRS[$i]}";
        #If there were subdirectories, use only the base analysis directory 
        if echo "$dir" | grep -Eq "\/"; 
        then

            outdir=$(dirname "$dir");
            dest=${GITREPO_HOME}/$outdir;
            
        else 
            dest=${GITREPO_HOME}/$dir;  
        fi; 
        filname=$(basename -- $(echo "$file"));
        # echo "The destintation is: $dest and the file is $filename"; 
        printf "%s\t%s\n" "$filname" "$dest" >> create_git_repos_${SCRIPT_DIR}_${DATE}.log;
        mkdir -p $dest && cp -n $file $dest/$filname;
    done
    echo "completed copying"
done