## Mysql语句语法技巧

### 参考链接
[database guide](https://database.guide/)
[mysql中concat 和 group_concat()的用法](https://www.cnblogs.com/zhming26/p/6382995.html)

### 函数

- CONCAT, CONCAT_WS, GROUP_CONCAT

    * CONCAT
    ```mysql
    SELECT CONCAT('My', NULL, 'QL'); // NULL
    SELECT CONCAT_WS(NULL,'First name', 'Last Name'); // NULL
    CONCAT_WS(',','First name',NULL,'Last Name'); // First name,Last Name
    ```

    * GROUP_CONCAT

        参考链接 [How to use GROUP_CONCAT in a CONCAT in MySQL](https://stackoverflow.com/questions/13451605/how-to-use-group-concat-in-a-concat-in-mysql)
    > GROUP_CONCAT([DISTINCT] expr [,expr ...]
    > [ORDER BY {unsigned_integer | col_name | formula} [ASC | DESC] [,col ...]]
    > [SEPARATOR str_val])

    > (下列语句为个人记录，其他人可忽略)调查打标工具，重复分配任务
    ```mysql
    select taskids,count(*) from (
        SELECT product_id, group_concat(taskid SEPARATOR '-') as taskids, count(*) as c  FROM 58fd.tagtask_product where created_at > '2018-11-14'
        AND taskid in (SELECT id FROM tagtask WHERE created_at>'2018-11-14' AND `status`>-1)
        group by product_id having c> 1
    ) as tt group by taskids;
    ```
