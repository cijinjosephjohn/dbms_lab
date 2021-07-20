--1. Create tables and insert values into the tables
CREATE TABLE branch (branch_id INT PRIMARY KEY,branch_name VARCHAR(50) NOT NULL,city VARCHAR(50) DEFAULT 'Trivandrum');

CREATE TABLE customer (cust_id INT PRIMARY KEY,cust_name VARCHAR(50) NOT NULL,city VARCHAR(50));

CREATE TABLE deposit(acc_no INT PRIMARY KEY,cust_id INT,branch_id INT,amount DECIMAL(14,2),date DATE,FOREIGN KEY (cust_id) REFERENCES customer(cust_id),FOREIGN KEY (branch_id) REFERENCES branch(branch_id),CHECK (amount>=1000) );

CREATE TABLE borrow(loan_no INT PRIMARY KEY,cust_id INT,branch_id INT ,amount DECIMAL(14,2),date DATE,FOREIGN KEY (cust_id) REFERENCES customer(cust_id),FOREIGN KEY (branch_id) REFERENCES branch(branch_id),CHECK (amount>=1000));

INSERT INTO branch(branch_id,branch_name,city) VALUES 
(4,'Fort','Bombay'),(294,'Crowford','Bombay'),(34,'Brighton','Brooklyn'),(352,'Downtown','Brooklyn'),(362,'Sampada','Nandgaon'),(62,'North Town','Bangalore'),(621,'Pownal','Nagpur'),(734,'Round Hill','Nagpur'),(834,'Seedwood','Nagpur');

INSERT INTO customer(cust_id,cust_name,city) VALUES (10034,'Mic Ronald','Brooklyn'),(10052,'Sunil Ray','Nandgaon'),(10053,'George David','Bangalore'),(10012,'David John','Nagpur'),(10021,'Sony Issac','Nagpur'),(10013,'Issac Collins','Bombay'),(10064,'Collins Gray','Brooklyn'),(10074,'Jennifer May','Bangalore'),(10031,'Mary Jane','Nagpur'),(10083,'Peter Hant','Nandgaon'),(10099, 'Gracy Lark','Bombay'),(10098,'Elizabeth Bennt','Bombay'),(10089,'Darcy Drack','Bangalore'),(10097,'Albert Bennt','Nagpur'),(10079,'Lizzy Richard','Nagpur'),(10095,'Rossy John','Nandgaon');

INSERT INTO deposit(acc_no,cust_id,branch_id,amount,date) VALUES (124001,10098,294,10000.00,'2021-01-02'),(124032,10013,4,50000.00,'2020-11-12'),(124030,10083,362,60000.00,'2014-11-12'),(124091,10021,834,30000.00,'2020-11-12'),(124009,10053,62,90000.00,'2021-02-02'),(124035,10012,734,80000.00,'2020-11-12'),(124058,10074,62,83000.00,'2014-08-12'),(124086,10052,362,30000.00,'2020-11-12'),(124010,10097,621,20000.00,'2014-09-02');
INSERT INTO borrow (loan_no,cust_id,branch_id,amount,date) VALUES (142002,10064,34,20034.00,'2020-11-12'),(142024,10052,362,30300.00,'2020-11-12'),(142059,10099,4,80005.00,'2020-11-12'),(142094,10034,352,12030.00,'2020-11-12'),(142049,10089,62,9503.00,'2020-11-12'),(142093,10097,734,15000.00,'2020-11-12'),(142039,10079,621,60000.00,'2020-11-12'),(142099,10095,362,130000.00,'2020-11-12'),(142010,10012,834,30000.00,'2020-01-02');

.headers on
.mode column
--2.Display the details of all customers having a loanamount greater than 50000
SELECT cust_id,cust_name,amount FROM borrow NATURAL JOIN customer WHERE amount>=50000;

--3.Display the names of all borrowers and their corresponding loan numbers
SELECT cust_name,loan_no FROM borrow NATURAL JOIN customer;

--4. Display the customer name and branch name of the customers who have made a deposit on or before 1/2/2021
SELECT('mARK');
SELECT cust_name,branch_name,date FROM (SELECT cust_name,branch_id,date FROM customer NATURAL JOIN deposit) NATURAL JOIN branch WHERE date<='2021-02-01' ;

--5.Display the customer name , date they have deposited and the amount 
SELECT cust_name,amount , STRFTIME('%m-%d-%Y', date) AS date  FROM customer NATURAL JOIN deposit;

--6.Display the names of all customers who have made deposits between 31 oct 2020 and 31 mar 2021

SELECT cust_name FROM customer NATURAL JOIN deposit WHERE
date BETWEEN '2020-10-31' AND '2021-03-31';

