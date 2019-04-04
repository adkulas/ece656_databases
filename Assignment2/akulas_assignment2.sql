DROP DATABASE IF EXISTS `assignment2`;
CREATE DATABASE IF NOT EXISTS `assignment2` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `assignment2`;


SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- ----------------------------
--  Table structure for `Instructor`
-- ----------------------------
DROP TABLE IF EXISTS `Instructor`;
CREATE TABLE `Instructor` (
  `instID` int(11) DEFAULT NULL,
  `instName` char(10) DEFAULT NULL,
  `deptID` char(4) DEFAULT NULL,
  `sessional` boolean
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Course`
-- ----------------------------
DROP TABLE IF EXISTS `Course`;
CREATE TABLE `Course` (
  `courseID` char(8) DEFAULT NULL,
  `courseName` varchar(50) DEFAULT NULL,
  `deptID` char(4) DEFAULT NULL,
  `prereqID` char(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Offering`
-- ----------------------------
DROP TABLE IF EXISTS `Offering`;
CREATE TABLE `Offering` (
  `courseID` char(8) DEFAULT NULL,
  `section` int(11) DEFAULT NULL,
  `termCode` decimal(4,0) DEFAULT NULL,
  `roomID` char(8) DEFAULT NULL,
  `instID` int(11) DEFAULT NULL,
  `enrollment` int(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Classroom`
-- ----------------------------
DROP TABLE IF EXISTS `Classroom`;
CREATE TABLE `Classroom` (
  `roomID` char(8) DEFAULT NULL,
  `Building` char(4) DEFAULT NULL,
  `Room` decimal(4,0) DEFAULT NULL,
  `Capacity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
--  Table structure for `Department`
-- ----------------------------
DROP TABLE IF EXISTS `Department`;
CREATE TABLE `Department` (
  `deptID` char(8) DEFAULT NULL,
  `deptName` varchar(50) DEFAULT NULL,
  `faculty` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- ----------------------------
--  Records of `Instructor`
-- ----------------------------
INSERT INTO Instructor(instID, instName, deptID, sessional) VALUES(1, 'Nelson', 'ECE', 0);
INSERT INTO Instructor(instID, instName, deptID, sessional) VALUES(3, 'Jimbo', 'ECE', 0);
INSERT INTO Instructor(instID, instName, deptID, sessional) VALUES(4, 'Moe', 'CS', 1);
INSERT INTO Instructor(instID, instName, deptID, sessional) VALUES(5, 'Lenny', 'CS', 0);

-- ----------------------------
--  Records of `Course`
-- ----------------------------
INSERT INTO Course(courseID, courseName, deptID, prereqID) VALUES('ECE365', 'Database Systems', 'ECE', 'ECE250');
INSERT INTO Course(courseID, courseName, deptID, prereqID) VALUES('ECE358', 'Computer Networks', 'ECE', 'ECE222');
INSERT INTO Course(courseID, courseName, deptID, prereqID) VALUES('ECE390', 'Engineering Design', 'ECE', 'ECE290');
INSERT INTO Course(courseID, courseName, deptID, prereqID) VALUES('MATH117', 'Calculus 1', 'MATH', NULL);

-- ----------------------------
--  Records of `Offering`
-- ----------------------------
INSERT INTO Offering(courseID, section, termCode, roomID, instID, enrollment) VALUES('ECE356', 1, 1191, 'E74417', 1, 64);
INSERT INTO Offering(courseID, section, termCode, roomID, instID, enrollment) VALUES('ECE356', 2, 1191, 'E74417', 3, 123);
INSERT INTO Offering(courseID, section, termCode, roomID, instID, enrollment) VALUES('ECE358', 2, 1191, 'E74417', 1, 123);
INSERT INTO Offering(courseID, section, termCode, roomID, instID, enrollment) VALUES('ECE390', 1, 1191, 'E74053', 1, 102);
INSERT INTO Offering(courseID, section, termCode, roomID, instID, enrollment) VALUES('MATH117', 1, 1189, 'RCH111', 5, 134);

-- ----------------------------
--  Records of `Classroom`
-- ----------------------------
INSERT INTO Classroom(roomID, Building, Room, Capacity) VALUES('E74417', 'E7', 4417, 138);
INSERT INTO Classroom(roomID, Building, Room, Capacity) VALUES('E74053', 'E7', 4053, 144);
INSERT INTO Classroom(roomID, Building, Room, Capacity) VALUES('RCH111', 'RCH', 111, 91);
INSERT INTO Classroom(roomID, Building, Room, Capacity) VALUES('RCH101', 'RCH', 101, 250);

-- ----------------------------
--  Records of `Department`
-- ----------------------------
INSERT INTO Department(deptID, deptName, faculty) VALUES('ECE', 'Electrical and Computer Engineering', 'Engineering');
INSERT INTO Department(deptID, deptName, faculty) VALUES('CS', 'Computer Science', 'Math');
INSERT INTO Department(deptID, deptName, faculty) VALUES('MATH', 'Math', 'Math');
INSERT INTO Department(deptID, deptName, faculty) VALUES('C&O', 'Combinatorics and Optimization', 'Math');




SET FOREIGN_KEY_CHECKS = 1;








-- QUESTION 1

-- (a) What are plausible Primary Keys on each of the five relations?

-- for Instructor, instID could be a valid primary key
ALTER TABLE Instructor
ADD PRIMARY KEY (instID);

-- for Course, courseID could be a valid primary key
ALTER TABLE Course
ADD PRIMARY KEY (courseID);

-- for Offering couseID,section,termcode could be a valid primary key
ALTER TABLE Offering
ADD PRIMARY KEY (courseID,section,termCode);

-- for Classroom roomID could be a valid primary key
ALTER TABLE Classroom
ADD PRIMARY KEY (roomID);

-- for Department deptID could be a valid primary key
ALTER TABLE Department
ADD PRIMARY KEY (deptID);

-- (b) What are plausible Foreign Keys for the five relations?

ALTER TABLE Instructor
ADD FOREIGN KEY (deptID) REFERENCES Department(deptID);

ALTER TABLE Course
ADD FOREIGN KEY (deptID) REFERENCES Department(deptID);



-- This foreign key will create a hierarchy relationship for the table. This cannot be applied 
-- because the table is incomplete. The prereq courses do not appear as courses themselves

-- NOTE: will fail.
-- ALTER TABLE Course
-- ADD FOREIGN KEY (prereqID) REFERENCES Course(courseID);

ALTER TABLE Offering
ADD FOREIGN KEY (roomID) REFERENCES Classroom(roomID);

ALTER TABLE Offering
ADD FOREIGN KEY (instID) REFERENCES Instructor(instID);




-- (c) What additional constraints, if any, should be added?

-- We may want to place contraints on the Capacity size in the Classroom table. This could be done to 
-- avoid any erroneous data entry when adding new classrooms.

-- We can also add a contraint to the Offering table where enrollment must be less than or equal to the 
-- Classroom(Capacity). Depending on the business logic this could cause problems if it is desirable to have
-- enrollment higher than classroom capacity anticipating a fraction of the students will drop the course.

-- Main Constraints to consider are:
--  - UNIQUE
--  - CHECK
--  - DEFAULT

-- The unique contraints are mainly dealt with by the primary key contraints.
-- None of the fields warrant the use of a Default value contraint.
-- The check constraints could be applied to the fields mentioned above
-- As mentioned in this SO post https://stackoverflow.com/questions/7522026/how-do-i-add-a-check-constraint-to-a-table
-- CHECK constraints are not supported in MYSQL so an alternative if desired would be to 
-- create a view with check option.




/*
(d) Knowing that each department is part of a faculty (deptID → faculty), that courses can have more than
one prerequisite, and desiring to be able to do queries based on term (Winter, Spring, Fall) without regard
to the particular year (e.g., what courses are offered in the fall term?), what modifications to the schema,
if any, are needed to ensure that it is either 3NF or BCNF (your choice)? If there are any new of changed
relations, identify them, including any changes or adjustments to primary keys and/or foreign keys, or any
other constraints. Explain your reasoning.
*/


-- PROBLEM 1: How to define multiple prerequisites for courses.
-- Currently there is a course table with column prereqID. The issue is if we try to add additional prerequisites
-- we will break the first normal form (1NF) because CourseID will no longer be unique and break the primary key constraint

-- A possible solution is to create a new table Prerequisite with the relation 
-- Prerequisite (courseID, prereqID)

-- and alter the table Courses to have the representation:
-- Courses (courseID, courseName, deptID)

-- ORIGINAL Course TABLE
-- +----------+--------------------+--------+----------+
-- | courseID | courseName         | deptID | prereqID |
-- +----------+--------------------+--------+----------+
-- | ECE358   | Computer Networks  | ECE    | ECE250   |
-- | ECE365   | Database Systems   | ECE    | ECE222   |
-- | ECE390   | Engineering Design | ECE    | ECE290   |
-- | MATH117  | Calculus 1         | MATH   | NULL     |
-- +----------+--------------------+--------+----------+


SET FOREIGN_KEY_CHECKS = 0;
-- ----------------------------
--  Table structure for `Prerequisite`
-- ----------------------------
SELECT "Creating prerequisite Table...";
DROP TABLE IF EXISTS `Prerequisite`;
CREATE TABLE `Prerequisite` (
  `ID` int(11) NOT NULL AUTO_INCREMENT, 
  `courseID` char(8) DEFAULT NULL,
  `prereqID` char(8) DEFAULT NULL,
  PRIMARY KEY(ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


SELECT "Inserting values into Prerequisite...";
INSERT INTO Prerequisite (courseID, prereqID)
  SELECT courseID, prereqID FROM Course;

SELECT "Alter original Course table...";
ALTER TABLE Course DROP COLUMN PrereqID;


SELECT "Add Foreign Keys and Constraints";
ALTER TABLE Prerequisite
ADD FOREIGN KEY (courseID) REFERENCES Course(CourseID),
ADD UNIQUE (courseID, prereqID);

SET FOREIGN_KEY_CHECKS = 1;


-- Course and Prerequisite tables after alterations
-- +----------+--------------------+--------+
-- | courseID | courseName         | deptID |
-- +----------+--------------------+--------+
-- | ECE358   | Computer Networks  | ECE    |
-- | ECE365   | Database Systems   | ECE    |
-- | ECE390   | Engineering Design | ECE    |
-- | MATH117  | Calculus 1         | MATH   |
-- +----------+--------------------+--------+
-- +------------+-------------+------+-----+---------+-------+
-- | Field      | Type        | Null | Key | Default | Extra |
-- +------------+-------------+------+-----+---------+-------+
-- | courseID   | char(8)     | NO   | PRI | NULL    |       |
-- | courseName | varchar(50) | YES  |     | NULL    |       |
-- | deptID     | char(4)     | YES  | MUL | NULL    |       |
-- +------------+-------------+------+-----+---------+-------+
-- +----+----------+----------+
-- | ID | courseID | prereqID |
-- +----+----------+----------+
-- |  1 | ECE358   | ECE222   |
-- |  2 | ECE365   | ECE250   |
-- |  3 | ECE390   | ECE290   |
-- |  4 | MATH117  | NULL     |
-- +----+----------+----------+
-- +----------+---------+------+-----+---------+----------------+
-- | Field    | Type    | Null | Key | Default | Extra          |
-- +----------+---------+------+-----+---------+----------------+
-- | ID       | int(11) | NO   | PRI | NULL    | auto_increment |
-- | courseID | char(8) | YES  | MUL | NULL    |                |
-- | prereqID | char(8) | YES  |     | NULL    |                |
-- +----------+---------+------+-----+---------+----------------+


-- PROBLEM 2: How to allow queries based on term
-- We should not simply add the term as a column to offering because the
-- information is contained within the term code and would result in redundancy
-- To solve this problem we can add a new table that provides information
-- on the term itself. This new tables could have the relation
-- Term (termCode, year, term)

-- ----------------------------
--  Table structure for `Term`
-- ----------------------------
SELECT "Creating Term Table...";
DROP TABLE IF EXISTS `Term`;
CREATE TABLE `Term` (
  `termCode` decimal(4,0) NOT NULL,
  `year` decimal(4,0) DEFAULT NULL,
  `term` char(8) DEFAULT NULL,
  PRIMARY KEY(termCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SELECT "Add values into new Term Table...";
INSERT INTO Term (termCode, year, term) VALUES (1191, 2019, 'Winter');
INSERT INTO Term (termCode, year, term) VALUES (1189, 2018, 'Fall');

ALTER TABLE Offering
ADD FOREIGN KEY (termCode) REFERENCES Term (termCode);



/*
(e) Considering queries for the following purposes:
- Which instructors are sessionals?
- Which instructors have taught courses over a particular timeframe?
- How many courses are taught by sessionals?
- How many students are taught by sessionals?
- Any of the above, grouped by faculty
- Any of the above, as fractions of total instructors and/or courses, as relevant?


Using “explain” and/or your own reasoning, identify what indexes would be potentially useful to help in
these queries.
*/


-- Which instructors are sessionals?
SELECT * FROM Instructor WHERE sessional=true;
-- +--------+----------+--------+-----------+
-- | instID | instName | deptID | sessional |
-- +--------+----------+--------+-----------+
-- |      4 | Moe      | CS     |         1 |
-- +--------+----------+--------+-----------+
-- 1 row in set (0.12 sec)

explain SELECT * FROM Instructor WHERE sessional=true;
-- +----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+-------------+
-- | id | select_type | table      | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
-- +----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+-------------+
-- |  1 | SIMPLE      | Instructor | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    4 |    25.00 | Using where |
-- +----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+-------------+
-- 1 row in set, 1 warning (0.11 sec)

ALTER TABLE Instructor ADD INDEX (sessional);

SELECT * FROM Instructor WHERE sessional=true;
-- +--------+----------+--------+-----------+
-- | instID | instName | deptID | sessional |
-- +--------+----------+--------+-----------+
-- |      4 | Moe      | CS     |         1 |
-- +--------+----------+--------+-----------+
-- 1 row in set (0.10 sec)

explain SELECT * FROM Instructor WHERE sessional=true;
-- +----+-------------+------------+------------+------+---------------+-----------+---------+-------+------+----------+-------+
-- | id | select_type | table      | partitions | type | possible_keys | key       | key_len | ref   | rows | filtered | Extra |
-- +----+-------------+------------+------------+------+---------------+-----------+---------+-------+------+----------+-------+
-- |  1 | SIMPLE      | Instructor | NULL       | ref  | sessional     | sessional | 2       | const |    1 |   100.00 | NULL  |
-- +----+-------------+------------+------------+------+---------------+-----------+---------+-------+------+----------+-------+
-- 1 row in set, 1 warning (0.00 sec)

-- We can see that the query was improved greatly. The type has changed from ALL to ref meaning that the index is used 
-- correctly and only part of the table needs to be searched for the return


-- Which instructors have taught courses over a particular timeframe?
EXPLAIN SELECT t1.instName, t2.termCode as termCode
FROM Instructor as t1
INNER JOIN Offering as t2
on t1.instID=t2.instID
WHERE termCode > 1190 AND termCode < 1192;

-- +----+-------------+-------+------------+-------+-----------------+--------+---------+------+------+----------+----------------------------------------------------+
-- | id | select_type | table | partitions | type  | possible_keys   | key    | key_len | ref  | rows | filtered | Extra                                              |
-- +----+-------------+-------+------------+-------+-----------------+--------+---------+------+------+----------+----------------------------------------------------+
-- |  1 | SIMPLE      | t2    | NULL       | index | instID,termCode | instID | 5       | NULL |    5 |    80.00 | Using where; Using index                           |
-- |  1 | SIMPLE      | t1    | NULL       | ALL   | PRIMARY         | NULL   | NULL    | NULL |    4 |    25.00 | Using where; Using join buffer (Block Nested Loop) |
-- +----+-------------+-------+------------+-------+-----------------+--------+---------+------+------+----------+----------------------------------------------------+

-- From the type column we can see that the second row (table t1) has type ALL. This indicates that an index is not being used.
-- We can improve the query by adding an index for table t1

ALTER TABLE Instructor ADD INDEX (instName);

-- +----+-------------+-------+------------+--------+----------------------------+---------+---------+-----------------------+------+----------+--------------------------+
-- | id | select_type | table | partitions | type   | possible_keys              | key     | key_len | ref                   | rows | filtered | Extra                    |
-- +----+-------------+-------+------------+--------+----------------------------+---------+---------+-----------------------+------+----------+--------------------------+
-- |  1 | SIMPLE      | t2    | NULL       | index  | instID,termCode,termCode_2 | instID  | 5       | NULL                  |    5 |    80.00 | Using where; Using index |
-- |  1 | SIMPLE      | t1    | NULL       | eq_ref | PRIMARY                    | PRIMARY | 4       | assignment2.t2.instID |    1 |   100.00 | NULL                     |
-- +----+-------------+-------+------------+--------+----------------------------+---------+---------+-----------------------+------+----------+--------------------------+
-- 2 rows in set, 1 warning (0.00 sec)

-- The query is now improved as indicated by the type "eq_ref". This performs a BTREE traversal to find one row.
-- The fact that t1 has type index may indicate teh query can be improved. index is similar to ALL but it is searching through all elements
-- of the index. Since we have indicies on the join column (it is a foreign key) this may indicate that re-writing the query could improve performance.
-- let's try a subquery first then joiing the resutls.

EXPLAIN SELECT t1.instName, t2.termCode as termCode
FROM Instructor as t1
INNER JOIN 
  (SELECT termCode, instID
  FROM Offering
  WHERE termCode > 1190 AND termCode < 1192) 
  as t2
on t1.instID=t2.instID;

-- +----+-------------+----------+------------+--------+----------------------------+---------+---------+-----------------------------+------+----------+--------------------------+
-- | id | select_type | table    | partitions | type   | possible_keys              | key     | key_len | ref                         | rows | filtered | Extra                    |
-- +----+-------------+----------+------------+--------+----------------------------+---------+---------+-----------------------------+------+----------+--------------------------+
-- |  1 | SIMPLE      | Offering | NULL       | index  | instID,termCode,termCode_2 | instID  | 5       | NULL                        |    5 |    80.00 | Using where; Using index |
-- |  1 | SIMPLE      | t1       | NULL       | eq_ref | PRIMARY                    | PRIMARY | 4       | assignment2.Offering.instID |    1 |   100.00 | NULL                     |
-- +----+-------------+----------+------------+--------+----------------------------+---------+---------+-----------------------------+------+----------+--------------------------+

-- This did not change the execution plan of the query.




-- How many courses are taught by sessionals?

-- Remove previous indexes
ALTER TABLE Instructor DROP INDEX sessional;
ALTER TABLE Instructor DROP INDEX instName;

EXPLAIN SELECT count(*) 
FROM
  (SELECT * FROM Instructor
  WHERE sessional=1) 
  as t1
INNER JOIN Offering as t2
ON t2.instID=t1.instID;

-- +----+-------------+------------+------------+------+---------------+--------+---------+-------------------------------+------+----------+-------------+
-- | id | select_type | table      | partitions | type | possible_keys | key    | key_len | ref                           | rows | filtered | Extra       |
-- +----+-------------+------------+------------+------+---------------+--------+---------+-------------------------------+------+----------+-------------+
-- |  1 | SIMPLE      | Instructor | NULL       | ALL  | PRIMARY       | NULL   | NULL    | NULL                          |    4 |    25.00 | Using where |
-- |  1 | SIMPLE      | t2         | NULL       | ref  | instID        | instID | 5       | assignment2.Instructor.instID |    1 |   100.00 | Using index |
-- +----+-------------+------------+------------+------+---------------+--------+---------+-------------------------------+------+----------+-------------+
-- 2 rows in set, 1 warning (0.00 sec)

-- This query can be improved by having an index on the Instructor table. We can try adding the index on sessional as before.

ALTER TABLE Instructor Add INDEX (sessional);

-- +----+-------------+------------+------------+------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- | id | select_type | table      | partitions | type | possible_keys     | key       | key_len | ref                           | rows | filtered | Extra       |
-- +----+-------------+------------+------------+------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- |  1 | SIMPLE      | Instructor | NULL       | ref  | PRIMARY,sessional | sessional | 2       | const                         |    1 |   100.00 | Using index |
-- |  1 | SIMPLE      | t2         | NULL       | ref  | instID            | instID    | 5       | assignment2.Instructor.instID |    1 |   100.00 | Using index |
-- +----+-------------+------------+------------+------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- 2 rows in set, 1 warning (0.00 sec)

-- The query is now using the index.


-- How many students are taught by sessionals?

ALTER TABLE Instructor DROP INDEX sessional;

EXPLAIN SELECT sum(enrollment) 
FROM
  (SELECT * FROM Instructor
  WHERE sessional=1) 
  as t1
INNER JOIN Offering as t2
ON t2.instID=t1.instID;

-- +----+-------------+------------+------------+------+---------------+--------+---------+-------------------------------+------+----------+-------------+
-- | id | select_type | table      | partitions | type | possible_keys | key    | key_len | ref                           | rows | filtered | Extra       |
-- +----+-------------+------------+------------+------+---------------+--------+---------+-------------------------------+------+----------+-------------+
-- |  1 | SIMPLE      | Instructor | NULL       | ALL  | PRIMARY       | NULL   | NULL    | NULL                          |    4 |    25.00 | Using where |
-- |  1 | SIMPLE      | t2         | NULL       | ref  | instID        | instID | 5       | assignment2.Instructor.instID |    1 |   100.00 | NULL        |
-- +----+-------------+------------+------------+------+---------------+--------+---------+-------------------------------+------+----------+-------------+
-- 2 rows in set, 1 warning (0.00 sec)

-- Again, this can be improved by the sessional index.

ALTER TABLE Instructor Add INDEX (sessional);

-- +----+-------------+------------+------------+------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- | id | select_type | table      | partitions | type | possible_keys     | key       | key_len | ref                           | rows | filtered | Extra       |
-- +----+-------------+------------+------------+------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- |  1 | SIMPLE      | Instructor | NULL       | ref  | PRIMARY,sessional | sessional | 2       | const                         |    1 |   100.00 | Using index |
-- |  1 | SIMPLE      | t2         | NULL       | ref  | instID            | instID    | 5       | assignment2.Instructor.instID |    1 |   100.00 | NULL        |
-- +----+-------------+------------+------------+------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- 2 rows in set, 1 warning (0.00 sec)




-- Any of the above, grouped by faculty
ALTER TABLE Instructor DROP INDEX sessional;

-- We will do courses taught grouped by faculty where sessional.
EXPLAIN SELECT d.faculty, COUNT(*)
FROM
Department AS d
INNER JOIN
  (SELECT t1.*
  FROM Instructor AS t1
  INNER JOIN
  Offering AS t2
  ON t1.instID=t2.instID
  WHERE t1.sessional=1)
AS tmp
ON d.deptID=tmp.deptID
GROUP BY d.faculty;

-- +----+-------------+-------+------------+--------+----------------+---------+---------+-----------------------+------+----------+----------------------------------------------+
-- | id | select_type | table | partitions | type   | possible_keys  | key     | key_len | ref                   | rows | filtered | Extra                                        |
-- +----+-------------+-------+------------+--------+----------------+---------+---------+-----------------------+------+----------+----------------------------------------------+
-- |  1 | SIMPLE      | t1    | NULL       | ALL    | PRIMARY,deptID | NULL    | NULL    | NULL                  |    4 |    25.00 | Using where; Using temporary; Using filesort |
-- |  1 | SIMPLE      | d     | NULL       | eq_ref | PRIMARY        | PRIMARY | 24      | func                  |    1 |   100.00 | Using where                                  |
-- |  1 | SIMPLE      | t2    | NULL       | ref    | instID         | instID  | 5       | assignment2.t1.instID |    1 |   100.00 | Using index                                  |
-- +----+-------------+-------+------------+--------+----------------+---------+---------+-----------------------+------+----------+----------------------------------------------+
-- 3 rows in set, 1 warning (0.00 sec)

ALTER TABLE Instructor Add INDEX (sessional);

-- +----+-------------+-------+------------+--------+--------------------------+-----------+---------+-----------------------+------+----------+----------------------------------------------+
-- | id | select_type | table | partitions | type   | possible_keys            | key       | key_len | ref                   | rows | filtered | Extra                                        |
-- +----+-------------+-------+------------+--------+--------------------------+-----------+---------+-----------------------+------+----------+----------------------------------------------+
-- |  1 | SIMPLE      | t1    | NULL       | ref    | PRIMARY,deptID,sessional | sessional | 2       | const                 |    1 |   100.00 | Using where; Using temporary; Using filesort |
-- |  1 | SIMPLE      | d     | NULL       | eq_ref | PRIMARY                  | PRIMARY   | 24      | func                  |    1 |   100.00 | Using where                                  |
-- |  1 | SIMPLE      | t2    | NULL       | ref    | instID                   | instID    | 5       | assignment2.t1.instID |    1 |   100.00 | Using index                                  |
-- +----+-------------+-------+------------+--------+--------------------------+-----------+---------+-----------------------+------+----------+----------------------------------------------+
-- 3 rows in set, 1 warning (0.00 sec)

-- Again the sessional column seems to be the best way to optimized the query using indexes. The fact that primary and foreign key relationships
-- exist definately contribute to the optimization of the query.



-- Any of the above, as fractions of total instructors and/or courses, as relevant?

-- Courses taught by sessionals as a fraction

ALTER TABLE Instructor DROP INDEX sessional;

EXPLAIN SELECT count_sessional/total_courses FROM
  (SELECT count(*) AS count_sessional
  FROM
    (SELECT * FROM Instructor
    WHERE sessional=0) 
    as t1
  INNER JOIN 
    Offering as t2
  ON t2.instID=t1.instID) 
  AS num
CROSS JOIN
  (SELECT count(*) AS total_courses
  FROM Offering)
  AS den;

-- +----+-------------+------------+------------+--------+---------------+----------+---------+-------------------------------+------+----------+-------------+
-- | id | select_type | table      | partitions | type   | possible_keys | key      | key_len | ref                           | rows | filtered | Extra       |
-- +----+-------------+------------+------------+--------+---------------+----------+---------+-------------------------------+------+----------+-------------+
-- |  1 | PRIMARY     | <derived2> | NULL       | system | NULL          | NULL     | NULL    | NULL                          |    1 |   100.00 | NULL        |
-- |  1 | PRIMARY     | <derived4> | NULL       | system | NULL          | NULL     | NULL    | NULL                          |    1 |   100.00 | NULL        |
-- |  4 | DERIVED     | Offering   | NULL       | index  | NULL          | termCode | 2       | NULL                          |    5 |   100.00 | Using index |
-- |  2 | DERIVED     | Instructor | NULL       | ALL    | PRIMARY       | NULL     | NULL    | NULL                          |    4 |    25.00 | Using where |
-- |  2 | DERIVED     | t2         | NULL       | ref    | instID        | instID   | 5       | assignment2.Instructor.instID |    1 |   100.00 | Using index |
-- +----+-------------+------------+------------+--------+---------------+----------+---------+-------------------------------+------+----------+-------------+
-- 5 rows in set, 1 warning (0.00 sec)

-- The first thing that appears obvious is to again add the sessional index.

ALTER TABLE Instructor Add INDEX (sessional);


-- +----+-------------+------------+------------+--------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- | id | select_type | table      | partitions | type   | possible_keys     | key       | key_len | ref                           | rows | filtered | Extra       |
-- +----+-------------+------------+------------+--------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- |  1 | PRIMARY     | <derived2> | NULL       | system | NULL              | NULL      | NULL    | NULL                          |    1 |   100.00 | NULL        |
-- |  1 | PRIMARY     | <derived4> | NULL       | system | NULL              | NULL      | NULL    | NULL                          |    1 |   100.00 | NULL        |
-- |  4 | DERIVED     | Offering   | NULL       | index  | NULL              | termCode  | 2       | NULL                          |    5 |   100.00 | Using index |
-- |  2 | DERIVED     | Instructor | NULL       | ref    | PRIMARY,sessional | sessional | 2       | const                         |    3 |   100.00 | Using index |
-- |  2 | DERIVED     | t2         | NULL       | ref    | instID            | instID    | 5       | assignment2.Instructor.instID |    1 |   100.00 | Using index |
-- +----+-------------+------------+------------+--------+-------------------+-----------+---------+-------------------------------+------+----------+-------------+
-- 5 rows in set, 1 warning (0.00 sec)

-- This improves the query on the instructor table. The derived tables are the sub query tables used to find the conditional count
-- and total count for the courses. It is unlikely that we can improve these much since the sub queries are counts of entries (improved
-- by having a primary key) and counting conditional (improved by the sessional index)

ALTER TABLE Instructor DROP INDEX sessional;


/*
(f) Considering the specific query:
select count(courseID) from Course inner join Department using (deptID)
where prereqID is NULL and faculty=’Math’;
Assuming no indexes, what would the execution plan be and what would be the estimated execution time
for that plan if the tables are on disk, in contiguous blocks, the number of rows in Course is r c , the number
of blocks in Course is b c , the number of rows in Department is r d , the number of blocks in Department is
b d , the time to find a random block on disk is T s and the time to transfer a block from disk is T t ? (g) For
the query above, identify any indexes over one or more attributes that might potentially improve the query
performance. For each index you identify, specify the type of index (B+-tree or Hash or either), whether
or not it is a primary or secondary index, if it is a secondary index identify if it is useful if it is an index
extension, and justify why the query might benefit from that index.
*/


EXPLAIN select count(courseID) 
from Course 
inner join 
Department 
using (deptID) 
where prereqID is NULL and faculty='Math';

-- has no keys defined or indexes
-- +----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
-- | id | select_type | table      | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra                                              |
-- +----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
-- |  1 | SIMPLE      | Course     | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    4 |    25.00 | Using where                                        |
-- |  1 | SIMPLE      | Department | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    4 |    25.00 | Using where; Using join buffer (Block Nested Loop) |
-- +----+-------------+------------+------------+------+---------------+------+---------+------+------+----------+----------------------------------------------------+
-- 2 rows in set, 1 warning (0.00 sec)


/*
The execution plan would involve an inner join on the two tables followed by a filter on the predicates.
The first step to evaluating the execution would be to write the query in relational algebra.

the query can be written as 
SUM[ σ_prereqID=NULL and faculty='Math'( ∏_deptID( Course |><|c.deptID=d.deptID Department ) ) ]

Since there are no indexes and keys let's consider the inner join as executed using a nested loop
Assuming the inner relations fit in memory the execution time for the join would be
(b_c * b_d) * T_t + 2*T_s

After the join is complete we need to loop over the returned elements and add
the elements that are not filtered. There is no reason the algorithm can't be optimized 
to execute this portion during the construction of the join. So the time should be the same as above

If we assume there is only enough memory for one block of each relation. The cost becomes

(r_c * b_d + b_c)* T_t + (r_c + b_c)* T_s

each block in the inner relation is read once for each record in the outer relation

*/


-- Adding primary and foreign keys
ALTER TABLE Course
ADD PRIMARY KEY (courseID);

ALTER TABLE Department
ADD PRIMARY KEY (deptID);

ALTER TABLE Course
ADD FOREIGN KEY (deptID) REFERENCES Department(deptID);

EXPLAIN select count(courseID) 
from Course 
inner join 
Department 
using (deptID) 
where prereqID is NULL and faculty='Math';

-- +----+-------------+------------+------------+--------+---------------+---------+---------+---------------------------+------+----------+-------------+
-- | id | select_type | table      | partitions | type   | possible_keys | key     | key_len | ref                       | rows | filtered | Extra       |
-- +----+-------------+------------+------------+--------+---------------+---------+---------+---------------------------+------+----------+-------------+
-- |  1 | SIMPLE      | Course     | NULL       | ALL    | deptID        | NULL    | NULL    | NULL                      |    4 |    25.00 | Using where |
-- |  1 | SIMPLE      | Department | NULL       | eq_ref | PRIMARY       | PRIMARY | 24      | assignment2.Course.deptID |    1 |    25.00 | Using where |
-- +----+-------------+------------+------------+--------+---------------+---------+---------+---------------------------+------+----------+-------------+
-- 2 rows in set, 1 warning (0.00 sec)



-- (g)

/* 
The primary and foreign keys defined above can help improve the query performance. 
We can also add index on the columns used as predicates, prereqID and faculty
For faculty I would use a BTREE. This way
when the 'Math' predicate is searched, it will order all values for faculty and search the tree.
 The prereqID can be indexed using a BTREE as well for the same reason. 
The best performance might occur if the resulting joined table can be indexed on both columns
at once. I think Hash would provide similar if not better performance than BTREE because the 
filter is a point query.
*/




-- QUESTION 2
-- (2) In assigment 1 you had to compute several queries on the Sean Lahman baseball database. There
-- were no explicit indexes on that database, though you should have added primary and foreign keys. Using
-- explain on the queries you created for Lab 1, determine if any additional explicit indexes would help in
-- solving those queries.


-- SELECT COUNT(*) AS num_unknown_birthdates
-- FROM Master
-- WHERE (birthDay IS NULL) OR (birthMonth IS NULL) OR (birthYear IS NULL)
-- OR (birthDay='') OR (birthMonth='') OR (birthYear='');