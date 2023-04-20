# EX3: Working with Join and other PostgreSQL functions

Create and load the following CSV files into database:

1. **mn_census_tracts**
2. **mn_county_pixel_values**

And practice with the following queries:

- Write the select or create statement that results in a new table mn_tracts_2000 that contains the following fields by Total, White_alone Black_alone, American_Indian_alone, Asian_alone Hawaiian_PI_alone, SOR_alone)
- Write the query necessary for joining the census tracts to the county pixel values table. (This is a zonal-- statistics of landcover types)
- If you use the count of pixels as a proxy for area, which county has the most people per pixel?
- Write the select or create statement that results in a new table mn_county that contains the aggregates of the following fields by county (Total, one_race, White_alone Black_alone, American_Indian_alone, Asian_alone Hawaiian_PI_alone, SOR_alone)
- Create a temporary table and a view for the previous question.
- What statement removes from the temporary table any records where the countyfp is 37, 19, or 53.

