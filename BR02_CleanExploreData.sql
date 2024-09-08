/* BIKE RIDING PROJECT (PART II)

1. Duplicates (Window functions)
2. Explore general view (Information schema, Count, Group by, Distinct)
3. Null values (Sum, Case, Delete)
4. Adding data and cleaning (Create, DayName, MonthName, Hour, TIMESTAMPDIFF)
5. Export cleaned table to CSV file
6. Indexes
*/

-----------------------------------------------------------------------------------------------------------------
-- 1. Duplicates
-- 1.1 Identify if duplicates exist
-- Option A: I used this option on my first attempt of identifying duplicates. Checking on ride_id as it is supposed to be a unique value. Result: 0 duplicates
/* select COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicates
FROM `2023_combined`; */

-- Option B: I learned later that I can use window functions to identify duplicates. Duplicates = 0.
WITH rownum_cte AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY ride_id, started_at, ended_at) AS row_num
FROM `2023_combined`
)
SELECT *
FROM rownum_cte
WHERE row_num >1;
/* If duplicates are found CTEs don't allow to delete data imediately within the same query
It is necessary to create a copy of the table but adding an extra column for row_num and then inserting the query with row_num ()
after that the DELETE can be applied based on the WHERE condition > 1 */


 -----------------------------------------------------------------------------------------------------------
-- 2. Explore general view
-- 2.1 Checking number of registers: 5.719.877 
SELECT count(*)
FROM `2023_combined`;

-- 2.2 Checking schema's properties in case it can't be seen in other way
SELECT column_name, data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = '2023_combined';

-- 2.3 Explore unique values. 
-- Bikes rideable_type = 3
SELECT COUNT(DISTINCT rideable_type)
FROM `2023_combined`;

-- Type of members = 2
SELECT COUNT(DISTINCT member_casual)
FROM `2023_combined`;

-- Start station = 1592 unique values
SELECT COUNT(DISTINCT start_station_name)
FROM `2023_combined`;

-- End station = 1597 unique values
SELECT COUNT(DISTINCT end_station_name)
FROM `2023_combined`;


 -----------------------------------------------------------------------------------------------------------
-- 3. Null values
-- 3.1 Number of Null values in each column in one view. Using CASE and SUM to recognise null values and count how many are there
SELECT 
	SUM(CASE WHEN ride_id is null THEN 1 ELSE 0 END) AS "ride_id_Null",
	SUM(CASE WHEN rideable_type is null THEN 1 ELSE 0 END) AS "rideable_type_Null", 
    SUM(CASE WHEN started_at is null THEN 1 ELSE 0 END) AS "started_at_Null",
    SUM(CASE WHEN ended_at is null THEN 1 ELSE 0 END) AS "ended_At_Null",
    SUM(CASE WHEN start_station_name is null THEN 1 ELSE 0 END) AS "start_station_name_Null", -- 875716
	SUM(CASE WHEN start_station_id is null THEN 1 ELSE 0 END) AS "start_Station_id_Null", -- 875716
    SUM(CASE WHEN end_station_name is null THEN 1 ELSE 0 END) AS "end_station_name_Null", -- 929202
    SUM(CASE WHEN end_station_id is null THEN 1 ELSE 0 END) AS "end_Station_id_Null", -- 929202
    SUM(CASE WHEN start_lat is null THEN 1 ELSE 0 END) AS "start_lat_Null",
    SUM(CASE WHEN start_lng is null THEN 1 ELSE 0 END) AS "start_lng_Null",
    SUM(CASE WHEN end_lat is null THEN 1 ELSE 0 END) AS "end_lat_Null", -- 6990
    SUM(CASE WHEN end_lng is null THEN 1 ELSE 0 END) AS "end_lng_Null", -- 6990
    SUM(CASE WHEN member_casual is null THEN 1 ELSE 0 END) AS "member_Casual_Null",
	COUNT(ride_id) AS "Non-Null Values" -- 5719877 non-null, which coincides with result in query #1
    FROM `2023_combined`;
 

 -- 3.2 (OPTIONAL) Counts the records that are NULL for both start_station and end_station. 
 -- This was used to compare how many registers would be affected if I deleted all those null values: 417110. Roughly 7% of the data.
