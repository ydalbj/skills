# PHPUnit总结

## The `UNIT` in unit testing

  > A `UNIT` is the smallest testable part of an application

  * 最小可测单元指类的行为，而非类的方法

    [The UNIT in unit testing](http://edorian.github.io/2012-03-14-The-UNIT-in-unit-testing/)

## 用法(Usage)

### 测试替身(Test Doubles )

  > PHPUnit 提供的 createMock($type) 和 getMockBuilder($type) 方法可以在测试中用来自动生成对象，此对象可以充当任意指定原版类型（接口或类名）的测试替身。

  * `getMockBuilder($type)`

    > getMockBuilder($type)->getMock(); 获取测试替身

  * `createMock($type)`

    > 此测试替身的创建使用了最佳实践的默认值（不执行原始类的 __construct() 和 __clone() 方法，且不对传递给测试替身的方法的参数进行克隆）

      `createMock`等同于
      ```php
              $stub = $this->getMockBuilder(SomeClass::class)
                     ->disableOriginalConstructor()
                     ->disableOriginalClone()
                     ->disableArgumentCloning()
                     ->disallowMockingUnknownTypes()
                     ->getMock();
      ```

  * 在默认情况下，原版类的所有方法都会被替换为只会返回 null 的伪实现（其中不会调用原版方法）。使用诸如 will($this->returnValue()) 之类的方法可以对这些伪实现在被调用时应当返回什么值做出配置。

  * 请注意，final、private 和 static 方法无法对其进行上桩(stub)或模仿(mock)。PHPUnit 的测试替身功能将会忽略它们，并维持它们的原始行为。

##### stubs

  * 使用一个配置好返回值的测试替身(Test Double)代替一个真实对象的方法叫做上桩(`stubbing`)

    ```php
        $stub = $this->createMock(SomeClass::class);

        // Configure the stub.
        $stub->method('doSomething')
             ->willReturn('foo');

        // Calling $stub->doSomething() will now return
        // 'foo'.
        $this->assertSame('foo', $stub->doSomething());
    ```

  * 方法名为`method`,不能用以上方法。需要用下列方法

    ```php
    $stub->expects($this->any())->method('doSomething')->willReturn('foo');
    ```

  * `willReturn($value)` 同 `will($this->returnValue($value))`

  * `returnArgument()`

    ```php
        $stub = $this->createMock(SomeClass::class);

        // Configure the stub.
        $stub->method('doSomething')
             ->will($this->returnArgument(0));

        // $stub->doSomething('foo') returns 'foo'
        $this->assertSame('foo', $stub->doSomething('foo'));

        // $stub->doSomething('bar') returns 'bar'
        $this->assertSame('bar', $stub->doSomething('bar'));
    ```

  * `returnSelf()` 返回stub object自身引用

    ```php
        $stub = $this->createMock(SomeClass::class);

        // Configure the stub.
        $stub->method('doSomething')
             ->will($this->returnSelf());

        // $stub->doSomething() returns $stub
        $this->assertSame($stub, $stub->doSomething());
    ```

  * `returnValueMap()`返回与参数相关的值

    ```php
        $stub = $this->createMock(SomeClass::class);

        // Create a map of arguments to return values.
        $map = [
            ['a', 'b', 'c', 'd'],
            ['e', 'f', 'g', 'h']
        ];

        // Configure the stub.
        $stub->method('doSomething')
             ->will($this->returnValueMap($map));

        // $stub->doSomething() returns different values depending on
        // the provided arguments.
        $this->assertSame('d', $stub->doSomething('a', 'b', 'c'));
        $this->assertSame('h', $stub->doSomething('e', 'f', 'g'));
    ```
  * `returnCallback()` 使用回调函数返回值

    ```php
        $stub = $this->createMock(SomeClass::class);

        // Configure the stub.
        $stub->method('doSomething')
             ->will($this->returnCallback('str_rot13'));

        // $stub->doSomething($argument) returns str_rot13($argument)
        $this->assertSame('fbzrguvat', $stub->doSomething('something'));
    ```

  * `onConsecutiveCalls()` 指定一组期待值列表

    ```php
        $stub = $this->createMock(SomeClass::class);

        // Configure the stub.
        $stub->method('doSomething')
             ->will($this->onConsecutiveCalls(2, 3, 5, 7));

        // $stub->doSomething() returns a different value each time
        $this->assertSame(2, $stub->doSomething());
        $this->assertSame(3, $stub->doSomething());
        $this->assertSame(5, $stub->doSomething());
    ```

  * `throwException()` 除了指定返回值，也可以抛出一个异常
    ```php
        $stub = $this->createMock(SomeClass::class);

        // Configure the stub.
        $stub->method('doSomething')
             ->will($this->throwException(new Exception));

        // $stub->doSomething() throws Exception
        $stub->doSomething();
    ```

##### Mock Objects

  > 将对象替换为能验证预期行为（例如断言某个方法必会被调用）的测试替身的实践方法称为`模仿(mocking)`

  > 由于关注的是检验某个方法是否被调用，以及调用时具体所使用的参数，因此引入 expects() 与 with() 方法来指明此交互应该是什么样的。

  * 测试某个方法会以特定参数被调用一次

    ```php
        // 为 Observer 类建立仿件对象，只模仿 update() 方法。
        $observer = $this->getMockBuilder(Observer::class)
                         ->setMethods(['update'])
                         ->getMock();

        // 建立预期状况：update() 方法将会被调用一次，
        // 并且将以字符串 'something' 为参数。
        $observer->expects($this->once())
                 ->method('update')
                 ->with($this->equalTo('something'));

        // 创建 Subject 对象，并将模仿的 Observer 对象连接其上。
        $subject = new Subject('My subject');
        $subject->attach($observer);

        // 在 $subject 对象上调用 doSomething() 方法，
        // 预期将以字符串 'something' 为参数调用
        // Observer 仿件对象的 update() 方法。
        $subject->doSomething();
    }
    ```
  * 测试某个方法将会被调用一次，并且以某个特定对象作为参数

    ```php
        $expectedObject = new stdClass;

        $mock = $this->getMockBuilder(stdClass::class)
                     ->setMethods(['foo'])
                     ->getMock();

        $mock->expects($this->once())
             ->method('foo')
             ->with($this->identicalTo($expectedObject));

        $mock->foo($expectedObject);
    ```

  * 创建仿件对象时启用参数克隆

    ```php
        $mock = $this->getMockBuilder(stdClass::class)
                     ->enableArgumentCloning()
                     ->getMock();

        // 现在仿件将对参数进行克隆，因此 identicalTo 约束将会失败。
        # 目前不太清楚为什么会失效
    }
    ```

  * 匹配器

    匹配器 |	含义
    ------|------
    PHPUnit_Framework_MockObject_Matcher_AnyInvokedCount any() |	返回一个匹配器，当被评定的方法执行0次或更多次（即任意次数）时匹配成功。
    PHPUnit_Framework_MockObject_Matcher_InvokedCount never()| 	返回一个匹配器，当被评定的方法从未执行时匹配成功。
    PHPUnit_Framework_MockObject_Matcher_InvokedAtLeastOnce atLeastOnce() |	返回一个匹配器，当被评定的方法执行至少一次时匹配成功。
    PHPUnit_Framework_MockObject_Matcher_InvokedCount once() |	返回一个匹配器，当被评定的方法执行恰好一次时匹配成功。
    PHPUnit_Framework_MockObject_Matcher_InvokedCount exactly(int $count) |	返回一个匹配器，当被评定的方法执行恰好 $count 次时匹配成功。
    PHPUnit_Framework_MockObject_Matcher_InvokedAtIndex at(int $index)	返回一个匹配器，当被评定的方法是第 $index 个执行的方法时匹配成功。

  * getMockBuilder($type) 方法来用流畅式接口定制测试替身的生成过程

    - setMethods(array $methods)：指定哪些方法将被替换为可配置的测试替身。其他方法的行为不会有所改变。如果调用 setMethods(null)，那么没有方法会被替换。

    - setConstructorArgs(array $args)：可用于向原版类的构造函数（默认情况下不会被替换为伪实现）提供参数数组。

    - setMockClassName($name)：可用于指定生成的测试替身类的类名

    - disableOriginalConstructor()：参数可用于禁用对原版类的构造方法的调用。

    - disableOriginalClone()：可用于禁用对原版类的克隆方法的调用。

    - disableAutoload()``可用于在测试替身类的生成期间禁用 ``__autoload()

##### Prophecy

  > Prophecy 是个“极为自我却又非常强大且灵活的 PHP 对象模仿框架。PHPUnit 对用 Prophecy 建立测试替身提供了内建支持。

  * 测试某个方法会以特定参数被调用一次

    ```php
        $subject = new Subject('My subject');

        // 为 Observer 类建立预言(prophecy)。
        $observer = $this->prophesize(Observer::class);

        // 建立预期状况：update() 方法将会被调用一次，
        // 并且将以字符串 'something' 为参数。
        $observer->update('something')->shouldBeCalled();

        // 揭示预言，并将仿件对象链接到主体上。
        $subject->attach($observer->reveal());

        // 在 $subject 对象上调用 doSomething() 方法，
        // 预期将以字符串 'something' 为参数调用
        // Observer 仿件对象的 update() 方法。
        $subject->doSomething();
    ```

    [Prophecy 文档](https://github.com/phpspec/prophecy#how-to-use-it)


##### Mocking Traits and Abstract Classes

```php
use PHPUnit\Framework\TestCase;

trait AbstractTrait
{
    public function concreteMethod()
    {
        return $this->abstractMethod();
    }

    public abstract function abstractMethod();
}

class TraitClassTest extends TestCase
{
    public function testConcreteMethod()
    {
        $mock = $this->getMockForTrait(AbstractTrait::class);

        $mock->expects($this->any())
             ->method('abstractMethod')
             ->will($this->returnValue(true));

        $this->assertTrue($mock->concreteMethod());
    }
}
```

##### 对文件系统进行模仿

  > vfsStream 可用于模仿真实文件系统

  > vfsStream is a stream wrapper for a [virtual filesystem](http://en.wikipedia.org/wiki/Virtual_file_system) that may be helpful in unit tests to mock the real filesystem.

  > composer require --dev mikey179/vfsStream
  ```json
  {
    "require-dev": {
        "phpunit/phpunit": "~7.0",
        "mikey179/vfsStream": "~1"
    }
  }
  ```

  * 在对与文件系统交互的类进行的测试中模仿文件系统

    ```php
    class Example
    {
        protected $id;
        protected $directory;

        public function __construct($id)
        {
            $this->id = $id;
        }

        public function setDirectory($directory)
        {
            $this->directory = $directory . DIRECTORY_SEPARATOR . $this->id;

            if (!file_exists($this->directory)) {
                mkdir($this->directory, 0700, true);
            }
        }
    }
    ```

    ```php
    public function setUp()
    {
        vfsStreamWrapper::register();
        vfsStreamWrapper::setRoot(new vfsStreamDirectory('exampleDir'));
    }

    public function testDirectoryIsCreated()
    {
        $example = new Example('id');
        $this->assertFalse(vfsStreamWrapper::getRoot()->hasChild('id'));

        $example->setDirectory(vfsStream::url('exampleDir'));
        $this->assertTrue(vfsStreamWrapper::getRoot()->hasChild('id'));
    }
    ```
