drop table if exists zepto;
create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice Numeric(8,2),
weightInGms INTEGER,
outofStock BOOLEAN,
quantity INTEGER
);


---- DATA EXPLORATION

---- 1.Count of Rows
select count(*) from zepto;

----2.Sample Data
select * from zepto
limit 10;

---- 3.null Values
select * from zepto
where name is null 
or
category is null 
or
mrp is null 
or
discountPercent is null 
or
discountedSellingPrice is null 
or
weightInGms is null 
or
availableQuantity is null 
or
outofStock is null 
or
quantity is null;

---- 4.Different Product Categories
select distinct category
from zepto
order by category;

---- 5.Products in stock vs Out of stock
select outofStock , count(sku_id)
from zepto
group by outofStock;

---- 6.Product names present multiple times
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

-----Data Cleaning
---- 7.Checking product with price zero
select * from zepto
where mrp=0
and discountedSellingPrice=0;

delete from zepto 
where mrp=0;

---- 8.Convert Paise to Rupees
Update zepto
Set mrp=mrp/100.0,
discountedSellingPrice=discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto;

----Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name mrp, discountPercent from zepto 
order by discountPercent desc 
limit 10;

---- Q2. What are the Products with High MRP but Out of Stock
select distinct name, mrp 
from zepto
where outofStock= TRUE and mrp > 300
order by mrp desc;

----Q3. Calculate Estimated Revenue for each category
select category,
sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue;

----Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name, mrp, discountPercent from zepto
where mrp > 500 and
discountPercent <10
order by mrp desc , discountPercent desc;

----Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,
Round(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

----Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name ,
weightInGms, 
discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms>=100
order by price_per_gram;

----Q7. Group the products into categories like Low, Medium, Bulk.
select distinct name,
weightInGms,
case
    when weightInGms <1000 then 'Low'
	when weightInGms <5000 then 'Medium'
	else 'Bulk'
end as weight_category
from zepto;

----Q8. What is the Total Inventory Weight Per Category
select category ,
sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;













