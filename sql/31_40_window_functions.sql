-- Query 1
SELECT Customer_ID, Subscription_Plan, Lifetime_Value,
       RANK() OVER (PARTITION BY Subscription_Plan ORDER BY Lifetime_Value DESC) as Rank_In_Plan
FROM customers
WHERE Customer_Status = 'Active'
ORDER BY Subscription_Plan, Rank_In_Plan
LIMIT 15;

-- Query 2
SELECT Customer_ID, Subscription_Plan, Monthly_Fee,
       DENSE_RANK() OVER (ORDER BY Monthly_Fee DESC) as Fee_Rank
FROM customers
LIMIT 10;

-- Query 3
SELECT Customer_ID, Subscription_Date, Revenue,
       SUM(Revenue) OVER (ORDER BY Subscription_Date) as Running_Total_Revenue
FROM customers
WHERE Customer_Status = 'Active'
ORDER BY Subscription_Date
LIMIT 15;

-- Query 4
SELECT Customer_ID, Subscription_Date, Monthly_Fee,
       LAG(Monthly_Fee) OVER (ORDER BY Subscription_Date) as Previous_Customer_Fee
FROM customers
ORDER BY Subscription_Date
LIMIT 10;

-- Query 5
SELECT Customer_ID, Lifetime_Value,
       NTILE(4) OVER (ORDER BY Lifetime_Value DESC) as Value_Quartile
FROM customers
LIMIT 20;

-- Query 6
SELECT Subscription_Plan,
       SUM(Revenue) as Plan_Revenue,
       ROUND(100.0 * SUM(Revenue) / SUM(SUM(Revenue)) OVER (), 2) as Pct_Of_Total_Revenue
FROM customers
WHERE Customer_Status = 'Active'
GROUP BY Subscription_Plan
ORDER BY Pct_Of_Total_Revenue DESC;

-- Query 7
WITH monthly_signups AS (
    SELECT strftime('%Y-%m', Subscription_Date) as Month, COUNT(*) as Signups
    FROM customers
    GROUP BY Month
)
SELECT Month, Signups,
       Signups - LAG(Signups) OVER (ORDER BY Month) as Change_From_Prev_Month
FROM monthly_signups
ORDER BY Month
LIMIT 15;

-- Query 8
WITH ranked AS (
    SELECT Customer_ID, Country, Lifetime_Value,
           ROW_NUMBER() OVER (PARTITION BY Country ORDER BY Lifetime_Value DESC) as rn
    FROM customers
)
SELECT Country, Customer_ID, Lifetime_Value
FROM ranked
WHERE rn <= 3
ORDER BY Country, rn;

-- Query 9
WITH ranked AS (
    SELECT Customer_ID, Lifetime_Value,
           ROW_NUMBER() OVER (ORDER BY Lifetime_Value DESC) as rn,
           COUNT(*) OVER () as total_customers
    FROM customers
)
SELECT Customer_ID, Lifetime_Value, rn,
       ROUND(100.0 * rn / total_customers, 2) as Cumulative_Pct_Of_Customers
FROM ranked
LIMIT 10;

-- Query 10
SELECT
    COUNT(*) as Total_Customers,
    SUM(CASE WHEN Customer_Status='Active' THEN 1 ELSE 0 END) as Active_Customers,
    SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) as Churned_Customers,
    ROUND(100.0 * SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Pct,
    ROUND(SUM(CASE WHEN Customer_Status='Active' THEN Revenue ELSE 0 END), 2) as MRR,
    ROUND(AVG(CASE WHEN Customer_Status='Active' THEN Revenue END), 2) as ARPU,
    ROUND(AVG(Lifetime_Value), 2) as Avg_CLTV
FROM customers;

