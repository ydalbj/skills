#!/bin/bash

if ! test -e "/etc/apt/sources.list.bk"
then
    cp /etc/apt/sources.list /etc/apt/sources.list.bk
fi

sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g;s/security.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list  
apt update