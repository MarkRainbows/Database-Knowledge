## redis



## 一、简介

### **1.1.概念**   

​     [redis](https://cloud.tencent.com/product/crs)是一个key-value[存储系统](https://baike.baidu.com/item/%E5%AD%98%E5%82%A8%E7%B3%BB%E7%BB%9F)。和Memcached类似，它支持存储的value类型相对更多，包括string(字符串)、list([链表](https://baike.baidu.com/item/%E9%93%BE%E8%A1%A8))、set(集合)、zset(sorted set --有序集合)和hash（哈希类型）。这些[数据类型](https://baike.baidu.com/item/%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B)都支持push/pop、add/remove及取交集并集和差集及更丰富的操作，而且这些操作都是原子性的。在此基础上，redis支持各种不同方式的排序。与memcached一样，为了保证效率，数据都是缓存在内存中。区别的是redis会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件，并且在此基础上实现了master-slave(主从)同步。

### **1.2.使用场景**

- 登录会话存储，存储在redis中，与memcached相比，数据不会丢失
- 排行版、计数器：比如一些秀场类的项目，经常会有一些前多少名的主播排名。还有一些文章阅读量的技术，或者新浪微博的点赞数。
- 作为[消息队列](https://cloud.tencent.com/product/cmq)：比如celery就是redis作为中间人
- 当前在线人数：显示有多少在线人数
- 一些常用的数据缓存：比如BBS论坛，模块不会经常变化，但是每次访问首页都要从mysql中获取，可以在redis中缓存起来，不用每次请求数据库。
- 把前200篇文章或者评论缓存：一般用户浏览网站，只会浏览前面一部分文章或者评论，那么可以把前面200篇文章和对应评论缓存起来。用户访问超过的，就访问数据库，并且以后文章超过200篇，则把之前的文章删除。
- 好友关系：微博的好友关系使用redis实现
- 发布和订阅功能：可以用来做聊天软件



## 二、对redis的操作


### **2.1.Redis通用操作**

说明：

将值value关联到key。如果key已经存在值，set命令会覆盖之前的值。默认的过期时间是永久。

-----------------------------------------------------------------------

1 存键值对 set key vaule 
 
  set username  Mark 

2 取键对应的值  get key

  get username 
 
3 查看键值对存货的事件TTL

ttl key  --- 当 key 不存在时，返回 -2 。 当 key 存在但没有设置剩余生存时间时，返回 -1 。 否则，以毫秒为单位，返回 key 的剩余生存时间。

4 keys * 查看已创建的键值对

5 exists 查看键是否存在  (integer) 1  存在   (integer) 0  不存在

6 flushdb 清空所有的键值对 

7 flushall 清空redis所有数据库的数据 (删库,慎重操作)

8 select 0 - 15  redis默认有16个数据库  select 0-15 在这些库当中切换

9 设置自己redis 的密码 和 数据重定向

redis-server --requirepass 123456 --appendonly yes > redis.log2> redis-error.log &

10 连接别人的redis数据库 

redis -cli -h 公网IP地址 -p 6379

11 shutdown save 保存数据并关闭服务器

12 dbsize  查看当前数据库的数据个数  (integer) 2 表示当前数据库有两个键值对

13 save / bgsave  - 保存数据/后台保存数据


###  **2.2.Redis的常用数据类型**

1 string(字符串)   2(hash)散列类型   3list(列表类型)  4 set(集合)  5 zset(有序集合)

### **2.3.字符串操作**


1 存键值对 set key vaule  

```
set username Mark
```

2 取键对应的值  get key

```
get username 
```

3 删除键值对

```
del username
```
 
4 设置过期时间

```
#两种方式都可以
set username derek EX 10     #10s

#或者
setex username 10 derek
```

5 keys * 查看已创建的所有键值对

```
keys *
```

### **2.4.列表操作**

 （1）在列表左边添加元素

```shell
lpush username derek
```

 将值value插入到列表key的表头。如果key不存在，一个空列表会被创建并执行lpush操作。当key存在但不是列表类型时，将返回一个错误。

（2）在列表右边添加元素

```javascript
rpush username Tom
```

将值value插入到列表key的表尾，如果key不存在，一个空列表会被创建并执行lpush操作。当key存在但不是列表时，将返回一个错误。

 （3）查看列表中的元素

```javascript
lrange username 0 -1       #起始到末尾，索引
```

返回列表key中指定区间内的元素，区间以偏移量start和stop指定。

 （4）移除列表中的元素

```javascript
#移除并返回列表key的头元素
lpop username

#移除并返回列表key的尾元素
rpop username
```

（5）指定返回第几个元素

将返回key这个列表中，索引为index的这个元素

```javascript
#lindex key index

lindex username 1
```

 （6）获取列表中的元素个数

```javascript
llen username
```

（7）删除指定的元素

```javascript
lrem users 2 derek    # 2,代表删除的数量

lrem users 0 derek     # 删除所有数量
```

根据参数count的值，移除列表中与参数value相等的元素。count的值可以试一下几种：

- count > 0：从表头开始向表尾搜索，移除与value相等的元素，数量为count
- count < 0：从表尾开始向表头搜索，移除与value相等的元素，数量为count的绝对值
- count = 0：移除表中所有与value相等的值。

### **2.5.集合操作**

（1）添加元素

```javascript
sadd users derek jack
```

（2）查看元素

```javascript
smembers users
```

（3）移除元素

```javascript
srem users derek
```

（4）查看集合中的元素个数

```javascript
scard users
```

（5）多个集合之间的交集、并集和差集

```javascript
sinter set1 set2      #交集

sunion set1 set2      #并集

sdiff set1 set2      #差集
```


### **2.6.哈希操作**

（1）添加一个新值

hset key field value

```javascript
hset person name derek
```

将哈希表key中的域field的值设为value。如果key不存在，一个新的哈希表被创建并进行HSET操作。如果域field已经存在哈希表中，旧值将被覆盖。

（2）获取哈希中的field对应的值

```javascript
hget person name
```

（3）删除field中的某个field

```javascript
hdel person name
```

（4）获取某个哈希中所有的field和value

```javascript
hgetall person
```

（5）获取某个哈希中所有的field

```javascript
hkeys person
```

（5）获取某个哈希中所有的值

```javascript
hvals person
```

（6）判断哈希中是否存在某个field

```javascript
hexists person name
```

（7）一次设多个

```javascript
hmset person name derek age 18 hight 175
```

（8）长度

```javascript
hlen person 
```

### **2.7.事务操作**

redis事务可以一次执行多个命令，事务具有以下特征：

- 隔离操作：事务中的所有命令都会序列化，按顺序执行，不会被其它命令打扰。
- 原子操作：事务中的命令要么全部被执行，要么全部不执行。

（1）开启一个事务

```javascript
multi
```

以后执行的所有命令，都将在这个事务中执行。

（2）执行事务

```javascript
exec
```

会将在multi和exec中的操作一并提交

（3）取消事务

```javascript
discard
```

会将multi后的所有命令取消

（4）监视一个或者多个key

```javascript
watch key .......
```

监视一个或多个key，如果在事务执行之前这个key被其它命令所改动，那么事务将被打断。

（5）取消所有key的监视

```javascript
unwatch
```

### **2.8.发布和订阅**

（1）给某个频道发布消息

```javascript
publish channel message
```

（2）订阅某个频道的消息

```javascript
subscribe channel
```

## 三、RDB和AOF的两种数据持久化机制

 **RDB同步机制**

- 开启和关闭：默认情况下是开启了，如果想关闭，那么注释掉“redis.conf”文件中的所有“safe”选项就可以了
- 同步机制：save 900 1 如果在900s以内发生了一次数据更新操作，那么就会做一次同步操作；还有两种机制：save 300 10;  save 60 10000
- 存储内容：存储的是具体的值，并且是经过压缩后存储进去的。
- 存储路径：根据“redis.conf”下的dir以及‘rdbfilename’来制定的，默认是 /var/lib/redis/dump.rdb
- 优点：1.存储数据到文件中会进行压缩，文件体积比AOF小；2.因为存储的是redis具体的值，并且经过压缩，因此在恢复的时候速度比AOF快；3.非常实用于备份。
-  缺点：1.RDB在多少时间内发生了多少写操作的时候就会触发同步机制，因为采用压缩机制，RDB在同步的时候都重新保存整个redis中的数据，因此一般会设置在最少5分钟才保存一次数据。在这种情况下，一单服务器故障，会造成5分钟的数据丢失。

 **AOF同步机制**

- 开启和关闭：默认是关闭的。如果想开启，那么修改redis.conf中的‘appendonly yes’ 就可以了
- 同步机制：1.appendfsync always：每次有数据更新操作，都会同步到文件中；2.appendfsync everysec：每秒进行一次更新；3.appendfsync no：30s更新一次（采用默认的）
- 存储内容：存储的是具体的命令，不会进行压缩。
- 存储路径：根据redis.conf下的dir以及appendfilename来指定的。默认是 /var/lib/redis/appendonly.aof
- 优点：1.AOF的策略是每秒钟或者每次发生写操作的时候都会同步，因此即使服务器故障，最多只会丢失1秒的数据；2.AOF存储的是redis的命令，并且是直接追加到aof文件后面，因此每次备份的时候只要添加新的数据进去就可以了。3.如果AOF文件比较大了，那么redis会进行重写，只保留最小的命令集合。
- 缺点：1.AOF文件因为没有压缩，因此体积比RDB大；2.AOF是在每秒或者每次写操作都进行备份，因此如果并发量比较大，效率可能有点慢；3，AOF文件因为存储的是命令，因此在灾难恢复的时候redis会重新运行AOF中的命令，速度不及RDB。

## 四、设置redis的连接密码

 （1）设置密码

```javascript
  vim /etc/redis.conf 
```

打开配置文件，然后按“/”搜索“requirepass”，再按‘n’找到‘requirepass password’，取消注释，在后面加上要设置的密码 requirepass password 123456.

（2）本地连接

```javascript
redis-cli -p 6379 -h 127.0.0.1 -a 123456
```

可以在连接的时候，通过‘-a’参数指定密码进行连接，也可以先登录上去，然后再使用‘auth password’命令进行授权。

 （3）其它机器连接redis

 如果想让其它机器连接本机的redis服务器，那么应该在‘redis.conf’配置文件中，指定“**bind 本机的ip地址**”，这样别的机器就能连接成功了。

```javascript
vim /etc/redis.conf
```

按‘/’搜索‘bind’，后面指定自己机器的ip



## 五、python操作redis

 （1）安装

```javascript
pip install redis
```

（2）连接

```javascript
from redis import redis

cache = Redis(host="139.199.131.146",port=6379,password=123456)
```

（3）字符串操作

```javascript
cache.set('uers','derek')

cache.get('users')

cache.delete('users')
```

（4）列表操作

```javascript
cache.lpush('users','tom')

print(cache.lrange('users',0,-1))
```

（5）集合的操作

```javascript
cache.sadd('group','CEO')

print(cache.smembers('group'))
```

（6）哈希的操作

```javascript
cache.hset('person','name','derek')

print('cache.hgetall('person')')
```

（7）事务的操作

```javascript
pip = cache.pipeline()
pip.set('username','derek')
pip.set('password','123456')
pip.execute()
```