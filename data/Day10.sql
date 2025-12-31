CREATE TABLE customers_d10 (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    region VARCHAR(50)
);

INSERT INTO customers_d10 VALUES
(1, 'Alice', 'US'),
(2, 'Bob', 'India'),
(3, 'Charlie', 'UK'),
(4, 'Diana', 'India'),
(5, 'Evan', 'US');

CREATE TABLE orders_d10 (
    order_id INT,
    cust_id INT,
    order_date DATE,
    order_amount INT,
    status VARCHAR(20),
    FOREIGN KEY (cust_id) REFERENCES customers_d10(cust_id)
);
  
INSERT INTO orders_d10 VALUES
(101, 1, '2025-01-05', 3000, 'completed'),
(102, 1, '2025-02-10', 4000, 'completed'),
(103, 2, '2025-01-15', 1500, 'completed'),
(104, 3, '2025-01-20', 5000, 'completed'),
(105, 3, '2025-02-18', 2000, 'completed'),
(106, 3, '2025-03-01', 3000, 'completed'),
(107, 4, '2025-02-05', 800, 'cancelled'),
(108, 5, '2025-01-25', 2500, 'completed');