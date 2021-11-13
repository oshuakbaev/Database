create database lab7
template template0
encoding UTF8;

create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

select * from customers;
select * from accounts;
select * from transactions;

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');


--1
--You can use large object data types to store audio, video, images, and other files that are larger than 32 KB.
--The VARCHAR, VARGRAPHIC, and VARBINARY data types have a storage limit of 32 KB.
--However, applications often need to store large text documents or additional data types such as audio,
--video, drawings, images, and a combination of text and graphics.
--For data objects that are larger than 32 KB, you can use the corresponding
--large object (LOB) data types to store these objects.


-------2.

-- role is a way to distinguish users.
-- user - it's named privilege
-- privilege it's ability.

--2.1

create role accountant;
create role administrator;
create role support;
create user "Kyanish_support";

GRANT all privileges ON lab7.public.accounts TO "Aiba";
GRANT all privileges ON lab7.public.accounts TO "Kuanish_admin";
GRANT insert ON lab7.public.accounts TO "Kyanish_support";


grant accountant to "Aiba";
grant administrator to "Kuanish_admin";
grant support to "Kyanish_support";

grant olzhas to "Kuanish_admin";

REVOKE all privileges ON accounts from "Aiba";

--5 indexes

create table cust_acc as
    select customers.name,customers.id, accounts.customer_id,accounts.currency
    from customers join accounts on customers.id = accounts.customer_id;

select * from transactions;

ALTER TABLE cust_acc
ADD UNIQUE (name,id,customer_id,currency);


create index test_index1 on cust_acc(id);

-- error  
SELECT * FROM cust_acc WITH(index(test_index1));


--6
begin;
create table transaction_init as
    select transactions.id,transactions.date,transactions.src_account,transactions.dst_account,transactions.amount,transactions.status
        from transactions where transactions.status='init';
commit;

select * from accounts;
select * from transactions;


create table six_2 as
    select accounts.account_id,transactions.src_account,transactions.dst_account,accounts.balance
        from accounts left join transactions on accounts.account_id = transactions.src_account or
             accounts.account_id = transactions.dst_account;


--error ,while trying to do 6.
begin;
    create table src_acc as
        select accounts.account_id,transactions.src_account,accounts.balance
        from accounts inner join transactions on accounts.account_id = transactions.src_account;
commit;

drop  src_acc;
select * from src_acc;
