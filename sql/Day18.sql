-- Day 18

-- 1. Customer Revenue Ranking

SELECT cust_id, SUM(order_amount) AS total_revenue,
	DENSE_RANK() OVER(ORDER BY SUM(order_amount) DESC) AS revenue_rank
FROM orders_d18
GROUP BY cust_id;

-- 2. Revenue Contribution % 

WITH cust_rev AS (
SELECT cust_id, SUM(order_amount) AS per_cust_revenue
FROM orders_d18
GROUP BY cust_id
)
SELECT cust_id, (per_cust_revenue * 100.0 / SUM(per_cust_revenue) OVER ()) AS percent_contribution
FROM cust_rev;

-- 3. Cumulative Revenue (Pareto Prep)

WITH rev AS (
SELECT cust_id, SUM(order_amount) AS revenue
FROM orders_d18
GROUP BY cust_id
)
SELECT cust_id, revenue, SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue,
ROUND(SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER () * 100, 2
) AS cumulative_percent
FROM rev
ORDER BY revenue DESC; 

-- 4. Top Revenue Drivers

SELECT cust_id 
FROM (
	SELECT cust_id,
    SUM(order_amount) AS revenue,
    SUM(SUM(order_amount)) OVER (ORDER BY SUM(order_amount) DESC) /
    SUM(SUM(order_amount)) OVER () AS cumulative_ratio
    FROM orders_d18
    GROUP BY cust_id
) t
WHERE cumulative_ratio <= 0.8;

-- 5. Channel-Level Concentration

WITH total_rev AS (
SELECT c.channel, COUNT(DISTINCT c.cust_id) AS no_of_customers, SUM(o.order_amount) AS total_revenue
FROM customers_d18 c JOIN orders_d18 o
ON c.cust_id = o.cust_id
GROUP BY channel
)
SELECT channel, no_of_customers, total_revenue, ROUND(total_revenue / no_of_customers, 2) AS avg_revenue_per_customer
FROM total_rev;

-- Business Qustions

-- 1. Why is revenue ranking more useful than just total revenue?
-- Ranking helps prioritize customers and focus effort where the revenue impact is highest.

-- 2. If 25% of customers generate 75% of revenue, what risk does the business face?
/* It shows that small portion of customer base is spending more amount which could be beneficial in short term but risky in long run in case there is churn.
Need to identify issue and make the larger base of customers to increase their spend. */

-- 3. Would you rather grow revenue by: adding more low-value customers (or) retaining top 20% customers. Why?
-- Retain top 20 percent customers to continue generating revenue while trying to increase customer base and spend.

-- 4. What would you tell leadership if Ads brings many customers but none appear in top 80% revenue?
-- Advice to reallocate budget and target high value other segments.
