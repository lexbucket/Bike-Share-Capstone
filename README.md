# Google Data Analytics Capstone: Bike Share

#### Tools used: Excel, SQL, Tableau.

## SCENARIO
'Cyclistic' is a bike share company with a fleet of more than 5000 bicycles that are geotracked and locked into a network of almost 700 stations across the city. Customers who purchase single-ride or full-day passes are referred to as casual riders and customers who purchase annual memberships are Cyclistic members. There have been some recent developments as the company is trying to maximise profits:

- The finance analysts concluded that annual memberships are much more profitable than casual riders.
- The director of marketing notes that casual riders already know and like the service, so there is a great opportunity to convert casual riders into annual members, instead of targetting only all-new customers.
- To design the new marketing strategy, it is necessary to understand first how casual riders and annual members use the service and provide some recommendations that 'Cyclistic' executives will be able to understand and approve.

## PROBLEM
As a data analyst who belongs to the marketing analytics team, the goal is to identify **how do annual members and casual riders use Cyclistic bikes, and what recommendations can be provided to convert casual riders into anualm members?** The analysis will be make with data from a whole year. In this case 2023.

## PREPARATION
The data has been taken from [here](https://divvy-tripdata.s3.amazonaws.com/index.html) where there is a file for each month of the year. The data has been available by Motive International Inc. under this [license](https://divvybikes.com/data-license-agreement).

- I downloaded 12 csv files corresponding to historical data from 2023.
- Each file contains 13 columns and more than a hundred thousand rows.
- Initial glimpse of the data was made with Excel. However, combining the 12 files into a unified one is not possible as there are more rows than the maximum that Excel can handle. MySQL was used for the processing stage, instead.

## PROCESSING
This stage is used for cleaning and querying the data to make it useful later for analysis. These files are included in this repository and have the detailed information of the proceess I followed usgin SQL.

1. [Create and combine tables](https://github.com/lexbucket/Bike-Share-Capstone/blob/main/BR01_CreateCombine.sql)
2. [Clean and explore data](https://github.com/lexbucket/Bike-Share-Capstone/blob/main/BR02_CleanExploreData.sql)
3. [Analyse data](https://github.com/lexbucket/Bike-Share-Capstone/blob/main/BR03_AnalyseData.sql)

A summary of this process is presented below:
- Created schema and tables for every file/month
- Combined the 12 tables in a single one to simplify analysis
- Looked for duplicates
- Explored null values
- Created a new table from the unified version, with proper data types for the date and extracted the month, day of the week and hour of the day in 3 new columns
- Added another column that calculated the duration of the trip without including registers that lasted less than 1 minute or more than 24 hours
- Added index to make some queries faster considering the number of registers was more than 5 million. 

## ANALYSIS
The analysis of the information was made using MySQL. However, the visualisations were made in Tableau. A dashboard on Tableau Public can be found [here](https://public.tableau.com/app/profile/fabio.v5058/viz/BikeShareAnalysis_17110918351330/Dashboard1).




