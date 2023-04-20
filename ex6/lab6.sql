/*
Vector Topological Analysis

Spatial statistics like Moran's I and LISA statistics are not supported in the PostGIS extension as functions.
However, with a Spatial database you can use topological functions/rules to understand the spatial relationships in your data.
*/


/*
For these questions you will need the mn_counties and mn_roads shapefiles.
You will need to create and load a table for the mn_population data.
You will need to load the meris_2010 and meris_2015 datasets
*/


CREATE TABLE mn_population (
    gis_join_match_code text,
    state_name text,
    county_name text,
    county_code int,
    total_population int,
    male int,
    female int,
    white_alone int,
    black_alone int,
    american_indian_alone int,
    asian_alone int,
    hawaiian_pi_alone int,
    sor_alone int
);


-- COPY mn_population FROM '/Users/zing/Desktop/GIS5577/lab6/lab6-Ziiiiing/mn_2010_tract_population_data.csv' WITH CSV HEADER;


--. Question 1, Write the SQL code to find all the adjacent counties to Ramsey County.
SELECT t2.name, t2.geom
FROM mn_counties t1
INNER JOIN mn_counties t2 ON st_touches(t1.geom, t2.geom)
WHERE t1.name = 'Ramsey';

-- Question 2, Write the SQL that joins the counties to the population table data.
-- SELECT t1.county_name, t1.total_population, t2.lsad, t2.aland,t2.awater, t2.geom
SELECT t1.gis_join_match_code, t1.county_name, t1.county_code, t1.total_population, t2.aland, t2.awater, t2.geom
FROM mn_population t1
LEFT JOIN mn_counties t2 ON (t2.name = split_part(t1.county_name, ' County', 1));


-- Question 3, Write the SQL code that calculates and sums the total population of all the adjacent counties to Ramsey County.
-- find adjacent counties to Ramsey
-- join with mn_pop
WITH touch_ramsey AS (
    SELECT t2.name, t2.geom
    FROM mn_counties t1
    INNER JOIN mn_counties t2 ON st_touches(t1.geom, t2.geom)
    WHERE t1.name = 'Ramsey'
)
SELECT SUM(t4.total_population) AS total_pop
FROM touch_ramsey t3
INNER JOIN mn_population t4 ON (split_part(t4.county_name, ' County', 1) = t3.name);

-- Question 4, Expand the SQL code in Question 2 so that it calculates the sums the total population of all the adjacent counties in Minnesota. Make sure to not add the counties in Wisconsin, Iowa, Dakota etc.
WITH mn_neighbor_counties AS (
    SELECT t1.name as county, t2.name as neighbor_county
    FROM mn_counties t1
    INNER JOIN mn_counties t2 ON st_touches(t1.geom, t2.geom)
)
SELECT t3.county, SUM(t4.total_population) as total_neighbor_co_pop
FROM mn_neighbor_counties t3
INNER JOIN mn_population t4 ON (split_part(t4.county_name, ' County', 1) = t3.neighbor_county)
GROUP BY t3.county;



-- Question 5, Expand the code in Question 3 and create a choropleth map of question 3 with labels of population for each adjacent county and place the image in your github repo.
WITH mn_neighbor_population AS (
    WITH mn_neighbor_counties AS (
        SELECT t1.name as county, t2.name as neighbor_county
        FROM mn_counties t1
        INNER JOIN mn_counties t2 ON st_touches(t1.geom, t2.geom)
    )
    SELECT t3.county, SUM(t4.total_population) as total_neighbor_co_pop
    FROM mn_neighbor_counties t3
    INNER JOIN mn_population t4 ON (split_part(t4.county_name, ' County', 1) = t3.neighbor_county)
    GROUP BY t3.county
)
SELECT t5.county, t5.total_neighbor_co_pop, t6.geom
FROM mn_neighbor_population t5
INNER JOIN mn_counties t6 ON (t5.county = t6.name);


/*
Use the roads to answer Questions 6-8
*/

-- Question 6, Write the SQL query that finds all the roads the intersect with I-94.
SELECT t2.gid, t2.name, t2.geom
FROM mn_roads t1
INNER JOIN mn_roads t2 ON st_intersects(t1.geom, t2.geom)
WHERE t1.name = 'Interstate Route 94';


-- Question 7, Write the SQL query that determines the all the features outside a 10 mile buffer of I-94.

-- crs transformation: WGS84(4326) -> UTM 15N(26915)
-- change unit: mile -> meter (UTM 15N)
-- st_buffer -> separate line buffers
-- st_union -> merge buffer into one polygon  !!!!!!!!
-- not st_intersect

