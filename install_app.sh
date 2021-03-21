#!/bin/bash
yum -y install git vim
git clone https://github.com/rajdurvasula/blogserver.git
cd blogserver
/opt/maven/bin/mvn clean package -DskipTests 
/opt/maven/bin/mvn spring-boot:run
