CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Category
INSERT INTO category(categoryName) VALUES ('Boots Socks');
INSERT INTO category(categoryName) VALUES ('Crew Socks');
INSERT INTO category(categoryName) VALUES ('Ankle Socks');
INSERT INTO category(categoryName) VALUES ('Low Cut Socks');
INSERT INTO category(categoryName) VALUES ('No Show Socks');

-- Products for Boots Socks
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Wool Blend Boot Socks (Pack of 2)', 1, 'Warm wool blend boot socks, pack of 2 pairs', 19.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Thermal Hiking Socks', 1, 'Thermal hiking socks with moisture-wicking, single pair', 12.50);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('High Performance Ski Socks', 1, 'High-performance ski socks for cold weather, single pair', 24.99);

-- Products for Crew Socks
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Cotton Crew Socks (Pack of 6)', 2, 'Soft cotton crew socks, pack of 6 pairs', 24.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Flamingo Crew Socks', 2, 'Stylish crew socks with flamingo design', 16.50);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Colorful Striped Crew Socks (Pack of 3)', 2, 'Stylish colorful striped crew socks, pack of 3 pairs', 19.99);

-- Products for Ankle Socks
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Cushioned Ankle Socks (Pack of 5)', 3, 'Cushioned ankle socks for everyday wear, pack of 5 pairs', 18.50);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Breathable Mesh Ankle Socks (Pack of 3)', 3, 'Breathable mesh ankle socks, pack of 3 pairs', 14.99);

-- Products for Low Cut Socks
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Sporty Low Cut Socks (Pack of 6)', 4, 'Sporty low cut socks, pack of 6 pairs', 22.50);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Cotton Low Cut Socks (Pack of 8)', 4, 'Soft cotton low cut socks, pack of 8 pairs', 28.99);

-- Products for No Show Socks
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Silicone Grip No Show Socks (Pack of 4)', 5, 'No show socks with silicone grip, pack of 4 pairs', 15.99);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Lace Liner No Show Socks (Pack of 3)', 5, 'Lace liner no show socks, pack of 3 pairs', 12.99);

INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');

-- Product Inventory for Boots Socks
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 50, 19.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 40, 12.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 30, 24.99);

-- Product Inventory for Crew Socks
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 60, 24.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 45, 16.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 35, 19.99);

-- Product Inventory for Ankle Socks
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 70, 18.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 50, 14.99);

-- Product Inventory for Low Cut Socks
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 80, 22.50);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 65, 28.99);

-- Product Inventory for No Show Socks
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (11, 1, 90, 15.99);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (12, 1, 75, 12.99);

-- Customers
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');

-- Order 1: Sufficient inventory for all items
DECLARE @orderId1 int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId1 = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId1, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId1, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId1, 10, 1, 31);

-- Order 2: Sufficient inventory for item 5
DECLARE @orderId2 int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId2 = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId2, 5, 5, 21.35);

-- Order 3: Insufficient inventory for item 7
DECLARE @orderId3 int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId3 = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId3, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId3, 7, 3, 30);

-- Order 4: Sufficient inventory for all items
DECLARE @orderId4 int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId4 = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId4, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId4, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId4, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId4, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId4, 29, 4, 14);

-- Order 5: Sufficient inventory for all items
DECLARE @orderId5 int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId5 = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId5, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId5, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId5, 20, 3, 10);

-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'img/1.jpg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/2.jpg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/3.jpg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/4.jpg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/5.jpg' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'img/6.jpg' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'img/7.jpg' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'img/8.jpg' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'img/9.jpg' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'img/10.jpg' WHERE ProductId = 10;
UPDATE Product SET productImageURL = 'img/11.jpg' WHERE ProductId = 11;
UPDATE Product SET productImageURL = 'img/12.jpg' WHERE ProductId = 12;

-- Loads image data for product 1