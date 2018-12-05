#!/bin/sh

source echo.sh
is_docker=`grep 'download.docker.com' /etc/apt/sources.list.d/*.list`

sudo apt-get remove docker docker-engine docker.io -y
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
source /etc/os-release

if [ -z $UBUNTU_CODENAME ];
then
  echo -e "please use `source xxx.sh` execute the script"
else
  if test $is_docker
  then
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      ${UBUNTU_CODENAME} \
      stable"
  fi
  sudo apt-get update
  sudo apt-get install docker-ce -y
fi
