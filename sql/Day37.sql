-- Day 37 - Window Functions

-- 1. Previous month revenue

SELECT customer_id, order_date, revenue, LAG(revenue) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_revenue
FROM sales_d37;

-- 2. Revenue movement - Classify each row as: Expansion, Contraction, No Change, First Order

WITH prev_rev AS (
SELECT customer_id, order_date, revenue, LAG(revenue) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_revenue
FROM sales_d37
)
SELECT customer_id, order_date, revenue, 
	CASE
    WHEN prev_revenue IS NULL THEN 'First Order'
    WHEN revenue = prev_revenue THEN 'No Change'
    WHEN revenue > prev_revenue THEN 'Expansion'
    WHEN revenue < prev_revenue THEN 'Contraction'
    END AS movement_type
FROM prev_rev;
	
-- 3. Running total revenue

SELECT customer_id, order_date, revenue, 
	SUM(revenue) OVER(PARTITION BY customer_id ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM sales_d37;

-- 4. Rank customers by total revenue

SELECT customer_id, SUM(revenue) AS total_revenue, 
	DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM sales_d37
GROUP BY customer_id;

-- Business Questions

-- 1. Why are window functions critical for time-based business analysis?
/* They allow us to analyze trends, comparisons, and changes over time without losing transactional granularity, which is essential for revenue, retention, and cohort analysis. */

-- 2. Why would a running total be useful for leadership dashboards?
/* A running total or cumulative sum is impotant for transforming transforming data which fluctuates daily or monthly into a clear upward trending narrative of progress
such as in case of tracking performance monitoring of customer revenue, etc. */

-- 3. In real companies, where would you use ranking logic?
-- Lead Scoring, Employees Ranking, Customer Satisfaction Analysis, etc.