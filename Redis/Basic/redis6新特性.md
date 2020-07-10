### ACL (访问控制列表 Access Control List)

Redis 6 中加入ACL的功能，能够对接入的用户进行三个层面的权限控制：

- 接入权限:用户名,密码
- 可以执行的命令
- 可以操作的key

```
127.0.0.1:6380> ACL WHOAMI
"default"
127.0.0.1:6380> ACL setuser aaron on >mypasswd +@all ~*
OK
127.0.0.1:6380> AUTH aaron mypasswd
OK
127.0.0.1:6380> ACL WHOAMI
"aaron"
127.0.0.1:6380> GET foo
(nil)
127.0.0.1:6380> SET foo bar
OK
```

去掉SET命令
```
127.0.0.1:6380> ACL setuser aaron -SET
OK
127.0.0.1:6380> SET foo 123
(error) NOPERM this user has no permissions to run the 'set' command or its subcommand
```

限制可以操作的`key`
```
127.0.0.1:6380> ACL setuser ben on >mypasswd +@all ~ben*
OK
127.0.0.1:6380> SET foo bar
(error) NOPERM this user has no permissions to access one of the keys used as arguments
127.0.0.1:6380> SET benfoo bar
OK
```

通过`ACL list`命令查看用户和他们的权限和密码(前提是该用户有ACL命令的权限)
```
127.0.0.1:6380> ACL list
1) "user aaron on >mypasswd ~* +@all -set"
2) "user default on nopass ~* +@all"
```

ACL功能是基于bitmap实现的,对性能几乎没有影响

### RESP3
`RESP3` 全称是 `REdis Serialization Protocol`,是Redis客户端与服务端之间通信的协议.
Redis5使用的是`RESP2`, Redis6是在RESP2的基础上,开始支持`RESP3`
