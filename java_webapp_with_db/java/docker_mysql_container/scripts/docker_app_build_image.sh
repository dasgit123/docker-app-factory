#!/bin/sh

# set my environ now
alias ll="ls -l"
set -o vi
alias vim=vi
alias d="sudo docker"

echo "Building my Docker Image for my app"
echo ""
echo "Step 1: Check for existing images..."
echo "--------------------------------------------------------"
d images | grep -s "java_engine_new"
if [ $? = 0 ]; then
	echo "Deleting an existing image & its container references..."
	d stop java_db
	d rm java_db
	d rmi java_engine_new
else
	echo "No image found before..."
fi
echo "--------------------------------------------------------"

echo "Step 2: Building my app image..."
echo "--------------------------------------------------------"

cd .. 
d build --tag=java_engine_new .
echo ""
