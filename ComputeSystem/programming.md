### 编程方法总结

##### 静态方法

* 什么情况下使用静态方法？和实例方法的区别？

  - 在加载时机和占用内存上，静态方法和实例方法是一样的，在类型第一次被使用时加载。调用的速度基本上没有差别。
    > 常见误解`静态方法常驻内存，实例方法不是，所以静态方法效率高但占内存。`

  - 静态方法实际上相当于结构化编程的普通函数

  - 从面向对象的角度上来说，在抉择使用实例化方法或静态方法时，应该根据是否该方法和实例化对象具有逻辑上的相关性，如果是就应该使用实例化对象  反之使用静态方法。

  - 如果一个方法与他所在类的实例对象无关，那么它就应该是静态的，而不应该把它写成实例方法

  - 使用静态方法应该考虑线程安全，对象依赖有没有问题

  - 参考资料

    [What are the advantages and disadvantages of having a static method in Java?](https://www.quora.com/What-are-the-advantages-and-disadvantages-of-having-a-static-method-in-Java)

    [Drawbacks of static methods in PHP](https://stackoverflow.com/questions/4463314/drawbacks-of-static-methods-in-php)

    [静态方法和实例化方法的区别](https://blog.csdn.net/dwzsq/article/details/2097783)

    [static和const关键字的使用（self::）](https://www.kancloud.cn/webxyl/php_oop/68888)
