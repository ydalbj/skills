##### homestead的使用

*　laravel/homestead vagrant box 本地安装

  > `vagrant box add laravel/homestead`国内下载box文件速度慢

  > 由于国内众所周知的网络原因，我们不得不考虑先下载好你需要的box再来添加

  > 不建议采用迅雷离线下载，据说会导致下载的文件损坏！(添加时解压偶尔会失败)

  - 创建`homestead.json`文件,填入一下内容

    ```json
    {
        "name": "laravel/homestead",
        "versions": [{
            "version": "6.4.0",
            "providers": [{
                "name": "virtualbox",
                "url": "~/homestead/homestead.box"
            }]
        }]
    }
    ```
    
    - 修改最新homestead.box版本号
    - 修改url所在文件夹路径

  - 添加laravel/homestead box
    ```shell
    $ vagrant box add homestead.json
    ```
