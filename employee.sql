/*1. */
CREATE DATABASE companydb;
USE companydb;

/*2. */
DROP TABLE if EXISTS employee;

CREATE TABLE employee( ssn INT PRIMARY KEY AUTO_INCREMENT,
fname VARCHAR(30) NOT NULL, lname VARCHAR(30) , address VARCHAR(30) DEFAULT 'Tvm',
sex VARCHAR(10), salary DECIMAL DEFAULT 80000.00 ,supperssn int REFERENCES employee(ssn));

SELECT * FROM employee;

DROP TABLE if EXISTS department;
CREATE TABLE department( dno INT PRIMARY KEY AUTO_INCREMENT, dname VARCHAR(30) NOT NULL , mgrssn INT REFERENCES employee(ssn),
mgrstartdate DATE DEFAULT '2018-01-01');

ALTER TABLE employee ADD dno INT  REFERENCES department(dno);

CREATE TABLE dlocation (dno INT REFERENCES department(dno) ,dloc VARCHAR(30) DEFAULT 'tvm', PRIMARY KEY(dno,dloc));

CREATE TABLE project (pno INT PRIMARY KEY ,pname VARCHAR(30)
NOT NULL, plocation VARCHAR(30) DEFAULT 'tvm',dno int REFERENCES department(dno));

CREATE TABLE works_on (ssn INT REFERENCES employee(ssn), pno INT REFERENCES project(pno),hours INT , PRIMARY KEY (ssn,pno));

SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM dlocation;
SELECT * FROM project;
SELECT * FROM works_on;

INSERT INTO employee (fname,lname,sex,supperssn,dno) VALUES
('Elizabeth','Bennet','F',2,1),
('Jane','Bennet','F',2,2),
('Zach','Herney','M',3,3),
('Darcy','Richardson','M',3,1),
('Rahul','R','M',3,2),
('Riya','Ann','F',2,3);

SELECT * FROM employee;

INSERT INTO department(dname,mgrssn,mgrstartdate) VALUES
('IT',1,'2019-01-01'),
('CS',2,'2019-01-01'),
('CE',3,'2019-01-01');

SELECT * FROM department;
INSERT INTO dlocation (dno) VALUES
(1),(2),(3);

SELECT * FROM dlocation;

INSERT INTO project (pno,pname,dno) VALUES
(1,'Projectaro',1),
(2,'Xtro',2),
(3,'project 3',3);

SELECT * FROM project;

INSERT INTO works_on(ssn,pno,hours) VALUES
(1,1,7),(2,2,8),(3,3,8),(4,4,3);

SELECT * FROM works_on;


/*4 */
ALTER TABLE employee ADD dob DATE;
/*5 */
UPDATE employee SET dob = '1978-01-10' WHERE ssn%2=1;
UPDATE employee SET dob = '1999-01-10';
SELECT * FROM employee;

/*6th */
SELECT * FROM employee WHERE dob BETWEEN '1970-01-01' AND '1990-01-01';
/*7th */
SELECT CONCAT(fname ,' ',lname) AS name_of_emp , TIMESTAMPDIFF(YEAR,dob,CURDATE()) AS Age FROM employee;
/* 8th */
SELECT CONCAT(fname,' ' ,lname) AS name_of_emp FROM employee WHERE dno NOT LIKE (SELECT dno FROM department WHERE dname LIKE 'CS');
/*9th */
SELECT ssn FROM employee WHERE ssn IN ( SELECT DISTINCT(ssn) FROM works_on);
/*10 */
SELECT ssn FROM employee WHERE ssn NOT IN (SELECT DISTINCT(ssn) FROM works_on);
/*11 */
SELECT CONCAT(fname,' ',lname) FROM employee WHERE ssn NOT IN (SELECT DISTINCT(ssn) FROM works_on);
/*12 */
INSERT INTO project (pno,pname,dno) VALUES
(4,'project 5',1),
(5,'project 6',1),
(6,'project 7',1);
SELECT dname FROM department AS d WHERE (SELECT COUNT(pno) FROM project AS p WHERE p.dno = d.dno) > 3 ORDER BY d.dname ASC;
/*13 Display the project numbers and names of project having more than 6 hours for employee controlled by
‘IT’ department.
 */
