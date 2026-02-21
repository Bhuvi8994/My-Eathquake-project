CREATE DATABASE earthquake_db;
USE earthquake_db;earthquake_dataearthquake_dataearthquake_dataearthquake_data
earthquake_data
SELECT COUNT(*) FROM earthquake_data;
---------Top 10 strongest earthquakes----------
SELECT time, place, mag
FROM earthquake_data
ORDER BY mag DESC
LIMIT 10;

--------Top 10 deepest earthquakes-------
SELECT time, place, depth_km
FROM earthquake_data
ORDER BY depth_km DESC
LIMIT 10;

------Shallow earthquakes < 50 km and mag > 7.5 -------
SELECT * 
FROM earthquake_data
WHERE depth_km < 50 AND mag > 7.5;

------ Average magnitude per magnitude type ------
SELECT magType, avg(mag) as age_mag
FROM earthquake_data 
group by magType;

------- Year with most earthquakes ------
SELECT year, COUNT(*) AS total
FROM earthquake_data
GROUP BY year
ORDER BY total DESC;

-------Month with highest number of earthquakes ------
SELECT Month, count(*) as total
FROM earthquake_data 
Group by month 
order by total DESC;

-----Day of week with most earthquakes----
SELECT day_of_week, Count(*) as total
FROM earthquake_data
group by day_of_week
order by total DESC;

--------Count of earthquakes per hour of day--------
SELECT hour(time) as hour, COUNT(*) as total
FROM earthquake_data
group by hour
order by hour;

------- Most active reporting network (net)-------
SELECT net, COUNt(*) as total
FROM earthquake_data
Group by net
order by net;

--------Count of reviewed vs automatic earthquakes-----------
SELECT status, COUNT(*) as total
FROM earthquake_data
group by status;

--------Count by earthquake type ---------
SELECT type, COUNT(*) as total
FROM earthquake_data
group by type;

------- Number of earthquakes by data type-------
SELECT type, COUNT(*) as total
FROM earthquake_data
group by type;

--------- Events with high station coverage (nst > threshold)------------
SELECT * 
FROM earthquake_data
WHERE nst > 50;

------------Number of tsunamis triggered per year--------
SELECT year, count(*) as tsunami
FROM earthquake_data
WHERE tsunami = 1
group by year
order by year;

-----------Count earthquakes by alert levels---------
SELECT alert, COUNT(*) as total
FROM earthquake_data
Group by alert;

----------Top 5 places with highest casualties------
SELECT place, SUM(casualties) as total
FROM earthquake_data
group by place
order by total DESC
limit 5;earthquake_data

--------- Average economic loss by alert level---------
SELECT alert, avg(economic_loss_usd) as avg_economic_loss_usd
FROM earthquake_data 
group by alert;

------------top 5 countries with the highest average magnitude of earthquakes in the past 10 years----------------
SELECT 
    country,
    AVG(mag) AS avg_magnitude,
    COUNT(*) AS total_earthquakes
FROM earthquake_data
WHERE year >= YEAR(CURDATE()) - 5
GROUP BY country
ORDER BY avg_magnitude DESC
LIMIT 5;

---------countries that have experienced both shallow and deep earthquakes within the same month-----
SELECT country, year, month
FROM earthquake_data
GROUP BY country, year, month
HAVING SUM(depth_km='shallow') > 0
   AND SUM(depth_km='deep') > 0;
   
-----------the year-over-year growth rate in the total number of earthquakes globally---------
SELECT year, COUNT(*) AS total_eq, LAG(COUNT(*)) OVER (ORDER BY year) AS prev_year, (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY year)) / LAG (COUNT(*)) OVER (ORDER BY year) * 100 growth_rate
FROM earthquake_data
GROUP BY year;

-------the 3 most seismically active regions by combining both frequency and average magnitude------------
SELECT country, COUNT(*) AS total_eq, AVG(mag) AS avg_mag, (COUNT(*) * AVG(mag)) AS activity_score
FROM earthquake_data
GROUP BY country
ORDER BY activity_score DESC 
LIMIT 3;

-----------each country, calculate the average depth of earthquakes within ±5° latitude range of the equator-----------
SELECT 
    country,
    AVG(depth_km) AS avg_depth_equatorial_zone,
    COUNT(*) AS total_eq
FROM earthquake_data
WHERE latitude BETWEEN -5 AND 5
      AND depth_km IS NOT NULL
      AND country IS NOT NULL
GROUP BY country
ORDER BY avg_depth_equatorial_zone DESC;

-------countries having the highest ratio of shallow to deep earthquakes-------
SELECT country, SUM(depth_km='shallow') / NULLIF (SUM(depth_km='deep'),0) shallow_deep_ratio
FROM earthquake_data
Group by country
order by shallow_deep_ratio DESC;

----------the average magnitude difference between earthquakes with tsunami alerts and those without----------
SELECT 
    AVG(CASE WHEN tsunami = 1 THEN mag END) 
    - 
    AVG(CASE WHEN tsunami = 0 THEN mag END) 
    AS avg_mag_difference
FROM earthquake_data
WHERE mag IS NOT NULL;

------the gap and rms columns, identify events with the lowest data reliability (highest average error margins)----------
SELECT id, place, rms, gap, (rms + gap) as error_score
FROM earthquake_data
order by error_score DESC;

------the regions with the highest frequency of deep-focus earthquakes (depth > 300 km)------
SELECT 
    country,
    COUNT(*) AS deep_focus_earthquake_count
FROM earthquake_data
WHERE depth_km > 300
      AND country IS NOT NULL
GROUP BY country
ORDER BY deep_focus_earthquake_count DESC;

DESCRIBE earthquake_data;
