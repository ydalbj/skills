##### 双重检查(Double-Check)

在多线程编程中，获取单例需要使用双重检查模式。
```java
class Singleton{
	// 这里务必用volatile 修饰单例变量，否则在实例化单例对象时，可能会有指令重排的问题，导致多线程时获取到null实例的情况
    private volatile static Singleton instance = null;
     
    private Singleton() {
         
    }
     
    public static Singleton getInstance() {
        if(instance==null) {
            synchronized (Singleton.class) {
                if(instance==null)
                    instance = new Singleton();
            }
        }
        return instance;
    }
}
```

[参考资料]
1. [Java并发编程：volatile关键字解析](https://www.cnblogs.com/dolphin0520/p/3920373.html)
2. [Java中的双重检查](https://blog.csdn.net/qq_31387691/article/details/53636262?utm_medium=distribute.pc_feed_404.none-task-blog-2~default~BlogCommendFromBaidu~default-2.control404&depth_1-utm_source=distribute.pc_feed_404.none-task-blog-2~default~BlogCommendFromBaidu~default-2.control40)
3. [Java单例双重检查问题](https://blog.csdn.net/weixin_35422230/article/details/114504144?utm_medium=distribute.pc_feed_404.none-task-blog-2~default~BlogCommendFromBaidu~default-1.control404&depth_1-utm_source=distribute.pc_feed_404.none-task-blog-2~default~BlogCommendFromBaidu~default-1.control40)