SELECT *
FROM arabica_data


--- Change column1 into id (44 columns)
EXEC sp_rename 'arabica_data.column1', 'id', 'COLUMN' 



--- Delete Duplicates
WITH RowCTE AS(
	SELECT *,
           ROW_NUMBER() 
		   OVER(PARTITION BY Owner, 
							farm_name, 
							Country_of_Origin,
							Region,
							Producer,
							In_Country_Partner,
							Expiration,
							Variety,
							Aroma,
							Flavor,
							Aftertaste,
							Acidity,
							Total_Cup_Points
         Order BY id ) AS DuplicateCount
    FROM arabica_data)
SELECT *
FROM RowCTE 
--- No duplicates were found




--- Convert Number_of_Bags to int

UPDATE arabica_data
SET Number_of_Bags = CAST(Number_of_Bags AS int)



--- Convert Bag_Weight to float and into kg

SELECT Bag_Weight, REPLACE(REPLACE(REPLACE(Bag_Weight, 'kg', ''), 'lbs', ''),',','') AS bag_weight_kg
FROM arabica_data

SELECT Bag_Weight, bag_weight_kg,
	CASE
	WHEN Bag_Weight LIKE '%lbs%' THEN bag_weight_kg*.453
	ELSE bag_weight_kg END AS weight
FROM arabica_data
WHERE Bag_Weight LIKE '%lbs%'



ALTER TABLE arabica_data --- add column first
ADD bag_weight_kg float;

UPDATE arabica_data --- input data from removed characters from Bag_Weight
SET bag_weight_kg = REPLACE(REPLACE(REPLACE(Bag_Weight, 'kg', ''), 'lbs', ''),',','')

UPDATE arabica_data --- converting lbs to kg
SET bag_weight_kg = CASE
	WHEN Bag_Weight LIKE '%lbs%' THEN bag_weight_kg*.453
	ELSE bag_weight_kg END

SELECT Bag_Weight, bag_weight_kg
FROM arabica_data




--- Format Grading_Date and Expiration *******
--- Get rid of 'th' 'st' 'rd' 'nd'
WITH dCTE AS(
SELECT Grading_Date,
REPLACE(REPLACE(REPLACE(REPLACE(Grading_Date, 'th', ''), 'st', ''),'rd',''),'nd','') AS grade_date
FROM arabica_data)

--- YYYYMMDD format

SELECT *,
LEFT(gd,3) AS g_month,
RIGHT(gd,7) AS g_dny
FROM dCTE

WITH dateCTE AS(
SELECT g_dny, gd,
RIGHT(g_dny,4) AS g_year,
REPLACE(LEFT(g_dny,2),' ','0') AS g_day,
CASE 
WHEN LEFT(gd,3) = 'Jan' THEN '01'
WHEN LEFT(gd,3) = 'Feb' THEN '02'
WHEN LEFT(gd,3) = 'Mar' THEN '03'
WHEN LEFT(gd,3) = 'Apr' THEN '04'
WHEN LEFT(gd,3) = 'May' THEN '05'
WHEN LEFT(gd,3) = 'Jun' THEN '06'
WHEN LEFT(gd,3) = 'Jul' THEN '07'
WHEN LEFT(gd,3) = 'Aug' THEN '08'
WHEN LEFT(gd,3) = 'Sep' THEN '09'
WHEN LEFT(gd,3) = 'Oct' THEN '10'
WHEN LEFT(gd,3) = 'Nov' THEN '11'
WHEN LEFT(gd,3) = 'Dec' THEN '12'
ELSE gd END AS g_month
FROM arabica_data)

SELECT *,
CAST((g_year +'-'+ g_month +'-'+ g_day) AS datetime) AS grade_date --- Still getting an error
FROM dateCTE

--- Format Grade Date
ALTER TABLE arabica_data
ADD gd varchar(50);

ALTER TABLE arabica_data
ADD g_dny varchar(7);

ALTER TABLE arabica_data
ADD g_day varchar(2)

ALTER TABLE arabica_data
ADD g_year varchar(4)

ALTER TABLE arabica_data
ADD g_month varchar(2)

ALTER TABLE arabica_data
ADD grade_date varchar(100);

UPDATE arabica_data
SET gd = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Grading_Date, 'th', ''), 'st', ''),'rd',''),'nd',''),',','')

UPDATE arabica_data
SET g_dny = RIGHT(gd,7)

UPDATE arabica_data
SET g_day = REPLACE(LEFT(g_dny,2),' ','0')

UPDATE arabica_data
SET g_month = CASE 
WHEN LEFT(gd,3) = 'Jan' THEN '01'
WHEN LEFT(gd,3) = 'Feb' THEN '02'
WHEN LEFT(gd,3) = 'Mar' THEN '03'
WHEN LEFT(gd,3) = 'Apr' THEN '04'
WHEN LEFT(gd,3) = 'May' THEN '05'
WHEN LEFT(gd,3) = 'Jun' THEN '06'
WHEN LEFT(gd,3) = 'Jul' THEN '07'
WHEN LEFT(gd,3) = 'Aug' THEN '08'
WHEN LEFT(gd,3) = 'Sep' THEN '09'
WHEN LEFT(gd,3) = 'Oct' THEN '10'
WHEN LEFT(gd,3) = 'Nov' THEN '11'
WHEN LEFT(gd,3) = 'Dec' THEN '12'
ELSE gd END

