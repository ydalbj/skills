## Laravel 7 大版本新特性



### Symfony 5 Required

### PHP 7.2.5 Required

### 认证(Authentication)

##### 脚手架

所有认证方式的脚手架都已移至 laravel/ui 仓库。如果您使用的是 Laravel 的认证脚手架，则应该安装此软件的 ^2.0 发行版

```shell
composer require laravel/ui "^2.0"
```

##### Token 存储接口 TokenRepositoryInterface

Illuminate\Auth\Passwords\TokenRepositoryInterface 中新增了 recentlyCreatedToken 方法。如果需要此接口的自定义实现，则应该在实现中添加此方法。

### Blade 模板

##### component 方法

Blade::component 方法已重命名为 Blade::aliasComponent

##### Blade 组件 & “Blade X

Laravel 7 引入了 Blade “组件标签” 的第一方支持。如果你希望禁用 Blade 内置的标签组件功能，你可以在 AppServiceProvider 的 boot 方法中调用 withoutComponentTags 方法

```php
use Illuminate\Support\Facades\Blade;

Blade::withoutComponentTags();
```

### Eloquent

##### addHidden / addVisible 方法

未被文档提及的 addHidden 及 addVisible 方法已被移除。请使用 makeHidden 及 makeVisible 方法

##### booting / booted 方法

booting 及 booted 已被添加至 Eloquent 以提供一个方便地定义在 “Boot” 过程中执行逻辑的地方。如果你的模型已包含了相同名字的方法，你将需要重命名你的方法以避免冲突

##### 日期序列化
在 Eloquent 模型上使用 toArray 或 toJson 方法时，Laravel 7 将使用新的日期序列化格式。为了格式化日期以进行序列化，Laravel 将会使用 Carbon 的 toJSON 方法，该方法将生成与 ISO-8601 兼容的日期，包括时区信息及小数秒。此外，该更改提供了更好的支持，并与客户端如期解析库集成。

此前，日期将序列化为以下格式：2020-03-04 16:11:00 。使用新格式进行序列化的日期将显示为：2020-03-04T20:01:00.283041Z

如果你希望继续保持之前所用的格式，你可以重写模型的 serializeDate 方

```php
/**
 * 为数组 / JSON 序列化准备日期。
 *
 * @param  \DateTimeInterface  $date
 * @return string
 */
protected function serializeDate(DateTimeInterface $date)
{
    return $date->format('Y-m-d H:i:s');
}
```

### 工厂类型
Laravel 7 移除了「工厂类型」特性。该特性自 2016 年十月起已未被文档提及。如果你仍在使用此特性，你应该升级至 工厂状态 以提供更大的灵活性

### getOriginal方法
$model->getOriginal() 方法执行在模型中定义的强制类型转换。此前，此方法返回未被修改的原始属性。如今，如果你希望获取未经修改的原始属性，请使用 getRawOriginal 方法。

### 路由绑定

Illuminate\Contracts\Routing\UrlRoutable 的方法 resolveRouteBinding 现在接受一个 $field 参数。如果您已手动实现此接口，则需要更新其实现。

此外，Illuminate\Database\Eloquent\Model 类的 resolveRouteBinding 方法现在还接受一个 $field 参数。如果要覆盖此方法，则应更新方法以接受此参数。

最后，trait Illuminate\Http\Resources\DelegatesToResources 的 resolveRouteBinding 方法现在还接受一个 $field 参数。如果要覆盖此方法，则应更新方法以接受此参数

### HTTP

##### PSR-7 兼容性
不推荐使用 Zend Diactoros 库来生成 PSR-7 响应。如果您将此软件包用于 PSR-7 兼容性，请安装 nyholm/psr7 的 Composer 包。另外，请安装 symfony/psr-http-message-bridge 的 ^2.0 发行版 Composer 包

### 邮件
##### 配置文件更改

为支持多个邮件驱动，Laravel 7 中默认的 mail 配置文件已更改为包含 mailers 数组。然而，为了保持向后兼容性，仍支持 Laravel 6 格式的配置文件。因此，升级到 Laravel 7 时，无需进行任何更改。但是，你可能想要查看 新的 mail 配置文件 的结构并更新文件

##### Markdown 邮件模板更新
默认的 Markdown 邮件模板已被更新为更专业及具吸引力的设计。另外，文档未提及的 promotion Markdown 邮件组件已被移除

### 队列
##### 已被弃用的 --daemon 标识已被移除
早前弃用的 queue:work 命令的 --daemon 标识已被正式移除。由于队列现在默认以守护进程的方式运行，因此，你不再需要该标识符

### 资源
弃用的 Illuminate\Http\Resources\Json\Resource 类已被正式移除。你的资源应当继承 Illuminate\Http\Resources\Json\JsonResource 类作为替代

### 路由
##### Router getRoutes 方法

由器（Router）的 getRoutes 方法如今不再返回 Illuminate\Routing\RouteCollection 实例，取而代之的是 Illuminate\Routing\RouteCollectionInterface 实例

### Session

array Session 驱动存储的数据现在可于当前请求中访问。过去，array Session 中存储的数据无法被当前请求访问

### 测试

TestResponse 类中的 assertSee 及 assertDontSee 断言将会自动转换值。你不需再继续手动转换传递给这些断言的值

### 验证
different 规则如今将会在其中一个参数缺失时失败
