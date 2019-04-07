什么是堆内存(heap)，栈内存(stack)

[堆内存和栈内存详解](https://blog.csdn.net/abcjennifer/article/details/39780819)
[JVM内存结构](https://blog.csdn.net/qq_31997407/article/details/79675371)
[参考资料中文1](http://blog.jobbole.com/75321/)
[参考资料英文1](https://stackoverflow.com/questions/79923/what-and-where-are-the-stack-and-heap)
[Memory Layout of C Programs](https://www.geeksforgeeks.org/memory-layout-of-c-program/)
[Understanding PHP memory](https://www.slideshare.net/jpauli/understanding-php-memory/18-ZendMM_guards_and_leak_tracker)


C程序的典型内存表示由以下部分组成 

* 代码段(Text segment)

  作为内存区域，文本段可以放在堆或堆栈下面，以防止堆和堆栈溢出覆盖它。在代码段中，也有可能包含一些只读的常数变量，例如字符串常量等。

* BSS段(bss segment)(Uninitialized data segment)

  通常是指用来存放程序中未初始化的全局变量的一块内存区域。BSS是英文Block Started by Symbol的简称。BSS段属于静态内存分配。

* 数据段(data segment)(Initialized data segment)

  通常是指用来存放程序中已初始化的全局变量的一块内存区域。数据段属于静态内存分配。


* 栈区（stack）

  由编译器自动分配释放 ，存放函数的参数值，局部变量的值等。其操作方式类似于数据结构中的栈 

* 堆区（heap）

  一般由程序员分配释放，若程序员不释放，程序结束时可能由OS回收。注意它与数据结构中的堆是两回事，分配方式倒是类似于链表

##### 栈
  * 线程启动时分配，每个线程一个栈区
  * 栈是作为执行线程的临时空间留出的内存
  * 调用函数时，会在堆栈顶部为区域变量和一些簿记数据保留一个块
  * 当该函数返回时，该块将变为未使用状态，并可在下次调用函数时使用
  * 栈始终以LIFO（后进先出）顺序保留
  * 这使得跟踪堆栈非常简单;从堆栈中释放块只不过是调整一个指针
  * 存储局部数据，返回地址，用做参数传递
  * 当用栈过多时可导致栈溢出（无穷次（大量的）的递归调用，或者大量的内存分配）

##### 堆
  * 堆是为动态分配留出的内存
  * 每个线程都获得一个堆栈，而应用程序通常只有一个堆

```c
int foo()
{
    char *pBuffer; //<--nothing allocated yet (excluding the pointer itself, which is allocated here on the stack).
    bool b = true; // Allocated on the stack.
    if(b)
    {
        //Create 500 bytes on the stack
        char buffer[500];

        //Create 500 bytes on the heap
        pBuffer = new char[500];

    }//<-- buffer is deallocated here, pBuffer is not
}//<--- oops there's a memory leak, I should have called delete[] pBuffer;
```

```c++
//main.cpp
inta = 0; //全局初始化区
char*p1; //全局未初始化区
main()
{
int b; //栈 
   char s[] = "abc"; //栈 
   char *p2; //栈  
   char *p3 = "123456"; //123456\0在常量区，p3在栈上。  
   static int c =0； //全局（静态）初始化区 
   p1 = (char *)malloc(10);  
    p2 = (char*)malloc(20);  
   //分配得来的10和20字节的区域就在堆区, 但是注意p1、p2本身是在栈中的 
   strcpy(p1,"123456"); //123456\0放在常量区，编译器可能会将它与p3所指向的"123456"优化成一个地方。  
}
```
