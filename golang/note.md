# Golang 笔记

## 基础

实例

```golang
package main

import "fmt"

func main(){
    fmt.Println("hello, world")
}
```

### 包

每个 Go 程序由包构成。包名都应该使用小写字符。
程序从 `main` 包开始运行。
按照约定，包名与导入路径的最后一个元素一致。例如 `math/rand` 包中的源码均以 `rand` 开始。

属于同一个包的源文件必须全部一起编译，一个包即是编译时的一个单元，因此根据惯例，每个目录下都只包含一个包。

### 导入

```golang
import "fmt"
import "math"
// or 使用分组导入语句
import (
    "fmt"
    "math"
)
```

### 导出名

在 Go 中，如果一个名字以大写字母开头，那就是可导出的（全局可见），可以在包外部使用。

### 变量

声明变量的一般形式是使用 `var` 关键字：`var identifer type`。

```golang
//变量定义的三种格式
// 1, 指定变量的类型，如果声明后不赋值，则使用零值
var a, b *int
var c bool
var d string
mo hong yi
// 2, 给定值但是没有给类型。Go 自己去类型推导
var i, j = 1, 2

var (
    e int
    f bool
    g string
)

// 3, 海象运算符 := 声明的时候同时赋值，注意左侧的变量不能是已经声明过的，不能在函数外使用
name := "tom"
```

### 常量

常量中数据类型只可以是布尔、数字类型和字符串型。

```golang
const identifier [type] = value
```

#### iota

iota 是一种特殊的常量，可以认为是一个可以被编译器修改的常量。
iota 在 const 关键字出现时将被重置为0，const 中每新增一行常量声明将 iota 计数一次（iota 可以理解为 const 语句块中的行索引）

```golang
const (
    a = iota    //0
    b           //1
    c           //2
    d = "ha"    //ha 独立值 iota += 1
    e           //ha iota += 1
    f = 100     //100 独立值 iota += 1
    g           //100 iota += 1
    h = iota    //7，恢复计数
    i           //8
)
```

### 基本类型

```golang
bool

string

int int8 int16 int32 int64
uint uint8 uint16 uint32 uint64 uintptr

byte // uint8的别名

rune // int32的别名，表示一个 Unicode 码位

float32 float64 //应该尽可能地使用float64， 因为 `math`包中有关数学的计算都是会接收这个类型的参数。

complex64 complex128

// int, uint, uintptr 类型在32位系统上通常是32位宽，在64位系统上通常是64位宽。
```

#### 零值

整型的零值为`0`。
浮点的零值为`0.0`。
布尔类型的零值为`false`。
字符串为`""`（空字符串）。

#### 类型转换

表达式 `T(v)` 将值 `v` 转换为类型 `T`

### 函数

```golang
func add(x int, y int) int {
    return x + y
}

// 当连续的函数参数类型相同时，可以只在最后一个参数上加类型声明
func sub(x, y int) int {
    return x - y
}

// 函数可以返回多个结果
func swap(x, y int) (int, int) {
    return y, x
}
```

#### 函数参数

| 传递类型 | 描述                                                                                                       |
| -------- | ---------------------------------------------------------------------------------------------------------- |
| 值传递   | 值传递是指在参数传递时，将实际参数复制一份传递到函数中，这样在函数中如果对参数进行修改，不会影响原本的参数 |
| 引用传递 | 引用传递是指在调用函数时将实际参数的地址传递到函数中，那么在函数中对参数进行的修改，将影响实际的参数       |

默认情况下，Go 使用的是值传递

#### 方法

方法是带有拥有者的函数，接受者可以是命名类型或结构体类型的一个值或指针。

```golang
func (variable_name variable_data_type) function_name() [return_type] {
    // 函数体
}
```

```golang
type Circle struct {
    radius float64
}

func(c Circle) getArea() float64 {
    return 3.14 * c.radius * c.radius
}

```

#### nil 接收者

值为 nil 的变量可以作为方法的接受者。

```golang
package main

import "fmt"

const defaultPath = "hello"

type Config struct {
  path string
}

func (c *Config) Path() string {
 if c == nil {
    return defaultPath
  }
  return c.path
}


func main() {
  var v1 *Config
  var v2 = &{
    path: "world"
  }
  fmt.Println(v1.Path(), v2.Path())
}

```

### 条件语句

#### if

```golang
if condition {

} else {

}
```

#### switch

```golang
switch {
    case condition1:
        // 执行1
    case condition2:
        // 执行2
    default:
        // 默认执行
}

// Type switch

var x interface{}

switch i := x.(type) {
    case nil:
        // nil
    case int:
        // type int
    case float64:
        // type float64
    case func(int) float64:
        // type func
    case bool, string:
        // type bool or string
    default:
        // default
}
```

#### select

select 是 Go 中的一个控制结构，类似 switch 语句。
select 语句只能用于通道操作，会监听所有指定通道上的操作。
如果有多个通道都准备好了，则会随机公平选择一个通道执行,其他的不会执行。如果所有的通道都不行则执行 default 块中的代码。如果没有 default 块，则会阻塞直到有通道可以运行。

```golang
select {
    case <- channel1:
        // 1 code
    case value := <- channel2:
        // 2 code
    default:
        // default code
}
```

### 循环语句

```golang
for init; condition; post {

}

for condition {

}

// 无限循环
for {}
```

continue 语句和break语句和其他的是一样的。

#### goto

```golang
goto label

label: statement
```

```golang
LOOP: for a < 20 {
    if a == 15 {
        // 跳过15
        a = a + 1
        goto LOOP
    }
}
```

### 字符串

字符串是一种值类型，且值不可变，即创建某个文本后无法修改文本的内容。更深入地说，字符串是字节的定长数组。

- 解释字符串：使用双引号括起来，其中转义字符将被替换
- 非解释字符串：该类字符串使用反引号括起来，转义字符将被原样输出。

字符串拼接使用`+`号来生成一个新的字符串。

#### strings 和 strconv 包

##### 字符串操作

`HasPrefix` 判断字符串是否包含该前缀

```golang
strings.HasPrefix(str, prefix string) bool
```

`HasSuffix` 判断字符串是否包含该后缀

```golang
strings.HasSuffix(str, suffix string) bool
```

`Contains` 判断字符串 s 是否包含 substr

```golang
strings.Contains(s, substr string) bool
```

`Index` 返回 substr 在字符串 s 中的索引（str 的第一个字符的索引），-1表示字符串 s 不包含字符串 substr

```golang
strings.Index(s, substr string) int
```

`LastIndex` 返回 substr 在字符串 s 中的最后出现位置的索引（substr 的第一个字符的索引），-1 表示字符串 s 不包含字符串 substr

```golang
strings.LastIndex(s, substr string) int
```

`Replace` 用于将字符串 str 中的前 n 个字符串 old 替换为字符串 new，
并返回一个新的字符串，如果 n = -1 则替换所有的字符串 old 替换为 new

```golang
strings.Replace(str, old, new string, n int) string
```

`Count` 用于计算字符串 str 在字符串 s 中出现的非重叠次数：

```golang
strings.Count(s, str string) int
```

`Repeat` 用来重复 count 次字符串 s 并返回一个新的字符串。

```golang
strings.Repeat(s, count int) string
```

`ToLower` 将字符串中的 Unicode 字符全部转为对应的小写字符

```golang
strings.ToLower(s) string
```

`ToUpper` 将字符串中的 Unicode 字符全部转为对应的大写字符

```golang
strings.ToUpper(s) string
```

`Trim` `TrimSpace` `TrimLeft` `TrimRight` 修剪字符串

```golang
// 删除字符串开头和结尾的空白字符
strings.TrimSpace(s)
// 删除指定的字符串
strings.Trim(s, "cut")
// 删除开头的字符串
strings.TrimLeft(s,"leftcut")
// 删除结束的字符串
strings.TrimRight(s, "rightcut")
```

`Fields` `Split` 分割字符串

```golang
// 使用空白字符作为分割字符将字符串分割为若干块。并返回一个slice。如果所有的字符都是空白字符，则返回一个长度为0的slice
strings.Fields(s)
//自定义分割符号对字符串进行分割，分割 slice。
strings.Split(s, seq)
```

`Join` 用于将元素类型为 string 的 slice 使用分割符号来拼接组成一个字符串

```golang
strings.Join(sl []string, seq string) string
```

`NewReader` 用于生成一个 `Reader` 并读取字符串的内容，然后返回一个指向该 `Reader` 的指针，从其他类型读取内容的函数还有：

- `Read()` 从 []byte 中读取内容
- `ReadByte()` 和 `ReadRune()` 从字符串中读取下一个 byte 或者 rune。

##### 字符串类型转换

与字符串相关的类型转换都是通过 `strconv` 包实现的。
该包包含了一些变量用于获取程序运行的操作系统平台下 int 类型所占的位数，如: `strconv.IntSize`。

- `strconv.Itoa(i int) string` 返回数字 i 所表示的字符串类型的十进制数。
- `strconv.FormatFloat(f float64, fmt byte, prec int, bitSize int) string` 将64位浮点数的数字转换为字符串，
  其中 `fmt` 表示格式（其值可以是 `'b'`,`'e'`,`'f'`,`'g'`），`prec` 表示精度，
  `bitsize` 则使用32表示float32， 用64表示float64。
