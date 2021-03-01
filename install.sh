#!/bin/bash
PWD=`pwd`
SCRIPT_DIR=blogserver
yum -y install git
git clone https://github.com/rajdurvasula/blogserver.git
$SCRIPT_DIR/scripts/prereqs.sh
cd $SCRIPT_DIR
mvn clean package -DskipTests
mvn spring-boot:run
