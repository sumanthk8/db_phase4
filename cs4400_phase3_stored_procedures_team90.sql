-- CS4400: Introduction to Database Systems (Spring 2024)
-- Phase III: Stored Procedures & Views [v1] Wednesday, March 27, 2024 @ 5:20pm EST
-- Group Version Tracker: v1.0

-- Team 90
-- Neel Sardana (nsardana3)
-- Yash Bhatia (ybhatia9)
-- George Tsakalakos (gtsakalakos3)
-- Sumanth Kondapalli (skondapalli9) 
-- Kabir Doshi (kdoshi36)

-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'drone_dispatch';
drop database if exists drone_dispatch;
create database if not exists drone_dispatch;
use drone_dispatch;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table users (
uname varchar(40) not null,
first_name varchar(100) not null,
last_name varchar(100) not null,
address varchar(500) not null,
birthdate date default null,
primary key (uname)
) engine = innodb;

create table customers (
uname varchar(40) not null,
rating integer not null,
credit integer not null,
primary key (uname)
) engine = innodb;

create table employees (
uname varchar(40) not null,
taxID varchar(40) not null,
service integer not null,
salary integer not null,
primary key (uname),
unique key (taxID)
) engine = innodb;

create table drone_pilots (
uname varchar(40) not null,
licenseID varchar(40) not null,
experience integer not null,
primary key (uname),
unique key (licenseID)
) engine = innodb;

create table store_workers (
uname varchar(40) not null,
primary key (uname)
) engine = innodb;

create table products (
barcode varchar(40) not null,
pname varchar(100) not null,
weight integer not null,
primary key (barcode)
) engine = innodb;

create table orders (
orderID varchar(40) not null,
sold_on date not null,
purchased_by varchar(40) not null,
carrier_store varchar(40) not null,
carrier_tag integer not null,
primary key (orderID)
) engine = innodb;

create table stores (
storeID varchar(40) not null,
sname varchar(100) not null,
revenue integer not null,
manager varchar(40) not null,
primary key (storeID)
) engine = innodb;

create table drones (
storeID varchar(40) not null,
droneTag integer not null,
capacity integer not null,
remaining_trips integer not null,
pilot varchar(40) not null,
primary key (storeID, droneTag)
) engine = innodb;

create table order_lines (
orderID varchar(40) not null,
barcode varchar(40) not null,
price integer not null,
quantity integer not null,
primary key (orderID, barcode)
) engine = innodb;

create table employed_workers (
storeID varchar(40) not null,
uname varchar(40) not null,
primary key (storeID, uname)
) engine = innodb;

-- -----------------------------------------------
-- referential structures
-- -----------------------------------------------

alter table customers add constraint fk1 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table employees add constraint fk2 foreign key (uname) references users (uname)
	on update cascade on delete cascade;
