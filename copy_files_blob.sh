#!/bin/bash
# Arguments:
# 1. Azure Blob Storage Service URL
/usr/bin/azcopy login --identity
export AZCOPY_AUTO_LOGIN_TYPE=MSI
/usr/bin/azcopy copy /var/log/blogserver.log $1
