-- SQL Data Cleaning Script
-- Dataset: Telco Customer Churn
-- July 2025 
-- Purpose: Prepare data for analysis, preserving original null values

/* 
NOTE:
I made the decision to leave NULL values as they are in this dataset. 

Reason: 
- Some NULLs may hold meaning (e.g., services not subscribed to) 
- Imputing or removing them could distort the raw behavior of customers
- I want to maintain data integrity for accurate reporting and modeling

Steps below include checks for: 
- Duplicates 
- Null values 
- Inconsistent formatting 
*/

-- 1. Check for duplicates 
SELECT 
   customerID,
   COUNT(*) 
FROM customer_churn
GROUP BY customerID 
HAVING COUNT(*) > 1;

-- No duplicates found.

-- 2. Check for NULLs in important columns 
SELECT 
  * 
FROM customer_churn 
WHERE customerID IS NULL
OR gender IS NULL
OR tenure_months IS NULL
OR monthly_charges IS NULL
OR churn_reason IS NULL
OR churn_score IS NULL;

-- NULLs exist in some columns but were retained intentionally. 

-- note: 
-- Dataset is preserved in its original state for deeper, transparent analysis. 
