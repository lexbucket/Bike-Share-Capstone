-- How do annual members and casual riders use Cyclistic bikes differently?

-- 1. Number of trips by memberhip type. Members = 3563357. Casuals = 2000488
SELECT member_casual, COUNT(*) AS total_trips
FROM `2023_cleared`
GROUP BY member_casual
ORDER BY total_trips desc;


/* 2. Max, Min and Avg of ride_length by type of membership. 
casual	1440	1	20.74
member	1439	1	11.88 */
SELECT member_casual, MAX(ride_length_min) AS Max_ride_length, MIN(ride_length_min) AS Min_ride_lenth, ROUND(AVG(ride_length_min),2) AS avg_ride_length
FROM `2023_cleared`
GROUP BY member_casual;

/* 3. Max, min, avg length of ride by type of membership
casual	1440	1	20.74
member	1439	1	11.88
*/
SELECT
    member_casual,
    MAX(ride_length_min) AS Max_ride_length,
    MIN(ride_length_min) AS Min_ride_length,
    ROUND(AVG(ride_length_min), 2) AS avg_ride_length
FROM `2023_cleared`
GROUP BY member_casual; 



/* 4. BIKE TYPE. Number of trips based on type of bike and membership type.
 using CASE statement within the COUNT function as we already know there are only 2 types of membership
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


/* 5. MONTHS 
	5.1 vs number of trips by type of membership.*/
SELECT member_casual, start_month, 
  CASE 
    WHEN member_casual = 'member' THEN COUNT(*) 
    WHEN member_casual = 'casual' THEN COUNT(*) 
  END AS count_trips
FROM `2023_cleared`
GROUP BY member_casual, start_month
ORDER BY member_casual, count_trips DESC;

/* 5.2 vs avg ride length by type of membership.*/
SELECT member_casual, start_month, 
  CASE 
    WHEN member_casual = 'member' THEN ROUND(AVG(ride_length_min),3) 
    WHEN member_casual = 'casual' THEN ROUND(AVG(ride_length_min),3) 
  END AS avg_ride_length
FROM `2023_cleared`
GROUP BY member_casual, start_month
ORDER BY member_casual, avg_ride_length DESC;


/* 6. DAY OF THE WEEK 
	6.1 vs number of trips by type of membership.
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

/* 6.2 vs avg ride length by type of membership.
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
-- ----------


/* 7. HOUR OF THE DAY 
	7.1 vs number of trips by type of membership.
*/
SELECT member_casual, start_hour, 
  CASE 
    WHEN member_casual = 'member' THEN COUNT(*) 
    WHEN member_casual = 'casual' THEN COUNT(*) 
  END AS count_trips
FROM `2023_cleared`
GROUP BY member_casual, start_hour
ORDER BY member_casual, count_trips DESC;

/* 7.2 vs avg ride length by type of membership.*/
SELECT member_casual, start_hour, 
  CASE 
    WHEN member_casual = 'member' THEN ROUND(AVG(ride_length_min),3) 
    WHEN member_casual = 'casual' THEN ROUND(AVG(ride_length_min),3) 
  END AS avg_ride_length
FROM `2023_cleared`
GROUP BY member_casual, start_hour
ORDER BY member_casual, avg_ride_length DESC;


/* 8. STATION. 
	8.1 vs Top 10 stations where trips start more often
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


/*	8.2 vs Top 10 stations where trips end more often
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