SELECT COUNT(*)
FROM `2023_combined`
WHERE (start_Station_name IS NULL AND end_station_name IS NULL);

 -----------------------------------------------------------------------------------------------------------
-- 4. Adding data and cleaning
/* OPTION 1: Create new table adding details about the duration of the trips 
This also filters all the 'invalid' ride_lenghts that are less than 1 minute or longer than 24 hrs
*/

CREATE TABLE IF NOT EXISTS `2023_cleared` AS (
SELECT 
	ride_id, 
	member_casual, 
    rideable_type, 
    started_At, 
    DATE(started_at) AS start_date, -- Split the date only (no time) in a new column
    MONTHNAME(started_at) AS start_month,  -- Split the name of the month in a new column
    DAYNAME(started_at) AS start_day, -- Split the name of the day in a new column
    HOUR(started_at) AS start_hour, -- Split the hour from the main format in a new column
    -- TIME(started_at) AS start_time,
    ended_at, 
    DATE(ended_at) AS end_date, -- Similar to what was done to start_date before
    MONTHNAME(ended_at) AS end_month, 
    DAYNAME(ended_at) AS end_day,
    HOUR(ended_at) AS end_hour,
    TIMESTAMPDIFF(minute, started_at, ended_at) AS ride_length_min, -- Difference in minutes between 2 dates
    start_station_name,
    end_station_name,
    start_lat, start_lng,
    end_lat, end_lng
FROM `2023_combined`
WHERE (TIMESTAMPDIFF(minute, started_at, ended_at) BETWEEN 1 AND 1440) -- don't consider ride_lenghts that are less than 1 minute or longer than 24 hrs
);

-- New number of records: 5563845
SELECT count(*)
FROM `2023_cleared`
;

/* OPTION 2: This version removes all registers with NULL values in any of its columns.
This was used as a comparison with the previous table to see how much the results change. This removes around 20% of the data from the dataset.
*/
/*
CREATE TABLE IF NOT EXISTS `2023_cleared2` AS (
SELECT 
	ride_id, 
	member_casual, 
    rideable_type, 
    started_At, 
    DATE(started_at) AS start_date,
    MONTHNAME(started_at) AS start_month, 
    DAYNAME(started_at) AS start_day,
    HOUR(started_at) AS start_hour,
    -- TIME(started_at) AS start_time,
    ended_at, 
    DATE(ended_at) AS end_date,
    MONTHNAME(ended_at) AS end_month, 
    DAYNAME(ended_at) AS end_day,
    HOUR(ended_at) AS end_hour,
    TIMESTAMPDIFF(minute, started_at, ended_at) AS ride_length_min,
    start_station_name,
    end_station_name,
    start_lat, start_lng,
    end_lat, end_lng
FROM `2023_combined`
WHERE (TIMESTAMPDIFF(minute, started_at, ended_at) BETWEEN 1 AND 1440)
 AND start_station_name IS NOT NULL
 AND end_station_name IS NOT NULL
 AND end_lat IS NOT NULL
 AND end_lng IS NOT NULL)
;

-- Records: 4244295
SELECT count(*)
FROM `2023_cleared2`
;
*/

-----------------------------------------------------------------------------------------------------------

-- 5. Export cleaned table to CSV file
-- 5.1 Check default folder path allowed by MySQL to export files
SHOW VARIABLES LIKE "secure_file_priv";

-- 5.2 Add header row (with UNION ALL) as by default INTO OUTFILE does not include headers.
SELECT 'member_casual', 'rideable_type', 'start_date', 'start_month', 'start_day', 'start_hour', 'ride_length_min', 'start_Station_name', 'end_station_name', 'start_lat', 'start_lng', 'end_lat', 'end_lng'
UNION ALL
SELECT member_casual, rideable_type, start_date, start_month, start_day, start_hour, ride_length_min, start_Station_name, end_station_name, start_lat, start_lng, end_lat, end_lng
FROM `2023_cleared`
INTO OUTFILE 'C:/xxxx/2023_cleared.csv' 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;

--------------------------------------------------------------------------------------------------
-- 6. INDEXES
show index from `2023_cleared`;
CREATE INDEX index_name ON `2023_cleared` (member_Casual, ride_length_min);
DROP INDEX index_name2 ON `2023_cleared`;

