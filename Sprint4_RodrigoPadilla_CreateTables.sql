-- CREATE TABLES DATABASE SALES

USE SALES;

DROP TABLE TRANSACTIONS;
DROP TABLE COMPANIES;
DROP TABLE PRODUCTS;
DROP TABLE USERS;
DROP TABLE CREDIT_CARDS;
DROP TABLE TMP_DET_PRODUCTS;

CREATE TABLE companies(
    company_id		VARCHAR(6) PRIMARY KEY,
    company_name	VARCHAR(255) NOT NULL,
    phone		VARCHAR(30),
    email		VARCHAR(50),
    country		VARCHAR(50),
    website		VARCHAR(50)
);

CREATE TABLE credit_cards(
    card_id 	VARCHAR(8) PRIMARY KEY,
    user_id	INT NOT NULL,
    iban	VARCHAR(50) NOT NULL,
    pan		VARCHAR(50) NOT NULL,
    pin		VARCHAR(4) NOT NULL,
    cvv		VARCHAR(4) NOT NULL,
    track1	VARCHAR(255),
    track2	VARCHAR(255),
    expiring_date	VARCHAR(15) 
);

CREATE table products
(
product_id INT PRIMARY KEY,
product_name VARCHAR(255),
price FLOAT, 
colour VARCHAR(7),
weight FLOAT,
warehouse_id VARCHAR(10)
);

CREATE TABLE users (
    user_id	INT PRIMARY KEY,
    first_name	VARCHAR(255),
    last_name	VARCHAR(255),
    phone	VARCHAR(30),
    email	VARCHAR(50),
    birth_date	VARCHAR(30), 
    country	VARCHAR(50),
    city	VARCHAR(50),
    postal_code	VARCHAR(30),
    address	VARCHAR(255)
);

CREATE TABLE transactions
(
    transac_id	VARCHAR(50) PRIMARY KEY,
    card_id	VARCHAR(8) NOT NULL,
    business_id	VARCHAR(6) NOT NULL,
    timestamp_aud	VARCHAR(30),
    amount	DOUBLE, -- aca cambiaste a FLOAT el dato OJO
    declined	TINYINT(1),
    product_ids	VARCHAR(512),
    user_id	INT,
    lat	DOUBLE,
    longitude DOUBLE,
	FOREIGN KEY (card_id) REFERENCES credit_cards(card_id),
	FOREIGN KEY (business_id) REFERENCES companies(company_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE card_states
	(
		card_id VARCHAR(8) PRIMARY KEY,
		card_status VARCHAR(20) default 'ACTIVA'
	);

CREATE TABLE tmp_det_products
	(	id_product VARCHAR(100),
		id_transac VARCHAR(100),
		timestamp_created VARCHAR(50)
	);

SHOW FULL TABLES FROM SALES;
