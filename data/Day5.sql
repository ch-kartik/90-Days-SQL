CREATE TABLE customers_d5 (
  cust_id INT PRIMARY KEY,
  cust_name VARCHAR(50),
  region VARCHAR(20)
);

INSERT INTO customers_d5 VALUES
(1,'Amit','East'),
(2,'Priya','West'),
(3,'John','North'),
(4,'Sara','East'),
(5,'Mohan','West'),
(6,'Dev','North');

CREATE TABLE subs_d5 (
  sub_id INT,
  cust_id INT,
  sub_month INT,   -- 1=Jan, 2=Feb, 3=Mar...
  status VARCHAR(20),
  fee INT,
  FOREIGN KEY (cust_id) REFERENCES customers_d5(cust_id)
);

INSERT INTO subs_d5 VALUES
(101,1,1,'Active',200),
(102,1,2,'Active',200),
(103,1,3,'Active',200),
(104,2,1,'Cancelled',120),
(105,2,3,'Active',200),
(106,3,1,'Active',120),
(107,3,2,'Expired',120),
(108,4,2,'Cancelled',200),
(109,4,3,'Active',80),
(110,5,3,'Active',200),
(111,6,2,'Active',120);
