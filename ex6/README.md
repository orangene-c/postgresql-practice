# EX6: Working with Topological Analysis
*Spatial statistics like Moran's I and LISA statistics are not supported in the PostGIS extension as functions. However, with a Spatial database you can use **topological functions/rules** to understand the spatial relationships in your data.*

Create a table and load the **mn_population** shapefile data, and load the raster datasets, **meris_2010** and **meris_2015** into the database, and complete the following queries:

1. Write the SQL code to find all the adjacent counties to Ramsey County.
2. Write the SQL that joins the counties to the population table data.
3. Write the SQL code that calculates and sums the total population of all the adjacent counties to Ramsey County.
4. Expand the SQL code in Question 2 so that it calculates the sums the total population of all the adjacent counties in Minnesota. Make sure to not add the counties in Wisconsin, Iowa, Dakota etc.
5. Expand the code in Question 3 and create a choropleth map of question 3 with labels of population for each adjacent county and place the image in your github repo.
6. Write the SQL query that finds all the roads the intersect with I-94.
7. Write the SQL query that determines the all the features outside a 10 mile buffer of I-94.
8. Calculate the histogram of landcover for Hennepin County in 2010. Do not use ST_Histogram, because the raster is an integer.
9. Which landcover types decreased from 2010 to 2015 in Hennepin County.
10. Which counties in MN has a decrease in tree cover (Values 50 through 90).
