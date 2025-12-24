-- Day-5

-- 1. Identify cohort month for each customer

SELECT c.cust_id, MIN(sub_month) AS cohort_month FROM customers_d5 c
JOIN subs_d5 s ON c.cust_id = s.cust_id
GROUP BY c.cust_id;

-- 2. Show customer activity with cohort month

SELECT c.cust_id, 
	MIN(sub_month) OVER(PARTITION BY c.cust_id) AS cohort_month, 
    s.sub_month, s.`status`
FROM customers_d5 c JOIN subs_d5 s
ON c.cust_id = s.cust_id
ORDER BY s.cust_id, s.sub_month;

-- 3. Calculate “months since cohort”

WITH cm AS (
SELECT c.cust_id, 
	MIN(sub_month) OVER(PARTITION BY c.cust_id) AS cohort_month, 
    s.sub_month
FROM customers_d5 c JOIN subs_d5 s
ON c.cust_id = s.cust_id
GROUP BY c.cust_id, s.sub_month
)
SELECT cust_id, cohort_month, sub_month, (sub_month - cohort_month) AS months_since_cohort
FROM cm; 

-- 4. Cohort retention count

WITH cm AS (
SELECT c.cust_id, 
	MIN(sub_month) OVER(PARTITION BY c.cust_id) AS cohort_month,
    s.sub_month,
    s.`status`
FROM customers_d5 c JOIN subs_d5 s
ON c.cust_id = s.cust_id
),
users AS (
SELECT cohort_month, (sub_month - cohort_month) AS months_since_cohort, COUNT(DISTINCT cust_id) AS active_users FROM cm
WHERE `status` = 'Active'
GROUP BY cohort_month, months_since_cohort
)
SELECT cohort_month, months_since_cohort, active_users
FROM users
ORDER BY cohort_month, months_since_cohort;

-- 5. Revenue by cohort & month_index

WITH cm AS (
SELECT c.cust_id, MIN(sub_month) OVER(PARTITION BY c.cust_id) AS cohort_month, s.sub_month, s.fee
FROM customers_d5 c JOIN subs_d5 s
ON c.cust_id = s.cust_id
)
SELECT cohort_month, (sub_month - cohort_month) AS month_since_cohort, SUM(fee) AS total_revenue
FROM cm
GROUP BY cohort_month,  sub_month;

select * from subs_d5;


-- 6. Retention drop detection (advanced)

WITH monthly_users AS (
SELECT s.sub_month,
	COUNT(DISTINCT c.cust_id) AS active_users
FROM customers_d5 c JOIN subs_d5 s
ON c.cust_id = s.cust_id
WHERE s.`status` = 'Active' GROUP BY s.sub_month
)
SELECT sub_month, active_users,
	LAG(active_users, 1, 0) OVER(PARTITION BY sub_month) AS previous_month_users,
    active_users - LAG(active_users, 1, 0) OVER(ORDER BY sub_month) AS user_change
FROM monthly_users;



-- Business Questions

-- 1. Which cohort is the strongest and why?
-- Cohort 1 is the strongest as we can see that most of the subscribers are still active even though some got cancelled they are back the following months i.e. long term engagement.

-- 2. Where is churn happening fastest — early or later months?
-- Churn can be seen in the earlier months, in the 1st and 2nd months but we can also see that some users have re-subscribed in later months.

-- 3. Which cohort deserves re-activation campaigns?
-- Cohort 2 requires reactivation campaign as there was churn during this month though some users have re-activated.

-- 4. If you are CEO, what would you change based on this data?
-- If I was a CEO, I would set up some kind of subscription bonus like some discount if users would subscribe longer duration, for example - monthly, quarterly and yearly discounts.
