## Linux 基本命令


##### Shell命令
* ps
  - 判断系统SysV `init` or `systemd`
    ```shell
    $ ps -p -l
    ```

* `-` 减号 (dash)
    > 在 GNU 指令中，如果单独使用 - 符号，不加任何该加的文件名称时，代表\"标准输入\"的意思。这是 GNU指令的共通选项。譬如下例
    ```shell
    $ tar xpvf -
    ```
    这里的 - 符号，既代表从标准输入读取资料。

* `&` 后台工作
    > 单一个& 符号，且放在完整指令列的最后端，即表示将该指令列放入后台中工作。
    ```shell
    $ tar cvfz data.tar.gz data > /dev/null&
    ```

* tee

    > 可以从标准输入中读入信息并将其写入标准输出或文件中

    ```shell
    $ sudo echo ‘1′ > ip_forward
    bash: ip_forward: Permission denied

    # 解决方法
    $ sudo sh -c ‘echo 1 > ip_forward’

    # 或
    $ echo ‘1′ | sudo tee ip_forward
    # 或
    $ echo ‘1′ | sudo tee ip_forward | cat > /dev/null