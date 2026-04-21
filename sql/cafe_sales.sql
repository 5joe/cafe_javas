-- TITLE: Cafe Java Sales Data Cleaning
-- AUTHOR: Ochwo Edrian Jude
-- DESCRIPTION: Standardizes item names, handles missing payment methods,
-- and casts numeric strings for analysis.


-- FINAL CLEANED TABLE --

CREATE OR REPLACE TABLE `cafe-javas256-493214.dataset_cafe.cafe_sales_cleaned` AS
WITH raw_data AS (
  SELECT * FROM `cafe-javas256-493214.dataset_cafe.cafe_sales` 
),

cleaned_data AS (
  SELECT Transaction_ID,
        -- Cleaning strings --
        -- Item --
        CASE 
              WHEN Item IS NULL  OR Item = '' THEN 'Juice' 
              ELSE Item 
        END AS Item_name,
        -- Payemnt Method --
        CASE
              WHEN Payment_Method IS NULL OR Payment_Method = '' THEN 'Other'
              WHEN Payment_Method = 'ERROR' THEN 'ERROR_UNKNOWN'
              WHEN Payment_Method = 'UNKNOWN' THEN 'ERROR_UNKNOWN'
              ELSE Payment_Method
        END AS Payment_mtd,
        --Location --
        CASE 
              WHEN Location IS NULL OR Location = '' THEN 'Other'
              WHEN TRIM(Location) = 'ERROR' OR TRIM(Location) = 'UNKNOWN' THEN 'ERROR_UNKNOWN'
              ELSE Location
        END AS Locationq,
        -- Cleaning numeric columns --
        -- Quantity --
        CASE 
              WHEN Quantity IS NULL or Quantity = '' OR TRIM(Quantity) = 'ERROR' OR TRIM(Quantity) = 'UNKNOWN' THEN 3
              ELSE CAST(Quantity AS INT64)
        END AS Quantityq,
        -- Price Per Unit --
        CASE 
              WHEN Price_Per_Unit IS NULL OR Price_Per_Unit = '' OR Price_Per_Unit = 'UNKNOWN' OR Price_Per_Unit = 'ERROR' THEN 3
              ELSE CAST(Price_Per_Unit AS FLOAT64)
        END AS Price_Per_Unitq,
        -- Total Spent
        CASE 
              WHEN Total_Spent IS NULL OR TRIM(Total_Spent) = 'ERROR' OR TRIM(Total_Spent) = 'UNKNOWN' THEN 8.0
              ELSE CAST(Total_Spent AS FLOAT64)
        END AS Total_Spentq,

        -- Cleaning Date
        SAFE.PARSE_DATE('%Y-%m-%d', SAFE_CONVERT_BYTES_TO_STRING(CAST(Transaction_Date AS BYTES))) AS transaction_date
  FROM raw_data
)

SELECT * FROM cleaned_data
WHERE `TRANSACTION_ID` IS NOT NULL;














