-- Day 45

CREATE TABLE payments_d45 (
    payment_id INT PRIMARY KEY,
    cust_id INT,
    payment_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO payments_d45 VALUES
-- Customer 1: Declining
(1, 1, '2024-01-10', 500),
(2, 1, '2024-02-10', 400),
(3, 1, '2024-03-10', 300),
-- Customer 2: Churned
(4, 2, '2024-01-15', 700),
(5, 2, '2024-02-15', 700),
-- Customer 3: Healthy (Growing)
(6, 3, '2024-02-05', 200),
(7, 3, '2024-03-05', 400),
-- Customer 4: Single month customer
(8, 4, '2024-03-20', 600);