--------------------------------------------------------------------------------------------
--In this project, we used the Adventure work database (2019) to calculate certain KPIs
---------------------------------------------------------------------------------------------

--Total sales by region for the year 2014

SELECT SUM(TotalDue)as total_sales, sp.Name as region, sp.TerritoryID
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] soh 
JOIN [AdventureWorks2019].[Person].[StateProvince] sp
ON soh.TerritoryID= sp.TerritoryID
Where YEAR(sp.ModifiedDate)='2014'
GROUP BY sp.Name,sp.TerritoryID
ORDER BY total_sales DESC;

--Total sales by each category of product

SELECT SUM(sod.LineTotal) as total_sales, pc.Name AS Product_category
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] sod
JOIN [AdventureWorks2019].[Production].[Product] p on p.ProductID=sod.ProductID
JOIN [AdventureWorks2019].[Production].[ProductSubcategory] ps on ps.ProductSubcategoryID=p.ProductSubcategoryID
JOIN [AdventureWorks2019].[Production].[ProductCategory] pc on ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY total_sales DESC;

--Display the total sales achieved by each sales agent in 2014

SELECT sp.BusinessEntityID AS Agent_ID, 
       e.JobTitle AS Agent_name,
       SUM(soh.TotalDue) AS total_sales
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] soh
JOIN [AdventureWorks2019].[Sales].[SalesPerson] sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN [AdventureWorks2019].[HumanResources].[Employee] e ON sp.BusinessEntityID = e.BusinessEntityID
WHERE YEAR(soh.OrderDate) = 2014
GROUP BY sp.BusinessEntityID, e.JobTitle
ORDER BY total_sales DESC;

--Display the 5 most profitable products (in terms of revenue generated) in 2014.

SELECT TOP 5 p.Name AS Product, SUM(sod.LineTotal) AS total_revenue
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] sod
JOIN [AdventureWorks2019].[Production].[Product] p ON sod.ProductID = p.ProductID
WHERE YEAR(p.ModifiedDate)='2014'
GROUP BY p.Name
ORDER BY total_revenue DESC;

--Create customer segments based on the total amount spent

SELECT c.CustomerID, 
       SUM(soh.TotalDue) AS Total_amount,
       CASE 
           WHEN SUM(soh.TotalDue) < 5000 THEN 'Low'
           WHEN SUM(soh.TotalDue) BETWEEN 5000 AND 15000 THEN 'Middle'
           ELSE 'High'
       END AS Segment_Client
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] soh 
JOIN [AdventureWorks2019].[Sales].[Customer] c ON soh.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY Total_amount DESC;

--Identify the 10 customers who generated the most revenue.

SELECT TOP 10 c.CustomerID, 
       SUM(soh.TotalDue) AS Total_amount,
       CASE 
           WHEN SUM(soh.TotalDue) < 5000 THEN 'Low'
           WHEN SUM(soh.TotalDue) BETWEEN 5000 AND 15000 THEN 'Middle'
           ELSE 'High'
       END AS Segment_Client
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] soh 
JOIN [AdventureWorks2019].[Sales].[Customer] c ON soh.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY Total_amount DESC

--display customers who have purchased products online and those who have made purchases in shop.

SELECT c.CustomerID,
       CASE 
           WHEN soh.OnlineOrderFlag = 1 THEN 'Online'
           ELSE 'In-Store'
       END AS Purchase_Type,
       COUNT(soh.SalesOrderID) AS Number_of_Purchases
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] soh 
JOIN [AdventureWorks2019].[Sales].[Customer] c ON soh.CustomerID = c.CustomerID
GROUP BY c.CustomerID, soh.OnlineOrderFlag
ORDER BY Number_of_Purchases DESC;

--Identify the most popular products purchased between 2013 and 2014.

SELECT p.Name AS Product, COUNT(sod.ProductID) AS Purchase_Count
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] sod
JOIN [AdventureWorks2019].[Production].[Product] p ON sod.ProductID = p.ProductID
JOIN [AdventureWorks2019].[Sales].[SalesOrderHeader] soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate BETWEEN '2013' AND '2014'  -- Last 12 months
GROUP BY p.Name
ORDER BY Purchase_Count DESC;

--Total sales by product in each region

SELECT sp.Name AS Region, p.Name AS Product, SUM(sod.LineTotal) AS Total_Sales
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] sod
JOIN [AdventureWorks2019].[Sales].[SalesOrderHeader] soh  ON sod.SalesOrderID = soh.SalesOrderID
JOIN [AdventureWorks2019].[Production].[Product] p ON sod.ProductID = p.ProductID
JOIN Person.StateProvince sp ON soh.ShipToAddressID = sp.StateProvinceID
GROUP BY sp.Name, p.Name
ORDER BY Region, Total_Sales DESC;

--identify the most profitable products and those that do not generate enough revenue

SELECT p.Name AS Produit, SUM(sod.LineTotal) AS Total_revenue
FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] sod
JOIN [AdventureWorks2019].[Production].[Product] p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY Total_revenue DESC;