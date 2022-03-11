#!/bin/bash 

#Jenny Smith 
#Purpose: create the github repos for local code directories

REPO_DIR=$1
REPO_NAME=$(basename $1)

cd $REPO_DIR
#NOTE `--initial-branch` requires git version >= 2.28
#though my git config init.defaultbranch=main was set - so thats weird. 
git init --initial-branch="main"
printf ".Rproj.user\n.Rhistory\n.Rdata\n.httr-oauth\n.DS_Store" > .gitignore
printf "# Analysis Directory \n### for $REPO_NAME\nAuthor: Jenny Leopoldina Smith<br>\nORCID: [0000-0003-0402-2779](https://orcid.org/0000-0003-0402-2779)\n<br>" > README.md
git add . && git commit -m "initial commit"
gh repo create "Meshinchi-Lab/$REPO_NAME" --public --source=. --push