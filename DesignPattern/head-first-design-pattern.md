### Head first设计模式总结

##### 设计原则
* 找出应用中可能需要变化之处，把它们独立出来，不要和那些不需要变化的代码混在一起
* 针对接口编程，而不是针对实现编程

  `针对接口编程`真正的意思是`针对超类型(supertype)编程`。
  更明确的说，变量的声明类型应该是超类型，通常是一个抽象类或者是一个接口。

  - 针对实现编程
    ```java
    Dog d = new Dog();
    d.bark();
    ```
  - 针对接口/超类型编程

    ```java
    Animal animal = new Animal();
    animal.makeSound();
    ```
    or
    ```java
    a = getAnimal();
    a.makeSound();
    ```

    > 这就是`多态`。

* 多用组合，少用继承
  > php可以用`trait`实现组合
  > 也可以用对象属性实现组合

##### 设计模式

* 策略模式（Strategy Pattern）

  > 策略模式定义了一族算法(a family of algorithms)，分别分装起来，可以互相替换。此模式让算法的变化独立于使用算法的客户(对象)。
