-- 1. List customer name, region, product name for all orders.

SELECT c.cust_name, c.region, p.product_name FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
JOIN products p ON o.product_id = p.product_id;

-- 2. Total revenue collected only from Delivered orders.

SELECT SUM(amount) AS total_revenue, `status` FROM orders WHERE `status` = 'Delivered';

-- 3. Count of orders by status (Delivered / Pending / Cancelled).

SELECT `status`, COUNT(order_id) AS count_of_orders FROM orders GROUP BY `status`;

-- 4. Which product category generated the highest revenue?

SELECT p.category, SUM(o.amount) AS revenue FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY SUM(o.amount) DESC LIMIT 1;

-- 5. Which region spent the most money?

SELECT c.region, SUM(o.amount) AS revenue FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
GROUP BY c.region
ORDER BY SUM(o.amount) DESC LIMIT 1;

-- 6. Show categories whose avg order amount > 10,000

SELECT p.category, AVG(o.amount) AS avg_order_amount FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
HAVING AVG(o.amount) > 10000;

-- 7. Show regions where total delivered revenue > 50,000

SELECT c.region, SUM(amount) AS total_revenue FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
WHERE o.`status` = 'Delivered'
GROUP BY c.region
HAVING SUM(amount) > 50000;

-- 8. Identify customers whose total spend > avg global spend

SELECT c.cust_name, SUM(o.amount) AS total_amount FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
GROUP BY c.cust_name
HAVING SUM(o.amount) > (SELECT AVG(amount) FROM orders);

-- Business Questions

-- 1. Which customer is highest value? Why?
/* Arun spent 76,000, mostly "Electonics" a high-ticket buyer. However, Ravi has repeat buy pattern (4000 + 70000) and high value which indicates a better long term customer */

-- 2. Which category should we promote?
/*  Promote Fashion with moderate price point with discount which can help increase volume */

-- 3. Which region needs operational follow-up (Pending & Cancelled trend)?
/* West has a cancellation risk, East has repeated Pendng related to shoes which could be due to supply or inventory issue & South has minor pending which needs to be watched closelt */

-- 4. If we had 1 analyst resource — where should they be deployed and why?
/* West as it has high deman for Electronics, a cancellation whichis a signal for risk and it is a growth region */
