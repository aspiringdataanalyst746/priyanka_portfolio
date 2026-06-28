CREATE PROCEDURE large_salaries2()
SELECT *
FROM employee_salary
WHERE salary >= 60000;
SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- When we change this delimiter it now reads in everything as one whole unit or query instead of stopping
-- after the first semi colon
DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
END $$

-- now we change the delimiter back after we use it to make it default again
DELIMITER ;

-- let's refresh to see the SP
-- now we can run this stored procedure
CALL large_salaries2();

