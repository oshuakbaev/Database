create database lab8
template template0
encoding UTF8;

--1.a
CREATE FUNCTION inc(val integer) RETURNS integer AS
    $$ BEGIN
        RETURN val + 1;
        END;
    $$
    LANGUAGE PLPGSQL;
--example
select inc(2);

--1.b
CREATE FUNCTION inc_2(val integer,val2 integer) RETURNS integer AS
    $$ BEGIN
        RETURN val + val2;
        END;
    $$
    LANGUAGE PLPGSQL;

--example
select inc_2(2,3);

--1.c
CREATE FUNCTION inc_3(val integer,out boolean_1 bool) AS

    $$ BEGIN
        if mod(val,2)=0 then boolean_1=true;
        else boolean_1=false;
        end if;
        END;
    $$
    LANGUAGE PLPGSQL;

--1.d

create or replace function isvalid(a varchar) returns bool as
    $$
        begin
            if length(a) > 7 then
                return true;
            else
                return false;
            end if;
        end;
    $$
language plpgsql;
select isvalid('qwerty12');

--1e
CREATE FUNCTION inc_4(val integer,out val1 integer, out val2 integer) AS

    $$ BEGIN
        val1=val+5;
        val2=val+10;
        END;
    $$
    LANGUAGE PLPGSQL;

select inc_4(1);

--2a--check

create table some_upd (
                          upd varchar(255),
                          crt_at timestamp,
                          upd_at timestamp
);
create or replace function time_function() returns trigger as $$
    begin
        if (tg_op = 'UPDATE') then
        new.upd_at = now();
    elsif (tg_op = 'INSERT') then
        new.upd_at = now();
        new.crt_at = now();
    end if;
    return new;
    end; $$
language plpgsql;

create trigger func before insert or update on some_upd
    for each row execute procedure time_function();

--2b

create table person(
    f_name varchar(64),
    l_name varchar(64),
    bd date,
    age integer
);

create or replace function get_age() returns trigger as $a$
    declare cur_d date;
    declare y integer;
    declare m integer;
    declare d integer;
    declare y0 integer;
    declare m0 integer;
    declare d0 integer;
    declare datee date;
    begin
        cur_d = current_date;
        datee := new.bd;
        y = extract(year from datee);
        m = extract(month from datee);
        d = extract(day from datee);
        y0 = extract(year from cur_d);
        m0 = extract(month from cur_d);
        d0 = extract(day from cur_d);
--         new.age = 10;
--         return new;
        if (m0 > m or (m0 = m and d0 >= d)) then
            new.age = y0 - y;
        else
            new.age = y0 - y - 1;
--         perform new.age;
        end if;
        return new;
    end
$a$ language plpgsql;

-- drop trigger age on person;
create trigger age before insert or update on person
    for each row execute procedure get_age();

insert into person(f_name, l_name, bd) values ('Olya', 'WFGVVBsvava', '2012-12-26') returning *;


--2c
create table sales(
    id serial,
    total double precision
);

create function tax() returns trigger as $$
    begin
        new.total := new.total * 1.12;
        return new;
    end;
$$ language plpgsql;

create trigger tax before insert or update on sales
    for each row execute procedure tax();
insert into sales(total) values (1000000000) returning *;

--2.d

create table dd (
    n int,
    m int
);

create function tokta() returns trigger as $$
    begin
        if (tg_op = 'DELETE') then
            raise exception 'dont delete';
        end if;
        return new;
    end
$$ language plpgsql;

create trigger tokta_trig before delete on dd
    for each row execute procedure tokta();
insert into dd (n, m)
values (10, 10);
delete from dd where m = 10 and n = 10;

--2.e

create table tablo (
   id int,
   a int,
   akvadrat int,
   acube int,
   password varchar,
   checkpp bool,
   primary key(id)
);

create function checkpass() returns trigger as
    $$
        begin
            new.akvadrat = new.a*new.a;
            new.acube = new.a*new.a*new.a;
           if length(new.password) > 7 then
                        new.checkpp := true;
                        return new;
                    else
                        new.checkpp := false;
                        return new;
                end if;
        end;
    $$
