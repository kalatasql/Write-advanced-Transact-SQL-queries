-- Create queries with table expressions

--Challenge 1: Create a view
--Adventure Works is forming a new sales team located in Canada. The team wants to create
--a map of all of the customer addresses in Canada. This team will need access to address
--details on Canadian customers only. Your manager has asked you to make sure that the team
--can get the data they require, but ensure that they don’t access the underlying source
--data when getting their information.

--To carry out the task do the following:

-- 1. Write a Transact-SQL query to create a view for customer addresses in Canada.
--Create a view based on the following columns in the SalesLT.Address table:
--AddressLine1
--City
--StateProvince
--CountryRegion
--In your query, use the CountryRegion column to filter for addresses located in Canada only.

CREATE VIEW SalesLT.vCustomerAddrCanada
AS
   SELECT AddressLine1,
	  City,
          StateProvince,
          CountryRegion
   FROM SalesLT.Address
   WHERE CountryRegion = 'Canada'

-- 2. Query your new view.
--Fetch the rows in your newly created view to ensure it was created successfully. Notice that it only shows address in Canada.

SELECT * 
FROM SalesLT.vCustomerAddrCanada

--Challenge 2: Use a derived table
--The transportation team at Adventure Works wants to optimize its processes. 
--Products that weigh more than 1000 are considered to be heavy products,
--and will also need to use a new transportation method if their list price 
--is over 2000. You’ve been asked to classify products according to their weight, 
--and then provide a list of products that meet both these weight and list price criteria.

--To help, you’ll:

-- 1. Write a query that classifies products as heavy and normal based on their weight.
--Use the Weight column to decide whether a product is heavy or normal.

SELECT ProductID, Name,
       (CASE 
	          WHEN Weight > 1000 THEN 'Heavy'
	          ELSE 'Normal'
	      END) AS WeightCategory,
       ListPrice 
FROM SalesLT.Product

-- 2. Create a derived table based on your query
--Use your derived table to find any heavy products with a list price over 2000.
--Make sure to select the following columns: ProductID, Name, Weight, ListPrice.

SELECT drv_prd.ProductID,
	     drv_prd.Name,
	     drv_prd.WeightCategory,
	     drv_prd.ListPrice
FROM  
     (SELECT ProductID, Name,
	          (CASE 
		             WHEN Weight > 1000 THEN 'Heavy'
		             ELSE 'Normal'
	           END) AS WeightCategory,
	           ListPrice 
FROM SalesLT.Product) AS drv_prd --derived table
WHERE drv_prd.ListPrice > 2000
