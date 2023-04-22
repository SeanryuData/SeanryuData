/****** Script for SelectTopNRows command from SSMS  ******/
/****** Checking flaws in my data
I could see that there is address used multiple times, which should not be happening.******/
use project;

SELECT *
  FROM [Address];

SELECT COUNT([add])
  FROM [Address]

--lets check by comparing the rows after sorting by address names
select distinct *
from Address
order by [add]

--looks like we are having multiple longitude or latitude values even with same Add
--i ll remove all null values for the coordinate

delete from Address
where Longitude is null or Latitude is null

--re check
select distinct *
from Address
order by [add];

-- we still have duplicate address with slightly different values in longitude and latitude
-- This might be caused due to formating type while importing the data, or just flaws inside data set
-- only selecting the distinct values for add


-- got some help from googling on how to create a table with no duplicate on one column
-- below execution will give me table information which then i can make use of it to create a new table and insert into

EXEC sp_columns address;

if OBJECT_ID('new_add') is not null drop table new_add;

CREATE TABLE new_add (
  [Add] nvarchar(max),
  Block_ID int,
  CLUE_small_area nvarchar(max),
  Longitude float,
  Latitude float
  );

INSERT INTO new_add ([Add], Block_ID, CLUE_small_area, Longitude, Latitude)
SELECT [Add], MIN(Block_ID), MIN(CLUE_small_area), MIN(Longitude), MIN(Latitude)
FROM Address
GROUP BY [Add];

--checking on the new table created
select *
from new_add;

-- from 40k rows to 5136
select count(*)
from new_add;


-- now for Shop dataset, explore

select *
from shop;

select COUNT(*)
from shop;

-- i believe there are no duplicated row since the count are exactly same
SELECT COUNT(DISTINCT concat(Census_year, [Add], Shop, Seating_type, Number_of_seats))
FROM shop;

-- The problem with our data set is that it contains restaurants and shops without coffee in thier menu.
-- therefore, will be filtering out business names that doesnt include coffee related words
--(this is a limitation on our data set)

select *
from shop
where  [shop] like '%coffee%' 
or [shop] like '%cafe%'
or [shop] like '%espresso%'
or [shop] like '%pour over%'

-- looking at how many shops with coffee related name we have

select count(*)
from shop
where  [shop] like '%coffee%' 
or [shop] like '%cafe%'
or [shop] like '%espresso%'
or [shop] like '%pour over%'

-- dropping all the rows that doenst have business name of coffee relation

DELETE FROM shop
WHERE [shop] NOT LIKE '%coffee%'
and [shop] not like '%cafe%'
and [shop] not like '%espresso%'
and [shop] not like '%pour over%';

--double check by counting number of rows that includes the filtering word and full rows
-- they both have same 12271 counts. So successfully done.

select count(*)
from shop

select count(*)
from shop
where  [shop] like '%coffee%' 
or [shop] like '%cafe%'
or [shop] like '%espresso%'
or [shop] like '%pour over%'


use project ;

select *
from new_add

select *
from shop

-- table successfully joint

select *
from shop as sh
left join new_add
on new_add.[Add] = sh.[add];

--Create a view based on the fields I need for Power BI then save it as view
Create view full_table as
select a.[Shop] as Business_name, a.Census_year, a.Number_of_seats, a.Seating_type,
b.*
from shop as a
left join new_add as b
on b.[Add] = a.[add];

select *
from full_table;

--lets check if there is business_name + census year more than 3 occurance.
--query is not giving any result , so no shop with repeated value
select [Census_year], new_add.[add], [shop], count(Number_of_seats) as bothseats
from shop as sh
left join new_add
on new_add.[Add] = sh.[add]
group by [Census_year], new_add.[add], [shop]
having count(Number_of_seats) > 2
order by [shop];


