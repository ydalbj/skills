### 事务

[mysql的事务控制](http://blog.51cto.com/gfsunny/1573929)

事务四特性：原子性，一致性，隔离性，持久性；即ACID(Atomicity、Consistency、Isolation、Durability)


##### 事务隔离性

  当数据库上有多个事务同时执行的时候，就可能出现脏读（dirty read）、不可重复读（non-repeatable read）、幻读（phantom read）的问题，为了解决这些问题，就有了“隔离级别”的概念。

  幻读问题是指一个事务的两次不同时间的相同查询返回了不同的的结果集

* 事务隔离级别

  - 读未提交：一个事务还没提交时，它做的变更就能被别的事务看到。

  - 读提交：一个事务提交之后，它做的变更才会被其他事务看到。

  - 可重复读：一个事务执行过程中看到的数据，总是跟这个事务在启动时看到的数据是一致的。

  - 串行化：对于同一行记录，“写”会加“写锁”，“读”会加“读锁”。当出现读写锁冲突的时候，后访问的事务必须等前一个事务执行完成，才能继续执行。

  > InnoDB默认隔离级别是`可重复读`(REPEATABLE READ)。

* 事务隔离的实现

  在 MySQL 中，实际上每条记录在更新的时候都会同时记录一条回滚操作。记录上的最新值，通过回滚操作，都可以得到前一个状态的值。
  `同一条记录在系统中可以存在多个版本，就是数据库的多版本并发控制（MVCC）`。
  回滚日志在不需要时才会删除，长事务意味着系统存储很老的事务视图。长事务还占用锁资源，也可能拖垮整个库。

* 事务的启动方式

  - 显式启动事务语句， begin 或 start transaction。配套的提交语句是 commit，回滚语句是 rollback。

  - set autocommit=0，这个命令会将这个线程的自动提交关掉。意味着如果你只执行一个 select 语句，这个事务就启动了，而且并不会自动提交。这个事务持续存在直到你主动执行 commit 或 rollback 语句，或者断开连接。

  `建议你总是使用 set autocommit=1, 通过显式语句的方式来启动事务`。

  information_schema 库的 innodb_trx 这个表中查询长事务，比如下面这个语句，用于查找持续时间超过 60s 的事务
  ```sql
  select * from information_schema.innodb_trx where TIME_TO_SEC(timediff(now(),trx_started))>60
  ```

  `begin/start transaction` 命令并不是一个事务的起点，在执行到它们之后的第一个操作 InnoDB 表的语句（第一个快照读语句），事务才真正启动。如果你想要马上启动一个事务，可以使用 `start transaction with consistent snapshot` 这个命令。

  - `completion_type`参数配置

    `NO_CHAIN` (or 0):COMMIT and ROLLBACK are unaffected. This is the default value.

    `CHAIN` (or 1):`COMMIT`和`ROLLBACK`分别相当于`COMMIT AND CHAIN`和`ROLLBACK AND CHAIN`. (新事务立即以与刚刚终止的事务相同的隔离级别启动。)

    `RELEASE`(or 2):`COMMIT`和`ROLLBACK`分别等同于`COMMIT RELEASE`和`ROLLBACK RELEASE`。 (终止事务后服务器断开连接。)

* 数据隔离级别的实现

  MySQL 两种视图概念

  - 一个是查询语句定义的虚拟表，在调用的时候执行查询语句并生成结果。创建视图的语法是`create view ...`,查询方法和表一样。

  - 另一个是InnoDB在实现MVCC时用到的一致性读视图,即`consistent read view`,用于支持RC(Read Commited)和RR(Repeatable Read)隔离级别的实现。它没有物理结构，作用是事务执行期间用来定义`我能看到什么数据`
