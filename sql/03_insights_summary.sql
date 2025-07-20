# SQL 3: Real-World SQL Questions for Customer Churn Dataset

---

## 1. Basic Data Overview

### Q1: How many total customers are in the dataset?
SELECT 
  churn_label, 
  COUNT(*) AS customer_count
FROM 
  customer_churn
GROUP BY churn_label;

### Q2: How many customers have churned vs. not churned?
SELECT churn_label, COUNT(*) AS customer_count
FROM customer_churn
GROUP BY churn_label;

## 2. Customer Demographics

### Q3: What is the distribution of customers by gender?
SELECT 
   gender,
   COUNT (*) gender_count
FROM 
   customer_churn
GROUP BY gender;

### Q4: -How many senior citizens are customers, and how many of them churned?
SELECT
  COUNT(*) AS total_senior_customers,
  COUNT(CASE WHEN churn_label = 'Yes' THEN 1 END) AS senior_citizen_churned
FROM 
  customer_churn
WHERE (senior_citizen) = 'Yes';

### Q5: Which city has the highest number of customers?
SELECT 
   city,
   COUNT(*) num_customers
FROM 
   customer_churn
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

## 3. Service Usage

### Q6: How many customers use each type of internet service?
SELECT
   internet_service,
   COUNT(*) num_customers
FROM 
   customer_churn
GROUP BY 1
ORDER BY 2 DESC;

### Q7: What percentage of customers have phone service but no internet service?
SELECT 
  ROUND(
    (COUNT(*) FILTER (WHERE phone_service = 'Yes' AND internet_service = 'No') * 100.0) 
    / COUNT(*), 2
  ) AS percentage_phone_no_internet
FROM customer_churn;

### Q8: How many customers have multiple lines? How many of them churned?
SELECT
  COUNT(*) cst_multiple_lines,
  COUNT(CASE WHEN churn_label = 'Yes' THEN 1 END) multiple_lines_churned
FROM 
  customer_churn
WHERE multiple_lines = 'Yes';

## 4. Billing and Payment 

### Q9: What is the average monthly charge per customer?
SELECT ROUND(AVG(monthly_charges)::numeric, 2) AS avg_monthly_charges
FROM customer_churn;

### Q10: What is the total revenue from customers who have not churned?
SELECT 
   SUM(total_charges) AS total_revenue_not_churned
FROM 
   customer_churn
WHERE 
   churn_label = 'No';

### Q11: Which payment method is most popular among customers who churned?
SELECT 
   payment_method,
   COUNT(*) AS num_churned
FROM 
   customer_churn
WHERE 
   churn_label = 'Yes'
GROUP BY 
   payment_method
ORDER BY 
   num_churned DESC
LIMIT 1;

## 5. Customer Behavior and Churn

### Q12: What is the average tenure (months as a customer) of churned vs. non-churned customers?
SELECT 
   churn_label,
   AVG(tenure_months) avg_tenure_months
FROM customer_churn
GROUP BY 1
ORDER BY 2 DESC;

### Q13: Which contract type has the highest churn rate?
SELECT 
  contract,
  COUNT(*) AS total_customers,
  COUNT(CASE WHEN churn_label = 'Yes' THEN 1 END) AS churned_customers,
  ROUND(
    COUNT(CASE WHEN churn_label = 'Yes' THEN 1 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate_percentage
FROM customer_churn
GROUP BY contract
ORDER BY churn_rate_percentage DESC;

### Q14: Find the top 5 reasons for churn and how many customers left for each reason.
WITH churned_customers AS (
  SELECT churn_reason
  FROM customer_churn
  WHERE churn_label = 'Yes'
)
SELECT
  churn_reason,
  COUNT(*) AS num_customers_left
FROM churned_customers
GROUP BY churn_reason
ORDER BY num_customers_left DESC
LIMIT 5;

## 6. Advanced Queries 

### Q15:  Find customers with high churn_score but low tenure — possible early churn risks?
WITH customer_high_cs AS 
(
SELECT 
   customerid, 
   churn_score
FROM 
   customer_churn
WHERE churn_score > 50
GROUP BY 1
)
SELECT 
   c.customerid,
   h.churn_score,
   c.tenure_months
FROM customer_churn c
JOIN customer_high_cs h
ON h.customerid = c.customerid 
WHERE tenure_months <= 6
ORDER BY 3 DESC;

### Q16: List customers whose total charges are zero or NULL but have been customers for more than 6 months.
WITH cst_total_charges AS
(
SELECT 
   customerid,
   total_charges
FROM 
   customer_churn
WHERE total_charges IS NULL OR total_charges = 0
)
SELECT 
   t.customerid,
   t.total_charges,
   c.tenure_months
FROM customer_churn c
JOIN cst_total_charges t
ON c.customerid = t.customerid 
WHERE tenure_months > 6
GROUP BY 1,2,3
ORDER BY 3 DESC;

### Q17: Identify customers who have made payments by mailed check and have a monthly charge above the dataset average.
WITH avg_monthly_charge AS (
    SELECT AVG(monthly_charges) AS avg_charge
    FROM customer_churn
),
bill_mailed_check AS (
    SELECT 
        customerid,
        payment_method,
        SUM(monthly_charges) AS total_monthly_charges
    FROM customer_churn
    WHERE payment_method = 'Mailed check'
    GROUP BY customerid, payment_method
)

SELECT 
    b.customerid,
    b.total_monthly_charges,
    a.avg_charge
FROM 
    bill_mailed_check b
    CROSS JOIN avg_monthly_charge a
WHERE 
    b.total_monthly_charges > a.avg_charge;