alter table drone_pilots add constraint fk3 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table store_workers add constraint fk4 foreign key (uname) references employees (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk8 foreign key (purchased_by) references customers (uname)
	on update cascade on delete cascade;
alter table orders add constraint fk9 foreign key (carrier_store, carrier_tag) references drones (storeID, droneTag)
	on update cascade on delete cascade;
alter table stores add constraint fk11 foreign key (manager) references store_workers (uname)
	on update cascade on delete cascade;
alter table drones add constraint fk5 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table drones add constraint fk10 foreign key (pilot) references drone_pilots (uname)
	on update cascade on delete cascade;
alter table order_lines add constraint fk6 foreign key (orderID) references orders (orderID)
	on update cascade on delete cascade;
alter table order_lines add constraint fk7 foreign key (barcode) references products (barcode)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk12 foreign key (storeID) references stores (storeID)
	on update cascade on delete cascade;
alter table employed_workers add constraint fk13 foreign key (uname) references store_workers (uname)
	on update cascade on delete cascade;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into users values
('jstone5', 'Jared', 'Stone', '101 Five Finger Way', '1961-01-06'),
('sprince6', 'Sarah', 'Prince', '22 Peachtree Street', '1968-06-15'),
('awilson5', 'Aaron', 'Wilson', '220 Peachtree Street', '1963-11-11'),
('lrodriguez5', 'Lina', 'Rodriguez', '360 Corkscrew Circle', '1975-04-02'),
('tmccall5', 'Trey', 'McCall', '360 Corkscrew Circle', '1973-03-19'),
('eross10', 'Erica', 'Ross', '22 Peachtree Street', '1975-04-02'),
('hstark16', 'Harmon', 'Stark', '53 Tanker Top Lane', '1971-10-27'),
('echarles19', 'Ella', 'Charles', '22 Peachtree Street', '1974-05-06'),
('csoares8', 'Claire', 'Soares', '706 Living Stone Way', '1965-09-03'),
('agarcia7', 'Alejandro', 'Garcia', '710 Living Water Drive', '1966-10-29'),
('bsummers4', 'Brie', 'Summers', '5105 Dragon Star Circle', '1976-02-09'),
('cjordan5', 'Clark', 'Jordan', '77 Infinite Stars Road', '1966-06-05'),
('fprefontaine6', 'Ford', 'Prefontaine', '10 Hitch Hikers Lane', '1961-01-28');

insert into customers values
('jstone5', 4, 40),
('sprince6', 5, 30),
('awilson5', 2, 100),
('lrodriguez5', 4, 60),
('bsummers4', 3, 110),
('cjordan5', 3, 50);

insert into employees values
('awilson5', '111-11-1111', 9, 46000),
('lrodriguez5', '222-22-2222', 20, 58000),
('tmccall5', '333-33-3333', 29, 33000),
('eross10', '444-44-4444', 10, 61000),
('hstark16', '555-55-5555', 20, 59000),
('echarles19', '777-77-7777', 3, 27000),
('csoares8', '888-88-8888', 26, 57000),
('agarcia7', '999-99-9999', 24, 41000),
('bsummers4', '000-00-0000', 17, 35000),
('fprefontaine6', '121-21-2121', 5, 20000);

insert into store_workers values
('eross10'),
('hstark16'),
('echarles19');

insert into stores values
('pub', 'Publix', 200, 'hstark16'),
('krg', 'Kroger', 300, 'echarles19');

insert into employed_workers values
('pub', 'eross10'),
('pub', 'hstark16'),
('krg', 'eross10'),
('krg', 'echarles19');

insert into drone_pilots values
('awilson5', '314159', 41),
('lrodriguez5', '287182', 67),
('tmccall5', '181633', 10),
('agarcia7', '610623', 38),
('bsummers4', '411911', 35),
('fprefontaine6', '657483', 2);

insert into drones values
('pub', 1, 10, 3, 'awilson5'),
('pub', 2, 20, 2, 'lrodriguez5'),
('krg', 1, 15, 4, 'tmccall5'),
('pub', 9, 45, 1, 'fprefontaine6');

insert into products values
('pr_3C6A9R', 'pot roast', 6),
('ss_2D4E6L', 'shrimp salad', 3),
('hs_5E7L23M', 'hoagie sandwich', 3),
('clc_4T9U25X', 'chocolate lava cake', 5),
('ap_9T25E36L', 'antipasto platter', 4);

insert into orders values
('pub_303', '2024-05-23', 'sprince6', 'pub', 1),
('pub_305', '2024-05-22', 'sprince6', 'pub', 2),
('krg_217', '2024-05-23', 'jstone5', 'krg', 1),
('pub_306', '2024-05-22', 'awilson5', 'pub', 2);

insert into order_lines values
('pub_303', 'pr_3C6A9R', 20, 1),
('pub_303', 'ap_9T25E36L', 4, 1),
('pub_305', 'clc_4T9U25X', 3, 2),
('pub_306', 'hs_5E7L23M', 3, 2),
('pub_306', 'ap_9T25E36L', 10, 1),
('krg_217', 'pr_3C6A9R', 15, 2);

-- -----------------------------------------------
-- stored procedures and views
-- -----------------------------------------------

-- add customer
delimiter // 
create procedure add_customer
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_rating integer, in ip_credit integer)
sp_main: begin
	
    # Check nullity
    if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null or ip_rating is null or
       ip_credit is null then
		leave sp_main;
	end if;
    
    # Check emptiness
    if ip_uname = '' or ip_first_name = '' or ip_last_name = '' or ip_address = '' or ip_rating < 1 or ip_rating > 5 or 
       ip_credit < 0 then
		leave sp_main;
	end if;

	# If user table does not have the user then insert
	if not exists (select 1 from users where uname = ip_uname) then
		
        INSERT INTO users (uname, first_name, last_name, address, birthdate)
		VALUES (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);  
    end if;
    
    
    # Ensure that the user in the table matches the credentials
    
    # When birth date is null
    if ip_birthdate is null then
		if not exists (select 1 from users where uname = ip_uname and first_name = ip_first_name and last_name = ip_last_name and
		   address = ip_address and birthdate is null) then
			
			leave sp_main;
		end if;
	# When birth date is not null
	else 
		if not exists (select 1 from users where uname = ip_uname and first_name = ip_first_name and last_name = ip_last_name and
		   address = ip_address and birthdate = ip_birthdate) then
			
			leave sp_main;
		end if;
	end if;
    
    # If customer table does not have the user then insert
	if not exists (select 1 FROM customers WHERE uname = ip_uname) then    
		
        INSERT INTO customers (uname, rating, credit)
		VALUES (ip_uname, ip_rating, ip_credit);
    END IF;
