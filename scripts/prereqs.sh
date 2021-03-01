#!/bin/bash
MYSQL_ROOT_PASSWORD="l55Wl06g121my7870g3z9092"
MYSQL_APPUSER_PASSWORD="ek470oJ05dj057465137lh00"
cat <<EOT > /etc/profile.d/locale.sh
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
EOT
# overwrite invalid repo entries
cat scripts/azure_yum_repo.txt > /etc/yum.repos.d/rh-cloud.repo
yum clean all
yum -y install java-1.8.0-openjdk-devel maven
yum install -y mariadb-server mariadb
systemctl start mariadb
# set root password
mysqladmin -u root password "${MYSQL_ROOT_PASSWORD}"
systemctl restart mariadb
# secure mysql
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "update mysql.user set Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') where User='root'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.user where User='root' and Host not in ('localhost','127.0.0.1','::1')"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.user where User=''"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "delete from mysql.db where Db='test' or Db='test\_%'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "flush privileges"
# create blog_db and user
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "create database blog_db"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "create user 'appuser'@localhost identified by '${MYSQL_APPUSER_PASSWORD}'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "grant all privileges on blog_db.* to 'appuser'@localhost"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "grant all privileges on blog_db.* to 'appuser'@'%' identified by '${MYSQL_APPUSER_PASSWORD}'"
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "flush privileges"

