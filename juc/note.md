# juc

## java 线程的6种状态

1. 初始（NEW）
2. 运行（RUNNABLE）
3. 阻塞（BLOCKED）
4. 等待（WAITING）
5. 超时等待（TIMED_WAITING）
6. 终止（TERMINATED）

![java 线程状态](../assets/java线程状态.jpg)

## 线程池

```java
// 基于 Executor 的线程池
ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(
    1, // 核心线程数，线程池中一直存活的线程数
    5, // 最大线程数，当核心线程全部繁忙，且阻塞队列已满时，线程池会临时追加一个新线程，直到线程池中的线程数达到最大线程数
    60, // 线程空闲时间，当线程空闲超过该时间，且线程数大于核心线程数，线程池会临时回收线程
    TimeUnit.SECONDS, // 时间单位
    new ArrayBlockingQueue<>(5), // 阻塞队列，当核心线程全部繁忙时，新任务会进入阻塞队列，等待被执行
    Executors.defaultThreadFactory(), // 线程工厂
    new ThreadPoolExecutor.AbortPolicy() // 拒绝策略
);

// 当核心线程处于空闲状态时，允许销毁这些空闲的核心线程，默认是不允许的
threadPoolExecutor.allowCoreThreadTimeOut(true);

// 默认情况下，创建线程池之后不会立即创建线程，而是等待提交任务后再创建线程。要向立即创建线程，可以通过以下两种方式：

// 初始化所有核心线程
threadPoolExecutor.prestartAllCoreThreads();
// 初始化一个核心线程
threadPoolExecutor.prestartCoreThread();
```

### 拒绝策略

拒绝策略，内置了4种拒绝策略：

- AbortPolicy：默认的策略，丢弃新提交的任务并抛出 RejectedExecutionException 异常，让开发人员及时知道系统的运行状态。
- DiscardPolicy：直接丢弃新提交的任务，不抛出异常，建议在无关紧要的业务中使用。
- DiscardOldestPolicy：丢弃队列中最老的任务，然后把新提交的任务加到队列尾部，也就是队列最尾部，建议在系统负载比较重的时候使用。
- CallerRunsPolicy：直接在提交任务的线程中运行，也就是调用 execute() 方法的线程。

```java
// 自定义拒绝策略，实现 RejectedExecutionHandler 接口
class MyRejectedExecutionHandler implements RejectedExecutionHandler {
    @Override
    public void rejectedExecution(Runnable r, ThreadPoolExecutor executor) {

    }
}
```

### Executors

```java
// 创建一个固定大小的线程池，允许的队列长度为 Integer.MAX_VALUE
Executors.newFixedThreadPool(5);

// 创建一个单线程化的线程池，允许的队列长度为 Integer.MAX_VALUE
Executors.newSingleThreadExecutor();
// 创建一个可缓存的线程池，允许创建的线程数量为 Integer.MAX_VALUE
Executors.newCachedThreadPool();
```

### 线程池的钩子函数

- beforeExecute：线程池中某个线程开始执行任务之前调用
- afterExecute：线程池中某个线程执行完任务之后调用
- terminated：线程池关闭时调用
