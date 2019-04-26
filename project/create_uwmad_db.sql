CREATE DATABASE IF NOT EXISTS `UWmadison` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `UWmadison`;


SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------------------------------------
-- CREATE ALL TABLES
-- -------------------------------------------------------------

DROP TABLE IF EXISTS `course_offerings`;
CREATE TABLE `course_offerings` (
  `uuid` varchar(100) NOT NULL,
  `course_uuid` varchar(100) NOT NULL,
  `term_code` decimal(4,0) NOT NULL,
  `name` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `courses`;
CREATE TABLE `courses` (
  `uuid` varchar(100) NOT NULL,
  `name` varchar(150) DEFAULT NULL,
  `number` int(11) NOT NULL,
  PRIMARY KEY(`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `grade_distributions`;
CREATE TABLE `grade_distributions` (
  `course_offering_uuid` varchar(100) NOT NULL,
  `section_number` int(11) NOT NULL,
  `a_count` int(11) NOT NULL,
  `ab_count` int(11) NOT NULL,
  `b_count` int(11) NOT NULL,
  `bc_count` int(11) NOT NULL,
  `c_count` int(11) NOT NULL,
  `d_count` int(11) NOT NULL,
  `f_count` int(11) NOT NULL,
  `s_count` int(11) NOT NULL,
  `u_count` int(11) NOT NULL,
  `cr_count` int(11) NOT NULL,
  `n_count` int(11) NOT NULL,
  `p_count` int(11) NOT NULL,
  `i_count` int(11) NOT NULL,
  `nw_count` int(11) NOT NULL,
  `nr_count` int(11) NOT NULL,
  `other_count` int(11) NOT NULL,
  PRIMARY KEY(`course_offering_uuid`,`section_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `instructors`;
CREATE TABLE `instructors` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `rooms`;
CREATE TABLE `rooms` (
  `uuid` varchar(100) NOT NULL,
  `facility_code` varchar(30) NOT NULL,
  `room_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY(`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `schedules`;
CREATE TABLE `schedules` (
  `uuid` varchar(100) NOT NULL,
  `start_time` int(11) NOT NULL,
  `end_time` int(11) NOT NULL,
  `mon` boolean,
  `tues` boolean,
  `wed` boolean,
  `thurs` boolean,
  `fri` boolean,
  `sat` boolean,
  `sun` boolean,
  PRIMARY KEY(`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sections`;
CREATE TABLE `sections` (
  `uuid` varchar(100) NOT NULL,
  `course_offering_uuid` varchar(100) NOT NULL,
  `section_type` varchar(10) NOT NULL,
  `number` int(11) NOT NULL,
  `room_uuid` varchar(100) DEFAULT NULL,
  `schedule_uuid` varchar(100) NOT NULL,
  PRIMARY KEY(`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `subject_memberships`;
CREATE TABLE `subject_memberships` (
  `subject_code` char(3) NOT NULL,
  `course_offering_uuid` varchar(100) NOT NULL,
  PRIMARY KEY(`subject_code`,`course_offering_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
  `code` char(3) NOT NULL,
  `name` varchar(100) NOT NULL,
  `abbreviation` varchar(20) NOT NULL,
  PRIMARY KEY(`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `teachings`;
CREATE TABLE `teachings` (
  `instructor_id` int(11) NOT NULL,
  `section_uuid` varchar(100) NOT NULL,
  PRIMARY KEY(`instructor_id`,`section_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- -------------------------------------------------------------
-- LOAD DATA INTO TABLES
-- -------------------------------------------------------------
LOAD DATA
    LOCAL
    INFILE 'data/course_offerings.csv' REPLACE
    INTO TABLE course_offerings
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (uuid,course_uuid,term_code,@vname)
        SET 
        name  = if(@vname='null', NULL, @vname);


LOAD DATA
    LOCAL
    INFILE 'data/courses.csv' REPLACE
    INTO TABLE courses
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (uuid,@vname,number)
        SET 
        name  = if(@vname='null', NULL, @vname);


LOAD DATA
    LOCAL
    INFILE 'data/grade_distributions.csv' REPLACE
    INTO TABLE grade_distributions
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (course_offering_uuid,section_number,a_count,ab_count,b_count,bc_count,c_count,d_count,f_count,s_count,u_count,cr_count,n_count,p_count,i_count,nw_count,nr_count,other_count);


LOAD DATA
    LOCAL
    INFILE 'data/instructors.csv' REPLACE
    INTO TABLE instructors
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (id,@vname)
        SET 
        name = if(@vname='null', NULL, @vname);


LOAD DATA
    LOCAL
    INFILE 'data/rooms.csv' REPLACE
    INTO TABLE rooms
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (uuid,facility_code,@vroom_code)
        SET 
        room_code  = if(@vroom_code='null', NULL, @vroom_code);


LOAD DATA
    LOCAL
    INFILE 'data/schedules.csv' REPLACE
    INTO TABLE schedules
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (uuid,start_time,end_time,@vmon,@vtues,@vwed,@vthurs,@vfri,@vsat,@vsun)
        SET 
        mon = if(@vmon='true', 1, 0),
        tues = if(@vtues='true', 1, 0),
        wed = if(@vwed='true', 1, 0),
        thurs = if(@vthurs='true', 1, 0),
        fri = if(@vfri='true', 1, 0),
        sat = if(@vsat='true', 1, 0),
        sun = if(@vsun='true', 1, 0);


LOAD DATA
    LOCAL
    INFILE 'data/sections.csv' REPLACE
    INTO TABLE sections
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (uuid,course_offering_uuid,section_type,number,@vroom_uuid,schedule_uuid)
        SET 
        room_uuid  = if(@vroom_uuid='null', NULL, @vroom_uuid);


LOAD DATA
    LOCAL
    INFILE 'data/subject_memberships.csv' REPLACE
    INTO TABLE subject_memberships
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (subject_code,course_offering_uuid);


LOAD DATA
    LOCAL
    INFILE 'data/subjects.csv' REPLACE
    INTO TABLE subjects
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (code,name,abbreviation);


LOAD DATA
    LOCAL
    INFILE 'data/teachings.csv' REPLACE
    INTO TABLE teachings
    FIELDS 
      TERMINATED BY ','
      ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (instructor_id,section_uuid);



-- -------------------------------------------------------------
-- CREATE FOREIGN KEY RELATIONSHIPS AND ADD INDEXES
-- -------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE course_offerings
ADD FOREIGN KEY (course_uuid) REFERENCES courses(uuid);

ALTER TABLE grade_distributions
ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid);

-- cant apply this FK relationship because sections have multiple section types
-- ALTER TABLE grade_distributions
-- ADD FOREIGN KEY (course_offering_uuid,section_number) REFERENCES sections(course_offering_uuid,number);


-- ALTER TABLE instructors


-- ALTER TABLE rooms


-- ALTER TABLE schedules


ALTER TABLE sections
ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid),
ADD FOREIGN KEY (room_uuid) REFERENCES rooms(uuid),
ADD FOREIGN KEY (schedule_uuid) REFERENCES schedules(uuid);

ALTER TABLE subject_memberships
ADD FOREIGN KEY (subject_code) REFERENCES subjects(code),
ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid) ON DELETE CASCADE;

-- ALTER TABLE subjects

ALTER TABLE teachings
ADD FOREIGN KEY (instructor_id) REFERENCES instructors(id),
ADD FOREIGN KEY (section_uuid) REFERENCES sections(uuid);




-- -------------------------------------------------------------
-- CREATE BACKUP
-- -------------------------------------------------------------

DROP TABLE IF EXISTS backup_course_offerings;
CREATE TABLE backup_course_offerings LIKE course_offerings; 
INSERT backup_course_offerings SELECT * FROM course_offerings;

DROP TABLE IF EXISTS backup_courses;
CREATE TABLE backup_courses LIKE courses; 
INSERT backup_courses SELECT * FROM courses;

DROP TABLE IF EXISTS backup_grade_distributions;
CREATE TABLE backup_grade_distributions LIKE grade_distributions; 
INSERT backup_grade_distributions SELECT * FROM grade_distributions;

DROP TABLE IF EXISTS backup_instructors;
CREATE TABLE backup_instructors LIKE instructors; 
INSERT backup_instructors SELECT * FROM instructors;

DROP TABLE IF EXISTS backup_rooms;
CREATE TABLE backup_rooms LIKE rooms; 
INSERT backup_rooms SELECT * FROM rooms;

DROP TABLE IF EXISTS backup_schedules;
CREATE TABLE backup_schedules LIKE schedules; 
INSERT backup_schedules SELECT * FROM schedules;

DROP TABLE IF EXISTS backup_sections;
CREATE TABLE backup_sections LIKE sections; 
INSERT backup_sections SELECT * FROM sections;

DROP TABLE IF EXISTS backup_course_offerings;
CREATE TABLE backup_subject_memberships LIKE subject_memberships; 
INSERT backup_subject_memberships SELECT * FROM subject_memberships;

DROP TABLE IF EXISTS backup_subjects;
CREATE TABLE backup_subjects LIKE subjects; 
INSERT backup_subjects SELECT * FROM subjects;

DROP TABLE IF EXISTS backup_teachings;
CREATE TABLE backup_teachings LIKE teachings; 
INSERT backup_teachings SELECT * FROM teachings;


