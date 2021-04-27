#!/bin/bash
# Arguments:
# 1. Azure Blob Storage Service URL
/usr/bin/azcopy login --identity
/usr/bin/azcopy copy /var/log/blogserver.log $1
