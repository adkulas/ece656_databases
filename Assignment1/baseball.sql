-- ####################################################
-- Part 1 Create SQL queries to answer the following questions:
-- ####################################################

-- (a) How many players have an unknown birthdate?
SELECT COUNT(*) AS num_unknown_birthdates
FROM Master
WHERE (birthDay IS NULL) OR (birthMonth IS NULL) OR (birthYear IS NULL)
OR (birthDay='') OR (birthMonth='') OR (birthYear='');
    -- Query Returns:
    -- +------------------------+
    -- | num_unknown_birthdates |
    -- +------------------------+
    -- |                    449 |
    -- +------------------------+

-- (b) Are more players in the Hall of Fame dead or alive? (Output the number alive minus the number dead)
SELECT SUM(m.alive) - SUM(m.dead) AS alive_minus_dead
FROM
    (SELECT playerID,
        CASE WHEN deathYear = '' THEN 1 ELSE 0 END AS alive,
        CASE WHEN deathYear != '' THEN 1 ELSE 0 END AS dead
    FROM Master)
    AS m
INNER JOIN 
    (SELECT *
    FROM HallOfFame 
    WHERE inducted='Y')
    AS h
USING (playerID)
LIMIT 10;
    -- Query Returns:
    -- +------------------+
    -- | alive_minus_dead |
    -- +------------------+
    -- |             -169 |
    -- +------------------+

-- (c) What is the name and total pay of the player with the largest total salary?
-- Question in my opinion is ambiguous. salary is annualized but it is asking for the largest total salary, implying a sum of salaries
-- In addition total pay is not well defined but can be interpreted as the sum of all salaries for all years a player has played

-- I have assumed "largest total solary" is largest salary
-- I have assumed "largest total pay" is the sum of all salaries the player has earned.
SELECT m.nameGiven, s.total_pay
FROM 
    (SELECT s1.playerID, SUM(s1.salary) AS total_pay
    FROM Salaries AS s1
    INNER JOIN
        (SELECT DISTINCT playerID, salary
        FROM Salaries
        WHERE salary= 
            (SELECT MAX(salary)
            FROM Salaries)) 
        AS s2
    ON s1.playerID=s2.playerID
    GROUP BY s1.playerID
    ORDER BY SUM(s1.salary) DESC)
    AS s
LEFT JOIN Master AS m 
ON s.playerID=m.playerID
ORDER BY s.total_pay DESC
LIMIT 1;

    -- Query RETURNS
    -- +--------------------+-----------+
    -- | nameGiven          | total_pay |
    -- +--------------------+-----------+
    -- | Alexander Enmanuel | 398416252 |
    -- +--------------------+-----------+


-- This returns players with max salary only
-- SELECT m.nameGiven, s.salary
-- FROM 
--     (SELECT playerID, salary
--     FROM Salaries
--     WHERE salary= 
--         (SELECT MAX(salary)
--          FROM Salaries)) 
--     AS s
-- LEFT JOIN Master AS m 
-- ON s.playerID=m.playerID
-- ORDER BY s.salary DESC;
    -- This returns the players with the max salary. This may not be what was intended by "largest total salary"
    -- +--------------------+----------+
    -- | nameGiven          | salary   |
    -- +--------------------+----------+
    -- | Clayton Edward     | 33000000 |
    -- | Alexander Enmanuel | 33000000 |
    -- | Alexander Enmanuel | 33000000 |
    -- +--------------------+----------+

-- (d) What is the average number of Home Runs a player has?
SELECT AVG(HR)
FROM Batting;
    -- Query Returns;
    -- +---------+
    -- | AVG(HR) |
    -- +---------+
    -- |  2.8136 |
    -- +---------+

-- (e) If we only count players who got at least 1 Home Run, what is the average number of Home Runs a player has?
SELECT AVG(h.HR) AS avg_HR_gt0
FROM
    (SELECT HR
    FROM Batting
    WHERE HR>0) AS h;
    -- Query Returns:
    -- +------------+
    -- | avg_HR_gt0 |
    -- +------------+
    -- |     7.2428 |
    -- +------------+


-- (f) If we define a player as a good batter if they have more than the average number of Home
-- Runs, and a player is a good Pitcher if they have more than the average number of ShutOut
-- games, then how many players are both good batters and good pitchers
SELECT COUNT(b.playerID) AS goodbat_goodpitch
FROM
    (SELECT playerID, AVG(HR)
    FROM Batting
    GROUP BY playerID
    HAVING AVG(HR) > (SELECT AVG(HR) FROM Batting))
    AS b
