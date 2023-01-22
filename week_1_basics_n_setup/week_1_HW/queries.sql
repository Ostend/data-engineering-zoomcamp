--Question 3. Count records 
--How many taxi trips were totally made on January 15?
--Tip: started and finished on 2019-01-15. 
--Remember that `lpep_pickup_datetime` and `lpep_dropoff_datetime` columns are in the format timestamp (date and hour+min+sec) and not in date.

--QUERY:

SELECT
CAST(lpep_pickup_datetime AS DATE) as pick_up_day, CAST(lpep_dropoff_datetime AS DATE) as drop_off_day,
COUNT(1)
FROM green_taxi_data
WHERE CAST(lpep_pickup_datetime AS DATE) = '2019-01-15'
AND CAST(lpep_dropoff_datetime AS DATE) = '2019-01-15'
GROUP BY
CAST(lpep_pickup_datetime AS DATE),
CAST(lpep_dropoff_datetime AS DATE)

--Answer: 20530

--Question 4. Largest trip for each day
--Which was the day with the largest trip distance
--Use the pick up time for your calculations.

--QUERY:

SELECT 
CAST(lpep_pickup_datetime AS DATE) as day
FROM green_taxi_data
WHERE trip_distance = (
 SELECT MAX(trip_distance)
 FROM green_taxi_data
)

--ANSWER: 2019-01-15

--Question 5. The number of passengers
--In 2019-01-01 how many trips had 2 and 3 passengers?

--QUERY:

SELECT COUNT(green_taxi_data."passenger_count") FILTER (WHERE green_taxi_data."passenger_count" = 2) as count_2,
COUNT(green_taxi_data."passenger_count") FILTER (WHERE green_taxi_data."passenger_count" = 3) as count_3
FROM green_taxi_data
WHERE CAST(lpep_pickup_datetime AS DATE) = '2019-01-01'

--ANSWER: {2:1282, 3:254}

--Question 6. Largest tip
--For the passengers picked up in the Astoria Zone which was the drop off zone that had the largest tip?
--We want the name of the zone, not the id.

Select g.tip_amount, g."PULocationID", g."DOLocationID", t."Zone"
FROM green_taxi_data g
JOIN taxi_zone pickup_zone ON g."PULocationID" = pickup_zone."LocationID"
JOIN taxi_zone t ON g."DOLocationID" = t."LocationID"
WHERE pickup_zone."Zone" = 'Astoria'
ORDER BY 
g.tip_amount desc

