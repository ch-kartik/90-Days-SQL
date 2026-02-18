-- Day 45 - Churn, Risk & Revenue Logic

-- 1. Monthly revenue table

SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d45
GROUP BY cust_id, month;

-- 2. Revenue trend per customer

WITH monthly AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d45
GROUP BY cust_id, month
),
prev_month AS (
SELECT cust_id, month, revenue, 
	LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_month_revenue
FROM monthly
)
SELECT cust_id, month, revenue, prev_month_revenue,
	CASE
    WHEN prev_month_revenue IS NULL THEN 'First Month'
    WHEN revenue = prev_month_revenue THEN 'Flat'
    WHEN revenue > prev_month_revenue THEN 'Growing'
    WHEN revenue < prev_month_revenue THEN 'Declining'
    END AS revenue_trend
FROM prev_month;

-- 3. Identify customer status

WITH monthly AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d45
GROUP BY cust_id, month
),
latest_month AS (
SELECT cust_id, MAX(month) AS latest_month
FROM monthly
GROUP BY cust_id
),
global_latest_month AS
(
SELECT MAX(month) AS global_latest_month
FROM monthly
),
prev_month_revenue AS (
SELECT cust_id, month, revenue, LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_month_revenue
FROM monthly 
)
SELECT l.cust_id, l.latest_month,
	CASE 
    WHEN p.month = (SELECT global_latest_month FROM global_latest_month) AND p.revenue < p.prev_month_revenue THEN 'At Risk'
    WHEN p.month = (SELECT global_latest_month FROM global_latest_month) AND (p.prev_month_revenue IS NULL OR p.revenue > p.prev_month_revenue) THEN 'Healthy'
    WHEN p.month != (SELECT global_latest_month FROM global_latest_month) THEN 'Churned'
    END AS customer_status
FROM prev_month_revenue p JOIN latest_month l
ON p.cust_id = l.cust_id
WHERE p.month = l.latest_month;

-- 4. Revenue at risk

WITH monthly AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d45
GROUP BY cust_id, month
),
latest_month AS (
SELECT cust_id, MAX(month) AS latest_month
FROM monthly
GROUP BY cust_id
),
global_latest_month AS (
SELECT MAX(month) AS global_latest_month
FROM monthly
),
prev_month_revenue AS (
SELECT cust_id, month, revenue, LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_month_revenue
FROM monthly
)
SELECT l.cust_id,
	CASE 
    WHEN p.month = (SELECT global_latest_month FROM global_latest_month) AND p.revenue < p.prev_month_revenue THEN p.revenue - p.prev_month_revenue
    WHEN p.month != (SELECT global_latest_month FROM global_latest_month) THEN p.revenue
    ELSE 0
    END AS revenue_at_risk
FROM prev_month_revenue p JOIN latest_month l
ON p.cust_id = l.cust_id
WHERE p.month = l.latest_month;


-- Business Questions

-- 1. Why is “no payment in latest month” a stronger churn signal than revenue decline?
/* No payment in last month shows that the customer has stopped the usage of product or services and is no longer spending whereas revenue decline may indicate
a temporary monetary constraint or in search of better value rather than complete seize. */

-- 2. Which customers should retention focus on FIRST and why?
/* Company should focus on Customer 1 immediately as the status is At Risk which shows there isa chance of churn and then focus on Customer 2 who has already churned as
there is no purchase in latest month, there is a need to understand the reason and try to recover the customer. */

-- 3. If leadership could track only ONE metric from this analysis, what should it be?
-- Customer status with a focus on revenue trends and revenue risk

-- 4. What assumption in this analysis could silently break in the real world?
/* The current analysis was done using limited data which is clean with uniform customer behaviour. In real world the data would be messy with behaviour fluctuation 
and inconsistency in data. */