SELECT pno,pname FROM project NATURAL JOIN works_on WHERE works_on.hours>6 AND dno LIKE (SELECT dno FROM department WHERE dname LIKE 'IT');
/*14 Display the names of employees assigned to maximum 3 projects.
*/
INSERT INTO works_on(ssn,pno,hours) VALUES
(1,6,3),(1,5,6),(1,4,8);

SELECT CONCAT(fname ,' ' , lname ) AS name_of_emp FROM employee AS e WHERE (SELECT COUNT(w.pno) FROM works_on AS w WHERE w.ssn=e.ssn)<3;
/*15 Display the names of departments along with number of projects controlled by each of them, in the
increasing order of number of projects; include departments which do not control any project.*/
SELECT * FROM project;
SELECT * FROM department;
SELECT  d.dname,COUNT(d.dno) as no_of_projects FROM department AS d NATURAL JOIN project AS p GROUP BY d.dname ORDER BY no_of_projects DESC ;
/*16 */
SELECT MAX(salary) FROM employee;
/*17 */
SELECT salary , dname FROM employee NATURAL JOIN department AS d WHERE salary = (SELECT MAX(salary) FROM employee AS e WHERE e.dno = d.dno);
/*18 */
SELECT CONCAT(fname,' ' ,lname ) FROM employee as emp1 NATURAL JOIN employee as emp2 WHERE emp1.ssn = emp2.supperssn;
/*19 */

SELECT d.dname,COUNT(distinct supperssn) FROM employee AS e NATURAL JOIN department AS d GROUP BY d.dname;
/*20 */
SELECT * FROM department ;
SELECT CONCAT(fname, ' ',lname) FROM employee AS e NATURAL JOIN department AS d WHERE e.ssn = d.mgrssn;
/*21 */
CREATE VIEW emp_details AS SELECT e.ssn,e.fname,e.lname,d.dname,p.pname FROM employee AS e NATURAL JOIN department AS d NATURAL JOIN project AS p;
SELECT * FROM emp_details;
/*22 Details of employee whose salary is more than average salary. */

SELECT CONCAT(fname,' ' ,lname) as emp_names FROM employee WHERE salary > (SELECT AVG(salary) FROM employee);
/*23 Count of employee in each department whose salary is greater than average salary of that department.*/
/*answer incompleter */
SELECT d.dname,AVG(e.salary) FROM employee AS e NATURAL JOIN department AS d GROUP BY d.dname;
/*24 */
SELECT CONCAT(e1.fname,' ',e1.lname ),e1.salary ,dname FROM employee AS e1 natural join department AS d WHERE e1.salary > (SELECT AVG(salary) FROM employee AS e2 WHERE
e1.dno = e2.dno);

/*25 */
INSERT INTO employee(ssn,fname,lname,Address,sex,salary,superssn,dno) VALUES
(8,'Raj','R','tvm','M',90000,3,2);

UPDATE employee SET dob='1960-01-01' WHERE ssn=8;
SELECT * FROM employee WHERE TIMESTAMPDIFF(YEAR,dob,CURDATE()) > 55;

/*26 */
UPDATE department SET dname = 'EC' WHERE dno = 3;
SELECT * FROM department;
SELECT * FROM works_on;
SELECT * FROM employee;
UPDATE works_on SET hours =9 WHERE ssn=2;
SELECT * FROM employee NATURAL JOIN works_on WHERE hours>8 AND dno = (SELECT dno FROM department WHERE dname ='EC');

/*27 */
SELECT * FROM (project AS p NATURAL JOIN employee AS e  )inner JOIN (department AS d natural join works_on AS w) ON d.dno =e.dno WHERE w.hours>4 GROUP BY d.dname;

/*28 */
SELECT * FROM works_on;
INSERT INTO works_on(ssn,pno,hours) VALUES
(2,2,9),(2,1,9),(2,3,5);
SELECT * FROM employee AS e WHERE (SELECT COUNT(pno) FROM works_on WHERE works_on.ssn = e.ssn) >2;