- `strconv.Atoi(s string)(i int, err error)` 将字符串转换为int型。
- `strconv.ParseFloat(s string, bitsize int)(f float64, err error)` 将字符串转为 float64类型

### 数组

`var arrayName [size] dataType`

```golang
balance := [5]int{1,2,3,4,5}
//或 使用...来代替数组的长度，编译器会根据元素的个数在自行推断数组的长度。
balance := [...]int{1,2,3,4,5}

```

### 指针

一个指针变量指向了一个值的内存地址。和 C++ 的指针用法基本相同。使用 `&` 进行取址， 使用 `*` 按地址取值。

指针的定义

`var point_name *var-type`

当一个指针被定义后没有分配到任何的变量时，他的值为nil。nil 指针被称为空指针。一个指针变量通常缩写为 `ptr`。

#### 转换和可比较性

对于指针类型变量能不能够比较和显示转换需要满足以下规则：

指针类型 *T1,*T2 对应的基类型 T1和T2的底层类型必须一致。

#### uintptr

uintptr 是一个足够大的整数类型，能够存放任何指针。不同于C语言，Go中普通类型的指针不能进行算术运算，我们可以将普通类型指针转为uintptr然后进行运算，
但普通类型指针不能直接转为uintptr，必须先转换为 unsafe.Pointer 类型之后，再转换成uintptr

#### unsafe.Pointer

`unsafe` 标准库包提供了 `unsafe.Pointer` 类型，`unsafe.Pointer` 类型称为非安全指针类型。

任何**指针类型都可以转为 unsafe.Pointer 类型， unsafe.Pointer 也可以转为任何指针类型**

```golang
func Alignof(variable ArbitaryType) uintptr // 用来获取变量variable的对齐保证
func Offsetof(variable ArbitaryType) uintptr // 用来获取结构体值的某个字段的地址相对于此结构体值地址的偏移
func Sizeof(variable ArbitaryType) uintptr  // 用来获取变量variable变量的大小尺寸
```

#### 正确使用 unsafe.Pointer

##### 通过非安全类型指针，将 T1 转换成 T2

```golang
func Float64bits(f float64) uint64 {
  // 此时 unsafe.Pointer 充当桥梁，T2 类型的尺寸不应该大于T1，否则会出现溢出异常。
  return *(*uint64)(unsafe.Pointer(&f))
}
```

##### 将非安全类型指针转为 `uintptr` 类型

```golang
a := 100
uintptr(unsafe.Pointer(&a))
```

##### 将非安全类型指针转为 `uintptr` 类型，并进行算术运算

### 结构体

```golang
type struct_variable_type struct {
    member definiton
    member definiton
    ...
}
```

一旦定义了结构体，就可以用于变量的声明。

```golang
variable_name := structure_variable_type {value1, value2, ... ,valuen}
// or
variable_name := structure_variable_type {key1:value1, key2:value2, ... ,keyn:valuen}
```

#### 空结构体

空结构体占用的内存空间大小为零字节，并且他们的地址可能相等也可能不想等。

> [!IMPORTANT]
> 无论逃逸还是未逃逸，我们都不应该对空结构体类型变量指向的内存地址是否一样，做任何预期。

#### 当一个结构体嵌入空结构体时，占用空间计算

空结构体本身不占用空间，但是作为某结构体内嵌字段时候，有可能是占用空间的。具体的计算规则如下：

- 当空结构体是该结构体唯一的字段时，该结构体是不占用空间的，空结构体自然也不占用空间。
- 当空结构体作为第一个字段或者中间字段的时候，是不占用空间的。
- 当空结构体作为最后一个字段的时候，是占用空间的，大小跟前一个字段保持一致。

#### 可以使用空结构体占用的空间大小为零的特性，完成一些特性而不占用额外的空间

可以使用 map 搭配空结构体实现 集合的数据结构。

### 切片

Go 语言的切片是对数组的抽象。与数组不同的是，切片的长度不是固定的，可以追加元素，在追加时可能使切片的容量变大。

数组和切片(Slice)之间有着紧密的联系。一个 Slice 是一个轻量级的数据结构。Slice 底层引用一个数组对象。
一个 Slice 由3部分组成：指针、长度和容量。指针指向第一个 Slice 元素对应的底层数组元素的地址，要注意 Slice 的第一个元素不一定就是引用数组的第一个元素。
长度对应的是 Slice 元素的个数;长度不能超过容量，容量一般是从 Slice 的开始位置到底层数组结尾的位置。

多个 Slice 之间可以共享底层的数据，并且引用数组的部分区间可能重叠。

```golang
// 定义切片
var identifier []type
// 可以使用 make 函数来创建切片,容量 capacity 为可选参数。
make([]T, length [,capacity])
```

#### 切片初始化

```golang
// 直接初始化切片， 其中 capacity 和 length 都是3
s := [] int {1, 2, 3}

// 初始化切片s，指向数组arr,底层就是arr数组
s := arr[:]

// 将 arr 中从下标 startIndex 到 endIndex - 1 下的元素创建一个新的切片。
s := arr[startIndex:endIndex]

// 将 arr 中从下标 startIndex 到 数组结尾下的元素创建一个新的切片
s := arr[startIndex:]

// 将 arr 中从数组开头到 endIndex - 1 下的元素创建一个新的切片
s := arr[:endIndex]
```

#### len() 和 cap() 函数

使用 `len()` 可以获取切片的长度。
使用 `cap()` 可以获取切片的容量。

#### 空(nil)切片

一个切片在未初始化之前默认是nil，长度为0。

#### append() 和 copy() 函数

如果想增加切片的容量，必须创建一个新的更大的切片并把原分片的内容都拷贝过来。

#### nil 切片

对于 nil 切片进行读写操作的时候会panic，但是对 nil 切片进行 `append` 操作是可以的。

### range

range 关键字用于 for 循环中迭代数组、切片、通道和集合中的元素。

### map

映射底层一般都是由数组组成，该数组每个元素被成为桶，它使用hash函数将key分配到不同的桶中，
如果出现hash碰撞冲突的时候，采用链地址法解决。

#### map的创建

当使用make函数创建map的时候，如果不指定map元素的数量，底层将使用`make_small`函数创建hmap结构，此时只产生哈希种子，不初始化桶。

在获取 map 的值的时候，如果不存在，返回该类型的零值。

#### 加载因子

加载因子，也称为扩容因子，或者负载因子，用来描述哈希表中的填满程度。加载因子越大，表明哈希表中的元素越多，空间利用率高，但是这也意味着
hash冲突的机会加大。**加载因子是通过写入元素个数除以桶的个数得到，当哈希表中所有桶都写满的情况下，此时的加载因子是1**，此时写入新的key
一定会产生hash碰撞，为了提高哈希表写入效率就必须在加载因子超过一定值时（这个值称为**加载因子阈值**），进行rehash操作，将桶容量进行扩容，来尽量避免冲突

Go 语言中映射的加载因子阈值是6.5，Go map中每个桶（每个桶有8个坑位）可以存放8个key-value,满载因子是8。

#### 扩容方式

1. 等容量扩容，未达到加载因子阈值情况下，如果B小于15时，溢出桶的数量大于2^B, 进行等容量扩容。
2. 双倍容量扩容

```golang
// 使用make
map_variable = make(map[keyType]valueType, initialCapacity)
// 使用map字面量
m := map[keyType]valueType {
    key1:value1,
    key2:value2
    ...
}
```

获取元素

```golang
// 如果不存在该值，则ok为false
v, ok := m["key"]
```

删除键值对

```golang
delete(m, "key")
```

#### nil map

对 nil map 进行读取操作时，会返回map valueType 的零值。当进行写操作的时候会发生 panic

### 接口

接口把具有共性的方法定义在一起，任何其他类型只要实现了这些方法就是实现了这个接口。
Go 语言中的接口是隐式实现的，也就是说，如果一个类型实现了一个接口定义的所有方法，那么它就自动地实现了该接口。因此可以通过接口作为参数来实现对不同类型的调用，从而实现多态。

```golang
type interface_name interface {
    method_name1 [return_type]
    method_name2 [return_type]
    method_name3 [return_type]
    ...
}

// 定义一个结构体
type struct_name struct {

}

// 实现接口方法
func (s *struct_name) method_name1() [return_type]{

}

func (s *struct_name) method_name2() [return_type]{

}

func (s *struct_name) method_name3() [return_type]{

}

//使用

// 定义方法1
var i interface_name

i = struct_name {

}
i.method_name1()

// 方法2
var i interface_name
i = new(struct_name)
i.method_name2()
```

#### 空接口

指定了零个方法的接口被称为空接口

```golang
type Any interface{}
```

空接口可以保存任何类型的值。(因为每个类型都至少实现了零个方法)

接口类型变量包含两个基本的属性：`Type` 和 `Value`，`Type` 指的是接口变量的底层类型，`Value` 指的是接口类型变量的底层值。
**接口类型是可以比较的。当拥有相同的底层类型，且相等的底层值的时候，或者两者都是nil的时候（type 和 value 都是nil），这两个值相等**

### 错误处理

常见的有五种错误处理的方法

1. 传播错误。子程序错误直接导致整个函数的失败

   ```golang
   res, err := http.Get(url)
   if err != nil {
       return nil, err
   }
   ```

