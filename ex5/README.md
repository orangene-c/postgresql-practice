# EX5: Working with PostGIS and Raster Data

This exercise is to develop expertise in processing spatial raster data with **PostGIS** using the **GLC2000** raster dataset, with the following queries:

1. creates a histogram of the state of Minnesota. A histogram is each unique pixel type and total number of pixels.
2. returns the most common pixel value for each county in Minnesota
3. returns the minimum and maximum value for each county in Minnesota
4. Rewrite query in Question 3 so that it uses a subquery or common table expression
5. reclassifies Mosaic: Croplaand / Shrub or Grass Cover (pixel value = 18 to pixel value 20)
6. Rewrite the query from question 5 to group the non-liveable places to a new pixel value 30. Then count the number of new pixels.
7. reclassifies all trees (Example not the actual values pixel value = [3,4,5,6] ) to a new category forest.
8. uses map algebra that multiplies all your pixel values by 5.
