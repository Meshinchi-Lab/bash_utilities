#!/bin/bash

#use the find command (a perl script) to  comeplete depth first search (DFS) with the 
#option -depth for all files with a space in the name. 
#the option execdir will execute the rename command and  the shell pattern pattern convention
#will change the whitespace to an underscore. 

#http://stackoverflow.com/questions/2709458/bash-script-to-replace-spaces-in-file-names

find $1 -depth 1 -name "* *" -execdir rename 's/ /_/g' "{}" \;



