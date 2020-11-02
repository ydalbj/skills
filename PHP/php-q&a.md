### Configuration
##### php.ini upload_max_filesize, post_max_size 设置不生效

如果是php-fpm,还需要设置 `php-fpm.conf`

```
php_admin_value[upload_max_filesize] = 20M
php_admin_value[post_max_size] = 20M
```

如果还有错误`413 Request Entity Too Large`
还要在`/etc/nginx/nginx.conf`里增加一行设置

```
client_max_body_size 20M;
```