
-- Create and load the following csv mn_census_tracts and mn_county_pixel_values for these questions


-- DONE 1) Write the select or create statement that results in a new table mn_tracts_2000 that contains the following
-- fields by Total, White_alone Black_alone, American_Indian_alone, Asian_alone Hawaiian_PI_alone, SOR_alone)
SELECT total, white_alone, black_alone, american_indian_alone, asian_alone, hawaiian_pi_alone, sor_alone
INTO mn_tracts_2000
FROM mn_census_tracts_2000;


-- ?? 2) Write the query necessary for joining the census tracts to the county pixel values table. (This is a zonal
-- statistics of landcover types)
SELECT t1.county_code, t1.county_name, t1.pixel_value, t1.pixel_count, t2.census_tract_code, t2.total
FROM mn_county_pixel_values t1
LEFT JOIN mn_census_tracts_2000 t2 on (t1.county_code = t2.county_code);


-- ?? 3) What type of join (cardinality) is performed in question 2 and what are the join fields?
-- It is a 'Many to Many' join based on the county_code field from both tables. Even though it is a LEFT JOIN, but the result shows
-- like the Cartesian Product from OUTER JOIN


-- DONE 4) If you use the count of pixels as a proxy for area, which county has the most people per pixel?
-- Ramsey -> 826.92
WITH county_pixel AS (
        SELECT county_name, SUM(pixel_count) AS county_pixel_count
        FROM mn_county_pixel_values
        GROUP BY county_name),
     county_pop AS (
        SELECT county_name, SUM(total) AS county_pop
        FROM mn_census_tracts_2000
        GROUP BY county_name)
SELECT t1.county_name, t2.county_pop, t1.county_pixel_count, t2.county_pop::float/t1.county_pixel_count AS pop_per_pixel
FROM county_pixel t1
INNER JOIN county_pop t2 ON (t1.county_name = t2.county_name)
ORDER BY pop_per_pixel DESC
LIMIT 1;


-- DONE 5) Write the select or create statement that results in a new table mn_county that contains the aggregates of the following fields by county (Total, one_race, White_alone Black_alone, American_Indian_alone, Asian_alone Hawaiian_PI_alone, SOR_alone)
SELECT county_name, SUM(total) AS sum_total, SUM(one_race) AS sum_one_race, SUM(white_alone) AS sum_white_alone,
       SUM(black_alone) AS sum_black_alone, SUM(american_indian_alone) AS sum_american_indian_alone,
       SUM(asian_alone) AS sum_asian_alone, SUM(hawaiian_pi_alone) AS sum_hawaiian_pi_alone, SUM(sor_alone) AS sum_sor_alone
INTO TABLE mn_county
FROM mn_census_tracts_2000
GROUP BY county_name
ORDER BY county_name;


-- DONE 6) Create a temporary table for question 5.
-- the only difference is the 'TEMP' before the new table name
SELECT county_name, SUM(total) AS sum_total, SUM(one_race) AS sum_one_race, SUM(white_alone) AS sum_white_alone,
       SUM(black_alone) AS sum_black_alone, SUM(american_indian_alone) AS sum_american_indian_alone,
       SUM(asian_alone) AS sum_asian_alone, SUM(hawaiian_pi_alone) AS sum_hawaiian_pi_alone, SUM(sor_alone) AS sum_sor_alone
INTO TEMP TABLE temp_mn_county
FROM mn_census_tracts_2000
GROUP BY county_name
ORDER BY county_name;

-- DONE 7) What statement removes from the temporary table any records where the countyfp is 37, 19, or 53.
DELETE FROM temp_mn_county -- no 'county_code' column, but only 'county_name'
WHERE county_name IN (
    SELECT DISTINCT county_name FROM mn_county_pixel_values WHERE county_code IN (19,37,53) -- find 'county_code'
    );


-- DONE 8) Create a view of question 5
CREATE VIEW view_mn_county AS
    SELECT county_name, SUM(total) AS sum_total, SUM(one_race) AS sum_one_race, SUM(white_alone) AS sum_white_alone,
       SUM(black_alone) AS sum_black_alone, SUM(american_indian_alone) AS sum_american_indian_alone,
       SUM(asian_alone) AS sum_asian_alone, SUM(hawaiian_pi_alone) AS sum_hawaiian_pi_alone, SUM(sor_alone) AS sum_sor_alone
    FROM mn_census_tracts_2000
    GROUP BY county_name
    ORDER BY county_name;



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
