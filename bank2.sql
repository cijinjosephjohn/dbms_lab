CREATE TABLE branch (branch_id INT PRIMARY KEY,branch_name VARCHAR(50) NOT NULL,city VARCHAR(50) DEFAULT 'Trivandrum');

CREATE TABLE customer (cust_id INT PRIMARY KEY,cust_name VARCHAR(50) NOT NULL,city VARCHAR(50));

CREATE TABLE deposit(acc_no INT PRIMARY KEY,cust_id INT,branch_id INT,amount DECIMAL(14,2),date DATE,FOREIGN KEY (cust_id) REFERENCES customer(cust_id),FOREIGN KEY (branch_id) REFERENCES branch(branch_id),CHECK (amount>=1000) );

CREATE TABLE borrow(loan_no INT PRIMARY KEY,cust_id INT,branch_id INT ,amount DECIMAL(14,2),date DATE,FOREIGN KEY (cust_id) REFERENCES customer(cust_id),FOREIGN KEY (branch_id) REFERENCES branch(branch_id),CHECK (amount>=1000));

INSERT INTO branch(branch_id,branch_name,city) VALUES 
(4,'Fort','Bombay'),(294,'Crowford','Bombay'),(34,'Brighton','Brooklyn'),(352,'Downtown','Brooklyn'),(362,'Sampada','Nandgaon'),(62,'North Town','Bangalore'),(621,'Pownal','Nagpur'),(734,'Round Hill','Nagpur'),(834,'Seedwood','Nagpur');

INSERT INTO customer(cust_id,cust_name,city) VALUES (10034,'Mic Ronald','Brooklyn'),(10052,'Sunil Ray','Nandgaon'),(10053,'George David','Bangalore'),(10012,'David John','Nagpur'),(10021,'Sony Issac','Nagpur'),(10013,'Issac Collins','Bombay'),(10064,'Collins Gray','Brooklyn'),(10074,'Jennifer May','Bangalore'),(10031,'Mary Jane','Nagpur'),(10083,'Peter Hant','Nandgaon'),(10099, 'Gracy Lark','Bombay'),(10098,'Elizabeth Bennt','Bombay'),(10089,'Darcy Drack','Bangalore'),(10097,'Albert Bennt','Nagpur'),(10079,'Lizzy Richard','Nagpur'),(10095,'Rossy John','Nandgaon');

INSERT INTO deposit(acc_no,cust_id,branch_id,amount,date) VALUES (124001,10098,294,10000.00,'2021-01-02'),(124032,10013,4,50000.00,'2020-11-12'),(124030,10083,362,60000.00,'2014-11-12'),(124091,10021,834,30000.00,'2020-11-12'),(124009,10053,62,90000.00,'2021-02-02'),(124035,10012,734,80000.00,'2020-11-12'),(124058,10074,62,83000.00,'2014-08-12'),(124086,10052,362,30000.00,'2020-11-12'),(124010,10097,621,20000.00,'2014-09-02');
INSERT INTO borrow (loan_no,cust_id,branch_id,amount,date) VALUES (142002,10064,34,20034.00,'2020-11-12'),(142024,10052,362,30300.00,'2020-11-12'),(142059,10099,4,80005.00,'2020-11-12'),(142094,10034,352,12030.00,'2020-11-12'),(142049,10089,62,9503.00,'2020-11-12'),(142093,10097,734,15000.00,'2020-11-12'),(142039,10079,621,60000.00,'2020-11-12'),(142099,10095,362,130000.00,'2020-11-12'),(142010,10012,834,30000.00,'2020-01-02');

--1. Write a function to find the number of customers who have loan.
DELIMITER $$
CREATE FUNCTION loan_cust_cnt()
RETURNS INT
BEGIN
	DECLARE cust_cnt INT;
	SELECT COUNT(DISTINCT c.c_id) AS "No. of customers" 
	FROM customer AS c INNER JOIN borrow AS bo ON c.cust_id=bo.cust_id INTO cust_cnt;
	RETURN cust_cnt;
END$$
DELIMITER ;
--function call
SELECT loan_cust_cnt();

--2. Write a procedure to list details of all customers.

DELIMITER $$
CREATE PROCEDURE list_cust_details()
BEGIN
	SELECT * FROM customer;
END$$
DELIMITER ;
--procedure call
CALL list_cust_details();

