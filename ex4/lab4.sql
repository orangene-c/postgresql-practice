
/*
Please load the mn_census_tracts_2010 for questions 1-6
*/


-- √ 1) Write the SQL query that will generate a single polygon of the state of Minnesota from the census tracts
CREATE VIEW mn_state AS
SELECT state_name, ST_Union(geom) AS mn_geom
FROM mn_census_tracts_2010
GROUP BY state_name;

-- 2) Write the SQL query that will report the spatial extent of the state of Minnesota
CREATE VIEW mn_bbox AS
SELECT state_name, ST_Extent(geom) AS mn_bbox_geom
FROM mn_census_tracts_2010
GROUP BY state_name;

/*You can use multiple statements or type in the values necessary for creating the polyline */
-- ? 3) Write the SQL query that will create a polyline that traverses the middle of the state. This can be vertical or horizontal.
-- split horizontally by spatial extent
-- DROP VIEW mn_midline;
CREATE VIEW mn_midline AS
WITH mn_bbox_points AS (
	SELECT st_xmin(mn_bbox_geom) AS xmin, st_xmax(mn_bbox_geom) AS xmax,
	       st_ymin(mn_bbox_geom) AS ymin, st_ymax(mn_bbox_geom) AS ymax,
		   (st_ymin(mn_bbox_geom)+st_ymax(mn_bbox_geom))/2 AS ymid
	FROM mn_bbox
)
SELECT st_setsrid(st_makeline(st_point(xmin,ymid),st_point(xmax,ymid)),4326) AS midline_geom
FROM mn_bbox_points;



-- ? 4) Write the SQL query that splits the state in half (based on your results from question 2)  and store it in a table.
-- tiny polygons exist after dump
-- union with nearest one if area less than xx ?
SELECT (st_dump(st_split(t1.mn_geom, t2.midline_geom))).geom
FROM mn_state t1, mn_midline t2;





-- √ 5) Write the SQL query that returns the census tracts that intersect with the polyline (from question 2)
SELECT t1.state_name, t1.county_nam, t1.census_tra, geom
FROM mn_census_tracts_2010 t1, mn_midline t2
WHERE st_intersects(t1.geom, t2.midline_geom);



-- 6) Write the SQL query that returns the census tracts that do not intersect with the polyline. Please use 1 query with 1 or more Common Table Expressions or subqueries
SELECT t1.state_name, t1.county_nam, t1.census_tra, geom
FROM mn_census_tracts_2010 t1, mn_midline t2
WHERE NOT st_intersects(t1.geom, t2.midline_geom);



-- 7) Write the SQL query that creates a view of centroids for MN counties call the view mn_county_centroids. 
--    Look at all the questions before creating the view to ensure you have all the information necessary.
CREATE VIEW mn_county_centroids AS
SELECT name, st_centroid(geom) AS centroid_geom
FROM mn_counties;

-- 8) Write the SQL query that identifies all random points that are within 5 kilometers of a county centroid
-- 3896 rows affected
SELECT t1.id, t1.geom
FROM random_points t1, mn_county_centroids t2
WHERE st_distance(st_transform(t1.geom,32615), st_transform(t2.centroid_geom,32615)) < 5000;


-- 9) Write the SQL query that identifies all random points that are within 5 kilometers of the Anoka county centroid
-- 201 rows affected
SELECT t1.id, t1.geom
FROM random_points t1, mn_county_centroids t2
WHERE t2.name = 'Anoka' AND st_distance(st_transform(t1.geom,32615), st_transform(t2.centroid_geom,32615)) < 5000;



-- 10) Are there any duplicate random points. If so write the SQL that identifies them.
-- 2700 rows affected
SELECT t1.id, t1.geom
FROM random_points t1, random_points t2
WHERE (t1.geom = t2.geom) AND (t1.id != t2.id)
ORDER BY t1.geom;


-- 11) Write the SQL query that identifies the number of duplicate points within each county.
WITH duplicate_points AS (
	SELECT t1.id dup_id, t1.geom as dup_geom
	FROM random_points t1, random_points t2
	WHERE (t1.geom = t2.geom) AND (t1.id != t2.id)
)
SELECT t4.name, count(t3.dup_id)
FROM duplicate_points t3, mn_counties t4
WHERE st_contains(t4.geom, t3.dup_geom)
GROUP BY t4.name
ORDER BY 2 DESC;



-- 12) If you were to delete a county in the mn_counties table, what would happen to the mn_county_centroids view
DROP TABLE mn_counties;  -- not work!
DROP TABLE mn_counties CASCADE;  -- works!
-- It is not able to use 'Drop Table' to delete mn_counties table, since we have created a view based on this table.
-- However, in order to delete the table successfully, we can use 'Drop TABLE .. CASCADE' to drop both table and related views
