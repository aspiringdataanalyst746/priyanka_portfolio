# TRIGGERS AND EVENTS
# Trigger: a block of code that executes automatically when event takes place on a specific table
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;


DELIMITER $$
CREATE TRIGGER employee_insert
-- specify what event needs to take place in order for this to be triggered
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ; 
DROP TRIGGER employee_insert;

-- refresh and find 'triggers' tab under employee_salary section
-- let's test it!
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(52, 'Jean-Ralphia', 'Sapaersteina', 'Entertainment 721 CEO', 1000001, NULL);

# Events: scheduled trigger- helpful for automation
SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO 
BEGIN
	DELETE
	FROM employee_demographics
	WHERE age >= 60;
END $$
DELIMITER ;