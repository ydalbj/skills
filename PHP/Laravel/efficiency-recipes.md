## 提升效率技巧

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

