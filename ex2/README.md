# EX2: Working with PostgreSQL and Database Management
The purpose of this exercise is to practice the basics of database management including Create, Read, Update, and Delete (CRUD) through the Iowa Liquor Sales and Denver Crimes spreadsheets, and utilize the some basic PostgreSQL functions:

1. [aggregate functions](https://www.postgresql.org/docs/10/functions-aggregate.html)
1. [string functions](https://www.postgresql.org/docs/10/functions-string.html)
1. [date time functions](https://www.postgresql.org/docs/10/functions-datetime.html)



## Data Sources

#### Kaggle Liquor Sales

Information about the Iowa liquor sales can be found at [Kaggle](https://www.kaggle.com/residentmario/iowa-liquor-sales)
#### Denver Crimes 2017
Information about the denver crimes spreadsheet can be found at the following [link](https://www.denvergov.org/opendata/dataset/city-and-county-of-denver-crime)



## Queries

- On what date (invoice_date) was the most total sales of liquor?
- Which store (store_name) had the largest liquor sales?
- Which county sold the least liquor?
- Report for every category the min, max, and total sales?
- How much more liquor was sold in 2012 compared to 2016?
- Provide the data definition language (DDL) information used for creating the denver_crimes table
- Provide the code you used for loading the data into the table. If you use INSERT VALUES 4 tuples is enough.
- Write the SQL statement used to group crimes by category, format string so that hyphens are spaces.
- How many traffic violations were committed in August 2014.
- Report the top ten categories of crimes for the month of August 2014
