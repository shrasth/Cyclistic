--Creating separating table for analysis
CREATE TABLE Cyclistic(
	ride_id nvarchar(250),
	rideable_type nvarchar(250),
	started_at datetime,
	ended_at datetime,
	start_station_name nvarchar(250),
	end_station_name nvarchar(250),
	member_casual nvarchar(250),
);

--Inserting data in new table
INSERT INTO Cyclistic (ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual)
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Jan_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Jan_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Feb_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Mar_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Apr_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM May_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Jun_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Jul_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Aug_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Sept_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Oct_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Nov_2022_tripdata
UNION
SELECT ride_id, rideable_type, started_at, ended_at,start_station_name,end_station_name,member_casual FROM Dec_2022_tripdata;

SELECT *
FROM Cyclistic;

-- Ride length in minutes
ALTER TABLE Cyclistic	
ADD time_in_minutes int;

UPDATE Cyclistic
SET time_in_minutes = DATEDIFF(MINUTE,started_at, ended_at);

--Adding day of the week

ALTER TABLE Cyclistic
ADD started_day VARCHAR(250);

UPDATE Cyclistic
SET started_day = DATENAME(dw,started_at);

--Adding Month-- 
ALTER TABLE Cyclistic
ADD Month_Name VARCHAR(250);

UPDATE Cyclistic
SET Month_Name = DATENAME(month,started_at);

--Adding route

ALTER TABLE Cyclistic
ADD route varchar(250);

UPDATE Cyclistic
SET route = CONCAT(start_station_name, ' to ', end_station_name);

SELECT *
FROM Cyclistic;

---------Analysis-----------
---Total duration (Yearly) for member casual

SELECT member_casual, SUM(time_in_minutes) AS Total_duration
FROM Cyclistic
GROUP BY member_casual;

--Total monthly rides
SELECT Month_Name AS Month, COUNT(ride_id) AS Total_rides
FROM Cyclistic
GROUP BY Month_Name
ORDER BY MONTH(CONCAT('2000-', Month_Name, '-01'));

--- Monthly rides between members and casuals

SELECT Month_Name, 
       SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member_trips,
       SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual_trips
FROM Cyclistic
GROUP BY Month_Name
ORDER BY MONTH(CONCAT('2000-', Month_Name, '-01'));

-- Total_rideable_type with all values

SELECT rideable_type,COUNT(rideable_type) AS total_ride_type
FROM Cyclistic
GROUP by rideable_type
ORDER BY COUNT(rideable_type) DESC;

--Total rideable type for member and casuals

SELECT rideable_type,
       COUNT(CASE WHEN member_casual = 'member' THEN 1 END) AS member,
       COUNT(CASE WHEN member_casual = 'casual' THEN 1 END) AS casual
FROM Cyclistic
GROUP BY rideable_type
ORDER BY COUNT(rideable_type) DESC;

--- Average ride length 

SELECT AVG(time_in_minutes) AS Avg_ride_length
FROM Cyclistic
WHERE time_in_minutes >2;

--- Average ride length for member casual

SELECT member_casual, AVG(time_in_minutes) AS Avg_ride_length
FROM Cyclistic
WHERE time_in_minutes >2
GROUP BY member_casual;

--Average Monthly ride length

SELECT Month_Name AS Month, AVG(time_in_minutes) AS Avg_ride_length
FROM Cyclistic
WHERE time_in_minutes > 2
GROUP BY MONTH(started_at), Month_Name
ORDER BY MONTH(started_at) ASC;

----- Average day ride length---

SELECT started_day AS Day, AVG(time_in_minutes) AS avg_time
FROM Cyclistic
WHERE time_in_minutes > 2
GROUP BY started_day
ORDER BY (CASE started_day
             WHEN 'Monday' THEN 1
             WHEN 'Tuesday' THEN 2
             WHEN 'Wednesday' THEN 3
             WHEN 'Thursday' THEN 4
             WHEN 'Friday' THEN 5
             WHEN 'Saturday' THEN 6
             WHEN 'Sunday' THEN 7
           END);


