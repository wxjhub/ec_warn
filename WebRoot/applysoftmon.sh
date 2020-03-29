#!/bin/bash
ps -ef|grep eftp |grep -v grep |awk '{print $10}' > /app/applysoftmon.txt