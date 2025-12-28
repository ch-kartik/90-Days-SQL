CREATE TABLE customers1 (
  cust_id INT PRIMARY KEY,
  cust_name VARCHAR(50),
  region VARCHAR(20)
);

INSERT INTO customers1 VALUES
(1,'Arun','North'),
(2,'Pooja','East'),
(3,'Ravi','East'),
(4,'Sneha','West'),
(5,'Imran','South');

CREATE TABLE subscriptions (
  sub_id INT PRIMARY KEY,
  cust_id INT,
  plan VARCHAR(20),
  start_date DATE,
  end_date DATE,
  status VARCHAR(20),
  fee INT,
  FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
);

INSERT INTO subscriptions VALUES
(101,1,'Gold','2024-01-01','2024-03-31','Expired',9000),
(102,1,'Gold','2024-04-01','2024-06-30','Active',9000),
(103,2,'Silver','2024-02-01','2024-03-31','Cancelled',4000),
(104,2,'Gold','2024-04-01','2024-06-30','Active',9000),
(105,3,'Silver','2024-01-15','2024-02-28','Expired',4000),
(106,3,'Silver','2024-03-01','2024-04-30','Cancelled',4000),
(107,4,'Gold','2024-01-10','2024-03-31','Expired',9000),
(108,5,'Platinum','2024-02-01','2024-05-31','Active',15000);

