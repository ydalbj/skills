### PHP基本语法使用总结

##### 类与对象

* 后期静态绑定

  > “后期绑定”的意思是说，static:: 不再被解析为定义当前方法所在的类，而是在实际运行时计算的。也可以称之为“静态绑定”，因为它可以用于（但不限于）静态方法的调用。

  - 非转发调用(non-forwarding call)

    > 当进行静态方法调用时，该类名即为明确指定的那个（通常在 :: 运算符左侧部分）；

    > 当进行非静态方法调用时，即为该对象所属的类。

  - 转发调用(forwarding call)

    通过以下几种方式进行的静态调用：self::，parent::，static:: 以及 forward_static_call()。

  - `self::`的限制

    使用 `self::` 或者 __CLASS__ 对当前类的静态引用，取决于定义当前方法所在的类。使用`static::class`可以后期静态绑定表示引用运行时最初调用的类（即上一个非转发调用类）

  - `$this` 与 `static::`


##### 字符编码

* 汉字和Unicode码(utf-8)之间的转换(Pack/Unpack)
  ```php
  $cnStr = "中"; //utf8的中文

  //unicode
  $code = unpack("H6codes", $cnStr);

  //汉字
  $cnStr = pack("H6", $code['codes']);
  ```
  > pack/unpack很强大,, 和c语言交换数据, 二进制方式的序列化,操作二进制文件.. etc…
