-- Day 24

CREATE TABLE customers_d24 (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    signup_date DATE
);

INSERT INTO customers_d24 VALUES
(1, 'Alice', '2023-01-05'),
(2, 'Bob', '2023-01-10'),
(3, 'Charlie', '2023-02-01'),
(4, 'David', '2023-02-10'),
(5, 'Eva', '2023-03-01');

CREATE TABLE orders_d24 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d24(cust_id)
);

INSERT INTO orders_d24 VALUES
(101, 1, '2023-01-10', 500),
(102, 1, '2023-02-15', 700),
(103, 2, '2023-01-20', 300),
(104, 2, '2023-01-25', 200),
(105, 3, '2023-02-05', 1000),
(106, 4, '2023-02-20', 400),
(107, 4, '2023-03-15', 600),
(108, 5, '2023-03-10', 800);