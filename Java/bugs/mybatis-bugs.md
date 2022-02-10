### MyBatis相关bugs总结

##### MyBatis-Generator生成xml代码重复问题

- MyBatis-generator版本1.4

- 报错信息

    ```
    java.lang.IllegalArgumentException: Result Maps collection already contains value for ...
    ```

- 解决方法

    mybatis-generator.xml文件中添加plugin [解决方案链接](https://blog.csdn.net/future_god_qr/article/details/122309780?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1.pc_relevant_default&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1.pc_relevant_default&utm_relevant_index=2)

    `<plugin type="org.mybatis.generator.plugins.UnmergeableXmlMappersPlugin" />`