--7. Display the  count of customers who have taken loan and belonging to Nagpur

SELECT COUNT(cust_id) FROM borrow NATURAL JOIN customer WHERE city LIKE 'Nagpur' ;

--8.Display the average loan amount .Round the result to two decimal places

SELECT  ROUND (AVG(amount),2) AS average FROM borrow;

--9.Display the customers where name starts with 's' and the branch in which they have deposited Branch name should also start with 's'

SELECT cust_name,branch_name FROM customer NATURAL JOIN deposit NATURAL JOIN branch WHERE cust_name LIKE 'S%' AND branch_name LIKE 's%';

--10.Display the customers having a loan amount between 5000 and 15000 in discending order of their loan amounts

SELECT cust_name FROM borrow NATURAL JOIN customer  WHERE amount BETWEEN 5000 AND 15000 ORDER BY amount DESC;
--11.Display the customers having a loan amount between 5000 and 15000 in alphabetical order
SELECT('MARK');
SELECT cust_name, amount FROM borrow NATURAL JOIN customer  WHERE amount BETWEEN 5000 AND 15000 ORDER BY cust_name ;

--12.List the total  loan which is given from each branch
SELECT branch_name , SUM (amount) AS total_amount FROM branch AS b INNER JOIN borrow AS bo ON b.branch_id=bo.branch_id GROUP BY branch_name;

--13.List the total deposit amount branch-wise
SELECT branch_name, SUM (amount) AS total FROM branch AS B INNER JOIN deposit AS d ON b.branch_id=d.branch_id GROUP BY branch_name;

--14. List the total loan from any branch.

SELECT branch_name, SUM (amount) AS total_amount FROM branch AS b INNER JOIN borrow AS bo ON b.branch_id = bo.branch_id WHERE b.branch_name  LIKE 'Sampada';

--15. List the total deposit of customers having an account which was started after 1 Jan 2015
SELECT (' MARK');
SELECT cust_name , SUM(amount) AS total_amount FROM deposit NATURAL JOIN customer WHERE date>='2015-01-01' GROUP BY cust_name;

--16. List total deposit of customers living in Bangalore.

SELECT SUM(amount) as total FROM deposit AS d INNER JOIN customer AS c ON d.cust_id = c.cust_id WHERE c.city LIKE 'Bangalore';

--17. Find the biggest deposit amount of the customers living in Bombay.

SELECT c.cust_id,c.cust_name,MAX(d.amount) FROM customer AS c INNER JOIN deposit AS d ON c.cust_id = d.cust_id WHERE c.city LIKE 'Bombay' ;

--18. Find the total deposit of customers living in the same city that Sunil is also living.

SELECT SUM(amount) AS total_deposit FROM deposit AS d INNER JOIN customer AS c ON c.cust_id = d.cust_id WHERE city LIKE (SELECT city FROM customer WHERE cust_name LIKE 'Sunil%'); 

--19. Count the total number of customers in each city

SELECT city,COUNT(cust_id) AS no_of_customers FROM customer GROUP BY city;

--20. List the name and deposit amount of all depositors and order them by the branch city.


SELECT b.city AS branch_city, c.cust_name,d.amount FROM customer AS c INNER JOIN deposit AS d ON c.cust_id =d.cust_id INNER JOIN branch AS b ON b.branch_id = d.branch_id ORDER BY b.city; 

--21. List the total deposit per branch by customers after 1 Jan 2015

SELECT b.branch_name ,SUM(d.amount) AS total_amt FROM branch AS b INNER JOIN deposit AS d ON b.branch_id = d.branch_id  WHERE date > '2015-01-01' GROUP BY b.branch_name;

--22. Give the branch-wise loan of customers living in Nagpur.

SELECT b.branch_name , SUM(bo.amount) FROM branch AS b INNER JOIN borrow AS bo ON b.branch_id = bo.branch_id WHERE b.city ='Nagpur' GROUP BY b.branch_name;

--23. Count the number of customers in each branch.
SELECT b.branch_name, COUNT(d.cust_id) + COUNT(bo.cust_id) AS total_cust FROM branch AS b LEFT JOIN deposit AS d ON b.branch_id = d.branch_id LEFT JOIN borrow AS bo ON bo.branch_id = b.branch_id GROUP BY branch_name; 

--24. Find the maximum loan of each branch.
SELECT b.branch_name , MAX(bo.amount) FROM branch AS b INNER JOIN borrow AS bo ON b.branch_id = bo.branch_id GROUP BY b.branch_name;

--25. Find the number of customers who are depositors as well as borrowers.

  SELECT COUNT(cust_id) AS count_1 FROM customer  WHERE cust_id IN 
    (SELECT cust_id FROM deposit INTERSECT SELECT cust_id FROM borrow);
