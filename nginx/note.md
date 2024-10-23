# nginx

nginx 是一个功能丰富、成熟完善的轻量级 Web 服务器，可作为 **HTTP 服务器**、**反向代理服务器**、**邮件服务器**，
支持 SSL、GZip 等多种功能，并且支持很多第三方的模块扩展。

## 代理

![正向代理](../assets/正向代理.jpg)
![反向代理](../assets/反向代理.jpg)

## 负载均衡

负载均衡(Load Balance)简单来说就是现有的请求使服务器压力太大，所以需要搭建一个服务器集群，
去分担原来一个服务器所受的压力。

### 负载均衡策略

nginx 给出三种内置的负载均衡策略：*轮询*、*加权轮询*和 *IP hash*。

1. 轮询法（默认方法）：
每个请求按时间顺序逐一分配到不同的服务器，如果服务器挂掉会自动跳过该服务器。

2. 加权轮询：
指定轮询几率，权重和访问比率成正比，当服务器的性能存在差异时，通过配置服务器的权重
可以让性能好的服务器更好发挥，有效利用资源。

3. ip hash
上面的方式存在的一个问题是在负载均衡系统中，假如用户在一台服务器具上登录了，该服务器上就存在这台服务器上了，那该用户的下一个请求过来可能会重新定位到别的服务器，
其登陆信息就丢失了。可以使用 hash 的特性、通过计算 ip 的 hash 值来定位服务器。

## 安装

[nginx 下载地址](https://nginx.org/en/download.html)

### docker 安装

```shell
# 拉取最新的镜像
docker pull nginx
# 指定版本
docker pull nginx:1.24.0
```

第一次运行镜像，用于拷贝配置文件和 html 目录到宿主机。

```shell
docker run -p 80:80 -d --name nginx nginx:latest
```

```shell
# 拷贝 Nginx 主配置文件 `/etc/nginx/nginx.conf`
docker cp nginx:/etc/nginx/nginx.conf /your_path/nginx/conf/

# 拷贝 Nginx 扩展配置 `/etc/nginx/cong.d`
docker cp nginx:/etc/nginx/conf.d /your_path/nginx/conf/

# 拷贝 Nginx html 目录 `/usr/share/nginx/html`。这是默认的文档根目录。
docker cp nginx:/usr/share/nginx/html /your_path/nginx/html

```

停止并删除容器，配置数据卷重新运行

```shell
docker stop nginx && docker rm nginx
```

```shell
创建一个 docker 的网络，方便之后与其他的容器进行通信

```shell
docker network create nginx_net
```

启动 nginx

```shell
docker run --network nginx_net \
  --name nginx \
  -d \
  -p 80:80 \
  -v /data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
  -v /data/nginx/conf/conf.d:/etc/nginx/conf.d \
  -v /data/nginx/html:/usr/share/nginx/html \
nginx:latest
```

## 基本流程

nginx 是基于多进程工作的，主进程(master)负责读取和教研配置文件，以及开启多个子进程来处理实际的响应请求，子进程(worker)负责具体的请求处理。

![nginx 多进程模型](../assets/nginx.jpg)

可以使用 `docker top nginx` 来查看容器内所有关于 nginx 的进程。

## 配置

### 最小配置

```shell

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    # 事件驱动模块

    # 指的是1个worker同时可以处理多少个连接
    worker_connections  1024;
}


http {
    # 返回的数据类型
    include       /etc/nginx/mime.types;
    # 如果不在 mime.types 中，要么在 mime.types 中配置，要么按 default_type 返回
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    # 使用 linux 的 sendfile(socket, file, len) 来进行高效的网络传输，底层是零拷贝
    sendfile        on;

    # 长连接时间
    keepalive_timeout  65;

  # 虚拟主机 vhost
  server {
    listen  80;
    server_name localhost; # 域名、主机名

    # 相对目录
    localhost / {
      root html;
      index index.html index.htm;
    }
  }


    include /etc/nginx/conf.d/*.conf;
}
```

## 虚拟主机与域名解析

域名、dns、ip地址的关系。nx
