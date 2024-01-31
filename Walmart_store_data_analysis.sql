create database salesdatawalmart;
use salesdatawalmart;

-- Feature Engineering --

-- time_of_day --

select time, ( 
case
	when time between '00:00:00' and '12:00:00' then 'Morning'
	when time between '02:01:00' and '16:00:00' then 'Afternoon'
	else 'Evening'
end) as time_of_day
from saless;

alter table saless add column time_of_day varchar(20);

-- Turn off safe update -- 


update saless
set time_of_day = (
case
	when time between '00:00:00' and '12:00:00' then 'Morning'
	when time between '02:01:00' and '16:00:00' then 'Afternoon'
	else 'Evening'
end
);

-- Adding day_name column --

select date, dayname(date)
from saless;

alter table saless add column day_name varchar(10);

update saless
set day_name = dayname(date);


-- adding month_name column --

select date, monthname(date)
from saless;

alter table saless add column month_name varchar(20);

update saless
set month_name = monthname(date);

-- -------------------------------------------------------------- --
-- ------------------------------Generic------------------------- --
-- -------------------------------------------------------------- --
-- How many unique cities does the data have? --

select count(distinct(city))
from saless;

-- In which city is each branch? --

select distinct(City), branch
from saless;

-- ---------------------------------------------------------------- --
-- ---------------------------------------------------------------- --
-- -------------------------Product-------------------------------- --
-- ---------------------------------------------------------------- --

-- How many unique product lines does the data have? --

select count(distinct(`Product line`)) as No_of_products_line
from saless;

-- What is the most common payment method? --

select payment, count(payment) as count
from saless
group by payment
order by count desc;

-- What is the most selling product line? --

select distinct(`Product line`), count(`Product line`) as count
from saless
group by `Product line`
order by count desc;

-- What is the total revenue by month? --

select sum(total) as total_month_sale, month_name
from saless
group by month_name
order by total_month_sale desc;

-- What month had the largest COGS? --

SELECT 
    month_name AS month, SUM(cogs) per_month_cogs
FROM
    saless
GROUP BY month
order by per_month_cogs desc;

-- What product line had the largest revenue? --

select `Product line`, sum(total) as total_revenue
from saless
group by `Product line`
order by total_revenue desc;

-- What is the city with the largest revenue? --

select city, sum(total) as total_revenue
from saless
group by city
order by total_revenue desc;

-- What product line had the largest VAT? --

select `Product line`, avg(`Tax 5%`) as avg_tax
from saless
group by `Product line`
order by avg_tax desc;

-- Which branch sold more products than average product sold? --

select branch, sum(Quantity) as qty
from saless
group by branch
having qty > avg(Quantity);

-- What is the most common product line by gender? --

select `Product line`,Gender, count(Gender) as qty
from saless
group by Gender,`Product line`
order by qty desc;

-- What is the average rating of each product line? --

select `Product line`, round(avg(Rating),2) as avg_rating
from saless
group by `Product line`
order by avg_rating desc; 

select `Product line`, avg(Quantity),
case 
	when count(Quantity)> avg(Quantity) then 'Good'
    when count(Quantity)< avg(Quantity) then 'Bad'
end as line
from saless
group by `Product line`;

-- ------------------------------------------------------------------ --
-- ------------------------------------------------------------------ --
-- ---------------------------Sales---------------------------------- --
-- ------------------------------------------------------------------ --

-- Number of sales made in each time of the day per weekday --

select time_of_day, count(*) as sales
from saless
group by time_of_day
order by sales desc;

-- Which of the customer types brings the most revenue? --

select `Customer type`, sum(Total) as sales
from saless
group by `Customer type`
order by sales desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)? --

select City, avg(`Tax 5%`) as tax
from saless
group by City
order by tax desc;

-- Which customer type pays the most in VAT? --

select `Customer type`, avg(`Tax 5%`) as tax
from saless
group by `Customer type`
order by tax desc; 

-- -------------------------------------------------------------- --
-- -------------------------------------------------------------- --
-- -----------------------Customer------------------------------- --
-- -------------------------------------------------------------- --

-- How many unique customer types does the data have? --

select distinct(`Customer type`) as customers, count(`Customer type`) as count
from saless
group by customers
order by count desc;

-- How many unique payment methods does the data have? --

select distinct(Payment)
from saless;

-- What is the most common customer type? --

select `Customer type`, count(`Customer type`) as no_of_customers
from saless
group by `Customer type`
order by no_of_customers desc;

-- Which customer type buys the most? --

select `Customer type`, sum(Total) as buying
from saless
group by `Customer type`
order by buying desc;

-- What is the gender of most of the customers? --

select Gender, count(`Customer type`) as count
from saless
group by Gender
order by count desc;

-- What is the gender distribution per branch? --

select Gender, Branch, count(Gender) as count
from saless
group by Gender, Branch
order by Branch;

-- Which time of the day do customers give most ratings? --

select time_of_day, sum(Rating) as rating
from saless
group by time_of_day
order by rating desc;

-- Which time of the day do customers give most ratings per branch? --

select time_of_day,branch,count(Rating) as rating
from saless
group by time_of_day, branch
order by rating desc;

-- Which day of the week has the best average rating? --

select day_name, avg(Rating) as rating
from saless
group by day_name
order by rating desc;

-- Which day of the week has the best average ratings per branch? --

select day_name, branch, avg(rating) as rating
from saless
group by day_name, branch
order by rating;