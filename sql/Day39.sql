-- Day 39 - Advanced Window Functions — Growth %, Momentum & Churn Signals

-- 1. Month-over-month revenue growth %

WITH month_rev AS (
SELECT cust_id, month, revenue, 
	LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_revenue
FROM monthly_revenue_d39
)
SELECT cust_id, month, revenue, prev_revenue, 
	CASE 
    WHEN prev_revenue = 0 OR prev_revenue IS NULL THEN NULL
    ELSE (revenue - prev_revenue) * 100.0 / prev_revenue 
    END AS mom_growth_pct
FROM month_rev;

-- 2. Growth direction flag - Classify each row as: Growing, Declining, Flat, First Month

WITH month_rev AS (
SELECT cust_id, month, revenue,
	LAG(revenue) OVER(PARTITION BY cust_id ORDER BY month) AS prev_revenue
FROM monthly_revenue_d39
)
SELECT cust_id, month, revenue,
	CASE 
    WHEN prev_revenue IS NULL THEN 'First Month'
    WHEN revenue = prev_revenue THEN 'Flat'
    WHEN revenue > prev_revenue THEN 'Growing'
    WHEN revenue < prev_revenue THEN 'Declining'
    END AS growth_direction
FROM month_rev;

-- 3. Rolling 3-month average revenue

SELECT cust_id, month, revenue, AVG(revenue) OVER(PARTITION BY cust_id ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3_month_avg 
FROM monthly_revenue_d39;

-- 4. Churn risk flag - Flag a row as “Churn Risk” if: revenue = 0 (or) revenue declined for 2 consecutive months Otherwise → “Stable”

WITH month_rev AS (
SELECT cust_id, month, revenue, 
	LAG(revenue, 1) OVER(PARTITION BY cust_id ORDER BY month) AS prev_rev,
    LAG(revenue, 2) OVER(PARTITION BY cust_id ORDER BY month) AS prev2_rev
FROM monthly_revenue_d39
)
SELECT cust_id, month, revenue,
	CASE 
    WHEN revenue = 0 OR (prev2_rev > prev_rev AND prev_rev > revenue) THEN 'Churn Risk'
    ELSE 'Stable'
    END AS churn_risk_flag
FROM month_rev;

-- Business Questions

-- 1. Why is percentage growth more meaningful than absolute growth?
/* Percentage growth more meaningful than absolute growth because it allows fair comparison across various time periods and different contexts whereas
absolute growth only shows total numeric increase. Percentage growth show the rate and efficiency of change. */

-- 2. Why are two consecutive declines a stronger churn signal than one?
/* The first decline is mostly due to teporary issues which can be fixed. The second decline shows deeper disengagement ofcustomer which could be intentional. */

-- 3. If a customer has high lifetime revenue but is now declining, how should the business respond?
/* Ths shows a high risk scenario where immediate action need to be taken. The goal should be to identify the root cause such as if customer has changing needs,
competitive pressure or any poor experience and try to re-engage customer before churn. */