INNER JOIN
    (SELECT playerID, AVG(SHO)
    FROM Pitching
    GROUP BY playerID
    HAVING AVG(SHO) > (SELECT AVG(SHO) FROM Pitching)) 
    AS p
USING (playerID);
    -- Query Returns:
    -- +-------------------+
    -- | goodbat_goodpitch |
    -- +-------------------+
    -- |                 7 |
    -- +-------------------+


-- QUESTION 2 
-- The SQL file has a very large number of INSERT statements in order to load the data into the
-- database. The CSV files, by contrast, have no associated SQL code to load the data into the
-- database. Create a LOAD statement that will load the data for the Fielding CSV (Fielding.csv)
-- into its associated table. You should verify that your LOAD statement operates correctly and
-- issues no warnings.

-- USED TO TEST LOAD STATEMENT WAS CORRECT
-- DROP TABLE IF EXISTS `Fielding2`;
-- CREATE TABLE `Fielding2` (
--   `playerID` varchar(255) DEFAULT NULL,
--   `yearID` int(11) DEFAULT NULL,
--   `stint` int(11) DEFAULT NULL,
--   `teamID` varchar(255) DEFAULT NULL,
--   `lgID` varchar(255) DEFAULT NULL,
--   `POS` varchar(255) DEFAULT NULL,
--   `G` int(11) DEFAULT NULL,
--   `GS` varchar(255) DEFAULT NULL,
--   `InnOuts` varchar(255) DEFAULT NULL,
--   `PO` int(11) DEFAULT NULL,
--   `A` int(11) DEFAULT NULL,
--   `E` int(11) DEFAULT NULL,
--   `DP` int(11) DEFAULT NULL,
--   `PB` varchar(255) DEFAULT NULL,
--   `WP` varchar(255) DEFAULT NULL,
--   `SB` varchar(255) DEFAULT NULL,
--   `CS` varchar(255) DEFAULT NULL,
--   `ZR` varchar(255) DEFAULT NULL
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Credit Source: https://stackoverflow.com/questions/2675323/mysql-load-null-values-from-csv-data

-- The replace option requires that a primary key is set. This is the same key used for (3)
SET FOREIGN_KEY_CHECKS = 0;
ALTER TABLE Fielding
ADD PRIMARY KEY (playerID, yearID, stint, Pos);
LOAD DATA
    LOCAL
    INFILE 'Fielding.csv' REPLACE
    INTO TABLE Fielding
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (playerID,@vyearID,@vstint,teamID,lgID,Pos,@vG,GS,InnOuts,@vPO,@vA,@vE,@vDP,PB,WP,SB,CS,ZR)
        SET 
        yearID  = if(@vyearID='', 0, @vyearID),
        stint   = if(@vstint='', 0, @vstint),
        G       = if(@vG='', 0, @vG),
        PO      = if(@vPO='', 0, @vPO),
        A       = if(@vA='', 0, @vA),
        E       = if(@vE='', 0, @vE),
        DP      = if(@vDP='', 0, @vDP);
SET FOREIGN_KEY_CHECKS = 1;


-- QUESTION 3. The SQL file is missing both primary and foreign keys (which is just as well since some of the
-- data causes problems when such keys are included, as you may have discovered when doing the
-- previous questions). We will assume that the baseball database is sufficiently normalized that we
-- do not want to change the basic set of tables. However, we do want to add primary- and foreign-
-- key constraints.


-- (1) Determine the primary and foreign keys needed for the baseball database

-- First determine candidate Primary keys
-- The primary key is used to uniquely identify a row of the table. No two keys can be the same.
-- Strategy is to check is a key is unique and then make a decision on whether this condition makes sense for the attributes

-- This query was used to test uniqueness
-- SELECT COL, COUNT(*) AS cnt  FROM TABLE_NAME GROUP BY COL ORDER BY cnt DESC LIMIT 10;

-- Masters -> playerID
-- Batting -> (playerID, yearID, stint) -- might be able to use stint to prim key
-- Pitching -> (playerID, yearID, stint)
-- Fielding -> (playerID, yearID, stint, Pos)
-- AllstarFull - > (playerID, gameID)
-- HallOfFame -> (playerID, yearID, votedBy)
-- Managers -> NONE
-- Teams -> (yearID,teamID)
-- BattingPost -> (playerID,yearID,round)
-- PitchingPost -> (playerID,yearID,round)
-- TeamFranchises -> franchID
-- FieldingOF -> (playerID,yearID,stint)
-- ManagersHalf -> (playerID,yearID,half)
-- TeamsHalf -> (teamID,yearID,half)
-- Salaries -> (playerID,teamID,yearID)
-- SeriesPost -> (yearID, round)
-- AwardsManagers -> (playerID,yearID,awardID) -- This assumes that an award cannot be given to the same player the same year more than once
-- AwardsPlayers -> (playerID,yearID,awardID,lgID) -- Baseball Magazine has given the same award to the same player in different leagues, had to add lgID to make unique
-- AwardsShareManagers -> (playerID,yearID,awardID)
-- AwardsSharePlayers -> (playerID,yearID,awardID)
-- FieldingPost -> (playerID,yearID,round,POS)
-- Appearances -> (playerID,yearID,teamID)
-- Schools -> schoolID
-- CollegePlaying -> NONE
-- FieldingOFSplit -> (playerID,yearID,stint,POS)
-- Parks -> `park.key`
-- HomeGames -> (`year.key`,`park.key`,`team.key`)

-- Second determine foreign key realtionships. These relatonships will constrain the key so that it
-- must appear in the referenced table. 

-- Anything with playerID should reference the Master TABLE
-- Batting, Fielding, Pitching, AllstarFull, Managers, BattingPost, PitchingPost, ManagersHalf, TeamsHalf, Salaries, FieldingPost, Appearances, FieldingOFsplit
--     should reference teams via teamID, yearID
-- Teams reference franchises via franchID
-- Seriespost teamIDwinner and teamIDloser should appear in the teams table
-- College playing should reference school table
-- Homegames reference team,year and park




-- (2) Write the necessary SQL to add the primary and foreign keys to this database. When doing
-- this, keep in mind the fact that there is missing data, as you may have noticed from the previous
-- questions, and so your SQL will need to address this issue.

-- ADD ALL PRIMARY KEYS
ALTER TABLE Master
ADD PRIMARY KEY (playerID);

ALTER TABLE Batting
ADD PRIMARY KEY (playerID, yearID, stint);

ALTER TABLE Pitching
ADD PRIMARY KEY (playerID, yearID, stint);

ALTER TABLE Fielding
ADD PRIMARY KEY (playerID, yearID, stint, Pos);

ALTER TABLE AllstarFull
ADD PRIMARY KEY (playerID, gameID);

ALTER TABLE HallOfFame
ADD PRIMARY KEY (playerID, yearID, votedBy);

ALTER TABLE Teams
ADD PRIMARY KEY (yearID,teamID);

ALTER TABLE BattingPost
ADD PRIMARY KEY (playerID, yearID, round);

ALTER TABLE PitchingPost
ADD PRIMARY KEY (playerID, yearID, round);

ALTER TABLE TeamsFranchises
ADD PRIMARY KEY (franchID);

ALTER TABLE FieldingOF
ADD PRIMARY KEY (playerID, yearID, stint);

ALTER TABLE ManagersHalf
ADD PRIMARY KEY (playerID, yearID, half);

ALTER TABLE TeamsHalf
ADD PRIMARY KEY (teamID, yearID, half);

ALTER TABLE Salaries
ADD PRIMARY KEY (playerID, teamID, yearID);

ALTER TABLE SeriesPost
ADD PRIMARY KEY (yearID, round);

ALTER TABLE AwardsManagers
ADD PRIMARY KEY (playerID, yearID, awardID);

ALTER TABLE AwardsPlayers
ADD PRIMARY KEY (playerID, yearID, awardID, lgID);

ALTER TABLE AwardsShareManagers
ADD PRIMARY KEY (playerID, yearID, awardID);

ALTER TABLE AwardsSharePlayers
ADD PRIMARY KEY (playerID, yearID, awardID);

ALTER TABLE FieldingPost
ADD PRIMARY KEY (playerID, yearID, round, POS);

ALTER TABLE Appearances
ADD PRIMARY KEY (playerID, yearID, teamID);

ALTER TABLE Schools
ADD PRIMARY KEY (schoolID);

ALTER TABLE FieldingOFsplit
ADD PRIMARY KEY (playerID, yearID, stint, POS);

ALTER TABLE Parks
ADD PRIMARY KEY (`park.key`);

ALTER TABLE HomeGames
ADD PRIMARY KEY (`year.key`, `park.key`, `team.key`);


-- ADD ALL FOREIGN KEYS

ALTER TABLE Batting
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE Pitching
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

    -- Fielding contains playerID's that do not appear in the Master table.
    -- This query will find those ID's and delete them from the table
    DELETE FROM Fielding
    WHERE playerID IN
        (SELECT tmp.playerID
        FROM 
            (SELECT child.*
            FROM Fielding AS child
            LEFT JOIN Master AS parent
            ON child.playerID=parent.playerID
            WHERE parent.playerID IS NULL)
        AS tmp);
    -- Results from subquery
    -- +----------+--------+-------+--------+------+------+------+------+---------+------+------+------+------+------+------+------+------+------+
    -- | playerID | yearID | stint | teamID | lgID | POS  | G    | GS   | InnOuts | PO   | A    | E    | DP   | PB   | WP   | SB   | CS   | ZR   |
    -- +----------+--------+-------+--------+------+------+------+------+---------+------+------+------+------+------+------+------+------+------+
    -- | mcclo01  |   1875 |     1 | WS6    | NA   | C    |   11 |      |         |   32 |    3 |   17 |    0 | 0    |      |      |      |      |
    -- | colli01  |   1892 |     1 | SLN    | NL   | OF   |    1 |      |         |    2 |    0 |    0 |    0 |      |      |      |      |      |
    -- +----------+--------+-------+--------+------+------+------+------+---------+------+------+------+------+------+------+------+------+------+
    -- After Delete:
    -- Query OK, 2 rows affected (1.00 sec)

-- Now the foreign key constraint can be applied
ALTER TABLE Fielding
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE AllstarFull
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- The foreign key relation can't be made for HallOfFame
-- This query was used to find the value missing from the referenced table
    -- SELECT child.*
    -- FROM HallOfFame AS child
    -- LEFT JOIN Master AS parent
    -- ON child.playerID=parent.playerID
    -- WHERE parent.playerID IS NULL
    
    -- Returns
    -- +----------+--------+---------+---------+--------+-------+----------+----------+-------------+
    -- | playerID | yearid | votedBy | ballots | needed | votes | inducted | category | needed_note |
    -- +----------+--------+---------+---------+--------+-------+----------+----------+-------------+
    -- | drewj.01 |   2017 | BBWAA   |     442 |    332 |     0 | N        | Player   |             |
    -- +----------+--------+---------+---------+--------+-------+----------+----------+-------------+

    -- I suspect this is a typo, but to confirm we check the Master, Fielding, and Batting tables for a similar name
    -- SELECT playerID FROM Master WHERE playerID LIKE 'drewj%'
    -- UNION
    -- (SELECT playerID FROM Batting WHERE playerID LIKE 'drewj%')
    -- UNION
    -- (SELECT playerID FROM Fielding WHERE playerID LIKE 'drewj%')
    
    -- Returns:
    -- +----------+
    -- | playerID |
    -- +----------+
    -- | drewjd01 |
    -- +----------+
    
    -- We are confident this is a typo and correct it with the following query
    UPDATE HallOfFame SET playerID='drewjd01' WHERE playerID='drewj.01';

-- Now the foreign key constriaint can be applied
ALTER TABLE HallOfFame
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE Managers
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE BattingPost
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE PitchingPost
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE FieldingOF
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE ManagersHalf
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- Cannot add foreign key to salaries. The following query was used to find missing playerIDs
    -- SELECT child.*
    -- FROM Salaries AS child
    -- LEFT JOIN Master AS parent
    -- ON child.playerID=parent.playerID
    -- WHERE parent.playerID IS NULL

    -- Result:
    -- +--------+--------+------+-----------+----------+
    -- | yearID | teamID | lgID | playerID  | salary   |
    -- +--------+--------+------+-----------+----------+
    -- |   2016 | BOS    | AL   | castiru02 | 11400000 |
    -- |   2016 | TOR    | AL   | dicker.01 | 12000000 |
    -- |   2016 | HOU    | AL   | harriwi10 |   525500 |
    -- |   2016 | LAD    | NL   | montafr02 |   510000 |
    -- |   2016 | ATL    | NL   | pierza.01 |  3000000 |
    -- |   2016 | COL    | NL   | rosajo01  | 12500000 |
    -- |   2016 | NYY    | AL   | sabatc.01 | 25000000 |
    -- |   2016 | NYY    | AL   | willima10 |   509700 |
    -- +--------+--------+------+-----------+----------+

    -- Try using bbredID to crossreference into the master table
    -- SELECT m.playerID AS m_playerID, m.bbrefID, s.playerID AS s_playerID 
    -- FROM Master AS m
    -- INNER JOIN 
    --     (SELECT child.*
    --     FROM Salaries AS child
    --     LEFT JOIN Master AS parent
    --     ON child.playerID=parent.playerID
    --     WHERE parent.playerID IS NULL)
    --     AS s
    -- ON m.bbrefID=s.playerID;
    -- Returns:
    -- +------------+-----------+------------+
    -- | m_playerID | bbrefID   | s_playerID |
    -- +------------+-----------+------------+
    -- | castiru01  | castiru02 | castiru02  |
    -- | delarjo01  | rosajo01  | rosajo01   |
    -- | dickera01  | dicker.01 | dicker.01  |
    -- | harriwi02  | harriwi10 | harriwi10  |
    -- | montafr01  | montafr02 | montafr02  |
    -- | pierzaj01  | pierza.01 | pierza.01  |
    -- | sabatcc01  | sabatc.01 | sabatc.01  |
    -- | willima07  | willima10 | willima10  |
    -- +------------+-----------+------------+

    -- All the playerID's in question appear in the master table
    -- if joined using the bbrefID. To fix the problem we can update all the playerIDs
    -- to match the Master table playerID

    -- Credit Source: https://stackoverflow.com/questions/11588710/mysql-update-query-with-sub-query#
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
    -- Query OK, 8 rows affected (0.20 sec)
    -- Rows matched: 8  Changed: 8  Warnings: 0
    
-- Now the foreign key contraint can be applied
ALTER TABLE Salaries
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE AwardsManagers
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE AwardsPlayers
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE AwardsShareManagers
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE AwardsSharePlayers
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE FieldingPost
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE Appearances
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE CollegePlaying
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE FieldingOFsplit
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);


