# Head first设计模式总结

## 设计原则
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

* 对象之间松耦合设计

  依赖注入，观察者模式等

* 开放-关闭原则(Open-Close)
  > 类应该对扩展开放，对修改关闭

* 依赖倒置原则(Dependency Inversion Principle)
  > 依赖抽象而不依赖具体类
  > 变量尽量不持有具体类的引用。（少用new，可以用工厂模式等）
  > 尽量不要让类派生自具体类，派生自抽象类或接口
  > 尽量不要覆盖基类中已实现的方法


## 设计模式

##### 策略模式(Strategy)

  > 策略模式定义了算法族(a family of algorithms)，分别分装起来，可以互相替换。此模式让算法的变化独立于使用算法的客户(对象)。

##### 观察者模式(Observer)

  > 观察者模式定义了对象之间的一对多依赖，当一个对象改变状态时，它的所有依赖者都会收到通知并自动更新。

##### 装饰者模式

  > 装饰者模式动态地将责任附加到对象上。若要扩展功能，装饰者提供了比继承更有弹性的替代方案。

  - 装饰者和被装饰对象有相同的超类型
  - 可以用一个或多个装饰者包装一个对象
  - 装饰者和被装饰者有相同的超类型，所以在任何需要原始对象(被包装的)场合，可以用装饰过的对象代替它。
  - 装饰者可以在所委托被装饰者的行为之前与/或之后，加上自己的行为，以达到特定的目的。
  - 对象可以在任何时候被装饰，所以可以在运行时动态地，不限量地用你喜欢的装饰者来装饰对象。

##### 工厂模式

  - 简单工厂:封装一组类的创建
    > 简单工厂其实称不上是一个设计模式，算是一种编程习惯。

  - 工厂方法模式：定义了一个创建对象的接口或抽象类，但是让子类决定该创建的对象是什么，来达到将对象创建过程封装的目的。

  - 抽象工厂模式：提供一个接口，用于创建相关或依赖对象的家族，而不需要明确指定具体类。(provides an interface for creating families of related or dependent objects without specifying their concrete classes)

    > 抽象工厂允许客户程序使用抽象的接口来创建一组相关的产品，而不需要知道实际产出的具体产品是什么。这样，客户程序就从具体的产品中解耦。

##### 单例模式(Singleton Pattern)

  > 单例模式确保一个类只有一个实例，并提供一个全局访问点

  * 处理多线程 (synchronized)

    ```java
    public class Singleton
    {
      private static Singleton uniqueInstance;

      private Singleton() {}

      public static synchronized Singleton getInstance()
      {
        if (uniqueInstance == null) {
          uniqueInstance = new Singleton();
        }

        return uniqueInstance;
      }
    }
    ```

    > 但是同步方法会降低程序执行效率

    1. 如果对性能要求不高，使用同步方法

    2. 预先创建实例，而不是延迟实例化

      > 如果应用程序总是创建并使用单件实例，或是在创建和运行时负担(内存)不大，可以预先创建实例。

        ```java
        public class Singleton
        {
          private static Singleton uniqueInstance = new Singleton();

          private Singleton() {}

          public static Singleton getInstance() {
            return uniqueInstance;
          }
        }
        ```

    3. `双重检查加锁`，在getInstance()中使用同步

        ```java
        public class Singleton
        {
          private volatile Singleton uniqueInstance;

          private Singleton() {}

          public static Singleton getInstance() {
            if (uniqueInstance == null) {
              synchronized (Singleton.class) {
                if (uniqueInstance == null) {
                  uniqueInstance = new Singleton();
                }
              }
            }

            return uniqueInstance;
          }
        }
        ```

        > `volatile`关键词确保，当uniqueInstance变量被初始化成Singleton实例时，多个线程正确地处理uniqueInstance变量




