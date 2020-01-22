#!/bin/sh
# Elasticsearch 安装脚本
# 安装不同版本请替换version变量
# deprecated 废弃，用docker方式部署更好

version='6.5.2'

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${version}.deb
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${version}.deb.sha512
shasum -a 512 -c elasticsearch-${version}.deb.sha512
sudo dpkg -i elasticsearch-${version}.deb
rm elasticsearch-${version}.deb elasticsearch-${version}.deb.sha512

# https://www.elastic.co/guide/en/elasticsearch/reference/current/rpm.html
#SysV init vs systemdedit
#Elasticsearch is not started automatically after installation. How to start and stop Elasticsearch depends on whether your system uses SysV init or systemd (used by newer distributions). You can tell which is being used by running this command:

#ps -p 1
#Running Elasticsearch with SysV initedit
#Use the chkconfig command to configure Elasticsearch to start automatically when the system boots up:

#sudo chkconfig --add elasticsearch
#Elasticsearch can be started and stopped using the service command:

#sudo -i service elasticsearch start
#sudo -i service elasticsearch stop
#If Elasticsearch fails to start for any reason, it will print the reason for failure to STDOUT. Log files can be found in /var/log/elasticsearch/.

#Running Elasticsearch with systemdedit
#To configure Elasticsearch to start automatically when the system boots up, run the following commands:

#sudo /bin/systemctl daemon-reload
#sudo /bin/systemctl enable elasticsearch.service
#Elasticsearch can be started and stopped as follows:

#sudo systemctl start elasticsearch.service
#sudo systemctl stop elasticsearch.service