language plpgsql;

create trigger passtrigger before insert on tablo
    for each row execute procedure checkpass();

insert into tablo(id, a, password) values (1, 3, 'holy') returning *;
insert into tablo(id, a, password) values (32, 4, 'fddafsafsaa') returning  *;
insert into tablo(id, a,  password) values (31, 5,'fdaf') returning  *;



--3
--Function, in computer programming language context, a set of instructions which takes some input and performs certain tasks. In SQL, a function returns a value.
--Procedure
--Procedure, as well, is a set of instructions which takes input and performs certain task.


--4a

create table tb1(
    id int unique,
    name varchar,
    date_of_birth date,
    age int,
    salary int,
    workexperience int,
    discount int
);
create or replace procedure increase()as
    $$
        begin
            update tb1
            set salary = salary * (workexperience/2)*1.1,
            discount = 10
            where workexperience >= 2;

            update tb1
            set discount = discount + (workexperience / 5)
            where workexperience >= 5;
            commit ;
        end;
    $$
language plpgsql;

call increase();
insert into tb1 values (1,'Olzjh', '2001-01-25', 19, 50000, 16, 0);
select * from tb1;


--- b ---
create or replace procedure increase40() as
    $$
        begin
            update tb1
            set salary = salary * 1.15
            where age >= 40;

            update tb1 set
            salary = salary * 1.15,
            discount = 20
            where age >= 40 and workexperience >= 8;
            commit ;
        end;
    $$
language plpgsql;

insert into tb1 values ( 3, 'WFvbdvv', '2000-11-11', 19, 40000, 20,0);
call increase40();
select * from tb1;

--5
CREATE TABLE members(
    memid integer,
    primary key (memid),
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode integer,
    telephone varchar(20),
    recommendedby integer,
    joindate timestamp
);
CREATE TABLE facilities(
    facid integer,
    primary key (facid),
    name varchar(100),
    membercost numeric,
    questcost numeric,
    initialoutlay numeric,
    monthlymaintenance numeric
);
CREATE TABLE bookings(
    facid integer,
    foreign key (facid) references facilities,
    memid integer,
    foreign key (memid) references members(memid),
    starttime timestamp,
    slots  integer
);

