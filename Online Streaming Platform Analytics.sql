create database streaming_platform;
use streaming_platform;

CREATE TABLE Users(
user_id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE,
country VARCHAR(50),
signup_date DATE
);

CREATE TABLE Subscription(
sub_id INT PRIMARY KEY,
user_id INT,
plan_type VARCHAR(20),
price DECIMAL(6,2),
start_date DATE,
end_date DATE,
FOREIGN KEY(user_id)
REFERENCES Users(user_id)
); 

CREATE TABLE Movies(
movie_id INT PRIMARY KEY,
title VARCHAR(150),
genre VARCHAR(50),
release_year INT,
duration INT
);

CREATE TABLE Watch_History(
watch_id INT PRIMARY KEY,
user_id INT,
movie_id INT,
watch_date DATE,
watch_time INT,
FOREIGN KEY(user_id)
REFERENCES Users(user_id),
FOREIGN KEY(movie_id)
REFERENCES Movies(movie_id)
);

CREATE TABLE Ratings(
rating_id INT PRIMARY KEY,
user_id INT,
movie_id INT,
rating INT CHECK(rating BETWEEN 1 AND 5),
review_date DATE,
FOREIGN KEY(user_id)
REFERENCES Users(user_id),
FOREIGN KEY(movie_id)
REFERENCES Movies(movie_id)
); 



select * from movie;
select * from users;
select * from subscription;
select * from watch_history;
select * from ratings;

select count(*) from movie;
select count(*) from users;
select count(*) from subscription;
select count(*) from watch_history;
select count(*) from ratings;


#                                      Module 1 — Basic Business Analysis
# Q1. Total Registered Users

SELECT COUNT(*) AS total_users
FROM Users;
#Shows the total customer base of the platform.

# Q2. Total Movies Available
SELECT COUNT(*) AS total_movies
FROM Movie_data;

# Q3. Total Revenue Generated
SELECT sum(price) as total_revenue
from subscription;

# Q4. Average Subscription Price
select round(avg(price),2) as avg_subscription_price 
from subscription;

# Q5. Revenue by Subscription Plan
select plan_type, count(*) as total_users,
sum(price) as revenue from subscription 
group by plan_type 
order by revenue desc;

# Q6. Users by Country
select country, count(*) as total_users from users 
group by country 
order by total_users desc;

# Q7. Movies by Genre
select genre , count(*) as total_movies from movie
group by genre 
order by total_movies desc;

# Q8. Average Duration by Genre
select genre, round(avg(duration),2) as avg_duration from movie
group by genre 
order by avg_duration desc;

# Q9. Latest Movies
select * from movie 
order by release_year desc limit 10; 

# Q10. Longest Movies
select title, duration from movie 
order by duration desc limit 10 ; 

# Q11 Premium vs Basic Users
select plan_type, count(*) as users from subscription
group by plan_type;

# Q12 Average Revenue per User (ARPU)
select 
round(sum(price)/count(distinct user_id),2) as ARPU
FROM subscription;

# Q13 Highest Subscription Price
select max(price) as highest_price 
from subscription; 

# Q14 Lowest Subscription Price
select min(price) as lowest_price 
from subscription;

# Q15 Average Watch Time
select avg(watch_time) as average_watch_time from watch_history;

# Q16 Total Watch Time
select sum(watch_time) as total_watch_time 
from watch_history;

# Q17 Movies Released Each Year
select release_year,
count(*) as total_movies from movie
group by release_year
order by release_year;

# Q18 Movies Longer than Average
select title, duration from movie where duration>
               (select avg(duration) from movie);
               
# Q19 Average Rating
select avg(rating) as avg_rating from ratings;

# Q20 Rating Distribution
select rating , count(*) as rating_distribution
from ratings 
group by rating 
order by rating desc;

# Q21 Watch Completion %
SELECT
w.watch_id,
m.title,
w.watch_time,
m.duration,
ROUND((w.watch_time/m.duration)*100,2) AS completion_percentage
FROM Watch_History w
JOIN Movie m
ON w.movie_id=m.movie_id;

# Q22 Completed Movies
select count(*) as completed_movies
from movie m
join watch_history w
on m.movie_id=w.movie_id
where w.watch_time>=m.duration ;  

# Q23 Incomplete Movies
select count(*) as incompleted_movie 
from movie m 
join watch_history w 
on m.movie_id=w.movie_id 
where w.watch_time<m.duration ; 

