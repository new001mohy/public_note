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

通道(channels)是gorouting之间的通信机制。通道可用来两个 gorouting 之间通过传递一个指定类型的值来同步运行和通信。操作符 `<-` 用于指定通道的方向。如果未指定方向，则为双向通道。

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

从 nil 通道接收数据会永远阻塞。可以将通道设置为nil可以停止使用这个通道。

#### 通道通信

- 对于缓冲通道，向通道发送数据 `happens-before` 从通道接收到数据, 写 > 读
- 对于无缓冲通道，从通道接受到数据 `happens-before` 从通道发送数据，读 > 写

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

| 类型 | 格式 | 作用 |
| --------------- | --------------- | --------------- |
| 测试函数 | 函数名前缀为Test | 测试程序的一些逻辑是否正确 |
| 基准函数 | 函数名前缀为Benchmark | 测试函数的性能 |
| 示例函数 | 函数名前缀为Example | 为文档提供示例文档 |

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
