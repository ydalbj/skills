## 快捷键

### Shell快捷键

[参考资料1](https://linuxtoy.org/archives/bash-shortcuts.html)
[参考资料2](https://www.howtogeek.com/howto/ubuntu/keyboard-shortcuts-for-bash-command-shell-for-ubuntu-debian-suse-redhat-linux-etc/)
* 进程相关

  - `Ctrl+c`:终止进程，发送SIGINT信号。

  - `Ctrl+z`:挂起进程，发送SIGTSTP信号。使用`fg process_name`可将进程返回前台。

  - `Ctrl+d`:关闭bash shell，相当于`exit`命令。

* 显示相关

  - `Ctrl+l`:清屏，相当于`clear`命令。

  - `Ctrl+s`:停止所有输出到屏幕。这在运行具有大量冗长详细输出的命令时特别有用，但您不希望使用Ctrl + C停止命令本身。在Windows系统中常与保存文件快捷键混淆。

  - `Ctrl+q`:使用Ctrl + S停止后，将输出恢复到屏幕。

* 光标移动

  - `Ctrl+a`或`Home`：移动光标至最前面
  - `Ctrl+b`或`End`：移动光标至最后面
  - `Alt+b`：左移一个单词
  - `Ctrl+b`：左移一个字符
  - `Alt+f`：右移一个单词
  - `Ctrl+f`：右移一个字符
  - `Ctrl+xx`：当前光标位置和行首或上次光标位置切换

* 删除文字

  - `Ctrl+d`或`Del`：删除当前光标所在字符
  - `Alt+d`：删除当前光标向右至单词结束
  - `Ctrl+d`：删除当前光标向左至单词开始
  - `Ctrl+h`或`Backspace`：删除光标前的字符
  - `Ctrl+w`：从光标处删除至字首
  - `Ctrl+k`：从光标处删除至命令行尾
  - `Ctrl+u`：从光标处删除至命令行首

* 修改

  - `Alt+t`：用前一个单词交换当前单词。
  - `Ctrl+t`：将光标前的最后两个字符相互交换。
  - `Ctrl+_`：撤消上次按键。您可以重复此操作以多次撤消。

* 剪切粘贴

  - `Ctrl+y`或`Ctrl+Shift+v`：粘贴

* 大小写转换

  - `Alt+u`：从光标处更改为全部大写的单词
  - `Alt+c`：大写光标下的字符,您的光标将移动到当前单词的末尾。
  - `Alt+Shift+l`：从光标处更改为全部小写的单词

* 历史输入

  - `Ctrl+p`：上一条命令，相当于上箭头
  - `Ctrl+n`：上一条命令，相当于下箭头
  - `Ctrl+r`：调用与您提供的字符匹配的最后一个命令。按此快捷键并开始键入以搜索bash历史记录以获取命令。
  - `Ctrl+o`：运行您使用Ctrl + R找到的命令。
  - `Ctrl+g`：离开历史搜索模式而不运行命令。

* emacs与vi键盘快捷键

  以上说明假设您在bash中使用默认键盘快捷键配置。默认情况下，bash使用emacs样式的密钥。

  以下命令将当前bash设置vi模式:
  ```shell
  $ set -o vi
  ```
  以下命令将当前bash恢复为默认的emacs模式：
  ```shell
  $ set -o emacs
  ```

  可将以上命令添加进`.bashrc`或`.zshrc`文件,永久设置成vi模式。

