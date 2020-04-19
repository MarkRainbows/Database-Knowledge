 
## redis的安装


### 1  非关系数据库/NoSQL 简介

定义:
NoSQL提出了另一种理念，以键值来存储，且结构不稳定，每一个元组都可以有不一样的字段，这种就不会局限于固定的结构，可以减少一些时间和空间的开销。使用这种方式，为了获取用户的不同信息，不需要像关系型数据库中，需要进行多表查询。仅仅需要根据key来取出对应的value值即可。

NoSql适合存储非结构化数据，比如：文章、评论：

（1）这些数据通常用于模糊处理，例如全文搜索、机器学习，适合存储较为简单的数据。

（2）这些数据是海量的，并且增长的速度是难以预期的。

（3）按照key获取数据效率很高，但是对于join或其他结构化查询的支持就比较差。



### 2  Redis 安装


说明：命令安装适用于Linux、macOS、centOS系统。 Windows需要提前安装Git再进行命令安装。

注意：在创建指定的Redis文件夹中使用终端命令。

```
(1)  wget http://download.redis.io/releases/redis-3.2.12.tar.gz  (下载安装包)

(2)  gunzip redis-3.2.12.tar.gz (解压安装包)

(3)  cd redis-3.2.12 (进去解压文件夹中)

(4)  make && make install (进行安装) 

(5)  redis-server --version / redis-cli  --version (查看Redis服务器、客户端的版本)
```

### 3 Redis 配置

说明：redis需要更改配置文件来保持加密登录,因为如果不修改配置文件,任何人都可以通过端口来控制这台redis数据库

配置Redis.conf ---->

1 cd redis-3.2.12

2 vim redis.conf 

(61)  bind 服务器私有地址 、
(84)  port 6379 设置端口号 、
(480) requirepass 123456  设置密码 、
(593) appendonly yes -- 只能添加模式 ]

3 启动redis服务 --- systemctl start redis  (确保6379端口没有被调用)
 
  
4 redis-server redis.conf >> redis.log &   -- 启动redis服务并且在后台运行,并且输出重定向给redis.log日志文件 
  (以配置文件启动redis-server，并生成redis日志文件)

5 redis-cli -h 私有地址  （如果是在服务器中，以服务器的私有地址启动服务端）


6 auth 密码(配置文件中的密码)


7 ping --- pong  测试成功



### 4 Redis 客户端

说明：安装Redis客户端可以更加直观的看到数据库的形态以及内容

Redis客户端下载地址


GitHub：[https://github.com/qishibo/AnotherRedisDesktopManager/] 
(https://github.com/qishibo/AnotherRedisDesktopManager/)

GitEE：[https://gitee.com/qishibo/AnotherRedisDesktopManager/releases](https://gitee.com/qishibo/AnotherRedisDesktopManager/releases)

注意：下载完成后直接连接本地或者服务器的Redis服务器，前提是已经安装好Redis。
















