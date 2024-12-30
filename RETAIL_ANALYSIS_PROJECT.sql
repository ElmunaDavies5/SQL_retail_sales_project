-- Data cleaning


SELECT *
FROM retail_analysis AS rns
;


-- Remove Duplicate
-- Standardize the data
-- Null values or blank values 
-- Remove any columns


CREATE TABLE retail_dup
LIKE retail_analysis;

SELECT *
FROM retail_dup
;


INSERT INTO retail_dup
SELECT *
FROM retail_analysis;


SELECT *
FROM retail_dup
WHERE quantiy IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
OR 
transactions_id IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR 
category IS NULL
OR 
 
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

ALTER TABLE retail_dup
RENAME COLUMN ï»¿transactions_id TO transactions_id;

UPDATE retail_dup
SET ï»¿transactions_id = transactions_id;

-- DATA EXPLORATION

-- How many unique customers we have

SELECT COUNT(DISTINCT customer_id) unique_cust
FROM retail_dup;

-- How many sales we have

SELECT COUNT(*)
FROM retail_dup;

-- How many unique category we have

SELECT COUNT(DISTINCT category) unique_cat
FROM retail_dup;

SELECT DISTINCT category
FROM retail_dup
ORDER BY category DESC;

-- Data Analysis & Business Problem & Answer


-- Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_dup
WHERE sale_date = '2022-11-05'
;

-- Write a SQL query to retrieve all transactions where the category is 'Clothinng' and the quantity sold is more than or equal 4 in the month of Novv-2022

SELECT *
FROM retail_dup
WHERE category = 'Clothing' AND
quantiy >= 4 AND
DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
;

-- Write a SQL query to calculate the total sales (total_sale) for each category

SELECT  
category,
SUM(total_sale) AS net_sale, 
COUNT(*) AS total_order
FROM retail_dup
GROUP BY category
ORDER BY category ASC
;

-- Write a SQL query to find the average age of customers who purchased items from the 'beauty' category

SELECT FLOOR(AVG(age)) AS average_age
FROM retail_dup
WHERE category = 'Beauty'
;

-- Write a SQL query to find all transactions where the total sales is greater than 1000

SELECT *
FROM retail_dup
WHERE total_sale > 1000
;

-- Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category

SELECT category, 
gender,
COUNT(transactions_id) total_trans
FROM retail_dup
GROUP BY category, gender
ORDER BY category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH highest_ranking AS
(
SELECT
YEAR(sale_date) AS years,
MONTH(sale_date) AS months,
ROUND(AVG(total_sale),2) AS average_sales,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale),2) DESC) AS ranking
FROM retail_dup
GROUP BY years, months
)
SELECT years,
months,
average_sales
FROM highest_ranking
WHERE ranking = 1;
-- ORDER BY years, average_sales DESC

-- Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id,
SUM(total_sale) net_sales
FROM retail_dup
GROUP BY customer_id
ORDER BY net_sales DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category

SELECT
category,
COUNT(DISTINCT customer_id) unique_customers
FROM retail_dup
GROUP BY category
ORDER BY unique_customers;

-- Write a SQL query to create each shift and number of orders (example morning <= 12, afternoon btw 12 & 17, evening >17)

WITH hourly_sales AS
(
SELECT *,
CASE
WHEN HOUR(sale_time) < 12 THEN 'morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
WHEN HOUR(sale_time) > 17 THEN 'evening'
END AS shift
FROM retail_dup
)
SELECT shift,
COUNT(transactions_id) AS total_orders
FROM hourly_sales
GROUP BY shift
;
-- End of project for now