# Q24. Display User Name, Movie Title and Watch Date
# Which user watched which movie and when?
select u.user_id , u.name, 
m.title, w.watch_date from users u 
inner join watch_history w
on u.user_id =w.user_id 
inner join movie m
on w.movie_id = m.movie_id 
order by w.watch_date desc; 

# Q25. Display User Name, Movie Title and Watch Time
select u.name, m.title, w.watch_time
from users u 
inner join watch_history w
on u.user_id=w.user_id
join movie m 
on w.movie_id=m.movie_id ;

# Q26. Display User Name, Subscription Plan and Price
select u.name, s.plan_type, s.price
from subscription s
join users u 
on u.user_id=s.user_id; 

# Q27. Display User Name, Country and Subscription Plan
select u.name, u.country, s.plan_type
from Users u
join Subscription s
on u.user_id = s.user_id;

# Q28. Show Movies Watched by Indian Users
SELECT u.name, u.country, m.title
FROM Users u
JOIN Watch_History w
ON u.user_id = w.user_id
JOIN Movie m
ON w.movie_id = m.movie_id
WHERE u.country='India';

# Q29. Show Movie Title with User Rating
SELECT m.title, r.rating
FROM Movie m
JOIN Ratings r
ON m.movie_id = r.movie_id;

# Q30. Show User Name, Movie Title and Rating
SELECT u.name, m.title, r.rating
FROM Ratings r
JOIN Users u
ON r.user_id=u.user_id
JOIN Movie m
ON r.movie_id=m.movie_id;

# Q31. Average Rating of Every Movie
SELECT m.title, ROUND(AVG(r.rating),2) AS avg_rating
FROM Movie m
JOIN Ratings r
ON m.movie_id=r.movie_id
GROUP BY m.title
ORDER BY avg_rating DESC;

# Q32. Movies Rated Above 4
SELECT m.title, r.rating
FROM Movie m
JOIN Ratings r
ON m.movie_id=r.movie_id
WHERE r.rating>4;

# Q33. Total Watch Time per User
SELECT u.name, 
SUM(w.watch_time) AS total_watch_time
FROM Users u
JOIN Watch_History w
ON u.user_id=w.user_id
GROUP BY u.name
ORDER BY total_watch_time DESC; 

# Q34. Total Movies Watched per User
SELECT u.name,
COUNT(w.movie_id) AS movies_watched
FROM Users u
JOIN Watch_History w
ON u.user_id=w.user_id
GROUP BY u.name
ORDER BY movies_watched DESC;

# Q35. Top 10 Most Active Users
SELECT u.name,
COUNT(*) AS total_views
FROM Users u
JOIN Watch_History w
ON u.user_id=w.user_id
GROUP BY u.name
ORDER BY total_views DESC
LIMIT 10;

# Q36. Top 10 Most Watched Movies
SELECT m.title,
COUNT(*) AS total_views
FROM Movie m
JOIN Watch_History w
ON m.movie_id=w.movie_id
GROUP BY m.title
ORDER BY total_views DESC
LIMIT 10;

# Q37. Most Popular Genre
SELECT m.genre,
COUNT(*) AS watch_count
FROM Movie m
JOIN Watch_History w
ON m.movie_id=w.movie_id
GROUP BY m.genre
ORDER BY watch_count DESC;

# Q38. Total Watch Time by Genre
SELECT m.genre,
SUM(w.watch_time) AS total_watch_time
FROM Movie m
JOIN Watch_History w
ON m.movie_id=w.movie_id
GROUP BY m.genre
ORDER BY total_watch_time DESC;

# Q39. Average Watch Time by Genre
SELECT m.genre,
ROUND(AVG(w.watch_time),2) AS avg_watch
FROM Movie m
JOIN Watch_History w
ON m.movie_id=w.movie_id
GROUP BY m.genre;

# Q40. Average Rating by Genre
SELECT m.genre,
ROUND(AVG(r.rating),2) AS avg_rating
FROM Movie m
JOIN Ratings r
ON m.movie_id=r.movie_id
GROUP BY m.genre
ORDER BY avg_rating DESC;

# Q41. Revenue Generated by Country
SELECT u.country,
SUM(s.price) AS revenue
FROM Users u
JOIN Subscription s
ON u.user_id=s.user_id
GROUP BY u.country
ORDER BY revenue DESC;

# Q42. Revenue by Genre
SELECT m.genre,
SUM(s.price) AS estimated_revenue
FROM Watch_History w
JOIN Movie m
ON w.movie_id=m.movie_id
JOIN Subscription s
ON w.user_id=s.user_id
GROUP BY m.genre
ORDER BY estimated_revenue DESC;

