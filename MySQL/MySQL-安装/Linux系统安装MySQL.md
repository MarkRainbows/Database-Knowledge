## Linux上安装MySQL


1. 下载MySQL源安装包: wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm  

2. 解压MySQL安装包: yum localinstall mysql57-community-release-el7-8.noarch.rpm

3. 安装MySQL: yum install mysql-community-server  

4. 设置开机启动MySQL服务: systemctl enable mysqld  

5. 启动/重启MySQL服务：systemctl restart mysqld  

6. 查看MySQL初始密码：grep 'A temporary password' /var/log/mysqld.log  

7. 更改MySQL密码：mysqladmin -u root -p'旧密码' password '新密码'  
   
注意：这里更改密码出了问题，更改失败，这是因为密码太过简单的原因。有两个接解决方法：

方法一：把密码设置复杂点（这是最直接的方法）

方法二：关闭mysql密码强度验证(validate_password)

编辑配置文件: vim /etc/my.cnf  增加这么一行validate_password=off. 
编辑后重启mysql服务：systemctl restart mysqld



### 设置mysql能够远程访问:  

a. 登录进MySQL:  mysql -uroot -p密码  

b. 增加一个用户给予访问权限: grant all privileges on *.* to 'root'@'ip地址' identified by '密码' with grant option; 

   (注意root@IP，这里填写一个IP表示可以只允许该IP可以访问，@'%'表示所有IP都可访问)

c. 刷新权限：flush privileges;­  

注意 ：

如果原来安装过MySQL,就必须删除原来安装过的mysql残留的数据. 
命令：rm -rf /var/lib/mysql  (mysql的配置文件,一旦删除无法连接mysql).
再重启mysql服务 systemctl restart mysqld















