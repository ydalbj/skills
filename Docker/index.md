## Docker技能汇总

### 安装

[安装教程](https://github.com/yeasy/docker_practice/blob/master/install/ubuntu.md)
[安装脚本](https://github.com/ydalbj/skills/blob/master/Linux/Installation/docker.sh)

### 基本概念

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
