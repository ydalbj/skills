## 推荐用户设置

### 准备

* Fira Code需要先安装，参考 [Fira Code](https://github.com/ydalbj/skills/blob/master/Tools/Editors/VSCode/font.md)
* VS Code sync 同步设置及扩展
    > 注： "sync.gist": "1dfe38eeee48e0439e61a764c25b4dab"
* PHP CS安装 TODO
* WSL安装 TODO

### 设置
```json
{
    "sync.gist": "1dfe38eeee48e0439e61a764c25b4dab",
    "phpcs.standard": "PSR2",
    "vim.disableAnnoyingNeovimMessage": true,
    "window.zoomLevel": 1,
    "editor.wordWrap": "on",
    "[vue]": {
        "editor.tabSize": 2
    },
    "[css]": {
        "editor.tabSize": 2
    },
    "[javascript]": {
        "editor.tabSize": 2
    },
    "[yaml]" : {
        "editor.tabSize": 2
    },
    "files.associations": { ".blade.php": "html", ".tpl": "html" },
    "git.ignoreMissingGitWarning": true,
    "window.menuBarVisibility": "default",
    "php-cs-fixer.executablePath": "${extensionPath}\\php-cs-fixer.phar",
    "php-cs-fixer.lastDownload": 1542621155118,
    "terminal.integrated.shell.windows": "C:\\WINDOWS\\System32\\bash.exe",
    "editor.fontFamily": "'Fira Code'",
    "editor.fontLigatures": true,
    "editor.fontWeight": "400"
}
```

### 扩展

##### setting sync

  在第一次上传数据时，会基于token生成一个gist-id，注意这不是同一个东西。

  配置文件可以修改token；或者第一次Shift + Alt + u时会要求你填token； 
  Windows：C:\Users\用户名\AppData\Roaming\Code\User\syncLocalSettings.json 
  Linux：~/.config/Code/User/syncLocalSettings.json

  然后 Shift + Alt + d ，开始同步数据；

  如果token无效，要在github上重新生成，先在原平台修改并生成新的gist-id，再到新平台做上述操作。 
  https://gist.github.com/用户名/token值或gist-id值 可以查看相关数据

