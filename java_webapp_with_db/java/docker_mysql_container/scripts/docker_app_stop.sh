#!/bin/sh

# set my environ now
alias ll="ls -l"
set -o vi
alias vim=vi
alias d="sudo docker"

echo "Safely closing the Docker Container for Java-Web App"
echo ""
echo "Step 1: Stopping Java-Web Engine..."
d stop java_db

echo ""
echo "Step 2: Stopping MY-SQL Container..."
d stop mysql_db

echo ""
echo "Waiting for 30 seconds to refresh"
sleep 30;

echo ""
echo "--------------------------------------------------------"
echo "App: http://192.168.99.100:8080/javaee6angularjsmysql/"
echo "Status: OFFLINE";
echo "--------------------------------------------------------"
