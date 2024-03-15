-- Create a Database
DROP DATABASE IF EXISTS `Bike_riding_project`;
CREATE DATABASE `Bike_riding_project`;
USE `Bike_riding_project`;
 
 /* IMPORTING FILE:
 To use import the file using INFILE the table needs to be created before
 Create the structure of the tables for MySQL (do this for the 12 tables)*/
  CREATE TABLE `bike_riding_project`.`2023_combined` (
  ride_id VARCHAR(20) NOT NULL,
  rideable_type VARCHAR(15),
  started_at DATETIME,
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
  -- PRIMARY KEY (ride_id)
  );

/* Before loading the data check if the Local_infile is ON so you can import data */
SHOW GLOBAL VARIABLES LIKE 'local_infile';

/* Load the CSV file into the table previously created
Include the \r in 'Lines terminated By' if using Windows
Ignore the first line as it is usually the header */
LOAD DATA LOCAL INFILE 'C:/xxxx/202312-divvy-tripdata.csv' 
INTO TABLE `bike_riding_project`.`202312_data`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- Windows users require the \r
IGNORE 1 LINES
(ride_id,rideable_type,started_at,ended_at,start_station_name,start_station_id,end_station_name,end_station_id,start_lat,start_lng,end_lat,end_lng,member_casual)
SET -- For the following columns apply: When empty cell or "", change to NULL.
start_station_name = NULLIF(start_station_name, ""),
start_station_id = NULLIF(start_station_id, ""),
end_station_name = NULLIF(end_station_name, ""),
end_station_id = NULLIF(end_station_id, ""),
end_lat = NULLIF(end_lat, ""),
end_lng = NULLIF(end_lng, "")
;

-- If the table's name needs to be changed:
ALTER TABLE `bike_riding_project`.`202301-divvy-tripdata` 
RENAME TO  `bike_riding_project`.`data-2023-01` ;

-- To delete a table
DROP TABLE `bike_riding_project`.`202301-tripdata`;

-- To delete all the registers of the table
TRUNCATE TABLE `bike_riding_project`.`202301-tripdata`;

/* EXPORTING TABLES TO CSV:
Check path to folder allowed by MySQL to export files */
SHOW VARIABLES LIKE "secure_file_priv";

-- Need to add the header row (with UNION ALL) as by default INTO OUTFILE does not include headers.
SELECT 'member_casual', 'rideable_type', 'start_date', 'start_month', 'start_day', 'start_hour', 'ride_length_min', 'start_Station_name', 'end_station_name', 'start_lat', 'start_lng', 'end_lat', 'end_lng'
UNION ALL
SELECT member_casual, rideable_type, start_date, start_month, start_day, start_hour, ride_length_min, start_Station_name, end_station_name, start_lat, start_lng, end_lat, end_lng
FROM `2023_cleared`
INTO OUTFILE 'C:/xxxx/2023_cleared2.csv' 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
;