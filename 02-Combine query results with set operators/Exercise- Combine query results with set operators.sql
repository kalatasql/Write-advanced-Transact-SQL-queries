--Combine query results with set operators

--Challenge
--Use the following code to create a table-valued function that retrieves address details for a given customer:

CREATE OR ALTER FUNCTION SalesLT.fn_CustomerAddresses (@CustomerID int)
RETURNS TABLE
RETURN
    SELECT ca.AddressType, a.AddressLine1, a.AddressLine2, a.City, a.StateProvince, a.CountryRegion, a.PostalCode
    FROM SalesLT.CustomerAddress as ca
    JOIN SalesLT.Address AS a
        ON a.AddressID = ca.AddressID
    WHERE ca.CustomerID = @CustomerID

--Now write a query that returns every customer ID and company name along with all of the address fields retrieved by the function.

SELECT c.CustomerID, c.CompanyName, ca.*
FROM SalesLT.Customer c
CROSS APPLY SalesLT.fn_CustomerAddresses(c.CustomerID) AS ca
ORDER BY c.CustomerID
