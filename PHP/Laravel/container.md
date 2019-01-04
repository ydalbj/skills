## Laravel Container

### 参考资料

[What is Dependency Injection](http://fabien.potencier.org/what-is-dependency-injection.html)

[Dependency Injection in Laravel](https://medium.com/a-young-devoloper/how-laravel-injects-our-dependencies-14e1b1a044e)

[Laravel Container容器 概念详解 上](https://segmentfault.com/a/1190000011433540)

[Laravel Container (容器) 深入理解 (下)](https://laravel-china.org/articles/6158/laravel-container-container-understand-below)


### Dependency Injection 概念原理

* 大多数时候，Dependency Injection 并不需要 Container

* Dependency Injection Container 是一个“知道如何实例化和配置对象”的对象（工厂模式的升华）

* Container 管理对象实例化到配置的过程

* 对象本身不知道自己是由 Container 管理的，对 Container 一无所知

* 依赖注入 并不限于构造函数 (还有setter方法，属性注入)


  ```php
  class Container
  {
    public function getMailTransport()
    {
      return new Zend_Mail_Transport_Smtp('smtp.gmail.com', [
        'auth'     => 'login',
        'username' => 'foo',
        'password' => 'bar',
        'ssl'      => 'ssl',
        'port'     => 465,
      ]);
    }

    public function getMailer()
    {
      $mailer = new Zend_Mail();
      $mailer->setDefaultTransport($this->getMailTransport());

      return $mailer;
    }
  }
  ```

### Container

##### Laravel Container

  * 几乎所有的服务容器绑定都是在 服务提供器

  * 如果类没有依赖任何接口，就没有必要将类绑定到容器中。

  * 在服务提供器中，你总是可以通过 $this->app 属性访问容器。

  * 解析实例:使用 make 方法从容器中解析出类实例。如果你的代码处于无法访问 $app 变量的位置，则可用全局辅助函数 resolve($name) 或 app($name)来解析。

  * 服务提供器是所有 Laravel 应用程序的引导中心，是配置应用程序的中心。引导可以理解为注册，比如注册服务容器绑定，事件监听器，中间件，甚至是路由。

    - `$app` 属性

      > 在服务提供器中可以通过`$this->app`访问服务容器

    - 服务提供器有两个方法`register`和`boot`

    - `register`方法

      > 在 register 方法中， 你只需要将事物绑定到 服务容器。而不要尝试在 register 方法中注册任何监听器，路由，或者其他任何功能

      - `bindings` 和 `singletons` 特性

        > 如果你的服务提供器注册了许多简单的绑定，你可能想用 bindings 和 singletons 属性替代手动注册每个容器绑定。当服务提供器被框架加载时，将自动检查这些属性并注册相应的绑定

        ```php
        // 设定所有的容器绑定的对应关系
        public $bindings = [
            ServerProvider::class => DigitalOceanServerProvider::class,
        ];

        // 设定所有的单例模式容器绑定的对应关系
        public $singletons = [
          DowntimeNotifier::class => PingdomDowntimeNotifier::class,
        ];

        ```

    - `boot`方法

      > 该方法在所有服务提供者被注册以后才会被调用

      > Boot 方法的依赖注入

      ```php
      public function boot(ResponseFactory $response)
      {
          $response->macro('caps', function ($value) {
              //
          });
      }
      ```

  * 注册服务提供者

    > 通过配置文件 config/app.php 进行注册

    > 通过composer.json文件注册

  * 延迟服务提供者

    > 如果你的服务提供者 仅 在 服务容器 中注册，可以选择延迟加载该绑定直到注册绑定的服务真的需要时再加载，延迟加载这样的一个提供者将会提升应用的性能，因为它不会在每次请求时都从文件系统加载。

    > Laravel 编译并保存延迟服务提供者提供的所有服务的列表，以及其服务提供者类的名称。因此，只有当你在尝试解析其中一项服务时，Laravel 才会加载服务提供者

    > 要延迟加载一个提供者，设置 defer 属性为 true 并设置一个 provides 方法。 provides 该方法返回该提供者注册的服务容器绑定

    ```php
    protected $defer = true;

    ...

    public function provides()
    {
        return [Connection::class];
    }
    ```

##### 在 Laravel 之外使用 Illuminate\Container

  ```shell
  $ composer require illuminate/container
  ```

  ```php
  include './vendor/autoload.php';

  use Illuminate\Container\Container;
  $container = Container::getInstance();
  ```

##### 基本用法，用type hint (类型提示) 注入 依赖

  > Container 使用 Reflection (反射) 来找到并实例化构造函数参数中的那些类，实现起来并不复杂，以后的文章里再介绍。

  > $this->app 代表的容器一般指Laravel容器。$container 代表通用容器。


##### Binding Interfaces to Implementations (绑定接口到实现)

  ```php
  $container->bind(MyInterface::class, MyClass::class);
  $instance = $container->make(MyInterface::class);
  ```

##### Binding Abstract & Concret Classes （绑定抽象类和具体类）

  ```php
  $container->bind(MyAbstract::class, MyConcreteClass::class);
  ```

##### 自定义绑定

  ```php
  $container->bind(GitHub\Client::class, function (Container $container) {
    $client = new GitHub\Client;
    $client->setEnterpriseUrl(GITHUB_HOST);
    return $client;
  });
  ```

##### 容器事件

  > 服务容器每次解析对象时会触发一个事件，你可以使用 resolving 方法监听这个事件。被解析的对象将被传入回调函数，这使得你能够在对象被传给调用者之前给它设置额外的属性

  ```php
  $this->app->resolving(function ($object, $app) {
    // Called when container resolves object of any type...
  });

  $this->app->resolving(HelpSpot\API::class, function ($api, $app) {
      // Called when container resolves objects of type "HelpSpot\API"...
  });
  ```

  还可以注册成「什么类解析完之后都调用」
  ```php
  $container->resolving(function ($object, Container $container) {
    // ...
  });
  ```

##### Extending a Class (扩展一个类)

  > 使用 extend() 方法，可以封装一个类然后返回一个不同的对象 (装饰模式)：

  ```php
  $container->extend(APIClient::class, function ($client, Container $container) {
    return new APIClientDecorator($client);
  });
  ```

##### 单例

  ```php
  $container->singleton(Cache::class, RedisCache::class);
  ```

##### Arbitrary Binding Names (任意绑定名称)

  > Container 还可以绑定任意字符串而不是类/接口名称。但这种情况下不能使用类型提示，并且只能用 make() 来获取实例。

  ```php
  $container->bind('database', MySQLDatabase::class);
  $db = $container->make('database');
  ```

  > 为了同时支持类/接口名称和短名称，可以使用 alias()

  ```php
  $container->singleton(Cache::class, RedisCache::class);
  $container->alias(Cache::class, 'cache');

  $cache1 = $container->make(Cache::class);
  $cache2 = $container->make('cache');

  assert($cache1 === $cache2);
  ```

##### 保存任何值

  > Container 还可以用来保存任何值，例如 configuration 数据

  ```php
  $container->instance('database.name', 'testdb');
  $db_name = $container->make('database.name');
  ```

  > 因为 Container 实现了 PHP 的 ArrayAccess 接口，所以支持数组访问语法

  ```php
  $container['database.name'] = 'testdb';
  $db_name = $container['database.name'];
  ```

  > 当处理 Closure 绑定的时候，你会发现这个方式非常好用

  ```php
  $container->singleton('database', function (Container $container) {
    return new MySQLDatabase(
        $container['database.host'],
        $container['database.name'],
        $container['database.user'],
        $container['database.pass']
    );
  });
  ```

  > Laravel 自己没有用这种方式来处理配置项，它使用了一个单独的 Config 类本身。 PHP-DI 用了

  > 数组访问语法还可以代替 make() 来实例化对象

  ```php
  $db = $container['database'];
  ```

##### Dependency Injection for Functions & Methods (给函数或方法注入依赖)

  > 除了给构造函数注入依赖，Laravel 还可以往任意函数中注入

  ```php
  function do_something(Cache $cache) { /* ... */ }
  $result = $container->call('do_something');
  ```

  > 函数的附加参数可以作为索引或关联数组传递

  ```php
  function show_product(Cache $cache, $id, $tab = 'details') { /* ... */ }

  // show_product($cache, 1)
  $container->call('show_product', [1]);
  $container->call('show_product', ['id' => 1]);

  // show_product($cache, 1, 'spec')
  $container->call('show_product', [1, 'spec']);
  $container->call('show_product', ['id' => 1, 'tab' => 'spec']);
  ```

  ```php
  // 闭包
  $closure = function (Cache $cache) { /* ... */ };
  $container->call($closure);

  // 静态方法
  $container->call(['SomeClass', 'staticMethod']);
  // or:
  $container->call('SomeClass::staticMethod');

  // 实例的方法
  $controller = $container->make(PostController::class);
  $container->call([$controller, 'index']);
  $container->call([$controller, 'show'], ['id' => 1]);

  // 实例方法的快捷方式
  $container->call('PostController@index');
  $container->call('PostController@show', ['id' => 4]);

  // 用接口或任何名称来代替具体类
  $container->singleton('post', PostController::class);
  $container->call('post@index');

  // 还可以传一个「默认方法」作为第三个参数。如果第一个参数是没有指定方法的类名称，则将调用默认方法。
  // Laravel 用这种方式来处理 event handlers :
  $container->call(MyEventHandler::class, $parameters, 'handle');
  // 相当于:
  $container->call('MyEventHandler@handle', $parameters);
  ```

##### Method Call Bindings (方法调用绑定)

  > bindMethod() 方法可用来覆盖方法，例如用来传递其他参数
  > 注意：这种方式不是 Container 接口 的一部分，只有在它的实现类 Container 才有。

  ```php
  $container->bindMethod('PostController@index', function ($controller, $container) {
    $posts = get_posts(...);

    return $controller->index($posts);
  });


  $container->call('PostController@index');
  $container->call('PostController', [], 'index');
  $container->call([new PostController, 'index']);

  // 但是，call() 的任何其他参数都不会传递到闭包中，因此不能使用它们
  // $container->call('PostController@index', ['Not used :-(']);
  ```

##### Contextual Bindings (上下文绑定)

  ```php
  $container
    ->when(PhotoController::class)
    ->needs(Filesystem::class)
    ->give(LocalFilesystem::class);

  $container
    ->when(VideoController::class)
    ->needs(Filesystem::class)
    ->give(S3Filesystem::class);

  // 现在 PhotoController 和 VideoController 都依赖了 Filesystem 接口，但是收到了不同的实例
  ```

  ```php
  // 闭包
  ...
    ->when(VideoController::class)
    ->needs(Filesystem::class)
    ->give(function () {
        return Storage::disk('s3');
    });

  // 短名称
  ...
  $container->instance('s3', $s3Filesystem);

  $container
    ->when(VideoController::class)
    ->needs(Filesystem::class)
    ->give('s3');
  ```

##### Binding Parameters to Primitives (绑定初始数据)

  > 当有一个类不仅需要接受一个注入类，还需要注入一个基本值（比如整数）。
还可以通过将变量名称 (而不是接口) 传递给 needs() 并将值传递给 give() 来注入需要的任何值 (字符串、整数等) ：

  ```php
  $container
    ->when(MySQLDatabase::class)
    ->needs('$username')
    ->give(DB_USER);

  $container
    ->when(MySQLDatabase::class)
    ->needs('$username')
    ->give(function () {
        return config('database.user');
    });
  ```

##### Tagging (标记)

  > Container 可以用来「标记」有关系的绑定

  ```php
  $container->tag(MyPlugin::class, 'plugin');
  $container->tag(AnotherPlugin::class, 'plugin');

  // 这样会以数组的形式取回所有「标记」的实例
  foreach ($container->tagged('plugin') as $plugin) {
    $plugin->init();
  }

  // tag() 方法的两个参数都可以接受数组
  $container->tag([MyPlugin::class, AnotherPlugin::class], 'plugin');
  $container->tag(MyPlugin::class, ['plugin', 'plugin.admin']);
  ```

###### Rebinding (重新绑定)

  > 这个功能很少用到，可以跳过，仅供参考

##### Overriding Constructor Parameters (重写构造函数参数)

  > makeWith 方法允许将附加参数传递给构造函数。它忽略任何现有的实例或单例，可以用于创建具有不同参数的类的多个实例，同时仍然注入依赖关系：

  ```php
  class Post
  {
    public function __construct(Database $db, int $id) { /* ... */ }
  }

  ...

  $post1 = $container->makeWith(Post::class, ['id' => 1]);
  $post2 = $container->makeWith(Post::class, ['id' => 2]);
  ```

  注意：Laravel 5.3 及以下使用 make($class, $parameters)。Laravel 5.4 中移除了此方法，但是在 5.4.16 以后又重新加回来了 makeWith() 。详见[PR](https://github.com/laravel/framework/pull/19201)


##### 其他常用方法

  * bound

    > 如果一个类/名称已经被 bind() , singleton() ，instance() 或 alias() 绑定，那么 bound() 方法返回 true


    ```php
    if (! $container->bound('database.user')) {
      // ...
    }

    //还可以使用数组访问语法和 isset()
    if (! isset($container['database.user'])) {
      // ...
    }

    //可以使用 unset() 来重置它，这会删除指定的绑定/实例/别名
    unset($container['database.user']);
    var_dump($container->bound('database.user')); // false
    ```
  * bindIf()

    > bindIf() 和 bind() 功能类似，差别在于只有在现有绑定不存在的情况下才注册绑定。 它一般被用在 package 中注册一个可被用户重写的默认绑定

    > 不过并没有 singletonIf() 方法，只能用 bindIf($abstract, $concrete, true) 来实现

    ```php
    $container->bindIf(Loader::class, FallbackLoader::class, true);

    // 相当于
    if (! $container->bound(Loader::class)) {
      $container->singleton(Loader::class, FallbackLoader::class);
    }

  * resolved()

    > 如果一个类已经被解析，resolved() 方法会返回 true

    ```php
    var_dump($container->resolved(Database::class)); // false
    $container->make(Database::class);
    var_dump($container->resolved(Database::class)); // true
    ```
