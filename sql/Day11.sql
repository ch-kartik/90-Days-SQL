-- Day 11 

-- 1. Monthly Revenue Trend

SELECT DATE_FORMAT(order_date, '%Y-%m') AS `month`, SUM(order_amount) AS total_revenue_per_month
FROM orders_d11
WHERE status = 'completed'
GROUP BY `month`;

-- 2. Monthly Active Customers

SELECT DATE_FORMAT(order_date, '%Y-%m') AS `month`, 
	COUNT(DISTINCT cust_id) AS cust_count
FROM orders_d11
WHERE status = 'completed'	
GROUP BY `month`;

-- 3. Average Order Value per Month

SELECT DATE_FORMAT(order_date, '%Y-%m') AS `month`, SUM(order_amount) AS total_revenue_per_month,  COUNT(order_id) AS total_orders, ROUND(AVG(order_amount), 2) AS avg_order_value
FROM orders_d11
WHERE `status` = 'completed'
GROUP BY `month`;

-- 4. Revenue Stability Check

SELECT DATE_FORMAT(order_date, '%Y-%m') AS `month`, SUM(order_amount) AS total_revenue_per_month
FROM orders_d11
WHERE status = 'completed'
GROUP BY `month`
HAVING SUM(order_amount) < 5000; 

-- Business Questions

-- 1. If revenue increases but active customers stay flat, what could be happening?

-- Revenue may be increasing due to high spend by customers or increase in pricing of product or service, could also be due to upsell.


-- 2. Why is tracking monthly active customers often more important than total customers?

-- Monthly active customers indicate real engaging with the services or the product which shows the current business health the long term and growth of the business.


-- 3. If February revenue drops but March recovers, what should leadership verify before reacting?

-- Need to check if it was de to seasonal change, one time events, etc. Also identify if recovery was done by existing customers or new ones before taking any decision.  
