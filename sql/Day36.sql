-- Day 36 - Revenue Cohorts: Expansion vs Contraction

-- 1. Revenue by cohort by month since signup

SELECT DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_cohort, 
	TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup,
    SUM(o.order_amount) AS total_revenue
FROM customers_d36 c JOIN orders_d36 o
ON c.cust_id = o.cust_id
GROUP BY signup_cohort, month_since_signup;

-- 2. Baseline revenue (Month 0) per cohort

WITH cohort_rev AS (
SELECT DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_cohort,
	TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup,
    SUM(o.order_amount) AS total_revenue
FROM customers_d36 c JOIN orders_d36 o
ON c.cust_id = o.cust_id
GROUP BY signup_cohort, month_since_signup
)
SELECT signup_cohort, total_revenue
FROM cohort_rev
WHERE month_since_signup = 0;

-- 3. Expansion vs Contraction calculation 

WITH cohort_rev AS (
SELECT DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_cohort,
	TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup,
    SUM(order_amount) AS revenue
FROM customers_d36 c JOIN orders_d36 o
ON c.cust_id = o.cust_id
GROUP BY  signup_cohort, month_since_signup
)
SELECT c.signup_cohort, c.month_since_signup, c.revenue, c.revenue - m0.revenue AS revenue_change,
	CASE
    WHEN c.revenue = m0.revenue THEN 'Flat'
    WHEN c.revenue > m0.revenue THEN 'Expansion'
    WHEN c.revenue < m0.revenue THEN 'Contraction'
    END AS status
FROM cohort_rev c JOIN cohort_rev m0
ON c.signup_cohort = m0.signup_cohort
AND m0.month_since_signup = 0;
    
-- 4. Net revenue movement by cohort

WITH cohort_rev AS (
SELECT DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_cohort,
	TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup,
    SUM(order_amount) AS revenue
FROM customers_d36 c JOIN orders_d36 o
ON c.cust_id = o.cust_id
GROUP BY signup_cohort, month_since_signup
)
SELECT c.signup_cohort,
	SUM(CASE WHEN c.revenue > m0.revenue THEN c.revenue - m0.revenue ELSE 0 END) AS expansion_revenue,
    SUM(CASE WHEN c.revenue < m0.revenue THEN m0.revenue - c.revenue ELSE 0 END) AS contracted_revenue,
    SUM( CASE
		WHEN c.revenue > m0.revenue THEN c.revenue - m0.revenue
        WHEN c.revenue < m0.revenue THEN m0.revenue - c.revenue
        ELSE 0
        END) AS net_change
FROM cohort_rev c JOIN cohort_rev m0
ON c.signup_cohort =  m0.signup_cohort
AND m0.month_since_signup = 0
WHERE c.month_since_signup > 0
GROUP BY c.signup_cohort;

-- 5. Identify dangerous cohorts

WITH cohort_rev AS (
SELECT DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_cohort,
	TIMESTAMPDIFF(MONTH, c.signup_date, o.order_date) AS month_since_signup,
    SUM(order_amount) AS revenue
FROM customers_d36 c JOIN orders_d36 o
ON c.cust_id = o.cust_id
GROUP BY signup_cohort, month_since_signup
)
SELECT c.signup_cohort, m2.revenue,
	CASE 
    WHEN m0.revenue != 0 THEN ROUND(m2.revenue / m0.revenue * 100, 1) 
    ELSE 0
    END AS retention_percent,
    CASE 
    WHEN m2.revenue / m0.revenue <= 0.8 THEN 1 ELSE 0
    END AS risk_flag
FROM cohort_rev c JOIN cohort_rev m0
ON c.signup_cohort = m0.signup_cohort
AND m0.month_since_signup = 0
JOIN cohort_rev m2
ON c.signup_cohort =  m2.signup_cohort
AND m2.month_since_signup = 2
GROUP BY c.signup_cohort;

-- Business Questions

-- 1. Why can a company have good customer retention but bad revenue retention?
/* A company having good customer retention but bad revenue retenion due to heavy discounts or losing high value clients while retaining low value ones. 
Customer retention counts users who stays while revenue retention counts value that remains. Losing high-ARPU customers while retaining low-ARPU customers */
 
-- 2. Which is more dangerous long-term: A) Losing customers completely B) Or keeping customers who steadily spend less? (Explain like you’re answering a CFO.)
/* Keeping customers who steadily spend less is often more dangerous because it masks decline. Churn is visible; revenue decay compounds silently and breaks forecasting. */

-- 3. If a cohort shows strong expansion, which teams deserve credit — and why?
-- Sales as the upsell, RevOps for pricing and incentives and Customer Success responsible for user adoption and product usage.

-- 4. How would RevOps act differently from Marketing after seeing contraction-heavy cohorts?
-- Marketing reacts with campaigns while RevOps redesigns systems for pricing, packaging, sales motion and CS prioritization.

-- 5. If you had to show one chart from today’s analysis to leadership, what would it be and why?
-- Net revenue retention by cohort(Expansion and Contraction stacked)