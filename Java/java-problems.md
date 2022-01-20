
### 时间问题

##### SimpleDateFormat线程不安全

	在多线程环境下，当多个线程同时使用相同的SimpleDateFormat对象（如static修饰）的话，如调用format方法时，多个线程会同时调用calender.setTime方法，导致time被别的线程修改，因此线程是不安全的。

	解决方案：
	1. 将SimpleDateFormat定义成局部变量
	2. 加一把线程同步锁：synchronized(lock)
	3. 使用ThreadLocal，每个线程都拥有自己的SimpleDateFormat对象副本
	4. 使用DateTimeFormatter代替SimpleDateFormat

参考：
- [SimpleDateFormat为什么线程不安全](https://www.php.cn/java/base/475759.html)

- [ThreadLocal的使用](https://blog.csdn.net/Gosick_Geass_Gate/article/details/99713163)