ALTER TABLE Batting
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE Fielding
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE Pitching
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE AllstarFull
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE Managers
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE BattingPost
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE PitchingPost
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE ManagersHalf
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE TeamsHalf
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

-- Cannot add foreign key to salaries that references teams
    -- Use this query to find all the missing teamID,yearID
    -- SELECT DISTINCT child.yearID AS s_yearID, child.teamID AS s_teamID, parent.yearID AS t_yearID, parent.teamID AS t_teamID
    -- FROM Salaries AS child
    -- LEFT JOIN Teams AS parent
    -- ON child.yearID=parent.yearID AND child.teamID=parent.teamID
    -- WHERE parent.teamID IS NULL;
    -- Result:
    -- +----------+----------+----------+----------+
    -- | s_yearID | s_teamID | t_yearID | t_teamID |
    -- +----------+----------+----------+----------+
    -- |     2016 | CHW      |     NULL | NULL     |
    -- |     2016 | NYY      |     NULL | NULL     |
    -- |     2016 | STL      |     NULL | NULL     |
    -- |     2016 | SFG      |     NULL | NULL     |
    -- |     2016 | LAD      |     NULL | NULL     |
    -- |     2016 | TBR      |     NULL | NULL     |
    -- |     2016 | CHC      |     NULL | NULL     |
    -- |     2016 | WSN      |     NULL | NULL     |
    -- |     2016 | NYM      |     NULL | NULL     |
    -- |     2016 | SDP      |     NULL | NULL     |
    -- |     2016 | KCR      |     NULL | NULL     |
    -- +----------+----------+----------+----------+
    
    -- It seems that these teams do not exist in the teams table. They are all
    -- from the year 2016. We can insert them so
    -- the key exists and all other fields default to NULL

    INSERT INTO Teams (yearID, TeamID)
    SELECT DISTINCT child.yearID AS s_yearID, child.teamID AS s_teamID
    FROM Salaries AS child
    LEFT JOIN Teams AS parent
    ON child.yearID=parent.yearID AND child.teamID=parent.teamID
    WHERE parent.teamID IS NULL;
    -- Query OK, 11 rows affected (0.86 sec)
    -- Records: 11  Duplicates: 0  Warnings: 0

