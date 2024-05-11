# Gradle 学习

## Gradle 构建基础

projects 和 tasks 是 Gradle中的最重要的两个概念。
任何一个 Gradle 构建都是由一个或多个 projects 组成。每个 project 都是由多个 tasks 组成。每个 task 都代表了构建执行过程中的一个原子性操作。

定义一个task

```groovy
task hello {
  println "Hello World!"
}
```

指定两个任务的依赖关系

```groovy
task hello {
  println "Hello"
}

task world(dependsOn: hello) {
  println "World"
}
```

延迟依赖(有点问题)

```groovy
task world(dependsOn: "hello") {
  println "world"
}

task hello {
  print "Hello"
}
```

默认任务,不指定会默认执行

```groovy
defaultTasks "hello", "world"
//这相当于执行 gradle hello world

task hello {
  print "Hello"
}

task world {
  print "World"
}
```

构建脚本的外部依赖

如果你的构建脚本需要使用外部库，可以将它们添加到构建脚本自身的脚本类路径中。使用 `buildscript()`方法执行此操作。

```groovy
buildscript {
  repositories {
    mavenCentral()
  }
  
  dependencies {
    classpath group "org.slf4j:slf4j-api:1.7.5"
  }
}
```

## 配置文件

>- build.gradle -文件包含项目构建所使用的脚本
>- settings.gradle -文件将包含必要的一些设置，例如任务或项目之间的依赖关系等。
>- settings.gradle 的优先级高于 build.gradle
