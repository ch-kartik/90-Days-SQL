-- Day 7

-- 1. Funnel count per stage

SELECT stage, COUNT(DISTINCT lead_id) AS users_count
FROM funnel_events_d7
GROUP BY stage;

-- 2. Lead source → Paid conversion

SELECT l.lead_source, COUNT(DISTINCT l.lead_id) AS total_leads, COUNT(r.lead_id) AS paid_users
FROM leads_d7 l LEFT JOIN revenue_d7 r
ON l.lead_id = r.lead_id
GROUP BY l.lead_source;

-- 3. Conversion rate per stage

WITH user_count_per_stage AS (
SELECT stage, COUNT(DISTINCT lead_id) AS user_count
FROM funnel_events_d7
GROUP BY stage
),
signup_users AS (
SELECT stage, COUNT(DISTINCT lead_id) AS signup_user_count
FROM funnel_events_d7
WHERE stage = 'Signup'
)
SELECT u.stage, u.user_count, ROUND((u.user_count / s.signup_user_count) * 100, 2) AS conversion_rate
FROM user_count_per_stage u
CROSS JOIN signup_users s;

-- 4. Drop-off analysis

WITH count_per_stage AS (
SELECT stage, 
	COUNT(DISTINCT lead_id) AS users_count,
    CASE stage
		WHEN 'Signup' THEN 1
        WHEN 'Trial' THEN 2
        WHEN 'Paid' THEN 3
	END AS stage_order
FROM funnel_events_d7
GROUP BY stage
), 
prev_stage AS (
SELECT stage, users_count, 
	LAG(users_count) OVER(ORDER BY stage_order) AS prev_stage_users
FROM count_per_stage
)
SELECT stage, (prev_stage_users - users_count) AS drop_users 
FROM prev_stage;

-- 5. Revenue by lead source

SELECT l.lead_source, SUM(revenue) AS total_revenue,
	DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM leads_d7 l JOIN revenue_d7 r
ON l.lead_id = r.lead_id
GROUP BY l.lead_source;

-- Business Questions

-- 1. Which stage needs the most improvement and why?
/* Paid stage needs the most improvement as it is observed that conversion rate is just 37.5 which is very less compared to Signup and Trial.
This shows significant drop before monetization, whichindicates that we need to understand if pricing is the issue or the value.*/

-- 2. Should the company invest more in Ads, Organic, or Referral?
/* The company should invest more in Organic as it has most paid users compared to Ads and Referral, this shows that users are willing to pay for it and it needs to be scaled.
 However, Ads also need optimization. */
 
-- 3. Is revenue loss coming more from poor conversion or low traffic?
-- Revenue loss is coming from both poor conversion and low traffic as it is seen that out of the users who signed up, only few are willing to try and very less numbers have paid.

-- 4. If you had one quarter to improve numbers, what would you fix first?
/* I will start with the Trial users in understanding and getting feedback about the services and if they would move to the paid subscription or the reason they are not willing to. 
I would focus on encouraging existing users for referral by providing additional perks like vouchers/discounts based on the increase in sales. 
Also investment in Ads should be done as there is a scope to increase revenue with it. */

