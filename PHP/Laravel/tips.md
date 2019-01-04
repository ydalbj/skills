## Laravel Tips

> 参考链接 [Laravel学院](https://laravelacademy.org/post/8203.html)

##### Eloquent

- 统计关联模型

    > 如果你想要在不加载关联关系的情况下统计关联结果数目，可以使用 withCount 方法，该方法会放置一个 {relation}_count 字段到结果模型。例如：

    ```php
    $posts = App\Post::withCount('comments')->get();

    foreach ($posts as $post) {
        echo $post->comments_count;
    }
    ```

- 渴求式加载指定字段

    > 并不是每次获取关联关系时都需要所有字段，因此，Eloquent 允许你在关联查询时指定要查询的字段：

    ```php
    $users = App\Book::with('author:id,name')->get();
    ```
    > 注：使用这个特性时，关联表id 字段以及主表外键字段是必须列出的。

- whereIn()查询，按照数组参数顺序排序
    ```php
    $products = Product::query()
    ->whereIn('id', $productIds)
    // orderByRaw 可以让我们用原生的 SQL 来给查询结果排序
    ->orderByRaw(sprintf("FIND_IN_SET(id, '%s')", join(',', $productIds)))
    ->get();
    ```

- `chunkById` vs `chunk`

  * `chunkById` 移动`id`起始位置和`limit`来分片;
  ```sql
  SELECT * FROM users WHERE id > ? ORDER BY id LIMIT 100;
  ```
  * `chunk` 使用`offset`分片;当offset越大，性能越低;所以`chunkById性能较好`

  [Laravel Database——查询构造器与语法编译器源码分析 (中)](https://laravel-china.org/articles/6249/laravel-database-query-constructor-and-syntax-compiler-source-code-analysis-in?order_by=vote_count&)

