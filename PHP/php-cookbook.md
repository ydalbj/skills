PHP Cookbook(PHP经典实例)第三版

### 18 安全和加密

##### 18.1 防止会话固定/劫持攻击

  会话固定攻击是指，服务器会话(session) id固定不变，导致第三方劫持使用该会话id获取认证及授权，冒充他人造成会话劫持攻击。

  解决方案：

    * session_regenerate_id():当用户登录后重新生成会话id
    * 配置session.use_only_cookies=ON（默认开启），仅接受cookie传递的会话id，不接受url传递的会话id
    * 配置session.use_strict_mode=ON(默认disabled，0)，启用后仅已初始化的会话id。

##### 18.2 跨站请求伪造（CSRF）

  在表单提交页面生成一个token，提交表单时验证此token与会话存储的token是否一致。
