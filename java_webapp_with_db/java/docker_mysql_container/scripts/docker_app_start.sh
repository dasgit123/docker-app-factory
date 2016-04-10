#!/bin/sh

# set my environ now
alias ll="ls -l"
set -o vi
alias vim=vi
alias d="sudo docker"

echo "Starting Docker Container for Java-Web App"
echo ""
echo "Step 1: Starting MY-SQL Container..."
d start mysql_db

echo ""
echo "Step 2: Starting Java-Web Engine..."
d run -it -d -p 8080:8080 --name=java_db --link mysql_db:mydatabaseserver java_engine_new
#d start java_db

echo ""
echo "Waiting for 40 seconds to refresh"
sleep 40;

echo ""
echo "--------------------------------------------------------"
echo "App: http://192.168.99.100:8080/javaee6angularjsmysql/"
echo "Status: ONLINE"
echo "--------------------------------------------------------"
