-- Customer Shopping Trend Analyis Data Exploration

SELECT * FROM customer_shopping_trends;

-- 1.What is the region in  the United States that we sold the most outwear in spring? Midwest Region with $1444 in Sales.

SELECT 
	Region,
    sum(`Purchase Amount USD`) AS Total_Sales
FROM customer_shopping_trends
WHERE Category = 'Outerwear' AND Season = 'Spring'
GROUP BY Region
ORDER BY Total_Sales DESC
;

-- 2. In California what percentage of sales were without discount codes ? 58% of sales at $3267.

WITH CTE1 AS(
		SELECT 
		Location,
		ROUND(((SUM(CASE WHEN `Discount Applied` = 'No Discount Applied' THEN 1 ELSE 0 END) 
		/ COUNT(*)) * 100),0) AS No_Discount_Applied_Percentage
FROM customer_shopping_trends
WHERE Location = 'California' 
GROUP BY Location
),
    
CTE2 AS(
		SELECT 
		Location,
		sum(`Purchase Amount USD`) AS Total_Sales
FROM customer_shopping_trends
WHERE Location = 'California'  AND `Discount Applied` = 'No Discount Applied'
GROUP BY Location
)

SELECT cte1.Location,
	   cte1.No_Discount_Applied_Percentage, 
       cte2.Total_Sales
FROM CTE1 cte1
JOIN CTE2 cte2
ON cte1.Location = cte2.Location
;

-- 3. How many total subscriptions do we have in the 18-30 age category across all regions? Within this age category we have 249 total subscriptions. 

SELECT `Age Category`,
		SUM(CASE WHEN `Subscription Status` = 'Yes' THEN 1 ELSE 0 END ) Total_Subscribtions 
FROM customer_shopping_trends
WHERE `Age Category` = '18-30'
GROUP BY `Age Category`
;		

-- 4. What is the  Number 1 prefered payment method currently ? Credit Card at $40,310

SELECT `Payment Method`,
		sum(`Purchase Amount USD`) AS Total_Sales
FROM customer_shopping_trends
GROUP BY `Payment Method`
ORDER BY Total_Sales DESC 
LIMIT 1;

-- 5. What Percentage of our Sales are from Male versus Female? Males we have 68% at $157,890 compared to Females with 32% at $75,191.
SELECT 
    Gender,
    SUM(`Purchase Amount USD`) AS Total_sales,
    ROUND((SUM(`Purchase Amount USD`) 
    / (SELECT SUM(`Purchase Amount USD`) FROM customer_shopping_trends)) * 100, 0) AS Sales_Percentage
FROM customer_shopping_trends
GROUP BY Gender
;


-- 6. What season had our highest sales ? The answer was Fall with $60,018

SELECT Season,
	   SUM(`Purchase Amount USD`) AS Total_sales
	FROM customer_shopping_trends
    GROUP BY Season
    ORDER BY Total_sales DESC
    ;
    
-- 7. Which Location had the highest sales ? Montanna at $5,784.
    

SELECT Location,
		SUM(`Purchase Amount USD`) AS Location_Total_sales
FROM customer_shopping_trends
GROUP BY Location
ORDER BY Location_Total_sales DESC
LIMIT 1;
 



