## 快捷键

### Shell快捷键

[参考资料](https://www.howtogeek.com/howto/ubuntu/keyboard-shortcuts-for-bash-command-shell-for-ubuntu-debian-suse-redhat-linux-etc/)

* 进程相关

  - `Ctrl+C`:终止进程，发送SIGINT信号。

  - `Ctrl+Z`:挂起进程，发送SIGTSTP信号。使用`fg process_name`可将进程返回前台。

  - `Ctrl+D`:关闭bash shell，相当于`exit`命令。

* 显示相关

  - `Ctrl+L`:清屏，相当于`clear`命令。

  - `Ctrl+S`:停止所有输出到屏幕。这在运行具有大量冗长详细输出的命令时特别有用，但您不希望使用Ctrl + C停止命令本身。在Windows系统中常与保存文件快捷键混淆。

  - `Ctrl+Q`:使用Ctrl + S停止后，将输出恢复到屏幕。
