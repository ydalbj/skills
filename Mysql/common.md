## 基本概念

##### DML
  DDL(data manipulation language):SELECT、UPDATE、INSERT、DELETE

* `REPLACE INTO` 

  > 必须有主键或唯一索引，存在则更新，不存在则插入。更新时会删除原纪录，再插入新纪录。所以更新一行，影响行数是2。

* `SQL_CALC_FOUND_ROWS`,`FOUND_ROWS()`的使用

  ```sql
  mysql> SELECT SQL_CALC_FOUND_ROWS * FROM tbl_name
  -> WHERE id > 100 LIMIT 10;
  mysql> SELECT FOUND_ROWS();
  ```
  第二个`SELECT`语句返回一个数字，表示如果没有`LIMIT`子句，第一个`SELECT`返回多少行。
  如果不使用`SQL_CALC_FOUND_ROWS`参数，第二个语句返回的是`LIMIT`限制的行数。

##### 

##### 字符编码
* `Character Sets` and `Collations`
TODO

  [手册链接](https://dev.mysql.com/doc/refman/8.0/en/charset.html)

* `字符`和`字节`的区别
  - 一个`字节`(`byte`)等于8个`bit`位
  - 字符，是一个单位的字形，类字形单位或符号，指的是字母，数字，字和符号，包括：1、2、3、A、B、C、~！·#￥%……—*（）——+等等。
  - 不同的字符编码，一个字符占用的字节数不一定。ASCII编码中，一个英文字母或数字占一个字节，一个中文汉字占两个字节。

* `varchar`和`char`
  - `char`列，长度范围0-255。右补齐空格。
  - 检索CHAR值时，除非启用`PAD_CHAR_TO_FULL_LENGTH` SQL模式，否则将删除尾随空格。
  - `varchar`列，长度范围(0-65535)。有效的最大长度取决于行最大长度（也是65535，所有列共享）
  - `varchar`值存储为1或2字节长度前缀+数据。前缀表示数据值的字节数。255字节以内前缀长度为1字节，255字节以上，前缀长度为2字节。
  - 如果没有开启严格模式(`strict SQL mode`),当你给一个`char`或`varchar`列赋值超过最大长度时，该值被截断至适合长度，并产生一个警告。如果你不想截断，就开启严格模式。
  - 对于`varchar`列，在插入之前会截断超出列长度的尾随空格，并且无论使用何种SQL模式，都会生成警告。对于CHAR列，无论SQL模式如何，都会以静默方式截断插入值中的多余尾随空格。
  
  例：`char(4)`,`varchar(4)`列存储示意表。(假设该列使用字符集为单字节字符，比如`latin1`或`ascii`)
  | Value |	CHAR(4) |	Storage Required |	VARCHAR(4) |	Storage Required |
  |-------| --------|-------|----------|-----------------
  | '' |	'    ' |	4 bytes |	'' |	1 byte |
  | 'ab' |	'ab  ' |	4 bytes |	'ab' |	3 bytes |
  | 'abcd' |	'abcd' |	4 bytes |	'abcd' |	5 bytes |
  | 'abcdefgh' |	'abcd' |	4 bytes |	'abcd' |	5 bytes |
  > 显示为存储在表的最后一行中的值仅在不使用严格模式时适用;如果MySQL在严格模式下运行，则不会存储超过列长度的值，并且会产生错误。

  - InnoDB将长度大于或等于768字节的固定长度字段编码为可变长度字段，可以在页外存储(`off-page`)。例如，当使用utf8mb4时，如果字符集的最大字节长度大于3，则CHAR（255）列可以超过768字节。

  - 如果将给定值存储到CHAR（4）和VARCHAR（4）列中，则从列中检索的值并不总是相同，因为在取值时从CHAR列中删除了尾随空格。

  - CHAR和VARCHAR列中的值将根据分配给列的字符集排序规则(`character set collation`)进行排序和比较

  [手册链接](https://dev.mysql.com/doc/refman/8.0/en/char.html)


* MySQL在 5.5.3 之后增加了 utf8mb4 字符编码，mb4即 most bytes 4。简单说 utf8mb4 是 utf8 的超集并完全兼容utf8，能够用四个字节存储更多的字符。
[MySQL使用utf8mb4经验总结](http://seanlook.com/2016/10/23/mysql-utf8mb4/)

##### InnoDB表空间
> MySQL 5.6 版之前的 InnoDB 不支持独立表空间。

* 系统表空间 (system tablespace)
    - innodb_file_per_table 为 OFF
    - 所有表所有数据统一存储,存储文件名 ibdata*
    - 系统表空间存储以下内容
        - InnoDB Data Dictionary
        - doublewrite buffer, the change buffer, and undo logs
        - table and index data

* 独立表空间 (file-per-table tablespace)
    - innodb_file_per_table 为 ON
    - 每个表有自己的独立表空间，每个表的数据和索引单独存储

* 共享通用表空间 (general tablespace)
    - 通过`CREATE TABLESPACE` 语法创建
    - 和系统表空间类似，通用表空间也是在多个表共享表空间存储数据
    - General tablespaces have a potential memory advantage over file-per-table tablespaces. The server keeps tablespace metadata in memory for the lifetime of a tablespace. Multiple tables in fewer general tablespaces consume less memory for tablespace metadata than the same number of tables in separate file-per-table tablespaces.
    - General tablespace data files may be placed in a directory relative to or independent of the MySQL data directory, which provides you with many of the data file and storage management capabilities of file-per-table tablespaces. As with file-per-table tablespaces, the ability to place data files outside of the MySQL data directory allows you to manage performance of critical tables separately, setup RAID or DRBD for specific tables, or bind tables to particular disks, for example
    - General tablespaces support both Antelope and Barracuda file formats, and therefore support all table row formats and associated features. With support for both file formats, general tablespaces have no dependence on innodb_file_format or innodb_file_per_table settings, nor do these variables have any effect on general tablespaces.
    - The TABLESPACE option can be used with CREATE TABLE to create tables in a general tablespaces, file-per-table tablespace, or in the system tablespace
    - The TABLESPACE option can be used with ALTER TABLE to move tables between general tablespaces, file-per-table tablespaces, and the system tablespace. Previously, it was not possible to move a table from a file-per-table tablespace to the system tablespace. With the general tablespace feature, you can now do so.
    - Creating a general tablespace in the data directory:
    ```sql
    mysql> CREATE TABLESPACE `ts1` ADD DATAFILE 'ts1.ibd' Engine=InnoDB;
    ```
    - Creating a general tablespace in a directory outside of the data directory:
    ```sql
    mysql> CREATE TABLESPACE `ts1` ADD DATAFILE '/my/tablespace/directory/ts1.ibd' Engine=InnoDB;
    ```
    - Adding Tables to a General Tablespace
    ```sql
    mysql> CREATE TABLE t1 (c1 INT PRIMARY KEY) TABLESPACE ts1;
    mysql> ALTER TABLE t2 TABLESPACE ts1;
    ```

    > Support for adding table partitions to shared tablespaces was deprecated in MySQL 5.7.24 and will be removed in a future MySQL version. Shared tablespaces include the InnoDB system tablespace and general tablespaces.
