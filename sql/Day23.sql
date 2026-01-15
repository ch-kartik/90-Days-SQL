-- Day 23 - Funnel, Conversion & Drop-off Analysis

-- 1. Funnel count per stage

SELECT event_type, COUNT(DISTINCT user_id) AS user_count
FROM funnel_events_d23
GROUP BY event_type;

-- 2. Conversion rate between stages

WITH user_conversion AS (
    SELECT 
        user_id,
        MAX(CASE WHEN event_type = 'visit' THEN 1 ELSE 0 END) AS visited,
        MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) AS signed_up,
        MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END) AS trial_started,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM funnel_events_d23
    GROUP BY user_id
)
SELECT 
    'Visit' AS from_stage,
    'Signup' AS to_stage,
    COUNT(CASE WHEN signed_up = 1 THEN 1 END) * 1.0 /
    COUNT(CASE WHEN visited = 1 THEN 1 END) AS conversion_rate
FROM user_conversion
UNION ALL
SELECT 
    'Signup' AS from_stage,
    'Trial' AS to_stage,
    COUNT(CASE WHEN trial_started = 1 THEN 1 END) * 1.0 /
    COUNT(CASE WHEN signed_up = 1 THEN 1 END) AS conversion_rate
FROM user_conversion
UNION ALL
SELECT 
    'Trial' AS from_stage,
    'Purchase' AS to_stage,
    COUNT(CASE WHEN purchased = 1 THEN 1 END) * 1.0 /
    COUNT(CASE WHEN trial_started = 1 THEN 1 END) AS conversion_rate
FROM user_conversion;	

-- 3. Identify drop-off users

SELECT user_id, 
	CASE 
    WHEN MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) = 1 
			AND MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END)  = 0
			AND MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 0 THEN 'Signup'
    WHEN MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) = 1
             AND MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END) = 1
             AND MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 0 THEN 'Trial'
    END AS drop_off_stage
FROM funnel_events_d23
GROUP BY user_id
HAVING ( MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) = 1 
			AND MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END)  = 0
			AND MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 0)
		OR ( MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) = 1 
			AND MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END)  = 1
			AND MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 0);


-- 4. Funnel completion flag per user

SELECT user_id,
	CASE
	WHEN MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) = 1
			AND MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END)  = 1
			AND MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 1 THEN 'Converted'
	WHEN MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) = 1
			AND MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END)  = 0
			AND MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 0 THEN 'Dropped After Signup'
	WHEN MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) = 1
             AND MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END) = 1
             AND MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 0 THEN 'Dropped After Trial'
	ELSE 'Only Visited'
    END AS funnel_status
FROM funnel_events_d23
GROUP BY user_id;

-- 5. Funnel leakage %

WITH user_conversion AS (
SELECT user_id, 
	MAX(CASE WHEN event_type = 'visit' THEN 1 ELSE 0 END) AS visited,
	MAX(CASE WHEN event_type = 'signup' THEN 1 ELSE 0 END) AS signed_up,
	MAX(CASE WHEN event_type = 'trial' THEN 1 ELSE 0 END) AS trial_started, 
	MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
FROM funnel_events_d23
GROUP BY user_id
)
SELECT
    'Visit' AS stage,
    COUNT(CASE WHEN visited = 1 AND signed_up = 0 THEN 1 END) * 1.0 /
    COUNT(CASE WHEN visited = 1 THEN 1 END) AS drop_off_percentage
FROM user_conversion
UNION ALL
SELECT
    'Signup' AS stage,
    COUNT(CASE WHEN signed_up = 1 AND trial_started = 0 THEN 1 END) * 1.0 /
    COUNT(CASE WHEN signed_up = 1 THEN 1 END) AS drop_off_percentage
FROM user_conversion
UNION ALL
SELECT
    'Trial' AS stage,
    COUNT(CASE WHEN trial_started = 1 AND purchased = 0 THEN 1 END) * 1.0 /
    COUNT(CASE WHEN trial_started = 1 THEN 1 END) AS drop_off_percentage
FROM user_conversion;


-- Business Questions

-- 1. If most users drop between signup → trial, what could that indicate?
-- It shows that users are not impressed with the onboarding process, misleading marketing than the actual product, communication and clarity issues.

-- 2. Which metric here would you prioritize improving first, and why?
-- Improve the stage with high drop-off and has many users. This will have huge impact on overall revenue or retention.

-- 3. How would Product, Marketing, and RevOps each use this funnel differently?
/* Product team focuses on improving user experience, Marketin team tries to increase acquistion and campaign performance, and RevOps team will focus on improving 
revenue growth and efficiency. */

-- 4. If purchase conversion is high but traffic is low, what’s the growth lever?
-- Primary growth lever when purchasing conversion is high but traffic is low is increasing raffic.

-- 5. What extra data would you want to make this analysis stronger?
-- Revenue details, user level attibutes like country, industry, etc. 