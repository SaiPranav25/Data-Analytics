EXEC sp_rename 'smart_city_dataset_cleaned', 'smart_city_dataset';

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

--Viewing all data 
SELECT * FROM smart_city_dataset;


--Converting the data upto two decimal points
SELECT 
  City_Name,
  CAST(ROUND(Population, 2) AS FLOAT) AS Population,
  CAST(ROUND(Area_sq_km, 2) AS FLOAT) AS Area_sq_km,
  CAST(ROUND(Smart_Infrastructure_Score, 2) AS FLOAT) AS Smart_Infrastructure_Score,
  CAST(ROUND(Energy_Consumption, 2) AS FLOAT) AS Energy_Consumption,
  CAST(ROUND(Public_Transport_Usage, 2) AS FLOAT) AS Public_Transport_Usage,
  CAST(ROUND(Air_Quality_Index, 2) AS FLOAT) AS Air_Quality_Index,
  CAST(ROUND(Education_Index, 2) AS FLOAT) AS Education_Index,
  CAST(ROUND(Healthcare_Index, 2) AS FLOAT) AS Healthcare_Index,
  CAST(ROUND(Employment_Rate, 2) AS FLOAT) AS Employment_Rate
INTO smart_city
FROM smart_city_dataset;



--Check basic statistics
select 
COUNT(*) as Total_Cities,
MIN(CAST(Population AS BIGINT)) as min_population,
MAX(CAST(Population AS BIGINT)) as max_population,
AVG(CAST(Population AS DECIMAL(18,2))) as avg_population
from smart_city;

--Categorize population
select *,
CASE 
WHEN Population < 100000 then 'Very small city'
WHEN Population between 100000 and 1000000 then 'Small city'
WHEN Population between 1000000 and 5000000 then 'Medium city'
ELSE 'Large city'
END AS City_category
from smart_city;

--Smallest cities
select top 10 City_Name, Smart_Infrastructure_Score
from smart_city
order by  Smart_Infrastructure_Score desc;

--Comparing Education Index and Healthcare Index
select City_Name, Education_Index, Healthcare_Index
from smart_city
order by Education_Index desc, Healthcare_Index desc;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'smart_city';

--To understnad which is the best city to live
select City_Name, Public_Transport_Usage, Air_Quality_Index
from smart_city
order by Public_Transport_Usage desc, Air_Quality_Index desc;

--Cities that need economic support
select City_Name, Employment_Rate
from smart_city
where Employment_Rate < 30
order by Employment_Rate;

--Creating view on wellbeing 
create view
city_wellbeing_summary as
select City_Name,Education_Index,Healthcare_Index,(Education_Index + Healthcare_Index) / 2.0 as Wellbeing_Score
from smart_city;
select * from city_wellbeing_summary order by Wellbeing_Score desc;

--Cities with better wellbeing score
select City_Name, Education_Index, Healthcare_Index,(Education_Index + Healthcare_Index) / 2.0 as Wellbeing_Score
from smart_city
where (Education_Index + Healthcare_Index) / 2.0 >
(select AVG((Education_Index + Healthcare_Index) / 2.0) from smart_city)
order by Wellbeing_Score desc;


--Most balanced cities
select top 10 City_Name,Smart_Infrastructure_Score,Education_Index,Healthcare_Index,Employment_Rate,
ROUND((Smart_Infrastructure_Score + Education_Index + Healthcare_Index + Employment_Rate) / 4.0, 2) AS Balanced_Score
from smart_city
order by Balanced_Score desc;

--Are large cities smarter
select City_Name, Area_sq_km, Smart_Infrastructure_Score
from smart_city
order by Area_sq_km desc;

--top smart cities using procedure
CREATE PROCEDURE GetTopSmartCities
@x int
as
BEGIN
select top (@x) City_Name, Smart_Infrastructure_Score
from smart_city
order by Smart_Infrastructure_Score desc;
END;
EXEC GetTopSmartCities @x = 5;

