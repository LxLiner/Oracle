drop table Purchase cascade constraints;
drop table Sale cascade constraints;
drop table Customer cascade constraints;
drop table Customer_type cascade constraints;
drop table Production cascade constraints;
drop table Employee cascade constraints;
drop table Position cascade constraints;
drop table Boss cascade constraints;
drop table Department cascade constraints;

create table Department (
	dep_id NUMERIC(5) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	location VARCHAR(20) NOT NULL,
	cash NUMERIC(10,2)
);

create table Boss (
	boss_id NUMERIC(5) PRIMARY KEY,
	emp_id NUMERIC(5) NOT NULL
);

create table Position (
	position_id NUMERIC(5) PRIMARY KEY,
	name VARCHAR(20) NOT NULL
);

create table Employee (
	emp_id NUMERIC(5) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	position_id NUMERIC(5) NOT NULL,
	hire_date DATE NOT NULL,
	salary NUMERIC(10,2) NOT NULL,
	dep_id NUMERIC(5) NOT NULL,
	boss_id NUMERIC(5) NOT NULL,
	CONSTRAINT fk_dep_id
		FOREIGN KEY (dep_id) 
		REFERENCES Department(dep_id),
	CONSTRAINT fk_boss_id
		FOREIGN KEY (boss_id) 
		REFERENCES Boss(boss_id),
	CONSTRAINT fk_position_id
		FOREIGN KEY (position_id) 
		REFERENCES Position(position_id)
);

create table Production (
	production_id NUMERIC(5) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	sale_price NUMERIC(10,2) NOT NULL,
	purchase_price NUMERIC(10,2) NOT NULL
);

create table Customer_type (
	c_type_id NUMERIC(5) PRIMARY KEY,
	name VARCHAR(20) NOT NULL
);

create table Customer (
	customer_id NUMERIC(5) PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	phone VARCHAR(20) NOT NULL,
	adress VARCHAR(20) NOT NULL,
	type NUMERIC(5) NOT NULL,
	CONSTRAINT fk_type
		FOREIGN KEY (type) 
		REFERENCES Customer_type(c_type_id)
);

create table Sale (
	sale_id NUMERIC(5) PRIMARY KEY,
	production_id NUMERIC(5) NOT NULL,
	dep_id NUMERIC(5) NOT NULL,
	customer_id NUMERIC(5) NOT NULL,
	quantity NUMERIC(10) NOT NULL,
	CONSTRAINT fk_production_id
		FOREIGN KEY (production_id) 
		REFERENCES Production(production_id),
	CONSTRAINT fk_dep_id_2
		FOREIGN KEY (dep_id) 
		REFERENCES Department(dep_id),
	CONSTRAINT fk_customer_id
		FOREIGN KEY (customer_id) 
		REFERENCES Customer(customer_id)
);

create table Purchase (
	purchase_id NUMERIC(5) PRIMARY KEY,
	production_id NUMERIC(5) NOT NULL,
	customer_id NUMERIC(5) NOT NULL,
	dep_id NUMERIC(5) NOT NULL,
	quantity NUMERIC(10) NOT NULL,
	CONSTRAINT fk_production_id_2
		FOREIGN KEY (production_id) 
		REFERENCES Production(production_id),
	CONSTRAINT fk_customer_id_2
		FOREIGN KEY (customer_id) 
		REFERENCES Customer(customer_id),
	CONSTRAINT fk_dep_id_3
		FOREIGN KEY (dep_id) 
		REFERENCES Department(dep_id)
);