-- =========================================
-- Executive Logistics Report
-- Based on logistics_dataset
-- =========================================

-- 1. On-Time Delivery Performance
SELECT 
    Status,
    COUNT(*) AS Total_Shipments,
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM logistics_dataset), 2),'%') AS Percentage
FROM logistics_dataset
GROUP BY Status
ORDER BY Percentage DESC;

-- 2. Top Problem Routes (Delay Percentage by Lane)
SELECT 
    Origin_State, Destination_State,
    COUNT(*) AS Total_Shipments,
    SUM(CASE WHEN Status = 'Delayed' THEN 1 ELSE 0 END) AS Delayed_Shipments,
    ROUND(SUM(CASE WHEN Status = 'Delayed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Delay_Percentage
FROM logistics_dataset
GROUP BY Origin_State, Destination_State
HAVING COUNT(*) > 20
ORDER BY Delay_Percentage DESC
LIMIT 10;

-- 3. Cost Per Mile & Revenue Per Mile Trend by Month
SELECT 
    DATE_FORMAT(Pickup_Date, '%m-%Y') AS Month,
    ROUND(SUM(Cost_USD) / SUM(Distance_Miles), 2) AS Cost_Per_Mile,
    ROUND(SUM(Revenue_USD) / SUM(Distance_Miles), 2) AS Revenue_Per_Mile
FROM logistics_dataset
GROUP BY DATE_FORMAT(Pickup_Date, '%m-%Y')
ORDER BY Month;

-- 4. Deadhead Miles Percentage
SELECT 
    ROUND(SUM(Deadhead_Miles) * 100.0 / SUM(Distance_Miles), 2) AS Deadhead_Percentage
FROM logistics_dataset;

-- 5. Customer Profitability
SELECT 
    Customer_Name,
    COUNT(*) AS Total_Shipments,
    ROUND(SUM(Revenue_USD) - SUM(Cost_USD), 2) AS Total_Profit,
    ROUND((SUM(Revenue_USD) - SUM(Cost_USD)) / SUM(Revenue_USD) * 100, 2) AS Profit_Margin_Percentage
FROM logistics_dataset
GROUP BY Customer_Name
ORDER BY Profit_Margin_Percentage DESC
LIMIT 10;

-- 6. Average Transit Time (Days)
SELECT 
    ROUND(AVG(DATEDIFF(Delivery_Date, Pickup_Date)), 2) AS Avg_Transit_Days
FROM logistics_dataset;

-- 7. Freight Type Profitability
SELECT 
    Freight_Type,
    COUNT(*) AS Total_Shipments,
    ROUND(AVG(Revenue_USD - Cost_USD), 2) AS Avg_Profit,
    ROUND(SUM(Revenue_USD - Cost_USD), 2) AS Total_Profit
FROM logistics_dataset
GROUP BY Freight_Type
ORDER BY Avg_Profit DESC;
