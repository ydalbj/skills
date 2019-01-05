#!/bin/sh
# MySQL安装脚本

mysql_apt_config_url=https://repo.mysql.com//mysql-apt-config_0.8.11-1_all.deb

source /etc/os-release

# 检查ubuntu codename环境变量是否存在
if [ -z $UBUNTU_CODENAME ];
then
  echo -e "please use `source xxx.sh` execute the script"
  exit
fi

if ! test -e mysql_apt.deb
then
  wget $mysql_apt_config_url --output-document mysql_apt.deb
fi
sudo dpkg -i mysql_apt.deb
sudo apt-get update
sudo apt-get install mysql-server
rm mysql_apt.deb
