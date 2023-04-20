CREATE TABLE mn_county_pixel_values(
county_code integer,
county_name text,
pixel_value integer,
pixel_count integer
);

\COPY mn_county_pixel_values FROM '/Users/zing/Desktop/GIS5577/lab3/lab3-Ziiiiing/mn_county_pixel_values.csv' WITH CSV HEADER;