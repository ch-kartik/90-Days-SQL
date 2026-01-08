-- Day 17

-- 1. Last Activity per Customer
WITH dates AS (
SELECT cust_id, MIN(order_date) AS first_order_date, MAX(order_date) AS last_order_date
FROM orders_d17
GROUP BY cust_id
),
orders AS(
SELECT cust_id, COUNT(order_id) AS total_completed_orders
FROM orders_d17
WHERE status = 'completed'
GROUP BY cust_id
)
SELECT d.cust_id, d.first_order_date, d.last_order_date, o.total_completed_orders
FROM dates d JOIN orders o
ON d.cust_id = o.cust_id
GROUP BY d.cust_id;

-- 2. Inactivity Gap
 
WITH orders AS ( 
SELECT cust_id, MIN(order_date) AS first_order, MAX(order_date) AS last_order
FROM orders_d17
GROUP BY cust_id 
)
SELECT cust_id, TIMESTAMPDIFF(MONTH, first_order, last_order) AS months_between_first_last_order
FROM orders;

-- 3. Churn Risk Classification

SELECT cust_id, 
	CASE
	WHEN MAX(order_date) >= DATE_SUB('2024-05-31', INTERVAL 1 MONTH) THEN 'Active'
    WHEN MAX(order_date) >= DATE_SUB('2024-05-31', INTERVAL 3 MONTH) THEN 'At Risk'
    ELSE 'Churned'
    END AS cust_class
FROM orders_d17
GROUP BY cust_id;

-- 4. Reactivated Customers

WITH previous AS (
SELECT cust_id, order_date, 
	LAG(order_date) OVER(PARTITION BY cust_id ORDER BY order_date) AS previous_date,
    LEAD(order_date) OVER(PARTITION BY cust_id ORDER BY order_date) AS next_date
FROM orders_d17
)
SELECT cust_id
FROM previous
WHERE TIMESTAMPDIFF(MONTH, previous_date, order_date) >= 2 AND next_date IS NOT NULL;


-- Business Questions

-- 1. Why is time gap between orders more useful than total orders?

-- Time gap between orders helps identify a customers behaviour, order patterns and identify churn risk. 

-- 2. Which customers should retention teams prioritize: At Risk (or) Already Churned. Why?

-- At Risk as there is still a little chance to retain the existing customers by providing value and satisfy their needs rather than trying to get back those who have already churned.

-- 3. If Ads customers churn faster but come back more often, how would you treat that channel?

-- In short term it may be good for revenue experimenting with Ads but in long term loyalty of customers is important so need to onboard more customers and also retain them by reducing churn.

-- 4. What single metric would you track weekly to catch churn early?

-- Number of active customers over a week