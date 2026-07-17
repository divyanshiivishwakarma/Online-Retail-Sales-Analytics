USE online_retail;

-- ONLINE RETAIL SALES ANALYSIS

-- -------------------------------------- --
-- Objective:
-- Analyze business performance using the
-- cleaned retail dataset.

-- Dataset:
-- retail_clean
-- -------------------------------------- --


-- ---------------------------- --
-- SECTION 1: BUSINESS OVERVIEW
-- ---------------------------- --
SELECT * FROM retail_clean;

-- KPI 1: Total Revenue
-- Business Question:
-- How much total revenue did the business generate?

SELECT 
   ROUND(SUM(Quantity*Price),2) AS total_revenue 
FROM retail_clean;

-- Insight:
-- The company generated a total revenue of £17,685,460.64
-- from completed transactions in the analyzed period.


-- KPI 2: Total Orders
-- Business Question:
-- How many completed orders were placed?

SELECT COUNT(DISTINCT Invoice) AS total_orders FROM retail_clean;

-- Insight:
-- The dataset contains 36969 completed customer orders.
-- during the analyzed period.


-- KPI 3: Total Customers
-- Business Question:
-- How many unique customers made purchases?

SELECT COUNT(DISTINCT `Customer ID`) AS total_customers FROM retail_clean;

-- Insight:
-- The business served 5878 unique customers
-- during the analysis period.



-- KPI 4: Average Order Value (AOV)
-- Business Question:
-- What is the average revenue generated per order?

SELECT ROUND(SUM(Quantity*Price)/COUNT(DISTINCT Invoice),2) AS average_order_value FROM retail_clean;

-- Insight:
-- The average order value is £478.39, indicating that each completed
-- order generated approximately £478 in revenue.

-- ------------------------------- --
-- SECTION 2: SALES TREND ANALYSIS
-- ------------------------------- --
-- KPI 1: Monthly Revenue Trend
-- Business Question:
-- How did revenue change month by month?

SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate,'%m/%d/%y %H:%i'),'%Y-%m') AS month, Round(SUM(Quantity*Price),2) AS revenue FROM retail_clean GROUP BY month ORDER BY month ;

-- Insight:
-- Revenue trend can be observed month by month.
-- This analysis helps identify seasonal demand,
-- growth trends, and unusual sales fluctuations.

-- KPI 2: Highest Revenue Month
-- Business Question:
-- Which month generated the highest revenue?

SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate,'%m/%d/%y %H:%i'),'%Y-%m') AS month, Round(SUM(Quantity*Price),2) AS revenue FROM retail_clean GROUP BY month ORDER BY revenue DESC LIMIT 1 ;

-- Insight:
-- November 2010 generated the highest revenue(£1,166,460.02), indicating exceptionally strong
-- performance during that month.

-- KPI 3: Monthly Order Trend
-- Business Question:
-- How many customer orders were placed each month?
SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate,'%m/%d/%y %H:%i'),'%Y-%m') AS month , COUNT(DISTINCT Invoice) AS total_orders FROM retail_clean GROUP BY month ORDER BY month;

-- Insight:
-- Monthly order volume highlights periods of
-- high customer activity and helps identify
-- peak purchasing seasons.

-- KPI 4: Highest Order Month

-- Business Question:
-- Which month received the highest number of customer orders?

SELECT DATE_FORMAT(STR_TO_DATE(InvoiceDate,'%m/%d/%y %H:%i'),'%Y-%m') AS month , COUNT(DISTINCT Invoice) AS total_orders FROM retail_clean GROUP BY month ORDER BY total_orders DESC LIMIT 1;

-- Insight:
-- November 2011 recieved the highest number of customer orders (2657),
-- which represents the period of greatest customer demand.

-- KPI 5:Revenue by Day of Week
-- Business Question:
-- Which day of the week generated the highest revenue?

SELECT DAYNAME(STR_TO_DATE(InvoiceDate,'%m/%d/%y %H:%i')) AS day_name, ROUND(SUM(Price*Quantity),2) AS revenue FROM retail_clean GROUP BY day_name ORDER BY revenue DESC;

