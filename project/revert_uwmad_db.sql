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

SET FOREIGN_KEY_CHECKS=1;
