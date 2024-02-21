-- Customer Shopping Trend Analyis Data Cleaning and Preparation

  -- 1. Double Checked for duplicate Customer IDs
   
CREATE TEMPORARY TABLE temp_customer_ids AS
SELECT `Customer ID`
FROM customer_shopping_trends
GROUP BY `Customer ID`
HAVING COUNT(*) > 1;

DELETE FROM customer_shopping_trends
WHERE `Customer ID` IN (
    SELECT `Customer ID` FROM temp_customer_ids
);


-- 2. Here I wanted to add a new Region column to our larger table

ALTER TABLE customer_shopping_trends
ADD Region Varchar(25);

-- double checked our join to make sure the right values would be pulled in and that that locations were matching on both tables 

SELECT CST.Location, Region
FROM customer_shopping_trends CST
LEFT JOIN US_Region UR
ON CST.Location = UR.Location;

-- Here is where I update the the new column based off the above join
UPDATE customer_shopping_trends CST
LEFT JOIN US_Region UR 
ON CST.Location = UR.Location
SET CST.Region = UR.Region;

-- 3. Here I wanted to group the ages of our customers into their own categories.

ALTER TABLE customer_shopping_trends
ADD `Age Category` Varchar(40);

-- First double checked ther min and max age to identify the age ranges that I could use.

SELECT MIN(AGE )
FROM customer_shopping_trends;

SELECT MAX(AGE )
FROM customer_shopping_trends;

-- double checked that my case statement would group these correctly
SELECT
    Age,
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '61 and over'
    END AS Age_Category
FROM
    customer_shopping_trends;

-- Updated the column with the new values

UPDATE customer_shopping_trends
SET `Age Category` = 
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN Age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '61 and over'
    END;
    
    -- 4. I wanted to make the discount applied column more descriptive so changed 'Yes' to Discount Appplied and 'No' to 'No Discount Applied'.
    
    -- First needed to modify the column to be able to take more values by updating datatype to VARCHAR with a longer length
    
ALTER TABLE customer_shopping_trends
MODIFY COLUMN `Discount Applied` VARCHAR(40);

UPDATE customer_shopping_trends
SET `Discount Applied` =
    CASE 
        WHEN `Discount Applied` = 'Yes' THEN 'Discount Applied'
        ELSE 'No Discount Applied'
    END;

-- 5. Here I removed the NULL values from table 

DELETE FROM customer_shopping_trends
WHERE `Customer ID` IS NULL;


  