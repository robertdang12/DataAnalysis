use customer;

ALTER TABLE customers -- easier to work with a column that doesn't have name of a keyword
RENAME COLUMN Date to Transaction_date; 

UPDATE customers
SET Transaction_date = str_to_date(Transaction_date, "%m/%d/%Y"); 
						-- adjusting date to standard SQL format

ALTER TABLE customers
MODIFY Transaction_date DATE; -- change date datatype from TEXT to DATE
ALTER TABLE customers
DROP COLUMN Column1; -- data cleaning; drop empty column

ALTER TABLE customers
ADD Profit int;  -- adding a column to calculate profit of each transaction
UPDATE customers
SET Profit = revenue - cost;

ALTER TABLE customers
ADD Unit_Margin float;    -- column to determine profitability of each unit
UPDATE customers                
SET Unit_Margin = `Unit Price` - `Unit Cost`;

-- What is the gender distribution?
SELECT `Customer Gender`, COUNT(*) AS Purchase_Count
FROM CUSTOMERS
group by `Customer Gender` 
order by `Customer Gender`;

select min(`customer age`) from customers; -- 17
select max(`customer age`) from customers; -- 87

-- What is the age distribution (by age groups)?
SELECT CASE
		WHEN `customer age` BETWEEN 17 AND 24 THEN '17-24' 
		WHEN `customer age` BETWEEN 25 AND 34 THEN '25-34'
		WHEN `customer age` BETWEEN 35 AND 44 THEN '35-44'  
        WHEN `customer age` BETWEEN 45 AND 54 THEN '45-54'
        WHEN `customer age` BETWEEN 55 AND 64 THEN '55-64'
        WHEN `customer age` BETWEEN 65 AND 74 THEN '65-74'
        WHEN `customer age` >= 75 THEN '75+'
END AS AgeGroup, count(*) as purchases_count
FROM customers
group by AgeGroup
order by AgeGroup;

-- What is the revenue total by age group?
SELECT CASE
		WHEN `customer age` BETWEEN 17 AND 24 THEN '17-24'
		WHEN `customer age` BETWEEN 25 AND 34 THEN '25-34'
		WHEN `customer age` BETWEEN 35 AND 44 THEN '35-44'
        WHEN `customer age` BETWEEN 45 AND 54 THEN '45-54'
        WHEN `customer age` BETWEEN 55 AND 64 THEN '55-64'
        WHEN `customer age` BETWEEN 65 AND 74 THEN '65-74'
        WHEN `customer age` BETWEEN 75 AND 87 THEN '75-87'
END AS AgeGroup, ROUND(AVG(`revenue`),2) as 'average_revenue'
FROM customers
group by AgeGroup 
order by AgeGroup;


-- How many customers are in each country?
SELECT `country`, count(country) as country_count
FROM customers
group by `country`
order by country_count desc;

#What is the profitability of sales of each country?
SELECT `country`, 
		AVG(revenue) as avg_revenue, 
        SUM(Revenue) as total_revenue, 
		AVG(cost) as avg_cost, 
        sum(cost) as total_cost,
        sum(profit) as total_profit, 
	round(avg(unit_margin),2) as avg_margins
from customers
group by `country`;

#What states in the United States have the most customers?
SELECT `state`, count(state) as state_count
FROM customers
WHERE `country` = 'United States'
group by `state`
order by state_count desc; 

-- What are the monthly trends in revenue?
SELECT `Year`, `Month`, ROUND(AVG(`revenue`),2) as average_revenue
from customers
WHERE year = '2015'
group by `month` 
order by average_revenue desc;

#Total revenue 2015
SELECT `Year`, `Month`, FORMAT(SUM(`revenue`), 0) as total_revenue
from customers
WHERE `Year` = 2015
group by `month` 
order by total_revenue desc;

#Total revenue 2016
SELECT `Year`, `Month`, SUM(`revenue`) as total_revenue
from customers
WHERE `year` = 2016
group by `month`
order by total_revenue desc;


#What country has the most profitable margins?
SELECT `country`, `product category`, round(avg(unit_margin),2) as mean_margin
FROM customers
group by `country`, `product category`
order by mean_margin desc;

-- What are the most profitable subcategories?
SELECT
    `Product Category`,
    `Sub Category`, 
	SUM(`Quantity`) AS total_quantity_sold,
    SUM(`Profit`) AS total_profit
FROM customers
GROUP BY `Product Category`, `Sub Category`
ORDER BY total_profit DESC;

#What are the most popular subcategories?
SELECT
    `Product Category`,
    `Sub Category`,
    SUM(`Quantity`) AS total_quantity_sold
FROM customers
GROUP BY `Product Category`, `Sub Category`
ORDER BY total_quantity_sold DESC;

#What are the most popular sub categories by age group?
SELECT
    age_group,
    `product category`,  
	`sub category`,
    count(*) AS category_count
FROM (
    SELECT
        CASE
		WHEN `customer age` BETWEEN 17 AND 24 THEN '17-24' 
		WHEN `customer age` BETWEEN 25 AND 34 THEN '25-34'
		WHEN `customer age` BETWEEN 35 AND 44 THEN '35-44'  
        WHEN `customer age` BETWEEN 45 AND 54 THEN '45-54'
        WHEN `customer age` BETWEEN 55 AND 64 THEN '55-64'
        WHEN `customer age` BETWEEN 65 AND 74 THEN '65-74'
        WHEN `customer age` >= 75 THEN '75+'
        END AS age_group,
        `product category`,
        `sub category`
    FROM customers
) AS age_category
GROUP BY age_group, `product category`,`sub category`
ORDER BY age_group, category_count DESC;





