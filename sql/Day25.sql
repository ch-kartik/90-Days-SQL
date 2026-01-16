-- Day 25 — Customer Activity & Recency Analysis

-- 1. Total revenue per customer

SELECT c.cust_id, c.cust_name, SUM(o.order_amount) AS total_revenue
FROM customers_d25 c JOIN orders_d25 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id, c.cust_name;

-- 2.  Last order date per customer

SELECT cust_id, MAX(order_date) AS last_order_date
FROM orders_d25
GROUP BY cust_id;

-- 3.  Customers who ordered only once

SELECT cust_id
FROM orders_d25
GROUP BY cust_id
HAVING COUNT(DISTINCT order_id) = 1;

-- 4. Active vs Inactive customers

SELECT cust_id, 
	CASE
    WHEN MAX(order_date) > '2023-02-28' THEN 'Active'
    ELSE 'Inactive'
    END AS status
FROM orders_d25
GROUP BY cust_id;

-- 5. Average days between first and last order per customer

SELECT cust_id, 
	DATEDIFF(MAX(order_date), MIN(order_date)) AS days_duration
FROM orders_d25
GROUP BY cust_id;

-- Business Questions

-- 1. Why is recency more important than total revenue for retention teams?
/* Recency shows whether a customer is still engaged, while total revenue is historical. Retention teams act on current behavior and not on past spending. */

-- 2. Which customer here looks most at risk of churn, and why?
-- Customer 2 is at risk  of churn as the last order is in Jan month and then there are no orders placed since last two months.

-- 3. If you could re-engage only one inactive customer, who would you choose and why?
-- Better to choose customer 1 over 2 as the former's last order was placed last month compared to the later who placed the last order two months ago.  

-- 4. How would this analysis help a RevOps or CS team?
/* Segment customers by behavior, identify drop-off points, trigger retention campaigns for inactive users, and align marketing spend toward channels bringing repeat customers */
