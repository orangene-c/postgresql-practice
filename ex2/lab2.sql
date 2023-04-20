-- 1. On what date (invoice_date) was the most total sales of liquor?
-- 2012-10-05 had the most total sales of $79,369.34
SELECT invoice_date, SUM(sale) AS total_sales
FROM iowa_liquor_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 2. Which store (store_name) had the largest liquor sales?
-- Hy-Vee #3 / BDI / Des Moines had the largest liquor sales of $477,603.41
SELECT store_name, SUM(sale) AS total_sales
FROM iowa_liquor_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 3. Which county sold the least liquor?
-- "FREMONT" sold least of "$338.29"
SELECT county, SUM(sale) AS total_sales
FROM iowa_liquor_sales
GROUP BY 1
ORDER BY 2
LIMIT 1;

-- 4. Report for every category the min, max, and total sales?
SELECT category_name, MIN(sale) AS min_sale, MAX(sale) AS max_sale, SUM(sale) AS total_sales
FROM iowa_liquor_sales
GROUP BY 1
ORDER BY 1;

-- 5. How much more liquor was sold in 2012 compared to 2016?
-- 2012 sold "$2,552,990.67"; 2016 sold "$2,436,544.46"; over "$116,446.21"
SELECT (MAX(temp_table.total_sales) - MIN(temp_table.total_sales)) AS compared_sales_2012_2016
FROM (SELECT EXTRACT(YEAR FROM invoice_date) AS invoice_year, SUM(sale) AS total_sales
	  FROM iowa_liquor_sales
	  WHERE EXTRACT(YEAR FROM invoice_date) = 2012 OR EXTRACT(YEAR FROM invoice_date) = 2016
	  GROUP BY invoice_year) AS temp_table;
	  
-- Extra can you analyze question (2,3) by the month?

-- 6. Provide the data definition language (DDL) information used for creating the denver_crimes table
DROP TABLE denver_crimes;
CREATE TABLE denver_crimes
(
	gid integer,
	offense_id bigint,
	offense_code integer,
	offense_type_id text,
	offense_category_id text,
	reported_date date,
	precinct_id integer,
	neighborhood_name text,
	is_crim boolean,
	is_trafic boolean
);


-- 7. Provide the code you used for loading the data into the table. If you use INSERT VALUES 4 tuples is enough.
-- 358970 records inserted
INSERT INTO denver_crimes
VALUES (63532,2.01E+15,3572,'drug-methampetamine-possess','drug-alcohol','3/4/2014',112,'globeville','t','f'),
        (63533,2.01E+15,2310,'theft-from-mails','larceny','3/4/2014',222,'hale','t','f'),
		(63534,2.01E+15,5441,'traffic-accident','traffic-accident','3/4/2014',423,'marston','f','t'),
		(63535,2.01E+15,5499,'traf-other','all-other-crimes','3/4/2014',422,'ruby-hill','t','f');




-- 8. Write the SQL statement used to group crimes by category, format string so that hyphens are spaces.
-- [Query distinct offense_category_id only??]
SELECT DISTINCT TRANSLATE(offense_category_id, '-', ' ') as offense_category_id_formatted
FROM denver_crimes;


-- 9. How many traffic violations were committed in August 2014.
-- 1904 cases
SELECT COUNT(*) AS traffic_counts_201408
FROM denver_crimes
WHERE is_trafic is True AND EXTRACT(YEAR FROM reported_date) = 2014 AND EXTRACT(MONTH FROM reported_date) = 8;

-- 10. Report the top ten categories of crimes for the month of August 2014
-- how to define crimes? true for is_crim column only? Or every record is defined as a crime?
SELECT offense_category_id, COUNT(offense_code) AS crime_counts_201408
FROM denver_crimes
WHERE EXTRACT(YEAR FROM reported_date) = 2014 AND EXTRACT(MONTH FROM reported_date) = 8
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