-- Insight:
-- Thursday generated the highest revenue (£3,831,174.91),
-- making it the most profitable day of the week. This indicates
-- strong customer purchasing activity on Thursdays and suggests
-- that promotional campaigns, product launches, and inventory
-- replenishment should be prioritized on this day to maximize sales.


-- KPI 6: Orders by Day of Week
-- Business Question:
-- Which weekday received the highest number of customer orders?

SELECT DAYNAME(STR_TO_DATE(InvoiceDate,'%m/%d/%y %H:%i')) AS day_name, COUNT(DISTINCT Invoice) AS total_orders FROM retail_clean GROUP BY day_name ORDER BY total_orders DESC;

-- Insight:
-- Thursday was the busiest weekday with the highest number of customer orders, The busiest weekday can help management
-- allocate staff and improve operational efficiency.


-- KPI 7: Revenue by Hour
-- Business Question:
-- At what time of day does the business generate the most revenue?

SELECT HOUR(STR_TO_DATE(InvoiceDate,'%m/%d/%y %H:%i')) AS hour_of_day, Round(SUM(Quantity*Price),2) AS revenue FROM retail_clean GROUP BY hour_of_day ORDER BY revenue DESC;

-- Insight:
-- The highest revenue (£2,739,126.88) was generated at 12:00 PM,
-- indicating that noon is the most profitable hour of the day.
-- This suggests that customer purchasing activity peaks around midday,
-- making it an ideal time for promotional campaigns, inventory readiness,
-- and ensuring adequate customer support and operational capacity.


-- KPI 8: Orders by Hour
-- Business Question:
-- During which hour do customers place the most orders?

SELECT HOUR(STR_TO_DATE(InvoiceDate,'%m/%d/%y %H:%i')) AS hour_of_day, COUNT(DISTINCT Invoice) AS total_orders FROM retail_clean GROUP BY hour_of_day ORDER BY total_orders DESC;

-- Insight:
-- The highest number of customer orders (6,170) was placed at 12:00 PM,
-- indicating that noon is the busiest purchasing period. This suggests
-- that customers are most active around midday, making it an ideal time
-- for promotional campaigns, website monitoring, and ensuring adequate
-- customer support and inventory readiness.

-- --------------------------- --
-- SECTION 3: PRODUCT ANALYSIS
-- --------------------------- --

-- KPI 1: Top 10 Products by Revenue
-- Business Question: Which products generated the highest revenue?

SELECT StockCode, Description, ROUND(SUM(Price*Quantity),2) AS revenue FROM retail_clean GROUP BY StockCode,Description ORDER BY revenue DESC  LIMIT 10;

-- Insight:
-- "REGENCY CAKESTAND 3 TIER" was the highest revenue-generating
-- product, contributing £285,992.35 in sales. Other products such
-- as "WHITE HANGING HEART T-LIGHT HOLDER" and
-- "PAPER CRAFT, LITTLE BIRDIE" also generated substantial revenue.
-- These products should be prioritized for inventory management,
-- promotional campaigns, and demand forecasting, as they represent
-- the company's strongest revenue drivers.


-- KPI 2: Top 10 Products by Quantity Sold
-- Business Question: Which products sold the highest number of units?

SELECT StockCode, Description, SUM(Quantity) AS total_quanity FROM retail_clean GROUP BY StockCode,Description ORDER BY total_quanity DESC  LIMIT 10;

-- Insight:
-- These products are the most frequently purchased items,
-- with WORLD WAR 2 GLIDERS ASSTD DESIGNS being the most sold item 
-- and should receive high inventory priority to prevent
-- stock shortages.

-- KPI 3: Lowest Selling Products
-- Business Question: Which products sold the fewest units?

SELECT StockCode, Description, SUM(Quantity) AS total_quanity FROM retail_clean GROUP BY StockCode,Description ORDER BY total_quanity ASC  LIMIT 10;

-- Insight:
-- Products with consistently low sales may require
-- pricing adjustments, marketing support, or inventory
-- optimization.


-- KPI 4: Most Expensive Products
-- Business Question: Which products have the highest selling price?

SELECT StockCode, Description, MAX(Price) AS highest_price FROM retail_clean GROUP BY StockCode,Description ORDER BY highest_price DESC  LIMIT 10;

