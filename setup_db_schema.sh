#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: ./setup_db.sh MYSQL_ROOT_PASSWORD MYSQL_APPUSER_PASSWORD"
  exit 0
fi
MYSQL_ROOT_PASSWORD=$1
MYSQL_APPUSER_PASSWORD=$2
# install java sdk
yum -y install java-1.8.0-openjdk-devel
# download maven
wget https://mirrors.estointernet.in/apache/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz
tar xzf apache-maven-3.8.1-bin.tar.gz -C /opt/
mv /opt/apache-maven-3.8.1 /opt/maven
wait $!
# install mariadb
yum install -y mariadb-server mariadb
wait $!
systemctl start mariadb

# secure mysql
mysql -u root <<_EOF_
update mysql.user set Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') where User='root';
delete from mysql.user where User='root' and Host not in ('localhost','127.0.0.1','::1');
delete from mysql.user where User='';
flush privileges;
_EOF_
# create blog_db and user
mysql -u root -p${MYSQL_ROOT_PASSWORD} <<_EOF_
create database blog_db;
create user 'appuser'@'localhost' identified by '${MYSQL_APPUSER_PASSWORD}';
grant all privileges on blog_db.* to 'appuser'@'localhost';
flush privileges;
_EOF_

# update application.poperties
sed -i -e "s~APPUSER_PASSWORD~$MYSQL_APPUSER_PASSWORD~g" src/main/resources/application.properties
