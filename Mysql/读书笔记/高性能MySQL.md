
## 第五章 创建高性能的索引

### 索引的类型

  - B-Tree索引
  - 哈希索引
  - 空间数据索引(R-Tree)
  - 全文索引

##### B-Tree索引

  - InnoDB 使用的B+Tree
  - B-Tree通常意味着所有的值都是按顺序存储的，并且每一个叶子页到根的距离相同
  - B-Tree索引适用于全键值、键值范围或键前缀查找

##### 哈希索引
  - 哈希索引只包含哈希值和行指针，而不存储字段值，所以不能使用索引中的值来避免读取行。不过，访问内存中的行的速度很快，所以大部分情况下这一点对性能的影响并不明显。
  - 哈希索引数据并不是按照索引值顺序存储的，所以也就无法用于排序。
  - 哈希索引只支持等值比较查询，包括=、IN()、<=>（注意<>和<=>是不同的操作）。也不支持任何范围查询，例如WHERE price>100
  - 访问哈希索引的数据非常快，除非有很多哈希冲突（不同的索引列值却有相同的哈希值）。当出现哈希冲突的时候，存储引擎必须遍历链表中所有的行指针，逐行进行比较，直到找到所有符合条件的行
  - 如果哈希冲突很多的话，一些索引维护操作的代价也会很高。

##### 创建自定义哈希索引
  如果存储引擎不支持哈希索引，则可以模拟像InnoDB一样创建哈希索引。思路很简单：在B-Tree基础上创建一个伪哈希索引。这和真正的哈希索引不是一回事，因为还是使用B-Tree进行查找，但是它使用哈希值而不是键本身进行索引查找。你需要做的就是在查询的WHERE子句中手动指定使用哈希函数。例如要在一个长的字符串类型字段上建索引(比如url)，可以增加一列 url_crc。
  ```sql
    SELECT id FROM url WHERE url="http://www.mysql.com";
  ```

  ```sql
    SELECT id FROM url WHERE url="http://www.mysql.com" AND url_crc=CRC32("http://www.mysql.com");
  ```

  这样实现的缺陷是需要维护哈希值。可以手动维护，也可以使用触发器实现。
  ```sql
    DELIMITER //
    CREATE TRIGGER pseudohash_crc_ins BEFORE INSERT ON pseudohash FOR EACH ROW BEGIN
    SET NEW.url_crc=crc32(NEW.url);
    END;
    //
    CREATE TRIGGER pseudohash_crc_upd BEFORE UPDATE ON pseudohash FOR EACH ROW BEGIN
    SET NEW.url_crc=crc32(NEW.url);
    END;
    //
    DELIMITER ;
  ```

### 5.3 高性能的索引策略

##### 5.3.1 独立的列

  “独立的列”是指索引列不能是表达式的一部分，也不能是函数的参数
  ```sql
  SELECT actor_id FROM sakila.actor WHERE actor_id + 1 = 5;
  ```

##### 5.3.2 前缀索引和索引选择性

  有时候需要索引很长的字符列，这会让索引变得大且慢。一个策略是前面提到过的模拟哈希索引。但有时候这样做还不够。
  通常可以索引开始的部分字符，这样可以大大节约索引空间，从而提高索引效率。但这样也会降低索引的选择性。索引的选择性是指，不重复的索引值（也称为基数，cardinality）和数据表的记录总数（#T）的比值，范围从1/#T到1之间。索引的选择性越高则查询效率越高，因为选择性高的索引可以让MySQL在查找时过滤掉更多的行。唯一索引的选择性是1，这是最好的索引选择性，性能也是最好的。

  诀窍在于要选择足够长的前缀以保证较高的选择性，同时又不能太长（以便节约空间）。