--so now moving into adding indoor seat + outdoor seat.
create view Census_year_vs_TotalS as
select [Census_year], new_add.[add], [shop], sum(Number_of_seats) as TotalS
from shop as sh
left join new_add
on new_add.[Add] = sh.[add]
group by [Census_year], new_add.[add], [shop];
--saving this as a view, so we can take a look at relation ship between Census_year vs TotalS

select *
from Census_year_vs_TotalS;

select *
from new_add;

--I see add as Null for some values.
select *
from Census_year_vs_TotalS
left join new_add
on new_add.[add] = Census_year_vs_TotalS.[add]

-- double check if there is null values and yes i do see some null values
select [Census_year], new_add.[add], [shop], sum(Number_of_seats) as TotalS
from shop as sh
left join new_add
on new_add.[Add] = sh.[add]
group by [Census_year], new_add.[add], [shop]
having [shop] = 'Reflex Cafe'


--after checking out the data inside Power BI, I found there are some ridiculus outlier to seating number field. 
--(eg: Arena View Restaurant And Cafe  had seating numbers of 2640), upon checking on google, looks like they also included the seats inside arena.
--lets explore in table shape.

select Business_name, avg(Number_of_seats)
from full_table
group by business_name, Number_of_seats
having Number_of_seats > 100
order by AVG(Number_of_seats) desc;

--Top 10 restaurnats did not exist in google, or were counting the seats for entire food court they were affliated in.
--rather than excluding the cafe with number of seats exceeding specific number.
--I decided to add one categorical field, which I can use PowerBI Slicer to compare.
select *
from [dbo].[full_table];


ALTER VIEW [dbo].[full_table] AS
SELECT Business_name, Census_year, Number_of_seats,Seating_type,[add],Block_ID,CLUE_small_area,Longitude,Latitude,
  CASE 
    WHEN number_of_seats BETWEEN 1 AND 25 THEN '1-25'
    WHEN number_of_seats BETWEEN 26 AND 50 THEN '26-50'
    ELSE '50+'
  END AS seat_range
FROM [dbo].[full_table];

--Having Error of following View or function 'dbo.full_table' contains a self-reference. Views or functions cannot reference themselves directly or indirectly.
select *
from [dbo].[full_table];

DROP VIEW [dbo].[full_table];

-- recreating view

CREATE VIEW full_table AS
SELECT a.[Shop] AS Business_name, a.Census_year, a.Number_of_seats, a.Seating_type,
b.Block_ID, b.CLUE_small_area, b.Longitude, b.Latitude,
  CASE 
    WHEN a.Number_of_seats BETWEEN 1 AND 25 THEN '1-25'
    WHEN a.Number_of_seats BETWEEN 26 AND 50 THEN '26-50'
    ELSE '50+'
  END AS seat_range
FROM shop AS a
LEFT JOIN new_add AS b ON b.[Add] = a.[add];

select *
from full_table

--Lets also update the View I created earlier [dbo].[Census_year_vs_TotalS].

drop view Census_year_vs_TotalS;

create view Census_year_vs_TotalS as

select [Census_year], new_add.[add], [shop], sum(Number_of_seats) as TotalS, 
  CASE 
    WHEN sum(Number_of_seats) BETWEEN 1 AND 25 THEN '1-25'
    WHEN sum(Number_of_seats) BETWEEN 26 AND 50 THEN '26-50'
    ELSE '50+'
  END AS TotalS_range
from shop as sh
left join new_add
on new_add.[Add] = sh.[add]
group by [Census_year], new_add.[add], [shop];

--Check
select *
from Census_year_vs_TotalS


--I see another outlier in my datat exploration via power BI, where Clue_small_area is (Blank)
select *
from full_table
where CLUE_small_area is null;

--I dont see Address column in my View, I missed it out from above haha

DROP VIEW [dbo].[full_table];

