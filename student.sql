CREATE TABLE class(class_id INTEGER PRIMARY KEY AUTOINCREMENT,class_name VARCHAR(20) NOT NULL,division VARCHAR(10),st_cnt INTEGER);

CREATE TABLE student(st_id INTEGER PRIMARY KEY AUTOINCREMENT,st_fname VARCHAR(50) NOT NULL , st_lname VARCHAR(50),st_address VARCHAR(50),phone INTEGER,email VARCHAR(50),class_id INTEGER,FOREIGN KEY (class_id) REFERENCES class(class_id));

CREATE TABLE teacher(tr_id INTEGER PRIMARY KEY AUTOINCREMENT, tr_fname VARCHAR(50) NOT NULL,tr_lname VARCHAR(50),phone INTEGER ,subject VARCHAR(30));

CREATE TABLE student_class(st_id INTEGER,class_id INTEGER,tr_id INTEGER ,PRIMARY KEY (st_id,class_id,tr_id),FOREIGN KEY (st_id) REFERENCES student(st_id),FOREIGN KEY (class_id) REFERENCES class(class_id) , FOREIGN KEY (tr_id) REFERENCES teacher(tr_id));

INSERT INTO class(class_name,division,st_cnt) VALUES ('1','A',60),('2','A',34),('2','B',39),('10','A',51),('4','A',34),('4','B',34),('4','C',34),('9','A',60);

INSERT INTO student(st_fname,st_lname,st_address,phone,email,class_id) VALUES ('John','Samuel','15 the Ave 3B',8934252701,'johnsamuel@gmail.com',1),('Ron','Sam','15 the Ave 3B',8934252702,'ronsam@gmail.com',2),('Ray','S John','15 the Ave 3B',8934252703,'johnsamuel@gmail.com',3),('Micheal','Jacob','15 the Ave 3B',8934252705,'johnsamuel@gmail.com',4),('Sam','Stephan','15 the Ave 3B',8934252704,'johnsamuel@gmail.com',5),('Sally','Lane','15 the Ave 3B',8934252706,'johnsamuel@gmail.com',6),('Elizabeth','Bennet','15 the Ave 3B',8934252707,'johnsamuel@gmail.com',7),('Jane','Bennet','15 the Ave 3B',8934252708,'johnsamuel@gmail.com',8),('John','Sam','15 the Ave 3B',8934252709,'johnsamuel@gmail.com',8),('John','Son','15 the Ave 3B',8934252710,'johnsamuel@gmail.com',7),('Gray','Richard','15 the Ave 3B',8934252711,'johnsamuel@gmail.com',6),('Elizabeth','Samuel','15 the Ave 3B',8934252701,'johnsamuel@gmail.com',5),('Wilbert','Samuel','15 the Ave 3B',8934252701,'johnsamuel@gmail.com',4),('Wicham','Samuel','15 the Ave 3B',8934252701,'johnsamuel@gmail.com',3),('Wolff','Samuel','15 the Ave 3B',8934252701,'johnsamuel@gmail.com',2),('Christian','Wolff','15 the Ave 3B',8934252701,'johnsamuel@gmail.com',1);

INSERT INTO teacher(tr_fname,tr_lname,phone,subject) VALUES 
('Wicham','David',83839291,'physics'),('Jaya','Collins',83839292,'Chemistry'),('Lizzy','Bennet',83839293,'English'),('Grey','Darcy',83839294,'English'),('Lina','Killic',83839295,'Astrophysics'),('John','Austin',83839296,'English'),('Nicolas','Holmes',83839297,'Maths'),('Microft','Watson',83839298,'English');

INSERT INTO student_class (st_id,tr_id,class_id) VALUES
(1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,1,8),(10,2,7),(11,3,6),(13,4,5),(14,5,4),(15,6,3),(16,7,2),(12,8,1); 

.headers on
.mode column
--2. List all classes where strength is greater than 50

SELECT class_name,division FROM class WHERE st_cnt>=50;

--3. List the name of students of Lina teacher.

SELECT s.st_fname,s.st_lname FROM student AS s INNER JOIN student_class AS sc ON s.st_id=sc.st_id  WHERE tr_id = (SELECT tr_id FROM student_class NATURAL JOIN teacher WHERE tr_fname LIKE 'Lina');

--4. List the names of all the English teachers.

SELECT tr_fname,tr_lname FROM teacher WHERE subject like 'English';

--5. List the names of teachers who teach standard 9
SELECT t.tr_fname,t.tr_lname FROM teacher AS t INNER JOIN student_class AS sc ON t.tr_id=sc.tr_id WHERE sc.class_id = (SELECT class_id FROM class WHERE class_name like '9');

--6. Find out all the classes that are taught by Jaya teacher

SELECT c.class_name,c.division FROM class AS c INNER JOIN student_class AS sc ON c.class_id = sc.class_id WHERE sc.tr_id = (SELECT tr_id FROM teacher WHERE tr_fname like 'Jaya');

--7. List the names and details of all students in standard 10
SELECT s.st_id,s.st_fname,s.st_lname,s.st_address,s.phone,s.email FROM student AS s INNER JOIN class AS c ON s.class_id=c.class_id WHERE c.class_name like '10';

select ('sdf');
--8. List all the students whose first name is the same along with their student id.
SELECT DISTINCT  s.st_fname,s.st_lname,s.st_id FROM student AS s CROSS JOIN student AS sc WHERE s.st_fname=sc.st_fname AND s.st_id!=sc.st_id ORDER BY s.st_fname ;
---9. List the name of students whose name starts with 's'.
SELECT st_fname,st_lname FROM student WHERE st_fname like 's%';

--10. Create a view named student_names and display the student’s first name and last name.
CREATE VIEW student_names AS SELECT st_fname,st_lname FROM student;
SELECT * FROM student_names;

--11. Create a view named teacher_names and display the teacher’s first name and last name.

CREATE VIEW teacher_names AS SELECT tr_fname,tr_lname FROM teacher;
SELECT * FROM teacher_names;

--12. Create a view named student_teachers and display the student’s first name, last name, teacher’sfirst name, last name and subject (that is student’s name, subjects the student is studying and thename of teacher taking that subject).

CREATE VIEW student_teachers AS SELECT s.st_fname,st_lname,t.tr_fname,t.tr_lname,subject FROM student AS s INNER JOIN student_class AS sc ON s.st_id=sc.st_id INNER JOIN teacher AS t ON sc.tr_id=t.tr_id ORDER BY t.subject;

SELECT * FROM student_teachers;