INSERT INTO members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) VALUES
(0, 'GUEST', 'GUEST', 'GUEST', 0, '(000) 000-0000', NULL, '2012-07-01 00:00:00'),
(1, 'Smith', 'Darren', '8 Bloomsbury Close, Boston', 4321, '555-555-5555', NULL, '2012-07-02 12:02:05'),
(2, 'Smith', 'Tracy', '8 Bloomsbury Close, New York', 4321, '555-555-5555', NULL, '2012-07-02 12:08:23'),
(3, 'Rownam', 'Tim', '23 Highway Way, Boston', 23423, '(844) 693-0723', NULL, '2012-07-03 09:32:15'),
(4, 'Joplette', 'Janice', '20 Crossing Road, New York', 234, '(833) 942-4710', 1, '2012-07-03 10:25:05'),
(5, 'Butters', 'Gerald', '1065 Huntingdon Avenue, Boston', 56754, '(844) 078-4130', 1, '2012-07-09 10:44:09'),
(6, 'Tracy', 'Burton', '3 Tunisia Drive, Boston', 45678, '(822) 354-9973', NULL, '2012-07-15 08:52:55'),
(7, 'Dare', 'Nancy', '6 Hunting Lodge Way, Boston', 10383, '(833) 776-4001', 4, '2012-07-25 08:59:12'),
(8, 'Boothe', 'Tim', '3 Bloomsbury Close, Reading, 00234', 234, '(811) 433-2547', 3, '2012-07-25 16:02:35'),
(9, 'Stibbons', 'Ponder', '5 Dragons Way, Winchester', 87630, '(833) 160-3900', 6, '2012-07-25 17:09:05'),
(10, 'Owen', 'Charles', '52 Cheshire Grove, Winchester, 28563', 28563, '(855) 542-5251', 1, '2012-08-03 19:42:37'),
(11, 'Jones', 'David', '976 Gnats Close, Reading', 33862, '(844) 536-8036', 4, '2012-08-06 16:32:55'),
(12, 'Baker', 'Anne', '55 Powdery Street, Boston', 80743, '844-076-5141', 9, '2012-08-10 14:23:22'),
(13, 'Farrell', 'Jemima', '103 Firth Avenue, North Reading', 57392, '(855) 016-0163', NULL, '2012-08-10 14:28:01'),
(14, 'Smith', 'Jack', '252 Binkington Way, Boston', 69302, '(822) 163-3254', 1, '2012-08-10 16:22:05'),
(15, 'Bader', 'Florence', '264 Ursula Drive, Westford', 84923, '(833) 499-3527', 9, '2012-08-10 17:52:03'),
(16, 'Baker', 'Timothy', '329 James Street, Reading', 58393, '833-941-0824', 13, '2012-08-15 10:34:25'),
(17, 'Pinker', 'David', '5 Impreza Road, Boston', 65332, '811 409-6734', 13, '2012-08-16 11:32:47'),
(20, 'Genting', 'Matthew', '4 Nunnington Place, Wingfield, Boston', 52365, '(811) 972-1377', 5, '2012-08-19 14:55:55'),
(21, 'Mackenzie', 'Anna', '64 Perkington Lane, Reading', 64577, '(822) 661-2898', 1, '2012-08-26 09:32:05'),
(22, 'Coplin', 'Joan', '85 Bard Street, Bloomington, Boston', 43533, '(822) 499-2232', 16, '2012-08-29 08:32:41'),
(24, 'Sarwin', 'Ramnaresh', '12 Bullington Lane, Boston', 65464, '(822) 413-1470', 15, '2012-09-01 08:44:42'),
(26, 'Jones', 'Douglas', '976 Gnats Close, Reading', 11986, '844 536-8036', 11, '2012-09-02 18:43:05'),
(27, 'Rumney', 'Henrietta', '3 Burkington Plaza, Boston', 78533, '(822) 989-8876', 20, '2012-09-05 08:42:35'),
(28, 'Farrell', 'David', '437 Granite Farm Road, Westford', 43532, '(855) 755-9876', NULL, '2012-09-15 08:22:05'),
(29, 'Worthington-Smyth', 'Henry', '55 Jagbi Way, North Reading', 97676, '(855) 894-3758', 2, '2012-09-17 12:27:15'),
(30, 'Purview', 'Millicent', '641 Drudgery Close, Burnington, Boston', 34232, '(855) 941-9786', 2, '2012-09-18 19:04:01'),
(33, 'Tupperware', 'Hyacinth', '33 Cheerful Plaza, Drake Road, Westford', 68666, '(822) 665-5327', NULL, '2012-09-18 19:32:05'),
(35, 'Hunt', 'John', '5 Bullington Lane, Boston', 54333, '(899) 720-6978', 30, '2012-09-19 11:32:45'),
(36, 'Crumpet', 'Erica', 'Crimson Road, North Reading', 75655, '(811) 732-4816', 2, '2012-09-22 08:36:38'),
(37, 'Smith', 'Darren', '3 Funktown, Denzington, Boston', 66796, '(822) 577-3541', NULL, '2012-09-26 18:08:45');

WITH RECURSIVE rec_recommendedby(recommender, member) as(
    select recommendedby, memid from members
    union all
    select members.recommendedby, rec.member from rec_recommendedby rec
    inner join members on members.memid=rec.recommender
)
SELECT rec.member, rec.recommender, members.firstname, members.surname
FROM rec_recommendedby rec
inner join members ON rec.recommender=members.memid
WHERE rec.member=12 or rec.member=22
ORDER BY rec.member asc, rec.recommender desc




