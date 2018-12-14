### PHP基本语法使用总结

##### 字符编码

* 汉字和Unicode码(utf-8)之间的转换(Pack/Unpack)
  ```php
  $cnStr = "中"; //utf8的中文
 
  //unicode
  $code = unpack("H6codes", $cnStr);
  
  //汉字
  $cnStr = pack("H6", $code['codes']);
  ```
  > pack/unpack很强大,, 和c语言交换数据, 二进制方式的序列化,操作二进制文件.. etc…
