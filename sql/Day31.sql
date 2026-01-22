-- Day 31

-- 1. Last Activity Per Customer

SELECT cust_id, MAX(order_date) AS last_order_date
FROM orders_d31
GROUP BY cust_id;

-- 2. Days Since Last Activity

SELECT cust_id, DATEDIFF('2023-04-01', MAX(order_date)) AS days_inactive
FROM orders_d31
GROUP BY cust_id;

-- 3. Inactivity Buckets

SELECT cust_id,
	CASE
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) <= 30 THEN 'Active'
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) BETWEEN 31 AND 60 THEN 'At Risk'
    WHEN DATEDIFF('2023-04-01', MAX(order_date)) > 60 THEN 'Churned'
    END AS inactivity_bucket
FROM orders_d31
GROUP BY cust_id;

-- 4. Revenue at Risk

WITH customer_status AS (
SELECT cust_id, SUM(order_amount) AS total_revenue, DATEDIFF('2023-04-01', MAX(order_date)) AS days_inactive
FROM orders_d31
GROUP BY cust_id
)
SELECT SUM(total_revenue) AS revenue_at_risk
FROM customer_status
WHERE days_inactive > 30;

-- Business Questions 

-- 1. Why is inactivity often a better churn signal than cancellation?
/* Inactivity often a better churn signal than cancellation as it occurs before customer made decision to leave which provides intervention whereas cancellation is
finally customer leaving after decision is made, makes it hard to reverse.  */

-- 2. Which bucket should RevOps prioritize first — At Risk or Churned? Why?
/* At Risk should be focued first because retaining existing customers is more cost-effective and profitable than acquiring new ones or winning back 
those who have already left. */

-- 3. What action would you take before a customer becomes churned?
/* Identify the reason the customer is inactive, analyse and make a plan of action and try to retain the customer, if required provide discount or voucher which 
might help the customer to continue orders and return. */