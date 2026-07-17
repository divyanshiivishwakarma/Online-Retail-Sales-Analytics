USE online_retail;
SHOW TABLES;
SELECT DATABASE();
SELECT COUNT(*) AS total_rows FROM retail_2009_2010;
SELECT COUNT(*) AS total_rows FROM retail_2010_2011;
-- 2009-2010
-- CHECK FOR MISSING VALUES 
SELECT *  FROM retail_2009_2010 LIMIT 10;
DESC retail_2009_2010;
SELECT
 SUM(Invoice IS NULL) AS missing_invoice,
 SUM(StockCode IS NULL) AS missing_stockcode,
 SUM(Description IS NULL) AS missing_description,
 SUM(Quantity IS NULL) AS missing_quantity,
 SUM(InvoiceDate IS NULL) AS missing_invoicedate,
 SUM(Price IS NULL) AS missing_price,
 SUM(`Customer ID` IS NULL) AS missing_customerid,
 SUM(Country IS NULL) AS missing_country
FROM retail_2009_2010;

-- CHECK FOR DUPLICATES
SELECT Invoice,StockCode,Description,Quantity,InvoiceDate,Price,`Customer ID`,Country,COUNT(*) AS duplicate_count
FROM retail_2009_2010 GROUP BY Invoice,StockCode,Description,Quantity,InvoiceDate,Price,`CUSTOMER ID`,Country HAVING COUNT(*)>1;

-- CHECK NEGATIVE OR ZERO QUANTITY
SELECT COUNT(*) FROM retail_2009_2010 WHERE Quantity<=0;

-- CHECK NEGATIVE OR ZERO PRICES
SELECT COUNT(*) FROM retail_2009_2010 WHERE Price<=0;

-- CHECK CANCELLED INVOICES
SELECT COUNT(*) FROM retail_2009_2010 WHERE Invoice LIKE 'C%';

SELECT COUNT(*) AS cancelled_with_neg_qty FROM retail_2009_2010 WHERE Invoice LIKE 'C%' AND Quantity<0;
SELECT COUNT(*) AS neg_qty_not_cancelled FROM retail_2009_2010 WHERE Invoice NOT LIKE 'C%' AND Quantity<0;
SELECT * FROM retail_2009_2010 WHERE price=0 LIMIT 20;
SELECT * FROM retail_2009_2010 WHERE Quantity < 0 AND Invoice NOT LIKE 'C%' LIMIT 20;

SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        `Customer ID`,
        Country
    FROM retail_2009_2010
    GROUP BY
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        `Customer ID`,
        Country
    HAVING COUNT(*) > 1
) AS dup;

SELECT
    SUM(duplicate_count - 1) AS duplicate_rows
FROM (
    SELECT
        COUNT(*) AS duplicate_count
    FROM retail_2009_2010
    GROUP BY
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        `Customer ID`,
        Country
    HAVING COUNT(*) > 1
) AS dup;

-- DATA QUALITY SUMMARY:
-- Total Rows: 525,461
-- Missing Customer IDs: 107,927
-- Duplicate Groups: 6,418
-- Duplicate Rows: 6,865
-- Quantity <= 0: 12,326
-- Price <= 0: 3,690
-- Cancelled Invoices: 10,206

-- Findings:
-- 10,205 negative quantity records correspond to cancelled invoices.
-- Remaining 2,121 records were investigated and primarily represent
-- inventory adjustments (e.g., damaged goods, stock corrections, or
-- internal movements) rather than customer sales.

CREATE TABLE retail_2009_2010_clean AS
SELECT DISTINCT
Invoice,
StockCode,
Description,
Quantity,
InvoiceDate,
Price,
`Customer ID`,
Country
FROM retail_2009_2010
WHERE Quantity>0 
AND Price>0
AND Invoice NOT LIKE "C%"
AND `Customer ID` IS NOT NULL;

SELECT COUNT(*) FROM retail_2009_2010_clean;
SELECT COUNT(*) FROM retail_2009_2010_clean WHERE Quantity<=0;
SELECT COUNT(*) FROM retail_2009_2010_clean WHERE Price<=0;
SELECT COUNT(*) FROM retail_2009_2010_clean WHERE Invoice LIKE "%C";
SELECT COUNT(*) FROM retail_2009_2010_clean WHERE 'Customer ID' IS NULL;

