-- 02_exploration.sql
-- Purpose: Explore key patterns and insights in customer churn behavior using SQL.

-- 1. Churn Count
SELECT churn_label, COUNT(*) AS customer_count
FROM customer_churn
GROUP BY churn_label
ORDER BY customer_count DESC;

-- 2. Churn by Gender
SELECT gender, churn_label, COUNT(*) AS count
FROM customer_churn
GROUP BY gender, churn_label
ORDER BY gender, churn_label;

-- 3. Churn by Internet Service Type
SELECT internet_service, churn_label, COUNT(*) AS count
FROM customer_churn
GROUP BY internetservice, churn
ORDER BY internetservice, churn;

-- 4. Average Monthly Charges by Churn Status
SELECT churn, ROUND(AVG(monthly_charges), 2) AS avg_monthlycharges
FROM customer_churn
GROUP BY churn;

-- 5. Churn Rate by Contract Type
SELECT contract, 
       COUNT(*) AS total_customers,
       SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
       ROUND(SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM customer_churn
GROUP BY contract
ORDER BY churn_rate DESC;

-- 6. Churn by Payment Method
SELECT payment_method, churn, COUNT(*) AS count
FROM customer_churn
GROUP BY payment_method, churn
ORDER BY payment_method, churn;

-- 7. Churn by Tenure Groups
SELECT
  CASE
    WHEN tenure_months BETWEEN 0 AND 12 THEN '0-12 months'
    WHEN tenure_months BETWEEN 13 AND 24 THEN '13-24 months'
    WHEN tenure_months BETWEEN 25 AND 48 THEN '25-48 months'
    WHEN tenure_months > 48 THEN '48+ months'
  END AS tenure_group,
  churn,
  COUNT(*) AS count
FROM customer_churn
GROUP BY tenure_group, churn
ORDER BY tenure_group, churn;
