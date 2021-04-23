#!/bin/bash
WORK_DIR=/opt/blogserver
mkdir -pv $WORK_DIR
echo "export LC_ALL=\"en_US.UTF-8\"" > /etc/environment
echo "export LC_CTYPE=\"en_US.UTF-8\"" >> /etc/environment
# As per Azure documentation
yum --disablerepo='*' remove 'rhui-azure-rhel7' -y
yum --config='https://rhelimage.blob.core.windows.net/repositories/rhui-microsoft-azure-rhel7-eus.config' install 'rhui-azure-rhel7-eus' -y
echo $(. /etc/os-release && echo $VERSION_ID) > /etc/yum/vars/releasever
yum install git java-1.8.0-openjdk-devel -y
# Install Maven 3.1.0
wget https://www-eu.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar xzf apache-maven-3.6.3-bin.tar.gz -C /opt
ln -s /opt/apache-maven-3.6.3 /opt/maven
cat <<_EOF_ > /etc/profile.d/maven.sh
export M2_HOME=/opt/maven
export PATH=$PATH:/opt/maven/bin
_EOF_
echo "source /etc/profile.d/maven.sh" >> /etc/bashrc
git clone https://github.com/rajdurvasula/blogserver.git $WORK_DIR
