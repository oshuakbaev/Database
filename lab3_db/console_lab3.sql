create database lab3
template template0
encoding UTF8;

--1.a
select *
from course
where credits>3;

--1.b
select *
from classroom
where building='Watson' or building = 'Packard';

--1.c
select *
from course
where dept_name = 'Comp. Sci.';

--1.d
select course_id,semester
from takes
where semester = 'Fall';

--1.e
select *
from student
where tot_cred>45 and tot_cred<90;

--1.f
select name
from student
where name like '%a' or name like '%e' or name like '%i' or name like '%o' or name like '%u';

--1.g
select *
from prereq
where prereq_id like 'CS-101';

-- 2.a
select name, dept_name, avg(salary) as average_salary
from instructor
group by name,dept_name;

--2.b

select foo.building,max(count_course_id)
from (select count(course_id) as count_course_id,building from section group by building) as foo
group by foo.building;

--2c

select dept_name,min(count_course_id)
from (select dept_name,count(course_id) as count_course_id from course group by dept_name) as foo
group by foo.dept_name;

--2.d

select S.id, S.name, T.course_id
from takes T, student S
where S.dept_name = 'Comp. Sci.' and (select count(course_id) from takes)>3
group by S.id, S.name, T.course_id;

-- 2.e
select name , dept_name
from instructor
where dept_name = 'Biology' or dept_name = 'Philosophy' or dept_name = 'Music';

-- 2f

select a.id,b.name,a.year
from teaches a , instructor b
where a.year = 2017 and a.id not in(select a.id
                                 from teaches
                                 where a.year = 2018) ;

--3.a

select id,course_id,grade
from takes
where course_id like '%CS%' and (grade = 'A' or grade = 'A-')

--3.b
select S.id as student_id,S.name as name_of_student , A.s_id as Advisor_id,pgrade
from advisor A,student S,(select grade as pgrade from takes where grade<>'B' and grade<>'A' and grade<>'A-' and grade<>'B+') as grade;

-- 3.c

select distinct(id) ,course_id,grade
from takes
where grade = 'A' or grade = 'B' or grade = 'A+' or grade = 'A-' or grade = 'B+'
or grade = 'B-';

--3.d
select teaches.id,instructor.name, teaches.course_id , takes.course_id, foo.grade
from teaches,(select grade from takes where grade <> 'A') as foo , takes,instructor
where takes.course_id = teaches.course_id and instructor.id = teaches.id
group by  teaches.id, instructor.name, teaches.course_id,takes.course_id, foo.grade;

--3.e

select section.course_id,time_slot.end_hr
from section, time_slot
where section.time_slot_id = time_slot.time_slot_id and end_hr<13;