-- Now we can add the contraint
ALTER TABLE Salaries
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE FieldingPost
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE Appearances
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE FieldingOFsplit
ADD FOREIGN KEY (yearID,teamID) REFERENCES Teams(yearID,teamID);

ALTER TABLE SeriesPost
ADD FOREIGN KEY (yearID,teamIDwinner) REFERENCES Teams(yearID,teamID),
ADD FOREIGN KEY (yearID,teamIDloser) REFERENCES Teams(yearID,teamID);

ALTER TABLE HomeGames
ADD FOREIGN KEY (`year.key`,`team.key`) REFERENCES Teams(yearID,teamID);


-- some franchID are NULL from the previous additions to the Teams table. This indicates
-- not that there is no franchise, only that the franchID is unassigned
ALTER TABLE Teams
ADD FOREIGN KEY (franchID) REFERENCES TeamsFranchises(franchID);


-- Some schools are not present in the schools table but are referenced in the CollegePlaying table

    -- Use this query to find all the missing schools
    -- SELECT DISTINCT child.schoolID AS c_schoolID, parent.schoolID AS s_schoolID
    -- FROM CollegePlaying AS child
    -- LEFT JOIN Schools AS parent
    -- ON child.schoolID=parent.schoolID
    -- WHERE parent.schoolID IS NULL;
    --     Returns:
    -- +------------+------------+
    -- | c_schoolID | s_schoolID |
    -- +------------+------------+
    -- | ctpostu    | NULL       |
    -- | txutper    | NULL       |
    -- | txrange    | NULL       |
    -- | caallia    | NULL       |
    -- +------------+------------+

    -- We can now insert these new schools into the schools table
    INSERT INTO Schools (schoolID)
    SELECT DISTINCT child.schoolID AS c_schoolID
    FROM CollegePlaying AS child
    LEFT JOIN Schools AS parent
    ON child.schoolID=parent.schoolID
    WHERE parent.schoolID IS NULL;
    -- Query OK, 4 rows affected (0.40 sec)
    -- Records: 4  Duplicates: 0  Warnings: 0

