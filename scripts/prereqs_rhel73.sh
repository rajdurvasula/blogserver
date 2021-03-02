#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: ./prereqs_rhel73.sh MYSQL_ROOT_PASSWORD MYSQL_APPUSER_PASSWORD"
  exit 0
fi
MYSQL_ROOT_PASSWORD=$1
MYSQL_APPUSER_PASSWORD=$2
echo "export LC_ALL=\"en_US.UTF-8\"" > /etc/profile.d/locale.sh
echo "export LC_CTYPE=\"en_US.UTF-8\"" >> /etc/profile.d/locale.sh
# As per Azure documentation
yum --disablerepo='*' remove 'rhui-azure-rhel7' -y
yum --config='https://rhelimage.blob.core.windows.net/repositories/rhui-microsoft-azure-rhel7-eus.config' install 'rhui-azure-rhel7-eus' -y
echo $(. /etc/os-release && echo $VERSION_ID) > /etc/yum/vars/releasever
yum install git java-1.8.0-openjdk-devel maven -y
yum install mariadb-server mariadb -y
systemctl start mariadb
# secure mysql
mysql -u root -p"" -e "update mysql.user set Password=PASSWORD\('${MYSQL_ROOT_PASSWORD}'\) where User='root'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.user where User='root' and Host not in \('localhost','127.0.0.1','::1'\)"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.user where User=''"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.db where Db='test' or Db='test\_%'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "flush privileges"
# create blog_db and user
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "create database blog_db"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "create user 'appuser'@'localhost' identified by '${MYSQL_APPUSER_PASSWORD}'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "grant all privileges on blog_db.* to 'appuser'@'localhost'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "grant all privileges on blog_db.* to 'appuser'@'%' identified by '${MYSQL_APPUSER_PASSWORD}'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "flush privileges"

