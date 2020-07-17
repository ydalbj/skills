[如何在 Windows 10 中安装 WSL2 的 Linux 子系统](https://blog.walterlv.com/post/how-to-install-wsl2.html)


### 启用虚拟机平台和Linux子系统功能

以管理员权限启动 PowerShell

输入以下命令启用虚拟机平台：
```
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
```

然后输入以下命令启用 Linux 子系统功能：

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

### 安装一个 Linux 发行版
打开微软商店应用，在搜索框中输入“Linux”然后搜索,选择一个你喜欢的 Linux 发行版本然后安装：

### 启用 WSL2

下载 [wsl2更新](https://docs.microsoft.com/en-us/windows/wsl/wsl2-kernel)


默认启用wsl2
```
wsl --set-default-version 2
```

使用 `wsl -l` 可以列出当前系统上已经安装的 Linux 子系统（分发版）名称
设置分发版
```
wsl --set-default <wsl -l列出的分发版名称>
```

