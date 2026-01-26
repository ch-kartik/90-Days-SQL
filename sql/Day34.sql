-- Day 34 - Revenue Risk & Churn Impact Analysis

-- 1. Total revenue per customer

SELECT cust_id, SUM(order_amount) AS total_amount
FROM orders_d34
GROUP BY cust_id;

-- 2. Last order date & recency (days since last order)

SELECT cust_id, MAX(order_date) AS last_order_date, DATEDIFF('2023-04-01', MAX(order_date)) AS days_since_last_order
FROM orders_d34
GROUP BY cust_id;

-- 3. Average monthly revenue per customer

WITH months AS (
SELECT '2023-01' AS month UNION ALL
SELECT '2023-02' UNION ALL
SELECT '2023-03'
),
rev_month AS (
SELECT cust_id, DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(order_amount) AS total_revenue
FROM orders_d34
GROUP BY cust_id, month
),
cust_months AS (
SELECT DISTINCT o.cust_id, m.month
FROM orders_d34 o
CROSS JOIN months m
)
SELECT cm.cust_id,
	AVG(COALESCE(rm.total_revenue, 0)) AS true_avg_monthly_revenue
FROM cust_months cm
LEFT JOIN rev_month rm
ON cm.cust_id = rm.cust_id
AND cm.month = rm.month
GROUP BY cm.cust_id;

-- 4. Identify “Revenue at Risk” customers

SELECT cust_id,
	CASE
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) < 30 THEN 'Safe'
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) > 60 THEN 'Churned'
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) BETWEEN 31 AND 60 THEN 'At Risk'
    END AS status
FROM orders_d34
GROUP BY cust_id;

-- 5. Revenue at Risk by segment	

WITH customer_rev AS (
SELECT cust_id, SUM(order_amount) AS total_revenue, DATEDIFF('2023-04-01', MAX(order_date)) AS days_since_last_order
FROM orders_d34
GROUP BY cust_id
)
SELECT SUM(total_revenue) AS revenue_at_risk
FROM customer_rev
WHERE days_since_last_order BETWEEN 31 AND 60;

-- 6. Top 2 customers contributing to revenue risk

WITH segment AS (
SELECT cust_id, SUM(order_amount) AS total_revenue,
	CASE
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) < 30 THEN 'Safe'
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) > 60 THEN 'Churned'
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) BETWEEN 31 AND 60 THEN 'At Risk'
    END AS status
FROM orders_d34
GROUP BY cust_id
) 
SELECT cust_id 
FROM segment
WHERE status IN ('At Risk', 'Churned') 
GROUP BY cust_id
ORDER BY total_revenue DESC LIMIT 2;


-- Business Questions

-- 1. Why is revenue at risk more actionable than churn count?
/* Revenue at risk shows the details of customers who are likely to quit and it could have financial impact. This allows teams to focus on retention efforts where
required and prevent revenue loss. Whereas churn count gives details of number of custormers left. */

-- 2. Why might a high-revenue customer with moderate recency be more dangerous than a low-revenue churned customer?
/* High revenue customer with moderate recency is more dangerous than low revenue churned customer because the former is contibuting a significant growth to the business 
and posess an active risk to the business growth and stability compared to the later who can be considered minor loss with low impact.*/

-- 3. What early signal would you monitor weekly to reduce revenue risk?
-- Indicators such as recency, frequency of product usage, referrals, etc.

-- 4. If leadership asks, “How much revenue could we lose next quarter?”, how does this analysis help?
/* Considering the limited data have access to, it is observed that the customers 2 & 3 are at risk. And the revenue at risk is 600. */

-- 5. Which team owns revenue-risk reduction — Sales, CS, Product, or RevOps? Why?
/* The primary owner is RevOps which is responsible to strategise and reduce revenue risk while CS is responsible for executing risk mitigation with active customers. 
As RevOps owns the entire system, communicates with different teams and processes to identify risk at early stage. */