CREATE TABLE department (
	dept_id INTEGER PRIMARY KEY AUTO_INCREMENT,
	dept_name VARCHAR(30) NOT NULL UNIQUE
);

INSERT INTO DEPARTMENT (dept_name) VALUES ('IT'), ('CS'), ('EC'), ('EEE'), ('CE'),('AI'), ('ML'), ('ME'), ('FT'), ('IE');

CREATE TABLE employee (
	emp_id INTEGER PRIMARY KEY AUTO_INCREMENT,
	ename VARCHAR(30) NOT NULL,
	dob DATE,
	doj DATE,
	sal DECIMAL,
	dept_id INTEGER REFERENCES department(dept_id)
);

INSERT INTO employee (ename, dob, doj, sal, dept_id) VALUES
('Rachel', '2001-01-02', '2019-08-01', 1000,  10), 
('Zach', '2001-03-12', '2020-08-01', 2000, 1),
('Dolores', '2002-01-01', '2019-09-01', 3000, 2),
('Robert', '2001-02-01', '2019-10-01', 4000, 3), 
('Sofia', '2002-05-09', '2019-08-01', 5000, 4), 
('Mary', '2002-03-25', '2019-08-02', 6000, 10), 
('Herney', '2002-05-21', '2019-08-03', 7000, 5), 
('Ram', '2002-01-05', '2019-08-04', 5000, 6), 
('John', '2002-01-04', '2019-08-05', 6000, 7), 
('Wicham', '2001-01-04', '2020-08-01', 7000, 8),
('Collins', '2001-05-10', '2019-08-01', 2000,  9),
('Jane', '2001-01-01', '2019-08-01', 2000,  10);

--3. Write a procedure for updating the salary of employees working in the department with dept_id=10 by 20%

DELIMITER $$
CREATE PROCEDURE update_salary(dep_id INTEGER)
BEGIN
	UPDATE employee SET sal = sal + (.2*sal)
	WHERE dept_id=dep_id;
END$$
DELIMITER ;

--call procedure
CALL update_salary(10)

--4. Write a function for employee table which accepts dept_id and return the highest salary in that department. Handle the error if the dept_id does not exist or if the query return more than one maximum

DELIMITER $$
CREATE FUNCTION max_sal(dep_id INTEGER)
RETURNS DECIMAL
BEGIN
	DECLARE max_salary NUMERIC;
	DECLARE cnt INTEGER;
	DECLARE dept_exists INTEGER;
	SELECT COUNT(dept_id) FROM department WHERE dept_id=dep_id
	  INTO dept_exists;
	IF dept_exists=0 THEN
		RETURN -1;
	END IF;
	SELECT COUNT(*) FROM employee WHERE dept_id=dep_id AND sal IN
	(SELECT MAX(sal) FROM employee WHERE dept_id=dep_id) INTO cnt;
	IF cnt>1 THEN
		RETURN -2;
	END IF;
	SELECT MAX(sal) FROM employee WHERE dept_id=dep_id INTO max_salary;
	RETURN max_salary;
END$$
DELIMITER ;

SELECT max_sal(1);

--5. Write a function which accepts emp_id and returns employee experience
DELIMITER $$
CREATE FUNCTION calculate_experience(e_id INTEGER)
RETURNS VARCHAR(50)
BEGIN
	DECLARE experience VARCHAR(50) DEFAULT '';
	DECLARE join_date DATE;
	DECLARE yy INT;
	DECLARE mm INT;
	DECLARE dd INT;
	SELECT doj FROM employee WHERE emp_id=e_id INTO join_date;	
	/*  DATE_SUB() - returns the difference in number of days.
	    SELECT DATE_SUB(CURRENT_DATE(), join_date) INTO experience; 
  */	
	/*  https://www.mysqltutorial.org/mysql-timestampdiff/ */
	SELECT TIMESTAMPDIFF(YEAR, join_date, CURDATE()) INTO yy;
	SELECT TIMESTAMPDIFF(MONTH, join_date, CURDATE()) - yy*12 INTO mm;
	SELECT TIMESTAMPDIFF(DAY, join_date, CURDATE()) - yy*365 - mm*30
	INTO dd;
	SET experience = CONCAT(experience, yy, ' years, ', mm, ' months and ', dd, ' days.');
	RETURN experience;
END$$
DELIMITER ;

SELECT calculate_experience(3);
