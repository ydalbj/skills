## PHP bugs记录

##### 配置相关

* `output_buffering`

    - BUG:If output_buffering = Off then ob_end_clean fails to delete buffer

    ```php
    ErrorException (E_NOTICE)
    ob_end_clean(): failed to delete buffer. No buffer to delete
    ```

        > Solution: 修改php.ini配置，`output_buffering=4096`
