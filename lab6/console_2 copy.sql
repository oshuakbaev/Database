create database lab6
template template0
encoding UTF8;

create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);


INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

select * from dealer;
select * from client;
select * from sell;

--1.a

select * from
dealer cross join client;

--1.b

select dealer.name, c.name, c.city, sell.id, sell.date, sell.amount from
dealer inner join client c on dealer.id = c.dealer_id
inner join sell on dealer.id = sell.dealer_id and c.id = sell.client_id;

--1.c
select dealer.id, c.id, dealer.name, c.name, c.city from
dealer inner join
    client c on c.city = dealer.location;

--1.d
select sell.id, sell.amount, c.name, dealer.location from
dealer inner join client c on dealer.id = c.dealer_id
inner join sell on dealer.id = sell.dealer_id and c.id = sell.client_id
where sell.amount >= 100.0 AND sell.amount <= 500.0;

--1.e
select id, name from dealer;

--1.f
select c.name, c.city, dealer.name, dealer.charge * sell.amount AS comission from
dealer inner join client c on dealer.id = c.dealer_id
inner join sell on dealer.id = sell.dealer_id and c.id = sell.client_id;
--1.g
select c.name, c.city, dealer.name, dealer.charge * sell.amount as comission from
dealer inner join client c on dealer.id = c.dealer_id
inner join sell on dealer.id = sell.dealer_id and c.id = sell.client_id
where dealer.charge > 0.12;
--1.h
select c.name, c.city, sell.date, sell.amount, dealer.name, dealer.charge * sell.amount AS comission from
dealer INNER JOIN client c on dealer.id = c.dealer_id
INNER JOIN sell on dealer.id = sell.dealer_id AND c.id = sell.client_id
;
--1.i
SELECT c.name, c.priority, dealer.name, sell.id, sell.amount AS temp FROM
dealer INNER JOIN client c on dealer.id = c.dealer_id
INNER JOIN sell on dealer.id = sell.dealer_id AND c.id = sell.client_id
WHERE sell.amount < 2000 OR (sell.amount > 2000 AND c.priority IS NOT NULL);

--2 task

create view v1 as
select sell.date, count(c.name), avg(sell.amount), sum(sell.amount) from
sell inner join client c on c.id = sell.client_id
group by (sell.date)
order by sell.date
;

select * from v1;


create view v2 as
select sell.date, count(c.name), avg(sell.amount), sum(sell.amount) from
sell inner join client c on c.id = sell.client_id
group by (sell.date)
order by sum(-sell.amount)
;
select * from v2 limit 5;


create view v3 as
select d.id, count(sell.id), sum(sell.amount), avg(sell.amount) from
sell inner join dealer d on d.id = sell.dealer_id
group by d.id;
select * from v3;


create view v4 as
select count(sell.dealer_id), sum(sell.amount), avg(sell.amount), sum(sell.amount * d.charge) as total from
sell inner join dealer d on d.id = sell.dealer_id
group by d.location;
select * from v4;


create view v5 as
select count(sell.id), sum(sell.amount), avg(sell.amount) from
sell inner join dealer d on d.id = sell.dealer_id
group by d.location;
select * from v5;


create view v6 as
select c.city, count(sell.id), avg(sell.amount), sum(sell.amount) from
sell inner join client c on c.id = sell.client_id
group by (c.city)
-- order by sum(-sell.amount)
;
select * from v6;


drop view v5, v6;
create view v5 as
select d.location, count(sell.id), sum(sell.amount) as plus, avg(sell.amount) from
sell inner join dealer d on d.id = sell.dealer_id
group by d.location;
-- select * from v5;
-- drop view v5;

create view v6 as
select c.city, count(sell.id), avg(sell.amount), sum(sell.amount) as minus from
sell inner join client c on c.id = sell.client_id
group by (c.city)
;

select * from
v5 right join v6 v on v5.location = v.city
where v5.plus < v.minus or (v5.location is null and v.city is not null);