# Q43. Users Who Watched but Never Rated
SELECT DISTINCT u.name
FROM Users u
JOIN Watch_History w
ON u.user_id=w.user_id
LEFT JOIN Ratings r
ON w.user_id=r.user_id
AND w.movie_id=r.movie_id
WHERE r.rating_id IS NULL;

# Q44. Movies Never Watched
SELECT m.title
FROM Movie m
LEFT JOIN Watch_History w
ON m.movie_id=w.movie_id
WHERE w.watch_id IS NULL;

# Q45. Movies Watched but Never Rated
SELECT DISTINCT m.title
FROM Movie m
JOIN Watch_History w
ON m.movie_id=w.movie_id
LEFT JOIN Ratings r
ON w.movie_id=r.movie_id
AND w.user_id=r.user_id
WHERE r.rating_id IS NULL;

# Q46. Movies with Duration Greater than Average
# Business Problem: Find movies longer than the average movie duration.
select movie_id, title, duration 
from movie 
where duration > (select avg(duration) from movie); 

# Q47. Movies Rated Above Average
# Business Problem: Find movies whose average rating is higher than the overall average rating.
select m.movie_id, m.title, avg(rating) from movie m
join ratings r 
on m.movie_id=r.movie_id
group by m.movie_id , m.title
having avg(r.rating)> (select avg(rating) from ratings );

# Q48. Users Who Watched More Movies than Average User
select u.user_id, u.name, count(*) as total_movies 
from users u 
join watch_history w
on w.user_id=u.user_id 
group by u.user_id, u.name 
having count(*)> 
( select avg(movie_count) from 
( select count(*) as movie_count from watch_history group by user_id ) as avg_movies); 

# Q49. Highest Rated Movie
select title from movie where movie_id=(
select movie_id from ratings 
group by movie_id
order by avg(rating) desc limit 1 );

# Q50. Lowest Rated Movie
SELECT title 
FROM Movie
WHERE movie_id =(
SELECT movie_id FROM Ratings
GROUP BY movie_id
ORDER BY AVG(rating)
LIMIT 1 );

# Q51. User Who Spent Maximum Money
SELECT name FROM Users
WHERE user_id = ( SELECT user_id
FROM Subscription
GROUP BY user_id
ORDER BY SUM(price) DESC
LIMIT 1 ); 

#  Q52. Most Watched Movie
SELECT title
FROM Movie
WHERE movie_id =
( SELECT movie_id
FROM Watch_History
GROUP BY movie_id
ORDER BY COUNT(*) DESC
LIMIT 1 );

# Q53. Least Watched Movie
SELECT title
FROM Movie
WHERE movie_id =
( SELECT movie_id
FROM Watch_History
GROUP BY movie_id
ORDER BY COUNT(*)
LIMIT 1
);

# Q54. Genres Having Above Average Watch Count
SELECT genre,
COUNT(*) AS total_views
FROM Movie m
JOIN Watch_History w
ON m.movie_id=w.movie_id
GROUP BY genre
HAVING COUNT(*) >
( SELECT AVG(total_views) FROM
( SELECT COUNT(*) AS total_views
FROM Movie m
JOIN Watch_History w
ON m.movie_id=w.movie_id
GROUP BY genre
) x );

# Q55. Highest Rated Movie in Each Genre
SELECT m.genre, m.title
FROM Movie m
JOIN Ratings r
ON m.movie_id=r.movie_id
GROUP BY m.genre,m.title
HAVING AVG(r.rating)=
( SELECT MAX(avg_rating)
FROM
( SELECT m2.genre, m2.movie_id,
AVG(r2.rating) avg_rating
FROM Movie m2
JOIN Ratings r2
ON m2.movie_id=r2.movie_id
WHERE m2.genre=m.genre
GROUP BY m2.genre,m2.movie_id
) t
);

# Q56. Users Who Have Rated Any Movie
select name from users u
where exists 
(select 1 from ratings r where r.user_id=u.user_id);

# Q57. Users Who Never Rated Any Movie
select name from users u 
where not exists 
(select 1 from ratings r 
where u.user_id=r.user_id);

# Q58. Movies That Have Ratings
select title from movie m 
where exists 
(select 1 from ratings r 
where m.movie_id=r.movie_id);

# Q59. Movies Never Rated
select title from movie m 
where not exists 
(select 1 from ratings r 
where r.movie_id=m.movie_id);