-- Insight:
-- Data suggests Manual has the highest selling price with its price being £10,953.50
-- Premium-priced products contribute to high-value sales
-- and may require targeted marketing toward specific
-- customer segments.

-- KPI 5: Average Selling Price by Product
-- Business Question: What is the average selling price of each product?

SELECT StockCode, Description, Round(AVG(Price),2) AS average_selling_price  FROM retail_clean GROUP BY StockCode,Description ORDER BY average_selling_price DESC  LIMIT 10;

-- Insight:
-- Average selling price helps identify premium
-- products and evaluate pricing consistency.


-- KPI 6: Products Appearing in Most Orders
-- Business Question: Which products appeared in the highest number of customer orders?

SELECT StockCode, Description, COUNT(DISTINCT Invoice) AS total_orders  FROM retail_clean GROUP BY StockCode,Description ORDER BY total_orders DESC  LIMIT 10;

-- Insight:
-- Products appearing in the largest number of customer
-- orders represent consistently popular products across
-- the customer base.

-- ---------------------------- --
-- SECTION 4: CUSTOMER ANALYSIS
-- ---------------------------- --

-- KPI 1: Top 10 Customers by Revenue
-- Business Question: Which customers generated the highest revenue?

SELECT `Customer ID` , ROUND(SUM(Price* Quantity),2) AS revenue FROM retail_clean GROUP BY `Customer ID` ORDER BY revenue DESC LIMIT 10;

-- Insight:
-- Customer ID 18102 was the highest revenue-generating customer,
-- contributing £608,821.65 in total sales during the analysis period.
-- This indicates that a small number of high-value customers contribute
-- significantly to overall revenue. Retaining such customers through
-- loyalty programs, personalized offers, and excellent customer service
-- can help improve long-term business profitability.


-- KPI 2: Customers with Highest Number of Orders
-- Business Question: Which customers placed the highest number of orders?

SELECT `Customer ID` , COUNT(DISTINCT Invoice) AS total_orders FROM retail_clean GROUP BY `Customer ID` ORDER BY total_orders DESC LIMIT 10;

-- Insight:
-- Customer with Customer ID 14911 placed the highest number of orders (398)
-- Customers placing the highest number of orders
-- demonstrate strong loyalty and repeat purchasing
-- behavior.

-- KPI 3: Average Revenue per Customer
-- Business Question: On average, how much revenue does each customer generate? 

SELECT ROUND(SUM(Price* Quantity)/ COUNT(DISTINCT `Customer ID`),2) AS average_customer_value FROM retail_clean ;

-- Insight:
-- Average Revenue generated per customer is £3,008.75 
-- Average customer value helps estimate
-- the expected revenue generated by each
-- customer during the analysis period.


-- KPI 4: Average Order Value per Customer
-- Business Question: Which customers spend the most money per order?

SELECT `Customer ID`,ROUND(SUM(Price*Quantity)/COUNT(DISTINCT Invoice),2) AS avg_order_value FROM retail_clean GROUP BY `Customer ID` ORDER BY avg_order_value DESC LIMIT 10;

-- Insight:
-- Customer with Customer ID 16446 has the highest average order value of £84,236.25
-- Customers with high average order values
-- represent premium buyers who tend to make
-- large purchases in each transaction.

-- KPI 5: Revenue Contribution by Customer
-- Business Question: How much revenue does each customer contribute?

SELECT `Customer ID`, ROUND(SUM(Quantity*Price),2) AS customer_revenue FROM retail_clean GROUP BY `Customer ID` ORDER BY customer_revenue DESC ;

-- Insight:
-- Highest revenue (£608,821.65) was contributed by customer with
-- Customer ID 18102
-- Customer revenue distribution helps identify
-- high-value, medium-value, and low-value customers,
-- supporting customer segmentation strategies.


-- KPI 6: Highest Quantity Purchased
-- Business Question: Which customers purchased the highest number of items?

SELECT `Customer ID`, SUM(Quantity) AS total_quantity FROM retail_clean GROUP BY `Customer ID` ORDER BY total_quantity DESC ;

