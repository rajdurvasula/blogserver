#!/bin/bash
# Arguments:
# 1. Azure Blob Storage Service URL
#/usr/bin/azcopy login --identity
#export AZCOPY_AUTO_LOGIN_TYPE=MSI
#/usr/bin/azcopy copy /var/log/blogserver.log $1
#
# Arguments:
# 1. file path
# 2. Blob Storage Service URL (including SAS Token)
if [ ! -f /usr/bin/azcopy ]; then
  curl -L -o azcopy_linux_amd64_10.10.0.tar.gz https://aka.ms/downloadazcopy-v10-linux
  tar xzf azcopy_linux_amd64_10.10.0.tar.gz
  chmod +x azcopy
  cp azcopy /usr/bin/
fi
/usr/bin/azcopy copy $1 $2