ALTER TABLE CollegePlaying
ADD FOREIGN KEY (schoolID) REFERENCES Schools(schoolID);


ALTER TABLE HomeGames
ADD FOREIGN KEY (`park.key`) REFERENCES Parks(`park.key`);




-- SELECT concat('DROP TABLE IF EXISTS `', table_name, '`;')
-- FROM information_schema.tables
-- WHERE table_schema = 'db356_akulas';

-- SET FOREIGN_KEY_CHECKS = 0;
-- DROP TABLE IF EXISTS `AllstarFull`;                
-- DROP TABLE IF EXISTS `Appearances`;                
-- DROP TABLE IF EXISTS `AwardsManagers`;             
-- DROP TABLE IF EXISTS `AwardsPlayers`;              
-- DROP TABLE IF EXISTS `AwardsShareManagers`;        
-- DROP TABLE IF EXISTS `AwardsSharePlayers`;         
-- DROP TABLE IF EXISTS `Batting`;                    
-- DROP TABLE IF EXISTS `BattingPost`;                
-- DROP TABLE IF EXISTS `CollegePlaying`;             
-- DROP TABLE IF EXISTS `Fielding`;                   
-- DROP TABLE IF EXISTS `FieldingOF`;                 
-- DROP TABLE IF EXISTS `FieldingOFsplit`;            
-- DROP TABLE IF EXISTS `FieldingPost`;               
-- DROP TABLE IF EXISTS `HallOfFame`;                 
-- DROP TABLE IF EXISTS `HomeGames`;                  
-- DROP TABLE IF EXISTS `Managers`;                   
-- DROP TABLE IF EXISTS `ManagersHalf`;               
-- DROP TABLE IF EXISTS `Master`;                     
-- DROP TABLE IF EXISTS `Parks`;                      
-- DROP TABLE IF EXISTS `Pitching`;                   
-- DROP TABLE IF EXISTS `PitchingPost`;               
-- DROP TABLE IF EXISTS `Salaries`;                   
-- DROP TABLE IF EXISTS `Schools`;                    
-- DROP TABLE IF EXISTS `SeriesPost`;                 
-- DROP TABLE IF EXISTS `Teams`;                      
-- DROP TABLE IF EXISTS `TeamsFranchises`;            
-- DROP TABLE IF EXISTS `TeamsHalf`;    
-- SET FOREIGN_KEY_CHECKS = 1;            
