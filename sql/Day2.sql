-- Day 2

-- 1. List region_name, product_name, amount for all sales.

SELECT r.region_name, p.product_name, s.amount FROM regions r
JOIN sales s ON r.region_id = s.region_id
JOIN products1 p ON s.product_id = p.product_id;

-- 2. Total delivered revenue by region.

SELECT r.region_name, SUM(s.amount) AS total_revenue
FROM regions r
JOIN sales s ON r.region_id = s.region_id
WHERE s.`status` = 'Delivered'
GROUP BY r.region_name;

-- 3. For each category, show total revenue.

SELECT p.category, SUM(amount) AS total_revenue FROM products1 p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category;

-- 4. Which product has the highest total revenue?

SELECT p.product_name, SUM(s.amount) total_revenue FROM products1 p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_name
ORDER BY SUM(s.amount) DESC LIMIT 1;

-- 5. Rank regions by total revenue (use RANK() window).

WITH region_revenue AS (
	SELECT r.region_name, SUM(s.amount) AS total_revenue
    FROM regions r JOIN sales s
    ON r.region_id = s.region_id
    GROUP BY r.region_name
)
SELECT region_name, total_revenue,
	RANK() OVER(ORDER BY total_revenue DESC) AS `rank`
FROM region_revenue;    

-- 6. For each region, show cumulative revenue ordered by sale_date.

SELECT r.region_name, s.sale_date,
	SUM(s.amount) OVER(PARTITION BY region_name ORDER BY s.sale_date) AS revenue_by_date
FROM regions r JOIN sales s ON r.region_id = s.region_id;
		
-- 7. Identify sales above the avg sale amount (window AVG()).

SELECT sale_id, amount
FROM sales
WHERE amount > (SELECT AVG(amount) FROM sales);
    
-- 8. For each category, show average revenue and label:
/* “High Value” if avg > 30,000
“Mid Value” if avg between 10,000–30,000
“Low Value” otherwise */

SELECT p.category, AVG(amount) AS avg_amount,
CASE 
	WHEN AVG(s.amount) > 30000 THEN "High Value"
    WHEN AVG(s.amount) BETWEEN 10000 AND 30000 THEN "Mid Value"
    ELSE "Low Value"
END AS label
FROM products1 p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category;



-- Business Questions

-- 1. Which region is the growth priority and why?
/* East should be the growth priority considering it is second most revenue generating region 
and highest revenue generated in Electronics category. This means there is strong demand where business can be scalable if supply improves */

-- 2. Which category deserves discount push?	
-- Electronics already shows strong demand and high revenue, discount can help improve sales and increase volume.

-- 3. Where do we see possible inventory or supply chain risk?
-- Possible risks might be due to out of stock, depending on single vendor, delay in supplies, etc.

-- 4. If we have 1 analyst, where do we deploy and why?
-- East as there is high Electronics demand, to help reduce cancellation and it is a growth region as well.