/*29 */
SELECT * FROM project;
SELECT * FROM employee;
SELECT pno FROM project NATURAL JOIN works_on  WHERE works_on.ssn = (SELECT ssn FROM employee WHERE TIMESTAMPDIFF(YEAR,dob,CURDATE())>55);

/*30 */
DELIMITER $$
CREATE PROCEDURE five_and_eight()
BEGIN

DECLARE f_name VARCHAR(30);
DECLARE l_name VARCHAR(30);
DECLARE f INT DEFAULT 0;
DECLARE c INT DEFAULT 0;
DECLARE emp_names VARCHAR(30) DEFAULT '';
DECLARE cur CURSOR FOR SELECT fname,lname FROM employee ORDER BY salary;
DECLARE CONTINUE handler FOR NOT FOUND SET f=1;

OPEN cur;
loop1 : loop
fetch cur INTO f_name,l_name ;
if f=1 then
leave loop1;
END if;
if c>5 AND c< 8 then
set emp_names = CONCAT(emp_names,f_name,' ',l_name,',');
END if ;
SET c = c+1;
END loop;
close cur;
SELECT emp_names ;
END $$
DELIMITER ;

/*31 */
SELECT * FROM employee AS e NATURAL JOIN works_on AS w NATURAL JOIN project  AS p WHERE e.dno NOT LIKE p.dno;

/*32 */
DELIMITER $$
CREATE FUNCTION product(num INT ,n INT )
RETURNS INT
BEGIN
DECLARE v INT ;
SET v = num*n;
RETURN v;
END $$
DELIMITER ;

SELECT product(2,3);

/*33 */
DELIMITER $$
CREATE FUNCTION isEven(num INT)
RETURNS VARCHAR(10)
BEGIN
if num%2=0 then
RETURN 'Even';
ELSE  
RETURN 'ODD';
END IF;
END $$
DELIMITER ;

SELECT isEven(3);

/*34 */
DELIMITER $$
CREATE FUNCTION factorial(num INT  )
RETURNS int
BEGIN
DECLARE v INT DEFAULT 1;
while num >0 do
set v= v*num;
set num=num-1;
END while;
RETURN v;
END $$
DELIMITER ;

SELECT factorial(4);

/*35 */

DELIMITER $$
CREATE FUNCTION emp_name()
RETURNS VARCHAR(3000)
BEGIN
DECLARE f INT DEFAULT 0;
DECLARE emp_names VARCHAR(3000) DEFAULT '' ;
DECLARE f_names VARCHAR(30);
DECLARE l_name VARCHAR(30);
DECLARE cur CURSOR FOR SELECT fname,lname FROM employee;
DECLARE CONTINUE handler FOR NOT FOUND SET  f =1;
OPEN cur;
loop1 : LOOP
BEGIN
fetch cur INTO f_names ,l_name;
if f=1 then
leave loop1;
END if ;
set emp_names = CONCAT(emp_names,' ',f_names,' ',l_name);
END ;
END loop;
RETURN emp_names;
close cur;
END $$
DELIMITER ;

SELECT emp_name();

/*36 */
DELIMITER $$
CREATE PROCEDURE empInDept(d_id INT)
BEGIN
SELECT * FROM employee WHERE dno = d_id;
END $$
DELIMITER ;

CALL empInDept(1);

/*37 */
DELIMITER $$
CREATE PROCEDURE empInDept2(d_name VARCHAR(30))
BEGIN
SELECT * FROM employee NATURAL JOIN department WHERE department.dname = d_name;
END $$
DELIMITER ;

CALL empInDept2('IT');
/*38 */
DELIMITER $$
CREATE PROCEDURE empProject(dept_name VARCHAR(30))
BEGIN
SELECT fname ,pname FROM employee NATURAL JOIN department NATURAL JOIN project WHERE dname LIKE dept_name;
END $$
DELIMITER ;

CALL empProject('IT');

/*39  . Write a procedure to list the name of employees who are drawing 5th highest salary to 8th highest salary*/

