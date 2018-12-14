## 常用技巧

##### 查询
* `SQL_CALC_FOUND_ROWS`,`FOUND_ROWS()`的使用

  ```sql
  mysql> SELECT SQL_CALC_FOUND_ROWS * FROM tbl_name
  -> WHERE id > 100 LIMIT 10;
  mysql> SELECT FOUND_ROWS();
  ```
  第二个`SELECT`语句返回一个数字，表示如果没有`LIMIT`子句，第一个`SELECT`返回多少行。
  如果不使用`SQL_CALC_FOUND_ROWS`参数，第二个语句返回的是`LIMIT`限制的行数。

##### 字符编码
* `字符`和`字节`的区别
  - 一个`字节`(`byte`)等于8个`bit`位
  - 字符，是一个单位的字形，类字形单位或符号，指的是字母，数字，字和符号，包括：1、2、3、A、B、C、~！·#￥%……—*（）——+等等。
  - 不同的字符编码，一个字符占用的字节数不一定。ASCII编码中，一个英文字母或数字占一个字节，一个中文汉字占两个字节。

* `varchar`和`char`

* MySQL在 5.5.3 之后增加了 utf8mb4 字符编码，mb4即 most bytes 4。简单说 utf8mb4 是 utf8 的超集并完全兼容utf8，能够用四个字节存储更多的字符。
[MySQL使用utf8mb4经验总结](http://seanlook.com/2016/10/23/mysql-utf8mb4/)
