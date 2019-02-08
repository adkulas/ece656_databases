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

SELECT AVG(review_count)
FROM user;
    -- Query Result:    
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

-- Question (e)
-- What fraction of users have written more than 10 reviews?

SELECT SUM(CASE WHEN review_count > 10 THEN 1 ELSE 0 END) / COUNT(*)
FROM user;
    -- Query Result:
    -- +---------------------------------------------------------------+
    -- | SUM(CASE WHEN review_count > 10 THEN 1 ELSE 0 END) / COUNT(*) |
    -- +---------------------------------------------------------------+
    -- |                                                        0.3311 |
    -- +---------------------------------------------------------------+

-- Question (f)
-- What is the average length of their reviews?

SELECT AVG(CHAR_LENGTH(text)) AS avg_char_len_per_review
FROM review;
    -- Query Result:
    -- +-------------------------+
    -- | avg_char_len_per_review |
    -- +-------------------------+
    -- |                675.9214 |
    -- +-------------------------+

-- Question could be interpreted as the average length of reviews from the users in the subset above
-- if this is the case the follow query would return the avg review length
-- SELECT AVG(CHAR_LENGTH(r.text))
-- FROM user AS u 
-- INNER JOIN review as r 
-- USING(user_ID)
-- WHERE u.review_count > 10;
    -- +--------------------------+
    -- | AVG(CHAR_LENGTH(r.text)) |
    -- +--------------------------+
    -- |                 698.7808 |
    -- +--------------------------+
