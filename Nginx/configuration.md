
### location 配置

[参考资料](https://juejin.im/post/5ce5e1f65188254159084141)

```
location [=|~|~*|^~|@] /uri/ {
  ...
} 
```

##### 匹配规则
* = : 表示精确匹配后面的url

* ~ : 表示正则匹配，但是区分大小写

* ~* : 正则匹配，不区分大小写

* ^~ : 表示普通字符匹配，如果该选项匹配，只匹配该选项，不匹配别的选项，一般用来匹配目录

* @ : "@" 定义一个命名的 location，使用在内部定向时，例如 error_page

匹配顺序

当nginx选择一个`location`块来服务请求时，它首先检查指定前缀的位置指令，记住最长的前缀`location`，然后检查正则表达式.
如果正则表达式匹配,则采用改`location`,否则采用之前记住的最长前缀`location`

* 精确匹配 =
* 前缀匹配 ^~（立刻停止后续的正则搜索）
* 按文件中顺序的正则匹配 ~或~*
* 匹配不带任何修饰的前缀匹配。

##### 目标地址处理规则

```
upstream api_server {
  server 10.0.101.62:8081;
  server 10.0.101.61:8082;
}

location / {
        rewrite ^(.*)$ http://10.0.101.62:8000/my-module$1 break;
}

location ^~ /my-module/ {
    root   /data/my-module/dist;
    rewrite ^/my-module/(.*)$  /$1 break;
    index  index.html index.htm;
}

location /my-module/api {
    proxy_pass  http://api_server;
    proxy_set_header Host $host;
    proxy_set_header  X-Real-IP        $remote_addr;
    proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;
    proxy_set_header  your-custome-header    "myHeader";
    proxy_set_header X-NginX-Proxy true;
}
```

上述配置，默认访问/会重定向到/my-module, 然后直接返回/data/my-module/dist下的html等静态文件。

访问/my-module/api则会代理到我们api服务器地址，是一个默认的round-robin负载均衡配置。

下面是访问localhost的日志, 访问首页一共进行了2次重定向。
```
Request URL: http://10.0.101.62:8000/
Request Method: GET
Status Code: 302 Moved Temporarily
Location: http://10.0.101.62:8000/flash/

Request URL: http://10.0.101.62:8000/flash/
Request Method: GET
Status Code: 302 Moved Temporarily
Location: http://10.0.101.62:8000/flash/index.html

Request URL: http://10.0.101.62:8000/flash/index.html
Request Method: GET
Status Code: 304 Not Modified
```

##### alias与root的区别

* root 实际访问文件路径会拼接URL中的路径
* alias 实际访问文件路径不会拼接URL中的路径

```
location ^~ /sta/ {  
   alias /usr/local/nginx/html/static/;  
}
```
请求：http://test.com/sta/sta1.html
实际访问：/usr/local/nginx/html/static/sta1.html 文件

```
location ^~ /tea/ {  
   root /usr/local/nginx/html/;  
}
```
请求：http://test.com/tea/tea1.html
实际访问：/usr/local/nginx/html/tea/tea1.html 文件

##### last和break关键字的区别

只用到了break，即匹配到此处后不会继续跳。

##### permanent 和 redirect关键字的区别

rewrite … permanent 永久性重定向，请求日志中的状态码为301
rewrite … redirect 临时重定向，请求日志中的状态码为302

我们常用的80端口转443，即http转https的一种配置方案为：
```
server {
    listen 80;
    server_name demo.com;
    rewrite ^(.*)$ https://${server_name}$1 permanent; 
}
```

会返回301永久重定向到对应的https：

```
Request URL: http://demo.com/flash/index.html
Request Method: GET
Status Code: 301 Moved Permanently
Location: https://demo/flash/index.html
```

