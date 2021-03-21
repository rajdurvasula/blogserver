#!/bin/bash
yum -y install git vim
git clone https://github.com/rajdurvasula/blogserver.git
cd blogserver
/opt/maven/bin/mvn -DskipTests clean package
/opt/maven/bin/mvn spring-boot:run
