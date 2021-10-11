--Question 1 done
DELIMITER $$
CREATE TRIGGER emp_name_upcse
BEFORE INSERT ON employee FOR EACH ROW 
BEGIN 
	SET NEW.ename=UPPER(NEW.ename);
END $$
DELIMITER ;

--Question 2 done
DROP TABLE IF EXISTS emp_backup;
CREATE TABLE emp_backup (emp_id VARCHAR(30),
ename VARCHAR(30) NOT NULL,dob DATE ,doj DATE,sal DECIMAL(10,2),dept_id INTEGER ,FOREIGN KEY (dept_id) REFERENCES department(dept_id),
date_of_op DATE,type_of_op VARCHAR(30));

DROP TRIGGER IF EXISTS emp_details_backup;
DELIMITER $$
CREATE TRIGGER emp_details_backup
BEFORE DELETE ON employee FOR EACH ROW
BEGIN 
	INSERT INTO emp_backup(emp_id,ename,dob,doj,sal,dept_id,date_of_op,type_of_op) VALUES (OLD.emp_id,OLD.ename,OLD.dob,OLD.doj,
	OLD.sal,OLD.dept_id,CURDATE(),'Delete');
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER emp_details_backup_update
AFTER UPDATE ON employee FOR EACH ROW
BEGIN 
	INSERT INTO emp_backup(emp_id,ename,dob,doj,sal,dept_id,date_of_op,type_of_op) VALUES (OLD.emp_id,OLD.ename,OLD.dob,OLD.doj,
	OLD.sal,OLD.dept_id,CURDATE(),'Update');
END$$
DELIMITER ;

--Question 3 not getting result

CREATE TRIGGER before_insert
BEFORE INSERT ON employee FOR EACH ROW 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='inserting';


CREATE TRIGGER before_delete
BEFORE DELETE ON employee FOR EACH ROW
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='deleting';



CREATE TRIGGER before_update
BEFORE UPDATE ON employee FOR EACH ROW 
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='updating';





--Question 4 done
DELIMITER $$
CREATE TRIGGER checking_emp_id
BEFORE INSERT ON employee FOR EACH ROW 
BEGIN 
	IF NEW. emp_id NOT LIKE 'E%' THEN 
		SET NEW.emp_id =CONCAT('E',NEW.emp_id);
	END IF;
END $$
DELIMITER ;

--Question 5 done
DELIMITER $$
CREATE TRIGGER calculating_age
BEFORE INSERT ON employee FOR EACH ROW 
BEGIN 
	DECLARE age INT ;
	SELECT TIMESTAMPDIFF(YEAR,NEW.dob,CURDATE()) INTO age;
	IF age<=0 THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='INVALID AGE';
	END IF;
END $$
DELIMITER ;
--Question 6 done
DROP TRIGGER IF EXISTS update_salary;
DELIMITER $$
CREATE TRIGGER update_salary
BEFORE UPDATE ON employee FOR EACH ROW
BEGIN
	IF NEW.sal < .8*OLD.sal THEN 
		SET NEW.sal=OLD.sal;
	END IF;
END $$
DELIMITER ;
--Question 7 done
DROP TRIGGER IF EXISTS calc_tax;
DELIMITER $$
CREATE TRIGGER calc_tax
BEFORE INSERT ON employee FOR EACH ROW 
BEGIN 
	IF ((NEW.sal)*12) >=15000 AND ((NEW.sal)*12)<=100000 THEN
		 SET NEW.tax_amount = ((NEW.sal)*12)*(10/100);
	ELSEIF ((NEW.sal)*12)>=100000 AND ((NEW.sal)*12)<200000 THEN 
		SET NEW.tax_amount = ((NEW.sal)*12)*(15/100);
	ELSEIF ((NEW.sal)*12)>=200000 THEN
		SET NEW.tax_amount = ((NEW.sal)*12)*(20/100);
	END IF ;
END $$
DELIMITER ;


