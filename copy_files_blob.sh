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
/usr/bin/azcopy copy $1 $2
