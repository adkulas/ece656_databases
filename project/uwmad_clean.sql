
-- -------------------------------------------------------------
--          course_offerings
-- -------------------------------------------------------------
select count(*) from course_offerings where name is NULL;
select count(*) from course_offerings where term_code is NULL;
select count(*) from course_offerings where course_uuid is NULL;
select count(*) from course_offerings where uuid is NULL;
 
DELETE FROM course_offerings WHERE name IS NULL;

-- -------------------------------------------------------------
--          courses
-- -------------------------------------------------------------
select count(*) from courses where number is NULL;
select count(*) from courses where uuid is NULL;
select count(*) from courses where name is NULL;

DELETE FROM courses WHERE name IS NULL;
-- -------------------------------------------------------------
--          grade_distributions
-- -------------------------------------------------------------
select count(*) from grade_distributions where course_offering_uuid is NULL;
select count(*) from grade_distributions where section_number is NULL;
select count(*) from grade_distributions where a_count is NULL; 
select count(*) from grade_distributions where ab_count is NULL; 
select count(*) from grade_distributions where b_count is NULL;
select count(*) from grade_distributions where bc_count is NULL;
select count(*) from grade_distributions where c_count is NULL; 
select count(*) from grade_distributions where d_count is NULL; 
select count(*) from grade_distributions where f_count is NULL; 
select count(*) from grade_distributions where s_count is NULL;
select count(*) from grade_distributions where u_count is NULL;
select count(*) from grade_distributions where cr_count is NULL;
select count(*) from grade_distributions where n_count is NULL;          
select count(*) from grade_distributions where p_count is NULL; 
select count(*) from grade_distributions where i_count is NULL; 
select count(*) from grade_distributions where nr_count is NULL;
select count(*) from grade_distributions where nw_count is NULL; 
select count(*) from grade_distributions where other_count is NULL;


-- -------------------------------------------------------------
--          instructors
-- -------------------------------------------------------------
select count(*) from instructors where name is NULL;
select count(*) from instructors where id is NULL;


DELETE FROM instructors WHERE name IS NULL;

-- -------------------------------------------------------------
--          rooms
-- -------------------------------------------------------------
select count(*) from rooms where uuid is NULL;
select count(*) from rooms where facility_code is NULL;
select count(*) from rooms where room_code is NULL; 

DELETE FROM rooms WHERE room_code IS NULL;
-- -------------------------------------------------------------
--          schedules
-- -------------------------------------------------------------
select count(*) from schedules where uuid is NULL;
select count(*) from schedules where start_time is NULL;
select count(*) from schedules where end_time is NULL;
select count(*) from schedules where mon is NULL;
select count(*) from schedules where tues is NULL;
select count(*) from schedules where wed is NULL;
select count(*) from schedules where thurs is NULL;
select count(*) from schedules where fri is NULL;
select count(*) from schedules where sat is NULL;
select count(*) from schedules where sun is NULL;

-- -------------------------------------------------------------
--          sections
-- -------------------------------------------------------------
select count(*) from sections where schedule_uuid is NULL; 
select count(*) from sections where room_uuid is NULL;
select count(*) from sections where section_type is NULL;
select count(*) from sections where course_offering_uuid is NULL;
select count(*) from sections where uuid is NULL;

DELETE FROM sections WHERE room_uuid IS NULL;

-- -------------------------------------------------------------
--          subject_membership
-- -------------------------------------------------------------

select count(*) from subject_memberships where course_offering_uuid is NULL;
select count(*) from subject_memberships where subject_code is NULL; 

-- -------------------------------------------------------------
--          subjects
-- -------------------------------------------------------------

select count(*) from subjects where code is NULL;
select count(*) from subjects where name is NULL;
select count(*) from subjects where abbreviation is NULL;

-- -------------------------------------------------------------
--          teachings
-- -------------------------------------------------------------

select count(*) from teachings where section_uuid is NULL;
select count(*) from teachings where instructor_id is NULL;
     





