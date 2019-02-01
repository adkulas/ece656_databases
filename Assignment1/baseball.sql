-- Part 1 Create SQL queries to answer the following questions:

-- (a) How many players have an unknown birthdate?
SELECT COUNT(*) AS num_unknown_birthdates
FROM Master
WHERE (birthDay IS NULL) OR (birthMonth IS NULL) OR (birthYear IS NULL)
OR (birthDay='') OR (birthMonth='') OR (birthYear='');

-- (b) Are more players in the Hall of Fame dead or alive? (Output the number alive minus the number dead)
SELECT COUNT(*) AS all_players,
    SUM(CASE WHEN deathYear != '' THEN 1 ELSE 0 END) - SUM(CASE WHEN deathYear = '' THEN 1 ELSE 0 END) AS alive_minus_dead
FROM Master;

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
LIMIT 1;

-- This is very slow (35.29s)
-- SELECT DISTINCT m.nameGiven, s.salary
-- FROM Salaries AS s
-- LEFT JOIN Master AS m 
-- ON s.playerID=m.playerID
-- ORDER BY s.salary DESC
-- LIMIT 1;

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
    (SELECT playerID
    FROM Batting
    WHERE HR> (SELECT AVG(HR) FROM Batting)) 
    AS b
INNER JOIN
    (SELECT playerID
    FROM Pitching
    WHERE SHO> (SELECT AVG(SHO) FROM Pitching)) 
    AS p
USING (playerID);