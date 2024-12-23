-- Use pivoting and grouping sets

-- In the query editor, enter the following code to create a view that contains the ID, company name, and main office region for all customers

 --CREATE VIEW SalesLT.v_CustomerRegions
 --AS
 --SELECT c.CustomerID, c.CompanyName,a. CountryRegion
 --FROM SalesLT.Customer AS c
 --JOIN SalesLT.CustomerAddress AS ca
 --    ON c.CustomerID = ca.CustomerID
 --JOIN SalesLT.Address AS a
 --    ON ca.AddressID = a.AddressID
 --WHERE ca.AddressType = 'Main Office';
 --GO

-- Create a view that includes details of sales of products to customers from multiple tables in the database. To do this, Run the following code:

 -- CREATE VIEW SalesLT.v_ProductSales AS 
 --SELECT c.CustomerID, c.CompanyName, c.SalesPerson,
 --       a.City, a.StateProvince, a.CountryRegion,
 --       p.Name As Product, pc.Name AS Category,
 --       o.SubTotal + o.TaxAmt + o.Freight AS TotalDue 
 --FROM SalesLT.Customer AS c
 --INNER JOIN SalesLT.CustomerAddress AS ca
 --    ON c.CustomerID = ca.CustomerID
 --INNER JOIN SalesLT.Address AS a
 --    ON ca.AddressID = a.AddressID
 --INNER JOIN SalesLT.SalesOrderHeader AS o
 --    ON c.CustomerID = o.CustomerID
 --INNER JOIN SalesLT.SalesOrderDetail AS od
 --    ON o.SalesOrderID = od.SalesOrderID
 --INNER JOIN SalesLT.Product AS p
 --    ON od.ProductID = p.ProductID
 --INNER JOIN SalesLT.ProductCategory AS pc
 --    ON p.ProductCategoryID = pc.ProductCategoryID
 --WHERE ca.AddressType = 'Main Office';

-- Challenge 1: Count product colors by category
--The Adventure Works marketing team wants to conduct research into the relationship between colors and products.
--To give them a starting point, you’ve been asked to provide information on how many products are available across the different color types.

--Use the SalesLT.Product and SalesLT.ProductCategory tables to get a list of products, their colors, and product categories.
--Pivot the data so that the colors become columns with a value indicating how many products in each category are that color.

SELECT *
FROM
    (SELECT pc.Name AS PrdCat, p.Name AS PrdName, ISNULL(p.Color, 'No color') as Color
     FROM SalesLT.Product p
     INNER JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID) AS pc_tbl
PIVOT
(
     COUNT(PrdName) FOR Color IN ([Silver], [Black], [Yellow], [Red], [Blue], [Grey], [Multi], [White], [No color])
) AS ColorPivot


--Challenge 2: Aggregate sales data by product and salesperson
--The sales team at Adventure Works wants to compare sales of individual products by salesperson. 
--To accomplish this, write a query that groups data from the SalesLT.v_ProductSales view you created previously to return:

--The sales amount for each product by each salesperson
--The subtotal of sales for each product by all salespeople
--The grand total for all products by all saleseople

SELECT ps.Product,
       ps.SalesPerson, 
       SUM(ps.TotalDue) as TotalSales
FROM SalesLT.v_ProductSales ps
GROUP BY ROLLUP(ps.Product, ps.SalesPerson)
