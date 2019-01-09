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
