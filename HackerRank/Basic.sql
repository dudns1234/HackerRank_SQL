-- Revising the Select Query I
문제 : Query all columns for all American cities in the CITY table with populations larger than 100000. The CountryCode for America is USA.
SELECT * FROM CITY WHERE POPULATION > 100000 AND COUNTRYCODE = 'USA'

-- Revising the Select Query II
문제 : Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.
SELECT NAME FROM CITY WHERE POPULATION > 120000 AND COUNTRYCODE = 'USA'

-- Select All
문제 : Query all columns (attributes) for every row in the CITY table.
SELECT * FROM CITY

-- Select By ID
문제 : Query all columns for a city in CITY with the ID 1661.
SELECT * FROM CITY WHERE ID = 1661

-- Weather Observation Station 3
문제 : Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
SELECT DISTINCT CITY FROM STATION WHERE ID % 2 = 0
SELECT DISTINCT CITY FROM STATION WHERE MOD(ID,2) = 0

-- Weather Observation Station 4
문제 : Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
SELECT COUNT(CITY) - COUNT(DISTINCT(CITY)) FROM STATION

-- Weather Observation Station 5
문재 : Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
(SELECT CITY, LENGTH(CITY)
FROM STATION 
WHERE LENGTH(CITY) = (SELECT MAX(LENGTH(CITY)) FROM STATION)
ORDER BY CITY ASC LIMIT 1)
UNION
(SELECT CITY, LENGTH(CITY) 
FROM STATION
WHERE LENGTH(CITY) = (SELECT MIN(LENGTH(CITY)) FROM STATION) 
ORDER BY CITY ASC LIMIT 1)
- 여기서 ()를 안해주면 에러 발생

-- Weather Observation Station 6
문제 : Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION WHERE LEFT(CITY,1) IN ('A','E','I','O','U'); -- 대문자 필수!!!

-- Weather Observation Station 7
문제 : Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION WHERE RIGHT(CITY,1) IN ('a','e','i','o','u');

-- Weather Observation Station 8
문제 : Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
SELECT DISTINCT CITY 
FROM STATION 
WHERE LEFT(CITY,1) IN ('A','E','I','O','U') AND RIGHT(CITY,1) IN ('a','e','i','o','u');

-- Weather Observation Station 9
Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION WHERE LEFT(CITY,1) NOT IN ('A','E','I','O','U');

-- Weather Observation Station 10
Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY FROM STATION WHERE RIGHT(CITY,1) NOT IN ('a','e','i','o','u');

-- Weather Observation Station 11
Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY,1) NOT IN ('A', 'E', 'I', 'O', 'U') OR RIGHT(CITY,1) NOT IN ('A', 'E', 'I', 'O', 'U');

-- Weather Observation Station 12
Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(CITY,1) NOT IN ('A', 'E', 'I', 'O', 'U') AND RIGHT(CITY,1) NOT IN ('A', 'E', 'I', 'O', 'U');

-- Higher Than 75 Marks
Query the Name of any student in STUDENTS who scored higher than  75 Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
SELECT NAME FROM STUDENTS WHERE MARKS > 75 ORDER BY RIGHT(NAME,3) ASC, ID ASC;

-- Employee Names
Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
SELECT NAME FROM EMPLOYEE ORDER BY NAME;

-- Employee Salaries
Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than $2000  per month who have been employees for less than 10 months. Sort your result by ascending employee_id.
SELECT NAME FROM EMPLOYEE WHERE SALARY >= 2000 AND MONTHS < 10 ORDER BY EMPLOYEE_ID ASC;

-- Revising Aggregations - The Count Function
-- 도시의 인구가 100,000명보다 큰 도시의 수를 쿼리
SELECT COUNT(*)
FROM CITY
WHERE POPULATION >= 100000

-- Revising Aggregations - The Sum Function
-- District가 캘리포니아에 있는 CITY의 모든 도시의 총 인구수를 조회
SELECT SUM(POPULATION)
FROM CITY
WHERE DISTRICT = 'California'

-- Revising Aggregations - Averages
SELECT AVG(POPULATION)
FROM CITY
WHERE DISTRICT = 'CALIFORNIA'

-- Average Population
-- 도시의 모든 도시에 대한 평균 인구를 가장 가까운 정수로 반올림
SELECT ROUND(AVG(POPULATION))
FROM CITY

-- Japan Population
SELECT SUM(POPULATION)
FROM CITY
WHERE COUNTRYCODE = 'JPN'

-- Population Density Difference
SELECT MAX(POPULATION) - MIN(POPULATION)
FROM CITY

-- The Blunder
SELECT CEILING(AVG(SALARY) - AVG(REPLACE(SALARY,0,''))) -- ROUND(AVG(SALARY) - AVG(REPLACE(SALARY,0,'')))+1
FROM EMPLOYEES
