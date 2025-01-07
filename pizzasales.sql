select *
from pizzasales

alter table pizzasales
drop column column17

drop table [Pizza Sales SQL Source]

---Q2
---total sales and revenue analysis

select distinct pizza_category, SUM(quantity) as ttal_qty, sum(total_price) as revenue
from PizzaSales
group by pizza_category

---order analysis by time

select day, month, year,
count(order_id) as orders, sum(total_price) as revenue
from PizzaSales
group by day, month, year
order by day,MONTH asc

---customer purchase behaivour

select distinct order_id,sum(quantity) as qty, sum( total_price) as order_value,
avg(total_price) as avgorder_value
from PizzaSales
group by order_id
order by order_id asc

---Q3
select distinct pizza_category, SUM(quantity) as ttal_qty, sum(total_price) as revenue
from PizzaSales
group by pizza_category

select  distinct size, sum(quantity) as qty
from PizzaSales
group by Size
order by qty desc

---peak sales analysis

select top 2 order_time, sum(quantity) as qty
from PizzaSales
group by order_time
order by qty desc

---Top performers and trend

select top 5  pizza_name, sum(quantity) as qty
from PizzaSales
group by pizza_name
order by qty desc


select TOP 1 pizza_name, sum(quantity) as qty, avg(unit_price) as ave_salesprice
from PizzaSales
group by pizza_name
order by ave_salesprice desc

select month, count(quantity) as qty,
sum(round(total_price,2)) as revenue
from PizzaSales
where year = 2015
group by month
order by revenue desc

--- price and revenue analysis

select  distinct size, concat('$', sum(round(unit_price,2))) as revenue,
concat('$', avg(round(unit_price,2))) as ave_price,
count( size) as volume
from PizzaSales
group by size
order by revenue asc


select distinct order_id,count(quantity) as qty, sum(unit_price) as order_revenue,
avg(unit_price) as ave_orderrevenue
from PizzaSales
group by order_id
Order by qty desc

select  sum(total_price) / count(distinct order_id) as ave_revenue_perorder, day
from PizzaSales
group by day

---Day of the week sales analysis
--- I am not sure what I missed here

select day, count(quantity) as total_volume,
sum(total_price) as total_revenue,
case
		when sum(total_price) > 30000 then 'high'
		when sum(total_price) between 10000 and 20000 then 'moderate'
		else 'low'
			end as Evaluation
from PizzaSales
group by day
order by day asc


WITH DayOfWeekSales AS (
    SELECT 
        DATENAME(WEEKDAY, CAST(order_dateupdated AS DATE)) AS DayOfWeek,
        SUM(total_price) AS TotalSales
    FROM PizzaSales
    GROUP BY DATENAME(WEEKDAY, CAST(order_dateupdated AS DATE))
)

SELECT 
    DayOfWeekSales.DayOfWeek,
    DayOfWeekSales.TotalSales,
    CASE 
        WHEN DayOfWeekSales.TotalSales = (SELECT MAX(TotalSales) FROM DayOfWeekSales) THEN 'Highest Sales'
		WHEN DayOfWeekSales.TotalSales = (SELECT MIN(TotalSales) FROM DayOfWeekSales) THEN 'Lowest Sales'
        ELSE 'Other'
    END AS SalesCategory
FROM DayOfWeekSales
ORDER BY DayOfWeekSales.TotalSales DESC
