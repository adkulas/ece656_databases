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