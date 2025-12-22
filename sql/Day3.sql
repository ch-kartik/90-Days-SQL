-- Day-3

-- 1. List all subscriptions with customer name, region, plan, fee.

SELECT c.cust_name, c.region, s.plan, s.fee FROM customers1 c 
JOIN subscriptions s ON c.cust_id = s.cust_id;

-- 2. Total subscription revenue by plan.

SELECT plan, SUM(fee) AS total_subs_revenue
FROM subscriptions
GROUP BY plan
ORDER BY SUM(fee) DESC;

-- 3. Count churn events (status = Cancelled) by region.

SELECT region, COUNT(sub_id) AS count
FROM customers1 c
JOIN subscriptions s ON c.cust_id = s.cust_id
WHERE s.`status` = 'Cancelled'
GROUP BY region;

-- 4. Identify returning customers (customers with >1 subscription).

SELECT c.cust_name AS returning_customers
FROM customers1 c JOIN subscriptions s
ON c.cust_id = s.cust_id
GROUP BY c.cust_name
HAVING COUNT(s.cust_id) > 1 ;

-- 5. Find average fee per region

SELECT region, AVG(fee) AS avg_fee
FROM customers1 c
JOIN subscriptions s
ON c.cust_id = s.cust_id
GROUP BY region 
ORDER BY AVG(fee) DESC;

-- 6. Rank customers by total revenue spent

WITH total_revenue AS (
	SELECT c.cust_name, SUM(s.fee) AS total_revenue_spent
    FROM customers1 c 
    JOIN subscriptions s
    ON c.cust_id = s.cust_id
    GROUP BY c.cust_name
)
SELECT cust_name, total_revenue_spent,
	RANK() OVER(ORDER BY total_revenue_spent DESC) AS `rank`
FROM total_revenue;

-- 7. Identify customers whose total spend > global average spend.

SELECT c.cust_name
FROM customers1 c
JOIN subscriptions s
ON c.cust_id = s.cust_id
GROUP BY c.cust_name
HAVING SUM(fee) > (SELECT AVG(fee) FROM subscriptions);

-- 8. Month-wise cumulative revenue (based on end_date).

SELECT DATE_FORMAT(end_date, '%Y-%m') AS `month`,
	SUM(fee) AS monthly_fee,
	SUM(SUM(fee)) OVER(ORDER BY DATE_FORMAT(end_date, '%Y-%m')) AS cumulative_revenue
FROM subscriptions
GROUP BY DATE_FORMAT(end_date, '%Y-%m');


-- Business Questions

-- 1. Which region is highest churn risk and why?
-- East has the highest churn risk considering the Cancelled and Expired status of subscriptions i.e. 2 and 1 which is more than other regions & only one active subscription. 

-- 2. Which plan is most profitable and should get marketing focus?
-- Gold plan is most profitable. It should get marketing focus as it is in demand considering the active status in latest months and it can be scalable to improve subscriptions.

-- 3. Where do we need retention follow-up?
/* First priority should be Expired as these subscribers could be fastest to recover followed by Cancelled to understand the reason and get feedback. 
Active subscribers should be the last priority to prevent future discontinuation. */

-- 4. If we have 1 analyst, should deploy to retention or acquisition? Why?
-- Deploy analyst to Retention to avoid churn which will affect long term business. Long term matters more than short term acquisition.
