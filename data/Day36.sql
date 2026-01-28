-- Day 36

CREATE TABLE customers_d36 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d36 VALUES
(1, '2023-01-05'),
(2, '2023-01-18'),
(3, '2023-02-02'),
(4, '2023-02-15'),
(5, '2023-03-01');

CREATE TABLE orders_d36 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d36(cust_id)
);

INSERT INTO orders_d36 VALUES
(101, 1, '2023-01-10', 200),
(102, 1, '2023-02-12', 300),
(103, 1, '2023-03-15', 500),
(104, 2, '2023-01-25', 400),
(105, 2, '2023-02-20', 200),
(106, 3, '2023-02-10', 300),
(107, 3, '2023-03-18', 300),
(108, 4, '2023-02-25', 600),
(109, 5, '2023-03-05', 150),
(110, 5, '2023-04-02', 100);