2. 错误的发生是偶然的，或者不可知的问题导致的，可以选择重试失败的操作。

   ```golang
   var success bool = false
   for i := 0; i < 3; i++ {
    res, err := http.Get(url)
    if err == nil {
        break
    }
   }
   ```

3. 如果某些错误发生后，程序无法继续运行。可以输出错误信息并结束程序。
4. 只输出错误信息，不需要终端程序的运行。
5. 直接忽略这个错误。

### 类型分支

```golang
switch x.(type) {
    case nil: //...
    case int, unit: //...
    case bool: //...
    default://...
}
```

### 并发

每一个并发的执行单元叫做一个 goroutine。

```golang
go func_name(参数列表)
```

### 通道

通道(channels)是gorouting之间的通信机制, 是并发安全的。通道可用来两个 gorouting 之间通过传递一个指定类型的值来同步运行和通信。
操作符 `<-` 用于指定通道的方向。如果未指定方向，则为双向通道。

```golang
ch <- v // 把v发送给通道ch
v := <- ch // 从ch接受数据并赋值给v
```

#### 声明通道

```golang
// 声明无缓冲区的通道，发送端发送数据，同时必须有接收端接收数据。
ch := make(chan int)

// 给通道设置缓冲区，带缓冲区的通道允许数据的发送和接收处于异步的状态。但是还是必须设置接受者，否则缓冲区满了也就不能再向里面发送信息了
ch := make(chan int, 10)
```

#### nil 通道

从 nil 通道接收数据会永远阻塞，这会造成goroutine泄漏。可以将通道设置为nil可以停止使用这个通道。

#### 通道通信

- 对于缓冲通道，向通道发送数据 `happens-before` 从通道接收到数据, 写 > 读
- 对于无缓冲通道，从通道接受到数据 `happens-before` 从通道发送数据，读 > 写

#### channel 规则

| 操作          | 空channel | 已关闭channel | 活跃的channel  |
| ------------- | --------- | ------------- | -------------- |
| close(ch)     | panic     | panic         | 成功关闭       |
| ch <- v       | 永远阻塞  | panic         | 成功发送或阻塞 |
| v,ok := <- ch | 永远阻塞  | 不阻塞        | 成功接收或阻塞 |

### 上下文 context

Context是由Golang官方开发的并发控制包，一方面可以用于当请求超时或取消时候，相关的gorouting马上退出释放资源，
另一方面Context本身含义就是上下文，其可以在多个goroutine或者多个处理函数之间传递共享的信息。

context 可以用来在 goroutine 之间传递上下文信息，相同的 context 可以传递给运行在不同 goroutine 中的函数，
上下文对于多个goroutine同时使用是安全的，context 包定义了上下文类型，可以使用 `background`、`TODO` 创建一个上下文，
在函数调用链之间传播 context，也可以使用 `WithDeadline`,`WithTimeout`,`WithCancel`或`WithValue`创建的修改副本替代他。

创建一个新的context。必须基于一个父context，组成一颗context树。

#### 创建Context

context 包主要提供了两种方式创建 context:

- context.Background()
- context.TODO()

这两个函数其实只是互为别名，没有差别，所以大多数情况下，我们都使用 `context.Background` 作为起始的上下文向下传递。

上面的两种方式是创建根 context，不具备任何功能，具体实践还是要依靠 context 包提供的 With 系列函数来进行派生。

```golang
func WithCancel(parent Context) (ctx Context, cancel CancelFunc)
func WithDeadline(parent Context, deadline time.Time) (Context, CancelFunc)
func WithTimeout(parent Context, timeout time.Duration) (Context, CancelFunc)
func WithValue(parent Context, key, var interface{}) Context
```

#### WithValue 携带数据

在日常开发中都希望有一个 trace_id 能串联所有日志，这就需要我们打印日志的时候能够获取到这个trace_id，
在 python 中我们可以用 gevent.local 来传递，在 java 中我们可以用 ThreadLocal 来传递， 在 Go 语言中
我们就可以使用 Context ，使用 WithValue 来创建一个携带 trace_id 的 context

在使用 WithValue 时要注意四个事项：

- 不建议使用 context 值传递关键参数，关键参数应该显示的声明出来，不应该隐式处理。
- 因为携带的value也是key,value的形式，为了避免 context 因多个包同时使用context而带来冲突，key建议采用内置类型。
- 可以获取当前ctx，也可以获取父 context 中的value，向上查找对应的value
- context 传递的数据中 key，value 都是 interface 类型，这种类型编译器无法确定类型，所以不是很安全，注意类型校验。

#### 超时控制

通常健壮的程序都是要设置超时时间的，避免因为服务端长时间相应消耗资源，所以一些 web 框架或 rpc 框架都会采用
`WithTimeout`或者`WithDeadline`来做超时控制，当一次请求到达我们设置的超时时间，就会及时取消当前任务。
`WithTimeout` 和 `WithDeadline` 作用是一样的，就是传递的时间参数不一样。通过传入的时间来自动取消 Context。
它们都会返回一个 `cancelFunc` 方法，通过调用这个方法可以提前进行取消，不过在使用的过程中建议在自动取消后也调用 `cancelFunc` 去
停止定时减少不必要的资源浪费。

```golang
package main

import (
  "context"
  "fmt"
  "time"
)

func main() {
  ctx, cancel := context.WithTimeout(context.Background(), 3 * time.Second)
  defer cancel()
  deal(ctx, cancel)
}

func deal(ctx context.Context, cancel context.CancelFunc) {
  for i := 0; i < 10; i++ {
    time.Sleep(1 * time.Second)
    select {
      case <- ctx.Done():
        fmt.Println(ctx.Err())
        return
      default:
        fmt.Println("deal time is %d\n", i)
        cancel()
    }
  }
}
```

如果我们想在一个goroutine中再单独地开一个goroutine去处理其他的时期，那么传递的context要基于context.Background或者context.TODO重新
衍生出一个context。

#### WithCancel 取消控制

业务开发时，我们往往为了完成一个复杂的需求会开多个 goroutine 去做一些事情，这就导致我们会在一次请求中开多个 goroutine 却无法控制，
我们就可以使用 WithCancel 来衍生一个 Context 传递到不同的goroutine 中，
当我想让这些 goroutine 停止运行，就可以使用 cancel 来进行取消。

#### 实现Context接口的类型

emptyCtx：emptyCtx 是 int 类型能够， emptyCtx 实现了 Context 接口，是一个空context，只能作为根context。
cancelCtx：支持取消操作
WithCancel/WithDeadline：创建一个ctx,以及它关联的取消函数
timeCtx：支持过期取消

### defer

golang 延迟调用

```golang
1. 关键字 defer 用于注册延迟调用。
2. 这些调用直到 return 前才被执行。因此可以用来做资源清理。
3. 多个 defer 语句，按先进后出（defer 栈）方式执行。
4. defer 语句中的变量，在 defer 声明时就决定了。
```

```golang
return 语句并不是一个原子操作。一般分为两步：将结果`x`赋值给返回值，然后执行 `RET`指令;
而 `defer` 语句执行的时候，是在赋值变量之后，`RET` 指令之前。
如果 `x` 是一个值类型，进行拷贝。

```

defer 下的函数参数包含子函数

```golang
package main

import "fmt"

func function(index, value int) {
  fmt.Println(index)
  return index
}

func main() {
  defer function(1, function(3, 0))
  defer function(2, function(4, 0))
}
```

执行结果时 3, 4, 2, 1

defer 入桟的时候，会将函数地址、函数参数一同入桟，所以当形参也是一个子函数的时候，会先将这个子函数运行得到子函数返回值。

使用 defer 捕获异常

```golang
func F() {
  defer func(){
    if err := recover(); err != nil {
      fmt.Println("捕获异常", err)
    }
  }()
}
```

### 测试

所有以 `_test.go` 为文件扩展名的的源代码文件都是 `go test` 的一部分，不会被 `go build` 编译到最终的可执行文件中。

在 `*_test.go` 文件中有三种类型的函数，**单元测试函数**、基准测试函数和实例函数。

| 类型     | 格式                  | 作用                       |
| -------- | --------------------- | -------------------------- |
| 测试函数 | 函数名前缀为Test      | 测试程序的一些逻辑是否正确 |
| 基准函数 | 函数名前缀为Benchmark | 测试函数的性能             |
| 示例函数 | 函数名前缀为Example   | 为文档提供示例文档         |

go test 参数解读:

```txt
-c  ：编译 go test 为可执行文件，但是不运行测试。
-i  ：安装测试包依赖的package，但是不运行测试。
-test.run pattern ：只跑哪些单元测试用例
-test.bench pattern ：跑哪些基准测试用例
-test.benchmem：是否在基准测试的时候输出内存情况
-test.benchtime t ：性能测试运行的时间，默认是1s
-test.cpuprofile cpu.out：是否输出cpu性能分析文件
-test.memprofile mem.out：是否输出内存性能分析文件
-test.blockprofile block.out：是否输出内部goroutine阻塞的性能分析文件
-test.memprofilerate n：内存性能分析的时候有一个分配了多少的时候才打点记录的问题。
这个参数就是设置打点的内存分配间隔，也就是profile一个sample代表的内存大小。
默认是 512*1024的。如果设置为1,那每分配一个内存块就会在profile中有个打点，
那么生成的profile的sample就会非常的多。如果设置为0，那就是不做打点了。

可以通过设置memprofilerate=1和GOGC=off来关闭内存回收，对每个内存块的分配进行观察。

-test.blockprofilerate n：控制goroutine阻塞的时候打点的纳秒数，默认1纳秒。
-test.parallel n ：性能测试的程序并行cpu数，默认等于 GOMAXPROCS
-test.timeout t ：如果测试用例运行时间超过t，则panic。
-test.short：将运行时间较长的测试用例运行时间缩短。
```

