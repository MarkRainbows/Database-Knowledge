-- DDL

DROP DATABASE if EXISTS practice;
CREATE DATABASE practice DEFAULT CHARSET 'utf8';

USE practice;

DROP TABLE IF EXISTS college;

CREATE TABLE college
(
college_id INT NOT NULL auto_increment comment '学院编号',
college_name  VARCHAR(60) NOT NULL comment '学院姓名',
college_master VARCHAR(20) NOT NULL comment '院长姓名',
college_web VARCHAR(512) DEFAULT ' ' comment'学院网址',
PRIMARY KEY(college_id)
)	;

CREATE TABLE student
(
stu_id INT NOT NULL COMMENT '学生编号',
stu_name VARCHAR(20) NOT NULL COMMENT '学生姓名	',
stu_sex enum('男','女') NOT NULL COMMENT '学生性别',
stu_bir date NOT NULL COMMENT '出生日期',
stu_address VARCHAR(256) COMMENT '学生籍贯',
coll_id INT NOT NULL COMMENT '所属学院编号',
PRIMARY KEY(stu_id)
);

CREATE TABLE teacher 
(
teacher_id INT NOT NULL COMMENT '教师编号',
teacher_name VARCHAR(60) NOT NULL COMMENT '教师姓名',
teacher_title VARCHAR(20) NOT NULL COMMENT '教师职称',
coll_id INT NOT NULL COMMENT '所属学院编号',
PRIMARY key(teacher_id)
);

CREATE TABLE course 
(
course_id INT NOT NULL COMMENT '课程编号',
course_name VARCHAR(60) NOT NULL COMMENT '课程名称',
credit TINYINT NOT NULL COMMENT '课程学分',	
tea_id INT NOT NULL COMMENT '教师工号',
PRIMARY KEY(course_id)
);

CREATE TABLE course_select
(
course_sel_id INT NOT NULL auto_increment COMMENT '选课编号',
stu_id INT NOT NULL COMMENT '学生编号',
cou_id INT NOT NULL COMMENT '课程编号',
select_date datetime COMMENT '选课时间',
score decimal(4,1) COMMENT '课程成绩',
PRIMARY KEY (course_sel_id)
);

-- 添加约束
-- 约束是约束字段的属性，使数据更加完整，在创建表的时候可以添加约束，也可以在创建完成后继续添加约束。
ALTER TABLE college ADD CONSTRAINT unique_college_name UNIQUE(college_name);
-- 查看表中的所有约束
SHOW CREATE TABLE college; 
-- 删除约束
ALTER TABLE college DROP INDEX unique_college_name;

ALTER TABLE student add CONSTRAINT fk_collid_stuid FOREIGN KEY(coll_id) REFERENCES college (college_id);
ALTER TABLE student DROP FOREIGN KEY fk_collid_stuid;

ALTER TABLE teacher add CONSTRAINT fk_collid_teaid FOREIGN KEY(coll_id) REFERENCES college (college_id);
ALTER TABLE teacher DROP FOREIGN KEY fk_collid_teaid;

ALTER TABLE course add CONSTRAINT fk_teaid_cuorid FOREIGN KEY(tea_id) REFERENCES teacher (teacher_id);
ALTER TABLE course DROP FOREIGN KEY fk_teaid_cuorid;

ALTER TABLE course_select add CONSTRAINT fk_stuid_sid FOREIGN key(stu_id) REFERENCES student(stu_id);
ALTER TABLE  course_select DROP FOREIGN KEY fk_stuid_sid;

ALTER TABLE course_select add CONSTRAINT fk_cid_course_id FOREIGN key(cou_id) REFERENCES course(course_id);
ALTER TABLE course_select DROP FOREIGN KEY fk_cid_course_id;

-- 给选课表的分数列添加触发器，分数不能小于0或者大于100.  

DELIMITER $$
use practice $$
create TRIGGER befor_socre_insert 
BEFORE INSERT
ON course_select FOR EACH ROW
BEGIN
IF(NEW.socre < 0 OR NEW.socre > 100) THEN
DELETE FROM course_select where score = NEW.score;
END IF ;
END ;	
DELIMITER ;

show TRIGGERS;

DROP TRIGGER befor_socre_insert;


索引
索引(相当于一本书的目录)，为表创建索引可以加速查询(用空间换时间)，索引会让增删改变得更慢，因为增删改操作调整 数据所以可能会导致更新索引
哪个列经常被用于查询的筛选条件，那么就应该在这个列上建立索引，主键上有默认的索引(唯一索引)，
如果使用模糊查询，如果查询条件不以%开头，那么索引有效，反之，无效

