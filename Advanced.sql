-- CTE: COMMON TABLE EXPRESSION. Define a subquery block that you can then reference in the main query
-- can only use a CTE immediately after creating it
WITH CTE_Example AS # how it gets defined
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT avg(avg_sal)
FROM CTE_Example
;

# same as above, but having columnn names at top
WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS -- overwrites column names that you have in your CTE query
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;


-- Same thing as above, but with a subquery
SELECT AVG(avg_sal)
FROM (SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) example_subquery
;

-- Create multiple CTEs within one
WITH CTE_Example AS # how it gets defined. first cte
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS # second cte
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;

# TEMPORARY TABLES: only available in the session they are created in
-- can be used to restore intermediate results for complex queries or to manipulate data before inserting it into a more perm table
-- 1st way
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar (50),
favourite_movie varchar(100)
);

-- view the table
SELECT *
FROM temp_table; -- can insert data into this table and reuse it (during the session)

INSERT INTO temp_table
VALUES('Alex', 'Freberg', 'Lord of the Rings: The Two Towers');

SELECT *
FROM temp_table;

-- 2nd way to create a temp table (more popUlar)
-- selecting data from an already existing table. naming it 'literally' to easily understand what is inside
SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k 
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k ;