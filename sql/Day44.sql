-- Day 44 - End-to-End Business SQL Case — Revenue, Churn & Actions

/*
Create ONE final table (one query, multiple CTEs allowed) with this structure:

cust_id
latest_month
latest_revenue
prev_month_revenue
revenue_trend        -- Growing / Flat / Declining / Single Month
customer_status      -- Healthy / At Risk / Churned
revenue_at_risk

*/

WITH monthly AS (
SELECT cust_id, DATE_FORMAT(payment_date, '%Y-%m-01') AS month, SUM(amount) AS revenue
FROM payments_d44
GROUP BY cust_id, month
),
latest_month AS (
SELECT cust_id, MAX(month) AS latest_month
FROM monthly
GROUP BY cust_id
),
global_latest_month AS (
SELECT DATE_FORMAT(MAX(payment_date), '%Y-%m-01') AS global_latest_month
FROM payments_d44
),
prev_month AS (
SELECT cust_id, month, revenue, 
	LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_month_revenue
FROM monthly
)
SELECT p.cust_id, p.month AS latest_month, p.revenue AS latest_revenue, p.prev_month_revenue,
	CASE 
    WHEN p.prev_month_revenue IS NULL THEN 'Single Month'
    WHEN p.revenue = p.prev_month_revenue THEN 'Flat'
    WHEN p.revenue > p.prev_month_revenue THEN 'Growing'
    WHEN p.revenue < p.prev_month_revenue THEN 'Declining'
    END AS revenue_trend,
    CASE
    WHEN p.month = (SELECT global_latest_month FROM global_latest_month) AND p.revenue < p.prev_month_revenue THEN 'At Risk'
    WHEN p.month = (SELECT global_latest_month FROM global_latest_month) AND p.revenue >= p.prev_month_revenue THEN 'Healthy'
    WHEN p.month != (SELECT global_latest_month FROM global_latest_month) THEN 'Churned'
    END AS customer_status,
    CASE
    WHEN p.revenue < p.prev_month_revenue THEN p.prev_month_revenue - p.revenue
    WHEN p.month != (SELECT global_latest_month FROM global_latest_month) THEN p.revenue
    ELSE 0
    END AS revenue_at_risk
FROM prev_month p JOIN latest_month l
ON p.cust_id = l.cust_id
AND p.month = l.latest_month;

-- Business Questions

-- 1. What does this table tell leadership in one sentence?
/* This table highlights which customers are growing, stable, at risk of churn, or already churned, along with the revenue currently exposed to loss*/

-- 2. Which customers need immediate action and why?
/* Customer 3 requires immediate action due to declining revenue and missed latest-month payment, indicating churn risk, followed by Customer 1 who shows
 a recent revenue decline despite continued payments. */

-- 3. What would you do in the next 30 days to reduce revenue at risk?
/* Prioritize outreach to At Risk customers, run pricing/usage analysis for declining accounts, Offer targeted retention incentives, Monitor next billing cycle closely. */
