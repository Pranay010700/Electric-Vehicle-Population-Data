-- 1.Find the most popular electric vehicle type per year
Use mydb;
SELECT Model_Year, Electric_Vehicle_Type_Description, MAX(Vehicle_Count) AS Max_Vehicle_Count 
FROM (
    SELECT Fact.Model_Year, Vehicle_Type.Electric_Vehicle_Type_Description, COUNT(*) AS Vehicle_Count
    FROM Fact
    JOIN Vehicle_Type ON Fact.Electric_vehicle_Type = Vehicle_Type.Electric_Vehicle_Type
    GROUP BY Fact.Model_Year, Vehicle_Type.Electric_Vehicle_Type_Description
) AS SubQuery
GROUP BY Model_Year,Electric_Vehicle_Type_Description
Order by Model_Year;


-- 2.Find the top 3 vehicle makes with the most electric vehicles each ye
SELECT Model_Year, Make, Vehicle_Count
FROM (
    SELECT Fact.Model_Year, Model.Make, COUNT(*) AS Vehicle_Count, 
    ROW_NUMBER() OVER(PARTITION BY Fact.Model_Year ORDER BY COUNT(*) DESC) as rn
    FROM Fact
    JOIN Model ON Fact.Model = Model.Model
    GROUP BY Fact.Model_Year, Model.Make
) AS SubQuery
WHERE rn <= 3;


-- 3.Find the average Base MSRP of electric vehicles per year, broken down by CAFV eligibility:
SELECT Fact.Model_Year, CAFV.CAFV_Eligibility_Description, AVG(Fact.Base_MSRP) AS Average_MSRP
FROM Fact
JOIN CAFV ON Fact.CAFV_Eligibility = CAFV.CAFV_Eligibility
GROUP BY Fact.Model_Year, CAFV.CAFV_Eligibility_Description
Order by Average_MSRP DESC;

-- 4.Find the county with the most electric vehicles for each electric vehicle type:
SELECT EV_Type, county, MAX(Vehicle_Count) as Max_Vehicle_Count
FROM (
    SELECT Vehicle_Type.Electric_Vehicle_Type_Description AS EV_Type, Location.county, COUNT(*) AS Vehicle_Count
    FROM Fact
    JOIN Vehicle_Type ON Fact.Electric_vehicle_Type = Vehicle_Type.Electric_Vehicle_Type
    JOIN Location ON Fact.DOL_Vehicle_ID = Location.DOL_Vehicle_ID
    GROUP BY EV_Type, Location.county
) AS SubQuery
GROUP BY EV_Type, county
order by Max_vehicle_count DESC;

-- 5.number of cars by year
SELECT Model_Year, COUNT(*) as Number_of_Cars
FROM Fact
GROUP BY Model_Year
ORDER BY Model_Year;

-- 6.average electric range of each vehicle type
SELECT Vehicle_Type.Electric_Vehicle_Type_Description, AVG(Fact.Electric_Range)
FROM Fact
JOIN Vehicle_Type ON Fact.Electric_vehicle_Type = Vehicle_Type.Electric_Vehicle_Type
GROUP BY Vehicle_Type.Electric_Vehicle_Type_Description;

-- 7.number of electric vehicles per legislative district
SELECT Location.Legislative_District, COUNT(*)
FROM Fact
JOIN Location ON Fact.DOL_Vehicle_ID = Location.DOL_Vehicle_ID
GROUP BY Location.Legislative_District;


-- 8.number of electric vehicles for each electric utility
SELECT Location.Electric_Utility, COUNT(*) as count
FROM Fact
JOIN Location ON Fact.DOL_Vehicle_ID = Location.DOL_Vehicle_ID
GROUP BY Location.Electric_Utility
Order by count DESC;

-- 9.model year with the highest average base MSRP for electric vehicles
SELECT Fact.Model_Year, AVG(Fact.Base_MSRP) as Average_MSRP
FROM Fact
GROUP BY Fact.Model_Year
ORDER BY Average_MSRP DESC
LIMIT 1;








