--Use window functions

--Challenge 1: Rank salespeople based on orders
--Write a query that ranks the salespeople based on the number of orders placed by the customers they are assigned to.

SELECT c.SalesPerson,
	   COUNT(oh.SalesOrderID) AS CntSales, 
	   RANK() OVER(ORDER BY COUNT(oh.SalesOrderID) DESC) AS 'Rank'
FROM SalesLT.Customer AS c
INNER JOIN SalesLT.SalesOrderHeader AS oh 
		ON c.CustomerID = oh.CustomerID
GROUP BY c.SalesPerson


--Challenge 2: Retrieve each customer with the total number of customers in the same region
--Write a query that returns the company name of each customer, 
--the city in which the customer has its main office, 
--and the total number of customers with a main office in the same region.

SELECT c.CompanyName, 
	   a.City,
	   a.CountryRegion,
	   COUNT(c.CustomerID) OVER(PARTITION BY a.CountryRegion) AS TotalCustInRegion
FROM SalesLT.Customer c
INNER JOIN SalesLT.CustomerAddress ca
		ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address a 
		ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
ORDER BY TotalCustInRegion DESC
