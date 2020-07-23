#!/bin/sh
# config github ssh access

email="liuhuidut@sina.com"

if ! test -e ~/.ssh/id_rsa
then
  echo "----------ssh keygen----------"
  echo "do not change the default ssh folder"

  # Generating a new SSH key
  ssh-keygen -t rsa -b 4096 -C ${email}

  # Adding your SSH key to the ssh-agent
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa

  sudo apt-get install xclip -y
  xclip -sel clip < ~/.ssh/id_rsa.pub
  echo "Copied the contents of the id_rsa.pub file to your clipboard"
  echo "You can paste it to your github account"
  cat ~/.ssh/id_rsa.pub
fi
