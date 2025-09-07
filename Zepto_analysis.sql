create database zepto_sql_project;
use zepto_sql_project;
drop table if exists zepto;

CREATE TABLE zepto (
  sku_id INT AUTO_INCREMENT PRIMARY KEY,
  Category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp DECIMAL(8,2),
  discountPercent DECIMAL(5,2),
  availableQuantity INT,
  discountedSellingPrice DECIMAL(8,2),
  weightInGms INT,
  outOfStock ENUM('True','False'),
  quantity INT
);

-- Data exploration
-- sample data
select * from zepto limit 10;

-- null values
select * from zepto
where name is null 
or category is null
or mrp is null
or discountPercent is null
or availableQuantity is null
or discountedSellingPrice is null
or WeightInGms is null
or OutOfStock is null
or quantity is null;

-- different product categories
select distinct category
from zepto
order by category;

-- Products in stock vs out of stock
select OutOfStock, COUNT(sku_id)
from zepto
group by OutOfStock;

-- product names present multiple times
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

-- Data Cleaning

-- Product with price = 0
select * from zepto
where mrp =0 or discountedSellingPrice =0;

set sql_safe_updates= 0;
Delete from zepto
where mrp=0;

-- convert paise to rupees
update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto;

-- Q1.Find the top 10 best-value products based on the discount percevtage
select name, mrp, discountPercent
from zepto
order by discountPercent DESC
limit 10;

-- Q2.What are the products with high MRP but Out of stock
select distinct name ,mrp from zepto
where outofstock=True and mrp >300
order by mrp desc;

-- Q3.Calculate Estimated Revenue for each category
select category,
sum(discountedSellingPrice * availableQuantity) as Total_Revenue
from zepto group by category order by total_revenue;

-- Q4.Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name, mrp,discountPercent
from zepto
where mrp>500 and discountPercent<10
order by mrp desc, discountpercent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category, round(avg(discountpercent),2) as Avg_discount
from zepto 
group by category
order by Avg_discount Desc
limit 5;

-- Q6. Find the price per gram for prodcuts above 100g and sort by best value.
select DISTINCT name, weightingms, discountedSellingprice,
round(discountedSellingPrice/weightIngms,2) as Price_per_gram
from zepto
where weightingms >= 100 order by price_per_gram;

-- Q7.Group the products into categories like low, Medium ,Bulk.
select distinct name, weightInGms,
case when weightInGms < 1000 then 'Low'
when weightInGms < 5000 then 'Medium'
else 'Bulk'
END AS weight_category
from zepto;

-- Q8. What is the total inventory weight per catgeory
select category,
sum(weightingms * availableQuantity) as Total_weight
from zepto
group by category 
order by Total_weight;

-- Q9. Most Expensive products per category
SELECT category, MAX(mrp) AS Max_MRP
FROM zepto
GROUP BY category
ORDER BY Max_MRP DESC;