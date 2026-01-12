-- Day 21 - Customer Lifecycle, Retention & Revenue Cohorts

-- 1. First Purchase Month per Customer

SELECT cust_id, MIN(DATE_FORMAT(order_date, '%Y-%m')) AS first_purchase_month
FROM orders_d21
GROUP BY cust_id;

-- 2. Monthly Revenue by Customer

SELECT cust_id, DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(order_amount) AS monthly_revenue
FROM orders_d21
GROUP BY cust_id, month;

-- 3. New vs Repeat Revenue per Month

WITH first_month AS (
SELECT cust_id, MIN(order_date) AS first_purchase_month
FROM orders_d21
GROUP BY cust_id
)
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, 
	SUM(CASE 
		WHEN DATE_FORMAT(o.order_date, '%Y-%m') = DATE_FORMAT(f.first_purchase_month, '%Y-%m') 
        THEN o.order_amount 
        END) AS new_revenue,
    SUM(CASE
		WHEN DATE_FORMAT(o.order_date, '%Y-%m') > DATE_FORMAT(f.first_purchase_month, '%Y-%m') 
        THEN o.order_amount 
        END) AS repeat_revenue
FROM orders_d21 o JOIN first_month f
ON o.cust_id = f.cust_id
GROUP BY month;

-- 4. Retained Customers Count per Month

WITH current_month AS (
SELECT cust_id, DATE_FORMAT(order_date, '%Y-%m') AS month
FROM orders_d21
),
retention_month AS (
SELECT r.month AS month, p.cust_id  
FROM current_month p JOIN current_month r 
ON p.cust_id = r.cust_id
AND p.month = DATE_FORMAT(DATE_SUB(CAST(CONCAT(r.month, '-01') AS DATE), INTERVAL 1 MONTH), '%Y-%m')
)
SELECT month, COUNT(DISTINCT cust_id) AS retained_customers
FROM retention_month
GROUP BY month
ORDER BY month;


-- 5. Revenue by Customer Age

WITH first_month AS (
SELECT cust_id, MIN(DATE_FORMAT(order_date, '%Y-%m')) AS first_month
FROM orders_d21
GROUP BY cust_id
),
orders AS (
SELECT o.order_amount, o.order_date, f.first_month,
	TIMESTAMPDIFF(MONTH, f.first_month, o.order_date) AS months_since_first_purchase
FROM first_month f JOIN orders_d21 o
ON f.cust_id = o.cust_id
),
bucket_orders AS (
SELECT order_amount, 
	CASE 
    WHEN months_since_first_purchase = 0 THEN 'Month 0 (first month)'
	WHEN months_since_first_purchase = 1 THEN 'Month 1'
    ELSE 'Month 2+'
    END AS customer_age_bucket
FROM orders
)
SELECT customer_age_bucket, SUM(order_amount) AS total_revenue
FROM bucket_orders
GROUP BY customer_age_bucket
ORDER BY CASE 
    WHEN customer_age_bucket = 'Month 0 (first month)' THEN 0
	WHEN customer_age_bucket = 'Month 1' THEN 1
    ELSE 2 	
    END;
		
        
-- Business Questions

-- 1. Is revenue growth coming more from new or repeat customers?
-- Repeat revenue from customers contributes a larger and sable share.

-- 2. Which month shows better retention quality?
-- Later months show higher retention because returning customers continue to transact, indicating improving product stickiness.

-- 3. What does customer age vs revenue tell you about product stickiness?
-- Higher revenue from older customer cohorts indicates strong product stickiness and increasing LTV, suggesting that retention efforts are compounding revenue over time.

-- 4. If repeat revenue is low, what business actions would you suggest?
/* If repeat revenue is low, identify the reason of reduce in spend of customers and take action. Improve onboarding style, conduct customer sucess follow ups, review
pricing and packaging.*/

-- 5. Which metric here would you show to a CEO, and why?
-- New vs repeat revenue split, because it clearly shows whether growth is sustainable or acquisition dependent.

