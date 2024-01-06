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
