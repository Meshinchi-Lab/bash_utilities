#!/bin/bash
#Author: Dan Tenenbaum & J. Smith


full_url=$1


IFS='/' read -ra SEGS <<< "$full_url"

samp=${SEGS[5]}
file=$(echo ${SEGS[6]} | sed -E 's/\?.+//')
name=$samp\_$file


curl -o $name "$full_url"
