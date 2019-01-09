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
  exit
fi

if test $is_docker
then
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    ${UBUNTU_CODENAME} \
    stable"
fi
sudo apt-get update
sudo apt-get install docker-ce -y

# 安装docker-compose
echo "dont forget to change version of docker-compose and docker-machine"
sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

curl -L https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine  && \
    chmod +x /tmp/docker-machine && \
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine


# 默认情况下，docker 命令会使用 Unix socket 与 Docker 引擎通讯。
# 而只有 root 用户和 docker 组的用户才可以访问 Docker 引擎的 Unix socket。
# 出于安全考虑，一般 Linux 系统上不会直接使用 root 用户。因此，更好地做法是将
# 需要使用 docker 的用户加入 docker 用户组。

sudo groupadd docker
sudo usermod -aG docker $USER

if ! test -e /etc/docker/daemon.json
then
sudo bash -c 'cat << EOF > /etc/docker/daemon.json
{
"registry-mirrors": [
  "https://registry.docker-cn.com"
]
}
EOF'
fi
