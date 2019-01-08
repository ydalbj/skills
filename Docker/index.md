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