### 原子操作 - atomic

atomic 包提供的操作可分为3类：

对整数类型T的操作，T 是 `int32`，`int64`，`uint32`,`uint64`,`uintptr` 其中的一种。

```golang
func AddT(addr *T, data T)(new T)
func CompareAndSwapT(addr *T, old, new T)(swapped bool)
func LoadT(addr *T)(var T)
func StoreT(addr *T, var T)
func SwapT(addr *T, new T)(old T)
```

### 并发map sync.Map

```golang
func (m *Map)Store(key, value interface{})bool //Store 新增和修改操作
func (m *Map)Load(key interface{})(value interface{}, ok bool) // Load方法用来获取key对应的value值
func (m *Map)Delete(key interface{})bool //Delete 删除key
func (m *Map)Range(f func(key, value interface{}) bool) // 接收一个迭代回调函数，用来处理遍历的key和value
```

总结：

- sync.Map 是不能值传递的
- sync.Map 采用的是空间换时间的策略。其底层结构存在两个map，分别是 read map 和 dirty map。
  当读取操作时候，优先从 read map 中读取，是不需要加锁的，
  若key不存在 read map 中时候，再从 dirty map 中读取，这个过程中是加锁的。当新增key操作时候，只会将新增的key添加到dirty map中，此过程是加锁的，
  但不会影响read map的读操作。当更新key操作的时候，如果key 已经存在于read map 中，无锁更新read map即可。
  总之sync.Map 会优先从 read map 中增删改查，因为对 read map 的操作是不需要加锁的。
- 当 sync.Map 读取key的时候，若从read map 中没有读到，但 dirty map 存在的key，则会把 dirty map 升级为readmap，这个过程是加锁的，下次读取的时候就依然从readmap中读取
- 延迟删除机制，删除一个键值时只是打上删除标记，只有 dirty map 升级为 read map 的时候才清理删除的数据。
- sync.Map 中 dirty map 要么是nil，要么包含 read map 中所有未删除的key-value
- sync.Map 适用于读多写少的场景。

### 等待组 sync.WaitGroup

- WaitGroup 是不能值传递的
- Add 方法的传值可以是负数，但加上该传值之后的WaitGroup计数器不能是负值
- Done 方法实际上是调用的是Add(-1)
- Add 方法和Wait方法不能并发调用
- Wait 方法可以多次调用，调用此方法的goroutine会阻塞，一直阻塞到WaitGroup计数器值变为0

### 一次性操作 sync.Once

sync.Once 用来完成一次性操作，比如配置加载，单例对象初始化等。

### 缓冲池 sync.Pool

sync.Pool 提供了临时的对象缓冲池，存在池子的对象可能在任何时刻被移除。sync.Pool **可以并发使用**，它通过**复用对象来减少对象内存分配和GC的压力**。
当负载大的时候，临时的对象缓冲池会扩大，缓存池中的对象会在每2个GC循环中清除。

### 锁

#### 互斥锁

互斥锁是一种常用的控制共享资源访问的方法，它能够保证同时只有一个goroutine可以访问共享资源。

```golang
var lock sync.Mutex

func add() {
  for i := 0; i < 1000; i++ {
    locl.Lock()
    x = x + 1
    lock.Unlock()
  }
}
```

#### 读写互斥锁

互斥锁是完全互斥的，但是很多情况下都是读多写少的，当我们去并发的读取一个资源不涉及资源修改的时候是没有必要加锁的。
读写锁使用的是sync.RWMutex类型

读写锁分为两种：读锁和写锁。当一个goroutine获取读锁之后，其他的goroutine如果是获取读锁会继续获得锁，如果是获取写锁就会等待。
当一个goroutine获取写锁之后，其他的goroutine无论是获取读锁还是写锁都会等待。

### G-M-P 调度机制

## gin

### hello world

```Golang
package main

import (
 "net/http"

 "github.com/gin-gonic/gin"
)

func main() {
 r := gin.Default()
 r.GET("/ping", func(c *gin.Context) {
  c.String(http.StatusOK, "pong")
 })
 r.Run()
}

```

### AsciiJSON

使用 AsciiJSON 生成具有转义的非 Ascii 字符的ASCII-only JSON

```golang
func main() {
 r := gin.Default()

 r.GET("/someJSON", func(ctx *gin.Context) {
  data := map[string]any{
   "lang": "go 语言",
   "tag":  "<br>",
  }
  ctx.AsciiJSON(http.StatusOK, data)
 })

 r.Run(":8080")
}

// {"lang":"go \u8bed\u8a00","tag":"\u003cbr\u003e"}
```

### HTML 渲染

使用 LoadHTMLGlob() 或者 LoadHTMLFiles()
glob 可以定义一批，Files需要指定具体的文件

```golang
func main() {
 r := gin.Default()
 // r.LoadHTMLGlob("templeates/*")
 r.LoadHTMLFiles("templeates/index.tmpl")
 r.GET("/index", func(ctx *gin.Context) {
  ctx.HTML(http.StatusOK, "index.tmpl", gin.H{
   "title": "Hello Mohy",
  })
 })

 r.Run()
}
```

```tmpl
<html>
  <h1>
    {{ .title}}
  </h1>
</html>
```

#### 使用不同模块下名称相同的模板

需要声明tmpl模板文件

```golang
func main() {
 r := gin.Default()
 r.LoadHTMLGlob("templeates/**/*")
 // r.LoadHTMLFiles("templeates/index.tmpl")
 r.GET("/posts/index", func(ctx *gin.Context) {
  ctx.HTML(http.StatusOK, "posts/index.tmpl", gin.H{
   "title": "Hello Posts",
  })
 })

 r.GET("/user/index", func(ctx *gin.Context) {
  ctx.HTML(http.StatusOK, "user/index.tmpl", gin.H{
   "title": "hello User",
  })
 })
 r.Run(":8080")
}
```

`user/index.tmpl`，必须添加开头的 `define` 和后面的 `end`

```golang
{{ define "user/index.tmpl" }}
<html>
  <h1>
    {{ .title}}
  </h1>
</html>
{{ end }}
```

```golang
{{ define "posts/index.tmpl" }}
<html>
  <h1>
    {{ .title}}
  </h1>
</html>
{{ end }}
```

### HTTP2 server 推送

http.Pusher 仅支持 **go1.8+**

后端主动向浏览器推送相关数据，可以在一定程度上加快速度，但提升不大？

### JSONP

使用 JSONP 向不同域的服务器发送数据。如果查询参数存在回掉，则将回掉添加到响应体中。

虽然 Gin 对 JSONP 的支持很好，但是不推荐使用，因为 JSONP 劫持问题，如果跨域还是使用代理或 CORS 比较好。

### Multipart/Urlencoded 绑定

```golang
type LoginForm struct {
 User     string `form:"user" binding:"required"`
 Password string `form:"password" binding:"required"`
 Test     string `form:"test"`
}

func main() {
 r := gin.Default()
 r.POST("/login", func(ctx *gin.Context) {
  var form LoginForm
  // 显示地绑定声明
  if ctx.ShouldBindWith(&form, binding.FormMultipart) == nil {
   // 或者使用 ShouldBind 自动绑定
   // if ctx.ShouldBind(&form) == nil {
   if form.User == "user" && form.Password == "password" {
    ctx.JSON(http.StatusOK, gin.H{
     "status": "you are logged in",
    })
   } else {
    ctx.JSON(http.StatusOK, gin.H{
     "status": "unauthorized",
    })
   }
  }
 })
 r.Run(":8080")
}
```

### Multipart/Urlencoded 表单

```golang
func main() {
 r := gin.Default()
 r.POST("form_post", func(ctx *gin.Context) {
  m := ctx.PostForm("message")
  // 可以设置非必需参数
  //
  age := ctx.DefaultPostForm("age", "24")

  ctx.JSON(200, gin.H{
   "status":  1,
   "message": m,
   "age":     age,
  })
 })
 r.Run(":8080")
}
```

### PureJson

通常，JSON 会使用 unicode 替换特殊的 HTML 字符，比如将 `<` 替换为 `\u003c`，想要原样输出可以使用 `PureJson`。

```golang
func main() {
 r := gin.Default()
 r.GET("/json", func(ctx *gin.Context) {
  ctx.JSON(200, gin.H{
   "html": "<b>hello,world</b>",
  })
 })
 r.GET("/purejson", func(ctx *gin.Context) {
  ctx.PureJSON(200, gin.H{
   "html": "<b>hello,world</b>",
  })
 })
 r.Run(":8080")
}
```

### Queuy 和 post form

`Context-type: application/x-www-form-urlencoded`

```golang
func main() {
 router := gin.Default()

 router.POST("/post", func(c *gin.Context) {

  id := c.Query("id")
  page := c.DefaultQuery("page", "0")
  name := c.PostForm("name")
  message := c.PostForm("message")

  fmt.Printf("id: %s; page: %s; name: %s; message: %s", id, page, name, message)
 })
 router.Run(":8080")
}
```

