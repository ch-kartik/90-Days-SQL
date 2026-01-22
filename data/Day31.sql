-- Day 31

CREATE TABLE customers_d31 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d31 (cust_id, signup_date) VALUES
(1, '2023-01-01'),
(2, '2023-01-05'),
(3, '2023-02-01'),
(4, '2023-02-15'),
(5, '2023-03-01');

CREATE TABLE orders_d31 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d31(cust_id)
);

INSERT INTO orders_d31 (order_id, cust_id, order_date, order_amount) VALUES
(101, 1, '2023-01-10', 300),
(102, 1, '2023-02-05', 400),
(103, 1, '2023-03-01', 500),
(104, 2, '2023-01-20', 200),
(105, 3, '2023-02-10', 250),
(106, 3, '2023-03-05', 300),
(107, 4, '2023-02-20', 150),
(108, 5, '2023-03-10', 100);