-- HANDLING THE MISSING DATA --

-- let me look at the facts in the column --
SELECT Item, COUNT(*) AS freqi
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Item
ORDER BY freqi DESC;

-- Calculation of mode(Item)-- NB: Replacing the nulls or '' is about 3.69753477% which is okay --
-- Note the ERROR and UNKNOWN info will be kept --
SELECT
    CASE 
        WHEN Item IS NULL OR Item = '' THEN 'Juice'
    ELSE Item
    END AS Item_name,
    COUNT(*) AS Total_count
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Item_name
ORDER BY Total_count DESC;
-- The above is the clean format that we shall deploy for Item column --

    


-- Calculation of mode (Payment_Method) NB: I wont be using this this is about 31.6% which is statistically significant therefore
-- using mode here isnt a good idea

SELECT Payment_Method, COUNT(*) AS freq
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Payment_Method
ORDER BY freq DESC;
-- How to handle the missing data --
-- null replace with Other
-- ERROR and UNKNOWN change it to 'ERROR_UNKNOWN'



-- Due to the statistical significance--
-- Null will be Other ERROR and UNKNOWN will be ERROR_UNKNOWN --
SELECT 
  CASE
      WHEN Payment_Method IS NULL OR Payment_Method = '' THEN 'Other'
      WHEN Payment_Method = 'ERROR' THEN 'ERROR_UNKNOWN'
      WHEN Payment_Method = 'UNKNOWN' THEN 'ERROR_UNKNOWN'
      ELSE Payment_Method
  END AS Payment_mtd,
  COUNT(*) AS transaction_count
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY 1
ORDER BY transaction_count;

-- Let's check the location out here --
SELECT Location, COUNT(*) AS freqloc
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Location
ORDER BY freqloc DESC;

-- null as Other and ERROR and UNKNOWN as ERROR_UNKNOWN --

SELECT
    CASE 
        WHEN Location IS NULL OR Location = '' THEN 'Other'
        WHEN TRIM(Location) = 'ERROR' OR TRIM(Location) = 'UNKNOWN' THEN 'ERROR_UNKNOWN'
        ELSE Location
    END AS Locationq,
    COUNT(*) AS frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Locationq
ORDER BY frequency DESC;

-- CLEANING FOR NUMERIC COLUMNS ie float64 and int64 --

## Quanity column 
-- value distribution --
SELECT Quantity, COUNT(*) AS frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Quantity
ORDER BY frequency DESC;

-- mode -- 5
SELECT Quantity, COUNT(*) AS frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Quantity
ORDER BY frequency DESC
LIMIT 1;

-- mean -- 3.028463396702...
SELECT 
  AVG(SAFE_CAST(Quantity AS INT64)) AS mean_quantity
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`;

-- median -- 3.0
SELECT  
  DISTINCT PERCENTILE_CONT(SAFE_CAST(Quantity AS INT64), 0.5) OVER() AS median_quantity
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`;

-- for the Quantity where there is missing data we shall use median as the measure of central tendency --
-- since its negatively skewed median isnt as affected by skewness compared to mean --

SELECT 
    CASE 
        WHEN Quantity IS NULL or Quantity = '' OR TRIM(Quantity) = 'ERROR' OR TRIM(Quantity) = 'UNKNOWN' THEN 3
        ELSE CAST(Quantity AS INT64)
    END AS Quantityq,
    COUNT(*) AS frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Quantityq
ORDER BY frequency DESC;

SELECT COUNT(*) FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`; #10,000

-- Price_Per_Unit --
SELECT Price_Per_Unit, COUNT(*) frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Price_Per_Unit
ORDER BY frequency DESC;

-- mode -- 3

SELECT Price_Per_Unit, COUNT(*) frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Price_Per_Unit
ORDER BY frequency DESC
LIMIT 1;

-- Mean -- 2.949984155... approximately 3
 SELECT 
  AVG(SAFE_CAST(Price_Per_Unit AS FLOAT64)) AS meanPPU
 FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`;

-- Median -- 3
SELECT DISTINCT
  PERCENTILE_CONT(SAFE_CAST(Price_Per_Unit AS FLOAT64), 0.5) OVER() AS medianPPU
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`;

-- Here I am going to use 3 -- Its evenly distributed.
-- We shall use the median --
SELECT 
    CASE 
        WHEN Price_Per_Unit IS NULL OR Price_Per_Unit = '' OR Price_Per_Unit = 'UNKNOWN' OR Price_Per_Unit = 'ERROR' THEN 3
        ELSE CAST(Price_Per_Unit AS FLOAT64)
    END AS Price_Per_Unitq,
    COUNT(*) AS frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Price_Per_Unitq
ORDER BY frequency;


-- Total Spent --
SELECT Total_Spent, COUNT(*) AS frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Total_Spent
ORDER BY frequency DESC;

-- mode -- 6
SELECT Total_Spent, COUNT(*) AS frequency
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Total_Spent
ORDER BY frequency DESC
LIMIT 1;


-- mean -- 8.924352....
SELECT 
  AVG(SAFE_CAST(Total_Spent AS FLOAT64)) AS meanTS
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`; 

-- median -- 8.0
SELECT DISTINCT
  PERCENTILE_CONT(SAFE_CAST(Total_Spent AS FLOAT64), 0.5) OVER() AS medianTS
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`;

-- Here since the data is right skewed we use the median that isnt txtremely affected by skewness

-- Handling --
SELECT 
    CASE 
        WHEN Total_Spent IS NULL OR TRIM(Total_Spent) = 'ERROR' OR TRIM(Total_Spent) = 'UNKNOWN' THEN 8.0
        ELSE CAST(Total_Spent AS FLOAT64)
    END AS Total_Spentq,
    COUNT(*) AS freq
FROM `cafe-javas256-493214.dataset_cafe.cafe_sales`
GROUP BY Total_Spentq
ORDER BY freq;




