/*40 Write a procedure to list name of employees having length of fname = 5. */
DELIMITER $$
CREATE PROCEDURE empWithFnameLengthFive()
BEGIN
SELECT fname , LENGTH(fname ) FROM employee WHERE LENGTH(fname) = 5;
END $$
DELIMITER ;

CALL empWithFnameLengthFive();

/*41 . Write a function to find the count of employees in a given department (using dname). */
DROP TABLE  empCntlnDept;
DELIMITER $$
CREATE FUNCTION empCntlnDept(dept_name VARCHAR(30))
RETURNS INT
BEGIN
DECLARE p INT;
SELECT COUNT(ssn) FROM employee WHERE dno = (SELECT dno FROM department WHERE dname LIKE dept_name) INTO p ;
RETURN p;

END $$
DELIMITER ;

SELECT empCntlnDept('IT');

/*42 */
DROP FUNCTION if EXISTS projectAssignedtoEmp;
DELIMITER $$
CREATE FUNCTION projectAssignedtoEmp(e_ssn INT )
RETURNS VARCHAR(300)
BEGIN
DECLARE projects VARCHAR(300) DEFAULT '' ;
DECLARE f INT DEFAULT 0;
DECLARE pn INT;
DECLARE p_name VARCHAR(30);
DECLARE cur CURSOR FOR SELECT pno  FROM works_on WHERE ssn = e_ssn;
DECLARE CONTINUE handler FOR NOT FOUND SET f=1;
OPEN cur;
loop1 : loop
BEGIN
fetch cur INTO pn;
if f=1 then
leave loop1;
END if ;
SELECT pname FROM project WHERE pno = pn INTO p_name ;
SET projects = CONCAT(projects,',',p_name);
END ;
END loop;
close cur;
RETURN projects;
END $$
DELIMITER ;

SELECT projectAssignedtoEmp(1);

/*43
Write a procedure to insert values in department table. It should handle the exception when there is
violation of primary key constraint.*/
DROP PROCEDURE  insertDepartment;
DELIMITER $$
CREATE PROCEDURE insertDepartment(d_no INT ,d_name VARCHAR(30))
BEGIN
DECLARE f INT  DEFAULT 0;
DECLARE CONTINUE  handler FOR 1062 begin
SELECT ('Duplicate department ID ');
END ;
INSERT INTO department (dno,dname ) VALUES (d_no,d_name);
END $$
DELIMITER ;

CALL insertDepartment(1,'m');

/*44 */
CREATE TABLE works_on_backup (ssn INT , pno INT ,hours INT );
DELIMITER $$
CREATE TRIGGER tr_works_on_backup
BEFORE INSERT ON works_on FOR EACH ROW
BEGIN
INSERT INTO works_on_backup(ssn,pno,hours) values
(NEW.ssn,NEW.pno,NEW.hours);
END $$
DELIMITER ;

INSERT INTO works_on(ssn,pno,hours) VALUES
(2,2,8);
SELECT * FROM works_on_backup;


/*45 */
DELIMITER $$
CREATE TRIGGER tr_check_salary_emp
BEFORE INSERT ON employee FOR EACH ROW
BEGIN
if NEW.salary <8000 then
signal SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary < 8000';
END if ;
END $$
DELIMITER ;
INSERT INTO employee(ssn,fname,salary) VALUES
(9,'john',399);

/*46 */
SELECT * FROM project ;
DELIMITER $$
CREATE TRIGGER  tr_disallow_mapped_department_deletion
BEFORE DELETE ON department FOR EACH ROW
BEGIN
if OLD.dno IN (SELECT dno FROM employee) then
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'cannot delete';
ELSEIF OLD.dno IN (SELECT dno FROM project) then
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'cannot delete';
END if ;
END $$
DELIMITER ;

DELETE FROM department WHERE dno =1;

/*47 */
DELIMITER $$
CREATE TRIGGER tr_check_updated_salary
BEFORE UPDATE ON employee FOR EACH ROW
BEGIN
if OLD.salary >NEW.salary then
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' cannot update';
END if ;
END $$

INSERT INTO employee(ssn,fname,salary) VALUES
(1,'afb',300);
DELIMITER ;
