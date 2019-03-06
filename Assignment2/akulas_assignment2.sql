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
INSERT INTO Department(deptID, deptName, faculty) VALUES('C&0', 'Combinatorics and Optimization', 'Math');




SET FOREIGN_KEY_CHECKS = 1;