#!/bin/bash

#Jenny Smith
#January 19, 2017
#purpose: compare two files with identical names to determine if they are different. 
 

#http://stackoverflow.com/questions/12736013/comparison-function-that-compares-two-text-files-in-unix

#define which files to compare
file1=$1
file2=$2

#diff command compares files line byte by byte. 
 

cmp $file1 $file2 || printf "different\t$file1\t$file2" >> dupCheck.txt

