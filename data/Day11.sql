CREATE TABLE orders_d11 (
    order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    status VARCHAR(20)
);

INSERT INTO orders_d11 VALUES
(201, 1, '2025-01-05', 3000, 'completed'),
(202, 1, '2025-02-10', 4000, 'completed'),
(203, 2, '2025-01-15', 1500, 'completed'),
(204, 3, '2025-01-20', 5000, 'completed'),
(205, 3, '2025-02-18', 2000, 'completed'),
(206, 3, '2025-03-01', 3000, 'completed'),
(207, 4, '2025-02-05', 800, 'cancelled'),
(208, 5, '2025-03-10', 2500, 'completed');
