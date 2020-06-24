##### 2.3 PID命名空间

可以有选择的创建没有PID命名空间的容器
```
docker run --pid host busybox:latest ps
```

`docker create`和`docker run`,主要区别在于容器是被停止状态创建.
`docker create`在编写脚本时会有用
```
CID=$(docker create nginx:latest)
echo $CID
```

`docker run`和`docker create` 可以试用`--cidfile`参数选项指定把容器id写入文件
```
docker create --cidfile /tmp/web.cid nginx
cat /tmp/web.cid
```
如果该文件存在,docker将不会试用所提供的cid文件创建一个新的容器.如果出现这种情况,创建命令将会失败.
