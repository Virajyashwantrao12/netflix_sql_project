drop table if exists netflix;
Create table netflix
(
   show_id Varchar(6),
   type    Varchar(10),
   title   Varchar(150),
   director Varchar(208),
   casts    Varchar(1000),
   country  Varchar(150),
   date_added Varchar(50),
   release_year Int,
   rating Varchar(10),
   duration Varchar(15),
   listed_in Varchar(150),
 description Varchar(250)
);

select*from netflix;
select count(*) as total_count
from netflix;

select distinct type from netflix;

--15 business problems solving
--Q1. Count the no. of movies and Tv show
select
type,
count(*) as total_content
from netflix
group by type

Q2. find the most common rating for movies and tv shows

SELECT
    type,
    rating,
    total_count,
    RANK() OVER (
        PARTITION BY type
        ORDER BY total_count DESC
    ) AS ranking
FROM (
    SELECT
        type,
        rating,
        COUNT(*) AS total_count
    FROM netflix
    GROUP BY type, rating
) t
ORDER BY type, total_count DESC;
Q3. list all movies released in a specific year for eg.2020
Select * from netflix
--filter for 2020
--movies

where type='Movie'
      And
	  release_year=2020

Q4. Find all the top 5 countries with the most content on netlfix
SELECT
    UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

Q5. Identify thr longest movie or tv show duration
Select*from netflix
where
	type='Movie'
	And
	duration= (Select Max(duration)From netflix)

Q6. find content added in last 5 years
select
	*
from netflix
where
	TO_date(date_added, 'Month DD,YYYY') >= Current_date - INTERVAL '5 years'
SELECT CURRENT_DATE - INTERVAL '5 years';

Q7. Find all the movies or tv shows directed by 'Rajiv Chilake'!
SELECT *
FROM netflix
WHERE director = 'Rajiv Chilaka';

Q8. List all TV shoes with more than 5 seasons
select*from netflix
where
	type='TV Show'
	and
	split_part(duration, ' ',1):: numeric> 5

Q9. Count the number of content items in each genre
select
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by 1

--Q10. Find each year andthe avg number of content release by india on netflix. return top 5 
--year with highest avg content release!

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS yearly_content,
    ROUND(
        COUNT(*)::numeric /
        (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100,
        2
    ) AS pct_content_per_year
FROM netflix
WHERE country = 'India'
  AND date_added IS NOT NULL
GROUP BY 1
ORDER BY 1;




	
