-- Day-6

-- 1. Show customer-month activity with cohort month

SELECT c.cust_id, s.sub_month, 
	MIN(s.sub_month) OVER(PARTITION BY c.cust_id) AS cohort_month
FROM customers_d6 c JOIN subs_d6 s
ON c.cust_id = s.cust_id;

-- 2. Calculate months_since_cohort
WITH cohort AS (
SELECT c.cust_id, s.sub_month, 
	MIN(s.sub_month) OVER(PARTITION BY c.cust_id) AS cohort_month 
FROM customers_d6 c JOIN subs_d6 s
ON s.cust_id = c.cust_id
)
SELECT cust_id, sub_month, (sub_month - cohort_month) AS months_since_cohort
FROM cohort;

-- 3. Identify retention drops

WITH ordered_month AS (
SELECT cust_id, sub_month, `status`,
	LEAD(sub_month) OVER(PARTITION BY cust_id ORDER BY sub_month) AS next_month
FROM subs_d6
)
SELECT cust_id, sub_month AS dropped_after_month
FROM ordered_month
WHERE next_month IS NULL 
OR next_month <> sub_month + 1
AND sub_month < (SELECT MAX(sub_month) FROM subs_d6);

-- 4. Retention count by cohort & month index

WITH cohort AS (
SELECT cust_id, sub_month, MIN(sub_month) OVER(PARTITION BY cust_id) AS cohort_month
FROM subs_d6
WHERE `status` = 'Active'
GROUP BY cust_id, sub_month
)
SELECT cohort_month, sub_month, 
	COUNT(DISTINCT cust_id) AS user_count 
FROM cohort
GROUP BY cohort_month, sub_month;

-- 5. Revenue retained vs lost month-over-month

WITH cust_month_revenue AS ( 
SELECT cust_id, sub_month, SUM(fee) AS revenue 
FROM subs_d6 WHERE status = 'Active' 
GROUP BY cust_id, sub_month 
), 
ordered AS ( 
SELECT cust_id, sub_month, revenue, 
	LEAD(sub_month) OVER(PARTITION BY cust_id ORDER BY sub_month) AS next_month
FROM cust_month_revenue 
),
max_month AS (
SELECT MAX(sub_month) AS last_month FROM cust_month_revenue
) 
SELECT o.sub_month, 
	SUM(CASE 
		WHEN o.next_month = o.sub_month + 1 THEN o.revenue
        END) AS revenue_retained,     -- Retained i.e. customers who were present last month 
    SUM(CASE 
		WHEN o.next_month IS NULL OR  o.next_month > o.sub_month + 1 THEN o.revenue 
        END) AS lost_revenue 
FROM ordered o
CROSS JOIN max_month m 
GROUP BY o.sub_month 
ORDER BY o.sub_month;

SELECT * FROM subs_d6;
SELECT * FROM customers_d6;

-- Business Questions

-- 1. Which customers show silent churn (not cancelled, just disappeared)?
/* Customer 2 shows silent churn, in 3rd month no activation is seen without any cancellation. We can see that customer 4 had 
temporary inactivity in 2nd month but is active in 3rd month. */

-- 2. Is churn happening early or later? Why is early churn dangerous?
/* It is observed that churn is happening later. Early churn is dangerous as Customer Acquisition Cost (CAC) is not recovered,
 it could lead to financial losses and affect long term growth of business. */

-- 3. What retention action would you take for customer 4 (Sara)?
/* Trigger an automatic engagement workflow after first inactivity, then follow up to understand the reason if user continues to be inactive. In case required 
propose an alternative membership plan or provide some kind of discount or voucher which will benefit user in long term. */

-- 4. If revenue drops but user count stays flat — what does that signal?
/* Drop in revenue while user count being flat will affect the Average Revenue per User. It could be due to many factors. It could be that users spend has 
decreased or due to subscription plan change, could be an impact of providing discounts, etc. */

