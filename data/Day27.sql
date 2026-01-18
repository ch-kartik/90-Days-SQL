-- Day 27

CREATE TABLE customers_d27 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d27 VALUES
(1, '2023-01-05'),
(2, '2023-01-12'),
(3, '2023-02-03'),
(4, '2023-02-20'),
(5, '2023-03-01');

CREATE TABLE orders_d27 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d27(cust_id)
);

INSERT INTO orders_d27 VALUES
(101, 1, '2023-01-10', 500),
(102, 1, '2023-02-15', 600),
(103, 2, '2023-01-20', 400),
(104, 3, '2023-02-10', 700),
(105, 3, '2023-03-05', 800),
(106, 4, '2023-02-25', 300),
(107, 5, '2023-03-10', 900);