-- Data Combining
-- Delete the table if it exists already
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

