-- Day-4

-- 1. Rank customers by total revenue

SELECT c.cust_name,
	SUM(s.fee) AS total_revenue,
    RANK() OVER(ORDER BY SUM(s.fee) DESC) AS `rank`
FROM customers_d4 c
JOIN subs_d4 s
ON c.cust_id= s.cust_id
GROUP BY c.cust_name;

-- 2. Dense_Rank revenue inside each region

SELECT c.region, c.cust_name,
	SUM(s.fee) AS total_revenue,
    DENSE_RANK() OVER(PARTITION BY c.region ORDER BY SUM(s.fee) DESC) AS `dense_rank`
FROM customers_d4 c
JOIN subs_d4 s
ON s.cust_id = c.cust_id
GROUP BY c.region, c.cust_name;

-- 3. Segment customers into 3 revenue buckets

SELECT c.cust_name, SUM(s.fee) AS revenue,
CASE
	WHEN NTILE(3) OVER(ORDER BY SUM(s.fee) DESC) = 1 THEN "High Value"
    WHEN NTILE(3) OVER(ORDER BY SUM(s.fee) DESC) = 2 THEN "Mid Value"
    ELSE "Low Value"
END AS cust_group
FROM customers_d4 c
JOIN subs_d4 s
ON c.cust_id = s.cust_id
GROUP BY c.cust_name;

-- 4. Show each subscription month + fee + previous month fee

SELECT c.cust_id, c.cust_name, s.start_month, s.fee,
	LAG(fee, 1, 0) OVER(PARTITION BY c.cust_id ORDER BY start_month) AS previous_month_fee
FROM customers_d4 c JOIN subs_d4 s
ON c.cust_id = s.cust_id;

-- 5. Month-wise revenue shift using LEAD

WITH monthly_revenue AS (
SELECT start_month, SUM(fee) AS monthly_revenue
FROM subs_d4
GROUP BY start_month
)
SELECT start_month, monthly_revenue,
	LEAD(monthly_revenue, 1, 0) OVER(ORDER BY start_month) AS next_month_revenue
FROM monthly_revenue;

-- 6. Identify customers whose spend dropped this month vs previous

WITH this_month_vs_prev_month AS(
SELECT c.cust_name, s.start_month, s.fee AS current_month_spend, 
	LAG(s.fee, 1, 0) OVER(PARTITION BY c.cust_name ORDER BY s.start_month) AS previous_month_spend
FROM customers_d4 c 
JOIN subs_d4 s
ON c.cust_id = s.cust_id
)
SELECT cust_name, current_month_spend, previous_month_spend
FROM this_month_vs_prev_month WHERE current_month_spend < previous_month_spend;


 -- Business Questions
 
 -- 1. Is churn concentrated in any region? Why does that matter?
 /* As per the given data, there are two cancellation in West and East region and one expiry in North. However, user who cancelled  Silver plan in West 
 in first month has upgraded to Gold in in third month. The user in North had Silver plan got expired however he has nother same plan which is active.
 Considering user inEast, had Gold plan cancelled and downgraded to Bronze plan the nextt month. Considering the limited amount of data, it can be seen 
 that the users aven't given up their subscriptions but changed their plans. It highly matters as it might lead to sudden impact on revenue of the business. */
 
 -- 2. Which plan looks most stable month-over-month?
 -- Both Gold and Silver are preferred by users, however Gold looks has more active months and least drop pattern.
 
 -- 3. Who would you target for an upsell and why?
 /* I would target John to upgrade to Gold from Silver as it can be seen that he is an active user since the first month, also I would target Sara to upgrade 
 to Silver, as she cancelled Gold and moved to Bronze, I would try to explain her the benefits of upgrading plan most probably during festive season to 
 avail discount. */
 
 -- 4. Which customers show declining behavior? How do we save them?
 /* Sara shows declining behavior as the Gold plan was cancelled and Bronze plan was activated. We need to have a discussion with user and understand the reason
 for the downgrade and take feedback. If required we should provide a discount or a voucher so the user prefers to upgrade again. Also offer retention incentives before final cancellation. */
 
