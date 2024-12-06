# 最佳实践

## 项目结构

- 最佳实践上说模块不要放到 `src` 下，但是也可以放，最好在 src 下直接暴露入口文件，如果只有一个文件的话建议直接在根目录下
- License：许可
- setup.py：用于项目的打包和发布管理
- requirements.txt：开发依赖
- ./docs/：包的参考和配置文件
- ./test_sample.py or ./tests/：当只有一个测试文件时，可以直接在根目录下创建，当有多个的时候，应该放到 ./tests/下
  - 当然测试数据需要导入包来进行测试，可以通过简单的路径设置来解决导入问题。
    可以先创建一个包含上下文环境的文件 `tests/context.py`

    ```python
      import os
      import sys
      sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
      import sample 
    ```

    然后在测试文件中导入

    ```python
    from .context import sample
    ```

- README：项目说明文件
- scripts 或者 bin：存放一些可执行文件

## 模块

模块的名称要短、使用小写，并避免使用特殊符号，比如（.?）。如果愿意你可以将模块命名为 `my_spam.py`，
不过并不推荐模块名中使用下划线，**应使用子模块，而不是使用下划线命名空间**

```python
# ok
import library.plugin.foo

# not ok
import library.foo_plugin
```

为了避免在导入中出现问题，你需要理解 import 的原理机制。
具体来说，`import modu` 语句将寻找合适的文件，即调用目录下的 `modu.py` 文件（如果这个文件存在）。
如果没有找到这个文件，Python 解释器会递归地在 `PYTHONPATH` 环境变量中寻找该文件，
如果仍然没有，将会抛出 `ImportError` 异常。

一旦找到 `modu.py`，Python 解释器会在隔离的作用域内执行这个模块，所有的顶层语句都会被执行，包括其他的引用。
方法和类的定义将会存储到这个模块的字典中。然后这个模块的变量、方法和类通过命名空间暴露给调用方。

尽量使用 `import modu` 而不是 `from modu import func`，这样可以避免命名冲突。

## 包

任意包含 `__init__.py` 文件的目录都被认为是一个包。
在 `pack/` 目录下的 `modu.py` 通过 `import pack.modu` 语句导入。该语句会在 `pack` 目录下寻找 `__init__.py`
文件，并执行其中的顶层语句。以上操作后，`modu.py` 中定义的所有变量、方法和类在 `pack.modu` 命名空间中可见。

一个常见的问题是往 `__init__.py` 中添加了许多代码，随着项目的复杂度增加，目录结构越来越深，引入嵌套子包中的模块时，
就需要执行路径上的 `__init__.py` 文件。如果包内的模块和子包没有代码共享的需求，最好的做法是使用一个空白的 `__init__.py` 文件

## 面向对象编程

python 是面向对象的语言，但是其不是强面向对象的语言（例如 Java），是否使用面向对象应该以面向对象的思想作为领导：
其中有一个很重要的点是：**是否有状态的改变，即是否有生命周期。**

例如你只是想计算这个 excel 文件中你需要的数据之和，那就应该避免使用面向对象，而是使用无状态的函数式编程。
但是当你想在 web 开发中操作订单的数据，对于同一个订单数据实体可能设计到下单、支付、发货等多个状态时，考虑面向对象是更好的选择。

同时使用面向对象时，不正确地使用类属性可能会导致一些副作用（类属性在不同的类对象中是共享的），要谨慎使用。

## 装饰器

装饰器是一个函数或类，它可以装饰一个函数或方法。被 ‘装饰’ 的函数或方法会替代原来的函数或方法。
由于在 Python 中函数是一等公民，它也可以被 ‘手动执行’，但是使用 @decorators 语法更清晰，因此首选 @decorators

```python
def foo():
  # 实现

def decorators(func):
  # 操作 func 语句
  return func


foo = decorators(foo)


@decorators
def bar():
  #实现语句
# bar 被装饰了
```

在处理一些与核心业务逻辑不相关的场景时，装饰器是一个很好的方法，如：缓存、计时

## 上下文管理器

上下文管理器是 Python 的一个对象，为操作提供了额外的上下文信息。使用 `with` 语句初始化上下文，以及在完成 `with` 中所有代码时，确保一些方法被调用。

```python
class CustomOpen(object):
  def __init__(self, filename):
    self.file =  open(filename)

  def __enter__(self):
    return self.file

  def __exit__(self, ctx_type, ctx_value, ctx_traceback):
    self.file.close()


with CustomOpen('file') as f:
  contents := r.read()
```

这是一个常规的 Python 对象，它有两个 `with` 语句使用的额外方法。
在过程中，先实例化了 CustomOpen 的对象，然后调用它的 `__enter__` 方法，
并且将 `__enter__` 方法的返回值在 `as f` 中被赋值给 `f`，`with` 语句执行结束后调用 `__exit__` 方法。

