# Redis

Redis 有 5 个基本的数据结构。

- String：字符串
- Hash：哈希
- List：列表
- Set：集合
- Sorted Set：有序集合

## Redis 数据类型

Redis 主要支持以下几种数据类型：

- **string（字符串）**：基本的数据存储单元，可以存储字符串、整数或者浮点数。
- **hash（哈希）**：一个键值对集合，可以存储多个字段。
- **list（列表）** ：一个简单的列表，可以存储一系列的字符串元素。
- **set（集合）**：一个无序的集合，可以存储不重复的字符串元素。
- **zset（sorted zset 有序集合）**：类似于集合，但是每个元素都有一个分数（score）与之关联。
- **Bitmaps**（位图）：基于字符串类型，可以对每个位进行操作。
- **HyperLogLogs**：用于基数统计，可以估算集合中唯一元素的数量。
- **Geospatial**：用于存储地理位置信息。
- **pub/sub（发布/订阅）**：一种消息通信模式，允许客户端订阅消息通道，并接收发布到该通道的消息。
- **streams（流）**：用于消息队列和日志存储，支持消息的持久化和时间排序。
- **modules（模块）**：redis 支持动态加载模块，可以扩展Redis的功能。

### String

string 是 redis 最基本的类型，一个 key 对应一个 value。
string 类型是二进制安全的。所以 redis 的 string 可以包含任何数据，比如jpg图片或者序列化的对象。
string 类型是 redis 最基本的数据类型，string 类型的最大值能存储 512 MB。

#### string 常用命令

- SET key value：设置键的值
- GET key：获取键的值
- INCR key：将键的值加1
- DECR key：将键的值减1
- APPEND key value：将值追加到键的值之后,就是append

#### 字符串命令

### Hash

Redis Hash 是一个键值对集合，类似一个小型的 NoSql 数据库。
Redis Hash 是一个 String 类型的 field 和 value 的映射表，Hash 适合用于存储对象。
每个 Hash 最多可以存储 2^32 - 1 个键值对。

#### hash 常用命令

- HSET key field value：设置哈希表中字段的值
- HGET key field：获取哈希表中字段的值
- HGETALL key：获取哈希表中所有的字段和值
- HDEL key value：删除哈希表中的一个或多个字段

### List

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部或者尾部。
列表最多可以存储2^32 - 1个元素。

#### list 常用命令

- LPUSH key value：将值插入到列表头部
- RPUSH key value：将值插入到列表尾部
- LPOP key：移出并获取列表的第一个元素
- RPOP key：移除并获取列表的最后一个元素
- LRANGE key start stop：获取列表在指定范围内的元素，两边都可以取到

### Set

Redis 的 Set 是 String 类型的无序集合。
集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。

#### set 常用命令

- SADD key value：向集合中添加一个或多个成员
- SREM key value：移除集合中一个或多个成员
- SMEMBERS key：返回集合中向的所有成员
- SISMEMBER key value：判断值是否是集合的成员

### zset

Redis zset 和 set 一样也是 string 类型元素的集合，且不允许重复的成员。
不同的是每个元素都会关联一个 double 类型的分数。redis 正是通过分数来为集合中的成员进行从小到大的排序。
zset 的成员是唯一的，但分数却可以重复。

#### zset 常用命令

- ZADD key score value：向有序集合添加一个或多个成员，或更新已存在成员的分数
- ZRANGE key start stop [WITHSCOPES]：返回指定范围的成员
- ZREM key value：移除有序集合中一个或多个成员
- ZSCORE key value：返回有序集合中，成员的分数值
