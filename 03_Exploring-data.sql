-- EXPLORING THE DATA

-- 1. Checking number of registers before any actions: 5.719.877 
SELECT count(*)
FROM `2023_combined`;

-- 2. Checking schema (column name and data type) in case it can't be seen in other way
SELECT column_name, data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = '2023_combined';

-- 3. DUPLICATES
-- 3.1 Checking on ride_id as it is supposed to be a unique value. Result: 0 duplicates
select COUNT(ride_id) - COUNT(DISTINCT ride_id) AS duplicates
FROM `2023_combined`;

-- 3.2 If you find a value >0 with the previous query, the next one displays details of the duplicates (it took about 7 minutes for a primary key, but it was quicker for other columns)
-- It can be used to know how many registers exist for each cell within the column-> electric_bike: 2945579, classic_bike: 2696011, docked_bike: 78287
SELECT rideable_type, COUNT(*) AS count_duplicates
FROM `2023_combined`
GROUP BY rideable_type
HAVING count_duplicates >1
;


-- 4. Categories: How many types of...?
-- 4.1 Bikes rideable_type = 3
SELECT COUNT(DISTINCT rideable_type)
FROM `2023_combined`;

-- 4.2 member_casual = 2
SELECT COUNT(DISTINCT member_casual)
FROM `2023_combined`;

-- 4.3 start station = 1592
SELECT COUNT(DISTINCT start_station_name)
FROM `2023_combined`;

-- 4.4 end station = 1597
SELECT COUNT(DISTINCT end_station_name)
FROM `2023_combined`;

-- 5. Number of Null values in each column in one view. Using CASE and SUM to recognise null values and count how many 
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
 
 -- 6. (OPTIONAL) Counts the records that are NULL for both start_station and end_station. This will be used for future analysis of location.
SELECT COUNT(*)
FROM `2023_combined`
WHERE (start_Station_name IS NULL AND end_station_name IS NULL);