生成器方式使用了 Python 自带的 `contextlib`

```python
from contextlib import contextmanager

@contextmanager
def custom_open(filename):
  f = open(filename)
  try:
    yield f 
  finally:
    f.close()

with custom_open('file') as f:
  contents := f.read()
```

这与上面的示例差不多，只不过更简洁。当运行到 `yield` 语句时，将控制权返回给 `with` 语句，
然后在 `as f` 时将 `yield` 的 `f` 赋值给 `f`。finally 确保 `close()` 被正常调用。

由于这俩个方法都是一样的，在使用时遵循 Python 之禅。如果封装的逻辑很多，则类方法会更好。而对于简单的情况，函数方法可能更好。

## 动态类型

Python 的动态类型会导致复杂度提升以及难以调试的代码，在使用时应**避免对不同类型的对象使用相同的变量名**，重复地使用变量名并不会提升效率，在赋值时会创建新对象。

## 可变和不可变类型

Python 提供了两种类型，可变类型允许对象的内部修改，常见的可变类型如列表和字典，可变类型是不稳定的，不能作为字典的键使用。而元组和字符串是不可变的，可以作为键使用。

字符串是一种不可变类型，这意味着当需要组合一个字符串时，将每一部分放到一个可变列表中，使用字符串时再组合起来会更高效。

差

```python
num = ""
for n in range(20):
  num += str(n) # 慢且低效
print(num)
```

好

```python
num = []
for n in range(20):
  num.append(str(n))
print("".join(num))
```

更好

```python
num = [str(n) for n in range(20)] 
print("".join(num))
```

最好

```python
num = map(str, range(20))
print("".join(num))
```

关于字符串的拼接，使用 join 不一定是最好的选择，比如在只有少数字符串拼接的时候，使用 `+` 更快。

```python
a = "aaa"
b = "bbb"
ab = a + b # 这种简单的反而比使用join更快。
```

## 代码风格

### 直接编码

在充满黑魔法的 Python 中，提倡使用直接的编码方式

糟糕

```python
def f(*args):
  x, y = args
  return dict(**locals())
```

优雅

```python
def f(x, y):
  return {'x': x, 'y': y}
```

### 一行不要写两个复合语句

糟糕

```python
print(a); print(b)
if a == 1: print(c)
if <complex comparison> and <other complex comparison>:
  # do something
```

优雅

```python
print(a)
print(b)
if a == 1: 
  print(c)
condition1 = <complex comparison>
condition2 = <other complex comparison>
if condition1 and condition2:
  # do something
```

### 避免使用魔法方法

使用魔法方法会导致代码可读性下降，使用更加直接的方式往往是更好的选择。

### 积极地使用私有的约定

对于任何不开放给外部的属性或方法，应该有一个下划线的前缀。

### 返回值

尽量保证函数最多只有一个返回值，虽然 Python 支持多个返回值，有时使用第二返回值来返回程序运行过程中的错误，但是建议抛出异常从而保证易于调试。

### 使用匿名变量

当一个变量你并不需要时，使用 `__`双下划线来接受，`_` 被经常使用在 `gettext()` 函数的别名。

### 检查变量是否等于常量

糟糕

```python
if attr == True:
  # do something 
```

优雅

```python
if attr:
 # do something

if attr is None:
 # do something
```

### 访问字典元素

不要使用 `dict.has_key()` 方法，应当使用 `x in d`，或者将一个默认参数传递给 `dict.get()`

### 列表维护

在迭代列表的过程中，永远不要从列表中移除元素。

```python
a = [3, 4, 5]
for i in a:
  if i > 4:
    a.remove(i)
```

不要在列表中多次遍历

```python
while i in a:
  a.remove(i)
```

使用推导式更优雅

### 列表与迭代器

如果只是遍历列表，请使用迭代器。使用推导式会创建一个新的列表对象。

```python
# 推导式创建了新对象
filtered_list = [value for value in sequence if value != x]

# 生成器不产生新对象
filtered_list = (value for value in sequence if value != x)
# or 
filtered_list = filter(lambda i : i != x, sequence)
```

### 在列表中修改值

请记住，赋值永远不会创建新的对象，如果有多个引用指向了同一个列表，修改其中一个变量则所有的变量都会受到影响。

### 读取文件

使用 `with` 去读取文件，这会自动帮你关闭文件。

### 行的延续

当一行代码太长时你需要分割成多行，如果使用反斜杠 Pythpn 解释器会将这个代码拼接到一起。但是应该避免使用。
更好地方式是在代码周围使用小括号，Python 解释器会把行的结尾和下一行连接起来直到找到闭合的小括号。
