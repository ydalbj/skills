## 推荐用户设置

##### 准备

* Fira Code需要先安装，参考 [Fira Code](https://github.com/ydalbj/skills/blob/master/Tools/Editors/VSCode/font.md)
* VS Code sync 同步设置及扩展
    > 注： "sync.gist": "1dfe38eeee48e0439e61a764c25b4dab"
* PHP CS安装 TODO
* WSL安装 TODO

##### 设置
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
