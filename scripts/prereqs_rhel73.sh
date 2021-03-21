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
yum install git java-1.8.0-openjdk-devel -y
# Install Maven 3.1.0
wget https://www-eu.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar xzf apache-maven-3.6.3-bin -C /opt
ln -s /opt/apache-maven-3.6.3 /opt/maven
cat <<_EOF_ > /etc/profile.d/maven.sh
export M2_HOME=/opt/maven
export PATH=$PATH:$M2_HOME/bin
_EOF_
echo "source /etc/profile.d/maven.sh" >> /etc/bashrc
yum install mariadb-server mariadb -y
systemctl start mariadb
# secure mysql
mysql -u root <<_EOF_
update mysql.user set Password=PASSWORD('${MYSQL_ROOT_PASSWORD}') where User='root';
delete from mysql.user where User='root' and Host not in ('localhost','127.0.0.1','::1');
delete from mysql.user where User='';
drop database test;
flush privileges;
_EOF_
#delete from mysql.db where Db='test' or Db='test\_%';
# create blog_db and user
mysql -u root -p${MYSQL_ROOT_PASSWORD} <<_EOF_
create database blog_db;
create user 'appuser'@'localhost' identified by '${MYSQL_APPUSER_PASSWORD}';
grant all privileges on blog_db.* to 'appuser'@'localhost';
grant all privileges on blog_db.* to 'appuser'@'%' identified by '${MYSQL_APPUSER_PASSWORD}';
flush privileges;
_EOF_

