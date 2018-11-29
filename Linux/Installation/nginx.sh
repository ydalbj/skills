#!/bin/sh

if ! [ -x "$(command -v nginx)" ]; then
  # install Vim
  echo "----------install Vim----------"
  sudo apt install nginx -y
  echo "----------Vim installed----------"
  sudo ufw allow 'Nginx HTTP'
fi
