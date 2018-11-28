#!/bin/sh

name="liuhui"
email="liuhuidut@sina.com"

sudo apt update

# install Vim
echo "----------install Vim----------"
sudo apt install vim -y
echo "----------Vim installed----------"

# install Git
echo "----------install Git----------"
sudo apt install git -y
git config --global user.name ${name}
git config --global user.email ${email}
git config --global core.editor vim
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.unstage "reset HEAD"
git config --global alias.last "log -l"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
echo "----------Git installed----------"


# install Zsh
echo "----------install Git----------"
sudo apt install zsh -y
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "----------Git installed----------"

# install f.lux
echo "----------install f.lux----------"
sudo add-apt-repository ppa:nathan-renniewaldock/flux
sudo apt update
sudo apt install fluxgui -y
echo "----------f.lux installed----------"

