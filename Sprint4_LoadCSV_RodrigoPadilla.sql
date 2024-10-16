-- ------------------------------------
-- SPRINT 4 
-- CARGA DE DATOS CSV EN TABLAS
-- ALUMNO RODRIGO PADILLA
-- REVISADO POR JOSEPH TAPIA
-- -------------------------------------

-- Carga de archivos CSV SPRINT 4

-- 1 LOAD DATA TABLE COMPANIES
-- 2 LOAD DATA TABLE CREDIT_CARDS
-- 3 LOAD DATA TABLE PRODUCTS
-- 4 LOAD DATA TABLE USERS
-- 5 LOAD DATA TABLE TRANSACTIONS

-- Primero reviso la carpeta de seguridad para dejar ahi los CSV y no tener problemas de privilegios
SHOW VARIABLES LIKE 'secure_file_priv';

-- 1 LOAD DATA TABLE COMPANIES
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 2 LOAD DATA TABLE CREDIT_CARDS
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 3 LOAD DATA PRODUCTS
-- aca se agrega una modificación previa a la carga para reemplazar el $ y respetar el tipo de datos FLOAT
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_name, @price, colour, weight, warehouse_id)
set price = REPLACE(@precio, '$', '') * 1.0;

-- 4 LOAD DATA USERS
-- El LOAD  de users contempla un UPDATE posterior a cada carga segun su "owner" CA, UK, USA

-- a) CA
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(user_id, first_name, last_name, phone, email, birth_date, country, city, postal_code, address);

-- b) USA
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(user_id, first_name, last_name, phone, email, birth_date, country, city, postal_code, address);


-- c) UK
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(user_id, first_name, last_name, phone, email, birth_date, country, city, postal_code, address);


-- 5 LOAD DATA TRANSACTIONS
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(transac_id, card_id, business_id, timestamp_aud, amount, declined, product_ids, user_id, lat, longitude);

-- ------------------

