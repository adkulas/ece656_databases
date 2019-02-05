-- ####################################################
-- Part 1 Create SQL queries to answer the following questions:
-- ####################################################

-- (a) How many players have an unknown birthdate?
SELECT COUNT(*) AS num_unknown_birthdates
FROM Master
WHERE (birthDay IS NULL) OR (birthMonth IS NULL) OR (birthYear IS NULL)
OR (birthDay='') OR (birthMonth='') OR (birthYear='');

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

-- (c) What is the name and total pay of the player with the largest total salary?

-- This one is much faster (0.10sec)
SELECT m.nameGiven, s.salary
FROM 
    (SELECT playerID, salary
    FROM Salaries
    WHERE salary= 
        (SELECT MAX(salary)
         FROM Salaries)) 
    AS s
LEFT JOIN Master AS m 
ON s.playerID=m.playerID
ORDER BY s.salary DESC
LIMIT 10;

-- (d) What is the average number of Home Runs a player has?
SELECT AVG(HR)
FROM Batting;

-- (e) If we only count players who got at least 1 Home Run, what is the average number of Home Runs a player has?
SELECT AVG(h.HR) AS avg_HR_gt0
FROM
    (SELECT HR
    FROM Batting
    WHERE HR>0) AS h;

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


-- QUESTION 2 
-- The SQL file has a very large number of INSERT statements in order to load the data into the
-- database. The CSV files, by contrast, have no associated SQL code to load the data into the
-- database. Create a LOAD statement that will load the data for the Fielding CSV (Fielding.csv)
-- into its associated table. You should verify that your LOAD statement operates correctly and
-- issues no warnings.
DROP TABLE IF EXISTS `Fielding2`;
CREATE TABLE `Fielding2` (
  `playerID` varchar(255) DEFAULT NULL,
  `yearID` int(11) DEFAULT NULL,
  `stint` int(11) DEFAULT NULL,
  `teamID` varchar(255) DEFAULT NULL,
  `lgID` varchar(255) DEFAULT NULL,
  `POS` varchar(255) DEFAULT NULL,
  `G` int(11) DEFAULT NULL,
  `GS` varchar(255) DEFAULT NULL,
  `InnOuts` varchar(255) DEFAULT NULL,
  `PO` int(11) DEFAULT NULL,
  `A` int(11) DEFAULT NULL,
  `E` int(11) DEFAULT NULL,
  `DP` int(11) DEFAULT NULL,
  `PB` varchar(255) DEFAULT NULL,
  `WP` varchar(255) DEFAULT NULL,
  `SB` varchar(255) DEFAULT NULL,
  `CS` varchar(255) DEFAULT NULL,
  `ZR` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOAD DATA
    LOCAL
    INFILE 'Fielding.csv'
    REPLACE
    INTO TABLE Fielding2
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
    
SELECT COUNT(*)
FROM Fielding AS f1
INNER JOIN Fielding2 AS f2
ON f1.playerID = f2.playerID;

SELECT (
(SELECT * FROM Fielding LIMIT 1) 
-
(SELECT * FROM Fielding2 LIMIT 1) );

SELECT playerID,yearID,stint,teamID,lgID,Pos,G,GS,InnOuts,PO,A,E,DP,PB,WP,SB,CS,ZR
FROM Fielding AS f1
WHERE NOT EXISTS
    (SELECT playerID,yearID,stint,teamID,lgID,Pos,G,GS,InnOuts,PO,A,E,DP,PB,WP,SB,CS,ZR
    FROM Fielding2 AS f2
    WHERE 
    f1.playerID=f2.playerID
    AND f1.yearID=f2.yearID
    AND f1.stint=f2.stint 
    AND f1.teamID=f2.teamID 
    AND f1.lgID=f2.lgID 
    AND f1.Pos=f2.Pos 
    AND f1.G=f2.G 
    AND f1.GS=f2.GS 
    AND f1.InnOuts=f2.InnOuts 
    AND f1.PO=f2.PO 
    AND f1.A=f2.A 
    AND f1.E=f2.E 
    AND f1.DP=f2.DP 
    AND f1.PB=f2.PB 
    AND f1.WP=f2.WP 
    AND f1.SB=f2.SB 
    AND f1.CS=f2.CS 
    AND f1.ZR=f2.ZR) 
LIMIT 100;

-- #################################################
-- PART 2 - 
-- #################################################

ALTER TABLE Master
ADD PRIMARY KEY (playerID);

ALTER TABLE Batting
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE Pitching
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE Fielding
ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);