-- =========================================================
-- CUSTOMER CHURN ANALYSIS - COMPLETE SQL PROJECT
-- TASK 2 + TASK 3 + TASK 4
-- =========================================================

-- =========================================================
-- TASK 2: DATASET LOADING & INITIAL VERIFICATION
-- Source: task2.sql
-- =========================================================

-- =========================================
-- CUSTOMER CHURN ANALYSIS
-- Task 2 - Dataset Verification
-- =========================================

USE ChurnDB;

-- Check total number of customers
SELECT COUNT(*) AS TotalCustomers
FROM dbo.CustomerChurn;

-- Display first 10 customers
SELECT TOP 10 *
FROM dbo.CustomerChurn;

-- =========================================================
-- TASK 3: SQL DATA MODELING / CLEAN VIEW
-- Source: Customer_Churn_Analysis.sql
-- =========================================================

-- Task 3: Check column data types
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CustomerChurn'
ORDER BY ORDINAL_POSITION;


-- Task 3: Check NULL values in TotalCharges
SELECT COUNT(*) AS NullTotalCharges
FROM dbo.CustomerChurn
WHERE TotalCharges IS NULL;


-- Task 3: Create cleaned view
CREATE VIEW dbo.vw_ChurnData
AS
SELECT
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,
    CAST(ISNULL(TotalCharges, 0.0) AS FLOAT) AS TotalCharges,
    Churn
FROM dbo.CustomerChurn;
GO


-- Task 3: Verify the cleaned view
SELECT TOP 10 *
FROM dbo.vw_ChurnData;


-- Task 3: Verify TotalCharges datatype
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'vw_ChurnData'
  AND COLUMN_NAME = 'TotalCharges';

-- =========================================================
-- TASK 4: SQL EXPLORATORY DATA ANALYSIS (EDA)
-- =========================================================

-- Question 1: What percentage of customers have churned overall?
SELECT
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRatePercentage
FROM dbo.vw_ChurnData;
-- Finding: 1,869 out of 7,043 customers churned.
-- Overall churn rate = 26.54%.


-- Question 2: Which contract type has the highest churn rate?
SELECT
    Contract,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRatePercentage
FROM dbo.vw_ChurnData
GROUP BY Contract
ORDER BY ChurnRatePercentage DESC;
-- Finding: Month-to-month customers have the highest churn rate at 42.71%.


-- Question 3: Do customers with higher MonthlyCharges churn more?
SELECT
    Churn,
    COUNT(*) AS TotalCustomers,
    AVG(MonthlyCharges) AS AverageMonthlyCharges
FROM dbo.vw_ChurnData
GROUP BY Churn
ORDER BY Churn;
-- Finding: Churned customers have an average MonthlyCharges of 74.44,
-- compared with 61.27 for customers who stayed.


-- Question 4: Does tenure relate to customer churn?
SELECT
    Churn,
    COUNT(*) AS TotalCustomers,
    AVG(Tenure) AS AverageTenure
FROM dbo.vw_ChurnData
GROUP BY Churn
ORDER BY Churn;
-- Finding: Churned customers have an average tenure of about 17 months,
-- compared with about 37 months for customers who stayed.


-- Question 5: Does InternetService type affect customer churn?
SELECT
    InternetService,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    CAST(
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRatePercentage
FROM dbo.vw_ChurnData
GROUP BY InternetService
ORDER BY ChurnRatePercentage DESC;
-- Finding: Fiber optic customers have the highest churn rate at 41.89%.


-- =========================================================
-- TASK 4 SUMMARY
-- =========================================================
-- 1. Overall churn rate: 26.54%.
-- 2. Month-to-month contracts have the highest churn: 42.71%.
-- 3. Churned customers have higher average MonthlyCharges: 74.44 vs 61.27.
-- 4. Churned customers have shorter average tenure: 17 vs 37 months.
-- 5. Fiber optic customers have the highest churn rate: 41.89%.