索引种类
普通索引：仅加速查询
唯一索引：加速查询 + 列值唯一（可以有null）
主键索引：加速查询 + 列值唯一（不可以有null）+ 表中只有一个
组合索引：多列值组成一个索引，专门用于组合搜索，其效率大于索引合并
全文索引：对文本的内容进行分词，进行搜索
<直接创建索引>
-- 创建普通索引
CREATE INDEX index_name ON table_name(col_name);
-- 创建唯一索引
CREATE UNIQUE INDEX index_name ON table_name(col_name);
-- 创建普通组合索引
CREATE INDEX index_name ON table_name(col_name_1,col_name_2);
-- 创建唯一组合索引
CREATE UNIQUE INDEX index_name ON table_name(col_name_1,col_name_2);

<通过修改表结构创建索引>
ALTER TABLE table_name ADD INDEX index_name(col_name);

-- 刪除索引
-- 直接删除索引
DROP INDEX index_name ON table_name;
-- 修改表结构删除索引
ALTER TABLE table_name DROP INDEX index_name;

-- 查看索引
-- #查看:
show index from `表名`; 或 show keys from `表名`;
-- #或
desc table_name; 也可以看索引，而且比较简单



-- DML 增删改查

-- 增

INSERT INTO college (college_name,college_master,college_web) VALUES
('计算机学院', '左冷禅', 'http://www.abc.com'),
('外国语学院', '岳不群', 'http://www.xyz.com'),
('经济管理学院', '风清扬', 'http://www.foo.com');


INSERT into student(stu_id,stu_name,stu_sex,stu_bir,stu_address,coll_id) VALUES
(1001, '向问天', '男', '1990-3-4', '四川成都', 1),
(1002, '任我行', '男', '1992-2-2', '湖南长沙', 1),
(1033, '任盈盈', '女', '1989-12-3', '湖南长沙', 1),
(1572, '余沧海', '男', '1993-7-19', '四川成都', 1),
(1378, '岳灵珊', '女', '1995-8-12', '四川绵阳', 1),
(1954, '林平之', '男', '1994-9-20', '福建莆田', 1),
(2035, '令狐冲', '男', '1988-6-30', '陕西咸阳', 2),
(3011, '林震南', '男', '1985-12-12', '福建莆田', 3),
(3755, '龙傲天', '男', '1993-1-25', '广东东莞', 3),
(3923, '向天问', '女', '1985-4-17', '四川成都', 3),
(2177, '隔壁老王', '男', '1989-11-27', '四川成都', 2);

INSERT INTO teacher(teacher_id,teacher_name,teacher_title,coll_id) VALUES
(1122, '张三丰', '教授', 1),
(1133, '宋远桥', '副教授', 1),
(1144, '杨逍', '副教授', 1),
(2255, '范遥', '副教授', 2),
(3366, '韦一笑', '讲师', 3);

INSERT INTO course(course_id,course_name,credit,tea_id) VALUES
(1111, 'Python程序设计', 3, 1122),
(2222, 'Web前端开发', 2, 1122),
(3333, '操作系统', 4, 1122),
(4444, '计算机网络', 2, 1133),
(5555, '编译原理', 4, 1144),
(6666, '算法和数据结构', 3, 1144),
(7777, '经贸法语', 3, 2255),
(8888, '成本会计', 2, 3366),
(9999, '审计', 3, 3366);

INSERT INTO course_select (stu_id,cou_id,select_date,score) VALUES
(1001, 1111, now(), 120),
(1001, 2222, now(), 87.5),
(1001, 3333, now(), 100),
(1001, 4444, now(), null),
(1001, 6666, now(), 100),
(1002, 1111, now(), 65),
(1002, 5555, now(), 42),
(1033, 1111, now(), 92.5),
(1033, 4444, now(), 78),
(1033, 5555, now(), 82.5),
(1572, 1111, now(), 78),
(1378, 1111, now(), 82),
(1378, 7777, now(), 65.5),
(2035, 7777, now(), 88),
(2035, 9999, now(), 70),
(3755, 1111, now(), 72.5),
(3755, 8888, now(), 93),
(3755, 9999, now(), null);

-- 删 

delete from student where stu_name = '隔壁老王';


-- 改 

update course_select set score = null where stu_id = 1378 and cou_id = 7777;


-- DQL 

-- 查询学生表的所有记录 
select * from student;

-- 查询指定字段的记录 / 查询学生表每个人的出生日期 
select stu_name as stuname ,stu_bir as birthday from student;

