-- Query 1
SELECT Customer_ID, Lifetime_Value,
    CASE
        WHEN Lifetime_Value >= 3000 THEN 'High Value'
        WHEN Lifetime_Value >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END as Value_Tier
FROM customers
ORDER BY Lifetime_Value DESC
LIMIT 10;

-- Query 2
SELECT
    CASE
        WHEN Lifetime_Value >= 3000 THEN 'High Value'
        WHEN Lifetime_Value >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END as Value_Tier,
    COUNT(*) as Customer_Count,
    ROUND(AVG(Lifetime_Value), 2) as Avg_LTV_In_Tier
FROM customers
GROUP BY Value_Tier
ORDER BY Avg_LTV_In_Tier DESC;

-- Query 3
SELECT Customer_ID, Monthly_Fee, Support_Tickets,
    CASE WHEN Support_Tickets >= 5 THEN 'At Risk' ELSE 'Healthy' END as Risk_Flag
FROM customers
WHERE Customer_Status = 'Active'
ORDER BY Monthly_Fee DESC
LIMIT 10;

-- Query 4
SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age < 45 THEN '30-44'
        WHEN Age < 60 THEN '45-59'
        ELSE '60+'
    END as Age_Group,
    COUNT(*) as Customer_Count,
    ROUND(AVG(Customer_Satisfaction), 2) as Avg_Satisfaction
FROM customers
GROUP BY Age_Group
ORDER BY Age_Group;

-- Query 5
SELECT Customer_ID, Subscription_Plan, Monthly_Fee, Discount_Percent
FROM customers
ORDER BY Discount_Percent DESC
LIMIT 10;

-- Query 6
SELECT c.Customer_ID, c.Subscription_Plan, c.Monthly_Fee,
       p.Support_Level, p.Max_Users_Allowed
FROM customers c
JOIN plan_details p ON c.Subscription_Plan = p.Subscription_Plan
LIMIT 10;

-- Query 7
SELECT p.Subscription_Plan, p.Onboarding_Included, COUNT(*) as Customer_Count
FROM customers c
JOIN plan_details p ON c.Subscription_Plan = p.Subscription_Plan
GROUP BY p.Subscription_Plan, p.Onboarding_Included
ORDER BY Customer_Count DESC;

-- Query 8
SELECT p.Support_Level, ROUND(AVG(c.Customer_Satisfaction), 2) as Avg_Satisfaction, COUNT(*) as Customer_Count
FROM customers c
JOIN plan_details p ON c.Subscription_Plan = p.Subscription_Plan
GROUP BY p.Support_Level
ORDER BY Avg_Satisfaction DESC;

-- Query 9
SELECT c.Customer_ID, c.Subscription_Plan, p.Max_Users_Allowed
FROM customers c
JOIN plan_details p ON c.Subscription_Plan = p.Subscription_Plan
WHERE c.Subscription_Plan = 'Enterprise'
LIMIT 10;

-- Query 10
SELECT p.Subscription_Plan, p.Support_Level, COUNT(c.Customer_ID) as Customer_Count
FROM plan_details p
LEFT JOIN customers c ON p.Subscription_Plan = c.Subscription_Plan
GROUP BY p.Subscription_Plan, p.Support_Level
ORDER BY Customer_Count DESC;