# Q60. Movies Longer Than ANY Sci-Fi Movie
select title, duration from movie 
where duration>any (
select duration from movie 
where genre="sci-fi"
);

# Q61. Movies Longer Than ALL Horror Movies
select title, duration from movie 
where duration>all 
(select duration from movie
where genre="Horror");

# Q62. Movies Watched by Indian Users
select title from movie
where movie_id in 
(select movie_id from watch_history 
where user_id in 
(select user_id from users 
where country="India") 
);

# Q63. Movies Never Watched
select title from movie 
where movie_id not in 
(select movie_id from watch_history);
# we can check by using these queries that there is no unwatched movie 
SELECT COUNT(*) FROM Movie;
SELECT COUNT(DISTINCT movie_id)
FROM Watch_History;

# Q64. Users Paying More Than Average Subscription Price
select u.name, s.price from users u 
join subscription s 
on s.user_id=u.user_id 
where s.price >
( select avg(price) from subscription s);

# Q65. Movies Rated 5 Stars
select title from movie m 
where movie_id in 
( select movie_id from ratings where rating=5 );

# Q66. Rank Movies by Average Rating (RANK())
# Business Problem: Rank movies based on their average rating.
select m.movie_id, m.title, 
avg(r.rating) as average_rating,
rank() over(order by avg(r.rating) desc) as movie_rank 
from movie m 
join ratings r 
on r.movie_id=m.movie_id
group by m.movie_id, m.title;

# Q67. Row Number for Users by Total Watch Time (ROW_NUMBER()) 
select u.user_id, u.name,
       sum(w.watch_time) as total_watch_time, 
	   row_number() over(order by sum(w.watch_time)desc ) as row_num
from users u 
join  watch_history w
on u.user_id=w.user_id
group by u.user_id, u.name;

# Q68. Dense Rank Movies by Watch Count (DENSE_RANK())
select m.title,
	   count(*) as total_views,
       dense_rank() over (order by count(*) desc ) as dense_ranking
from movie m 
join watch_history w 
on m.movie_id=w.movie_id
group by m.title;

# Q69. Running Total of Subscription Revenue
 select sub_id, start_date, price,
        sum(price) over(order by start_date ) as running_revenue
from subscription;

# Q70. Previous Watch Time (LAG())
select user_id, watch_date, watch_time,
	   lag(watch_time) over(partition by user_id order by watch_date) 
       as previous_watch_time
from watch_history; 

# Q71. Next Watch Time (LEAD())
select user_id, watch_date, watch_time,
	   lead(watch_time) over(partition by user_id order by watch_date) 
       as next_watch_time
from watch_history; 

# Q72. First Movie Watched by Each User (FIRST_VALUE())
select distinct 
	    user_id,
        first_value(movie_id) over(partition by user_id
        order by watch_date) as first_movie
from watch_history;

