#!/bin/bash

#Jenny Smith
#January 12, 2017
#purpose: copy all files recursively to a new folder


#http://stackoverflow.com/questions/9622883/recursive-copy-of-specific-files-in-unix-linux


#find TARGET-20-PAPXRJ/ -type f -exec cp -t allFiles/ {} +

find $1 -type f -exec cp -t $2 {} +
