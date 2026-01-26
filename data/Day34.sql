-- Day 34

CREATE TABLE customers_d34 (
    cust_id INT PRIMARY KEY,
    signup_date DATE
);

INSERT INTO customers_d34 (cust_id, signup_date) VALUES
(1, '2023-01-05'),
(2, '2023-01-15'),
(3, '2023-02-01'),
(4, '2023-02-10'),
(5, '2023-03-01');

CREATE TABLE orders_d34 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d34(cust_id)
);

INSERT INTO orders_d34 (order_id, cust_id, order_date, order_amount) VALUES
-- Customer 1 (high value, slowing)
(101, 1, '2023-01-10', 400),
(102, 1, '2023-02-10', 350),
(103, 1, '2023-03-05', 300),
-- Customer 2 (at risk)
(104, 2, '2023-01-20', 250),
(105, 2, '2023-02-15', 200),
-- Customer 3 (churned)
(106, 3, '2023-02-05', 150),
-- Customer 4 (recent & healthy)
(107, 4, '2023-02-20', 180),
(108, 4, '2023-03-25', 220),
-- Customer 5 (new, early stage)
(109, 5, '2023-03-10', 120);