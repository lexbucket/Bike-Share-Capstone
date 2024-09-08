/* BIKE RIDING PROJECT (PART I)

1. Create schema (Create database, Drop, Use)
2. Create tables' structure (Create table)
3. Import CSV files (Load Data Local Infile)
4. Unify tables (UNION ALL)
*/

-------------------------------------------------------------------------------------------------

-- 1. Create schema/database
DROP DATABASE IF EXISTS `Bike_riding_project`;
CREATE DATABASE `Bike_riding_project`;
USE `Bike_riding_project`;

-------------------------------------------------------------------------------------------------

 -- 2. Create table structure:
 /*Before importing the CSV file the tables structure need to be created (do this for each of the 12 tables)
 This is a good moment to make sure to select the right data type for each column*/
  CREATE TABLE `bike_riding_project`.`202301_data` (
  ride_id VARCHAR(20) NOT NULL,
  rideable_type VARCHAR(15),
  started_at DATETIME, -- From here I select this column with the data type DATETIME so I don't have to do it later
  ended_at DATETIME,
  start_station_name VARCHAR(70),
  start_station_id VARCHAR(40),
  end_station_name VARCHAR(70),
  end_station_id VARCHAR(40),
  start_lat FLOAT,
  start_lng FLOAT,
  end_lat VARCHAR(20),
  end_lng VARCHAR(20),
  member_casual VARCHAR(7)
  );

----------------------------------------------------------------------------------------------------
-- 3. Import CSV files
-- 3.1 Before loading the data check if the Local_infile is ON so data can be imported
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- 3.2 Load the CSV file into the table previously created (Repeat this for the 12 months)
LOAD DATA LOCAL INFILE 'C:/xxxx/202312-divvy-tripdata.csv' 
INTO TABLE `bike_riding_project`.`202301_data`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- Windows users require the \r
IGNORE 1 LINES -- Ignore the first line as it is usually the header
(ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual)
SET -- For the following columns: When empty cell or "", change to NULL.
start_station_name = NULLIF(start_station_name, ""),
start_station_id = NULLIF(start_station_id, ""),
end_station_name = NULLIF(end_station_name, ""),
end_station_id = NULLIF(end_station_id, ""),
end_lat = NULLIF(end_lat, ""),
end_lng = NULLIF(end_lng, "")
;

-------------------------------------------------------------------------------------------------

-- 4. Unify tables
-- Delete the table if already exists
DROP TABLE IF EXISTS `bike_riding_project`.`2023_combined`;

-- Combining all the 12 tables into a single table containing data from Jan 2023 to Dec 2023

CREATE TABLE IF NOT EXISTS `bike_riding_project`.`2023_combined` AS (
  SELECT * FROM `bike_riding_project`.`202301_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202302_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202303_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202304_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202305_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202306_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202307_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202308_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202309_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202310_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202311_data`
  UNION ALL
  SELECT * FROM `bike_riding_project`.`202312_data`
 );

-----------------------------------------------------------------------------------------------------

-- **Useful DDL (Data Definition Language) commands:

-- If the table's name needs to be changed:
ALTER TABLE `bike_riding_project`.`202301-divvy-tripdata` 
RENAME TO  `bike_riding_project`.`data-202301` ;

-- To delete a table
DROP TABLE `bike_riding_project`.`202301-tripdata`;

-- To delete all the registers of the table but leaving the table structure
TRUNCATE TABLE `bike_riding_project`.`202301-tripdata`;