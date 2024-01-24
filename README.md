# -Apple-App-Store-Data-Exploration
 
### Project Overview


This data exploration project focuses on providing insights for aspiring app developers looking to make data-driven decisions in building their apps for the Apple App Store. 

The project aims to answer the following stakeholder questions:


# Stakeholders' Questions:

* What app categories are most popular?

* What price should I set for my app?

* How can I maximize user ratings for my app?


# Data Preparation


The initial step in this project involves combining data from multiple sources to create a comprehensive dataset for analysis.


* Combine Data Using Joins

``CREATE TABLE applestore_description_combined AS``

``SELECT * FROM appleStore_description1``

``UNION ALL``

``SELECT * FROM appleStore_description2``

``UNION ALL``

``SELECT * FROM appleStore_description3``

``UNION ALL``

``SELECT * FROM appleStore_description4``



## Exploratory Data Analysis


Overview of Data


Let's start by checking the structure of the data and getting familiar with it.


***Check the structure of the tables***


``SELECT * FROM AppleStore``

``SELECT * FROM applestore_description_combined``


***Unique App IDs***

We need to know the number of unique apps in both Apple Store tables.

``SELECT COUNT(DISTINCT id) AS UniqueAppIDs``

``FROM AppleStore``

``SELECT COUNT(DISTINCT id) AS UniqueAppIDs``

``FROM applestore_description_combined``


***Missing Values*** 

Checking for missing values in key fields.

``SELECT COUNT(*) AS MissingValues``

``FROM AppleStore``

``WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL``

``SELECT COUNT(*) AS MissingValues``

``FROM applestore_description_combined``

``WHERE app_desc IS NULL``



***App Categories***

Finding out the number of apps per genre.

``SELECT prime_genre, COUNT(*) AS NumApps``

``FROM AppleStore``

``GROUP BY prime_genre``

``ORDER BY NumApps DESC``


***App Ratings***

Getting an overview of the app ratings.

``SELECT MIN(user_rating) AS MinRating``,

        MAX(user_rating) AS MaxRating,
      
         AVG(user_rating) AS AvgRating
      
``FROM AppleStore``

***Paid vs. Free Apps***

Determining whether paid apps have higher ratings than free apps.

`SELECT CASE`

           WHEN price > 0 THEN 'Paid'
          
           ELSE 'FREE'
          
      END AS App_Type,
      
       AVG(user_rating) AS Avg_Rating`
       
`FROM AppleStore`

`GROUP BY App_Type`


***Supported Languages***

Checking if apps with more supported languages have higher ratings.


`SELECT CASE`
           
           WHEN lang_num < 10 THEN '<Languages'
          
           WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
          
           ELSE '>30 languages'
       
       END AS language_bucket,
      
       AVG(user_rating) AS Avg_Rating

`FROM AppleStore`

`GROUP BY language_bucket`

`ORDER BY Avg_Rating DESC`


***Low-Rated Genres***

Identifying genres with low user ratings.


`SELECT prime_genre`,
      
       AVG(user_rating) AS Avg_Rating

`FROM AppleStore`

`GROUP BY prime_genre`

`ORDER BY Avg_Rating ASC`

`LIMIT 10`



***Description Length vs. User Rating***

Checking if there is a correlation between the length of the app description and user ratings.


`SELECT CASE`
           
           WHEN LENGTH(b.app_desc) < 500 THEN 'Short'
           
           WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
          
           ELSE 'Long'
      
       END AS description_length_bucket,
     
       AVG(a.user_rating) AS average_rating

`FROM AppleStore AS a`

`JOIN applestore_description_combined AS b`

`ON a.id = b.id`

`GROUP BY description_length_bucket`

`ORDER BY average_rating DESC`

***Top-Rated Apps by Genre***

Identifying the top-rated app for each genre.


`SELECT prime_genre`,
      
      ` track_name`,
 
      ` user_rating`

`FROM` (
          
          SELECT prime_genre,
               
                 track_name,
               
                 user_rating,
                 
                 RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
          
          FROM AppleStore
    
     ) AS a

`WHERE a.rank = 1`



# Insights
The most popular app categories on the Apple App Store are revealed, allowing app developers to make informed decisions on which categories to target.
The analysis provides insights into app pricing, indicating whether paid or free apps tend to have higher user ratings.
The number of supported languages and their impact on user ratings is analyzed, offering guidance on language support for app developers.
Genres with lower average user ratings are identified, helping developers avoid potentially less competitive markets.
The relationship between app description length and user ratings is explored, offering insight into the ideal length of app descriptions for attracting higher ratings.
The top-rated app for each genre is identified, allowing developers to benchmark their apps against the best in their respective categories.
