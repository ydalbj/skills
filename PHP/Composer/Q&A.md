##### Q: `composer update` 下载超时
```
  [Composer\Downloader\TransportException (504)]                                                                                                                             
  The "https://mirrors.aliyun.com/composer/p/provider-2019-01%24ae53a47c6dc1ae458231cfefe7739e207add3b7356e6f2700c3f8c79c736e023.json" file could not be downloaded (HTTP/1  
  .1 504 Gateway Time-out)    
```
A: 强制使用与Packagist的https连接
在`composer.json`文件添加如下配置
```
"repositories": [
    {
         "type": "composer", 
         "url": "https://mirrors.aliyun.com/composer/"
    },
    { "packagist": false }
]
```

[参考](https://stackoverflow.com/questions/43996782/how-to-correct-the-composer-downloader-transportexception-error-for-composer)
