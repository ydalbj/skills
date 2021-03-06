### composer

##### 版本约束

[关于 Composer 版本约束表达式的使用](https://www.jianshu.com/p/b1964eb9ede3)

* 语义化版本

  - 版本格式：`主版本号.次版本号.修订号`

  - 版本号递增规则如下

    - 主版本号：当你做了不兼容的 API 修改
    - 次版本号：当你做了向下兼容的功能性新增
    - 修订号：当你做了向下兼容的问题修正
    - 先行版本号及版本编译信息可以加到“主版本号.次版本号.修订号”的后面，作为延伸。
      > 1.0.0-alpha1 这样在后面添加修饰符号来表示先行版本。

* 版本约束

  - 使用 `~` 约束符锁定小版本的方式
    > `~` 表示最后一位可变，前面几位都不可变
    > ~1.1 表示可以为 大于等于 1.1 的任何版本，比如 1.1.0、1.2.0、1.3.5 、1.99.9999、 1.9999.999999 都可以安装，但是不能安装 2.0.0
    > ~1.1.2 表示 大于等于 1.1.2 的任何版本，比如 1.1.2、1.1.3、1.1.99、 1.1.9999 都可以安装。
  
  - 使用 `^` 约束符锁定大版本
    > `^` 锁定不允许变的第一位
    > ^1.2 表示任意大于等于 1.2 的 1.x.x 版本，比如 1.2.0、1.2.1、1.3.0、1.9.99999 等。只要前面的 1 并且大于 ^ 后面指定的 1.2 都满足条件

  - 锁定版本范围

    > `>、<、>=、<=、|`这些符号来组合，比如：>= 1.3 <1.6、>=1.3 | >=1.7 、3.0|4.0

  - 最后就是使用具体版本号

  - 使用 dev- 前缀加分支名

    > 我们在自己开发一个包的时候，经常会用 dev-master 或者 dev-develop 来指定版本，它表示使用该分支下最新的提交

  - 不限定版本(极不推荐)

  - `注意`

    > 如果你的版本是 1.0 以下，0.0.1，0.9.99999 等这样的版本的时候， ^ 的作用与 ~ 一样，也就是说：
      ^0.0.3 表示：>=0.0.3 < 0.0.4
      所以需要注意这个问题，之所以这样设计是有原因的：主版本号为零（0.y.z）的软件处于开发初始阶段，一切都可能随时被改变。这样的公共 API 不应该被视为稳定版。
      所以不要掉进这个坑哦。

