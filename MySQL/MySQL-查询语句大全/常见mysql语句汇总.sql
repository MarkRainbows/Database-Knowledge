数据库 - 实现项目中的数据持久化

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

数据库的类别：
- 关系型数据库 - MySQL
特点：
1. 理论基础：集合论和关系代数
2. 用二维表来组织数据（行（记录）和列（字段））
- 能够唯一标识一条记录的列称为主键（primary key）
3. SQL - 结构化查询语言
- DDL - 数据定义语言 - create / drop / alter
- DML - 数据操作语言 - insert / delete / update / select
- DCL - 数据控制语言 - grant / revoke / commit / rollback

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


1 DDL 语言

a create 创建数据库 ---  create database 数据库名 default charset 'utf8';   (utf8表示支持中文) 

b drop 删除数据库(慎重操作) --- drop database if exists 数据库名;

c create 创建表  ---  create table tb_表名 (字段1-字段数据类型-条件约束, 字段2....);

  1 字段类型 1 int (整形) 2 varchar (可变字符集) 3 bit (布尔值) 只有1和0 Ture False   4 date(日期类型的数据) 5 datetime(日期时间类型)

  2 条件约束 1 not null(非空约束)  2 auto_increment (自动增加+1) 3 default (默认值) 4 primary key (字段) 设置主键 5 unique - 值唯一  6 unsigned 无符号

  3 注释 1 -- 注释内容  (查询注释)  2 comment '注释内容' (字段注释)

  4 其他数据类型:int (tinyint ,mediuint,float....) 
                char(数字) 定长字符串,该字段的内容规定指定的长度...
                text 长文本数据 0-65535字符 ...
                需要什么数据去查就行.

d drop table 表名  删除表 , truncate table 表名 ---清空表中所有的记录

e alter 修改表属性操作 --- alter table 表名 drop 列名; (删除字段) ;
						  alter table 表名 add column 字段名 字段类型 字段约束; (增加字段);
						  例如  alter table tb_college add column collmaster varchar(20) not null comment '院长姓名';					

f 给表添加主键约束--- alter table tb_teacher add  primary key (teaid);  一般创建表的时候就直接定义 primary key (字段)

g 给表添加外键约束 --- alter table tb_teacher add  foreign key (当前表要关联的字段) references tb_college (关联表的主键字段);

h 说明: constraint + 索引名   索引名自己随便命令,用来指向当前添加的约束
  alter table tb_score add constraint uni_score_sid_cid unique (sid, cid);

  索引名的作用就是删除约束时直接删除索引名
  alter table tb_score drop index uni_score_sid_cid  --删除 sid cid字段的唯一性约束


-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


索引 


索引(相当于一本书的目录)
为表创建索引可以加速查询(用空间换时间)
索引会让增删改变得更慢
因为增删改操作调整 数据所以可能会导致更新索引
那个列经常被用于查询的筛选条件，那么就应该在这个列上建立索引
主键上有默认的索引(唯一索引)
如果使用模糊查询，如果查询条件不以%开头，那么索引有效，反之，无效


create index idx_emp_ename on tb_student(sname); -- 建立索引
create unique index uni_emp_ename on tb_student(sname); -- 唯一索引
alter table tb_student drop index idx_emp_ename; -- 删除索引

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=



2 DML 语言

(1) insert into tb_表名 (字段1,字段2,字段3) values ('数据1'),('数据2'),('数据3');  --- 插入记录
例如 :
insert into tb_college (collname, collmaster, collweb) values 
('计算机学院', '左冷禅', 'http://www.abc.com'),
('外国语学院', '岳不群', 'http://www.xyz.com'),
('经济管理学院', '风清扬', 'http://www.foo.com');


(2) delete from tb_表名 where 条件语句  --- 删除指定的记录
例如:
delete from tb_college where collmaster='左冷禅'


(3) update tb_表名 set 字段='值' where 条件语句 --- 更新指定记录的数据
例如:
update tb_college set collmaster = '东方不败' where collid = 7;


(4) select 语句  (重点)

1 查询所有记录
select * from 表名


2 查询指定字段的数据
select 字段1 as 重命名字段1,字段2 as 重命名字段2 from 表名 (查询时重新生成一张指定的表,与原表无关)
实例: select cname as 课程名称,credit as 学分 from tb_course;


3 筛选语句 where  等于 =   不等于 <>   > < (大于小于)  >= <= (大等于小等于)
select 字段 as 新字段 from 表名 where 筛选条件;
-- 查询所有女学生的姓名和出生日期(筛选)
select sname as 姓名 , birth as 出生日期  from tb_student where  gender = 0;


4 查询分支语句 类似 if else (适用于bit类型的字段)
select if(bit字段,'值1','值2') as 重名字段 from 表名;  --- (该字段为bit类型, 当值为1的时候显示值1,当值为0的时候显示值2)
-- 查询学生表的姓名和性别,是1就显示男,是0就显示女
select sname as 姓名 ,  if(gender,'男','女') as 性别 from tb_student 


5 where 筛选条件在某段值中间  between '值1' and '值2'
查询80后的学生姓名
select sname as 姓名 from tb_student where birth between '1980-1-1' and '1989-12-31';


6 筛选字符数是多少 --- length() 查询的是字节数  一个字符是3个字节
查询名字为4个字的学生姓名
select stuid as 学号,sname as 姓名 from tb_student where length(sname)/3 = 4  


7 模糊查询 '值1%' , '值2_' , '值3__','%值4%'.
where 字段 like '值1%' --- 查询指定字段中以'值1'开头的记录  
查询姓杨的学生姓名 -- select sname as 姓名 from tb_student where sname like '杨%';

