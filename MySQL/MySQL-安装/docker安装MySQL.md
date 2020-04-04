## 数据库 - 实现项目中的数据持久化


### 数据库的类别：

- 关系型数据库 - MySQL特点：
- 理论基础：集合论和关系代数
- 用二维表来组织数据（行（记录）和列（字段））
- 能够唯一标识一条记录的列称为主键（primary key）

SQL - 结构化查询语言：

1. DDL - 数据定义语言 - create / drop / alter
2. DML - 数据操作语言 - insert / delete / update / select
3. DCL - 数据控制语言 - grant / revoke / commit / rollback



### 数据库的类别：
- 关系型数据库 - MySQL、Oracle、PostgreSQL...
- 给关系型数据库 - Redis、MongoDB、Elasticsearch ...


### 关系型数据库产品：
- Oracle - 甲骨文
- MYSQL - 甲骨文 - MariaDB
- DB2、SQLServer、postgreSQL、 SQLite

### 非关系性数据库产品：
- MongoDB - 文档数据库 - 适合量大但是价值低的数据
- Redis - KV数据库 - 性能好适合做高速缓存服务
- ElasticSearch - 搜索引擎

### Linux安装软件 

#### A.  包管理工具 - yum / rpm

yum 是一个用于管理rpm包的后台程序  在建立好yum服务器后，yum客户端可以通过 http、ftp方式获得软件包，并使用方便的命令直接管理、更新所有的rpm包，甚至包括kernel的更新。它也可以理解为红旗环境下的apt管理工具。

1.  yum -y install docker-io  安装   

2.  yum -y remove docker-io   删除  

3.  yum info ...  查看安装包的信息

4.  yum search ... 查询要安装的文件

5.  yum list installed | grep docker  列出yum中已经安 装的所有的docker文件.


#### B. Docker  - 虚拟化服务并创建虚拟化容器并安装软件

#####  启动Docker服务

1. systemctl start docker  开启服务

2. systemctl stop docker   关闭服务

3. systemctl restart docker  重启服务

4. systemctl  status docker  查看服务状态

5. systemctl enable docker  实现开机自启

6. systemctl disable docker 实现开机不自启


##### 使用docker命令


1.  查看已经下载的镜像文件（安装包）：docker images  


2.  下载MySQL的镜像文件：
docker pull mysql：5.7

3.  创建并运行容器命令:
docker run -d -p 3306:3306 --name mysql57 -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7

4.  查看运行的容器状态: docker ps

5.  检查端口：
netstat -nap | grep  3306

6.  停止容器：
docker stop mysql57 (容器名)

7.  启动容器：
docker start mysql57 (容器名)

8.  删除容器
docker rm -f mysql57 (容器名)

9.  查看安装的容器
docker container ls -a





#### 关系型数据库可以保证数据的完整性

1. 实体完整性 :每条记录就是唯一的  没有冗余  -主键/唯一索引
2. 参照完整性 :(引用完整)外键
3. 域完整形:数据类型 ,非空约束,默认值约束,检查约束



#### 注意 :

1. 在同时开启了 systemctl start mysqld  和  docker模拟器的服务和容器时3306端口会冲突 

2. 要么使用阿里云Linux服务器上的mysql,要么使用docker平台的mysql
它们的服务不能同时开启,端口会冲突. (建议使用docker平台mysql)


#### 安装MySQL客户端工具：

a Navicat - 猫

b SQLyog - 海豚

c Toad for MYSQL - 蛤蟆


#### youtube 网站上的两个编程的使用课程

1 -- crash course

2 -- best practice