-- 加删选条件 / 查询学生表中所有女生的学号和姓名
select stu_id as 学号,stu_name as 学生姓名 from student where stu_sex = '女';

-- 查询学生表中所有的90后的女生姓名，出生日期，学号
select stu_id as 学号, stu_name as 学生姓名, stu_bir as 出生日期 from student where stu_sex = '女' and stu_bir between '1990-01-01' and '1999-12-31';

-- 模糊查询 / 查询学生表中姓林的学生信息。
select 	* from student where stu_name like '林%';

-- 查询姓“张”名字总共三个字的老师的姓名和职称(模糊)
select teacher_name as 姓名, teacher_title as 职称 from teacher  where teacher_name like '张__' ;

-- 查询名字中有“天”字的学生的姓名(模糊)
select stu_name as 姓名 from student where stu_name like '%天%' ;

-- 查询学生的籍贯(去重)
select distinct stu_address from student;

-- 查询男学生的姓名和生日按年龄从大到小排列(排序)
select stu_name as 姓名, stu_bir as 生日 from student where stu_sex = '男' order by stu_bir ;

-- 查询年龄最大/最小的学生的出生日期(聚合函数)
select max(stu_bir) from student ;
select min(stu_bir) from student ;

-- 查询学生/男学生/女学生的总人数
select count(stu_id) as 总人数 from student;
select count(stu_id) as 男生人数 from student where stu_sex = '男';
select count(stu_id) as 女生人数 from student where stu_sex = '女';

-- 查询课程号为1111课程的平均分/最低分/最高分/选课人数/考试人数
select avg(score) from course_select where cou_id = '1111';
select max(score) from course_select where cou_id = '1111';
select min(score) from course_select where cou_id = '1111';
select count(stu_id) from course_select where cou_id = '1111';
select count(score) from course_select where cou_id = '1111';

-- 查询男女学生的人数(分组和聚合函数)
select count(stu_id) as 人数 from student group by(stu_sex);

-- 查询学号为1001的学生所有课程的总成绩(筛选和聚合函数)
select sum(score) as 总分数 from course_select where stu_id = '1001';

-- 查询每个学生的学号和平均成绩(分组和聚合函数)
select stu_id as 学号, avg(score) as 平均成绩 from course_select group by stu_id;

-- 查询平均成绩大于等于80分的学生的学号和平均成绩(先分组每个人然后在筛选平均成绩大于80)
select stu_id as 学号,avg(score) as 平均成绩  from course_select group by stu_id having avg(score) >= 80;

-- 查询年龄最大的学生的姓名(子查询)
select stu_name as 学生姓名from student where stu_bir = (select min(stu_bir) from student);

-- 查询选了三门及以上的课程的学生姓名(子查询/分组条件/集合运算)
select stu_name as 姓名 from student where stu_id in (select stu_id from course_select  group by stu_id having count(stu_id)>=3);

-- 查询课程名称、学分、授课老师的名字和职称（连表查询）
select course_name,credit,teacher_name,teacher_title from course,teacher where tea_id = teacher_id;

-- 查询学生姓名和所在学院名称
select stu_name,college_name from student,college where coll_id = college_id;

-- 查询学生姓名、课程名称以及考试成绩(三表连表查询)
select stu_name,course_name,score from student,course,course_select 
where student.stu_id = course_select.stu_id and cou_id = course_id
and score is not null;

-- 查询选课学生的姓名和平均成绩(子查询和连接查询)
select stu_name as 姓名, avgscore from student,
(select stu_id,avg(score) as avgscore from course_select group by stu_id) course_select
where course_select.stu_id = student.stu_id;

-- 查询每个学生的姓名和选课数量(左外连接和子查询)
select stu_name as 姓名, ifnull(total, 0) as 选课数量 
from student left outer join (select stu_id, count(stu_id) as total 
from course_select group by stu_id) course_select on course_select.stu_id = student.stu_id;



4. DCL 数据库权限控制

-- 创建名为hellokitty的用户
create user 'hellokitty'@'localhost' identified by '123123';

-- 将对SRS数据库所有对象的所有操作权限授予hellokitty
grant all privileges on SRS.* to 'hellokitty'@'localhost';

-- 召回hellokitty对SRS数据库所有对象的insert/delete/update权限
revoke insert, delete, update on SRS.* from 'hellokitty'@'localhost';



范式理论

数据完整性

1. 实体完整性 - 每个实体都是独一无二的
   - 主键 / 唯一约束 / 唯一索引
2. 引用完整性（参照完整性）
   - 外键
3. 域完整性 - 数据是有效的
   - 数据类型
   - 非空约束
   - 默认值约束
   - 检查约束
