-- Day 32

CREATE TABLE customers_d32 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d32 VALUES
(1, '2023-01-05'),
(2, '2023-01-12'),
(3, '2023-02-01'),
(4, '2023-02-10'),
(5, '2023-02-18');

CREATE TABLE orders_d32 (
    order_id INT,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d32(cust_id)
);

INSERT INTO orders_d32 VALUES
(101, 1, '2023-01-10', 300),
(102, 1, '2023-02-05', 400),
(103, 1, '2023-03-01', 500),
(104, 2, '2023-01-20', 200),
(105, 3, '2023-02-10', 250),
(106, 3, '2023-02-25', 300),
(107, 4, '2023-02-15', 150),
(108, 5, '2023-02-20', 600),
(109, 5, '2023-03-10', 700);