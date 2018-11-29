#!/bin/sh
# install php

if ! [ -x "$(command -v php)" ]; then
  # 解决有可能存在的语言问题
  sudo apt install -y language-pack-en-base
  sudo locale-gen en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8

  # 添加php的仓库
  sudo apt-get install -y software-properties-common

  # 中途按下回车,添加源
  sudo add-apt-repository ppa:ondrej/php
  sudo apt-get update
  sudo apt-get install -y php7.2 php7.2-mysql php7.2-curl php7.2-xml php7.2-json php7.2-gd php7.2-mbstring

  # install pecl
  sudo apt-get install php-dev php-pear autoconf automake libtool  -y

  # pecl install mcrypt
  sudo apt-get -y install gcc make autoconf libc-dev pkg-config
  sudo apt-get -y install libmcrypt-dev
  sudo pecl install mcrypt-1.0.1

  sudo bash -c "echo extension=/usr/lib/php/20170718/mcrypt.so > /etc/php/7.2/cli/conf.d/20-mcrypt.ini"
fi
