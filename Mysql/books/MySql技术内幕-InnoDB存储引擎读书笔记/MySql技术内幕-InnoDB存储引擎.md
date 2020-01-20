## InnoDB存储引擎

### InnoDB体系架构

##### 后台线程

InnoDB存储引擎是多线程的模型，因此其后台有多个不同的后台线程，负责处理不同的任务。

- Master Thread

    负责将缓冲池中的数据异步刷新到磁盘，保证数据一致性，包括脏页的刷新，合并插入缓冲(Insert BufferA), Undo页的回收等。

- IO Thread

    InnoDB大量使用AIO(Async IO)来处理IO请求，IO Thread负责这些IO请求的回调处理。

    InnoDB 1.0版本之前共有4个IO Thread，分别是write、read、insert buffer和log IO thread。在Linux平台下，IOThread的数量不能进行调整，但是在Windows平台下可以通过参数innodb_file_io_threads来增大IO Thread。

    从InnoDB 1.0.x版本开始，read thread和write thread分别增大到了4个，并且不再使用innodb_file_io_threads参数，而是分别使用innodb_read_io_threads和innodb_write_io_threads参数进行设置。在Linux平台上就可以根据CPU核数来更改相应的参数值了。

- Purge Thread

    事务被提交后，其所使用的undolog可能不再需要，因此需要PurgeThread来回收已经使用并分配的undo页。

    配置参数
    ```conf
    [mysqld]
    innodb_purge_threads=1
    ```

    在InnoDB 1.1版本中，即使将innodb_purge_threads设为大于1，InnoDB存储引擎启动时也会将其设为1，并在错误文件中。从InnoDB 1.2版本开始，InnoDB支持多个Purge Thread

- Page Cleaner Thread

    Page Cleaner Thread是在InnoDB 1.2.x版本中引入的。其作用是将之前版本中脏页的刷新操作都放入到单独的线程中来完成

##### 内存

- 缓冲池(Buffer Pool)

    缓冲池简单来说就是一块内存区域，通过内存的速度来弥补磁盘速度较慢对数据库性能的影响。在数据库中进行读取页的操作，首先将从磁盘读到的页存放在缓冲池中，这个过程称为将页“FIX”在缓冲池中。配置参数`innodb_buffer_pool_size`。

    具体来看，缓冲池中缓存的数据页类型有：索引页、数据页、undo页、插入缓冲（insert buffer）、自适应哈希索引（adaptive hashindex）、InnoDB存储的锁信息（lock info）、数据字典信息（datadictionary）等。配置参数`innodb_buffer_pool_instances`设置缓冲池实例数量，默认为1。

    - LRU List，Free List和Flush List

        数据库中的缓冲池是通过LRU（Latest Recent Used，最近最少使用）算法来进行管理的。即最频繁使用的页在LRU列表的前端，而最少使用的页在LRU列表的尾端。当缓冲池不能存放新读取到的页时，将首先释放LRU列表中尾端的页。