UPDATE arabica_data
SET g_year = RIGHT(g_dny,4)

UPDATE arabica_data
SET grade_date = (g_year +'-'+ g_month +'-'+ g_day)

--- Format Expiration Date
ALTER TABLE arabica_data
ADD ed varchar(50);

ALTER TABLE arabica_data
ADD e_dny varchar(7);

ALTER TABLE arabica_data
ADD e_day varchar(2)

ALTER TABLE arabica_data
ADD e_year varchar(4)

ALTER TABLE arabica_data
ADD e_month varchar(2)

ALTER TABLE arabica_data
ADD expiration_date varchar(100);

UPDATE arabica_data
SET ed = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Expiration, 'th', ''), 'st', ''),'rd',''),'nd',''),',','')

UPDATE arabica_data
SET e_dny = RIGHT(ed,7)

UPDATE arabica_data
SET e_day = REPLACE(LEFT(e_dny,2),' ','0')

UPDATE arabica_data
SET e_month = CASE 
WHEN LEFT(ed,3) = 'Jan' THEN '01'
WHEN LEFT(ed,3) = 'Feb' THEN '02'
WHEN LEFT(ed,3) = 'Mar' THEN '03'
WHEN LEFT(ed,3) = 'Apr' THEN '04'
WHEN LEFT(ed,3) = 'May' THEN '05'
WHEN LEFT(ed,3) = 'Jun' THEN '06'
WHEN LEFT(ed,3) = 'Jul' THEN '07'
WHEN LEFT(ed,3) = 'Aug' THEN '08'
WHEN LEFT(ed,3) = 'Sep' THEN '09'
WHEN LEFT(ed,3) = 'Oct' THEN '10'
WHEN LEFT(ed,3) = 'Nov' THEN '11'
WHEN LEFT(ed,3) = 'Dec' THEN '12'
ELSE ed END

UPDATE arabica_data
SET e_year = RIGHT(e_dny,4)

UPDATE arabica_data
SET expiration_date = (e_year +'-'+ e_month +'-'+ e_day)

SELECT *
FROM arabica_data





--- Cleaning Harvest_Year into same format
--- ASSUMPTION: tendency for harvest year to be either the grading year or 1 year less
SELECT Harvest_Year
FROM arabica_data

--- Harvest_Year data containing letters
SELECT Harvest_Year, Grading_Date
FROM arabica_data
WHERE Harvest_Year LIKE '%[a-z]%' 
--- Months, 4T, etc. 
WITH hCTE AS(
SELECT Harvest_Year,
REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(REPLACE (
       REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(REPLACE (
       REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(
       REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(REPLACE(
	   REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
	   REPLACE(REPLACE(REPLACE
      (Harvest_Year,'4T7',''),'47/',''),'4t/10','2010'),'3t/',''),'1t/',''),'4t/','')--- Get rid of letters and special instances
					,'May-August',''),'Abril - Julio',''),'Abril - Julio /','')
					,'A', '') , 'B', ''), 'C', ''), 'D', ''), 'E', ''), 'F', ''), 'G', '') 
                    , 'H', ''), 'I', ''), 'J', ''), 'K', ''), 'L', ''), 'M', '') 
                    , 'N', ''), 'O', ''), 'P', ''), 'Q', ''), 'R', ''), 'S', '')
                    , 'T', ''), 'U', ''), 'V', ''), 'W', ''), 'X', ''), 'y', '')
                    , 'Z', ''),'23',''),'/','-'),' ','')   AS hy --- Get rid of some dashes and extra white space
FROM arabica_data)

SELECT *
FROM hCTE

ALTER TABLE arabica_data
ADD harvesting_year varchar(50);

UPDATE arabica_data
SET harvesting_year = REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(REPLACE (
       REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(REPLACE (
       REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(
       REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (REPLACE(REPLACE(
	   REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
	   REPLACE(REPLACE(REPLACE
      (Harvest_Year,'4T7',''),'47/',''),'4t/10','2010'),'3t/',''),'1t/',''),'4t/','')
					,'May-August',''),'Abril - Julio',''),'Abril - Julio /','')
					,'A', '') , 'B', ''), 'C', ''), 'D', ''), 'E', ''), 'F', ''), 'G', '') 
                    , 'H', ''), 'I', ''), 'J', ''), 'K', ''), 'L', ''), 'M', '') 
                    , 'N', ''), 'O', ''), 'P', ''), 'Q', ''), 'R', ''), 'S', '')
                    , 'T', ''), 'U', ''), 'V', ''), 'W', ''), 'X', ''), 'y', '')
                    , 'Z', ''),'23',''),'/','-'),' ','') 