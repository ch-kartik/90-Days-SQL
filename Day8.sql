-- Day - 8

CREATE TABLE customers_d8 (
  cust_id INT PRIMARY KEY,
  cust_name VARCHAR(50),
  region VARCHAR(20)
);

INSERT INTO customers_d8 VALUES
(1,'Amit','North'),
(2,'Sara','East'),
(3,'John','West'),
(4,'Pooja','South'),
(5,'Ravi','North');

CREATE TABLE revenue_d8 (
  cust_id INT,
  rev_month INT,
  revenue INT,
  FOREIGN KEY (cust_id) REFERENCES customers_d8(cust_id)
);

INSERT INTO revenue_d8 VALUES
(1,1,2000),(1,2,2500),(1,3,3000),
(2,1,3000),(2,2,2000),
(3,1,1500),(3,2,1500),(3,3,1500),
(4,2,1800),(4,3,2200),
(5,1,500),(5,2,700);