### SecureJSON

使用 SecureJSON 防止 json 劫持。如果给定的结构是数组值，则默认预置 `while(1)` 到响应体。

```golang
func main() {
 r := gin.Default()

 r.GET("/secureJSON", func(ctx *gin.Context) {
  names := []string{"lena", "alex", "foo"}
  ctx.SecureJSON(200, names)
 })
 r.Run(":8080")
}


// 响应 while(1);["lena","alex","foo"]
```

### 绑定 Uri

使用结构体标签uri,以及路由路径中添加`:tag`来进行 Uri 绑定

```golang
type Person struct {
 ID   string `uri:"id" binding:"required,uuid"`
 Name string `uri:"name" binding:"required"`
}

func main() {
 r := gin.Default()
 r.GET("/:name/:id", func(ctx *gin.Context) {
  var person Person
  if err := ctx.ShouldBindUri(&person); err != nil {
   ctx.JSON(400, gin.H{"msg": err.Error()})
  }
  ctx.JSON(200, gin.H{"name": person.Name, "uuid": person.ID})
 })

 r.Run(":8080")
}



```

### 绑定表单数据至自定义结构体

使用 `c.Bind(&b)` 进行数据绑定

### 绑定查询字符串或表单数据

```golang
type Person struct {
  Name      string    `form:"name"`
  Address   string    `form:"address"`
  Birthday  time.Time `form:"birthday" time_format:"2006-01-02" time_utc:"1"`
}

func main(){
  r := gin.Default()
  r.GET("/testing", func (ctx *gin.Context){
    var person Person
    // 如果是 GET 请求，只使用 `Form` 绑定引擎
    // 如果是 POST 请求，首先检查 Context-type 是否为 JSON 或 XML，然后使用 Form
    if c.ShouldBind(&person) == nil {
    log.Println(person.Name)
  }
  })
  r.Run(":8080")
}
```

### 不使用默认的中间件

使用

```golang
r := gin.New()
```

代替

```golang
r := gin.Default()
```

### 查询字符串参数

```golang
name := ctx.DefaultQuery("name", "alex")
age := ctx.Query("age")
```

### 从 reader 读取数据

```golang
func main() {
 router := gin.Default()
 router.GET("/someDataFromReader", func(c *gin.Context) {
  response, err := http.Get("https://raw.githubusercontent.com/gin-gonic/logo/master/color.png")
  if err != nil || response.StatusCode != http.StatusOK {
   c.Status(http.StatusServiceUnavailable)
   return
  }

  reader := response.Body
  contentLength := response.ContentLength
  contentType := response.Header.Get("Content-Type")

  extraHeaders := map[string]string{
   "Content-Disposition": `attachment; filename="gopher.png"`,
  }

  c.DataFromReader(http.StatusOK, contentLength, contentType, reader, extraHeaders)
 })
 router.Run(":8080")
}

```

### 定义路由日志的格式

如果想指定日志的格式，可以使用 `gin.DebugPrintRouteFunc` 指定格式。

### 将 request body 绑定到不同的结构体中

一般通过调用 `c.Request.Body` 方法绑定数据，但不能多次调用这个方法。

在某些特殊格式，如 `JSON`， `XMl`， `MsgPack`，`ProtoBuf` 时，使用 `c.ShouldBind` 只能使用一次，
要想多次进行绑定，应该使用 `c.ShouldBindBodyWith`, 这个方法是在调用了一次 `c.ShouldBind` 之后，
将结果存入上下文中。重复进行绑定时使用的是上下文中的数据。这会对性能造成轻微地影响。
如果调用一次就能完成绑定的话，就不要使用这个方法。

同时对于其他格式，如 `Query`， `Form`，`FormPost`，`FormMultipart` 可以多次调用 `c.ShouldBind()` 而不会造成任何性能损失。

### 静态文件服务

```Golang
func main() {
 router := gin.Default()
 router.Static("/assets", "./assets")
 router.StaticFS("/more_static", http.Dir("my_file_system"))
 router.StaticFile("/favicon.ico", "./resources/favicon.ico")

 // 监听并在 0.0.0.0:8080 上启动服务
 router.Run(":8080")
}
```

### 静态文件嵌入

