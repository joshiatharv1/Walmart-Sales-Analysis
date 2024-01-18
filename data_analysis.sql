CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY, 
branch VARCHAR(5) NOT NULL, 
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL, 
quantity INT NOT NULL, 
VAR FLOAT(6, 4) NOT NULL, 
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL, 
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12,4) NOT NULL,
rating FLOAT(2,1)
);
---- --------------------------------------------------------------------------------------------
----- --------------------------------FEATURE ENGINERING---------------------------------------

-- time_of_day

SELECT 
time,
     (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
        ELSE "Evening"
        
    END
    )AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);


UPDATE sales 
SET time_of_day=(
CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
        ELSE "Evening"
    END
);

-- day_name

SELECT 
      date,
      DAYNAME(date) AS day_name
FROM sales ;


ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales SET day_name=DAYNAME(date);

 -- month_name 
 
 SELECT 
      date,
      MONTHNAME(date)
      FROM sales;
      
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
 
UPDATE sales SET month_name = MONTHNAME(date);
 
      
-- --------------------------------------------------------------------------------------------------
-- -------------------------------------GENERIC-------------------------------------------------

-- How many unique cities does the data have?

SELECT DISTINCT city FROM sales;
SELECT DISTINCT branch FROM sales;

-- In which city is each branch?

SELECT DISTINCT city FROM sales;
SELECT DISTINCT branch FROM sales;

-- --------------------------------------------------------------------------------------------
-- ------------------------------------------PRODUCT-------------------------------------------

-- How many unique product lines does the data have?

SELECT DISTINCT product_line FROM sales;

-- What is the most common payment method?

SELECT payment_method,count(payment_method) AS cnt FROM sales GROUP BY payment_method ORDER BY cnt DESC;
  
-- What is the most selling product line? ---------------------------------------------------

SELECT product_line, count(product_line) as cnt FROM sales GROUP BY product_line ORDER BY cnt DESC;

-- -------------- What is the total revenue by month?--------------------------------------------
-- ----------------------------------------------------------------------------------------------
SELECT month_name AS month, SUM(total) AS total_revenue FROM sales GROUP BY month_name ORDER BY total_revenue DESC;


-- ----------------------What month had the largest COGS?------------------------------------------
-- ------------------------------------------------------------------------------------------------

SELECT month_name AS month,
SUM(cogs) AS cogs
FROM sales GROUP BY month_name
ORDER BY cogs DESC;

-- ----------------------------------What product line had the largest revenue?------------------
SELECT 
product_line ,
SUM(total) AS total_revenue
FROM sales GROUP BY product_line ORDER BY total_revenue DESC;


-- ----------------------------What city has the largest revenue?------------------------------

SELECT branch,city, SUM(total) AS total_revenue FROM sales GROUP BY city, branch ORDER BY total_revenue DESC;
 
-- ---------------------------- What is the city with the largest revenue?----------------------

SELECT city, SUM(total) AS total_revenue FROM sales GROUP BY city ORDER BY total_revenue DESC;

-- ----------------------------What product line had the largest VAT?---------------------------

SELECT product_line, AVG(VAR) as Max_VAT FROM sales GROUP BY product_line ORDER BY MAX_VAT DESC;

-- -Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales---

SELECT
  product_line,
  AVG(total) AS average_sales,
  CASE
    WHEN total > AVG(total) THEN 'Good'
    ELSE 'Bad'
  END AS GOOD_OR_BAD
FROM
  sales
GROUP BY
  product_line, total;
-- --- Which branch sold more products than average product sold?--------------

SELECT branch, SUM(quantity) AS qty FROM SALES GROUP BY branch HAVING SUM(quantity)> (SELECT AVG(quantity) FROM SALES);

-- -------What is the most common product line by gender?--------------------------

SELECT product_line, gender, COUNT(gender) AS cnt from sales GROUP BY gender, product_line ORDER BY cnt DESC;

-- -----------------------What is the average rating of each product line?---------------

SELECT product_line, AVG(rating) AS avg_rating from sales GROUP BY product_line;


-- -------------------------------------------------------------------------------------------
-- ----------------------------------------SALES----------------------------------------------

-- -----Number of sales made in each time of the day per weekday---
SELECT time_of_day, COUNT(*) AS total_sales FROM sales WHERE day_name="Monday" GROUP BY time_of_day ORDER BY total_sales DESC;

-- --------Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS Max_revenue from sales GROUP BY customEr_type ORDER BY Max_revenue DESC;

-- ---------Which city has the largest tax percent/ VAT (Value Added Tax)?----------------------
SELECT city, AVG(VAR) AS VAT from sales GROUP BY city ORDER BY VAT DESC;

-- -------------Which customer type pays the most in VAT?----------------------------------------

SELECT customer_type, AVG(VAR) AS VAT from sales GROUP BY customer_type ORDER BY VAT DESC;
-- ----------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------CUSTOMER---------------------------------------------------------------------

-- ------------------How many unique customer types does the data have?-------------------------------------------------------
SELECT DISTINCT customer_type from sales;

-- ------------------How many unique payment methods does the data have?--------------------------------------------------------
SELECT DISTINCT payment_method from sales;


-- ----------------What is the most common customer type?----------------------------------------------------
SELECT customer_type, COUNT(customer_type) AS cnt from sales GROUP BY customer_type ORDER BY cnt DESC;

-- -------------------Which customer type buys the most?-----------------------------------------------------
SELECT customer_type, SUM(quantity) AS spends_more FROM sales GROUP BY customer_type ORDER BY spends_more DESC;

-- -----------------------What is the gender of most of the customers?--------------------------------------
SELECT gender, COUNT(*) AS cnt from sales GROUP BY gender ORDER BY cnt DESC;


-- -----------------------What is the gender distribution per branch?-----------------------------------------
SELECT gender, COUNT(*) as gender_cnt
FROM SALES WHERE BRANCH="C" GROUP BY gender ORDER BY gender_cnt DESC;

-- -------------------------Which time of the day do customers give most ratings?-----------------------------
SELECT time_of_day, COUNT(rating) AS cnt from sales GROUP BY time_of_day ORDER BY cnt DESC;

-- --------------------------Which time of the day do customers give most ratings per branch?------------------
SELECT time_of_day, COUNT(rating) AS cnt from sales WHERE branch="A" GROUP BY time_of_day ORDER BY cnt DESC;

-- --------------------------Which day fo the week has the best avg ratings?------------------------------------
SELECT day_name, AVG(rating) AS cnt from sales GROUP BY day_name ORDER BY cnt DESC;

-- ---------------------------Which day of the week has the best average ratings per branch?---------------------
SELECT day_name, AVG(rating) AS cnt from sales WHERE branch="A" GROUP BY day_name ORDER BY cnt DESC;
