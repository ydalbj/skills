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
  gist是存储设置的，token用于访问gist，验证用户身份用，可能会过期，需要去github重新生成token，
  然后在vscode配置文件(syncLocalSettings.json)更新token值。

  配置文件可以修改token；或者第一次Shift + Alt + u时会要求你填token； 
  Windows：C:\Users\用户名\AppData\Roaming\Code\User\syncLocalSettings.json 
  Linux：~/.config/Code/User/syncLocalSettings.json

  `Shift + Alt + d` ，开始下载配置，如果gist中没有的本地扩展会被清除；
  `Shift + Alt + u`, 上传配置，会覆盖gist中的数据

