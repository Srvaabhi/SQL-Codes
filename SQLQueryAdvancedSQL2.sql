--1.	List all the states in which we have customers who have bought cellphones from 2005 till today.
SELECT Country, State, COUNT(State)
FROM DIM_LOCATION
INNER JOIN FACT_TRANSACTIONS ON DIM_LOCATION.IDLocation = FACT_TRANSACTIONS.IDLocation 
INNER JOIN DIM_DATE ON FACT_TRANSACTIONS.DATE = DIM_DATE.DATE
WHERE YEAR >= 2005
GROUP BY Country, State
/**WE CAN USE THE BELOW QUERY FOR DISTINCT STATES. AND TO GET THE COUNT WE CAN USE THE ABOVE QUERY*/
SELECT DISTINCT State
FROM DIM_LOCATION
INNER JOIN FACT_TRANSACTIONS ON DIM_LOCATION.IDLocation = FACT_TRANSACTIONS.IDLocation 
INNER JOIN DIM_DATE ON FACT_TRANSACTIONS.DATE = DIM_DATE.DATE
WHERE YEAR >= 2005
================================================================================================================================================
--2.	What state in the US is buying more 'Samsung' cell phones?
SELECT Country, State, COUNT(State) AS State_Count, Quantity, Manufacturer_Name
FROM DIM_LOCATION 
INNER JOIN FACT_TRANSACTIONS ON DIM_LOCATION.IDLocation = FACT_TRANSACTIONS.IDLocation
INNER JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
INNER JOIN DIM_MANUFACTURER ON DIM_MODEL.IDManufacturer = DIM_MANUFACTURER.IDManufacturer
WHERE Manufacturer_Name = 'Samsung'
AND Country = 'US'
GROUP BY Country, State, Quantity, Manufacturer_Name
================================================================================================================================================
--3.	Show the number of transactions for each model per zip code per state.
SELECT ZipCode, Country, State, FACT_TRANSACTIONS.IDModel, Quantity, DIM_MODEL.IDModel, Model_Name, COUNT(Model_Name) ModelCount 
FROM DIM_LOCATION 
INNER JOIN FACT_TRANSACTIONS ON DIM_LOCATION.IDLocation = FACT_TRANSACTIONS.IDLocation
INNER JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
GROUP BY ZipCode, Country, State, FACT_TRANSACTIONS.IDModel, Quantity, DIM_MODEL.IDModel, Model_Name
================================================================================================================================================
--4.	Show the cheapest cellphone
SELECT top 1 Model_Name, Unit_price, Manufacturer_Name 
FROM DIM_MODEL 
INNER JOIN DIM_MANUFACTURER ON DIM_MODEL.IDManufacturer = DIM_MANUFACTURER.IDManufacturer
ORDER BY Unit_price
================================================================================================================================================
--5. Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price.
SELECT TOP 5 Manufacturer_Name, Model_Name, Unit_price, AVG(TotalPrice) AS AVG_PRICE, Quantity 
FROM DIM_MANUFACTURER 
INNER JOIN DIM_MODEL ON DIM_MANUFACTURER.IDManufacturer = DIM_MODEL.IDManufacturer
INNER JOIN FACT_TRANSACTIONS ON DIM_MODEL.IDModel = FACT_TRANSACTIONS.IDModel
GROUP BY Manufacturer_Name, Model_Name, Unit_price, Quantity
ORDER BY Quantity, AVG(TOTALPRICE)
================================================================================================================================================
--6. List the names of the customers and the average amount spent in 2009, where the average is higher than 500
SELECT Customer_Name, AVG(TotalPrice) AS Amt_Spent, YEAR	
FROM DIM_CUSTOMER AS C 
INNER JOIN  FACT_TRANSACTIONS AS T on C.IDCustomer = T.IDCustomer
INNER JOIN DIM_DATE as D ON T.Date = d.DATE
WHERE YEAR = 2009
GROUP BY Customer_Name, YEAR
Having AVG(TotalPrice) > 500	
================================================================================================================================================
--7. List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010
SELECT TOP 5 YEAR, SUM(Quantity) AS QUANT, Model_Name 
FROM DIM_DATE
INNER JOIN FACT_TRANSACTIONS ON DIM_DATE.DATE = FACT_TRANSACTIONS.Date
INNER JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
WHERE YEAR IN (2008, 2009, 2010)
GROUP BY YEAR, Model_Name 
================================================================================================================================================
--8.Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.
SELECT top 2 DIM_MANUFACTURER.IDManufacturer, SUM(TotalPrice) AS TotalSalesPrice, YEAR, Manufacturer_Name 
FROM DIM_DATE 
INNER JOIN FACT_TRANSACTIONS ON DIM_DATE.Date=FACT_TRANSACTIONS.DATE
INNER JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel=DIM_MODEL.IDModel
INNER JOIN DIM_MANUFACTURER ON DIM_MODEL.IDManufacturer=DIM_MANUFACTURER.IDManufacturer
WHERE YEAR=2009
OR YEAR=2010
GROUP BY DIM_MANUFACTURER.IDManufacturer, DIM_DATE.YEAR, Manufacturer_Name
ORDER BY YEAR, TotalSalesPrice DESC
================================================================================================================================================
--9. Show the manufacturers that sold cellphone in 2010 but didn’t in 2009.
SELECT YEAR, DIM_MODEL.IDManufacturer, DIM_MANUFACTURER.IDManufacturer, Manufacturer_Name
FROM DIM_DATE 
INNER JOIN FACT_TRANSACTIONS ON DIM_DATE.Date = FACT_TRANSACTIONS.DATE
INNER JOIN DIM_MODEL ON FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
INNER JOIN DIM_MANUFACTURER ON DIM_MODEL.IDManufacturer = DIM_MANUFACTURER.IDManufacturer
WHERE YEAR = 2010
AND YEAR <> 2009
================================================================================================================================================
--10. Find top 100 customers and their average spend, average quantity by each year. Also find the percentage of change in their spend.
SELECT TOP 100 Customer_Name, TotalPrice, AVG(TOTALPRICE) AS AVG_SPEND, AVG(QUANTITY) AS AVG_QTY, Quantity,YEAR
FROM DIM_CUSTOMER INNER JOIN FACT_TRANSACTIONS ON DIM_CUSTOMER.IDCustomer = FACT_TRANSACTIONS.IDCustomer
INNER JOIN DIM_DATE ON FACT_TRANSACTIONS.Date = DIM_DATE.DATE
GROUP BY Customer_Name, TotalPrice, Quantity,YEAR
ORDER BY AVG_SPEND DESC

=====================================================================================================================================================================
--SELECTION OF ALL TABLES FOR REFERENCE
SELECT * FROM DIM_MANUFACTURER
SELECT * FROM DIM_MODEL 
SELECT * FROM DIM_CUSTOMER
SELECT * FROM DIM_LOCATION
SELECT * FROM DIM_DATE
SELECT * FROM FACT_TRANSACTIONS