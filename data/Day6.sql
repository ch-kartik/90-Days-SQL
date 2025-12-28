CREATE TABLE customers_d6 (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(50)
);

INSERT INTO customers_d6 VALUES
(1,'Amit'), 
(2,'Neha'), 
(3,'Ravi'), 
(4,'Sara');


CREATE TABLE subs_d6 (
    cust_id INT,
    sub_month INT,
    `status` VARCHAR(20),
    fee INT,
    FOREIGN KEY (cust_id) REFERENCES customers_d6(cust_id)
);

INSERT INTO subs_d6 VALUES
(1,1,'Active',1000),
(1,2,'Active',1000),
(1,3,'Active',1000),
(2,1,'Active',1200),
(2,2,'Active',1200),
(3,1,'Active',900),
(3,2,'Cancelled',0),
(4,1,'Active',1500),
(4,3,'Active',1500);
