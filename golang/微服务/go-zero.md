# gozero

下载 goctl(go control)，是 go-zero 微服务框架下的代码生成工具。其功能有：

- api 服务生成
- rpc 服务生成
- model 代码生成
- 模块管理

通过 goctl 下载其他工具：goctl env check -i -f --verbose

## goctl

```bash
# 根据api文件构建api服务
goctl api go --api *api --dir ../
```

## api

api 是 go-zero 自研的api描述语言，旨在实现人性化的基础描述乎语言，作为生成HTTP服务最基础的描述语言。

api 领域特性语言包括语法模块，info 块，结构体声明，服务描述等几大服务语法组成，其中结构体和Go的结构体语法几乎一样，只是移除了struct关键字。

### 语法

#### 注释

在api领域特性语言中有2中格式：

1. 单行注释以`//`开始
2. 多行注释（文档注释）以`/*`开始，以第一个`*/`

### 语法标记

#### syntax（计算机语言句法）

```api
syntax = "v1"
```

#### info 语句

info 语句是 api 语言的 meta 信息，其仅用于对当前的 api 文件进行描述， **暂**不参与代码生成，其和注释还是有一定的区别，
注释一般是依附某个 syntax 语句存在，而 info 语句是描述整个 api 信息的。

```api
info (
  author: name
  date: 2024-06-12
  desc: 用户模块的api
)
```

#### import 语句

`import` 语句是在 api 中引入其他 api 文件的语句块，其支持相对/绝对路径，**不支持** `package` 的设计。

```api
// 单行 import
import "foo"
import "/path/to/file"

// import 组
import (
  "bar"
  "relative/to/file"
)
```

#### 数据类型

api 中的数据类型基本上延续了 Golang 的数据类型。

```api
// 别名类型
type Integer = int

// 空结构体
type Foo{}

// 单个结构体
type Bar {
  Foo int               `json:"foo"`
  Bar bool              `json:"bar"`
  Baz []string          `json:"baz"`
  Qux map[string]string `json:"qux"`
}

// 结构体组
type (

)
```

> [!IMPORTANT] > [1] 虽然语法上支持别名，但是在语义分析时会对别名进行拦截
> [2] 虽然语法上支持结构体内嵌，但是在语义分析时会对此进行拦截

#### service 语句

service 语句是对 HTTP 服务的直观描述，包括请求 handel，请求方法，请求路由，请求体，响应体，jwt 开关，中间件声明等定义。

##### @server 语句

@server 语句是对一个服务语句的 meta 信息描述，其对应特性包括但不限于：

- jwt 开关
- 中间件
- 路由分组
- 路由分组

```api
@server (
  // jwt 声明
  // 如果key固定为“jwt:”，则代表开启jwt鉴权声明
  // value 则为配置文件的结构体名称
  jwt:Auth

  // 路由前缀
  // 如果key固定为prefix
  // 则代表由前缀声明
  prefix:/v1

  // 路由分组
  // 如果key固定为group，则代表路由分组声明
  // value则为具体的分组名称，在 goctl 生成代码后会根据此值进行文件夹分组
  group: Foo

  // 中间件
  // 如果key固定为middleware，则代表中间件声明
  // value则为具体的中间件名称，在 goctl 声明代码后会根据此值生成对应的中间件函数
  middleware: AuthInterceptor

  // 超时控制
  // 如果key为固定的 timeout, 则代表超时配置
  // value 为具体中的 duration，在 goctl 生成代码后会根据此值生成对应的超时配置
  timeout:3s

  // 除了上述几个内置的key之外，其他的key-value可以作为annotation信息传递给goctl及其插件，但是目前goctl并未使用。
  foo:var
)
```

##### 服务条目

服务条目（ServiceItemStmt）是对单个 HTTP 请求的描述，包含 @doc 语句， handler 语句，路由语句信息。

###### @doc 语句

@doc 语句是对单个路由的meta描述，一般为 key-value 值，可以传递给 goctl 及其插件来进行扩展生成。

###### handler 语句

@handler 语句是对单个路由的 handler 信息控制，主要用于生成 golang http.HandleFunc 的实现转换方法

```api
@handler foo
```

###### 路由语句

路由语句是对单次 HTTP 请求的具体描述，包括请求方法，请求路径，请求体，响应体信息。

```api
// 没有请求体和响应体的写法
get /ping

// 只有请求体的写法
get /foo(req)

// 只有响应体的写法
post /foo returns(res)

// 在请求体和响应体的写法
post /foo(req) returns(res)
```

service写法

```api
// 带@server的写法
@server {
  prefix:/v1
  group:Login
}
service user {
  @doc "登陆"
  @handler Login
  post /user/login (LoginReq) returns (LoginResp)
}

@server{
  prefix:/v1
  middleware:AuthInterceptor
}

service user {
  @doc "登陆"
  @handler Login
  post /user/login (LoginReq) returns (LoginResp)
}


// 不带 @server的写法
service user {
    @doc "登录"
    @handler login
    post /user/login (LoginReq) returns (LoginResp)

    @handler getUserInfo
    get /user/info/:id (GetUserInfoReq) returns (GetUserInfoResp)
}

```

## 中间件

在 api 等文件中定义的 middleware 只能作用于下方定义的service中，在启动文件中可以使用全局中间件, 使用时，先进全局中间件，后进局部中间件

```bash
global before
before
after
global end
```

## 日志

```bash
Log:
  ServiceName: user-api
  # Mode: console
  Mode: file
  # Encoding: plain
  Encoding: json
```

## model gen

goctl model 为 goctl 提供数据库模型代码生成指令，目前只支持 MYSQL, POSTGRESQL, MONGO 的代码生成，
MYSQL 支持从 sql 文件和数据库连接两种方式生成。
POSTGRESQL 仅支持从数据库连接生成。

```shell
#!/bin/bash

user=root
password=qwert12345
host=127.0.0.1
port=3306
tables=("user" "company")
style=goZero
cache=true #是否生成带缓存的代码
dbname=gozero_study
modeldir=./genModel

for((i=0;i<"${#tables[*]}";i++)); do
    echo "开始生成 '${tables[i]}' 代码"
    goctl model mysql datasource --url="${user}:${password}@tcp(${host}:${port})/${dbname}" --table="${tables[i]}" --style="${style}" --dir="${modeldir}" --cache="${cache}"
done
```

## rpc
