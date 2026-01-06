-- Day 15

CREATE TABLE customers_d15 (
  cust_id INT PRIMARY KEY,
  signup_date DATE,
  channel VARCHAR(20)
);

INSERT INTO customers_d15 VALUES
(1, '2024-01-05', 'Organic'),
(2, '2024-01-10', 'Paid'),
(3, '2024-02-02', 'Organic'),
(4, '2024-02-15', 'Referral'),
(5, '2024-03-01', 'Paid'),
(6, '2024-03-10', 'Organic');

CREATE TABLE orders_d15 (
  order_id INT PRIMARY KEY,
  cust_id INT,
  order_date DATE,
  order_amount INT,
  status VARCHAR(15),
  FOREIGN KEY (cust_id) REFERENCES customers_d15(cust_id)
);

INSERT INTO orders_d15 VALUES
(201, 1, '2024-01-20', 1200, 'completed'),
(202, 1, '2024-02-18', 1500, 'completed'),
(203, 2, '2024-01-25', 2000, 'completed'),
(204, 2, '2024-02-05', 1800, 'cancelled'),
(205, 3, '2024-02-20', 2200, 'completed'),
(206, 3, '2024-03-18', 2100, 'completed'),
(207, 4, '2024-02-28', 3000, 'completed'),
(208, 5, '2024-03-15', 2500, 'completed');