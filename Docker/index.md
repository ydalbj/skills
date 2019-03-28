## Docker技能汇总

### 安装

[安装教程](https://github.com/yeasy/docker_practice/blob/master/install/ubuntu.md)
[安装脚本](https://github.com/ydalbj/skills/blob/master/Linux/Installation/docker.sh)

### 基本基础

##### 基本操作

  * `docker rm` 删除container
  * `docker rmi` 删除image
  * `docker cp` 在host和container之间拷贝文件
  * `docker commit` 保存改动为新的image
  * `docker inspect` 查看容器信息
  * `docker version` 查看client/server api版本等信息。注意与`docker --version`的不同
  * `docker exec -it <container-id> bash` 进入容器
  * `docker create` 语法同docker run，创建一个容器，但不启动
  * image分层：Dockerfile中的每一行都产生一个新层
  * 构建image的Dockerfile的每一层都是只读的，构建完成后产生一个容器层（container layer），是可写可读的,更改后通过`docker commit`保存修改为新image
  * 不要把Dockerfile当shell脚本来写，`cd /path/to`,只影响当前行。

##### 容器操作

  * 批量删除容器

    1. 查询所有的容器，过滤出Exited状态的容器，列出容器ID，删除这些容器

      ```shell
      $ docker rm `docker ps -a|grep Exited|awk '{print $1}'`
      ```

    2. 删除所有未运行的容器（已经运行的删除不了，未运行的就一起被删除了）

      ```shell
      $ docker rm $(sudo docker ps -a -q)
      ```

    3. 根据容器的状态，删除Exited状态的容器

      ```shell
      $ docker rm $(sudo docker ps -qf status=exited)
      ```

    4. Docker 1.13版本以后，可以使用 docker containers prune 命令，删除孤立的容器

      ```shell
      $ docker container prune
      ```



##### 最佳实践

  [Docker文档](https://docs.docker.com/get-started/)

  > 镜像(image):静态的定义

  > 容器(container):运行时实例

     Docker应用层级结构

      - 最下层是容器(Container)
      - 再上一层是服务(Services)
      - 最上层是Stack

  * 容器

    - 用`Dockerfile`定义容器
    - 构建Docker应用镜像
      ```shell
      $ docker build -t repository:tag .
      ```

    - 运行容器应用

      ```shell
      $ docker run -p repository
      ```

  * 镜像仓库(registry)

    - 登录registry，例如hub.docker.com

      ```shell
      $ docker login
      ```
    - 给镜像做标签
      ```shell
      $ docker tag image username/repository:tag
      ```
    - 发布镜像至仓库

      ```shell
      $ docker push username/repository:tag
      ```

    - 从镜像仓库拉取并运行镜像

      ```shell
      $ docker run -p 4000:80 username/repository:tag
      ```

  * 服务(service)

    > 服务实际上只是“生产环境中的容器”。服务只运行一个镜像(image)，编码镜像运行的方式（端口，容器副本数量等）。

    - `docker-compose.yml`文件

      ```yml
      version: "3"
      services:
        web:
          # replace username/repo:tag with your name and image details
          image: username/repo:tag
          deploy:
            replicas: 5
            resources:
              limits:
                cpus: "0.1"
                memory: 50M
            restart_policy:
              condition: on-failure
          ports:
            - "4000:80"
          networks:
            - webnet
      networks:
        webnet:
      ```

    - 运行应用

      > 下列命令启动一个single service stack，运行5个容器实例(docker-compose.yml文件配置)

      ```shell
      $ docker swarm init
      $ docker stack deploy -c docker-compose.yml getstartedlab
      ```

      > 查看service
      ```shell
      $ docker service ls
      ```

      > 查看sevice task(在一个service里运行的单个容器称为task)
      ```shell
      $ docker service ps getstartedlab_web
      ```

      > 查看所有task
      ```shell
      $ docker container ls -q
      ```

      > 扩展service,执行以下命令，docker就地更新，无需拆除stack，或杀死任何容器

      ```shell
      $ docker stack deploy -c docker-compose.yml getstartedlab
      ```

      > Take down the app and the swarm

      ```shell
      $ docker stack rm getstartedlab
      $ docker swarm leave --force
      ```

  * Swarm cluster

    > 通过将多台机器连接到称为Swarm(群集)的“Dockerized”集群，可以实现多容器，多机器应用程序。Swarm是一组运行Docker并加入群集的计算机。

    > Swarm manager可以使用多种策略来运行容器

    > Swarm manager是Swarm(群集)中唯一可以执行命令的机器，或授权其他机器作为Worker加入群集。

    - 设置Swarm

      运行`docker swarm init` 启动swarm mode，使当前机器成为Swarm manager。在其他机器上运行`docker swarm join`加入Swarm成为一个Worker。

    - 创建一个集群

      1. `docker-machine create`创建虚拟机

      ```shell
      $ docker-machine create --driver virtualbox myvm1
      $ docker-machine create --driver virtualbox myvm2

      $ docker-machine ls
      ```

      2. 初始化Swarm，添加节点

      ```shell
      $ docker-machine ssh myvm1 "docker swarm init --advertise-addr <myvm1 ip>"

      $ docker-machine ssh myvm2 "docker swarm join --token <token> <myvm ip>:<port>"
      ```

      端口`2377`和`2376`

        > 始终使用端口2377运行docker swarm init和docker swarm join

        > docker-machine ls返回的机器IP地址包括端口2376，它是Docker守护程序端口

      Docker Machine可以让您使用自己的系统SSH。

        ```shell
        $ docker-machine --native-ssh ssh myvm1 ...
        ```

      通过Swarm manager查看节点

        ```shell
        $ $ docker-machine ssh myvm1 "docker node ls"
        ```
      
      退出Swarm：如果要重新开始，可以从每个节点运行docker swarm leave。
    
    - 在Swarm cluster上部署您的应用程序

      配置 `docker-machine` shell 操作 swarm manager

      除了使用`docker-machine ssh`操作虚拟机外，还可以通过运行`docker-machine env <machine>`来配置当前shell来操作虚拟机Docker守护进程

        ```shell
        $ docker-machine env myvm1
        $ eval $(docker-machine env myvm1)
        ```

    - 然后在Swarm manager机器上执行 docker stack deply及其它docker操作

  * Stacks

    Stack是一组相互关联的Service，它们共享依赖关系，并且可以协调和规划在一起

##### Docker网络

* Docker 默认网络

  `docker network ls`查看默认网络类型有bridge(默认),host,none

* 创建自定义网络：（设置固定IP）

  启动Docker容器的时候，使用默认的网络是不支持指派固定IP的，如下：

  ```shell
  $ docker run -itd  --net bridge --ip 172.17.0.10 centos:latest /bin/bash

  6eb1f228cf308d1c60db30093c126acbfd0cb21d76cb448c678bab0f1a7c0df6
  docker: Error response from daemon: User specified IP address is supported on user defined networks only.
  ```

  - 创建自定义网络

    ```shell
    docker network create --subnet=172.18.0.0/16 mynetwork
    ```
  - 创建Docker容器,指定ip

    ```shell
    $ docker run -itd --name networkTest1 --net mynetwork --ip 172.18.0.2 centos:latest /bin/bash
    ```

### Docker uid,gid

  linux内核负责管理uid和gid空间。容器共享内核，在运行Docker容器的服务器上，整个uids和gids也由单个内核控制。在常见的linux工具中显示的用户名（和组名）不是内核的一部分，而是由外部工具（/etc/passwd，LDAP，Kerberos等）管理。因此，您可能会看到不同的用户名，但即使在不同的容器内，您也无法为同一个uid / gid拥有不同的权限。

  启动容器时，如果不指定`--user`，或者没有在Dockerfile里指定 `USER`。默认以root用户启动容器进程。容器内的root用户和host的容器用户拥有相同的uid，即有相同的权限。需要注意的是，在运行容器时指定用户标志也会覆盖Dockerfile中的该值。