end //
delimiter ;

-- add drone pilot
delimiter // 
create procedure add_drone_pilot
	(in ip_uname varchar(40), in ip_first_name varchar(100),
	in ip_last_name varchar(100), in ip_address varchar(500),
    in ip_birthdate date, in ip_taxID varchar(40), in ip_service integer, 
    in ip_salary integer, in ip_licenseID varchar(40),
    in ip_experience integer)
sp_main: begin

	# Check nullity
	if ip_uname is null or ip_first_name is null or ip_last_name is null or ip_address is null or 
       ip_taxID is null or ip_service is null or ip_salary is null or ip_licenseID is null or ip_experience is null then
       
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_uname = '' or ip_first_name = '' or ip_last_name = '' or ip_address = '' or ip_taxID = '' or ip_licenseID = '' or 
	   ip_service < 0 or ip_salary < 0 or ip_experience < 0 then
       
		leave sp_main;
	end if;
    
    # Before proceeding with any inserts, we should make sure taxID and licenseID are unique. We should not add a drone pilot
    # if the employee already holds another role. We also should not accidentally add an employee if the license ID is not unique.
    
    if exists (select 1 from employees where taxID = ip_taxID) or
       exists (select 1 from drone_pilots where licenseID = ip_licenseID) then
		leave sp_main;
	end if;
	
    # If user table does not have user then insert
    IF not exists (select 1 FROM users WHERE uname = ip_uname) then
    
		INSERT INTO users (uname, first_name, last_name, address, birthdate)
        VALUES (ip_uname, ip_first_name, ip_last_name, ip_address, ip_birthdate);
	end if;
    
    # Ensure that the user in the table matches the credentials
    
    # When birth date is null
    if ip_birthdate is null then
		if not exists (select 1 from users where uname = ip_uname and first_name = ip_first_name and last_name = ip_last_name and
		   address = ip_address and birthdate is null) then
			
			leave sp_main;
		end if;
	# When birth dates
	else
		if not exists (select 1 from users where uname = ip_uname and first_name = ip_first_name and last_name = ip_last_name and
		   address = ip_address and birthdate = ip_birthdate) then
			
			leave sp_main;
		end if;
	end if;

	# If employee table does not have user then insert
	if not exists (select 1 FROM employees WHERE uname = ip_uname) and 
	   not exists (select 1 from employees where taxID = ip_taxID) then
       
		INSERT INTO employees (uname, taxID, service, salary)
        VALUES (ip_uname, ip_taxID, ip_service, ip_salary);
	end if;
    
    # Ensure that the employee in the table matches the credentials
    if not exists (select 1 from employees where uname = ip_uname and taxID = ip_taxID and service = ip_service and
	   salary = ip_salary) then
       
		leave sp_main;
	end if;
    
    # If drone pilot table does not have the pilot then insert
    if not exists (select 1 FROM drone_pilots WHERE uname = ip_uname) and 
	   not exists (select 1 from drone_pilots where licenseID = ip_licenseID) THEN
       
        INSERT INTO drone_pilots (uname, licenseID, experience)
        VALUES (ip_uname, ip_licenseID, ip_experience);
	END IF;

