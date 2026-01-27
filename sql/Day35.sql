-- Day 35 - Retention Curve & Revenue Decay Analysis

-- 1. Revenue by customer by month since signup

SELECT c.cust_id, 
	TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup, 
    SUM(o.order_amount) AS total_revenue
FROM customers_d35 c JOIN orders_d35 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id, month_since_signup;

-- 2. Build a retention curve

SELECT TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup,
	COUNT(DISTINCT c.cust_id) AS active_customers, 
    SUM(o.order_amount) AS total_revenue
FROM customers_d35 c JOIN orders_d35 o
ON c.cust_id = o.cust_id
GROUP BY month_since_signup;

-- 3. Identify revenue decay

WITH month_since_signup AS(
SELECT TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup, 
	SUM(o.order_amount) AS total_revenue
FROM customers_d35 c JOIN orders_d35 o
ON c.cust_id = o. cust_id
GROUP BY month_since_signup
ORDER BY month_since_signup
),
monthly_revenue AS(
SELECT month_since_signup, CONCAT('Month ', month_since_signup - 1, ' -> Month ', month_since_signup) AS transition,
	total_revenue AS month_y_revenue,
    LAG(total_revenue, 1, 0) OVER(ORDER BY month_since_signup) AS month_x_revenue			
FROM month_since_signup
)
SELECT transition, month_x_revenue - month_y_revenue AS revenue_drop
FROM monthly_revenue
WHERE month_since_signup > 0;

-- 4. Average revenue per retained customer by month

WITH cust_rev AS (
SELECT TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup, SUM(o.order_amount) AS total_revenue, COUNT(DISTINCT c.cust_id) AS cust_count
FROM customers_d35 c JOIN orders_d35 o
ON c.cust_id = o.cust_id
GROUP BY month_since_signup
)
SELECT month_since_signup, ROUND(total_revenue/cust_count, 2) AS avg_revenue_per_customer
FROM cust_rev;

-- 5. Flag customers with early revenue decay

WITH orders AS (
SELECT cust_id, order_amount, 
	MIN(order_date) OVER(PARTITION BY cust_id) AS min_date,
    MAX(order_date) OVER(PARTITION BY cust_id) AS max_date,
    order_date
FROM orders_d35
),
month_rev AS (
SELECT cust_id, 
	SUM(CASE WHEN order_date = min_date THEN order_amount ELSE 0 END) AS month_0,
    SUM(CASE WHEN order_date = max_date AND min_date != max_date THEN order_amount ELSE 0 END) AS later_month
FROM orders
GROUP BY cust_id
)
SELECT cust_id, month_0, later_month, 
	CASE 
    WHEN later_month != 0 THEN ROUND((month_0 - later_month) / month_0 * 100.0, 1) ELSE 0 END AS drop_percent,
    CASE
    WHEN later_month != 0 AND (month_0 - later_month) / month_0 >= 0.5 THEN 1 ELSE 0 END AS flagged
FROM month_rev;

WITH month_rev AS (
SELECT c.cust_id, TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS m, SUM(o.order_amount) AS revenue
FROM customers_d35 c JOIN orders_d35 o
ON c.cust_id = o.cust_id
GROUP BY c.cust_id, m
),
pivot AS (
SELECT cust_id, 
	SUM(CASE WHEN m = 0 THEN revenue ELSE 0 END) AS month_0,
    SUM(CASE WHEN m IN (1,2) THEN revenue ELSE 0 END) AS month_1_2
    FROM month_rev
    GROUP BY cust_id
)
SELECT *, ROUND((month_0 - month_1_2) / month_0 * 100, 1) AS drop_percent,
	CASE
    WHEN (month_0 - month_1_2) / month_0 >= 0.5 THEN 1 ELSE 0
    END AS flagged
FROM pivot
WHERE month_0 > 0;

-- Business Questions

-- 1. Why do retention curves matter more than churn rate?
/* Retention curve matters as it shows when and why customers leave rather than the number of customers who left. It provides time based details of the product and business health.  */

-- 2. What does fast revenue decay signal about onboarding or product value?
/* Fast revenue decay is a critical warning signal which shows that there is an issue with either onboarding process or product value. This shows that although initial
acquisition was successful but customers are not satisfied with later process. */

-- 3. Which team should act if Month-1 revenue collapses?
-- Immediate action lies with Product and RevOps Team followed but CS and operations. 

-- 4. Why might “customer count retention” look fine while revenue retention drops?
/* Customer count retention looks fine but revenue retention rops because the retained customers are not spending or paying less while the ones who churned were high paying
and high value customers. */

-- 5. What would you show a CFO from today’s analysis?
-- Most revenue got generated in signup month. There was revenue loss during Month 1 due to drop in usage not because of churn.