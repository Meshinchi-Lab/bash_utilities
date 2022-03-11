#!/bin/bash

#Jenny Smith
#January 12, 2017
#purpose: remove all files with a particular name or pattern from all directories recusively. 
#find all files with the name in quote and remove it from all directories recusively. 

#find simplified/ -depth -name "README.txt" -type f -execdir rm "{}" \;

find $1 -depth -name "$2" -type f -execdir rm "{}" \;

