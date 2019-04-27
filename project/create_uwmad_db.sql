
DROP DATABASE IF EXISTS `UWmadison`;
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

DROP TABLE IF EXISTS backup_subject_memberships;
CREATE TABLE backup_subject_memberships LIKE subject_memberships; 
INSERT backup_subject_memberships SELECT * FROM subject_memberships;

DROP TABLE IF EXISTS backup_subjects;
CREATE TABLE backup_subjects LIKE subjects; 
INSERT backup_subjects SELECT * FROM subjects;

DROP TABLE IF EXISTS backup_teachings;
CREATE TABLE backup_teachings LIKE teachings; 
INSERT backup_teachings SELECT * FROM teachings;





-- -------------------------------------------------------------
-- CREATE FOREIGN KEY RELATIONSHIPS AND ADD INDEXES
-- -------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;

select "Alter course offerings";
ALTER TABLE course_offerings
ADD FOREIGN KEY (course_uuid) REFERENCES courses(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

select "Alter grade dist";
ALTER TABLE grade_distributions
ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

select "Alter Sections";
ALTER TABLE sections
ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (room_uuid) REFERENCES rooms(uuid) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (schedule_uuid) REFERENCES schedules(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

select "Alter Subjects";
ALTER TABLE subject_memberships
ADD FOREIGN KEY (subject_code) REFERENCES subjects(code) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

select "Alter teachings";
ALTER TABLE teachings
ADD FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (section_uuid) REFERENCES sections(uuid) ON DELETE CASCADE ON UPDATE CASCADE;



-- -------------------------------------------------------------
-- CREATE USER FOR THE CLIENT/SERVER APPLICATION
-- -------------------------------------------------------------
CREATE USER 'ece656project'@'localhost';
GRANT ALL PRIVILEGES ON UWmadison.* To 'ece656project'@'localhost' IDENTIFIED BY 'ece656projectpass';


-- -------------------------------------------------------------
-- CREATE STORED PROCEDURE FOR DATA MINING
-- -------------------------------------------------------------

DROP procedure IF EXISTS `GetDataset`;
DELIMITER //
 CREATE PROCEDURE GetDataset()
   BEGIN
    
    DROP VIEW IF EXISTS `view1`;
    DROP VIEW IF EXISTS `view2`;
    DROP VIEW IF EXISTS `view3`;
    DROP VIEW IF EXISTS `view4`;
    DROP VIEW IF EXISTS `view5`;

    -- find faculty + prog year
    CREATE VIEW `view1` AS
        SELECT t1.*, FLOOR(t1.subject_code / 100) AS prog_year  
        FROM
        (SELECT course_offering_uuid AS cid,
            (SELECT subject_code FROM subject_memberships 
                WHERE course_offering_uuid = cid
                GROUP BY subject_code
                ORDER BY COUNT(*) DESC
                LIMIT 0,1) AS subject_code
        FROM subject_memberships
        GROUP BY course_offering_uuid) 
        AS t1;


    -- has lab component
    CREATE VIEW `view2` AS
        SELECT t1.course_offering_uuid, CASE WHEN SUM(t1.has_lab) > 0 THEN 1 ELSE 0 END AS has_lab
        FROM
            (SELECT course_offering_uuid, CASE WHEN section_type = 'LAB' THEN 1 ELSE 0 END AS has_lab
            FROM sections) AS t1
        GROUP BY course_offering_uuid;


    -- average hours per week
    CREATE VIEW `view3` AS 
        SELECT t2.co_uuid, AVG(duration) AS avg_duration_weekly
        FROM
            (SELECT t1.course_offering_uuid AS co_uuid, t1.number AS n, SUM(t1.weekly_duration) AS duration
            FROM
                (SELECT s.course_offering_uuid AS course_offering_uuid, sc.duration AS weekly_duration, s.number AS number
                FROM sections as s
                INNER JOIN
                    (SELECT uuid, (end_time - start_time) * (mon+tues+wed+thurs+fri+sat+sun) AS duration
                    FROM schedules) AS sc
                ON s.schedule_uuid = sc.uuid) 
                AS t1
            GROUP BY t1.course_offering_uuid, t1.number)
            AS t2
        GROUP BY t2.co_uuid;


    -- get average num of people enrolled and average grade for course
    CREATE VIEW `view4` AS 
    SELECT co.uuid, AVG(num_grades) as avg_num_people, AVG(avg_gpa) AS avg_gpa
    FROM course_offerings as co 
    INNER JOIN
        (SELECT
        course_offering_uuid,
            (4.0 * a_count + 3.5 * ab_count + 3.0 * b_count + 2.5 * bc_count + 2 * c_count + 1 * d_count) / 
            IF((a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)=0,1,
            (a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)) AS avg_gpa,

            a_count + ab_count + b_count + bc_count + c_count + d_count + f_count AS num_grades
        FROM grade_distributions) AS gd
    ON co.uuid = gd.course_offering_uuid
    GROUP BY co.uuid;

    -- find instructor for course offering including NULLS
    CREATE VIEW `view5` AS 
    SELECT c.uuid, t2.instructor
    FROM course_offerings AS c 
    LEFT JOIN
        (SELECT course_offering_uuid AS cid,
            (SELECT t1.instructor_id 
                FROM 
                    (SELECT instructor_id, course_offering_uuid
                    FROM teachings AS t
                    INNER JOIN
                        (SELECT course_offering_uuid, uuid, section_type
                        FROM sections
                        WHERE section_type = 'LEC') as s
                    ON t.section_uuid = s.uuid)
                    AS t1
                WHERE t1.course_offering_uuid = cid
                GROUP BY t1.instructor_id
                ORDER BY COUNT(*) DESC
                LIMIT 0,1) AS instructor
        FROM 
            (SELECT instructor_id, course_offering_uuid
            FROM teachings AS t
            INNER JOIN
                (SELECT course_offering_uuid, uuid, section_type
                FROM sections
                WHERE section_type = 'LEC') as s
            ON t.section_uuid = s.uuid)
            AS t1
        GROUP BY course_offering_uuid) AS t2
    ON c.uuid = t2.cid;

    DROP TABLE IF EXISTS `course_offering_mining`;
    CREATE TABLE `course_offering_mining`
    SELECT 
        view1.cid, view1.subject_code, view1.prog_year, view2.has_lab, 
        view3.avg_duration_weekly, view4.avg_num_people, view4.avg_gpa, view5.instructor
    FROM view1
    INNER JOIN view2 ON view1.cid = view2.course_offering_uuid
    INNER JOIN view3 ON view1.cid = view3.co_uuid
    INNER JOIN view4 ON view1.cid = view4.uuid
    INNER JOIN view5 ON view1.cid = view5.uuid;

    DROP VIEW view1;
    DROP VIEW view2;
    DROP VIEW view3;
    DROP VIEW view4;
    DROP VIEW view5;


   END //
 DELIMITER ;





DROP procedure IF EXISTS `RevertDatabase`;
DELIMITER //
 CREATE PROCEDURE RevertDatabase()
   BEGIN

-- -------------------------------------------------------------
-- REVERT FROM BACKUP
-- -------------------------------------------------------------
    SET FOREIGN_KEY_CHECKS=0;
    DROP TABLE IF EXISTS course_offerings;
    CREATE TABLE course_offerings LIKE backup_course_offerings; 
    INSERT course_offerings SELECT * FROM backup_course_offerings;

    DROP TABLE IF EXISTS courses;
    CREATE TABLE courses LIKE backup_courses; 
    INSERT backup_courses SELECT * FROM courses;

    DROP TABLE IF EXISTS grade_distributions;
    CREATE TABLE grade_distributions LIKE backup_grade_distributions; 
    INSERT grade_distributions SELECT * FROM backup_grade_distributions;

    DROP TABLE IF EXISTS instructors;
    CREATE TABLE instructors LIKE backup_instructors; 
    INSERT instructors SELECT * FROM backup_instructors;

    DROP TABLE IF EXISTS rooms;
    CREATE TABLE rooms LIKE backup_rooms; 
    INSERT rooms SELECT * FROM backup_rooms;

    DROP TABLE IF EXISTS schedules;
    CREATE TABLE schedules LIKE backup_schedules; 
    INSERT schedules SELECT * FROM backup_schedules;

    DROP TABLE IF EXISTS sections;
    CREATE TABLE sections LIKE backup_sections; 
    INSERT sections SELECT * FROM backup_sections;

    DROP TABLE IF EXISTS subject_memberships;
    CREATE TABLE subject_memberships LIKE backup_subject_memberships; 
    INSERT subject_memberships SELECT * FROM backup_subject_memberships;

    DROP TABLE IF EXISTS subjects;
    CREATE TABLE subjects LIKE backup_subjects; 
    INSERT subjects SELECT * FROM backup_subjects;

    DROP TABLE IF EXISTS teachings;
    CREATE TABLE teachings LIKE backup_teachings; 
    INSERT teachings SELECT * FROM backup_teachings;


    select "Alter course offerings";
    ALTER TABLE course_offerings
    ADD FOREIGN KEY (course_uuid) REFERENCES courses(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

    select "Alter grade dist";
    ALTER TABLE grade_distributions
    ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

    select "Alter Sections";
    ALTER TABLE sections
    ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (room_uuid) REFERENCES rooms(uuid) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (schedule_uuid) REFERENCES schedules(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

    select "Alter Subjects";
    ALTER TABLE subject_memberships
    ADD FOREIGN KEY (subject_code) REFERENCES subjects(code) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (course_offering_uuid) REFERENCES course_offerings(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

    select "Alter teachings";
    ALTER TABLE teachings
    ADD FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (section_uuid) REFERENCES sections(uuid) ON DELETE CASCADE ON UPDATE CASCADE;

    SET FOREIGN_KEY_CHECKS=1;


   END //
 DELIMITER ;

