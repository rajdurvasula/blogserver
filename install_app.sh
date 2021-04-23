#!/bin/bash
#if [ $# -ne 2 ]; then
#  echo "Usage ./install_app.sh PROXY_HOST PROXY_PORT"
#  exit 0
#fi
WORK_DIR=/opt/blogserver
if [ $# -eq 2 ]; then
  PROXY_HOST=$1
  PROXY_PORT=$2
  sed -i -e "s~PROXY_HOST~$PROXY_HOST~g" settings.xml
  sed -i -e "s~PROXY_PORT~$PROXY_PORT~g" settings.xml
  if [ ! -d ~/.m2 ]; then
    mkdir -pv ~/.m2
  fi
  cp settings.xml ~/.m2/
fi
cd $WORK_DIR
sed -i -e "s~WORK_DIR~$WORK_DIR~g" blogserver.service
cp blogserver.service /etc/systemd/system/
/opt/maven/bin/mvn clean package -DskipTests 
systemctl daemon-reload
systemctl start blogserver
systemctl enable blogserver
