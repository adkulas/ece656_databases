-- CREATE DATABASE  IF NOT EXISTS `baseball2016` /*!40100 DEFAULT CHARACTER SET utf8 */;
-- USE `baseball2016`;

CREATE DATABASE  IF NOT EXISTS `assignment2` /*!40100 DEFAULT CHARACTER SET utf8 */;
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
INSERT INTO Course(courseID, courseName, deptID, prereqID) VALUES('ECE358', 'Computer Networks', 'ECE', 'ECE250');
INSERT INTO Course(courseID, courseName, deptID, prereqID) VALUES('ECE390', 'Engineering Design', 'ECE', 'ECE250');
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

ALTER TABLE Course
ADD FOREIGN KEY (prereqID) REFERENCES Course(courseID);

ALTER TABLE Offering
ADD FOREIGN KEY (roomID) REFERENCES Classroom(roomID);

ALTER TABLE Offering
ADD FOREIGN KEY (instID) REFERENCES Instructor(instID);




-- (c) What additional constraints, if any, should be added?


/*
(d) Knowing that each department is part of a faculty (deptID → faculty), that courses can have more than
one prerequisite, and desiring to be able to do queries based on term (Winter, Spring, Fall) without regard
to the particular year (e.g., what courses are offered in the fall term?), what modifications to the schema,
if any, are needed to ensure that it is either 3NF or BCNF (your choice)? If there are any new of changed
relations, identify them, including any changes or adjustments to primary keys and/or foreign keys, or any
other constraints. Explain your reasoning.
*/





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



-- QUESTION 2
-- (2) In assigment 1 you had to compute several queries on the Sean Lahman baseball database. There
-- were no explicit indexes on that database, though you should have added primary and foreign keys. Using
-- explain on the queries you created for Lab 1, determine if any additional explicit indexes would help in
-- solving those queries.