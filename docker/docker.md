# Docker

## Docker Hello world

```bash
docker run ubuntu:15.10 /bin/echo "Hello world"
```

- **docker**: Docker 的二进制文件
- **run**: 与前面的 docker 组合来运行一个容器。
- **ubuntu:15.10** ：指定要运行的镜像， Docker 首先从本地主机查找镜像是否存在，
  如果不存在，Docker 就会从镜像仓库 Docker Hub 下载公共镜像。
- **/bin/echo "Hello world"** : 在启动的容器里执行的命令。

### 运行交互式的容器

通过 docker 的两个参数 `-i`，`-t`，让 docker 运行的容器实现交互的能力

```bash
docker run -i -t ubuntu:15.10 /bin/bash
```

- **-t** : 在新容器内指定一个伪终端或终端。
- **-i** ：允许你对容器内的标准输入进行交互

### 启动容器（后台模式）

```bash
docker run -d ubuntu:15.10 /bin/bash -c "while true;do echo hello world; sleep 1;done"
```

启动后，使用 `docker ps` 来查看启动的容器。输出详情如下：

**CONTAINER ID**：容器ID
**IMAGE**：使用的镜像
**COMMAND**：启动容器时运行的命令
**CREATED**：容器的创建时间
**STATUS**：容器状态

- created（已创建）
- restarting（重启中）
- running/Up（运行中）
- removing（迁移中）
- paused（暂停中）
- exited（停止）
- dead（死亡）

**PORTS**：容器的端口信息和连接类型。
**NAMES**：容器名称

在宿主主机中使用 `docker logs` 命令，可以查看容器内的标准输出。

### 停止容器

```bash
docker stop [container_id|container_name]
```

## Docker 容器使用

### 获取容器

```bash
docker pull ubuntu
```

### 启动容器

```bash
docker run -it ubuntu /bin/bash
```

- **i**：交互式操作
- **t**：终端
- **ubuntu**：镜像
- **/bin/bash**：放在镜像名后的命令，这里我们希望有一个交互式的 Shell，使用/bin/bash

退出终端：exit

### 启动已停止运行的容器

查看所有的容器命令：

```bash
docker ps -a
```

使用 docker start 启动一个已经停止的容器。

### 后台运行

使用参数 `-d` 指定容器的运行模式。

### 停止一个容器

```bash
docker stop <容器ID>
```

### 进入容器

```bash
docker exec -it <容器ID> /bin/bash
```

### 导出和导入容器

#### 导出容器

如果想导出本地某个容器，可以使用 **docker export** 命令。

```bash
docker export <容器ID> > image.tar
```

#### 导入容器快照

可以使用 docker import 从容器快照文件中再导入为镜像。

```bash
cat docker/image.tar | docker import - test/ubuntu:v1
```

此外，也可以通过指定 URL 或者某个目录来导入

```bash
docker import https://url.tgz example/imagerepo
```

### 删除容器

```bash
docker rm -f <容器ID>
```

## Docker 镜像使用

### 镜像列表

使用 **docker images** 来列出本地机器上的镜像。

- **REPOSITORY**：表示镜像的仓库源
- **TAG**：镜像的标签
- **IMAGEID**：镜像ID
- **CREATED**：镜像的创建时间
- **SIZE**：镜像大小

同一个仓库源可以有多个TAG，代表这个仓库源的不同版本。

### 获取一个新的镜像

```golang
docker pull 仓库:TAG
```

### 查找镜像

```bash
docker search <镜像>
```

- **NAME**：镜像仓库源的名称
- **DESCRIPTION**：镜像的描述
- **OFFICIAL**：是否是docker官方发布的
- **AUTOMATED**：自动构建

### 删除镜像

```bash
docker rmi hello-world
```

### 设置镜像标签

可以使用 docker tag 命令，为镜像添加一个新的标签。

```bash
docker tag 镜像ID username/repository_name:tag
```

## Docker 容器连接

### 网络端口映射

可以使用 `-P` 和 `-p` 来指定容器端口绑定到主机端口。

- **-P**：将容器内部端口**随机**映射到主机的端口
- **-p**：将容器内部的端口绑定到**指定**的主机端口

### Docker 容器互联

端口映射并不是唯一把 docker 连接到另一个容器的方法。
docker 有一个连接系统允许将多个容器连接到一起，共享连接信息。
docker 连接会创建一个父子关系，其中父容器可以看到子容器的信息。