CREATE VIEW full_table AS
SELECT a.[Shop] AS Business_name, a.Census_year, a.Number_of_seats, a.Seating_type,b.[Add],
b.Block_ID, b.CLUE_small_area, b.Longitude, b.Latitude,
  CASE 
    WHEN a.Number_of_seats BETWEEN 1 AND 25 THEN '1-25'
    WHEN a.Number_of_seats BETWEEN 26 AND 50 THEN '26-50'
    ELSE '50+'
  END AS seat_range
FROM shop AS a
LEFT JOIN new_add AS b ON b.[Add] = a.[add];

-- As expected, they were having missing information in Address, Removing the rows where business address is empty
select *
from full_table
where CLUE_small_area is null;

DROP VIEW [dbo].[full_table];

CREATE VIEW full_table AS
SELECT a.[Shop] AS Business_name, a.Census_year, a.Number_of_seats, a.Seating_type,b.[Add],
b.Block_ID, b.CLUE_small_area, b.Longitude, b.Latitude,
  CASE 
    WHEN a.Number_of_seats BETWEEN 1 AND 25 THEN '1-25'
    WHEN a.Number_of_seats BETWEEN 26 AND 50 THEN '26-50'
    ELSE '50+'
  END AS seat_range
FROM shop AS a
LEFT JOIN new_add AS b ON b.[Add] = a.[add]
where b.[Add] is not null;


-- Lets create a rank column to use for yearly change in Total seats for each cafe.
select f.[add], Census_year,SUM(number_of_seats) as totalS, 
rank() over (partition by f.[add] order by census_year,sum(Number_of_seats)) as ranker, 
lag(
SUM(number_of_seats),1
) over (partition by f.[add] order by census_year)
from full_table f
group by f.[add], Census_year 


--  I want to use the ranker-1 as a value for its lag. For that there need to be a self jointo use ranker as a value
select f.[add], Census_year,SUM(number_of_seats) as totalS, 
rank() over (partition by f.[add] order by census_year,sum(Number_of_seats)) as ranker, 
lag(
SUM(number_of_seats),1
) over (partition by f.[add] order by census_year)
from full_table f
group by f.[add], Census_year 

SELECT [add], Census_year, totalS, ranker, 
       (ranker - 1) as ranker_minus_one
FROM (
    SELECT f.[add], Census_year, SUM(number_of_seats) as totalS, 
           RANK() OVER (PARTITION BY f.[add] ORDER BY census_year, SUM(Number_of_seats)) as ranker, 
           LAG(SUM(number_of_seats), 1) OVER (PARTITION BY f.[add] ORDER BY census_year)
    FROM full_table f
    GROUP BY f.[add], Census_year
) as subquery


SELECT [add], Census_year, totalS, ranker, 
       (ranker - 1) as ranker_minus_one
FROM (
    SELECT f.[add], Census_year, SUM(number_of_seats) as totalS, 
           RANK() OVER (PARTITION BY f.[add] ORDER BY census_year, SUM(Number_of_seats)) as ranker, 
           LAG(SUM(number_of_seats), 1) OVER (PARTITION BY f.[add] ORDER BY census_year) as prev_year_total
    FROM full_table f
    GROUP BY f.[add], Census_year
) as subquery

SELECT a.[add], a.Census_year, a.totalS, a.ranker, 
       (a.ranker - 1) as ranker_minus_one, b.totalS as prev_year_totalS
FROM (
    SELECT f.[add], Census_year, SUM(number_of_seats) as totalS, 
           RANK() OVER (PARTITION BY f.[add] ORDER BY census_year, SUM(Number_of_seats)) as ranker, 
           LAG(SUM(number_of_seats), 1) OVER (PARTITION BY f.[add] ORDER BY census_year) as prev_year_total
    FROM full_table f
    GROUP BY f.[add], Census_year
) AS a
LEFT JOIN (
    SELECT f.[add], Census_year, SUM(number_of_seats) as totalS
    FROM full_table f
    GROUP BY f.[add], Census_year
) AS b
ON a.[add] = b.[add] AND a.Census_year - 1 = b.Census_year

