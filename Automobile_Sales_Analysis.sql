SELECT *
FROM [dbo].[Auto Sales Data]


--Calculating Key Metrics
SELECT	SUM([Total Sales]) AS [Total Revenu]
	   ,SUM([Qty Ordered]) AS [Total Qty Sold]
	   ,AVG([Total Sales]) AS [Average Sales Per Order]
FROM [dbo].[Auto Sales Data];

--Sales Trends Over Time

--Monthly or quarterly trends:

SELECT YEAR([Order Date]) AS Year
		,MONTH([Order Date]) AS Month
		,SUM([Total Sales]) AS [Total Revenue]
FROM [dbo].[Auto Sales Data]
GROUP BY YEAR([Order Date]),MONTH([Order Date])
ORDER BY Year, Month;

--Regional Sales Trend

SELECT TOP(10) Country
		,SUM([Total Sales]) AS Revenue
FROM [dbo].[Auto Sales Data]
GROUP BY Country
ORDER BY Revenue DESC;

--Top Products by Revenue: Identify top 10 products

SELECT TOP(10) [PRODUCTCODE] AS Product_Code
		,SUM([Total Sales]) AS Revenue
FROM  [dbo].[Auto Sales Data]
GROUP BY [PRODUCTCODE]
ORDER BY Revenue DESC;

--Order Size Distribution: Break down sales by deal size

SELECT [Deal Size]
		,COUNT(*) AS Order_Count
		,SUM([Total Sales]) AS Revenue
FROM [dbo].[Auto Sales Data]
GROUP BY [Deal Size]
ORDER BY Revenue;

--Product Line Performance: Revenue and quantity sold for each product line

SELECT [Product Line]
		,SUM([Qty Ordered]) AS Qty_Sold
		,SUM([Total Sales]) AS Revenue
FROM [dbo].[Auto Sales Data]
GROUP BY [Product Line]
ORDER by Revenue DESC;



WITH Product_Performance AS (
    SELECT 
        [Product Line],
        SUM([Total Sales]) AS Total_Revenue, 
        SUM([Qty Ordered]) AS Total_Quantity_Sold
    FROM [dbo].[Auto Sales Data]
    GROUP BY [Product Line]
	
)
SELECT 
    * 
FROM Product_Performance
WHERE Total_Revenue > 100000;


--Customer Contribution: Identify high-value customers contributing the most to revenue.

SELECT TOP(10) [Customer Name]
		,COUNT(*) AS Order_Count
		,SUM([Total Sales]) AS Revenue
FROM [dbo].[Auto Sales Data]
GROUP BY [Customer Name]
ORDER BY Revenue DESC;


--Monthly Growth Rate: Track monthly growth rates to understand the performance trajectory

WITH MonthlySales AS (
    SELECT 
        YEAR([Order Date]) AS Year
        ,MONTH([Order Date]) AS Month
        ,SUM([Total Sales]) AS Total_Revenue
    FROM [dbo].[Auto Sales Data]
    GROUP BY YEAR([Order Date]), MONTH([Order Date])
)
SELECT 
    Year 
    ,Month 
    Total_Revenue 
    ,LAG(Total_Revenue) OVER (ORDER BY Year, Month) AS Previous_Revenue
    ,((Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Year, Month)) / 
    LAG(Total_Revenue) OVER (ORDER BY Year, Month)) * 100 AS Growth_Rate
FROM MonthlySales;

--Underperforming Products: Identify products contributing the least to sales to address inefficiencies.

SELECT TOP(10) [PRODUCTCODE]
		,SUM([Total Sales]) AS Revenue
FROM [dbo].[Auto Sales Data]
GROUP BY [PRODUCTCODE]
ORDER BY Revenue;

--Repeat Order Analysis: Understand customer loyalty and order frequency by analyzing DAYS_SINCE_LASTORDER

SELECT 
    [Customer Name]
    ,ROUND(AVG([Days_Since_Last_Order]),2) AS Avg_Days_Between_Orders
    ,COUNT(*) AS Total_Orders
FROM [dbo].[Auto Sales Data]
GROUP BY [Customer Name]
ORDER BY Avg_Days_Between_Orders ASC;

--High-Value Time Periods: Discover the time periods with the highest sales volume to plan marketing efforts.

SELECT 
    YEAR([Order Date]) AS Year, 
    MONTH([Order Date]) AS Month, 
    SUM([Total Sales]) AS Total_Revenue
FROM [dbo].[Auto Sales Data]
WHERE [Total Sales] = (SELECT MAX([Total Sales]) FROM [dbo].[Auto Sales Data])
GROUP BY YEAR([Order Date]), MONTH([Order Date]);

--High-Value Product Lines by Country: Understand which product lines are most popular in each region to target marketing efforts.

SELECT 
    [Country] 
    ,[Product Line] 
    ,SUM([Total Sales]) AS Total_Revenue
FROM [dbo].[Auto Sales Data]
GROUP BY [Country], [Product Line]
ORDER BY [Country], Total_Revenue DESC;
