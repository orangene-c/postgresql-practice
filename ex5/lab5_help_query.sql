/*
 RASTER BAND STATISTICS AND ANALYTICS
 --------------------------------------
 st_count -> for each tile, return total count of the whole input raster
 st_histogram -> for each tile, return histogram with min/max/count/percent for each classes(ranges)
 st_quantile -> for each tile, return 5 quantiles(0,25%,50%,75%,100%) along with pixel value -> min/max/median pixel value
 st_summarystats -> for each tile, return pixel count/sum of pixel values?/mean value/stddev/min/max
 st_valuecount -> for each tile, count for each pixel value
 */


-- find minnesota tiles
-- (return 11 rows of tiles)
SELECT p.name, r.*
FROM glc2000_clipped r
INNER JOIN us_states p ON st_intersects(r.rast, p.geom)
WHERE p.name = 'Minnesota';

-- clip tiles to include MN only
-- merge clipped tiles into one
SELECT p.name, st_union(st_clip(r.rast, p.geom)) AS rast
FROM glc2000_clipped r
INNER JOIN us_states p ON st_intersects(r.rast, p.geom)
WHERE p.name = 'Minnesota'
GROUP BY p.name;

-- find mn counties clipped tiles
-- merge clipped tiles for same county
SELECT p.name, st_union(st_clip(r.rast, p.geom)) as rast
FROM glc2000_clipped r
INNER JOIN mn_counties p ON st_intersects(p.geom, r.rast)
GROUP BY p.name;

-- number of each pixel for whole raster (312 tiles merged)
-- pval(18) -> 43291
-- pval(20) -> 5715193
SELECT (st_valuecount(st_union(rast))).*
FROM glc2000_clipped
ORDER BY value;

-- pixel type of original raster
SELECT st_bandpixeltype(rast)
FROM glc2000_clipped;