--While I could use Lag function to bring TotalS value of lag of Census_Year - (rank-1).
--I thought it would make it lot more simple for me to use self join of a.Censusyear = b.censusyear-1
--to use selfjoin with Total S. I need to subquery


SELECT a.[add], b.Census_year,a.Census_year, a.totalS, b.totalS
FROM 
(SELECT [add], Census_year, SUM(number_of_seats) AS totalS
from full_table
group by [add], Census_year
) as a
left JOIN 
(SELECT [add], Census_year, SUM(number_of_seats) AS totalS
from full_table
group by [add], Census_year
)
as b
    ON a.[add] = b.[add] AND a.Census_year - 1 = b.Census_year
ORDER BY a.[add], a.Census_year,b.Census_year;

-- I realised that for self join, using CTE will reduce the work as you only have to write the query once.
With cte as(
SELECT [add], Census_year, SUM(number_of_seats) AS totalS
from full_table
group by [add], Census_year)

SELECT a.[add],a.Census_year, a.totalS, b.totalS as TotalS_prev_year
FROM cte as a
left JOIN 
cte as b
    ON a.[add] = b.[add] AND a.Census_year - 1 = b.Census_year
ORDER BY a.[add], a.Census_year,b.Census_year;

--perfect, now lets calculate the annual change in TotalSeats by subtracting the value.
With cte as(
SELECT [add], Census_year, SUM(number_of_seats) AS totalS
from full_table
group by [add], Census_year)

SELECT a.[add],a.Census_year,a.totalS, b.totalS-a.totalS as Change_in_Seats
FROM cte as a
left JOIN 
cte as b
    ON a.[add] = b.[add] AND a.Census_year - 1 = b.Census_year
ORDER BY a.[add], a.Census_year,b.Census_year;


--I already checked the graph of general trend of change in seats which were reducing over time. But lets see if thats actually the case by using Average.
With cte as(
SELECT [add], Census_year, SUM(number_of_seats) AS totalS
from full_table
group by [add], Census_year)

SELECT avg(cast(b.totalS-a.totalS as float)) as AvgChange_in_Seats
FROM cte as a
left JOIN 
cte as b
    ON a.[add] = b.[add] AND a.Census_year - 1 = b.Census_year
where b.Census_year is not null

--Resulted in -.0315 as expected and checked by visual.
--Lets also check by different seat_range

With cte as(
SELECT [add], Census_year, SUM(number_of_seats) AS totalS, seat_range
from full_table
group by [add], Census_year,seat_range)

SELECT avg(cast(b.totalS-a.totalS as float)) as AvgChange_in_Seats,a.seat_range
FROM cte as a
left JOIN 
cte as b
    ON a.[add] = b.[add] AND a.Census_year - 1 = b.Census_year
where b.Census_year is not null
group by a.seat_range;

--there is massive positive value for range 1-25. 21.8. Which indicating the calculation is also adding up when the new shop is introduced.
--lets check if thats actually the case.
--seating range is preventing me from using aggregate function, as it is calculated based on the number of seats rather than TotalS
--so there are two seating range for each seating type even on the same census_year and business name.
-- I need to readdress seat range so it is based on the total seats rather than number of seats.

With cte as(
SELECT [add], Census_year, SUM(number_of_seats) AS totalS, seat_range
from full_table
group by [add], Census_year,seat_range)

SELECT a.[add],a.Census_year,a.totalS --,cast(b.totalS-a.totalS as float) as Change_in_Seats,a.seat_range
FROM cte as a
left JOIN 
cte as b
    ON a.[add] = b.[add] AND a.Census_year - 1 = b.Census_year

group by a.[add], a.Census_year, a.totalS
order by a.[add], a.Census_year

SELECT [add], Census_year, SUM(number_of_seats) AS totalS
from full_table a
group by [add], Census_year
order by a.[add], a.Census_year

select *
from full_table