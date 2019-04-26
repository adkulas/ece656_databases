DROP TABLE test;
CREATE TABLE `test` (
  `id` int(11) NOT NULL,
  `numbers` int(11) DEFAULT NULL,
  `numbers2` int(11) DEFAULT NULL,
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT into test (id, numbers, numbers2) VALUES(1, NULL, 6);
INSERT into test (id, numbers, numbers2) VALUES(2, NULL, 7);
INSERT into test (id, numbers, numbers2) VALUES(3, NULL, 8);
INSERT into test (id, numbers, numbers2) VALUES(4, 1, NULL);
INSERT into test (id, numbers, numbers2) VALUES(5, 2, NULL);
INSERT into test (id, numbers, numbers2) VALUES(6, 2, NULL);
INSERT into test (id, numbers, numbers2) VALUES(7, 4, 5);
INSERT into test (id, numbers, numbers2) VALUES(8, 5, 8);



UPDATE test as t1
NATURAL JOIN
  (SELECT avg(numbers)
  FROM test as t2)
SET numbers = NULL
WHERE numbers =  10;

    UPDATE Salaries AS s
    INNER JOIN
        -- This will join the query above to the original salary table to allow the update
        (SELECT m.playerID AS mpID, m.bbrefID, s.playerID AS spID
        FROM Master AS m
        INNER JOIN 
            (SELECT child.*
            FROM Salaries AS child
            LEFT JOIN Master AS parent
            ON child.playerID=parent.playerID
            WHERE parent.playerID IS NULL)
            AS s
        ON m.bbrefID=s.playerID) AS tmp
    ON s.playerID=tmp.spID
    -- Update the playerIDs in salary to match Master
    SET s.playerID=tmp.mpID;


UPDATE test as t1
NATURAL JOIN
  (SELECT avg(numbers) as average
  FROM test) as t2
SET t1.numbers = t2.average WHERE t1.numbers IS NULL;

update test as t1
NATURAL JOIN
  (SELECT avg(numbers)
  FROM test) as t2.average
WHERE t1.numbers IS NULL; 


UPDATE test as t1
NATURAL JOIN
  (
    SELECT AVG(dd.numbers) as median_val
    FROM (
    SELECT d.numbers, @rownum:=@rownum+1 as `row_number`, @total_rows:=@rownum
      FROM test d, (SELECT @rownum:=0) r
      WHERE d.numbers is NOT NULL
      -- put some where clause here
      ORDER BY d.numbers
    ) as dd
    WHERE dd.row_number IN ( FLOOR((@total_rows+1)/2), FLOOR((@total_rows+2)/2) )
  ) as t2
SET t1.numbers = t2.median_val WHERE t1.numbers IS NULL;



SELECT AVG(dd.numbers) as median_val
FROM (
SELECT d.numbers, @rownum:=@rownum+1 as `row_number`, @total_rows:=@rownum
  FROM test d, (SELECT @rownum:=0) r
  WHERE d.numbers is NOT NULL
  -- put some where clause here
  ORDER BY d.numbers
) as dd
WHERE dd.row_number IN ( FLOOR((@total_rows+1)/2), FLOOR((@total_rows+2)/2) );


UPDATE test as t1
NATURAL JOIN
  (
    SELECT numbers AS mode, COUNT(*) 
    FROM test 
    WHERE numbers IS NOT NULL 
    GROUP BY numbers ORDER BY COUNT(*) 
    DESC LIMIT 1
  ) AS t2
SET t1.numbers = t2.mode WHERE t1.numbers IS NULL;



    select numbers, count(*) 
    from test 
    where numbers IS NOT NULL 
    group by numbers order by count(*) 
    DESC LIMIT 1;



DELETE FROM test WHERE numbers IS NULL;



Select *
from
(
    SELECT tbl.*, @counter := @counter +1 counter
    FROM (select @counter:=0) initvar, tbl
    ORDER BY ordcolumn
) X
where counter <= (50/100 * @counter);
ORDER BY ordcolumn


SELECT @rows := ROUND(COUNT(*) * 50/100) FROM test;
PREPARE STMT FROM ‘SELECT * FROM test ORDER BY RAND() LIMIT ?’;
EXECUTE STMT USING @rows;

SET @a=1;


SELECT @rows := ROUND(COUNT(*) * 20/100) FROM test;
PREPARE STMT FROM 'SELECT * FROM test ORDER BY RAND() LIMIT ?';
EXECUTE STMT USING @rows;

SELECT @rows := ROUND(COUNT(*) * 20/100) FROM test;
PREPARE STMT FROM 'DELETE FROM test ORDER BY RAND() LIMIT ?';
EXECUTE STMT USING @rows;










SELECT
course_offering_uuid,
(4.0 * a_count + 3.5 * ab_count + 3.0 * b_count + 2.5 * bc_count + 2 * c_count + 1 * d_count) / IF((a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)=0,1,(a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)) AS avg_gpa,
a_count + ab_count + b_count + bc_count + c_count + d_count + f_count AS num_grades
FROM grade_distributions
LIMIT 10;

ALTER TABLE grade_distributions
ADD avg_gpa float,
ADD num_grades int(11);

UPDATE grade_distributions as t1
INNER JOIN
  (
    SELECT
    course_offering_uuid,
    (4.0 * a_count + 3.5 * ab_count + 3.0 * b_count + 2.5 * bc_count + 2 * c_count + 1 * d_count) / IF((a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)=0,1,(a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)) AS avg_gpa,
    a_count + ab_count + b_count + bc_count + c_count + d_count + f_count AS num_grades
    FROM grade_distributions
  ) AS t2
USING (course_offering_uuid)
SET t1.avg_gpa = t2.avg_gpa, t1.num_grades = t2.num_grades;


SELECT t1.course_offering_uuid,t2.*
FROM grade_distributions as t1
INNER JOIN
  (
    SELECT
    course_offering_uuid,
    (4.0 * a_count + 3.5 * ab_count + 3.0 * b_count + 2.5 * bc_count + 2 * c_count + 1 * d_count) / IF((a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)=0,1,(a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)) AS avg_gpa,
    a_count + ab_count + b_count + bc_count + c_count + d_count + f_count AS num_grades
    FROM grade_distributions
  ) AS t2
USING(course_offering_uuid)
LIMIT 10;