可以使用 [go-assets](https://github.com/jessevdk/go-assets) 将静态资源打包到可执行文件中。

### 控制日志输出颜色

```Golang
// 禁止日志的颜色
gin.DisableConsoleColor()

// 强制日志颜色化
gin.ForceConsoleColor()
```

### 路由参数

以 `:` 开头的是必须得有的，以 `*` 开头的则是有没有都可

```golang
 // 此 handler 将匹配 /user/john 但不会匹配 /user/ 或者 /user
 router.GET("/user/:name", func(c *gin.Context) {
  name := c.Param("name")
  c.String(http.StatusOK, "Hello %s", name)
 })

 // 此 handler 将匹配 /user/john/ 和 /user/john/send
 // 如果没有其他路由匹配 /user/john，它将重定向到 /user/john/
 router.GET("/user/:name/*action", func(c *gin.Context) {
  name := c.Param("name")
  action := c.Param("action")
  message := name + " is " + action
  c.String(http.StatusOK, message)
 })
```

### 路由组

```golang
v1 := router.Group("/v1")
{
  v1.GET("/login", loginEndpoint)
}
```

| 标签                 | 作用                                                            | 示例                        |
| -------------------- | --------------------------------------------------------------- | --------------------------- |
| -                    | skip                                                            | Password string \`json:"-"` |
| \|                   | or，允许使用多个验证器和接受                                    |                             |
| structonly           | 验证嵌套结构体，但不验证内部的字段                              |                             |
| nostructlevel        | 与structonly标签相同，只是不会运行任何结构体级别的验证          |                             |
| omitempty            | 无值不验证，有值验证                                            |                             |
| omitnil              | 允许在值为 nil 时跳过验证                                       |                             |
| dive                 | 告诉验证器深入到切片，数组或map并验证                           |                             |
| keys&endkeys         |                                                                 |                             |
| required             | 验证值不是默认的零值                                            |                             |
| required_if          | 字段必须存在，当仅当all时不为空，其他指定的字段等于字段后面的值 |                             |
| required_unless      | 字段必须存在，除非参数等于给定的值                              |                             |
| required_with        | 字段存在则请求该字段                                            |                             |
| required_with_all    | 如果字段都存在则请求该字段                                      |                             |
| required_without     | 如果字段不存在则请求该字段                                      |                             |
| required_without_all | 如果字段都不存在，则请求该字段                                  |                             |
| excluded_if          | 如果字段等于指定的值，则排除该字段                              |                             |
| excluded_unless      | 排除该字段，除非值为给定的值                                    |                             |
| isdefault            | 验证该值是默认的零值                                            |                             |
| len                  | 验证给定参数为指定的长度或时间                                  |                             |
| max                  | 验证给定参数小于等于长度或时间                                  |                             |
| min                  | 验证给定参数大于等于长度或时间                                  |                             |
| eq                   | 验证数量或时间相等                                              |                             |
| ne                   | 验证数量或时间不相等                                            |                             |
| oneof                | 验证参数为给定参数的一个                                        |                             |
| gt                   | 验证参数大于指定参数                                            |                             |
| gte                  | 验证参数大于等于指定参数                                        |                             |
| lt                   | 验证参数小于指定参数                                            |                             |
| lte                  | 验证参数小于等于指定参数                                        |                             |
| eqfield              | 验证参数等于另一个字段                                          |                             |

### 模型绑定和验证

要将请求体绑定到结构体中，使用模型绑定。Gin 目前支持 `JSON`、`XML`、`YAML`和标准表单值的绑定(foo=bar&boo=baz)。
使用时，需要在要绑定的所有字段上，设置响应的tag。例如使用JSON绑定时，g置字段标签为 `json:"fieldname"`。
Gin提供了两类绑定方法：

- Type-Must bind

  - Methods -Bind,BindJSON,BindXML,BindQuery,BindYAML
  - Behavior -这些方法属于 MustBindWith 的具体调用。如果发生绑定错误，则请求终止。

- Type-Should bind
  - Methods -ShouldBind,ShouldBindJSON,ShouldXML,ShouldBindQuery,ShouldBindYAML
  - Behavior - 这些方法属于 `ShouldBindBodyWith` 的具体调用。如果发生绑定错误，Gin会返回错误并由开发者处理错误和请求。

```golang
type Person struct {
 ID   string `json:"id" binding:"required"`
 Name string `json:"name" binding:"required"`
}

func main() {
 r := gin.Default()
 r.POST("/login", func(ctx *gin.Context) {
  var person Person

  if err := ctx.ShouldBindJSON(&person); err != nil {
   ctx.JSON(http.StatusBadRequest, gin.H{
    "error": err.Error(),
   })
  }
  if person.Name == "name" {
   ctx.JSON(http.StatusOK, gin.H{
    "status": "OK",
   })
  }
 })
 r.Run(":8080")
}


// 传参错误
{
    "error": "Key: Person.ID Err:Field validation 'ID' failed on the 'required' tag
Key: 'Person.Name' Error:Field validation for 'Name' failed on the 'required' tag"
}
```

### 如何记录日志

```golang
func main() {
    // 禁用控制台颜色，将日志写入文件时不需要控制台颜色。
    gin.DisableConsoleColor()

    // 记录到文件。
    f, _ := os.Create("gin.log")
    gin.DefaultWriter = io.MultiWriter(f)

    // 如果需要同时将日志写入文件和控制台，请使用以下代码。
    // gin.DefaultWriter = io.MultiWriter(f, os.Stdout)

    router := gin.Default()
    router.GET("/ping", func(c *gin.Context) {
        c.String(200, "pong")
    })

    router.Run(":8080")
}
```

### 上传文件

#### 单文件

```golang
func main() {
 r := gin.Default()
 // 为 multipart forms 设置较低的内存限制（默认是 32 MIB）
 r.MaxMultipartMemory = 8 << 20
 r.POST("/upload", func(ctx *gin.Context) {
  // 单文件
  file, _ := ctx.FormFile("file")
  log.Println(file.Filename)

  dst := "./" + file.Filename

  // 上传文件至指定的完整文件路径
  ctx.SaveUploadedFile(file, dst)
  ctx.String(http.StatusOK, fmt.Sprintf("'%s' upload", file.Filename))
 })
 r.Run(":8080")
}
```

#### 多文件上传

```golang
func main() {
 r := gin.Default()
 // 为 multipart forms 设置较低的内存限制（默认是 32 MIB）
 r.MaxMultipartMemory = 8 << 20
 r.POST("/upload", func(ctx *gin.Context) {
  //多文件
  form, _ := ctx.MultipartForm()
  files := form.File["files"]
  for _, v := range files {
   log.Println(v.Filename)
   dst := "./" + v.Filename
   ctx.SaveUploadedFile(v, dst)
  }
  ctx.String(http.StatusOK, fmt.Sprintf("%d files uploaded", len(files)))

 })

 r.Run(":8080")
}
```

### 设置和获取 Cookie

```golang
func main() {
  router := gin.Default()
  router.GET("/cookie", func(c *gin.Context){
    cookie,err := c.Cookie("gin_cookie")
    if err != nil {
      cookie = "NotSet"
      c.SetCookie("gin_cookie", "test", 3600, "/", "localhost", false, true)

    }
  })
  router.Run()
}
```

### 使用 BasicAuth 中间件

```golang
// 私密数据
var secrets = gin.H{
 "admin": "adminPassword",
}

func main() {
 r := gin.Default()
 // 路由组使用 gin.BasicAuth() 中间件
 // gin.Accounts 是 map[string]string 的一种快捷方式
 authorized := r.Group("/admin", gin.BasicAuth(gin.Accounts{
  "admin": "adminPassword",
  "user":  "userPassword",
 }))

 {
  authorized.GET("/secrets", func(ctx *gin.Context) {
   // 获取用户，他是由 BasicAuth 中间件设置的
   user := ctx.MustGet(gin.AuthUserKey).(string)
   if secret, ok := secrets[user]; ok {
    ctx.JSON(http.StatusOK, gin.H{"user": user, "secret": secret})
   } else {
    ctx.JSON(http.StatusOK, gin.H{"user": user, "secret": "NO SECRET :("})
   }
  })
 }
 r.Run(":8080")
}
```

### 使用中间件

```Golang
func main() {
 // 新建一个没有任何默认中间件的路由
 r := gin.New()

 // 全局中间件
 // Logger 中间件将日志写入 gin.DefaultWriter，即使你将 GIN_MODE 设置为 release。
 // By default gin.DefaultWriter = os.Stdout
 r.Use(gin.Logger())

 // Recovery 中间件会 recover 任何 panic。如果有 panic 的话，会写入 500。
 r.Use(gin.Recovery())

 // 你可以为每个路由添加任意数量的中间件。
 r.GET("/benchmark", MyBenchLogger(), benchEndpoint)

 // 认证路由组
 // authorized := r.Group("/", AuthRequired())
 // 和使用以下两行代码的效果完全一样:
 authorized := r.Group("/")
 // 路由组中间件! 在此例中，我们在 "authorized" 路由组中使用自定义创建的
    // AuthRequired() 中间件
 authorized.Use(AuthRequired())
 {
  authorized.POST("/login", loginEndpoint)
  authorized.POST("/submit", submitEndpoint)
  authorized.POST("/read", readEndpoint)

  // 嵌套路由组
  testing := authorized.Group("testing")
  testing.GET("/analytics", analyticsEndpoint)
 }

 // 监听并在 0.0.0.0:8080 上启动服务
 r.Run(":8080")
}
```

### 优雅地重启或停止

```golang
func main() {
 r := gin.Default()
 r.GET("/", func(ctx *gin.Context) {
  time.Sleep(5 * time.Second)
  ctx.String(http.StatusOK, "Welcome Gin Server")
 })

 srv := &http.Server{
  Addr:    ":8080",
  Handler: r,
 }

 go func() {
  // 服务连接
  if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
   log.Fatalf("Listen: %s\n", err)
  }
 }()

 // 等待中断信号以优雅地关闭服务器（设置 5 秒地超时时间）
 quit := make(chan os.Signal, 1)
 signal.Notify(quit, os.Interrupt)
 <-quit
 log.Println("Shutdown Server ...")

 c, cancel := context.WithTimeout(context.Background(), 5*time.Second)
 defer cancel()
 if err := srv.Shutdown(c); err != nil {
  log.Fatal("Server Shutdown:", err)
 }
 log.Println("Server exiting")
}
```

### 在中间件中使用 goroutine

当在中间件或handler中启动新的goroutine时，**不能**使用原始的上下文，必须使用只读副本。

```Golang
 r.GET("/long_async", func(c *gin.Context) {
  // 创建在 goroutine 中使用的副本
  cCp := c.Copy()
  go func() {
   // 用 time.Sleep() 模拟一个长任务。
   time.Sleep(5 * time.Second)

   // 请注意您使用的是复制的上下文 "cCp"，这一点很重要
   log.Println("Done! in path " + cCp.Request.URL.Path)
  }()
 })
```

### 重定向

#### HTTP 重定向。内部外部重定向均支持

```golang
r.GET("/test", func(c *gin.Context) {
 c.Redirect(http.StatusMovedPermanently, "http://www.google.com/")
})

r.POST("/test", func(c *gin.Context) {
 c.Redirect(http.StatusFound, "/foo")
})
```

#### 路由重定向，使用 HandleContext

```golang
r.GET("/test", func(c *gin.Context) {
    c.Request.URL.Path = "/test2"
    r.HandleContext(c)
})
r.GET("/test2", func(c *gin.Context) {
    c.JSON(200, gin.H{"hello": "world"})
})
```

### 自定义中间件

```golang
func Logger() gin.HandlerFunc {
 return func(c *gin.Context) {
  t := time.Now()

  // 设置 example 变量
  c.Set("example", "12345")

  // 请求前

  c.Next()

  // 请求后
  latency := time.Since(t)
  log.Print(latency)

  // 获取发送的 status
  status := c.Writer.Status()
  log.Println(status)
 }
}
```

## GORM

### 模型定义

GORM 通过将 Go 结构体（Go Struct）映射到数据库来简化数据库交互。了解如何在 GORM 中定义模型，
是充分利用 GORM 全部功能的基础。

模型是使用普通结构体定义的。这些结构体可以包含具有基本Go类型、指针或这些类型的别名，
甚至是自定义类型（只需要实现`database/sql` 包中的 Scanner 和 Valuer 接口）。

- 具体的数字类型如 `uint`、`string`和`uint8`直接使用。
- 指向 `*string`的指针类型表示可空字段。
- 使用 `database/sql` 包的 `sql.NullString` 用于具有更多控制的可空字段。
- `CreateAt` 和 `UpdateAt` 是特殊字段，当记录创建或更新时，GORM 会自动向内填充时间。

#### 约定

1. 主键:GORM 使用一个名为`ID`的字段作为每个模型的默认主键。
2. 表名：默认情况下，GORM 将结构体名称转为 `snake_case` 并为表名加上复数形式。
   例如一个`User`结构体在数据库的表名变为 `users`。
3. 列名：GORM 自动将结构体字段名称转化为 `snake_case` 来作为数据表中的列名。
4. 时间戳字段 `CreateAt` 和 `UpdateAt`

#### 字段权限控制

```golang
type User struct {
 Name1 string `gorm:"<-:create"`          // 允许读和创建
 Name2 string `gorm:"<-:update"`          // 允许读和更新
 Name3 string `gorm:"<-"`                 // 允许读和写（创建和更新）
 Name4 string `gorm:"<-:false"`           // 只读
 Name5 string `gorm:"->"`                 // 只读
 Name6 string `gorm:"->;<-:create"`       //允许读写
 Name7 string `gorm:"->:false;<-:create"` //仅能创建，禁止从db读
 Name8 string `gorm:"-"`                  // 通过 struct 读写会忽略该字段
 Name9 string `gorm:"-:all"`              // 通过 struct 读写、迁移会忽略该字段
 Name0 string `gorm:"-:migration"`        //通过 struct 迁移会忽略该字段
}
```

#### 创建/更新时间追踪(纳秒，毫秒，秒，Time)

GORM 约定使用 `CreateAt` 和 `UpdateAt` 追踪创建和更新时间。如果在模型中定义了这两个字段，
GROM 会在创建和更新的时候自动填充当前字段。

要使用**不同名称的字段**，可以配置 `autoCreateTime` 和 `autoUpdateTime` 标签。

想要保存当前的时间戳，将 `time` 转为 `int` 类型即可。

```golang
type Model struct {
 CreateAt   time.Time // 在创建时，如果该字段为零值，则使用当花钱的时间进行填充
 UpdateAt   int64     // 在创建时该字段为零值或更新的时候，使用当前时间戳秒数来填充
 CreateTime int64     `gorm:"autoCreateTime:nano"`  // 使用时间戳纳秒数进行填充
 UpdateTime int64     `gorm:"autoUpdateTime:milli"` // 使用时间戳毫秒数进行填充
 Create     int64     `gorm:"autoCreateTime"`       // 使用时间戳秒数进行填充
}
```

#### 嵌入结构体

对于正常的结构体，可以通过标签 `embedded` 将其嵌入。可以使用标签 `embeddedPrefix` 来为 db 的字段名添加前缀。

#### 字段标签

声明 model 的时候， tag是可选的，GORM 支持以下tag：tag名大小写不敏感，但是建议使用`camelCase`

| 标签名                | 说明                                                 |
| --------------------- | ---------------------------------------------------- |
| column                | 指定 db 列名                                         |
| type                  | 列数据类型，推荐使用兼容好的通用类型                 |
| serializer            | 指定将数据序列化或反序列化到数据库的序列化器         |
| size                  | 定义列数据类型的长度                                 |
| primaryKey            | 将列定义为主键                                       |
| unique                | 将列定义为唯一                                       |
| default               | 定义列的默认值                                       |
| precssion             | 指定列的精度                                         |
| scale                 | 指定列大小，比如DECIMAL(20,2)                        |
| not null              | 指定列为not null                                     |
| autoIncrement         | 指定列为自动增长                                     |
| autoIncementIncrement | 自动步长，控制连续记录之间的间隔                     |
| embedded              | 嵌套字段                                             |
| embeddedPrefix        | 嵌入字段的列名前缀                                   |
| autoCreateTime        | 创建时追踪当前时间                                   |
| autoUpdateTime        | 创建/更新时追踪当前时间                              |
| index                 | 根据参数创建索引多个字段使用相同的名称则创建复合索引 |
| uniqueIndex           | 与 index 相同，但是你创建的是唯一索引                |
| check                 | 创建检查约束                                         |
| <-                    | 设置字段的写入权限                                   |
| ->                    | 设置字段的读权限                                     |
| -                     | 忽略该字段                                           |
| comment               | 迁移时为字段添加注释                                 |

### 连接数据库

GORM 官方支持的数据库类型有：MySql,PostgresSql,Sqlite，SQL Server 和 TiDB

这里使用PostgresSql 做演示。

```golang
func main() {
 db, err := gorm.Open(
  postgres.Open("host=host user=user password=pd dbname=gorm port=5432 sslmode=disable TimeZone=Asia/Shanghai"),
  &gorm.Config{
   Logger:                 logger.Default.LogMode(logger.Info),
   SkipDefaultTransaction: true,
  },
 )

 if err != nil {
  log.Fatalln("init gorm conn:", err)
 }
 // 连接池， GORM 使用`database/sql`来维护连接池
 sqlDB, err := db.DB()
 if err != nil {
  log.Fatalln("init db conn:", err)
 }
 // 设置保持空闲连接的数量，如果<=0，则没有空闲连接，默认是2，就是说会有两个连接一直保持，等待使用
 sqlDB.SetMaxIdleConns(3)
 // 设置连接的最大空闲时间，过期的连接可能会在重用之前被延迟关闭，如果 <= 0连接不会关闭，单位是纳秒，可以使用time包中的Hour等
 sqlDB.SetConnMaxLifetime(time.Hour)
 // 设置最大的连接数，如果不设置（0）就是不限制。但是无限创建可能有性能瓶颈。所以需要根据数据库性能来进行配置。
 // 当超出设定的数量，在等到超时之前，有连接释放就会获得操作的权限，如果没有则返回连接超时。
 // 最大连接数 必须大于 最大空闲数
 sqlDB.SetMaxOpenConns(100)
 // 连接的空闲时间
 sqlDB.SetConnMaxLifetime(time.Minute * 3)
}
```

### CRUD

#### 创建

> [!IMPORTANT]
> 必须向create传递指针，而不能是结构体

##### 单条记录

```golang
func main() {
 db := GetDB()
 // 自动迁移, 自动创建表
 // db.AutoMigrate(&model.User{})
 user := model.User{Name: "new001", Age: 24}
 if err := db.Create(&user).Error; err != nil {
  log.Fatalln("insert user err", err)
 }
}
```

##### 也可以创建多条数据

```Golang
func main() {
 db := GetDB()
 user := []model.User{
  {Name: "new001", Age: 24},
  {Name: "xlex", Age: 32},
 }
 if err := db.Create(&user).Error; err != nil {
  log.Fatalln("insert user err", err)
 }
}
```

##### 用指定的字段创建记录，Select 是选定字段，Omit 是排除这些字段

```golang
db.Select("Name", "Age").Create(&user)

db.Omit("CreateAt", "Age").Create(&user)
```

##### 批量插入

批量插入，要高效地插入大量记录，请将切片传递给`Create`方法。
GORM 将生成一条SQL来插入所有数据，并返回所有的主键值，并触发`Hook`方法。
当这些记录可以被分割成多个批次时，GORM 会开启一个事务来处理。

```Golang
var users = []User{{Name: "jinzhu1"}, {Name: "jinzhu2"}, {Name: "jinzhu3"}}
db.Create(&users)

for _, user := range users {
  user.ID // 1,2,3
}
```

可以通过 `db.CreateInBatches` 方法来指定批量插入的批次的大小。

```golang
db.CreateInBatches(users, 100)
```

可以在初始化gorm的时候使用`CreateInBatchSize`，之后所有的创建&关联行为都会遵循此配置。

```golang
db, err := gorm.Open(sqlite.Open("gorm.db"), &gorm.Config{
  CreateBatchSize: 1000,
})

db := db.Session(&gorm.Session{CreateBatchSize: 1000})

users = [5000]User{{Name: "jinzhu", Pets: []Pet{pet1, pet2, pet3}}...}

db.Create(&users)
```

##### 创建钩子

GORM 允许用户通过实现一个接口`BeforeSave`,`BeforeCreate`,`AfterSave`,`AfterCreate` 来自定义钩子。

```golang
func (u *User) BeforeCreate(tx *gorm.DB) (err error) {
  u.UUID = uuid.New()

    if u.Role == "admin" {
        return errors.New("invalid role")
    }
    return
}
```

如果想跳过Hooks方法，可以使用`SkipHooks`会话模式

```golang
DB.Session(&gorm.Session{SkipHooks:true}).Create(&user)
```

根据map创建，不会执行钩子方法，也不会回写主键。

##### 关联创建

关联创建。在该模型中关联了另一个模型，那么这个关联也会被`upsert`， 并且它们的Hooks方法也会被调用。
可以通过 Select 和 Omit 跳过关联。

#### 查询

##### 检索单条数据

GORM 提供了`First`,`Take`,`Last` 方法，以便从数据库中查询单个对象。
添加了 `LIMIT 1`，没有找到时，返回 `ErrRecodeNotFound` 错误。

```golang
var user model.User
// 获取第一条数据（主键升序）SELECT * FROM users ORDER BY id LIMIT 1;
db.First(&user)

// 获取第一条数据，不排序 SELECT * FROM users LIMIT 1;
db.Take(&user)

// 获取最后一条数据（主键降序） SELECT * FROM users ORDER BY id DESC LIMIT 1;
db.Last(&user)

// 检查是否是 ErrRecodeNotFound 错误
errors.Is(result.Error, gorm.ErrRecodeNotFound)
```

`First` 和 `Last` 方法会按照主键排序找到第一条数据和最后一条数据。
只有在目标 struct 是指针或者 `db.Model()` 指定model时，此方法才有效。
此外，如果相关 model 没有定义主键，那么按 model 的第一个字段进行排序。

```golang
func main() {
 db := GetDB()
 var user model.User
 // 可以工作，因为指定了结构体的指针
 db.First(&user)

 result := map[string]interface{}{}
 // 可以工作，使用 db.Model 指定了具体模型的指针
 db.Model(&model.User{}).First(&result)

 // take
 db.Table("users").Take(&result)
 fmt.Printf("user: %v\n", user)
}
```

##### 根据主键检索

如果主键是数字类型，你可以使用内联变量来检索对象。当使用字符串时，需要额外注意来避免SQL注入。

```golang
// SELECT * FROM users WHERE id = 10;
db.First(&user, 10)

// SELECT * FROM users WHERE id = 10;
db.First(&user, "10")
// SELECT * FROM users where id in (1, 2, 3);
db.Find(&users, []{1,2,3})
```

如果主键是字符串，可以这样写

```golang
db.First(&user, "id = ?", "123hjjhbgbhggggggggg")
```

当目标对象有一个主键值的时候，将使用主键构建查询条件：例如：

```golang
var user = User{ID: 10}

// select * from users where id = 10;
db.First(&user)

var result User
// select * from users where id = 10;
db.Model(User{ID:10}).First(&user)
```

##### 检索全部对象

```golang
func main() {
 db := GetDB()
 var users []model.User
 result := db.Find(&users)
 fmt.Printf("result.RowsAffected: %v\n", result.RowsAffected)
}
```

##### 条件

###### String 条件

```golang
// 获取第一个匹配的记录 SELECT * FROM users where name = 'alex' order by id limit 1;
db.Where("name = ?", "alex").First(&user)

// 获取所有匹配的记录 select * from users where name != 'alex';
db.Where("name != ?", "alex").Find(&users)

// IN  select * from users where name in ('alex', 'mark');
db.Where("name IN ?", []string{"alex", "mark"}).Find(&users)

// like  select * from users where name like %le%;
db.Where("name like ?", "%le%").Find(&users)

// AND select * from users where name = 'alex' and age >= 22;
db.Where("name = ? and age >= ?", "alex", "22").Find(&users)

// Time  select * from users where update_at > '2024-05-09'
db.Where("update_at > ?", lastWeek).Find(&users)
```

> [!IMPORTANT]
> 如果对象设置了主键，条件查询将不会覆盖主键的值，而是用 And 连接条件。

```golang
var user = User{ID: 10}
// select * from users where id = 10 and id = 20 order by id limit 1;
db.Where("id = ?", 20).First(&user)
```

###### Struct & Map 条件

```Golang
// Struct  select * from users where name = 'alex' and age = 10 order by id limit 1;
db.Where(&User{Name:"alex", Age: 10}).First(&user)

// Map select * from users where name = 'alex' and age  =10;
db.Where(map[string]interface{}{"name":"alex","age":10}).Find(&users)

// 主键切片 select * from users where id in (10, 20, 21);
db.Where([]int64{10,20,21}).Find(&users)
```

> [!IMPORTANT]
> 当使用结构体构建查询条件时，零值不会用于构建查询条件，要想条件包含零值，可以使用 map。

###### 选定特定的字段

```golang
db.Select("name","age").Find(&users)
```

###### 排序

```golang
// select * from users order by age desc, name
db.Order("age desc, name").Find(&users)
```

###### Limit & Offset

```golang
db.Limit(1).Offset(10).Find(&users)
```

###### Group By & Having

```golang
// SELECT name, sum(age) as total FROM `users` GROUP BY `name` HAVING name = "group"
db.Model(&User{}).Select("name, sum(age) as total").Group("name")
.Having("name = ?", "group").Find(&result)
```

###### Distinct

```golang
db.Distinct("name", "age").Order("name, age desc").Find(&results)
```

###### Joins

```golang
db.Model(&User{}).Select("users.name, emails.email").
Joins("left join emails on emails.user_id = users.id").Scan(&result{})
```

###### Scan

Scan 和 find 的功能差不多，但是Scan使用的时候需要显式地指出数据库的表名。

```golang
type Result struct {
  Name string
  Age  int
}

var result Result
db.Table("users").Select("name", "age").Where("name = ?", "Antonio").Scan(&result)

// Raw SQL
db.Raw("SELECT name, age FROM users WHERE name = ?", "Antonio").Scan(&result)
```

#### 高级查询

##### 字段选择

在查询的时候，字段较少的时候，可以使用 `Select` 指定，字段较多的时候，可以指定一个
包含多个字段的模型（结构体）

```Golang
type User struct {
  ID     uint
  Name   string
  Age    int
  Gender string
  // 很多很多字段
}

type APIUser struct {
  ID   uint
  Name string
}

// 在查询时，GORM 会自动选择 `id `, `name` 字段
db.Model(&User{}).Limit(10).Find(&APIUser{})
// SQL: SELECT `id`, `name` FROM `users` LIMIT 10

```

##### 锁(gorm)

pass

#### 更新

##### 保存所有字段

`Save` 会保存所有的字段，即使该字段是零值。
`Save` 是一个组合函数，如果保存的值不包含主键，它将执行`Create`，否则它将执行`Update`， 包含所有的字段。

##### 更新单个列

当使用 `Update` 更新单列时，需要有一些条件（**阻止全局更新** ），当使用 `Model`，并且有主键的时候，
主键将被用于构建条件。

```golang
// 根据条件更新
db.Model(&User{}).Where("activate = ?", true).Update("name", "hello")
```

##### 更新多列

`Updates` 方法支持 `Struct` 和 `map[string]interface{}` 参数。当使用 `struct` 更新时，默认情况下只会更新非零值的字段。

```golang
// 根据 `struct` 更新属性，只会更新非零值的字段
db.Model(&user).Updates(User{Name: "hello", Age: 18, Active: false})

// 根据 `map` 更新属性
db.Model(&user).Updates(map[string]interface{}{"name": "hello", "age": 18})
```

#### 删除

##### 删除一条记录

当删除一条数据的时候，需要指定主键，否则会触发**批量删除**

```Golang
delete from users where id = 10;
db.Delete(&User{}, 10)
```

##### 批量删除

如果指定的值不包括主键，那么 GORM 会执行批量删除，它将删除所有匹配的数据。

```golang
db.Where("name like ?", "%al").Delete(&Email{})

// 可以传递一个主键的切片，可以更高效的删除、
```

##### 软删除

如果模型包含了 `gorm.DeletedAt` 字段，那么该模型的调用`Delete`的时候，是软删除。

```golang
UPDATE "users" SET "deleted_at"='2024-06-05 13:50:43.549'
WHERE id = 1 AND "users"."deleted_at" IS NULL
```

###### 查找被软删除的记录

可以使用`Unscoped` 来查询到被软删除的记录

```golang
db.Unscoped().Where("age = 20").Find(&users)
```

##### 永久删除

可以使用`Unsoped` 来永久删除匹配的记录

```golang
db.Unsoped().Delete(&order)
```

#### SQL 构建器

##### 原生sql

```golang
db.Raw("SELECT id, name, age from users where id = ?", 7).Scan(&result)
```

### 关联

#### Belongs To

Belongs To 会与另一个模型建立了一对一关系。这种模型的每一个实例都属于另一个模型的一个实例。
比如，每个 user 能且只能被分配给一个 company.

#### Has One

`has one` 与另一个模型建立一对一的关系。和 Belongs To 关系相反。

#### Has Many

`has many` 与另一个模型建立了一对多的连接、当前模型可以拥有零或多个关联的模型。

#### Many To Many

user 会多种 language, 多个 user 也可以说一种 language

### 会话

为了避免共用DB导致的一些问题， gorm 提供了会话模式，通过新建 session 的形式，
将 db 的操作分离，互不影响。

```golang
type Session struct {
 DryRun                   bool   // 生成SQL但不执行
 PrepareStmt              bool   // 预编译模式
 NewDB                    bool   // 新的db, 不带之前的条件
 Initialized              bool   // 初始化新的db
 SkipHooks                bool   // 跳过执行钩子函数
 SkipDefaultTransaction   bool   // 跳过默认的事物
 DisableNestedTransaction bool   // 禁用嵌套事物
 AllowGlobalUpdate        bool   // 允许全局更新
 FullSaveAssociations     bool   // 允许更新关联字段
 QueryFields              bool   // 查询的字段，开启后 * -> 具体的字段名
 Context                  context.Context  // 上下文，可以传一个超时的上下文来控制执行的时间
 Logger                   logger.Interface
 NowFunc                  func() time.Time
 CreateBatchSize          int    // 创建的批次大小
}
```

### 事务

#### 自动事务

```golang
db.Transaction(func(tx *gorm.DB) error {
  // 在事物中执行一些 db 操作。从这里开始，数据库操作应该使用tx， 而不是db
  if err := tx.Create(&Animal{Name: "cat"}).Error; err != nil {
    // 返回任何的错误都会回滚事务
    return err
  }
  // 返回nil提交事物
})
```

#### 手动事物

Gorm 支持直接调用事务控制方法

```golang
// 开始事务
tx := db.Begin()

// 在事务中执行一些db操作，从这里开始，应该使用 `tx` 而不是 `db`
tx.Create(...)

// 遇到错误的时候回滚事物
tx.Rollback()

// 否则，提交事务
tx.Commit()
```

一个特殊的示例

```golang
func CreateAnimals(db *gorm.DB) error {
  // 再唠叨一下，事务一旦开始，你就应该使用 tx 处理数据
  tx := db.Begin()
  // defer & recover
  defer func() {
    if r := recover(); r != nil {
      tx.Rollback()
    }
  }()

  if err := tx.Error; err != nil {
    return err
  }

  if err := tx.Create(&Animal{Name: "Giraffe"}).Error; err != nil {
     tx.Rollback()
     return err
  }

  if err := tx.Create(&Animal{Name: "Lion"}).Error; err != nil {
     tx.Rollback()
     return err
  }

  return tx.Commit().Error
}
```

#### 嵌套事务

GORM 支持嵌套事务，可以回滚较大事务内执行的一部分操作

```golang
db.Transaction(func(tx *gorm.DB) error {
  tx.Create(&user1)

  tx.Transaction(func(tx2 *gorm.DB) error {
    tx2.Create(&user2)
    return errors.New("rollback user2") // Rollback user2
  })

  tx.Transaction(func(tx3 *gorm.DB) error {
    tx3.Create(&user3)
    return nil
  })

  return nil
})
```

#### SavePoint, RollbackTo

GORM 提供了 SavePoint， RollbackTo 方法，来提供保存点以及回滚至保存点的功能

```golang
tx := db.Begin()
tx.Create(&user1)

tx.SavePoint("sp1")
tx.Create(&user2)
tx.RollbackTo("sp1") // Rollback user2

tx.Commit()
```
