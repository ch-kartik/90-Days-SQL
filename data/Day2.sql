CREATE TABLE regions (
  region_id INT PRIMARY KEY,
  region_name VARCHAR(50)
);

INSERT INTO regions VALUES
(1, 'North'),
(2, 'South'),
(3, 'East'),
(4, 'West');

CREATE TABLE products1 (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50)
);

INSERT INTO products1 VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Mobile', 'Electronics'),
(103, 'Shoes', 'Fashion'),
(104, 'Shirt', 'Fashion'),
(105, 'Watch', 'Luxury');

CREATE TABLE sales (
  sale_id INT PRIMARY KEY,
  region_id INT,
  product_id INT,
  amount DECIMAL(10,2),
  sale_date DATE,
  status VARCHAR(20),
  FOREIGN KEY (region_id) REFERENCES regions(region_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO sales VALUES
(1, 1, 101, 55000, '2024-10-10', 'Delivered'),
(2, 1, 102, 30000, '2024-11-05', 'Delivered'),
(3, 2, 103, 4000,  '2024-11-15', 'Pending'),
(4, 2, 104, 2500,  '2024-12-01', 'Delivered'),
(5, 3, 105, 32000, '2024-09-15', 'Cancelled'),
(6, 3, 101, 60000, '2024-11-25', 'Delivered'),
(7, 4, 102, 28000, '2024-12-10', 'Delivered'),
(8, 4, 103, 4500,  '2024-12-12', 'Delivered'),
(9, 4, 105, 72000, '2024-12-15', 'Pending'),
(10,4, 101, 58000, '2024-12-18', 'Delivered');
