-- Query 1
SELECT Customer_ID, Country, Monthly_Fee, Customer_Status
FROM customers
WHERE Subscription_Plan = 'Enterprise'
LIMIT 10;

-- Query 2
SELECT Customer_ID, Subscription_Plan, Monthly_Fee, Customer_Satisfaction
FROM customers
WHERE Customer_Status = 'Churned' AND Monthly_Fee > 100
LIMIT 10;

-- Query 3
SELECT Customer_ID, Country, Subscription_Plan, Monthly_Fee
FROM customers
WHERE Country IN ('USA', 'India') AND Subscription_Plan = 'Premium'
LIMIT 10;

-- Query 4
SELECT Customer_ID, Subscription_Plan, Usage_Hours_Monthly
FROM customers
WHERE Support_Tickets = 0
LIMIT 10;

-- Query 5
SELECT Customer_ID, Customer_Satisfaction, Support_Tickets, Customer_Status
FROM customers
WHERE Customer_Satisfaction < 4
ORDER BY Customer_Satisfaction ASC
LIMIT 10;

-- Query 6
SELECT Subscription_Plan, COUNT(*) as Customer_Count
FROM customers
GROUP BY Subscription_Plan
ORDER BY Customer_Count DESC;

-- Query 7
SELECT Subscription_Plan,
       ROUND(AVG(Monthly_Fee), 2) as Avg_Fee,
       ROUND(AVG(Customer_Satisfaction), 2) as Avg_Satisfaction
FROM customers
GROUP BY Subscription_Plan
ORDER BY Avg_Fee DESC;

-- Query 8
SELECT Country, COUNT(*) as Customer_Count
FROM customers
GROUP BY Country
HAVING COUNT(*) > 3000
ORDER BY Customer_Count DESC;

-- Query 9
SELECT Marketing_Channel,
       COUNT(*) as Total_Customers,
       SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) as Churned_Count,
       ROUND(100.0 * SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Pct
FROM customers
GROUP BY Marketing_Channel
ORDER BY Churn_Rate_Pct DESC;

-- Query 10
SELECT Company_Size,
       COUNT(*) as Customer_Count,
       ROUND(AVG(Lifetime_Value), 2) as Avg_LTV
FROM customers
GROUP BY Company_Size
ORDER BY Avg_LTV DESC;

