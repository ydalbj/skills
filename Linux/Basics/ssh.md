##### SSH免密码登录

  1. 客户端执行：生成秘钥和公钥文件  `ssh-keygen -t rsa`
  2. 客户端执行：复制公钥至SSH服务器~/.ssh/authorized_keys文件 `ssh-copy-id user@server` (需要输入密码)

##### 免输入公钥密码（Enter passphrase for key '/Users/m/.ssh/id_rsa':）

  ```shell
    eval `ssh-agent`
    ssh-add -k ~/.ssh/id_rsa
  ```
