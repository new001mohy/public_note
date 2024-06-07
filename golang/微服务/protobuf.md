# Protobuf

## 基本规范

- 文件以`.proto` 做为文件后缀，除了结构定义的语句外以分号结尾
- 结构定义可以包含：message、service、enum
- rpc方法定义结尾的分号可有可无
- Message 命名采用驼峰命名的方式，字段命名采用小写字母加下划线的分割方式。

```txt
message SongServerRequest {
  required string song_name = 1;
}
```

- Enums 类型名采用大驼峰命名方式，字段命名采用大写字母加下划线的分割方式

```txt
enum Foo {
  FIRST_VALUE = 1;
  SECOND_VALUE = 2;
}
```

- Service 和 rpc 方法名统一采用驼峰式命名

## 字段规则

- 字段格式：`限定修饰符` `数据类型` `字段名称` = `字段编码值` `[字段默认值]`
- 限定修饰符包括：required\optional\repeated
  - required：表示一个必须字段，对于发送方，在发消息之前必须设置该字段的值，对于接收方，必须能识别该字段的意思。
    发送之前没有设置 required 字段或者无法识别 required 字段都会引发编解码异常，导致该字段被丢弃。
  - optional：表示是一个可选字段，对于发送方，在发送消息时，可以有选择性的设置或者不设置该字段的值。
  对于接收方，如果能够识别可选字段就进行相应的处理，如果无法识别，则忽略该字段。--因为 optional 字段的特性，
  很多接口在升级版本的时候都把后面添加的字段都统一设置为 optional 字段，这样老的版本无需升级程序也可以与新的服务通信。
  - repeated：表示该字段可以包含0～N个元素。其特性和 optional 一样，但是每一次可以包含多个值。可以看作是在传递一个数组的值。
- 数据类型
  
  - Protobuf 定义了一套基本数据类型
- 字段名称
  
  - 字段名称的命名和 Java 等语言变量的命名方式几乎是相同的
  - Protobuf 建议字段的命名采用下划线分割的方式。例如 first_name 而不是 firstName

- 字段编码值
  
  - 有了该值，通信双方才能互相识别对方的字段，相同的编码值，其限定修饰符和数据类型必须相同，编码值的取之范围是 `1~2^32`
  - 其中 1～15 的编码时间和空间效率都是最高的，编码值越大，其编码的时间和空间效率就越低，所以建议把经常要传递的值的字段编码设置为1～15之间的值。
  - 1900～2000 编码值为 Google protobuf 系统内部保留值，建议不要在自己的项目中使用。

- 字段默认值
  
  - 当在传递数据时，对于 required 数据类型，如果没有设置值，则使用默认值传递到对端。

## service 定义

- 如果想要将消息类型用在RPC系统中，可以在`.proto`文件中定义一个RPC服务接口，protobuf 编译器会根据所选择的不同语言生成服务接口代码
- 例如，想要定义一个RPC服务并具有一个方法，该方法接收 SearchRequest 并返回一个 SearchResponse，可以在 `.proto` 文件中进行如下定义：

```proto
service SearchRequest {
  rpc Search (SearchRequest) returns (SearchResponse) {}
}
```

- 生成的接口代码作为客户端与服务端的约定，服务端必须实现定义的所有接口方法，客户端直接调用同名方法向服务端发起请求，比较麻烦的是，即便业务上不需要参数也必须指定一个请求消息，一般会定义一个空message

## message 定义

- 一个 message 类型定义描述了一个请求或响应的消息格式，可以包含多种类型字段
- 例如定义一个请求的消息格式，每个请求包含查询字符串、页码、每页数目
- 字段名用小写，转为 Go 文件后自动变为大写，message 就相当于结构体

```proto
syntax = "proto3";

message SearchRequest {
  string query = 1;           // 查询字符串
  int32 page_number = 2;      // 页码
  int32 result_per_page = 3;  // 每页数据
} 
```

- 首行声明使用的 protobuf 版本为 proto3
- SearchRequest 定义了3个字段，每个字段声明以分号结尾。可以使用//添加行注释

## 添加更多的 Message 类型

- 一个 .proto 文件中可以定义多个消息类型，一般用于同时定义多个相关的消息，例如在一个.proto文件中同时定义搜索请求和响应消息。

```proto
syntax = "proto3"

// SearchRequest
message SearchRequest {
  string query = 1;           // 查询字符串
  int32 page_number = 2;      // 页码
  int32 result_per_page = 3;  // 每页条数
}

// SearchResponse
message SearchResponse {
  // ...
}
```

## 如何使用其他 Message

- message 支持嵌套使用，作为另一个 message 中的字段类型

```proto
message SearchResponse {
  repeated Result  results = 1;
}

message Result {
  string url = 1;
  string title = 2;
  repeated string snippets = 3;
}
```

## Message 嵌套的使用

- 支持嵌套消息，消息可以包含另一个消息作为其字段。也可以在消息内定义一个新的消息。
- 内部声明的message类型名称只可在内部直接使用

```proto
message SearchRequest {
  message Result {
    string url = 1;
    string title = 2;
    repeated string snippets = 3;
  }
  repeated Result results = 1;
}
```

- 也可以支持多层嵌套

```proto
message Outer {
  message MiddleAA {
    message Inner {
      int64 ival = 1;
      bool booly = 2;
    }
  }
}
```

## proto3 的 Map 类型

- proto3 支持 map 类型的声明

```proto
map<key_type, value_type> map_field = N;

message Project {...}

map<string, Project> projects = 1;
```

- 键、值类型可以是内置的类型，也可以是自定义的message类型
- 字段不支持 repeated 属性

## .proto 文件编译

- 通过定义好的.proto文件生成的Java, Python，C++，Go...代码，需要安装编译器 protoc
- 当使用protocol buffer 编译器运行 .proto 文件时，编译器将生成所选语言的代码，用于使用在.proto文件中定义的消息类型，服务接口约定等。不同的语言生成的代码格式不同：
  - C++：每个.proto文件生成一个.h文件一个.cc文件，每个消息类型对应一个类
  - Java：生成一个.java文件，同样每个消息对应一个类，同时还有一个特殊的Builder类用于创建消息接口
  - Python：每个.proto 文件中的消息类型生成一个含有静态描述符的模块，该模块与一个元类metaclass在运行时创建需要的Python数据访问类
  - Go：生成一个.pb.go文件，每个消息类型对应一个结构体
  - Ruby：生成一个.rb文件的Ruby模块，包含所有的消息类型
  - JavaNano：类似java,但不包含Builder类
  - Objective-C：每个.proto文件生成一个pbobjc.h和一个pbobjc.m文件
  - C#：生成.cs文件包含，每个消息类型对应一个类

## import 导入定义

- 可以使用 import 语句导入使用其他描述文件中的声明的类型
- protobuf 接口文件可以像C语言的h文件一样，分离为多个，在需要的时候通过 import 导入需要的文件。
其行为和C语言的`#include` 或者 java中的 `import` 行为大致相同
- protocol buffer 编译器会在 -I/ --proto_path 参数指定的目录中查找导入的文件，如果没有指定该参数，默认在当前目录中查找

## 包的使用

- 在.proto 文件中使用package声明包名，避免命名冲突

```proto
syntax = "proto3";
package foo.bar;
message Open {...}
```

- 在其他消息格式中可以使用包名+消息名的方式来使用类型，如

```proto
message Foo {
  foo.bar.Open open = 1;
}
```
