/*
Homework 3
The purpose this homework assignment is to continue developing your knowledge in basic SQL.
Please look at the PSQL documentation to help understand how to develop the appropriate queries.
*/


-- Create and load the following csv mn_census_tracts and mn_county_pixel_values for these questions

-- 1) Write the select/create statement for a new table mn_tracts_2000 that contains the following fields by Total, White_alone Black_alone American_Indian_alone   Asian_alone Hawaiian_PI_alone   SOR_alone)

-- 2) Write the query necessary for joining the census tracts to the county zonal statistics

-- 3) What type of join is performed in question 2 and what are the join fields?

-- 4) If you use count of pixel as a proxy for area, which census tract has the most people per pixel

-- 5) Write the select/create statement for a new table mn_county that contains the aggregates of the following fields by county (Total, one_race,  White_alone Black_alone American_Indian_alone   Asian_alone Hawaiian_PI_alone   SOR_alone)

-- 6) Create a temporary table for question 5. 

-- 7) Remove temporary table any records where the countyfp is 37, 19, or 53.

-- 8) Create a view of question 5

/* EXTRA Understanding views
   1) Duplicate the mn_county table call it mn_county_test;
   2) Create a new view of the join in question 5
   2) Remove any records from the table mn_county_test where countyfp is 37, 19, or 53. 
   3) Query the new view to see how delete the data affecte the table
   4) INSERT INTO mn_county_test data for one county
   INSERT INTO mn_county_test
   SELECT
   FROM 
   WHERE countyfp = 37
*/

Count the number of records and before and after the command in both. Explained what has happened.

DELETE FROM mn_county_zonal_stats WHERE countyfp IN (37, 19, 53);

-- 6) Perform a Join on the temporary table created in Question 5 how many records are there

-- 7) Perform a Join on the view created in Question 5 so that you can identify the pixel values missing from your truncated dataset

-- 8) Develop a entity relationship diagram (pdf) showing the relationships (joins) between for these datasets (mn_census_tracts, mn_county_zonal_stats, mn_county_pixel_values).



select * from mn_census_tracts_2000 limit 100;