end //
delimiter ;

-- add product
delimiter // 
create procedure add_product
	(in ip_barcode varchar(40), in ip_pname varchar(100),
    in ip_weight integer)
sp_main: begin

	# Check nullity
    if ip_barcode is null or ip_pname is null or ip_weight is null then
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_barcode = '' or ip_pname = '' or ip_weight < 0 then
		leave sp_main;
	end if;

	# Insert if unique barcode
	IF not exists (select 1 FROM products WHERE barcode = ip_barcode) THEN
        INSERT INTO products (barcode, pname, weight)
        VALUES (ip_barcode, ip_pname, ip_weight);
    END IF;

end //
delimiter ;

-- add drone
delimiter // 
create procedure add_drone
	(in ip_storeID varchar(40), in ip_droneTag integer,
    in ip_capacity integer, in ip_remaining_trips integer,
    in ip_pilot varchar(40))
sp_main: begin

	# Check nullity
	if ip_storeID is null or ip_droneTag is null or ip_capacity is null or ip_remaining_trips is null or ip_pilot is null then
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_storeID = '' or ip_pilot = '' or ip_droneTag < 0 or ip_capacity < 0 or ip_remaining_trips < 0 then
		leave sp_main;
	end if;
    
    # Ensure the store exists
    if not exists (select 1 from stores where storeId = ip_storeID) then
		leave sp_main;
	end if;
    
    # Ensure the drone pilot exists
    if not exists (select 1 from drone_pilots where uname = ip_pilot) then
		leave sp_main;
	end if;

	# Insert if droneTag + storeID are unqiue and pilot is not occupied
	If not exists (select 1 FROM drones WHERE storeID = ip_storeID and droneTag = ip_droneTag) and 
       not exists (select 1 from drones where pilot = ip_pilot) then
       
        INSERT INTO drones (storeID, droneTag, capacity, remaining_trips, pilot) 
		VALUES (ip_storeID, ip_droneTag, ip_capacity, ip_remaining_trips, ip_pilot);
    END IF;

end //
delimiter ;

-- increase customer credits
delimiter // 
create procedure increase_customer_credits
	(in ip_uname varchar(40), in ip_money integer)
sp_main: begin
	
    # Check nullity
    if ip_uname is null or ip_money is null then
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_uname = '' or ip_money < 0 then
		leave sp_main;
	end if;
    
    # Ensure the customer exists
    if not exists (select 1 from customers where uname = ip_uname) then
		leave sp_main;
	end if;
    
    # Run the update statement.
    update customers set credit = credit + ip_money
	where uname = ip_uname;

end //
delimiter ;

-- swap drone control
delimiter // 
create procedure swap_drone_control
	(in ip_incoming_pilot varchar(40), in ip_outgoing_pilot varchar(40))
sp_main: begin

	# Check null values
    if ip_incoming_pilot is null or ip_outgoing_pilot is null then
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_incoming_pilot = '' or ip_outgoing_pilot = '' then
		leave sp_main;
	end if;
	
    # Update only if the incoming pilot exists, is unoccupied and the outgoing pilot is assigned to drone
    if exists (select 1 FROM drone_pilots WHERE uname = ip_incoming_pilot) and 
       not exists (select 1 FROM drones WHERE pilot = ip_incoming_pilot) and 
       exists (select 1 FROM drones WHERE pilot = ip_outgoing_pilot) then
       
        UPDATE drones SET pilot = ip_incoming_pilot where pilot = ip_outgoing_pilot;
	end if;
    
