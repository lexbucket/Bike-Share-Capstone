/* OPTION 1: Create new table adding details about the duration of the trips 
This also filters all the 'invalid' ride_lenghts that are less than 1 minute or longer than 24 hrs
*/
-- To delete a table
DROP TABLE `bike_riding_project`.`2023_cleared`;

CREATE TABLE IF NOT EXISTS `2023_cleared` AS (
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
);

-- 5563845 records
SELECT count(*)
FROM `2023_cleared`
;

/* OPTION 2: This other version of the table removes all NULL values from the dataset.
This will be used as a comparison with the previous table to see how much the results change as 
this table removes around 20% of the data from the dataset.
*/
DROP TABLE `bike_riding_project`.`2023_cleared2`;

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

-- 4244295 records
SELECT count(*)
FROM `2023_cleared2`
;

-- INDEXES
show index from `2023_cleared`;
CREATE INDEX index_name ON `2023_cleared` (member_Casual, start_station_name, end_station_name);
DROP INDEX index_name ON `2023_cleared`;

