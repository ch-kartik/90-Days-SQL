-- Day 22

CREATE TABLE customers_d22 (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    country VARCHAR(30)
);

INSERT INTO customers_d22 VALUES
(1, 'Emily', 'USA'),
(2, 'Daniel', 'Germany'),
(3, 'Sophia', 'UK'),
(4, 'Liam', 'India'),
(5, 'Olivia', 'USA');

CREATE TABLE products_d22 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    cost_price DECIMAL(10,2)
);

INSERT INTO products_d22 VALUES
(101, 'Basic Plan', 40),
(102, 'Pro Plan', 70),
(103, 'Enterprise Plan', 120);

CREATE TABLE orders_d22 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    product_id INT,
    order_date DATE,
    selling_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    FOREIGN KEY (cust_id) REFERENCES customers_d22(cust_id),
    FOREIGN KEY (product_id) REFERENCES products_d22(product_id)
);

INSERT INTO orders_d22 VALUES
(1, 1, 102, '2025-01-05', 100, 10),
(2, 1, 103, '2025-02-10', 160, 20),
(3, 2, 101, '2025-01-12', 60, 0),
(4, 3, 102, '2025-02-14', 95, 15),
(5, 4, 101, '2025-02-20', 55, 5),
(6, 5, 103, '2025-03-01', 170, 30);