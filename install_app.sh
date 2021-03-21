#!/bin/bash
yum -y install git vim
git clone https://github.com/rajdurvasula/blogserver.git
cd blogserver
mvn -DskipTests clean package
mvn spring-boot:run
