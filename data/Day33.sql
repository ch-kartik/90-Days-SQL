-- Day 33

CREATE TABLE customers_d33 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d33 VALUES
(1, '2023-01-01'),
(2, '2023-01-10'),
(3, '2023-02-01'),
(4, '2023-02-15'),
(5, '2023-03-01');

CREATE TABLE orders_d33 (
    order_id INT,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d33(cust_id)
);

INSERT INTO orders_d33 VALUES
(101, 1, '2023-01-05', 300),
(102, 1, '2023-02-05', 400),
(103, 1, '2023-03-01', 500),
(104, 2, '2023-01-12', 200),
(105, 2, '2023-01-20', 250),
(106, 3, '2023-02-10', 150),
(107, 3, '2023-02-18', 180),
(108, 4, '2023-02-20', 600),
(109, 5, '2023-03-05', 120),
(110, 5, '2023-03-15', 140);