# Linux bash默认配置


##### 设置vi-mode

修改`.zshrc`或`.bashrc`添加配置

* 设置vi-style bash

  `set -o vi`

* 设置快捷命令复制ssh-key

  `alias cpssh = "xclip -sel clip < ~/.ssh/id_rsa.pub"`


附 .zshrc 推荐配置
```
# bash可用
set -o vi
alias cpssh = "xclip -sel clip < ~/.ssh/id_rsa.pub"

# 仅限zsh
# 设置zsh显示vi-mode
function zle-line-init zle-keymap-select {
  RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
  RPS2=$RPS1
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
```

在Bash和任何其他使用GNU Readline的工具中使用vi模式，例如MySQL命令行。修改/etc/inputrc 或 ~/.inputrc

```
set editing-mode vi
set show-mode-in-prompt on
```

##### ssh-host免密码登录

  > 强烈不推荐使用免密码登录，因为极可能泄露密码。推荐使用ssh秘钥登录。如果安全性要求不那么敏感，可用此方法作为临时解决方案。

  首先指定HOST，编辑`~/.ssh/config`。可用`ssh myhost`命令连接ssh服务器。
  ```
  Host myhost
  HostName localhost
  User root
  Port 22
  ```

  然后，在`.zshrc`或`.bashrc`，设置密码环境变量，设置命令别名。
  ```
  export PS=your-password
  alias ssh58cmd="sshpass -p $PS ssh 58cmd"
  ```

##### 命令别名
  配置 `.zshrc`或`.bashrc`
  ```
  alias ..='cd ..'
  alias ...='cd ..; cd ..'
  alias ll='ls -alh'
  alias mkcd='foo(){mkdir -p "$1"; cd "$1"}; foo '
  alias c='clear'
  alias install='sudo apt get install'
  alias update='sudo apt get update; sudo apt upgrade'
  alias ga.='git add .'
  alias gam='git commit --amend'
  alias gcm='git commit -m'
  alias gst='git status'
  alias gdf='git diff'
  alias gps='git push'
  alias gpl='git pull'
  alias gtl='git tag -l'
  alias gta='git tag -a'
  alias gpst='git push && git push --tags'
  alias cist='composer install'
  alias cupd='composer update'
  ```