-- most preferable day

SELECT started_day As Day, COUNT(started_day) AS Total
FROM Year_2022
GROUP BY started_day
ORDER BY Total DESC;

--- most preferable day for member_Casual

---Member

SELECT started_day As Day, COUNT(started_day) AS Total
FROM Cyclistic
WHERE  member_casual = 'member'
GROUP BY started_day
ORDER BY Total DESC;

--Casual

SELECT started_day As Day, COUNT(started_day) AS Total
FROM Cyclistic
WHERE member_casual = 'casual'
GROUP BY started_day
ORDER BY Total DESC;

--- Hourly Analysis (Peak hours) ---

SELECT COUNT(ride_id) AS Number_of_Trips,  
         LEFT(CONVERT(VARCHAR(20), started_at, 108),2) AS TIMEPART
FROM Cyclistic
GROUP BY LEFT(CONVERT(VARCHAR(20), started_at, 108),2);


--- Hourly analysis for member_casual--

SELECT LEFT(CONVERT(VARCHAR(20), started_at, 108),2) AS TIMEPART, 
       SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS member_trips,
       SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS casual_trips
FROM Cyclistic
GROUP BY LEFT(CONVERT(VARCHAR(20), started_at, 108),2)
ORDER BY LEFT(CONVERT(VARCHAR(20), started_at, 108),2) ASC;


----- Top 5 most travelled routes

SELECT TOP (5) route, COUNT(route) AS total_trips
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
GROUP BY route
ORDER BY COUNT(route) DESC;


--- TOP 5 most travelled routes  member_casual

SELECT TOP (5) route, COUNT(member_casual) AS total_rides_member
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND member_casual = 'member'
GROUP BY route,member_casual
ORDER BY COUNT(route) DESC;


SELECT TOP (5) route,  COUNT(member_casual) AS total_rides_casual
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND member_casual = 'casual'
GROUP BY route,member_casual
ORDER BY COUNT(route) DESC; 


--- Top 5 longest duration trips(in minutes)

SELECT TOP (5) route, SUM(time_in_minutes) AS trip_duration
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
GROUP BY route
ORDER BY SUM(time_in_minutes) DESC;

---Top 5 longest duration trips(in minutes) member_casual

SELECT TOP (5) route, SUM(time_in_minutes) AS trip_duration_members
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND member_casual = 'member'
GROUP BY route,member_casual
ORDER BY SUM(time_in_minutes) DESC;


SELECT TOP (5) route, SUM(time_in_minutes) AS trip_duration_casuals
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND member_casual = 'casual'
GROUP BY route,member_casual
ORDER BY SUM(time_in_minutes) DESC;


-- Most popular station for pickup

SELECT TOP (5) start_station_name, COUNT(start_station_name) AS total_count
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY COUNT(start_station_name) DESC;


---Top 5 pickup station based on member_casual

SELECT TOP (5) start_station_name,  COUNT(member_casual) AS total_count_member
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND member_casual = 'member'
GROUP BY start_station_name,member_casual
ORDER BY COUNT(start_station_name) DESC;


SELECT TOP (5) start_station_name,  COUNT(member_casual) AS total_count_casual
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND member_casual = 'casual'
GROUP BY start_station_name,member_casual
ORDER BY COUNT(start_station_name) DESC;


--- Most popular station for dropoff

SELECT TOP (5) end_station_name, COUNT(end_station_name) AS total_count
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL
GROUP BY end_station_name
ORDER BY COUNT(end_station_name) DESC;


---Top 5 dropoff station based on member_casual ( end_station)

SELECT TOP (5) end_station_name,  COUNT(member_casual) AS total_count_member
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND member_casual = 'member'
GROUP BY end_station_name,member_casual
ORDER BY COUNT(end_station_name) DESC;


SELECT TOP (5) end_station_name,  COUNT(member_casual) AS total_count_casual
FROM Cyclistic
WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL AND member_casual = 'casual'
GROUP BY end_station_name,member_casual
ORDER BY COUNT(end_station_name) DESC;