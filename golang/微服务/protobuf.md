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
  - required 表示一个必须字段，对于发送方，在发消息之前必须设置该字段的值，对于接收方，必须能识别该字段的意思。
    发送之前没有设置 required 字段或者无法识别 required 字段都会引发编解码异常，导致该字段被丢弃。
