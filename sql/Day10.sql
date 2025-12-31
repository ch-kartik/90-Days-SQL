-- Day 10

-- 1. Repeat vs One-Time Customers

SELECT cust_id, COUNT(order_id) AS total_completed_orders,
	CASE 
    WHEN COUNT(order_id) >= 2 THEN 'Repeat'
    ELSE 'One-Time'
    END AS cust_type
FROM orders_d10
WHERE `status` = 'completed'
GROUP BY cust_id; 

-- 2. Revenue Contribution by Customer Type

SELECT CASE
		WHEN COUNT(order_id) >= 2 THEN 'Repeat'
        ELSE 'One-Time'
        END AS cust_type,
       SUM(order_amount) AS total_revenue
FROM orders_d10
WHERE `status` = 'completed'
GROUP BY cust_id;

WITH customer_type AS (
SELECT cust_id, 
	CASE
		WHEN COUNT(cust_id) >= 2 THEN 'Repeat'
        ELSE 'One-Time'
    END AS cust_type
FROM orders_d10
WHERE `status` = 'completed'
GROUP BY cust_id
)
SELECT c.cust_type, SUM(o.order_amount) AS total_revenue
FROM customer_type c JOIN orders_d10 o
ON c.cust_id = o.cust_id
WHERE o.`status` = 'completed'
GROUP BY c.cust_type;


-- 3. Retention Risk List

SELECT cust_id AS high_risk_churn_candidates
FROM orders_d10
WHERE `status` = 'completed'
GROUP BY cust_id
HAVING COUNT(order_id) = 1 AND SUM(order_amount) > 2000;

-- 4. Revenue Concentration

WITH rev AS (
SELECT cust_id, SUM(order_amount) AS segment_revenue, 
	(SELECT SUM(order_amount) FROM orders_d10) AS total_revenue
FROM orders_d10
WHERE status = 'completed'
GROUP BY cust_id
)
SELECT cust_id, segment_revenue, ROUND((segment_revenue/total_revenue) * 100, 2) AS percentage_contribution_to_overall_revenue
FROM rev;

-- Business Questions

-- 1. Why is a business more vulnerable if most revenue comes from one-time customers?
/* Business from onr time customers is unpredictable. The revenue will be uncertain. It makes investment decision and growth plan risky.

-- 2. If Repeat customers are only 30% of users but generate 70% revenue, what should leadership do?
/* Try to protect repeat customers in various ways such as with proper support, multi tier pricing, good experience. Analyse and understand what could lead one-time users
to become repeative customers and implement the same at a larger level. */

/* 3. Which is more dangerous:
	• losing many low-value customers
	• or losing one high-value repeat customer
	Why?    */   
/* Losing one high-value repeat customer is dangerous as it affects revenue and stability, but at the same time low-value customers as a group have their own 
importance considering the reputation issue it could lead to the products and the business brand, loss of loyalty and low revenue as a whole. */