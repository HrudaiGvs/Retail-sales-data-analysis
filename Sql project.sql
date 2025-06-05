-- Retail Sales Analysis
-- CREATE TABLE
CREATE TABLE retail_sales (
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(10),
age INT,
category VARCHAR(25),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);
-- Data Cleaning

select * from retail_sales
where transactions_id is null 
or sale_date is null
or sale_time is null
or quantiy is null 
or cogs is null;

delete from retail_sales
where transactions_id is null 
or sale_date is null
or age is null
or sale_time is null
or quantiy is null 
or cogs is null;

select * from retail_sales;

-- Data exploration
-- 1. Number of sales

select count(*) as total_sales from retail_sales;

--2. Number of customers purchases

select count(distinct customer_id) from retail_sales;

--3. Total categories

select distinct category from retail_sales;

-- Data Analysis & Business key problems & answers

--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05
--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--3.Write a SQL query to calculate the total sales (total_sale) for each category.
--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
--5.Write a SQL query to find all transactions where the total_sale is greater than 1000
--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--8.Write a SQL query to find the top 5 customers based on the highest total sales 
--9.Write a SQL query to find the number of unique customers who purchased items from each category.
--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
---------------------------------------------------------------------------------------------------------------------------------------------------
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05';

--2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales 
where category = 'Clothing' AND quantiy >= 4 AND to_char(sale_date,'yyyy-mm') = '2022-11';

--3.Write a SQL query to calculate the total sales (total_sale) for each category

select category, sum(total_sale) as net_sales,count(*) as total_orders from retail_sales
group by category;

--4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select category, round(avg(age),2) as Average_age from retail_sales
where category = 'Beauty'
group by category;

--5.Write a SQL query to find all transactions where the total_sale is greater than 1000

select * from retail_sales
where total_sale >1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

select category,gender, count(transactions_id) as total_transactions from retail_sales
group by category, gender
order by 1;

--7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from (
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
round(avg(total_sale)) as avg_sale,
rank() over(partition by extract(year from sale_date) order by round(avg(total_sale)) desc) as rank
from retail_sales
group by 1,2
) as t1 where rank = 1;

--8.Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id, sum(total_sale) from retail_sales
group by customer_id
order by 2 desc
limit 5;

--9.Write a SQL query to find the number of unique customers who purchased items from each category.

select category,count(distinct customer_id) as purchased from retail_sales
group by category;

--10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
as
(
select *,
case 
when extract(hour from sale_time) < 12 then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening' 
end as shift
from retail_sales)
select shift, count(*) as total_orders 
from hourly_sale
group by shift
order by 2 desc;
