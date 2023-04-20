
/* 
Here is the metadata for the GLC2000 dataset
Pixel Value GLC Global Class (according to LCCS terminology)
1.      Tree Cover, broadleaved, evergreen LCCS >15% tree cover, tree height >3 (Examples of sub-classes at regional level* : closed > 40% tree cove; open 15-40% tree cover)
2.      Tree Cover, broadleaved, deciduous, closed 
3.      Tree Cover, broadleaved, deciduous, open (open 15-40% tree cover)
4.      Tree Cover, needle-leaved, evergreen
5.      Tree Cover, needle-leaved, deciduous
6.      Tree Cover, mixed leaf type
7.      Tree Cover, regularly flooded, fresh  water (& brackish)
8.      Tree Cover, regularly flooded, saline water, (daily variation of water level)
9.      Mosaic: Tree cover / Other natural vegetation 
10.     Tree Cover, burnt 
11.     Shrub Cover, closed-open, evergreen (Examples of sub-classes at reg. level *: (i) sparse tree layer)
12.     Shrub Cover, closed-open, deciduous (Examples of sub-classes at reg. level *: (i) sparse tree layer)
13.     Herbaceous Cover, closed-open (Examples of sub-classes at regional level *: (i) natural, (ii) pasture, (iii) sparse trees or shrubs) 
14.     Sparse Herbaceous or sparse Shrub Cover
15.     Regularly flooded Shrub and/or Herbaceous Cover
16.     Cultivated and managed areas (Examples of sub-classes at reg. level *: (i) terrestrial; (ii) aquatic (=flooded during cultivation),  and under terrestrial:  (iii) tree crop & shrubs (perennial),  (iv) herbaceous crops (annual), non-irrigated, (v) herbaceous crops (annual), irrigated)    
17.     Mosaic: Cropland / Tree Cover / Other natural vegetation
18.     Mosaic: Cropland / Shrub or Grass Cover 
19.     Bare Areas
20.     Water Bodies (natural & artificial)
21.     Snow and Ice (natural & artificial)
22.     Artificial surfaces and associated areas

*/




/*
For questions 1-8 please use the raster dataset GLC2000
*/

-- Question 1, Write the SQL code that creates a histogram of the state of Minnesota. A histogram is each unique pixel type and total number of pixels.
WITH mn_clipped AS (
	SELECT p.name, st_union(st_clip(r.rast, p.geom)) AS rast
	FROM glc2000_clipped r
	INNER JOIN us_states p ON st_intersects(r.rast, p.geom)
	WHERE p.name = 'Minnesota'
	GROUP BY p.name)
SELECT (st_valuecount(r.rast)).*
FROM mn_clipped r
ORDER BY value;


-- Question 2, Write the SQL code that returns the most common pixel value for each county in Minnesota
WITH mn_counties_rast_valcount AS (
	SELECT p.name, (st_valuecount(st_union(st_clip(r.rast, p.geom)))).*
	FROM glc2000_clipped r
	INNER JOIN mn_counties p ON st_intersects(p.geom, r.rast)
	GROUP BY p.name)
SELECT DISTINCT ON (name)
	   name, value, count
FROM mn_counties_rast_valcount
ORDER BY name, count DESC;


-- Question 3, Write the SQL code that returns the minimum and maximum value for each county in Minnesota.
SELECT p.name,
       (st_summarystats(st_union(st_clip(r.rast, p.geom)))).min AS min_pval,
	   (st_summarystats(st_union(st_clip(r.rast, p.geom)))).max AS max_pval
FROM glc2000_clipped r
INNER JOIN mn_counties p ON st_intersects(p.geom, r.rast)
GROUP BY p.name;


-- Question 4, Rewrite query in Question 3 so that it uses a subquery or common table expression.
WITH mn_counties_rast_stat AS (
	SELECT p.name, (st_summarystats(st_union(st_clip(r.rast, p.geom)))).*
	FROM glc2000_clipped r
	INNER JOIN mn_counties p ON st_intersects(p.geom, r.rast)
	GROUP BY p.name)
SELECT name, min AS min_pval, max AS max_pval
FROM mn_counties_rast_stat;


--??? Question 5, Write the SQL code that reclassifies Mosaic: Croplaand / Shrub or Grass Cover (pixel value = 18 to pixel value 20)
-- The query below will make the output raster ignores those un-reclassified pixels to NoData,
-- and only returns with reclassified pixels(18) to its new class(20)
SELECT (st_valuecount(st_reclass(st_union(rast), '18:20', '8BUI'))).*
FROM glc2000_clipped;

-- In order to include all pixel values, either reclassified or un-reclassified, I chose to specify all pixel values in
-- the reclassarg, and used st_union to merge all tiles to better compare the before and after counts by pixel values.
SELECT (st_valuecount(st_union(rast))).*,
       (st_valuecount(st_reclass(st_union(rast), ROW(1,'18:20, [1-17]:[1-17], [19-22]:[19-22]', '8BUI', NULL)))).*
FROM glc2000_clipped;


-- Question 6, Rewrite the query from question 5 to group the non-liveable places to a new pixel value 30. Then count the number of new pixels.
-- Non-liveable places are water bodies(20) and snow and ice(21).
SELECT (st_valuecount(st_reclass(st_union(rast), '[20-21]:30', '8BUI'))).*
FROM glc2000_clipped;


-- Question 7, Write the SQL code that reclassifies all trees (Example not the actual values pixel value = [3,4,5,6] ) to a new category forest. 
SELECT (st_valuecount(st_reclass(st_union(rast), '[1-10]:50', '8BUI'))).*
FROM glc2000_clipped;


-- Question 8, Write the SQL code that uses map algebra that multiplies all your pixel values by 5.
-- (Probably 31 secs for processing)
SELECT (st_valuecount(st_union(rast))).*,
       (st_valuecount(st_mapalgebra(st_union(rast), 1,NULL, '[rast]*5'))).*
FROM glc2000_clipped
