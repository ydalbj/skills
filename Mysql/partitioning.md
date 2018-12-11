## 分区分表

### 概述
分区(Partitioning)是从逻辑上把一个大表分割成小的物理片段执行的。分区有以下优点：
* 当最频繁使用的表区域是单独的分区或少量分区时，查询性能可能会显著提高。这样的分区及其索引比整个表的索引更容易放倒内存中。

* (TODO以下未充分理解,为什么B-Tree索引会有更好的性能)When queries or updates are using a large percentage of one partition, the performance may be increased simply through a more beneficial sequential access to this partition on the disk, instead of using the index and random read access for the whole table. In our case the B-Tree (itemid, clock) type of indexes are used that substantially benefit in performance from partitioning.

* 只要在创建分区时计划好，可以通过添加或删除分区执行批量插入和删除操作。ALTER TABLE语句的执行速度比任务批量插入或删除语句快得多。

* (TODO以下未充分理解)It is not possible to use tablespaces for InnoDB tables in MySQL. You get one directory - one database. Thus, to transfer a table partition file it must by physically copied to another medium and then referenced using a symbolic link.
> Note: Starting with MySQL 5.6 there is a possibility of specifying the location of a tablespace.  However, there are some [limitations](http://dev.mysql.com/doc/refman/5.6/en/tablespace-placing.html)

### prepare
* 从5.1版本开始支持分区,可以通过以下方式检查是否支持分区。

    - before MySQL5.6
        ```sql
        SELECT variable_value FROM information_schema.global_variables WHERE variable_name = 'have_partitioning';
        ```
        or

        ```sql
        SHOW VARIABLES LIKE '%partition%';
        ```

    - MySQL 5.6+
        ```sql
        SELECT plugin_status FROM information_schema.plugins WHERE plugin_name = 'partition';
        ```
        or

        ```sql
        SELECT PLUGIN_NAME as Name, PLUGIN_VERSION as Version, PLUGIN_STATUS as Status FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_TYPE='STORAGE ENGINE';
        ```

        or
        ```sql
        SHOW PLUGINS;
        ```

    确保结果是`yes`或`active`

### Note
* MySQL 5.7.17之后普通的分区(generic partitioning handler)废弃，8.0版本之后移除。简单认定，数据库表没有指定存储引擎，即可认为是MySQL不建议使用的分区方式。 [参考链接](https://www.jianshu.com/p/94703170dd85)

* MySQL5.6.7之前分区最大数量是1024，从5.6.7开始上限变为8192，包括子分区。

### 参考链接
[Docs/howto/mysql partitioning](https://zabbix.org/wiki/Docs/howto/mysql_partitioning)
[MySQL 最佳实践 分区表基本类型](http://mysql.taobao.org/monthly/2017/11/09/)
[MySQL学习](https://www.jianshu.com/p/94703170dd85)
