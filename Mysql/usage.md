# 基本用法

SQL-cookbook

### 检索记录

##### 空值转实际值

  * `coalesce`函数

    ```sql
    select coalesce(comm, 0) from emp;
    select coalesce(null, 1);
    select coalesce(null, null, null, 1);
    ```
  * `case when`

    ```sql
    CASE input_expression
    WHEN when_expression THEN
        result_expression [...n ] [
    ELSE
        else_result_expression
    END
    ```

    ```sql
    CASE
    WHEN Boolean_expression THEN
        result_expression [...n ] [
    ELSE
        else_result_expression
    END
    ```

    ```sql
    select case
        when comm is null then 0
        else comm
        end
      from emp
    ```

### 排序

##### 按子串排序(substr函数)

  ```sql
  select ename, job from emp order by substr(job, length(job)-2)
  ```

##### 处理排序空值
  
  使用CASE表达式来标记一个值是否为null。
  将null值排在后边
  ```sql
  select a,b,c from (select a,b,c case when c is null then 0 else 1 end as is_null from t) x order by is_null desc, c
  ```

##### 根据数据项的键排序

  问题：要根据某些条件逻辑来排序。例如JOB是“salesman”,要根据comm排序，否则根据sal排序。

  ```sql
  select ename,sal,job,comm from emp order by case when job = 'salesman' then comm else sal end
  ```

  ```sql
  select ename,sal,job,comm,case when job = 'salesman' then comm else sal end as ordered from emp order by 5
  ```

### 操作多个表

##### 记录集的叠加

  `union`:Union：对两个结果集进行并集操作，不包括重复行，同时进行默认规则的排序；
  `union all`:对两个结果集进行并集操作，包括重复行，不进行排序；

  ```sql
  select employee_id,job_id from employees
  union all
  select employee_id,job_id from job_history
  ```
