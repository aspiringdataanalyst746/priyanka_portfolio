# STORED PROCEDURES: a way to save your sql code so you can reuse it again and again
-- when you save it you can call that store procedure and it can execute the code that you wrote
-- useful for storing complex queries, simplifying repetitive code and overall enhanced performance

CREATE PROCEDURE large_salaries() -- naming it
SELECT * -- normal query
FROM employee_salary
WHERE salary >= 50000;
-- hit refresh and this will be under "stored procedures"

CALL large_salaries(); -- call the procedure
-- 5:38
# Another way to do this- if you have multiple queries, need to create a different delimiter (; is a delimiter that seperates
# the queries. it will run 2 seperate queries instead of it being one query
DELIMITER $$ 
-- beginning of store procedure
CREATE PROCEDURE large_salaries3() 
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
    SELECT * 
    FROM employee_salary
    WHERE salary >= 10000;
END $$ 
-- end of store procedure
DELIMITER ; 
-- change delimiter back to the normal one- best pracitce!

CALL large_salaries3();

# PARAMETERS: variables that are passed as an input to a store procedure
DELIMITER $$
-- creating the parameter in "large_salaries4()"
-- naming the parameter (employee_id) and giving it a data type (integer)
CREATE PROCEDURE large_salaries4(employee_id_param INT)
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE employee_id = employee_id_param;
    -- employee_id in table = employee_id in parameter. naming it something else for less confusion
END $$
DELIMITER ;

-- passing through the parameter: inputting employee number 1 and we want the salary to come out as the output
CALL large_salaries4(1);