where 字段 like '值2_' --- 查询指定字段中以'值2'开头的记录,但只有两个字符的记录  
查询姓杨的只有两个字的学生--- select sname as 姓名 from tb_student where sname like '杨_';

where 字段 like '值2__' --- 查询指定字段中以'值3'开头的记录,但只有三个字符的记录  
查询姓杨的只有两个字的学生--- select sname as 姓名 from tb_student where sname like '杨_';


where 字段 like '%值4%' --- 查询指定字段中包含值4的记录 (常用)
查看名字中包含杨的记录  --- select sname as 姓名 from tb_student where sname like '%杨%';


8 (is null , is not null) 查询某字段为空时的记录 或者 某字段不为空的记录 
查询没有录入家庭住址的学生 --- select sname as 姓名 from tb_student where addr is null ;
查询录入了家庭住址的学生 --- select sname as 姓名 from tb_student where addr is not null ;


9 查询记录去重操作 select  --- 某些数据查询出来会有多个重复记录,这时需要去重
select distinct 字段 from 表名 
查询学生选课的日期有哪几天 -- select distinct seldate from tb_score 


10 字段排序查询 -- order by 字段1 asc 字段2 desc  (asc升序, desc降序)
查询学生的姓名,性别,学号,并按性别升序(从小到大),学号降序排序(从大到小) 
--- select stuid as 学号,sname as 姓名 ,gender as 性别 from tb_student order by gender asc, stuid desc;

注意:同时有多个字段排序时 查询结果会按照第一个字段的顺序进行排序



11 聚合函数:max/min/sum/avg/count

max(字段) 查询这个字段中的最大值 -- 一般和分组函数一起使用
查询年龄最小值 -- select max(birth) from tb_student;
查询年龄最大值 -- select min(birth) from tb_student;
统计有多少人 -- select count(stuid) as 人数 from tb_student ;
查看某个课程的平均成绩 -- select avg(mark) from tb_score where cid = 1111;

注意:平均成绩一般会直接和分组一起使用 (先分组后,在求每个组的平均成绩), 
     分组之前筛选用 where, 分组之后用having, 最后用排序order by 给查询结果进行展示

实例: 查询学号在 1000-2000之间 并且平均成绩大于60分,学生的学号和平均成绩

select sid as 学号,avg(mark) as 平均分 from tb_score 
where sid between 1000 and 1999 
group by sid 
having 平均分 >= 60 
order by 平均分 desc;


12 分组函数 group by 字段 自动去重该字段并把该字段进行分组后升序排序 (先分组,再求每个组的平均成绩)

查询每个学生的平均成绩和学号select sid as 学号,avg(mark) as 平均分 from tb_score group by sid;


13 子查询  把一个查询的结果当做另一个查询的一分部分来使用
查询选了俩们课以上的课程的学生姓名 (子查询, 在课程表中选了两们课的学生作为子查询,学生表(父查询)把子查询的结果作为筛选条件使用)

select sname as 学生姓名 from tb_student where stuid in (select sid from tb_socre  group by sid having count(cid)>2);



14 连接查询  --- 需要查询多个表中字段数据  
比如查询每个学生的姓名和平均成绩   --- 学生姓名在学生表,平均成绩在成绩 (子查询和连接查询)

a 内连接  inner join  交叉集合

(1)

select sname, avgmark from tb_student inner join 
(select sid, avg(mark) as avgmark from tb_score group by sid) t2 
on stuid=sid;
(2)

select sname avgmark 
from tb_student t1, (select sid, avg(mark) as avgmark from tb_socre group by sid;) t2
where stuid = sid

b 左外链接  把左表(写在前面的表)不满足连接条件的记录也查出来对应记录补null值 --- 查询左表全部的记录和右表交叉的记录

select sname, total, sid from tb_student t1 left join 
(select sid, count(sid) as total from tb_score group by sid) t2 
on stuid=sid;

c 右外链接 把右表(写在后面的表)不满足连接条件的记录也查出来对应记录补null值 --- 查询右表的全部记录和左表交叉的记录
select sname, total, sid from tb_student t1 right join 
(select sid, count(sid) as total from tb_score group by sid) t2
on stuid=sid;

15 分页查询  -- 获取查询结果的指定数量条记录

select * from 表名 limlt M offset N; --跳过N条 ,取M条数据


-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


3  DCL - 数据控制语言


创建用户, 刚创建出来的用户没有任何权限,

-- 创建名为hellokitty的用户并设置口令
create user 'hellokitty'@'%' identified by '123123';

-- 给用户授权
grant select on srs.* to 'hellokitty'@'%';
grant insert, delete, update on srs.* to 'hellokitty'@'%';
grant create, drop, alter on srs.* to 'hellokitty'@'%';

grant all privileges on srs.* to 'hellokitty'@'%';
grant all privileges on srs.* to 'hellokitty'@'%' with grant option;

-- 召回
revoke all privileges on srs.* from 'hellokitty'@'%';


'@'ip' 指定ip地址   '@'%'  任意ip地址



-- 事务控制     (将多个操作绑定在一起 ,只要有一个操作失败了,那么整个绑定的操作就会失败,数据回到操作之前) 比如支付环节操作

-- 开启事务环境    关闭事务环境
1 begin;          再 run 一次begin;

update tb_score set mark=mark-2 where sid=1001 and mark is not null;
update tb_score set mark=mark+2 where sid=1002 and mark is not null;

2 commit --- 事务提交  (如果所有操作成功 就提交使其操作生效)
 
3 rollback  ---  -- 事务回滚  (如果事务中有一个操作失败了,那么所有操作都失效,回到初始位置)

begin;
delete from tb_score;
rollback;
















