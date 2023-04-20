-- Select from the dataset the following states minnesota, alabama, wisconsin, illinois?
-- Messages: 6683 rows affected.
SELECT *
FROM census_tracts_2000_diversity
WHERE state_name='Minnesota' OR state_name='Alabama' OR state_name='Wisconsin' OR state_name='Illinois';

-- Which state has the most census tracts?
-- California: 7049
SELECT state_name, COUNT(census_tract_code) AS census_tract_count
FROM census_tracts_2000_diversity
GROUP BY state_name
ORDER BY census_tract_count DESC
LIMIT 1;


-- Which state has the largest population?
-- California: 33871648
SELECT state_name, SUM(total) AS state_population
FROM census_tracts_2000_diversity
GROUP BY state_name
ORDER BY state_population DESC
LIMIT 1;

-- Which state has the largest population of people over the age of 65?
-- California: 3595658
SELECT state_name, SUM(male_65_and_66_years + male_67_to_69_years + male_70_to_74_years + male_75_to_79_years + male_80_to_84_years + male_85_years_and_over
					 + female_65_and_66_years + female_67_to_69_years + female_70_to_74_years + female_75_to_79_years + female_80_to_84_years + female_85_years_and_over) 
					 AS state_population_over_65
FROM census_tracts_2000_diversity
GROUP BY state_name
ORDER BY state_population_over_65 DESC
LIMIT 1;

-- Which state has the largest population of people 17 and under?
-- California: 9249829
SELECT state_name, SUM(male_under_5_years + male_5_to_9_years + male_10_to_14_years + male_15_to_17_years
					 + female_under_5_years + female_5_to_9_years + female_10_to_14_years + female_15_to_17_years) 
					 AS state_population_under_17
FROM census_tracts_2000_diversity
GROUP BY state_name
ORDER BY state_population_under_17 DESC
LIMIT 1;

-- What are the top 10 states with the largest populations?
-- CA, TX, NY, FL, IL,Pen, Ohio,Michigan, New Jersey, Georgia
SELECT state_name, SUM(total) AS state_population
FROM census_tracts_2000_diversity
GROUP BY state_name
ORDER BY state_population DESC
LIMIT 10;

-- How many counties are in each state?
SELECT state_name, COUNT(DISTINCT county_code) AS county_count
FROM census_tracts_2000_diversity
GROUP BY state_name
ORDER BY state_name;

-- Which state has the largest population of american indians?
-- CA: 333346
SELECT state_name, SUM(american_indian_alone) AS american_indian_pop
FROM census_tracts_2000_diversity
GROUP BY state_name
ORDER BY american_indian_pop DESC
LIMIT 1;

-- ?Which census tract has the largest proportion of male to women ratio?
-- [some female and men columns have bad values which are not equal to the sum of all-age's population; some female has 0 value as well]
SELECT gis_join_match_code, state_name, state_code, county_name, county_code, census_tract_code, male, female, NULLIF(male,0)/NULLIF(female,0) AS male_to_female_ratio
FROM census_tracts_2000_diversity
ORDER BY male_to_female_ratio DESC NULLS LAST
LIMIT 1;

-- ?Which states have the top 10 census tracts with unequal ratios for men and women?
-- [some female and men columns have bad values which are not equal to the sum of all-age's population; some female has 0 value as well]
SELECT gis_join_match_code, state_name, male, female, NULLIF(male,0)/NULLIF(female,0) AS male_to_female_ratio
FROM census_tracts_2000_diversity
ORDER BY male_to_female_ratio DESC NULLS LAST
LIMIT 10;

-- ?which census tracts have a majority minority population? --Majority minority population is defined as non-white population.
-- [Does this question mean to query the census tract that more than half of the population is non-white??]
SELECT gis_join_match_code, state_name, state_code, county_name, county_code, census_tract_code, total, total-white_alone as minorities
FROM census_tracts_2000_diversity
WHERE total-white_alone > total/2;


