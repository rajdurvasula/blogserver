#!/bin/bash
if [ $# -ne 2 ]; then
	echo "Usage: ./install.sh MYSQL_ROOT_PASSWORD MYSQL_APPUSER_PASSWORD"
	exit 0
fi
MYSQL_ROOT_PASSWORD=$1
MYSQL_APPUSER_PASSWORD=$2
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# overwrite invalid repo entries
echo "[rhui-microsoft-azure-rhel7] > /etc/yum.repos.d/rh-cloud.repo
echo "name=Microsoft Azure RPMs for Red Hat Enterprise Linux 7" >> /etc/yum.repos.d/rh-cloud.repo
echo "baseurl=https://rhui-1.microsoft.com/pulp/repos/microsoft-azure-rhel7" >> /etc/yum.repos.d/rh-cloud.repo
echo "https://rhui-2.microsoft.com/pulp/repos/microsoft-azure-rhel7" >> /etc/yum.repos.d/rh-cloud.repo
echo "https://rhui-3.microsoft.com/pulp/repos/microsoft-azure-rhel7" >> /etc/yum.repos.d/rh-cloud.repo 
echo "enabled=1" >> /etc/yum.repos.d/rh-cloud.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/rh-cloud.repo
echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-microsoft-azure-release" >> /etc/yum.repos.d/rh-cloud.repo
echo "sslverify=1" >> /etc/yum.repos.d/rh-cloud.repo
yum clean all
yum -y install java-1.8.0-openjdk-devel maven
yum install -y mariadb-server mariadb
systemctl start mariadb
# set root password
mysqladmin -u root password "${MYSQL_ROOT_PASSWORD}"
systemctl restart mariadb
# secure mysql
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "alter user 'root'@'localhost' identified by '${MYSQL_ROOT_PASSWORD}'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.user where User='root' and Host != 'localhost'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.user where User='root' and Host != '127.0.0.1'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.user where User='root' and Host != '::1'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.user where User=''"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.db where Db='test' or Db='test\_%'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "flush privileges"
# create blog_db and user
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "create database blog_db"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "create user 'appuser'@localhost identified by '${MYSQL_APPUSER_PASSWORD}'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "grant all privileges on blog_db.* to 'appuser'@localhost"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "grant all privileges on blog_db.* to 'appuser'@'%' identified by '${MYSQL_APPUSER_PASSWORD}'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "flush privileges"
