create database project
template template0
encoding UTF8;

create table Shop(
    product_info varchar(32),
    purchases varchar(32),
    Unique(product_info),
    foreign key(product_info) references time_slot(client_purchases)
);


create table time_slot(
    client_date_purchases int,
    client_purchases varchar(32),
    product_season varchar(32),
    product_region varchar(32),
    primary key(client_purchases)
);

create table electronic_product(
    product_name varchar(32),
    product_id int,
    number_of_product int,
    receipt int,
    primary key(product_name)
);

create table electronic(
    number_of_elec int,
    TV varchar(32),
    Computer int,
    phones int,
    prod_name varchar,
    primary key(number_of_elec)
);


create table Manufacturers(
    production int ,
    Apple int,
    Sony int,
    Nicon int,
    Samsung int,
    foreign key(production) references electronic_product(product_id)
);

create table warehouse(
    number_product int,
    foreign key(number_product) references electronic_product(number_of_product)
);
Alter table electronic_product
add unique(number_of_product);

create table payment(
    credit_card int,
    debit_card int,
    cash int
);

create table client(
    client_acc varchar(56),
    client_purchases varchar(56),
    receipt int,
    client_bonuses int,
    client_bills varchar(10000),
    purchase_year int,
    primary key(client_acc),
    unique (client_purchases)
);

create table transportation(
    product_id int,
    number_of_product int,
    primary key(product_id),
    receipt_ int,
    UNIQUE(receipt_)
);


create table Airplane(
    name varchar(32),
    path varchar(32),
    receipt_1 int
);

create table car(
    name varchar(32),
    path varchar(32),
    receipt_2 int
);

create table ship(
    name varchar(32),
    path varchar(32),
    receipt_3 int
);

CREATE INDEX index_shop
ON Shop (product_info,purchases);

CREATE INDEX index_time_slot
ON time_slot(client_purchases,client_date_purchases);

CREATE INDEX index_electronic_product
ON electronic_product(product_name,product_id);

CREATE INDEX index_electronic
ON electronic(number_of_elec,TV);

CREATE INDEX index_Manufacturers
ON Manufacturers(production,Apple);

CREATE INDEX index_warehouse
ON warehouse(number_product);

CREATE INDEX index_payment
ON payment(cash);

CREATE INDEX index_client
ON client(client_acc);

CREATE INDEX index_transportation
ON transportation(product_id);

CREATE INDEX index_Airplane
ON Airplane(name);

CREATE INDEX index_car
ON car(name);

CREATE INDEX index_ship
ON ship(name);

INSERT INTO client(client_acc, client_purchases, receipt, client_bonuses, client_bills,purchase_year) VALUES
('avaava@ffw','vmvdvm',255,2,11111,2020),('avaava@ffw','vfvdvd',256,22,1122111,2020),('smvomfm@ffw','smvomfm',256,22,1122111,2020),
('avdfba@ffw','avdfba',256,22,1122111,2020);

;


select * from client;


INSERT INTO electronic_product(product_name, product_id, number_of_product, receipt) VALUES
    ('smvomfm','144',215,255),('smvomffm','4',26,256),('smvomffm','4',26,256);



insert into electronic(prod_name,number_of_elec, TV, Computer, phones) values
('smvomffm',2115,1113,155,166),
('smvomfm',255,5113,1155,1166);

select * from electronic_product;

insert into shop(product_info) values
('smvomfm'),
('smvomffm');


insert into time_slot(client_date_purchases, client_purchases, product_season, product_region) values
(211,'avaava','spring','mced'),(21,'vfvdvd','leto','aef'),(21,'vfvdvd','leto','aef');

select * from shop;


--4.Find the customer who has bought the most (by price) in the past year

select client_acc,purchase_year,max(clie)
from client
where cl
group by client_acc, purchase_year,client_purchases;

select * from client;



