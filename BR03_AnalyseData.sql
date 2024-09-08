/* BIKE RIDING PROJECT (PART III)

EDA (Exploratory Data Analysis) -> Window functions, Subqueries, Round, Case, null values */

--------------------------------------------------------------------------------------------
/* 1. Number of trips by membership type with percentage. 
 Members = 3563357 (64%). Casuals = 2000488 (36%), Overall = 5563845 */
SELECT member_casual, COUNT(*) AS total_trips,
ROUND((COUNT(*)/SUM(COUNT(*)) OVER())*100,2) AS percentage_trips, -- Window function to calculate total of registers: SUM(COUNT(*)) OVER()
SUM(COUNT(*)) OVER() AS overall_trips
FROM `2023_cleared`
GROUP BY member_casual
ORDER BY total_trips desc 
;

--------------------------------------------------------------------------------------------
/* 2. Max, min, avg ride length by membership type. Without index it took 14 minutes. With index it took 6 seconds.
casual	1440	1	20.74	15.07
member	1439	1	11.88	15.07
*/
SELECT
	member_casual,
	-- MAX(ride_length_min) AS Max_ride_length, -- It's 1440(24hr) as expected
	-- MIN(ride_length_min) AS Min_ride_length, -- It's 1min as expected
	ROUND(AVG(ride_length_min), 2) AS avg_ride_length,
    (SELECT ROUND(AVG(ride_length_min),2) FROM `2023_cleared`) AS total_avg -- Subquery to get the total average without grouping
FROM `2023_cleared`
GROUP BY member_casual; 

--------------------------------------------------------------------------------------------
/* 3. Bike Type. Trips based on membership type.
				casual	members
electric_bike	1063621	1774327
classic_bike	860752	1789030
docked_bike		76115	0
 */
SELECT 
	rideable_type, 
    COUNT(case member_casual when 'casual' then 1 else null end) AS casual, 
    COUNT(case member_casual when 'member' then 1 else null end) AS members
FROM `2023_cleared`
GROUP BY  rideable_type
ORDER BY casual DESC;

-- OPTIONAL:
-- 4. Bike type trips. electric_bike: 2945579, classic_bike: 2696011, docked_bike: 78287
SELECT rideable_type, COUNT(*) AS count_bike_type
FROM `2023_cleared`
GROUP BY rideable_type
;
--------------------------------------------------------------------------------------------
-- 5. Info per month 
-- 5.1 Number of trips by type of membership.
SELECT member_casual, start_month, 
  CASE 
    WHEN member_casual = 'member' THEN COUNT(*) 
    WHEN member_casual = 'casual' THEN COUNT(*) 
  END AS count_trips
FROM `2023_cleared`
GROUP BY member_casual, start_month
ORDER BY member_casual, count_trips DESC;

-- 5.2 Avg ride length by type of membership.
SELECT member_casual, start_month, 
  CASE 
    WHEN member_casual = 'member' THEN ROUND(AVG(ride_length_min),3) 
    WHEN member_casual = 'casual' THEN ROUND(AVG(ride_length_min),3) 
  END AS avg_ride_length
FROM `2023_cleared`
GROUP BY member_casual, start_month
ORDER BY member_casual, avg_ride_length DESC;

--------------------------------------------------------------------------------------------
/* 6. Info per day of the week 
   6.1 Number of trips by type of membership.
casual	Saturday	398741
casual	Sunday		325768
casual	Friday		303098
casual	Thursday	263024
casual	Wednesday	242207
casual	Tuesday		239372
casual	Monday		228278
member	Thursday	573645
member	Wednesday	571412
member	Tuesday		561796
member	Friday		517105
member	Monday		481793
member	Saturday	459719
member	Sunday		397887 */
SELECT member_casual, start_day, 
  CASE 
    WHEN member_casual = 'member' THEN COUNT(*) 
    WHEN member_casual = 'casual' THEN COUNT(*) 
  END AS count_trips
FROM `2023_cleared`
GROUP BY member_casual, start_day
ORDER BY member_casual, count_trips DESC;

/* 6.2 Avg ride length by type of membership.
casual	Sunday		24.298
casual	Saturday	23.571
casual	Monday		20.361
casual	Friday		20.121
casual	Tuesday		18.496
casual	Thursday	18.024
casual	Wednesday	17.622
member	Saturday	13.312
member	Sunday		13.305
member	Friday		11.817
member	Thursday	11.389
member	Tuesday		11.386
member	Wednesday	11.307
member	Monday		11.248 */
SELECT member_casual, start_day, 
  CASE 
    WHEN member_casual = 'member' THEN ROUND(AVG(ride_length_min),3) 
    WHEN member_casual = 'casual' THEN ROUND(AVG(ride_length_min),3) 
  END AS avg_ride_length
FROM `2023_cleared`
GROUP BY member_casual, start_day
ORDER BY member_casual, avg_ride_length DESC;

--------------------------------------------------------------------------------------------
-- 7. Info per hour of the day 
-- 7.1 Number of trips by type of membership.
SELECT member_casual, start_hour, 
  CASE 
    WHEN member_casual = 'member' THEN COUNT(*) 
    WHEN member_casual = 'casual' THEN COUNT(*) 
  END AS count_trips
FROM `2023_cleared`
GROUP BY member_casual, start_hour
ORDER BY member_casual, count_trips DESC;

-- 7.2 vs avg ride length by type of membership.*/
SELECT member_casual, start_hour, 
  CASE 
    WHEN member_casual = 'member' THEN ROUND(AVG(ride_length_min),3) 
    WHEN member_casual = 'casual' THEN ROUND(AVG(ride_length_min),3) 
  END AS avg_ride_length
FROM `2023_cleared`
GROUP BY member_casual, start_hour
ORDER BY member_casual, avg_ride_length DESC;

--------------------------------------------------------------------------------------------
/* 8. Stations
   8.1 Top 10 stations where trips start more often
Streeter Dr & Grand Ave				61742
DuSable Lake Shore Dr & Monroe St	39321
Michigan Ave & Oak St				36512
Clark St & Elm St					35115
DuSable Lake Shore Dr & North Blvd	35075
Kingsbury St & Kinzie St			34259
Wells St & Concord Ln				32938
Clinton St & Washington Blvd		31967
Wells St & Elm St					29888
Theater on the Lake					29407    
*/
SELECT
	start_station_name, count(*) as number_of_trips
FROM `2023_cleared`
WHERE start_station_name IS NOT NULL
-- 	AND member_casual = 'casual' -- Add this line to see only by 'casual' or 'member'
GROUP BY start_station_name
ORDER BY number_of_trips DESC 
LIMIT 10;

/*	8.2 Top 10 stations where trips end more often
Streeter Dr & Grand Ave				63061
DuSable Lake Shore Dr & North Blvd	38695
Michigan Ave & Oak St				37290
DuSable Lake Shore Dr & Monroe St	37253
Clark St & Elm St					34369
Kingsbury St & Kinzie St			33690
Wells St & Concord Ln				33619
Clinton St & Washington Blvd		32698
Millennium Park						30436
Theater on the Lake					30094
*/
SELECT
	end_station_name, count(*) as number_of_trips
FROM `2023_cleared`
WHERE end_station_name IS NOT NULL
GROUP BY end_station_name
ORDER BY number_of_trips DESC 
LIMIT 10;

