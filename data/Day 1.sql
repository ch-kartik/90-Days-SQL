CREATE TABLE customers (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    region VARCHAR(20)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    cust_id INT,
    product_id INT,
    amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1,'Arun','North'),
(2,'Megha','South'),
(3,'Ravi','West'),
(4,'Zara','East'),
(5,'Pooja','South');

INSERT INTO products VALUES
(101,'iPhone','Electronics',70000),
(102,'Laptop','Electronics',55000),
(103,'Shoes','Fashion',3000),
(104,'Watch','Fashion',6000),
(105,'Mixer','Home',4000);

INSERT INTO orders VALUES
(1001,1,101,70000,'2024-11-12','Delivered'),
(1002,2,103,3000,'2024-11-15','Pending'),
(1003,3,105,4000,'2024-11-20','Cancelled'),
(1004,1,104,6000,'2024-11-22','Delivered'),
(1005,5,102,55000,'2024-12-01','Delivered'),
(1006,4,103,3000,'2024-12-02','Pending'),
(1007,3,101,70000,'2024-12-03','Delivered'),
(1008,2,105,4000,'2024-12-05','Delivered');



SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM products;
