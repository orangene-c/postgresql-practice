# EX4: Working with PostGIS spatial operators
Create a table and load the **mn_census_tracts_2010**, and complete the following queries:

1. Generate a single polygon of the state of Minnesota from the census tracts
2. Report the spatial extent of the state of Minnesota
3. Create a polyline that traverses the middle of the state. This can be vertical or horizontal.
4. Splits the state in half (based on your results from question 2)  and store it in a table.
5. Returns the census tracts that intersect with the polyline (from question 2)
6. Returns the census tracts that do not intersect with the polyline. Please use 1 query with 1 or more Common Table Expressions or subqueries
7. Creates a view of centroids for MN counties call the view mn_county_centroids.
8. Identifies all random points that are within 5 kilometers of a county centroid
9. Identifies all random points that are within 5 kilometers of the Anoka county centroid
10. Are there any duplicate random points. If so write the SQL that identifies them.
11. Identifies the number of duplicate points within each county.
12. If you were to delete a county in the mn_counties table, what would happen to the mn_county_centroids view

