CREATE TABLE applestore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL 

SELECT * FROM appleStore_description4


*EXPLORATORY DATA ANALYSIS*

--Check to familiarise with the table 

SELECT * FROM AppleStore

SELECT * FROM applestore_description_combined


--Check the number of unique apps in both apple store tables 

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM applestore_description_combined

--Check for missing values in key fields 

SELECT COUNT(*) AS Missingvalues
FROM AppleStore
WHERE track_name is NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS Missingvalues
FROM applestore_description_combined
WHERE app_desc IS NULL


-- find out the number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC


--Get an overview of the app's ratings 

SELECT Min(user_rating) AS MinRating,
	   Max(user_rating) AS MaxRating,
       Avg(user_rating) AS AvgRating
FROM AppleStore

--Determine whether paid apps have higher ratings than free apps

SELECT CASE 
			WHEN price > 0 	THEN 'Paid'
            ELSE 'FREE'
        END as App_Type,
        Avg(user_rating) AS Avg_Rating
FROM 	AppleStore
GROUP BY App_Type 

--Check if apps with more supported languages have higher ratingsAppleStore

SELECT CASE 
			WHEN lang_num <10 THEN '<Languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
       END AS language_bucket,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC

           
-- Check genre with low ratings 

SELECT prime_genre,
		avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10
      


-- Check if there is a correlation between the length of the app description and the user rating 

SELECT CASE 
			WHEN length(b.app_desc) <500 THEN 'short'
            WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
        END AS description_length_bucket,
        avg(a.user_rating) AS average_rating

FROM 
		AppleStore AS a
JOIN    
		applestore_description_combined AS b
ON 			
		a.id = b.id

GROUP BY  description_length_bucket
ORDER BY  average_rating DESC

      
--Check top-rated app for each genre

SELECT 
	prime_genre,
    track_name,
    user_rating
FROM (
  		SELECT 
  		prime_genre,
  		track_name,
  		user_rating,
  		RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
        FROM 
        AppleStore
     ) 	AS a 
WHERE 
a.rank = 1