WITH i94_buffer_10mile AS (
    SELECT st_union(st_buffer(st_transform(geom, 26915), 10*1609.34 )) as buffer_geom
    FROM mn_roads
    WHERE name = 'Interstate Route 94'
)
SELECT t2.gid, t2.name, t2.geom
FROM i94_buffer_10mile t1
INNER JOIN mn_roads t2 ON NOT st_intersects(t1.buffer_geom, st_transform(t2.geom, 26915));


/*
Use the meris 2010 and 2015 datasets to answer Questions 8-10
*/

-- Question 8, Calculate the histogram of landcover for Hennepin County in 2010. Do not use ST_Histogram, because the raster is an integer.

-- extract raster for Hennepin County: clip & union

WITH hennepin_rast_2010 AS (
    SELECT p.name, st_union(st_clip(r.rast, p.geom)) AS rast
    FROM meris_2010 r
    INNER JOIN mn_counties p ON st_intersects(r.rast, p.geom)
    WHERE p.name = 'Hennepin'
    GROUP BY p.name
)
SELECT (st_valuecount(rast)).*
FROM hennepin_rast_2010
ORDER BY 1;




-- Question 9, Which landcover types decreased from 2010 to 2015 in Hennepin County.

-- value count for both 2010, 2015
-- compare count by value, if value not exist in 2015, fill 0 for its 2015 count

WITH hennepin_valuecount_2010 AS (
    WITH hennepin_rast_2010 AS (
        SELECT p.name, st_union(st_clip(r.rast, p.geom)) AS rast
        FROM meris_2010 r
        INNER JOIN mn_counties p ON st_intersects(r.rast, p.geom)
        WHERE p.name = 'Hennepin'
        GROUP BY p.name
    )
    SELECT (st_valuecount(rast)).*
    FROM hennepin_rast_2010
),
hennepin_valuecount_2015 AS (
    WITH hennepin_rast_2015 AS (
        SELECT p.name, st_union(st_clip(r.rast, p.geom)) AS rast
        FROM meris_2015 r
        INNER JOIN mn_counties p ON st_intersects(r.rast, p.geom)
        WHERE p.name = 'Hennepin'
        GROUP BY p.name
    )
    SELECT (st_valuecount(rast)).*
    FROM hennepin_rast_2015
)
SELECT t1.value, t1.count AS count_2010, coalesce(t2.count, 0) AS count_2015
FROM hennepin_valuecount_2010 t1
LEFT JOIN hennepin_valuecount_2015 t2 ON (t1.value = t2.value)
WHERE t1.count > t2.count OR t2 IS NULL;



-- Question 10, Which counties in MN has a decrease in tree cover (Values 50 through 90).

-- raster by tiles -> raster by county
-- value count
-- extract tree cover only
-- sum count for tree cover pixel
-- join 2010's and 2015's tree cover sum by county name, compare sum

WITH mn_tree_2010 AS (
    WITH mn_county_valuecount_2010 AS (
        WITH mn_county_rast_2010 AS (
            SELECT p.name, st_union(st_clip(r.rast, p.geom)) AS rast
            FROM meris_2010 r
            INNER JOIN mn_counties p ON st_intersects(r.rast, p.geom)
            GROUP BY p.name
        )
        SELECT name, (st_valuecount(rast)).*
        FROM mn_county_rast_2010
    )
    SELECT name, sum(count)
    FROM mn_county_valuecount_2010
    WHERE value >= 50 AND value <= 90
    GROUP BY name
), mn_tree_2015 AS (
    WITH mn_county_valuecount_2015 AS (
        WITH mn_county_rast_2015 AS (
            SELECT p.name, st_union(st_clip(r.rast, p.geom)) AS rast
            FROM meris_2015 r
            INNER JOIN mn_counties p ON st_intersects(r.rast, p.geom)
            GROUP BY p.name
        )
        SELECT name, (st_valuecount(rast)).*
        FROM mn_county_rast_2015
    )
    SELECT name, sum(count)
    FROM mn_county_valuecount_2015
    WHERE value >= 50 AND value <= 90
    GROUP BY name
)
SELECT t1.name, t1.sum AS tree_cover_2010, t2.sum AS tree_cover_2015
FROM mn_tree_2010 t1
INNER JOIN mn_tree_2015 t2 ON (t1.name = t2.name)
WHERE t1.sum < t2.sum






