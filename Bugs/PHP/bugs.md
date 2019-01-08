## PHP bugs记录

##### 阻塞

* 耗时页面session阻塞

  - Bug：一个页面有多个ajax请求，并且多个ajax请求页都涉及到session，即都得操作同一个session文件，由于锁定ajax的执行必须是逐个执行的。导致页面加载速度极慢。

  
    > 一个启用了session_start 页面，由于执行时间过长。导致通一个用户访问，另外一个很简单的启用session_start页面一直阻塞着。 直到第一个页面执行完了。第二个页面就可以读取。这个就是，我们常说的，session阻塞机制。

    - 文件存储session

      > session默认以文件保存，当一个用户访问session_start页面后，这个时候，就会默认创建一个包含session_id文件名，并且这个时候，会对文件进行锁定。如果这个用户点击链接，又访问一个该站session_start网页。这是，由于session_id一样，这个页面也有读取锁定该用户存放session文件。 由于，第一个页面没有执行完，它一直锁定了该文件。 第2个页面就不能获取锁，一直处于等待状态。

    - memcache存储session

      > 用memcache保存用户session，相比读取文件有很大速度提升。而且可以做到多服务器共享session。memcached读取时候，是共享的，不会出现等待。但是，memcached连接数，还是会保持着。如果这个时候，你设置的memcached连接数过小，很快memcached就挂死了。

  - Solution：读写session后，立即调用session_write_close，session_commit 函数，释放资源。

    > 通过file或者memcache，如果处理耗时页面，都会带来服务器资源很大消耗。其实我们一般写入session或者读取时候，如果自己能够控制。用完了，就关闭掉文件锁，或者mem连接。就会自动释放资源，其实，php里面的：session_write_close，session_commit 函数就能做到改功能。

##### 配置相关

* `output_buffering`

    - Bug:If output_buffering = Off then ob_end_clean fails to delete buffer

      ```php
      ErrorException (E_NOTICE)
      ob_end_clean(): failed to delete buffer. No buffer to delete
      ```

    - Solution: 修改php.ini配置，`output_buffering=4096`
