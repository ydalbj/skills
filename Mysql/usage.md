# 基本用法

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