# Q73. Latest Movie Watched by Each User (LAST_VALUE())
SELECT DISTINCT
    user_id,
    LAST_VALUE(movie_id) OVER(
        PARTITION BY user_id
        ORDER BY watch_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS latest_movie
FROM Watch_History;

# Q74. Divide Users into 4 Groups (NTILE())
SELECT
    user_id,
    watch_time,
    NTILE(4) OVER(ORDER BY watch_time DESC) AS quartile
FROM Watch_History;

# Q75. Top Rated Movie in Each Genre
SELECT *
FROM
(
    SELECT
        m.genre,
        m.title,
        ROUND(AVG(r.rating),2) AS avg_rating,
        ROW_NUMBER() OVER(
            PARTITION BY m.genre
            ORDER BY AVG(r.rating) DESC
        ) AS rn
    FROM Movies m
    JOIN Ratings r
    ON m.movie_id = r.movie_id
    GROUP BY m.genre, m.movie_id, m.title
) x
WHERE rn = 1;

#Q76
WITH UserWatchCount AS
(
    SELECT
        user_id,
        COUNT(movie_id) AS total_movies
    FROM Watch_History
    GROUP BY user_id
)
SELECT
u.user_id,
u.name,
uw.total_movies
FROM UserWatchCount uw
JOIN Users u
ON uw.user_id=u.user_id
WHERE uw.total_movies>10
ORDER BY uw.total_movies DESC;

#Q77. Top 5 Users by Watch Time
WITH UserWatchTime AS
(
SELECT
user_id,
SUM(watch_time) AS total_watch_time
FROM Watch_History
GROUP BY user_id
)
SELECT
u.user_id,
u.name,
uw.total_watch_time
FROM UserWatchTime uw
JOIN Users u
ON uw.user_id=u.user_id
ORDER BY uw.total_watch_time DESC
LIMIT 5;


#Q78. Average Rating by Genre
WITH GenreRating AS
(
SELECT
m.genre,
ROUND(AVG(r.rating),2) AS avg_rating
FROM Movie m
JOIN Ratings r
ON m.movie_id=r.movie_id
GROUP BY m.genre
)
SELECT *
FROM GenreRating
ORDER BY avg_rating DESC;

#Q79. Movies Above Genre Average Rating
WITH MovieRatings AS
(
SELECT
m.movie_id,
m.title,
m.genre,
AVG(r.rating) AS avg_rating
FROM Movie m
JOIN Ratings r
ON m.movie_id=r.movie_id
GROUP BY m.movie_id,m.title,m.genre
)
SELECT *
FROM MovieRatings
WHERE avg_rating>
(
SELECT AVG(avg_rating)
FROM MovieRatings
);
 
 
#Q80. Create View for User Subscriptions
CREATE VIEW vw_user_subscription AS
SELECT
u.user_id,
u.name,
u.country,
s.plan_type,
s.price
FROM Users u
JOIN Subscription s
ON u.user_id=s.user_id;
SELECT *
FROM vw_user_subscription;


#Q81. Create View for Movie Ratings
CREATE VIEW vw_movie_ratings AS
SELECT
m.movie_id,
m.title,
ROUND(AVG(r.rating),2) AS avg_rating
FROM Movie m
JOIN Ratings r
ON m.movie_id=r.movie_id
GROUP BY m.movie_id,m.title;
SELECT *
FROM vw_movie_ratings;

#Q82. Create View for User Watch History
CREATE VIEW vw_watch_history AS
SELECT
u.name,
m.title,
w.watch_date,
w.watch_time
FROM Users u
JOIN Watch_History w
ON u.user_id=w.user_id
JOIN Movie m
ON w.movie_id=m.movie_id;
SELECT *
FROM vw_watch_history;


#Q83. Procedure to Get Movies by Genre (IN Parameter)
DELIMITER $$
CREATE PROCEDURE GetMoviesByGenre
(
IN p_genre VARCHAR(50)
)
BEGIN
SELECT *
FROM Movie
WHERE genre=p_genre;
END $$
DELIMITER ;
CALL GetMoviesByGenre('Action');

#Q84. Procedure to Count Movies by Genre (OUT Parameter)
DELIMITER $$

CREATE PROCEDURE CountMoviesByGenre
(
IN p_genre VARCHAR(50),
OUT total_movies INT
)
BEGIN
SELECT COUNT(*)
INTO total_movies
FROM Movie
WHERE genre=p_genre;
END $$
DELIMITER ;
CALL CountMoviesByGenre('Comedy', @total);
SELECT @total;

#Q85. Procedure to Increase Subscription Price (INOUT Parameter)
DELIMITER $$
CREATE PROCEDURE IncreasePrice
(
INOUT amount DECIMAL(6,2)
)
BEGIN
SET amount = amount + 100;
END $$
DELIMITER ;
SET @price = 299;
CALL IncreasePrice(@price);
SELECT @price;


#-----------------------------------------BUSINEES ANALYTICS--------------------------------------------------------
#Q86. Most Popular Genre
SELECT
    m.genre,
    COUNT(*) AS total_views
FROM Movie m
JOIN Watch_History w
ON m.movie_id = w.movie_id
GROUP BY m.genre
ORDER BY total_views DESC
LIMIT 1;


#Q87. Top 5 Movies by Total Watch Time
SELECT
    m.title,
    SUM(w.watch_time) AS total_watch_time
FROM Movie m
JOIN Watch_History w
ON m.movie_id = w.movie_id
GROUP BY m.movie_id, m.title
ORDER BY total_watch_time DESC
LIMIT 5;

#Q88. User Who Generated Highest Subscription Revenue
SELECT
    u.user_id,
    u.name,
    SUM(s.price) AS total_revenue
FROM Users u
JOIN Subscription s
ON u.user_id = s.user_id
GROUP BY u.user_id, u.name
ORDER BY total_revenue DESC
LIMIT 1;

#Q89. Best Performing Subscription Plan
SELECT
    plan_type,
    COUNT(*) AS subscriptions,
    SUM(price) AS revenue
FROM Subscription
GROUP BY plan_type
ORDER BY revenue DESC
LIMIT 1;

#Q90. Country Generating Highest Revenue
SELECT
    u.country,
    SUM(s.price) AS total_revenue
FROM Users u
JOIN Subscription s
ON u.user_id = s.user_id
GROUP BY u.country
ORDER BY total_revenue DESC
LIMIT 1;

#Q91. Highly Watched but Poorly Rated Movies
SELECT
    m.title,
    COUNT(DISTINCT w.watch_id) AS total_views,
    ROUND(AVG(r.rating),2) AS avg_rating
FROM Movie m
JOIN Watch_History w
ON m.movie_id = w.movie_id
JOIN Ratings r
ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(DISTINCT w.watch_id) >
       (
           SELECT AVG(movie_views)
           FROM
           (
               SELECT COUNT(*) AS movie_views
               FROM Watch_History
               GROUP BY movie_id
           ) x
       )
AND AVG(r.rating) < 3.5
ORDER BY total_views DESC;

#Q92. Most Engaged Users
SELECT
    u.user_id,
    u.name,
    SUM(w.watch_time) AS total_watch_time
FROM Users u
JOIN Watch_History w
ON u.user_id = w.user_id
GROUP BY u.user_id, u.name
ORDER BY total_watch_time DESC
LIMIT 10;

#Q93. Users with Low Engagement
SELECT
    u.user_id,
    u.name,
    SUM(w.watch_time) AS total_watch_time
FROM Users u
JOIN Watch_History w
ON u.user_id = w.user_id
GROUP BY u.user_id, u.name
HAVING SUM(w.watch_time) < 300
ORDER BY total_watch_time;

#Q94. Average Watch Time by Country
SELECT
    u.country,
    ROUND(AVG(w.watch_time),2) AS avg_watch_time
FROM Users u
JOIN Watch_History w
ON u.user_id = w.user_id
GROUP BY u.country
ORDER BY avg_watch_time DESC;

#Q95. Most Popular Genre in Each Country
WITH CountryGenre AS
(
    SELECT
        u.country,
        m.genre,
        COUNT(*) AS total_views
    FROM Users u
    JOIN Watch_History w
    ON u.user_id = w.user_id
    JOIN Movie m
    ON w.movie_id = m.movie_id
    GROUP BY u.country, m.genre
),
RankedGenre AS
(
    SELECT
        country,
        genre,
        total_views,
        ROW_NUMBER() OVER(
            PARTITION BY country
            ORDER BY total_views DESC
        ) AS rn
    FROM CountryGenre
)
SELECT
    country,
    genre,
    total_views
FROM RankedGenre
WHERE rn = 1;

#Q96. Movies Watched in More Than One Country
SELECT
    m.title,
    COUNT(DISTINCT u.country) AS countries_watched
FROM Movie m
JOIN Watch_History w
ON m.movie_id = w.movie_id
JOIN Users u
ON w.user_id = u.user_id
GROUP BY m.movie_id, m.title
HAVING COUNT(DISTINCT u.country) > 1
ORDER BY countries_watched DESC;

#Q97. Percentage of Movies That Received Ratings
SELECT
    ROUND(
        COUNT(DISTINCT r.movie_id) * 100.0
        / COUNT(DISTINCT m.movie_id),
        2
    ) AS rated_movie_percentage
FROM Movie m
LEFT JOIN Ratings r
ON m.movie_id = r.movie_id;

#Q98. Top 5 Users by Number of Movies Watched
SELECT
    u.user_id,
    u.name,
    COUNT(DISTINCT w.movie_id) AS movies_watched
FROM Users u
JOIN Watch_History w
ON u.user_id = w.user_id
GROUP BY u.user_id, u.name
ORDER BY movies_watched DESC
LIMIT 5;

#Q99. Revenue Contribution by Subscription Plan
SELECT
    plan_type,
    SUM(price) AS revenue,
    ROUND(
        SUM(price) * 100.0 /
        (SELECT SUM(price) FROM Subscription),
        2
    ) AS revenue_percentage
FROM Subscription
GROUP BY plan_type
ORDER BY revenue_percentage DESC;

#Q100. Overall Platform Performance KPI
SELECT
    (SELECT COUNT(*) FROM Users) AS total_users,
    (SELECT COUNT(*) FROM Movies) AS total_movies,
    (SELECT COUNT(*) FROM Watch_History) AS total_views,
    (SELECT SUM(watch_time)
	 FROM Watch_History) AS total_watch_time,
     (SELECT ROUND(AVG(rating),2)
     FROM Ratings) AS average_rating,
     (SELECT SUM(price)
     FROM Subscription) AS total_revenue;
     
