#!/bin/bash
if [ $# -ne 2 ]; then
  echo "usage: ./install_rhel73.sh MYSQL_ROOT_PASSWORD MYSQL_APPUSER_PASSWORD [PROXY_HOST] [PROXY_PORT]"
  exit 0
fi
WORK_DIR=/opt/blogserver
mkdir -pv $WORK_DIR
./prereqs_rhel73.sh
./setup_db_schema.sh $1 $2
if [ $# -eq 4 ]; then
  ./install_app.sh $3 $4
fi
