/*
In this case study, we'll be looking at an every day Retail Store Data. 
The goals are to look at the customer's demographic, total revenue and transactions, and rating our products.

This data was created by Darpan Bajaj https://www.kaggle.com/darpan25bajaj/retail-case-study-data
*/

SELECT *
FROM Transactions

SELECT *
FROM Customer

SELECT *
FROM prod_cat_info

--- Cleaning Data
--- Convert tran_date and DOB to Date
UPDATE Customer
SET DOB = CONVERT(date,DOB,105) 

UPDATE Transactions
SET tran_date = CONVERT(date,tran_date,105)







--- Join Tables
SELECT transaction_id, cust_id, tran_date, Transactions.prod_subcat_code, Transactions.prod_cat_code, Qty, Rate, Tax, 
total_amt, Store_type, DOB, Gender, city_code, prod_cat, prod_subcat INTO combined_data
FROM Transactions
INNER JOIN Customer
ON Transactions.cust_id = Customer.customer_id
INNER JOIN prod_cat_info
ON prod_cat_info.prod_cat_code = Transactions.prod_cat_code AND prod_cat_info.prod_sub_cat_code = Transactions.prod_subcat_code

SELECT *
FROM combined_data







--- Daily/Monthly/Quarterly/Yearly Transactions
--- Daily Transaction
SELECT tran_date, COUNT(tran_date) AS number_of_transactions
FROM combined_data
GROUP BY tran_date
ORDER BY tran_date 

--- Monthly
SELECT DATEPART(MONTH, tran_date) AS tran_month, DATEPART(Year, tran_date) AS tran_year, SUM(total_amt) AS monthly_amt
FROM combined_data
GROUP BY DATEPART(MONTH,tran_date), DATEPART(Year, tran_date)
Order BY tran_year, tran_month

--- Quarterly
SELECT DATEPART(QUARTER, tran_date) AS tran_quarter, DATEPART(Year, tran_date) AS tran_year, SUM(total_amt) AS quarterly_amt
FROM combined_data
GROUP BY DATEPART(Quarter,tran_date), DATEPART(Year, tran_date)
Order BY tran_year, tran_quarter

--- Yearly
SELECT DATEPART(Year, tran_date) AS tran_year, SUM(total_amt) AS yearly_amt
FROM combined_data
GROUP BY DATEPART(Year,tran_date)
Order BY tran_year








--- Demographic Data:
--- Customers' Gender makeup?
SELECT Gender, COUNT(Gender) AS gender_count
FROM combined_data
GROUP BY Gender

--- How Old are our Customers? 
WITH CTE AS (
SELECT DATEDIFF(YEAR, DOB,getdate()) AS Age
FROM combined_data)

SELECT AVG(Age) as avg_age, MIN(Age) as min_age, MAX(Age) as max_age
FROM CTE

--- Customers' City Code?
SELECT city_code, COUNT(city_code) AS city_code_count
FROM combined_data
GROUP BY city_code
ORDER BY city_code

--- Customer Yearly Spend
SELECT cust_id, SUM(total_amt), DATEPART(Year, tran_date) AS tran_year
FROM combined_data
GROUP BY cust_id, DATEPART(Year, tran_date)
ORDER BY cust_id, tran_year

--- Each Customers first transaction (amount and product category)
SELECT A.transaction_id, A.cust_id, A.tran_date, A.prod_cat, A.prod_subcat, A.total_amt
FROM combined_data AS A
INNER JOIN
(SELECT cust_id, MIN(tran_date) AS first_transaction
FROM combined_data
GROUP BY cust_id) AS B
ON A.cust_id = B.cust_id AND A.tran_date = B.first_transaction
ORDER BY tran_date







--- Popular Product Category and Sub Category
--- Highest Quantity and Revenue
SELECT prod_cat, prod_subcat, SUM(Qty) AS qty_sold, SUM(total_amt) AS total_amt
FROM combined_data
Group By prod_cat, prod_subcat
ORDER BY SUM(total_amt)

--- Highest Number of Returns
SELECT prod_cat, prod_subcat, COUNT(Qty) AS number_returns
FROM combined_data
WHERE Qty < 0
Group By prod_cat, prod_subcat
ORDER BY COUNT(Qty) DESC

