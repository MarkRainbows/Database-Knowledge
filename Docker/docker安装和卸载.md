##Docker  模拟器

数据库 - 实现项目中数据持久化  


- 关系型数据的产品:

```
1.Oracle - 甲骨文     (世界排名第一的服务器产品)

2.MYSQL - 甲骨文 - MariaDB  

3.DB2、SQLServer、postgreSQL、 SQLite

```

###Linux系统中安装docker  


####1 包管理工具 - yum / rpm

yum 是一个用于管理rpm包的后台程序  在建立好yum服务器后，yum客户端可以通过 http、ftp方式获得软件包，并使用方便的命令直接管理、更新所有的rpm包，甚至包括kernel的更新。它也可以理解为红旗环境下的apt管理工具。docker 工具实现数据库mySQL的模拟器。

####2 安装docker 步骤

 1  yum -y install docker-io  安装docker的镜像文件

 2 systemctl  start  docker  开启docker虚拟器服务

####3 Docker中安装mySQL数据库：

 (1) docker pull mysql:5.7 在docker虚拟器中拉取 MySQL的镜像文件，这里下载的是MySQL5.7版本

 (2) docker images  查看已经下载的镜像文件

 (3) docker run -d -p 3306:3306 --name mysql57 -e MYSQL\_ROOT\_PASSWORD=123456 mysql:5.7

注释： 创建并运行容器   -d 表示容器和MySQL同步  -p 表示端口号   --name  容器名   password 容器密码

 (4)  docker ps   可以看容器的运行状态

 (5) 最后一步安装mySQL客户端工具:这里推荐 Navicat.  

总结yum安装软件和卸载软件的命令

   - yum -y  install  .... 安装

   - yum -y  remove ... 删除/卸载

   - yum info ...   查看 安装包的信息

   - yum search ... 查看要安装的文件

   - yum list install | grep docker列出yum服务器中已经安装的所有关于docker的文件





总结docker的虚拟化服务  

        systemctl start docker  开启服务

        systemctl stop docker   关闭服务

        systemctl restart docker  重启服务

        systemctl  status docker  查看服务状态

        systemctl enable docker  实现开机自启

        systemctl disable docker 实现开机不自启




总结docker 容器的开启和关闭

       1 检查端口：

       netstat -nap | grep  3306

       2 停止容器：

       docker stop mysql57 (容器名)

       3 启动容器：

       docker start mysql57 (容器名)

       4 删除容器

       docker rm -f mysql57 (容器名) -f 强制删除  mysql57是容器名

       5 查看安装的容器

       docker container ls -a




​        

































