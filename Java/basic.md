### Java基础

##### 基本概念

* `OpenJDK` & `Oracle JDK`

  - OpenJDK是Sun在2006年末把Java开源而形成的项目，这里的“开源”是通常意义上的源码开放形式，即源码是可被复用的，例如IcedTea、UltraViolet都是从OpenJDK源码衍生出的发行版。OpenJDK和Oracle JDK目前​​仅由Oracle创建和维护

  - 授权协议的不同
    > OpenJDK采用GPL V2协议发布，而JDK则采用JRL协议发布。
    > 两个协议虽然都是开放源代码的，但是在使用上的不同在于GPL V2允许在商业上使用，而JRL只允许个人研究使用。

  - OpenJDK只包含最精简的JDK

  - OpenJDK源代码不完整

  [参考链接](https://www.cnblogs.com/bluestorm/p/8965656.html)

* 在类中使用 `this` 关键词

  - 第一个也是最常见的是在setter方法中消除变量引用的歧义

    ```java
    public class Foo
    {
        private String name;

        public void setName(String name) {
            this.name = name;
        }
    }
    ```

  - 第二种是当需要将当前类实例作为参数传递给另一个对象的方法时
    ```java
    public class Foo
    {
        public String useBarMethod() {
            Bar theBar = new Bar();
            return theBar.barMethod(this);
        }

        public String getName() {
            return "Foo";
        }
    }

    public class Bar
    {
        public void barMethod(Foo obj) {
            obj.getName();
        }
    }
    ```

  - 第三种方法是从构造函数中调用备用构造函数
    ```java
    class Foo
    {
        public Foo() {
            this("Some default value for bar");

            //optional other lines
        }

        public Foo(String bar) {
            // Do something with bar
        }
    }
    ```
