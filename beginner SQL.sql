SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT 
    first_name, 
    last_name, 
    birth_date,
    age,
    (age + 10) * 10 + 10 + 10 
FROM
    parks_and_recreation.employee_demographics;
    
SELECT distinct first_name, gender
FROM parks_and_recreation.employee_demographics;

# WHERE CLAUSE
SELECT *
FROM parks_and_recreation.employee_salary
WHERE first_name = 'Leslie'; 

SELECT *
FROM parks_and_recreation.employee_salary
WHERE salary <= 50000; 

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE gender != 'Female'
;

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1985-01-01'
;

# Logical operators in the WHERE clause: AND OR NOT
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1985-01-01' OR NOT gender = 'Male'
;

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55
;

-- LIKE STATEMENT
-- % and _
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date LIKE '1989%'
;

SELECT *
FROM parks_and_recreation.employee_demographics;

# GROUP BY clause
SELECT first_name
FROM parks_and_recreation.employee_demographics
GROUP BY gender;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM parks_and_recreation.employee_demographics
group by gender; 

SELECT occupation, salary
FROM parks_and_recreation.employee_salary
group by occupation, salary;

# ORDER BY CLAUSE
SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY gender, age; 

# HAVING CLAUSE
SELECT gender, AVG(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age) > 35
; 

SELECT occupation, AVG(salary)
FROM parks_and_recreation.employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000
;

# FINAL VIDEO OF MYSQL BEGINNER SERIES
# limit - to get top 3, top 10 etc
SELECT *
FROM parks_and_recreation.employee_demographics
order by age desc
LIMIT 2, 1; # position 2 (row 2) and the one after it (i.e. row 3)

-- Aliasing: changing the name of the column
SELECT gender, AVG(age) AS avg_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING avg_age > 40;
