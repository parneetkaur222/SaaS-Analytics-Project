-- Query 1
SELECT Customer_ID, Subscription_Plan, Monthly_Fee
FROM customers
WHERE Monthly_Fee > (SELECT AVG(Monthly_Fee) FROM customers)
ORDER BY Monthly_Fee DESC
LIMIT 10;

-- Query 2
SELECT Country,
       ROUND(100.0 * SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate_Pct
FROM customers
GROUP BY Country
HAVING Churn_Rate_Pct > (
    SELECT 100.0 * SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) / COUNT(*)
    FROM customers
)
ORDER BY Churn_Rate_Pct DESC;

-- Query 3
SELECT Customer_ID, Subscription_Plan, Monthly_Fee, Plan_Avg_Fee
FROM (
    SELECT Customer_ID, Subscription_Plan, Monthly_Fee,
           AVG(Monthly_Fee) OVER (PARTITION BY Subscription_Plan) as Plan_Avg_Fee
    FROM customers
)
WHERE Monthly_Fee > Plan_Avg_Fee
ORDER BY Monthly_Fee DESC
LIMIT 10;

-- Query 4
SELECT Customer_ID, Subscription_Plan, Lifetime_Value
FROM customers
WHERE Lifetime_Value = (SELECT MAX(Lifetime_Value) FROM customers);

-- Query 5
SELECT Customer_ID, Customer_Status, Support_Tickets
FROM customers
WHERE Support_Tickets < (
    SELECT AVG(Support_Tickets) FROM customers WHERE Customer_Status = 'Churned'
)
AND Customer_Status = 'Active'
LIMIT 10;

-- Query 6
WITH plan_revenue AS (
    SELECT Subscription_Plan, SUM(Revenue) as Total_Revenue, COUNT(*) as Customer_Count
    FROM customers
    WHERE Customer_Status = 'Active'
    GROUP BY Subscription_Plan
)
SELECT * FROM plan_revenue
ORDER BY Total_Revenue DESC;

-- Query 7
WITH plan_revenue AS (
    SELECT Subscription_Plan, SUM(Revenue) as Total_Revenue
    FROM customers
    WHERE Customer_Status = 'Active'
    GROUP BY Subscription_Plan
)
SELECT pr.Subscription_Plan, pr.Total_Revenue, pd.Support_Level
FROM plan_revenue pr
JOIN plan_details pd ON pr.Subscription_Plan = pd.Subscription_Plan
ORDER BY pr.Total_Revenue DESC;

-- Query 8
WITH high_value AS (
    SELECT COUNT(*) as Count, AVG(Customer_Satisfaction) as Avg_Satisfaction
    FROM customers WHERE Lifetime_Value >= 2000
),
low_value AS (
    SELECT COUNT(*) as Count, AVG(Customer_Satisfaction) as Avg_Satisfaction
    FROM customers WHERE Lifetime_Value < 2000
)
SELECT 'High Value' as Segment, Count, ROUND(Avg_Satisfaction,2) as Avg_Satisfaction FROM high_value
UNION ALL
SELECT 'Low Value' as Segment, Count, ROUND(Avg_Satisfaction,2) as Avg_Satisfaction FROM low_value;

-- Query 9
WITH ranked_customers AS (
    SELECT Customer_ID, Country, Monthly_Fee,
           ROW_NUMBER() OVER (PARTITION BY Country ORDER BY Monthly_Fee DESC) as rn
    FROM customers
)
SELECT Country, Customer_ID, Monthly_Fee
FROM ranked_customers
WHERE rn = 1
ORDER BY Monthly_Fee DESC;

-- Query 10
WITH industry_stats AS (
    SELECT Industry,
           COUNT(*) as Total,
           SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) as Churned,
           ROUND(100.0 * SUM(CASE WHEN Customer_Status='Churned' THEN 1 ELSE 0 END) / COUNT(*), 2) as Churn_Rate
    FROM customers
    GROUP BY Industry
)
SELECT * FROM industry_stats
WHERE Total > 1000
ORDER BY Churn_Rate DESC;

