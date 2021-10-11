--Question 1
DELIMITER $$
DROP PROCEDURE IF EXISTS inst_emp;
CREATE PROCEDURE inst_emp()
BEGIN 
  DECLARE err INT DEFAULT 0;
	DECLARE CONTINUE HANDLER FOR 1062 SET err=1;
	INSERT INTO employee(emp_id,ename,dob,doj,sal,dept_id) VALUES (1,'Ravi','2001-02-28','2019-02-02',60000.00,3);
	IF err=1 THEN
	BEGIN
		SELECT CONCAT('Duplicate key  occurred') AS message;
	END ;
  END IF;
END $$
DELIMITER ;

--question 2
USE testdb;
DELIMITER $$
CREATE PROCEDURE show_emp_names()

BEGIN
	DECLARE F INT DEFAULT 0;
	DECLARE fname VARCHAR(50);
	DECLARE emp_names VARCHAR(5000) DEFAULT ' '; 
	DECLARE cur CURSOR FOR SELECT ename FROM employee;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET f=1;
	OPEN cur;
	loop1: LOOP 
		FETCH cur INTO fname;
		IF f=1 THEN
			LEAVE loop1;
		END IF;
		SET emp_names = CONCAT(emp_names, fname, ', ');
	END LOOP loop1;
	CLOSE cur;
	SELECT emp_names;
END$$
DELIMITER ;
		
--call function
CALL show_emp_names();

--QUESTION 3
DELIMITER $$

CREATE PROCEDURE update_emp_salary()
BEGIN
	DECLARE F INT DEFAULT 0;
	DECLARE id INT ;
	DECLARE join_date DATE ;
	DECLARE yy INT; 
	DECLARE cur1 CURSOR FOR SELECT emp_id FROM employee;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET f=1;
	OPEN cur1;
	loop1: LOOP
		FETCH cur1 INTO id;
		IF f=1 THEN
			LEAVE loop1;
		END IF;
		SELECT doj FROM employee WHERE emp_id=id INTO join_date;
		SELECT TIMESTAMPDIFF(YEAR, join_date, CURDATE()) INTO yy;
		myloop : WHILE yy>0 DO
				UPDATE employee SET sal = sal + .05*sal WHERE emp_id =id;
				SET yy=yy-1;
		END WHILE myloop;
	END LOOP loop1;
	CLOSE cur1;
END $$
DELIMITER ;

--call PROCEDURE
CALL update_emp_salary();
