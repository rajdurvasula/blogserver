#!/bin/bash
PWD=`pwd`
SCRIPT_DIR=blogserver
cd $SCRIPT_DIR
mvn clean package -DskipTests
mvn spring-boot:run
