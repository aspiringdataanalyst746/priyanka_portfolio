-- Joins: join 2 or more tables if they have a common column 
SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT * 
FROM parks_and_recreation.employee_salary;

# inner join- brings all cols from both tables and only the same rows that both tables have
SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;

# OUTER JOIN - left join, right join
-- left join: takes everything from the left table, and only the matches from the right table
SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
    
# SELF JOIN: tie the table to itself (join the same table together
SELECT emp1.employee_id AS emp_santa, 
emp1.first_name AS first_name_santa, 
emp1.last_name AS last_name_santa, 
emp2.employee_id AS emp_id,
emp2.first_name AS first_name_emp, 
emp2.last_name AS last_name_emp
FROM employee_salary  emp1 # first table -> "left" table
JOIN employee_salary  emp2 # second table -> "right" table
	ON emp1.employee_id +1 = emp2.employee_id
;

-- Joining multiple tables together
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments pd
	ON sal.dept_id = pd.department_id #col names are different but the data is the same
    ;

#UNION - ALLOWS YOU TO COMBINE ROWS TOGETHER FROM THE SAME/SEPERATE TABLES
SELECT first_name, last_name
FROM employee_demographics
UNION #union distinct - will only take unique values and remove duplicates | union all - puts everything together
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name, 'Old Man' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;

#STRING FUNCTIONS IN MYSQL
SELECT length('skyfall');

SELECT first_name, length(first_name)
FROM employee_demographics
ORDER BY 2;

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

-- TRIM functions- removes whitespace from front, back or middle
SELECT('          sky            '); 
SELECT TRIM('          sky            '); 
SELECT LTRIM('          sky            '); # only removing whitespace from LHS
SELECT RTRIM('          sky            '); # only removing whitespace from RHS

# SUBSTRINGS
-- Left & Right
SELECT first_name,
LEFT(first_name, 4), # how many characters from the LHS do we want to select
RIGHT(first_name, 4), # how many characters from the RHS do we want to select
SUBSTRING(first_name,3,2), # col_name, position we want to start at, how many characters
birth_date,
SUBSTRING(birth_date,6,2) AS birth_month
FROM employee_demographics;

# REPLACE - replaces specific characters with a different character that you want
SELECT first_name, REPLACE(first_name, 'a', 'z') #replace a with z (case sensitive!)
FROM employee_demographics;

# LOCATE
SELECT LOCATE('x', 'Alexander'); #locate the letter 'x' in 'alexander'. output gives the position of the letter x

SELECT first_name, LOCATE('An', first_name)
FROM employee_demographics;

SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;

# CASE STATEMENTS
SELECT first_name, 
last_name,
age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 and 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END AS Age_Bracket
FROM employee_demographics;

# Example
-- Pay increase and bonus
-- < 50000 = 5% raise
-- > 50000 = 7% raise
-- finance = 10% bonus
SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN (salary * 1.05) 
    WHEN salary > 50000 THEN (salary * 1.07) 
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * 0.10
END AS Bonus
FROM employee_salary
;

# SUBQUERIES- query within another query
SELECT *
FROM employee_demographics
WHERE employee_id IN 
				(SELECT employee_id # can only have one column 
                FROM employee_salary
                WHERE dept_id = 1);

SELECT first_name, salary, 
(SELECT avg(salary) 
FROM employee_salary) AS avg_salary
FROM employee_salary;

SELECT AVG(max_age)
FROM 
(SELECT gender, 
avg(age) AS avg_age, 
max(age) AS max_age, 
min(age) AS min_age, 
count(age) AS count_age
FROM employee_demographics
GROUP BY gender) AS agg_table;

# WINDOW FUNCTIONS
SELECT gender, AVG(salary) as avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;

-- same thing as above, but using the window function
-- result will be in their own individual rows
SELECT dem.first_name, dem.last_name, # benefit of window fn is that we can add cols like this and it won't affect the result (can't do this with the fn above)
gender, 
AVG(salary) OVER(PARTITION BY gender) # performs calculation (in this case avg but for the unique values of gender
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;

-- Rolling total: starts at a specific value, and adds on values from subsequent rows based off of your partition
SELECT dem.first_name, dem.last_name, 
gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
  
-- row number with rolling funtions
SELECT dem.employee_id, dem.first_name, dem.last_name, 
gender, salary,
ROW_NUMBER() OVER()
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
-- row number (repeating itself) with rolling funtions 
SELECT dem.employee_id, dem.first_name, dem.last_name, 
gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num, # rank- according to position (if 2 values are the same, will change as can see here with Tom-Andy)
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num # still duplicates, but gives the next number numerically, not positionally
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;