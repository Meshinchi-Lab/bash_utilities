#!/bin/bash
#Author: Dan Tenenbaum


full_url=$1


IFS='/' read -ra SEGS <<< "$full_url"
for i in "${SEGS[@]}"; do
    :
done


IFS='?' read -ra SEGS2 <<< "$i"
for j in "${SEGS2[@]}"; do
    :
done

name=${SEGS2[0]}


curl -o $name "$full_url"
