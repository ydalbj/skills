
##### location 配置

[参考资料](https://www.cnblogs.com/woshimrf/p/nginx-config-location.html)

```
location [=|~|~*|^~|@] /uri/ {
  ...
} 
```

匹配规则
* = : 表示精确匹配后面的url

* ~ : 表示正则匹配，但是区分大小写

* ~* : 正则匹配，不区分大小写

* ^~ : 表示普通字符匹配，如果该选项匹配，只匹配该选项，不匹配别的选项，一般用来匹配目录

匹配顺序
* @ : "@" 定义一个命名的 location，使用在内部定向时，例如 error_page

* `=` 前缀的指令严格匹配这个查询。如果找到，停止搜索；
* 所有剩下的常规字符串，最长的匹配。如果这个匹配使用 ^~ 前缀，搜索停止；
* 正则表达式，在配置文件中定义的顺序；
* 如果第 3 条规则产生匹配的话，结果被使用。否则，使用第 2 条规则的结果。

目标地址处理规则

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

alias与root的区别

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