-- Insight: 
-- Customer with Customer ID 14646 has the highest number of ordered items (367193 items)
-- Customers purchasing the largest quantities
-- may represent wholesale buyers or businesses
-- making bulk purchases.


-- KPI 7: Customer Purchase Frequency
-- Business Question: How frequently does each customer purchase?

SELECT `Customer ID`, COUNT(DISTINCT Invoice) AS purchase_frequency FROM retail_clean GROUP BY `Customer ID` ORDER BY purchase_frequency DESC ;

-- Insight:
-- Customer with Customer ID 14911 has the highest purchase frequency
-- with total of 398 orders.
-- Purchase frequency measures customer loyalty
-- and helps identify repeat customers for
-- retention campaigns.

-- --------------------------- --
-- SECTION 5: COUNTRY ANALYSIS
-- --------------------------- --

-- KPI 1: Revenue by Country
-- Business Question: Which countries generated the highest revenue?

SELECT Country, ROUND(SUM(Price * Quantity),2) AS revenue FROM retail_clean GROUP BY Country ORDER BY revenue DESC ;

-- Insight:
-- United Kingdom generated the highest revenue of £14,666,669.08
-- Countries with the highest revenue represent the
-- company's strongest markets and may offer opportunities
-- for increased investment, marketing, and expansion.

-- KPI 2: Top 10 Countries by Revenue
-- Business Question: Which ten countries generated the highest revenue?

SELECT Country, ROUND(SUM(Price * Quantity),2) AS revenue FROM retail_clean GROUP BY Country ORDER BY revenue DESC LIMIT 10 ;

-- Insight:
-- The top ten countries contribute the majority
-- of international sales and should remain key
-- focus areas for future business growth.

-- KPI 3: Orders by Country
-- Business Question: Which countries placed the highest number of orders?

SELECT Country, COUNT(DISTINCT Invoice) AS total_orders FROM retail_clean GROUP BY Country ORDER BY total_orders DESC ;

-- Insight:
-- United Kingdom placed the highest number of orders (33541)
-- Countries with high order volumes demonstrate
-- strong customer demand and purchasing activity.

-- KPI 4: Customers by Country
-- Business Question: Which countries have the largest customer base?

SELECT Country, COUNT(DISTINCT `Customer ID`) AS total_customers FROM retail_clean GROUP BY Country ORDER BY total_customers DESC ;

-- Insight:
-- The United Kingdom had the largest customer base with 5,350 unique
-- customers, indicating that it is the company's strongest market in
-- terms of customer reach. This suggests a high level of customer
-- engagement and repeat business in the UK. Maintaining customer
-- satisfaction and loyalty in this market while expanding the customer
-- base in other countries could support long-term business growth.

-- KPI 5 :Average Revenue per Order by Country
-- Business Question: Which countries generate the highest average revenue per order?

SELECT Country, ROUND(SUM(Quantity * Price)/COUNT(DISTINCT Invoice),2) AS average_order_value FROM retail_clean GROUP BY Country ORDER BY average_order_value DESC;

-- Insight:
-- Netherlands generates the highest revenue per order (£2,430.84)
-- Countries with high average order values
-- indicate customers who tend to spend more
-- per purchase.


-- KPI 6: Average Revenue per Customer by Country
-- Business Question: Which countries have the highest customer value?

SELECT Country,ROUND(SUM(Quantity * Price)/COUNT(DISTINCT `Customer ID`),2) AS average_customer_value FROM retail_clean GROUP BY Country ORDER BY average_customer_value DESC;

-- Insight:
-- EIRE has the highest cutomer value of £1,24,260.86
-- Countries with high customer value may
-- represent premium markets where customers
-- spend more over time.


-- KPI 7: Quantity Sold by Country
-- Business Question: Which countries purchased the highest number of products?

SELECT Country, SUM(Quantity) AS total_quantity FROM retail_clean GROUP BY Country ORDER BY total_quantity DESC ;

-- Insight:
-- The United Kingdom generated the highest revenue (£8,671,453),
-- making it the company's largest market during the analysis period.
-- This indicates a strong customer base and high purchasing activity
-- in the UK. The business should prioritize inventory planning,
-- customer retention strategies, and targeted marketing campaigns
-- in this region while exploring opportunities to replicate this
-- success in other countries.
