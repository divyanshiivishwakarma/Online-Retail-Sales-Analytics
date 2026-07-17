USE online_retail;

-- -------------------------------- --
-- SECTION 6: ADVANCED SQL ANALYSIS
-- -------------------------------- --

-- KPI 1: Top Customers using CTE
-- Business Question: Who are the company's top customers by revenue?

WITH customer_revenue AS 
(SELECT `Customer ID`, ROUND(SUM(Price * Quantity),2) AS revenue 
FROM retail_clean 
GROUP BY `Customer ID`)
 SELECT *
 FROM customer_revenue
 ORDER BY revenue DESC LIMIT 10;

-- Insight:
-- Customer with Customer ID 18102 generated the highest revenue (£6,08,821.65).
-- The highest revenue-generating customers contribute
-- a disproportionately large share of total business
-- sales and should be prioritized for customer retention.


-- KPI 2: Customer Revenue Ranking
-- Business Question: What is each customer's revenue ranking?

SELECT  `Customer ID`, ROUND(SUM(Price * Quantity),2) AS revenue , RANK() OVER(ORDER BY ROUND(SUM(Price * Quantity),2) DESC) AS revenue_rank FROM retail_clean GROUP BY `Customer ID`;

-- Insight:
-- Customer ranking helps identify VIP customers
-- for loyalty programs and premium services.


-- KPI 3: Dense Ranking
-- Business Question: Rank customers without skipping numbers.

SELECT  `Customer ID`, ROUND(SUM(Price * Quantity),2) AS revenue , DENSE_RANK() OVER(ORDER BY ROUND(SUM(Price * Quantity),2) DESC) AS revenue_rank FROM retail_clean GROUP BY `Customer ID`;

-- Insight:
-- Dense ranking provides continuous rankings when customers have identical revenues.


-- KPI 4: Row Number
-- Business Question: Give every customer a unique position.

SELECT  `Customer ID`, ROUND(SUM(Price * Quantity),2) AS revenue , ROW_NUMBER() OVER(ORDER BY ROUND(SUM(Price * Quantity),2) DESC) AS row_num FROM retail_clean GROUP BY `Customer ID`;


-- KPI 5: Running Revenue
-- Business Question: How does cumulative revenue grow over time?

WITH monthly_sales AS 
( SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate ,'%m/%d/%y %H:%i'), '%Y-%m') AS month ,
 SUM(Price * Quantity) AS revenue
 FROM retail_clean
 GROUP BY month)
 SELECT month,
 ROUND(revenue,2),
 ROUND(SUM(revenue) OVER(ORDER BY month),2)
 AS cumulative_revenue
 FROM monthly_sales;

-- Insight:
-- Running totals illustrate cumulative business
-- growth throughout the analysis period.


-- KPI 6: Top Product Per Country
-- Business Question: Which product generated the highest revenue in each country?

WITH ranked_products AS(
SELECT Country,
Description,
ROUND(SUM(Price * Quantity),2) AS revenue,
RANK() OVER (PARTITION BY country ORDER BY SUM(Price * Quantity) DESC)
AS product_rank
FROM retail_clean
GROUP BY Country, Description)
SELECT * FROM ranked_products
WHERE product_rank=1;

-- Insight:
-- This gives an information about which product
-- is generating highest revenue in each country.alter


-- KPI 7: Customer Segmentation
-- Business Question: Classify customers according to spending.

WITH customer_sales AS
(SELECT `Customer ID`,
SUM(Price * Quantity) AS revenue
FROM retail_clean
GROUP BY `Customer ID`
)
SELECT 
`Customer ID` , 
ROUND(revenue,2),
CASE 
WHEN revenue >=10000 THEN 'VIP'
WHEN revenue >=5000 THEN 'PREMIUM'
WHEN revenue >=1000 THEN 'REGULAR'
ELSE 'LOW VALUE'
END AS customer_segment
FROM customer_sales
ORDER BY revenue DESC;

-- Insight:
-- Customer segmentation enables targeted
-- marketing strategies and personalized offers
-- based on customer value.

 