-- Day 18

CREATE TABLE customers_d18 (
  cust_id INT PRIMARY KEY,
  channel VARCHAR(20)
);

INSERT INTO customers_d18 VALUES
(1,'Organic'),(2,'Ads'),(3,'Organic'),(4,'Referral'),
(5,'Ads'),(6,'Organic'),(7,'Referral'),(8,'Ads');

CREATE TABLE orders_d18 (
  order_id INT PRIMARY KEY,
  cust_id INT,
  order_amount INT,
  order_date DATE,
  status VARCHAR(15),
  FOREIGN KEY (cust_id) REFERENCES customers_d18(cust_id)
);

INSERT INTO orders_d18 VALUES
(101,1,3000,'2025-01-05','completed'),
(102,1,2500,'2025-02-10','completed'),
(103,2,800,'2025-01-15','completed'),
(104,2,700,'2025-02-20','completed'),
(105,3,5000,'2025-01-25','completed'),
(106,4,1200,'2025-02-05','completed'),
(107,5,600,'2025-01-12','completed'),
(108,6,2200,'2025-03-01','completed'),
(109,6,2400,'2025-03-15','completed'),
(110,7,900,'2025-02-18','completed'),
(111,8,400,'2025-01-22','completed');