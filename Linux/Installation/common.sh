#!/bin/sh

name="liuhui"
email="liuhuidut@sina.com"

sudo apt update
# vim-gnome 支持系统剪贴板
sudo apt install vim vim-gnome axel proxychains -y

if ! [ -x "$(command -v git)" ]; then
  # install Git
  echo "----------install Git----------"
  sudo apt install git -y
  echo "----------Git installed----------"
fi

  git config --global user.name ${name}
  git config --global user.email ${email}
  git config --global credential.helper store
  git config --global core.safecrlf true
  git config --global core.autocrlf false
  git config --global core.editor vim
  git config --global alias.st status
  git config --global alias.co checkout
  git config --global alias.ci commit
  git config --global alias.br branch
  git config --global alias.unstage "reset HEAD"
  git config --global alias.last "log -l"
  git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
  git config --global pull.rebase true

if ! [ -x "$(command -v zsh)" ]; then
  # install Zsh
  echo "----------install Zsh----------"
  sudo apt install zsh -y
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo "----------Zsh installed----------"
fi

if ! [ -x "$(command -v fluxgui)" ]; then
  # install f.lux
  echo "----------install f.lux----------"
  sudo add-apt-repository ppa:nathan-renniewaldock/flux
  sudo apt update
  sudo apt install fluxgui -y
  echo "----------f.lux installed----------"
fi

if ! [ -x "$(command -v composer)" ]; then
  # install composer
  echo "----------install composer----------"
  sudo apt install composer -y
  composer config -g repo.packagist composer https://packagist.laravel-china.org
  composer global require "squizlabs/php_codesniffer=*"
  composer global require friendsofphp/php-cs-fixer
  echo "----------composer installed----------"
fi

if ! [ -x "$(command -v axel)" ]; then
  # install axel (command line download accelerator)
  echo "----------install composer----------"
  sudo apt install axel -y
  echo "----------composer installed----------"
fi

if ! [ -x "$(command -v gnome-tweak-tool)" ]; then
  # install gnome-tweak-tool
  echo "----------install gnome-tweak-tool----------"
  sudo apt install gnome-tweak-tool
  echo "----------install gnome-tweak-tool----------"
fi

if ! test -d ~/.vim_runtime
then
  echo "----------install awesome vimrc----------"
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  sh ~/.vim_runtime/install_awesome_vimrc.sh
  echo "----------awesome vimrc installed----------"
fi

# sudo nopassword
if ! test -e "/etc/sudoers.d/mysudo"
then
  echo "%sudo  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/mysudo | cat > /dev/null
fi

# 下载工具
if ! [ -x "$(command -v uget)"]; then
  sudo add-apt-repository ppa:plushuang-tw/uget-stable
  sudo apt-get update
  sudo apt-get install uget aria2
fi

# 截图工具
if ! [ -x "$(command -v flameshot)"]; then
  sudo apt-get install flameshot
fi
