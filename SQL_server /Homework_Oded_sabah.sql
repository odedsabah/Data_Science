select * from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'dbo'

select * from movies

-- 1. Get the top ten popular movies where the original language was English.
select top(10) *
  from movies
 where original_language = 'en'
 order by
       popularity desc
;

-- 2. Calculate the number of movies that were released by year.
select year(release_date) as release_year
     , count(movie_id) as movies_count
  from movies
 group by
       year(release_date)
 order by
       release_year
;

-- 3. Calculate the number of movies that were released by month.
select month(release_date) as release_month
     , count(movie_id) as movies_count
  from movies
 group by
       month(release_date)
 order by
       release_month
;

-- 4. Create a new variable based on runtime,
--    where the movies are categorized into
--    the following categories: 0 = Unknown, 1-50 = Short, 51-120 Average, >120 Long.
select *
     , case
         when runtime >= 1 and runtime <= 50 then 'Short'
         when runtime > 50 and runtime <= 120 then 'Average'
         when runtime > 120 then 'Long'
         else 'Unknown'
       end as movie_runtime_group
  from movies
 order by
       runtime
;

-- 5. For each year, calculate :

--    a. The dense rank, based on the revenue (descending order)
select *
     , year(release_date) as release_year
     , dense_rank() over (
         partition by year(release_date)
             order by revenue desc
       ) as revenue_rank_by_year
  from movies
;

--    b. The yearly revenue's sum of the movies
select *
     , year(release_date) as release_year
     , sum(cast(revenue as float)) over (
           partition by year(release_date)
       ) as revenue_sum_by_year
  from movies
;

--    c. The percent of the revenue with respect to the yearly annual revenue (b).
select *
     , year(release_date) as release_year
     , sum(cast(revenue as float)) over (
           partition by year(release_date)
       ) as revenue_sum_by_year
     , revenue / sum(cast(revenue as float)) over (
           partition by year(release_date)
       ) * 100 as pct_of_year_revenue
  from movies
;

-- 6. For each movie:
--    Count the number of female actors in the movie.
--    Count the number of male actors in the movie.
--    Calculate the ratio of male vs women (female count / male count)

select movie_id
     , [1] as female_actors_cnt
     , [2] as male_actors_cnt
     , cast([1] as float) / (case when [2] > 0 then cast([2] as float) else 1 end) as female_male_ratio
  from (
          select m.movie_id
               , a.gender
               , a.actor_id
            from movies as m
                 inner join
                 movies_cast as c
                   on m.movie_id = c.movie_id
                 inner join
                 actors_dim as a
                   on c.actor_id = a.actor_id
           where a.gender > 0
           group by
                 m.movie_id
               , a.gender
               , a.actor_id
       ) as src
 pivot (
         count (actor_id) for gender in ([1], [2])
       ) pvt
 order by
       movie_id
;

---    7. For each of the following languages: [en, fr, es, de, ru, it, ja]:
--- Create a column and set it to 1 if the movie has a translation** to the language and zero if not.
select *
  from (
         select iso_639_1
              , 1 as num
              , movie_id
           from movie_languages

       ) as src
 pivot (
         count (num)
         for iso_639_1 in (en, fr, es, de, ru, it, ja)
       ) as pvt
 order by
       movie_id
;
---     8.For each of the crew departments, get a column and count the total number of individuals for each movie.
-- Create a view with this query

create view dsuser22.crew_departments as
(
    select m.movie_id
         , c.department
         , count(1) as crew_count
      from movies as m
           inner join
           movies_crew as c
             on m.movie_id = c.movie_id
     group by
           m.movie_id
         , c.department
)
;
select * from dsuser22.crew_departments
         order by movie_id
