# Linux bash默认配置

修改`.zshrc`或`.bashrc`添加配置

* 设置vi-style bash

  `set -o vi`

* 设置快捷命令复制ssh-key
  `alias cpssh = "xclip -sel clip < ~/.ssh/id_rsa.pub"`

  ```
  set -o vi
  alias cpssh = "xclip -sel clip < ~/.ssh/id_rsa.pub"
  ```

* ssh-host免密码登录

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

