## windows10系统下安装MySQL5.7步骤

###1、 下载MySQL

[下载地址](https://dev.mysql.com/downloads/mysql/5.7.html#downloads) ：点击选择要下载的MySQL，下载服务MySQL在这里插入图片描述选择MySQL版本，默认是最新版本，我这里下载5.7版本

###2、 解压并配置环境变量

将zip文件解压到硬盘上并配置环境变量找一个目录解压下载好的MySQL包，并把MySQL的bin目录全路径加到系统环境变量path中在这里插入图片描述:

![avatar](https://img-blog.csdnimg.cn/20190510170023182.png)

###3、 创建my.ini文件
新下载的MySQL根目录下没有my.ini文件，需要自己创建和配置，如下所示：

my.inin文件位置在这里插入图片描述：
![avatar](https://img-blog.csdnimg.cn/20190510170231308.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTA5ODI1MDc=,size_16,color_FFFFFF,t_70)

my.ini文件内容：

[mysql]
##### #设置mysql客户端默认字符集
default-character-set=utf8 [mysqld]
##### #设置3306端口
port = 3306 
##### #设置mysql的安装目录
basedir=D:\Program Files (x86)\database\mysql-5.7.26-winx64
##### #设置mysql数据库的数据的存放目录
datadir=D:\Program Files (x86)\database\mysql-5.7.26-winx64\data
##### #允许最大连接数
max_connections=200
##### #服务端使用的字符集默认为8比特编码的latin1字符集
character-set-server=utf8
##### #创建新表时将使用的默认存储引擎
default-storage-engine=INNODB



###4、 生成data目录

新下载的MySQL根目录下没有data目录，需要生成。以管理员身份启动命令行工具，进入mysql的bin目录下，执行命令：mysqld --initialize-insecure

###5、 安装MySQL
以管理员身份启动命令行工具，进入mysql的bin目录下，执行命令：mysqld install

###6、 开启mysql
以管理员身份启动命令行工具，执行命令：net start mysql

而关闭mysql同样是以管理员身份启动命令行工具，执行命令：net stop mysql

###7、 进入mysql
配好环境变量后，可以在任意打开的命令行工具中执行mysql命令，刚安装好的mysql有一个root用户且没有密码。 mysql -u root -p

###8、 重置mysql的root用户密码
命令：set password for root@localhost = password('123456');
这样下次登录的时候就需要输入密码了,如下图所示：
![avatar](https://img-blog.csdnimg.cn/20190510164625477.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3UwMTA5ODI1MDc=,size_16,color_FFFFFF,t_70)

###9、 设置数据库访问权限

本机数据库如果要允许远程访问，则需要设置权限：
grant all PRIVILEGES on dbname.* to 'root'@'127.0.0.1' identified by '123456' WITH GRANT OPTION;

all PRIVILEGES

表示赋予所有的权限给指定用户，这里也可以替换为赋予某一具体的权限，例如：select,insert,update,delete,create,drop 等，具体权限间用“,”半角逗号分隔。

dbname.*

表示上面的权限是针对于哪个表的，dbname指的是数据库名称，后面的 * 表示对于所有的表，由此可以推理出：对于全部数据库的全部表授权为*.*，对于某一数据库的全部表授权为数据库名.*，对于某一数据库的某一表授权为“数据库名.表名”。

'root'@'127.0.0.1' 

root表示哪个用户授权，这个用户可以是存在的用户，也可以是不存在的用户。

127.0.0.1表示允许远程连接的 IP 地址，你的IP，如果想不限制链接的 IP 则设置为%即可。
grant all PRIVILEGES on dbname.* to 'root'@'%' identified by '123456' WITH GRANT OPTION;

'123456'---password 为用户root的密码。

