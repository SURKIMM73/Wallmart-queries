 SELECT *FROM [WalmartSalesData.csv]

SELECT *,
    CASE
        WHEN CAST(Time AS TIME) >= '05:00:00' AND CAST(Time AS TIME) < '12:00:00' THEN 'Morning'
        WHEN CAST(Time AS TIME) >= '12:00:00' AND CAST(Time AS TIME) < '17:00:00' THEN 'Afternoon'
        WHEN CAST(Time AS TIME) >= '17:00:00' AND CAST(Time AS TIME) < '21:00:00' THEN 'Evening'
        ELSE 'Night'
    END AS "Time of the day"
FROM [WalmartSalesData.csv]

select *,
datename(weekday,cast(Date as date))as "Day of the week"
from [WalmartSalesData.csv];

select *,
datename(month,cast(Date as date)) as "Month"
from [WalmartSalesData.csv];

--HOW MANY UNIQUE CITIES ARE THERE
select city, count(distinct city) as "Total cities"
from [WalmartSalesData.csv];

--IN WHICH CITY IS EACH BRANCH 
select distinct branch,city
from [WalmartSalesData.csv]
order by branch;

--HOW MANY UNIQUE PRODUCT LINES ARRE THERE
select count (distinct product_line) "TOTAL "
from [WalmartSalesData.csv];

-- WHAT IS THE MOST COMON PAYMENT METHOD 
Select payment,count(Payment) as"Payment count",
rank() over( order by count(*) desc) "Payment rank" 
from [WalmartSalesData.csv]
group by payment
order by 'payment rank';

--what is the most selling product line
select top 1 product_line, sum(quantity) "Total sold",
rank() over(order by sum(quantity)) as "quantity rank"
from [WalmartSalesData.csv]
group by Product_line
order by 'quantity rank'; 

--WHAT IS THE TOTAL REVENUE BY MONTH
select DATENAME(MONTH,cast(date as date)) as Month,sum(unit_price *Quantity) as revenue,
rank() over(order by sum(unit_price * Quantity) desc) as "revenue Rank"
from  [WalmartSalesData.csv]
group by DATENAME(MONTH,cast(date as date));

---WHAT MONTH HAD THE LARGEST COGS
select datename(Month,cast(date as date)) as month,sum (cogs) As "Monthly cogs",
rank() over (order by sum(cogs) desc) as "Cogs rank"
from [WalmartSalesData.csv] 
group by datename(Month,cast(date as date))

--WHAT PRODUCT LINE HAD THE LARGEST REVENUE
select product_line,sum(unit_price * quantity) as revenue,
rank() over (order by sum(unit_price * quantity) desc) as "Revenue rank "
from  [WalmartSalesData.csv]
group by Product_line

--WHICH  CITY HAS THE LARGEST REVENUE
select city,sum(unit_price*quantity)as "Total revenue" ,
rank () over(order by sum(unit_price *quantity) desc) as "Revenue rank"
from [WalmartSalesData.csv]
group by city;

--WHAT PRODUCT LINE HAS THE LARGEST VAT 
select top 1 product_line,sum(tax_5) as "Total VAT"
from [WalmartSalesData.csv]
group by Product_line
order by sum(tax_5) desc;



--FETCH EACH PRODUCT LINE AND ADD COLUMN TO THOSE PRODUCT LINE SHOWING GOOD , BAD GOOD IF ITS GREATER THAN AVERAGE SALES 
select  distinct product_line,
       case 
	       when (unit_price * quantity) > AVG(unit_price * quantity) then 'Good'
		   else 'Bad'
       end as category 
from [WalmartSalesData.csv]
group by product_line,Quantity, unit_price;


--WHICH BRACH SOLD MORE PRODUCTSS THAN THE AVERAGE PRODUCT SOLD 
WITH BranchSales AS (
    SELECT 
        branch, 
        SUM(quantity) AS total_quantity_sold
    FROM 
        [WalmartSalesData]
    GROUP BY 
        branch
), AverageSales AS (
    SELECT 
        AVG(total_quantity_sold) AS average_quantity_sold
    FROM 
        BranchSales
)
SELECT 
    bs.branch,
    bs.total_quantity_sold,
    avs.average_quantity_sold
FROM 
    BranchSales bs, 
    AverageSales avs
WHERE 
    bs.total_quantity_sold > avs.average_quantity_sold;


--WHAT IS THE MOST COMMON PRODUCT BY GENDER 
select product_line, gender,count(product_line)
from [WalmartSalesData.csv]
group by product_line, gender
order by count(product_line)

--WHAT  IS THE AVERAGE RATING OF EACH PRODUCT_LINE
select product_line,AVG(rating) as rtn
from [WalmartSalesData.csv]
group by product_line
order by AVG(rating) desc

