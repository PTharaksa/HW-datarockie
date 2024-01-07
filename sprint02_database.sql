--drop database if exists pizzaDB;
--create database pizzaDB;
--use pizzaDB;

create table if not exists orders (
                      order_id varchar(10) primary key not null, 
                      cus_id varchar(10) not null,                         
                      order_date date,  
                      order_status varchar(10),
                      menu_id varchar(10) not null,
                      unit integer(10),
                      emp_id varchar(10) not null);

create table if not exists customer ( 
  cus_id varchar(10) primary key not null,        
  cus_firstname varchar(40), 
  cus_lastname varchar(40), 
  cus_phone int(10),
  cus_address varchar(30),
  is_member boolean not null);

create table if not exists employee ( 
  emp_id varchar(10) primary key not null,        
  emp_firstname varchar(40), 
  emp_lastname varchar(40), 
  emp_phone int(10),
  emp_email varchar(30),
  sin_year int(4),
  ret_year int(4),
  emp_pos varchar(10));

create table if not exists position ( 
  emp_pos varchar(10) primary key not null,
  salary decimal(5,2),
  dep varchar(20));

create table if not exists menu ( 
  menu_id varchar(10) primary key not null,
  unit_price decimal(5,2),
  menu_abbname varchar(20));

create table if not exists member ( 
  mem_id varchar(10) primary key not null,
  cus_id varchar(10),
  points decimal(5,2),
  mem_email varchar(30),
  mem_type varchar(10));
---insert values into orders table
insert into orders values ('R001', 'C001', '2022-01-01', 'Completed', 'M001', 1, 'E004');
insert into orders values ('R002', 'C001', '2022-01-05','Completed', 'M002', 1, 'E005');
insert into orders values ('R003', 'C002', '2022-01-01','Completed', 'M005', 1, 'E004');
insert into orders values ('R004', 'C003', '2022-01-01', 'Completed', 'M003', 2, 'E007');
insert into orders values ('R005', 'C004', '2022-02-12', 'Completed', 'M003', 1, 'E004');
insert into orders values ('R006', 'C005', '2022-02-13',  'Completed', 'M004', 1, 'E005');
insert into orders values ('R007', 'C005', '2022-02-15', 'Completed', 'M002', 2, 'E007');
insert into orders values ('R008', 'C003', '2022-03-01','Completed', 'M003', 2, 'E004');
insert into orders values ('R009', 'C002', '2022-03-01','Completed', 'M003', 2, 'E005');
insert into orders values ('R010', 'C004', '2022-03-01','Completed', 'M003', 1, 'E005');

---insert values into customer table
insert into customer values ('C001', 'James', 'Smith', 0987654321, '123 Main Street', true);
insert into customer values ('C002', 'Jane', 'Doe', 6656641147, '3244 Bruen Circles', false);
insert into customer values ('C003', 'Bobby', 'Brown', 6626320923, 'Suite 397 882 Goodwin Rest', true);
insert into customer values ('C004', 'Sam', 'Smith', 6624767889, 'Apt. 574 547 Fonda Crescent', false);
insert into customer values ('C005', 'Taylor', 'Swift', 6624521857, '3775 Kuvalis Rapids', true);

---insert values into employee table
insert into employee values ('E001', 'John', 'Doe', 1234567890, 'qpmzj@example.com', 2001, null, 'Manager');
insert into employee values ('E002', 'Jane', 'Smith', 2345678901, 'oqibz@example.com', 1989, 2019, 'Manager');
insert into employee values ('E003', 'Bob', 'Johnson', 3456789012, 'ejeyd@example.com' , 1999 , null, 'Chef');
insert into employee values ('E004', 'Alice', 'Williams', 4567890123, 'rdlnk@example.com', 2015,
  null, 'Cashier');
insert into employee values ('E005', 'Mike', 'Brown', 5678901234, 'ejeyd@example.com', 2015, null, 'Cashier');
insert into employee values ('E006', 'Emily', 'Davis', 6789012345, 'oqibz@example.com', 2015, null, 'Delivery');
insert into employee values ('E007', 'Michel', 'Brown', 5678901234, 'ejeydz@example.com', 2015, null, 'Cashier');

---insert values into menu table
insert into menu values ('M001', 379.00, 'Hawaiian Pizza');
insert into menu values ('M002', 299.00, 'Doublecheese Pizza');
insert into menu values ('M003', 299.00, 'Doublepeperoni Pizza');
insert into menu values ('M004', 349.00, 'Seafood Cocktail Pizza');
insert into menu values ('M005', 349.00, 'Spicy Superseafood Pizza');

---insert values into member table
insert into member values ('MEM001', 'C001', 0.00, 'qpmzj@example.com', null);
insert into member values ('MEM002', 'C003', 0.00, 'oqibz@example.com', null);
insert into member values ('MEM003', 'C005', 0.00, 'ejeyd@example.com', null);

---insert values into position table
insert into position values ('Casheir', 12000.00, 'Customer Service');
insert into position values ('Chef', 20000.00, 'Chef');
insert into position values ('Deliver', 12000.00, 'Customer Service');
insert into position values ('Manager', 30000.00, 'Manager');


.mode box
---ยอดขายในแต่ละเดือน 
select strftime('%m', orders.order_date) AS months, sum(unit * (
  select unit_price
  from menu
  where menu.menu_id == orders.menu_id
)) AS total_sales
from orders
group by months
ORDER BY months;

---ยอดขายที่พนักงานแต่ละคนทำได้
select emp.emp_firstname, emp.emp_lastname, sum(o.unit * (
  select unit_price
  from menu
  where menu.menu_id == o.menu_id
)) AS total_sales
from orders as o
inner join employee as emp 
on o.emp_id == emp.emp_id
group by emp.emp_firstname, emp.emp_lastname
order by total_sales desc;

---เมนูที่มีการสั่งมากที่สุด
select sum(unit) as total_unit, (
  select menu_abbname
  from menu
  where menu.menu_id == orders.menu_id
) AS menu_name
from orders
group by menu_name
order by sum(unit) desc;

---ถ้าลูกค้าเป็นสมาชิกให้บวกคะแนนสะสม 5 คะแนนต่อ 1 รายการอาหาร 
--ถ้า น้อยกว่า 10 --> bronze 
--ถ้า 10-19 --> platinum 
--ถ้า 20-29 --> silver
--ถ้า 30-39 --> gold 
--ถ้า 40 ขึ้นไป --> diamond 

with CustomerTotalPoints as (
  select cus.cus_id, SUM(o.unit * 5) as total_points
  from customer as cus
  inner join orders as o on cus.cus_id = o.cus_id
  group by cus.cus_id
)

  update member
  set points = points + ctp.total_points,
  mem_type = case when points + ctp.total_points < 10 then 'Bronze'
    when points + ctp.total_points >= 10 and points + ctp.total_points < 20 then 'Platinum'
    when points + ctp.total_points >= 20 and points + ctp.total_points < 30 then 'Silver'
    when points + ctp.total_points >= 30 and points + ctp.total_points < 40 then 'Gold'
    when points + ctp.total_points >= 40 and points + ctp.total_points < 50 then 'Diamond'
    end
  from CustomerTotalPoints ctp
  where member.cus_id = ctp.cus_id;
select * from member;