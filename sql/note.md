# 窗口函数

## 什么是窗口函数

窗口函数是 SQL 标准中的一个高级特性，它允许用户在不改变查询结果集行数的情况下，对每一行执行聚合计算或者其他复杂的计算。
这些计算是基于当前行与结果集中的其他行的关系进行的。窗口函数特别适用于**需要执行跨多行的计算，同时又想保持原始查询结果集的行数不变的场景**。

### 窗口函数的原理

窗口函数是在原先的结果集上定义一个“窗口”来工作，这个窗口可以是整个结果集，或者是结果集的一个子集。窗口函数会对窗口内的行执行计算，并为每一行返回一个值。
这个值是根据窗口内行的值以及窗口函数本身的逻辑计算得出的。

窗口函数不会改变查询结果集的行数，而是为每一行添加一个额外的列，这个列包含了窗口函数的计算结果。

### 窗口函数的组成部分

```SQL
<窗口函数>(<参数>) OVER (
  [PARTITION BY <分区表达式>]
  [ORDER BY <排序表达式> [ASC | DESC]]
  [ROWS/RANGE <窗口范围>]
)
```

- <窗口函数>(<参数>)：指定要使用的窗口函数及其参数。窗口函数可以是聚合参数（如 SUM 等）也可以是窗口函数设计的函数（如 ROW_NUMBER 等）。
- OVER()：定义窗口的框架，所有的窗口函数都需要使用 OVER 子句来指定窗口的范围和行为。
- PARTITION BY <分区表达式>(可选)：将结果集分成多个分区，窗口函数会在每个分区内独立执行。分区表达式可以是一个或多个列名，用于确定如何将结果集分成不同的分区。
- ORDER BY <排序表达式> ASC | DESC (可选)：指定窗口内的排序顺序。排序表达式可以是一个或多个列名，用于确定窗口内行的排序方式。
- ROWS/Range <行范围>(可选)：定义窗口的行范围。行范围可以是固定的行数，也可以是相当于当前行的动态范围

## 窗口函数分类

### 序号窗口函数

序号函数作为结果集中的每一行分配一个唯一的序号或者排名。这些函数通常基于排序顺序和其他条件来分配这些序号。

| 函数 | 作用 |
| -------------- | --------------- |
| ROW_NUMBER() | 每一行分配一个唯一的序号 |
| RANK() | 为每一行分配一个排名，对于相同的值会留下空位 |
| DENSE_RANK() | 为每一行分配一个排名，但不会为相同的值留下空位 |

### 分布窗口函数

分布函数用于计算值在窗口内的相对位置或分布。

| 函数 | 作用 |
| -------------- | --------------- |
| PERCENT_RANK() | 计算行的百分比排名 |
| CUMS_DIST() | 计算行相对于所有其他行的累积分布 |

### 前后窗口函数

前后函数允许访问与当前行相关的前一行或后一行的值

| 函数 | 作用 |
| -------------- | --------------- |
| LAG(expr, offset, default) | 返回指定偏移量之前行的值 |
| LEAD(expr, offset, default) | 返回指定偏移量之后行的值 |

### 首尾窗口函数

首尾函数允许获取窗口的第一行会最后一行的数据
| 函数 | 作用 |
| -------------- | --------------- |
| FIRST_VALUE(expr) | 返回窗口内第一行的值 |
| LAST_VALUE(expr) | 返回窗口内的最后一行的值 |

需要注意的是, FIRST_VALUE() 和 LAST_VALUE() 在没有指定 ORDER BY 子句的时候可能不会按预期工作，因为窗口的顺序是不确定的
此外，LAST_VALUE() 在某些情况下可能不如使用LEAD()函数灵活。

### 聚合窗口函数

聚合函数作为窗口函数：sum(),avg(),min(),max() 等也可以作为窗口函数使用。

### 其他函数

NTH_VALUE(expr,n)：返回窗口内第 n 行的值。
NTILE(n)：将结果集分成指定数量的近似相等的组，并为每一行分配一个行号。
