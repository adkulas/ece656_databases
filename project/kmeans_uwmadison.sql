

-- convert to GPA's
DROP TEMPORARY TABLE IF EXISTS section_gpas;
  CREATE TEMPORARY TABLE
  section_gpas
  SELECT
    schedule_uuid,
    course_offering_uuid,
    section_number,
    (4.0 * a_count + 3.5 * ab_count + 3.0 * b_count + 2.5 * bc_count + 2 * c_count + 1 * d_count) / IF((a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)=0,1,(a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)) AS gpa,
    a_count + ab_count + b_count + bc_count + c_count + d_count + f_count AS num_grades
  FROM grade_distributions  natural join sections ;


--schedule of courses  that students performed well
SELECT 
    
    sch.start_time,
    sch.end_time, 
    SUM(gpas.gpa * gpas.num_grades) / SUM(gpas.num_grades) as avg_gpa,
    AVG(gpas.num_grades) as avg_num_grades, 
    SUM(gpas.num_grades) as total_num_grades
  FROM instructors i
  JOIN teachings t ON i.id = t.instructor_id
  JOIN sections s ON s.uuid = t.section_uuid
  JOIN section_gpas gpas ON gpas.course_offering_uuid = s.course_offering_uuid AND gpas.section_number = s.number
  JOIN schedules sch ON sch.uuid=gpas.schedule_uuid
  GROUP BY sch.uuid
  HAVING avg_num_grades >= 31 and avg_gpa > 3.5
  ORDER BY avg_gpa DESC
  LIMIT 15




 


create table km_data (id int primary key, cluster_id int,
    lat double, lng double);
create table km_clusters (id int auto_increment primary key,
    start_time double, end_time double
);



DELIMITER //
CREATE PROCEDURE kmeans(n_K int)
BEGIN
TRUNCATE km_clusters;
-- initialize cluster centers
INSERT INTO km_clusters (start_time, end_time) SELECT start_time, end_time FROM km_data LIMIT n_K;
REPEAT
    -- assign clusters to data points
    UPDATE km_data d SET cluster_id = (SELECT id FROM km_clusters c 
        ORDER BY POW(d.lat-c.lat,2)+POW(d.lng-c.lng,2) ASC LIMIT 1);
    -- calculate new cluster center
    UPDATE km_clusters C, (SELECT cluster_id, 
        AVG(lat) AS lat, AVG(lng) AS lng 
        FROM km_data GROUP BY cluster_id) D 
    SET C.lat=D.lat, C.lng=D.lng WHERE C.id=D.cluster_id;
UNTIL ROW_COUNT() = 0 END REPEAT;
END//



--instructors/courses that give highest grades for a class of more than 250 students
 SELECT *
  FROM instructors i
  JOIN teachings t ON i.id = t.instructor_id
  JOIN sections s ON s.uuid = t.section_uuid
  JOIN section_gpas gpas ON gpas.course_offering_uuid = s.course_offering_uuid AND gpas.section_number = s.number
  LIMIT 5

 SELECT 
    i.id, 
    i.name, 
    SUM(gpas.gpa * gpas.num_grades) / SUM(gpas.num_grades) as avg_gpa,
    AVG(gpas.num_grades) as avg_num_grades, 
    SUM(gpas.num_grades) as total_num_grades
  FROM instructors i
  JOIN teachings t ON i.id = t.instructor_id
  JOIN sections s ON s.uuid = t.section_uuid
  JOIN section_gpas gpas ON gpas.course_offering_uuid = s.course_offering_uuid AND gpas.section_number = s.number
  GROUP BY i.id
  HAVING avg_num_grades >= 30
  ORDER BY avg_gpa DESC
  LIMIT 15































