drop table if exists zepto;

create table zepto(
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountpercent NUMERIC(5,2),
    availablequantity INTEGER,
    discountedsellingprice NUMERIC(8,2),
    weightingms INTEGER,
    outofstock BOOLEAN,
    quantity INTEGER
	);

-----------------------------Sample data---------------------------
SELECT * FROM zepto
LIMIT 10;

--Count rows
SELECT COUNT (*) FROM zepto;

--Check Null values
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

--Check different product category
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--Producct in stock and out of sock
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

--Product name present multipletimes
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY COUNT(sku_id)DESC;

---------------------------Data Cleaning---------------------------

--Product with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--Convert mrp from paise to rupee
UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp,discountedsellingprice FROM zepto;


---------------------------Buisness Problems----------------------------------

--Q1.Find the top 10 best value product based on the Discount percentage.

SELECT DISTINCT name,mrp,discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Q2.What are the Products with high mrp but out of stock.

SELECT Distinct category,mrp
FROM zepto
WHERE outofstock = TRUE
ORDER BY (mrp)DESC
LIMIT 10;

--Q3.Calculate estimate revenue for each category.

SELECT category,
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4.Find products where mrp is greater tean 500 and discount < 10%.

SELECT category,mrp,discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
Order by discountpercent;

--Q5.Identify the Top  10 category  offering the highest average discount percentage.

SELECT category,
ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6.Find the price per gram for product above 100g and sort by best value.

SELECT DISTINCT name,weightingms,discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) AS price_per_gm
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_gm;

--Q7.Group the product into category like Low,Medium,Bulk.

SELECT DISTINCT name,weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
	WHEN weightingms < 4000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is total Inventory weight per Category.

SELECT category,
SUM(weightingms * availablequantity) AS inventory_total_weight
FROM zepto
GROUP BY category
ORDER BY inventory_total_weight;


