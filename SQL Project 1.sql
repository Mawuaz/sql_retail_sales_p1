CREATE TABLE retail_sales 
		(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category VARCHAR(15),
			quantiy	INT,
			price_per_unit FLOAT,	
			cogs FLOAT,
			total_sale FLOAT

		)

-- Data Cleaning
SELECT * FROM retail_sales;
SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
			transactions_id	IS NULL
			OR
			sale_date IS NULL
			OR
			sale_time IS NULL
			OR
			gender IS NULL
			OR
			category IS NULL
			OR
			quantiy	IS NULL
			OR
			cogs IS NULL
			OR
			total_sale IS NULL

-- DELETION OF RECORD

DELETE FROM retail_sales
WHERE 
			transactions_id	IS NULL
			OR
			sale_date IS NULL
			OR
			sale_time IS NULL
			OR
			gender IS NULL
			OR
			category IS NULL
			OR
			quantiy	IS NULL
			OR
			cogs IS NULL
			OR
			total_sale IS NULL

-- Data Exploration
-- How many sales we have ?
SELECT COUNT(*)  AS total_sale FROM retail_sales

-- How many unique customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales

-- How many unique categories we have count & data ?
SELECT category, COUNT(*) FROM retail_sales
GROUP BY 1

-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Answers to the problems below :
-- A.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05'

-- A.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * FROM retail_sales WHERE category = 'Clothing' AND quantiy >= '4' AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
SELECT * FROM retail_sales WHERE category = 'Clothing' AND quantiy >= '4' AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' 

-- A.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, sum(total_sale) AS net_sale, count(*) as total_orders FROM retail_sales
GROUP BY 1

-- A.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, ROUND(avg(age), 2) AS avg_age FROM retail_sales GROUP BY 1

-- A.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales WHERE total_sale > '1000'

-- A.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender, category, count(*) as total_trans FROM retail_sales GROUP BY 1,2
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT year, month, average_sale FROM
(
 SELECT 
  EXTRACT(YEAR FROM sale_date) AS year, 
  EXTRACT(MONTH FROM sale_date) AS month, 
  AVG(total_sale) AS average_sale,
  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
 FROM retail_sales GROUP BY 1,2
) t1
WHERE t1.rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT COUNT(*) FROM (SELECT DISTINCT customer_id FROM retail_sales) --155
SELECT
 customer_id, 
 sum(total_sale) as total_sales
FROM retail_sales GROUP BY 1 ORDER BY 2 DESC LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(customer_id)
FROM retail_sales GROUP BY 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT 
CASE 
 WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
 ELSE 'Evening'
END AS shift,
COUNT(transactions_id) as total_orders
FROM retail_sales
GROUP BY 1