end //
delimiter ;

-- repair and refuel a drone
delimiter // 
create procedure repair_refuel_drone
	(in ip_drone_store varchar(40), in ip_drone_tag integer,
    in ip_refueled_trips integer)
sp_main: begin

	# Check nullity
    if ip_drone_store is null or ip_drone_tag is null or ip_refueled_trips is null then
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_drone_store = '' or ip_drone_tag < 0 or ip_refueled_trips < 0 then
		leave sp_main;
	end if;
    
    # Ensure the drone exists
    if not exists (select 1 from drones where storeID = ip_drone_store and droneTag = ip_drone_tag) then
		leave sp_main;
	end if;

	# Run the update statement.
	UPDATE drones SET remaining_trips = remaining_trips + ip_refueled_trips
	WHERE storeID = ip_drone_store AND droneTag = ip_drone_tag;

end //
delimiter ;

-- begin order
delimiter // 
create procedure begin_order
	(in ip_orderID varchar(40), in ip_sold_on date,
    in ip_purchased_by varchar(40), in ip_carrier_store varchar(40),
    in ip_carrier_tag integer, in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	
    # Check nullity
    if ip_orderID is null or ip_sold_on is null or ip_purchased_by is null or ip_carrier_store is null or ip_carrier_tag is null or
       ip_barcode is null or ip_price is null or ip_quantity is null then
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_orderID = '' or ip_purchased_by = '' or ip_carrier_store = '' or ip_carrier_tag < 0 or ip_barcode = '' or
       ip_price < 0 or ip_quantity <= 0 then
		leave sp_main;
	end if;
    
    # Check validity of different contributors (foreign keys)
    if not exists (select 1 from customers where uname = ip_purchased_by) or
	   not exists (select 1 from products where barcode = ip_barcode) or
       not exists (select 1 from drones where storeID = ip_carrier_store and droneTag = ip_carrier_tag) then
		leave sp_main;
	end if;
        
    # Check if the customer has sufficient credit
    if (select current_credit from customer_credit_check where customer_name = ip_purchased_by) < 
	   ((select credit_already_allocated from customer_credit_check where customer_name = ip_purchased_by) + 
       (ip_price * ip_quantity)) then
		
        leave sp_main;
	end if;
    
    # Check drone capacity
    if (select total_weight_allowed from drone_traffic_control where drone_serves_store = ip_carrier_store and drone_tag = ip_carrier_tag) < 
	   ((select current_weight from drone_traffic_control where drone_serves_store = ip_carrier_store and drone_tag = ip_carrier_tag) + 
       ((select  weight from products where barcode = ip_barcode) * ip_quantity)) then
		
        leave sp_main;
	end if;
    
    # If the order exists, we can't "begin" it
    if exists (select 1 from orders where orderID = ip_orderID) then
		leave sp_main;
	end if;
    
    # Add into orders table
	insert into orders
	values (ip_orderID, ip_sold_on, ip_purchased_by, ip_carrier_store, ip_carrier_tag);
    
    # Add into order_lines table
	insert into order_lines
	values (ip_orderID, ip_barcode, ip_price, ip_quantity);

end //
delimiter ;

-- add order line
delimiter // 
create procedure add_order_line
	(in ip_orderID varchar(40), in ip_barcode varchar(40),
    in ip_price integer, in ip_quantity integer)
sp_main: begin
	declare cust_uname varchar(40);
    declare order_storeID varchar(40);
    declare order_droneTag varchar(40);
	
    # Check nullity
    if ip_orderID is null or ip_barcode is null or ip_price is null or ip_quantity is null then
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_orderID = '' or ip_barcode = '' or ip_price < 0 or ip_quantity <= 0 then
		leave sp_main;
	end if;
    
    # Ensure order and product exist (foreign keys)
    if not exists (select 1 from orders where orderID = ip_orderID) or
       not exists (select 1 from products where barcode = ip_barcode) then
		leave sp_main;
	end if;
        
    select purchased_by into cust_uname from orders where orderID = ip_orderID; # Get the username
    
    select carrier_store into order_storeID from orders where orderID = ip_orderID; # Get the store id
    select carrier_tag into order_droneTag from orders where orderID = ip_orderID; # Get the drone tag
    
    # Check for any anomalies
    if not exists (select 1 from customers where uname = cust_uname) or
	   not exists (select 1 from drones where storeID = order_storeID and droneTag = order_droneTag) then
		leave sp_main;
	end if;
    
    # Check if the customer has sufficient credit
    if (select current_credit from customer_credit_check where customer_name = cust_uname) < 
	   ((select credit_already_allocated from customer_credit_check where customer_name = cust_uname) + 
       (ip_price * ip_quantity)) then
		
        leave sp_main;
	end if;
    
    # Check drone capacity
    if (select total_weight_allowed from drone_traffic_control where drone_serves_store = order_storeID and drone_tag = order_droneTag) < 
	   ((select current_weight from drone_traffic_control where drone_serves_store = order_storeID and drone_tag = order_droneTag) + 
       ((select  weight from products where barcode = ip_barcode) * ip_quantity)) then
		
        leave sp_main;
	end if;
    
    # Add into order_lines table if the product isn't already included
    if not exists (select 1 from order_lines where orderID = ip_orderID and barcode = ip_barcode) then
		insert into order_lines
        values (ip_orderID, ip_barcode, ip_price, ip_quantity);
        
	end if;
end //
delimiter ;

-- deliver order
delimiter // 
create procedure deliver_order
	(in ip_orderID varchar(40))
sp_main: begin
	declare cust_uname varchar(40);
    declare order_storeID varchar(40);
    declare order_droneTag varchar(40);
    declare drone_pilot varchar(40);
	
    # Check nullity
    if ip_orderID is null then
		leave sp_main;
	end if;
    
    # Check invalid values
    if ip_orderID = '' then
		leave sp_main;
	end if;
    
    # Ensure there are orders to be delivered
    if not exists (select 1 from orders where orderID = ip_orderID) or
       not exists (select 1 from order_lines where orderID = ip_orderID) then
		leave sp_main;
	end if;
    
    select purchased_by into cust_uname from orders where orderID = ip_orderID; # Get the username
    
    select carrier_store into order_storeID from orders where orderID = ip_orderID; # Get the store id
    select carrier_tag into order_droneTag from orders where orderID = ip_orderID; # Get the drone tag
    
    select pilot into drone_pilot from drones where storeID = order_storeID and droneTag = order_droneTag; # Get the pilot
    
    # Check for any anomalies (all parties present)
    if not exists (select 1 from customers where uname = cust_uname) or
	   not exists (select 1 from drones where storeID = order_storeID and droneTag = order_droneTag) or
       not exists (select 1 from drone_pilots where uname = drone_pilot) then
		leave sp_main;
	end if;
    
    # Ensure the drone is capable of making the trip
    if (select deliveries_allowed from drone_traffic_control 
		where drone_serves_store = order_storeID and drone_tag = order_droneTag) <= 0 then
		
        leave sp_main;
	end if;
    
    # Update the customer credit accordingly
    update customers set credit = credit - (select cost from orders_in_progress where orderID = ip_orderID) 
    where uname = cust_uname;
    
    # Update the store's revenue
    update stores set revenue = revenue + (select cost from orders_in_progress where orderID = ip_orderID) 
    where storeID = order_storeID;
    
    # Update the drone's remaining trips
    update drones set remaining_trips = remaining_trips - 1 
    where storeID = order_storeID and droneTag = order_droneTag;
    
    # Update the pilot's experience
    update drone_pilots set experience = experience + 1 
    where uname = drone_pilot;
    
    # Update the rating if applicable
    if (select cost from orders_in_progress where orderID = ip_orderID) > 25 and 
	   (select rating from customer_credit_check where customer_name = cust_uname) < 5 then
		
        update customers set rating = rating + 1 where uname = cust_uname;
	end if;
        
	# Delete all instances of order
    delete from order_lines where orderID = ip_orderID;
    delete from orders where orderID = ip_orderID;
    
end //
delimiter ;

-- cancel an order
delimiter // 
create procedure cancel_order
	(in ip_orderID varchar(40))
sp_main: begin
	declare cust_uname varchar(40);

	# Check nullity
	if ip_orderID is null then
		leave sp_main;
	end if;
    
    # Check for invalid values
    if ip_orderID = '' then
		leave sp_main;
	end if;
    
    # Check if we have an order to delete
    if not exists (select 1 from orders where orderID = ip_orderID) and
	   not exists (select 1 from order_lines where orderID = ip_orderID) then
		leave sp_main;
	end if;
    
    select purchased_by into cust_uname from orders where orderID = ip_orderID; # Get the username
    
    # Ensure the customer exists
    if not exists (select 1 from customers where uname = cust_uname) then
		leave sp_main;
	end if;
    
    # Update rating
    if (select rating from customer_credit_check where customer_name = cust_uname) > 1 then
		update customers set rating = rating - 1 where uname = cust_uname;
	end if;
    
    # Delete all instances of order
    delete from order_lines where orderID = ip_orderID;
    delete from orders where orderID = ip_orderID;

end //
delimiter ;

-- display persons distribution across roles
create or replace view role_distribution (category, total) as

select 'users', count(*) from users
union
select 'customers', count(*) from customers
union
select 'employees', count(*) from employees
union
select 'customer_employer_overlap', count(*) from customers inner join employees on customers.uname=employees.uname
union
select 'drone_pilots', count(*) from drone_pilots
union
select 'store_workers', count(*) from store_workers
union
select 'other_employee_roles', count(*) from employees WHERE uname NOT IN (SELECT uname FROM drone_pilots UNION SELECT uname FROM store_workers);


-- display customer status and current credit and spending activity
create or replace view customer_credit_check (customer_name, rating, current_credit,
	credit_already_allocated) as

select uname, rating, credit, coalesce(sum(price*quantity), 0) 
from ( 
	customers left join orders 
	on uname = purchased_by 
) left join order_lines 
on orders.orderID = order_lines.orderID 
group by uname;

-- display drone status and current activity
create or replace view drone_traffic_control (drone_serves_store, drone_tag, pilot,
	total_weight_allowed, current_weight, deliveries_allowed, deliveries_in_progress) as
select storeID, droneTag, pilot, capacity, coalesce(sum(quantity*weight), 0), remaining_trips, count(distinct orders.orderID) 
from (
	(
		drones left join orders 
		on storeID=carrier_store and droneTag=carrier_tag 
	) left join order_lines on orders.orderID=order_lines.orderID 
) left join products on order_lines.barcode=products.barcode 
group by storeID, droneTag;


-- display product status and current activity including most popular products
create or replace view most_popular_products (barcode, product_name, weight, lowest_price,
	highest_price, lowest_quantity, highest_quantity, total_quantity) as

select products.barcode, pname, weight, min(price), max(price), coalesce(min(quantity), 0), coalesce(max(quantity), 0), coalesce(sum(quantity),0) 
from products left join order_lines 
on products.barcode = order_lines.barcode 
group by products.barcode;


-- display drone pilot status and current activity including experience
create or replace view drone_pilot_roster (pilot, licenseID, drone_serves_store,
	drone_tag, successful_deliveries, pending_deliveries) as

select uname, licenseID, storeID, droneTag, experience, count(distinct orderID)
from (
	drone_pilots left join drones 
	on uname=pilot
) left join orders on storeID=carrier_store and droneTag=carrier_tag
group by uname, storeID, droneTag;

-- display store revenue and activity
create or replace view store_sales_overview (store_id, sname, manager, revenue,
	incoming_revenue, incoming_orders) as

select storeID, sname, manager, revenue, coalesce(sum(price * quantity), 0), count(distinct orders.orderID)
from (
	stores left join orders
    on storeID = carrier_store
) left join order_lines on orders.orderID = order_lines.orderID
group by storeID;

-- display the current orders that are being placed/in progress
create or replace view orders_in_progress (orderID, cost, num_products, payload,
	contents) as

select orders.orderID, coalesce(sum(price * quantity), 0), coalesce(count(distinct order_lines.barcode), 0), coalesce(sum(weight * quantity), 0), coalesce(group_concat(pname), 0)
from (
	orders left join order_lines
    on orders.orderID = order_lines.orderID
) inner join products on order_lines.barcode = products.barcode
group by orderID;

-- remove customer
delimiter // 
create procedure remove_customer
	(in ip_uname varchar(40))
sp_main: begin

    # Check nullity
	if ip_uname is null then
		leave sp_main;
	end if;

	# Check invalid values
	if ip_uname = '' then
		leave sp_main;
	end if;

	# Ensure the customer exists
	if not exists (select 1 from customers where uname = ip_uname) then
		leave sp_main;
	end if;

	# Ensure the customer has no pending orders
	if exists (select 1 from orders where purchased_by = ip_uname) then
		leave sp_main;
	end if;

	# Delete from customers table
	delete from customers where uname = ip_uname;

	# Delete from users table if they are not an employee
	if not exists (select 1 from employees where uname = ip_uname) then
		delete from users where uname = ip_uname;
	end if;

end //
delimiter ;

-- remove drone pilot
delimiter // 
create procedure remove_drone_pilot
	(in ip_uname varchar(40))
sp_main: begin
	
    # Check nullity 
	if ip_uname is null then
		leave sp_main;
	end if;

	# Check invalid values
	if ip_uname = '' then
		leave sp_main;
	end if;

	# Ensure the drone pilot exists
	if not exists (select 1 from drone_pilots where uname = ip_uname) then
		leave sp_main;
	end if;

	# Ensure the drone pilot is not controlling any drones
	if exists (select 1 from drones where pilot = ip_uname) then
		leave sp_main;
	end if;

	# Delete from drone_pilots table
	delete from drone_pilots where uname = ip_uname;

	# Delete from employees table if they have no other roles (they shouldnt given description)
	if not exists (select 1 from store_workers where uname = ip_uname) then 
		delete from employees where uname = ip_uname;
	else
		leave sp_main;
	end if;

	# Delete from users table if they are not a customer and the above delete went through
	if not exists (select 1 from customers where uname = ip_uname) then
		delete from users where uname = ip_uname;
	end if;

end //
delimiter ;

-- remove product
delimiter // 
create procedure remove_product
	(in ip_barcode varchar(40))
sp_main: begin
	
    # Check nullity
	if ip_barcode is null then
		leave sp_main;
	end if;

	# Check invalid values
	if ip_barcode = '' then
		leave sp_main;
	end if;
    
	# Ensure the product exists
	if not exists (select 1 from products where barcode = ip_barcode) then
		leave sp_main;
	end if;

	# Ensure the product is not part of any pending orders
	if exists (select 1 from order_lines where barcode = ip_barcode) then
		leave sp_main;
	end if;

	# Delete the product
	delete from products where barcode = ip_barcode;

end //
delimiter ;

-- remove drone
delimiter // 
create procedure remove_drone
	(in ip_storeID varchar(40), in ip_droneTag integer)
sp_main: begin
	
    # Check nullity
	if ip_storeID is null or ip_droneTag is null then
		leave sp_main;
	end if;

	# Check invalid values
	if ip_storeID = '' or ip_droneTag < 0 then
		leave sp_main;
	end if;
    
    # Ensure the drone exists
	if not exists (select 1 from drones where storeID = ip_storeID and droneTag = ip_droneTag) then
		leave sp_main;
	end if;

	# Ensure the drone is not assigned to any pending orders
	if exists (select 1 from orders where carrier_store = ip_storeID and carrier_tag = ip_droneTag) then
		leave sp_main;
	end if;

	# Delete the drone
	delete from drones where storeID = ip_storeID and droneTag = ip_droneTag;

end //
delimiter ;
