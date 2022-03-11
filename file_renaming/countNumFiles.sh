#!/bin/bash


#list all directories and then  list the files+directories inside and count them. 
for dir in $(ls -1); do if [ -d $dir ]; then numFiles=$(ls -1 $dir | wc -l); echo $dir $numFiles; fi; done

#need to add code to make it list the directories as directories and files as files 




