#!/bin/sh

# install Vim
echo "----------install Vim----------"
sudo apt install vim -y
echo "----------Vim installed----------"

# install Git
echo "----------install Git----------"
sudo apt install git -y
git config --global user.name liuhui
git config --global user.email liuhuidut@sina.com
git config --global core.editor vim
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.unstage "reset HEAD"
git config --global alias.last "log -l"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
echo "----------Git installed----------"
