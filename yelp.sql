-- ##############################
-- PART 2
-- ##############################

-- Question (a)
-- Which user has written the greatest number of reviews?

SELECT name, review_count
FROM user
WHERE review_count = (SELECT MAX(review_count) FROM user);

    -- +--------+--------------+
    -- | name   | review_count |
    -- +--------+--------------+
    -- | Victor |        11284 |
    -- +--------+--------------+


-- Question (b)
-- Which business has received the greatest number of reviews?

SELECT name, review_count
FROM business
WHERE review_count = (SELECT MAX(review_count) FROM business);

    -- +--------------+--------------+
    -- | name         | review_count |
    -- +--------------+--------------+
    -- | Mon Ami Gabi |         6414 |
    -- +--------------+--------------+


-- Question (c)
-- What is the average number of reviews written by users?

SELECT SUM(review_count) / COUNT(*)
FROM user;

    -- +------------------------------+
    -- | SUM(review_count) / COUNT(*) |
    -- +------------------------------+
    -- |                      24.3193 |
    -- +------------------------------+


-- Question (d)
-- The average rating written by a user can be determined in two ways:
-- a. By direct reading from the Users table “average stars” column
-- b. By computing an average of the ratings issued by a user for businesses reviewed
-- For how many users is the difference between these two amounts larger than 0.5?

SELECT COUNT(*)
FROM
    (SELECT user_id, AVG(stars) AS calc_avg_stars
    FROM review
    GROUP BY user_id)
    AS r
INNER JOIN user as u
USING (user_id)
WHERE (ABS(r.calc_avg_stars - u.average_stars) > 0.5);

    -- Query Result:
    -- +----------+
    -- | COUNT(*) |
    -- +----------+
    -- |       66 |
    -- +----------+


SELECT u.user_ID
FROM user AS u
LEFT JOIN review AS r
ON u.user_id=r.user_id
WHERE(r.user_ID IS NULL);



-- Question (e)
-- What fraction of users have written more than 10 reviews?



-- Question (f)
-- What is the average length of their reviews?