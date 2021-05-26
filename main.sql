
--1. Create Tables
CREATE TABLE physician (phy_id INTEGER PRIMARY KEY,phy_fname VARCHAR(50),phy_lname VARCHAR(50),address VARCHAR(100),salary DECIMAL(10,2),designation VARCHAR(50),field_of_spec VARCHAR(50),year_of_spec DATE,CHECK (salary>=0));
CREATE TABLE nurse(nurse_id INTEGER PRIMARY KEY,nurse_name VARCHAR(50) NOT NULL,shift INTEGER CHECK (shift BETWEEN 1 AND 3));
 CREATE TABLE ward(ward_no INTEGER PRIMARY KEY,ward_name VARCHAR(50) NOT NULL,no_of_beds INTEGER,telephone INTEGER , nurse_id INTEGER, FOREIGN KEY (nurse_id) REFERENCES nurse(nurse_id),CHECK (no_of_beds >0));
 CREATE TABLE patient (pat_no INTEGER PRIMARY KEY AUTOINCREMENT  ,pat_name VARCHAR(50) NOT NULL,phy_id INTEGER ,ward_no INTEGER ,date_of_admit DATE ,FOREIGN KEY (ward_no) REFERENCES ward(ward_no),FOREIGN KEY (phy_id) REFERENCES physician(phy_id));

--2. Insert values into table
 INSERT INTO physician (phy_id,phy_fname,phy_lname,address,salary,designation,field_of_spec,year_of_spec) VALUES 
 (10001,'Wilman','K T','305 - 14th Ave. S. Suite 3B',100000.00,'MD','Neurologist','2005-11-30'),(10002,'John','Richardson','Keskuskatu 45',50000.00,'MD','General Surgeon','2016-10-31'),(10024,'Jacob','John','305 - 14th Ave. S. Suite 4B',48000.00,'DO','Neurologist','2018-02-24'),(10052,'Pramod','R M','305 - 14th Ave. S. Suite 5D',40000.00,'MD','General Surgeon','2019-12-31'),(10034,'Marty','Roy','305 - 14th Ave. S. Suite 3B',60000.00,'DO','Neurologist','2011-10-21'),(10057,'Erick','George','305 - 14th Ave. S. Suite 1B',61000.00,'MD','General Surgeon','2011-10-21');


INSERT INTO nurse (nurse_id,nurse_name,shift) VALUES
(12001,'Sara',1),(12320,'David',2),(12535,'Lang',2),(12630,'Roy',3),(12934,'Adam',1),(12536,'Lovey',3),(12921,'Chekov',2),(12634,'Tokiyo',1),(12834,'Rio',2),(12734,'Moscow',1),(12312,'Macarty',1),(12364,'Guptil',2),(12758,'Smith',3);

INSERT INTO ward (ward_no,ward_name,no_of_beds,telephone,nurse_id) VALUES (1,'Emergency Ward',2,235125,12834),(2,'ICU',2,231124,12921),(3,'ICCU',2,231125,12630),(4,'Morgue',100,231128,12312),(5,'General Ward',180,231129,12001);

INSERT INTO patient (pat_name,phy_id,ward_no,date_of_admit) VALUES 
('Mohan',10057,2,2021-02-25),('Kumar',10052,1,2021-03-02),('Jason',10052,3,2021-03-03),('Normann',10034,2,2021-03-13),('Chris',10024,5,2021-03-23),('Jay',10002,5,2021-03-24),('Ray',10001,4,2021-04-02);

.headers on
.mode column
--3.Display the patient number and ward number of all patients.

SELECT pat_no,ward_no FROM patient;
--4.Display the name of nurse and the shift he/she is working.
SELECT  nurse_name,shift FROM nurse;
--5.Display the name of patients and their physician only for patients assigned to any ward
SELECT pat_name,phy_fname FROM patient NATURAL JOIN physician;
--6.Display the details of all physicians who earn more than 50,000.

SELECT phy_fname,phy_lname,salary FROM physician WHERE salary>50000;
--7.Display the unique listing of areas that the physicians are specialized in.

SELECT * FROM physician WHERE field_of_spec='Neurologist';

--8.Display the details of patients whose names have letter 'N' in them and are being treated by physician Pramod.

SELECT pat_name FROM patient NATURAL JOIN physician WHERE pat_name LIKE '%n%' AND (phy_fname = 'Pramod' or phy_lname='Pramod');

--9. Display the physician's names and their monthly salary.

SELECT phy_fname || ' ' || phy_lname AS Name, salary FROM physician;

--10. Display the names of physicians whose first name is made up of 5 letters.

SELECT phy_fname FROM physician WHERE phy_fname like '_____';

--11. Display the names of department that physicians belong to that do not start with letter 'P'.
SELECT DISTINCT designation AS department FROM physician
WHERE  designation NOT LIKE (SELECT designation FROM physician WHERE phy_fname NOT LIKE 'P%');

--12. Display the name of ward that have more than 22 beds.

SELECT ward_name ,no_of_beds FROM ward WHERE no_of_beds>22;

--13. Display the name of all patients who are admitted, their physician's name and ward name.
SELECT pat_name,phy_fname,ward_name FROM (SELECT pat_name,phy_fname,ward_no,phy_id FROM patient NATURAL JOIN physician ) NATURAL JOIN (SELECT pat_name,phy_id,ward_name,ward_no FROM patient NATURAL JOIN ward);