#### 容器命名

当我们创建一个容器的时候，docker会自动对它进行命名。另外，也可以使用**--name**标识来命名容器。

#### 新建网络

```bash
docker network create -d bridge test-net
```

参数说明：

- **-d**：指定Docker网络类型，有 bridge,overlay

#### 连接容器

运行一个容器，并连接到新建的 test-net 网络中

```bash
docker run -itd --name test1 --network test-net ubuntu /bin/bash
```

### 配置DNS

可以在宿主机的 /etc/docker/daemon.json 文件中增加以下内容设置容器的DNS

```json
{
  "dns": ["114.114.114.114", "8.8.8.8"]
}
```

## Docker 仓库管理

[Docker hub](https://hub.docker.com/)

## Docker Dockerfile

Dockerfile 是一个用来构建镜像的文本文件

```bash
FROM centos #基础镜像，后续的所有操作都是基于此镜像
RUN <命令行命令> #等同于，在终端操作的Shell命令
RUN ["可执行文件"， "参数1"， "参数2"] # 例如 RUN ["test.php", "dev", "offline"]
```

> [!IMPORTANT]
> Dockerfile 的指令每执行一次都会在docker上新建一层，过多层会造成镜像膨胀过大。例如：

```bash
FROM centos
RUN yum -y install wget
RUN wget -o redis.tar.gz "https://download.redis.io/release/redis-5.0.3.tar.gz"
RUN tar -xvf redis.tar.gz
```

以上的执行会构建3层镜像。可以简化为以下格式：

```bash
FROM centos
RUN yum -y install wget \
    && wget -O rs.tar.gz "http://download.redis.io/releases/redis-5.0.3.tar.gz" \
    && tar -xvf rs.tar.gz
```

如上，以 `&&` 符号连接命令， 这样只会创建一层镜像。

### 构建镜像

在 Dockerfile 文件的目录下，执行构建操作。

```bash
docker build -t nginx:v3
```

### 指令详解

| Dockerfile 指令 | 说明                                                              |
| --------------- | ----------------------------------------------------------------- |
| FROM            | 指定基础镜像                                                      |
| LABEL           | 添加镜像的元数据，使用键值对的形式                                |
| RUN             | 在构建的过程中在镜像中执行的命令                                  |
| CMD             | 指定容器创建的默认命令                                            |
| ENTRYPOINT      | 设置容器创建时的主要命令                                          |
| EXPOSE          | 声明容器运行时监听的特定网络端口                                  |
| ENV             | 在容器内部设置环境变量                                            |
| ADD             | 将文件、目录或远程URL复制到镜像中                                 |
| COPY            | 将文件或目录复制到镜像中                                          |
| VOLUMN          | 为容器创建挂载点或声明卷                                          |
| WORKDIR         | 设置后续指令的工作目录                                            |
| USER            | 指定后续指定的用户上下文                                          |
| ARG             | 定义在构建过程中传递给构建器的变量， 可使用"docker build"命令设置 |
| ONBUILD         | 当该镜像被用作另一个构建过程的基础上时，添加触发器                |
| STOPSIGNAl      | 设置发送给容器以退出的系统调用信号                                |
| HEALTHCHECK     | 定义周期性检查容器健康状态的命令                                  |
| SHELL           | 覆盖docker中默认的shell，用于RUN等指令                            |

**COPY**：可以实现容器内部和宿主机的文件复制

**CMD**：cmd 在docker run的时候执行，RUN 在 docker build 时执行。

## Docker Compose

Compose 是用于定义和运行多个容器的Docker 应用程序工具。通过 Compose 可以使用 YML 文件来配置程序需要的所有服务。
Compose 使用的3个步骤：

- 使用 Dockerfile 定义应用程序的环境
- 使用docker-compose.yml 定义构成应用程序的服务，这样可以让容器在隔离环境中一起运行。
- 最后，执行 docker-compose up 命令来启动并运行整个应用程序。

### docker-compose.yml 文件

**version**：指定本yml依从的 compose 哪个版本制定的。

| Column1 | Column2 | Column3 |
| --------------- | --------------- | --------------- |
| Item1.1 | Item2.1 | Item3.1 |
| Item1.2 | Item2.2 | Item3.2 |
