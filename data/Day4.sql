CREATE TABLE customers_d4 (
  cust_id INT PRIMARY KEY,
  cust_name VARCHAR(50),
  region VARCHAR(20)
);

INSERT INTO customers_d4 VALUES
(1,'Amit','East'),
(2,'Priya','West'),
(3,'John','North'),
(4,'Sara','East'),
(5,'Mohan','West'),
(6,'Dev','North');


CREATE TABLE subs_d4 (
 sub_id INT,
 cust_id INT,
 plan VARCHAR(20),
 fee INT,
 status VARCHAR(20),
 start_month INT, -- (1=Jan, 2=Feb...6=Jun)
 FOREIGN KEY (cust_id) REFERENCES customers_d4(cust_id)
);

INSERT INTO subs_d4 VALUES
(101,1,'Gold',200,'Active',1),
(102,1,'Gold',200,'Active',2),
(103,2,'Silver',120,'Cancelled',1),
(104,2,'Gold',200,'Active',3),
(105,3,'Silver',120,'Active',1),
(106,3,'Silver',120,'Expired',4),
(107,4,'Gold',200,'Cancelled',2),
(108,4,'Bronze',80,'Active',3),
(109,5,'Gold',200,'Active',4),
(110,6,'Silver',120,'Active',2);