-- 2010-2011
SELECT * FROM retail_2010_2011 LIMIT 10;
DESC retail_2010_2011;
-- CHECK FOR MISSING VALUES 
SELECT
 SUM(Invoice IS NULL) AS missing_invoice,
 SUM(StockCode IS NULL) AS missing_stockcode,
 SUM(Description IS NULL) AS missing_description,
 SUM(Quantity IS NULL) AS missing_quantity,
 SUM(InvoiceDate IS NULL) AS missing_invoicedate,
 SUM(Price IS NULL) AS missing_price,
 SUM(`Customer ID` IS NULL) AS missing_customerid,
 SUM(Country IS NULL) AS missing_country
FROM retail_2010_2011;

-- CHECK FOR DUPLICATES
SELECT Invoice,StockCode,Description,Quantity,InvoiceDate,Price,`Customer ID`,Country,COUNT(*) AS duplicate_count
FROM retail_2010_2011 GROUP BY Invoice,StockCode,Description,Quantity,InvoiceDate,Price,`CUSTOMER ID`,Country HAVING COUNT(*)>1;

-- CHECK NEGATIVE OR ZERO QUANTITY
SELECT COUNT(*) FROM retail_2010_2011 WHERE Quantity<=0;

-- CHECK NEGATIVE OR ZERO PRICES
SELECT COUNT(*) FROM retail_2010_2011 WHERE Price<=0;

-- CHECK CANCELLED INVOICES
SELECT COUNT(*) FROM retail_2010_2011 WHERE Invoice LIKE 'C%';

SELECT COUNT(*) AS cancelled_with_neg_qty FROM retail_2010_2011 WHERE Invoice LIKE 'C%' AND Quantity<0;
SELECT COUNT(*) AS neg_qty_not_cancelled FROM retail_2010_2011 WHERE Invoice NOT LIKE 'C%' AND Quantity<0;
SELECT * FROM retail_2010_2011 WHERE price= 0 LIMIT 20;
SELECT * FROM retail_2010_2011 WHERE Quantity < 0 AND Invoice NOT LIKE 'C%' LIMIT 20;

SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        `Customer ID`,
        Country
    FROM retail_2010_2011
    GROUP BY
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        `Customer ID`,
        Country
    HAVING COUNT(*) > 1
) AS dup;

SELECT
    SUM(duplicate_count - 1) AS duplicate_rows
FROM (
    SELECT
        COUNT(*) AS duplicate_count
    FROM retail_2010_2011
    GROUP BY
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        `Customer ID`,
        Country
    HAVING COUNT(*) > 1
) AS dup;

-- DATA QUALITY SUMMARY (2010–2011)
-- Total Rows: 541,910
-- Missing Customer IDs: 135,080
-- Missing Descriptions: 1,454
-- Duplicate Groups: 4,879
-- Duplicate Rows: 5,268
-- Quantity <= 0: 10,624
-- Price <= 0: 2,517
-- Cancelled Invoices: 9,288

-- Findings:
-- 9,288 negative quantity records correspond to cancelled invoices.
-- Remaining 1,336 negative quantity records are inventory adjustments
-- (e.g., damaged, lost, stock corrections) with zero price and/or missing customer information.
-- These records will be excluded from sales analysis.

CREATE TABLE retail_2010_2011_clean AS
SELECT DISTINCT
Invoice,
StockCode,
Description,
Quantity,
InvoiceDate,
Price,
`Customer ID`,
Country
FROM retail_2010_2011
WHERE Quantity>0 
AND Price>0
AND Invoice NOT LIKE "C%"
AND `Customer ID` IS NOT NULL;

SELECT COUNT(*) FROM retail_2010_2011_clean;
SELECT COUNT(*) FROM retail_2010_2011_clean WHERE Quantity<=0;
SELECT COUNT(*) FROM retail_2010_2011_clean WHERE Price<=0;
SELECT COUNT(*) FROM retail_2010_2011_clean WHERE Invoice LIKE "%C";
SELECT COUNT(*) FROM retail_2010_2011_clean WHERE 'Customer ID' IS NULL;

DROP TABLE IF EXISTS retail_clean;
CREATE TABLE retail_clean AS
SELECT * FROM retail_2009_2010_clean
UNION ALL
SELECT * FROM retail_2010_2011_clean;

SELECT COUNT(*) FROM retail_clean;
SELECT COUNT(*) FROM retail_clean WHERE quantity<=0;
SELECT COUNT(*) FROM retail_clean WHERE PRICE<=0;
SELECT COUNT(*) FROM retail_clean WHERE Invoice LIKE 'C%';
SELECT COUNT(*) FROM retail_clean WHERE `Customer ID` IS NULL;
SELECT COUNT(*) FROM retail_clean WHERE DESCRIPTION IS NULL;