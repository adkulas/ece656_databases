CREATE DATABASE IF NOT EXISTS `Yelp` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `Yelp`;


SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


DROP TABLE IF EXISTS `business`;
CREATE TABLE `business` (
  `business_id` char(22) NOT NULL,
  `name` varchar(100) NOT NULL,
  `neighborhood` varchar(100) DEFAULT NULL,
  `address` varchar(150) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `stars` float DEFAULT NULL,
  `review_count` int(5) DEFAULT '0',
  `is_open` int(1) DEFAULT NULL,
  PRIMARY KEY (`business_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `business_categories`;
CREATE TABLE `business_categories` (
  `category` varchar(100) DEFAULT NULL,
  `business_id` char(22) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `checkin`;
CREATE TABLE `checkin` (
  `business_id` char(22) NOT NULL,
  `sunday_0_1_count` int(5) DEFAULT '0',
  `sunday_1_2_count` int(5) DEFAULT '0',
  `sunday_2_3_count` int(5) DEFAULT '0',
  `sunday_3_4_count` int(5) DEFAULT '0',
  `sunday_4_5_count` int(5) DEFAULT '0',
  `sunday_5_6_count` int(5) DEFAULT '0',
  `sunday_6_7_count` int(5) DEFAULT '0',
  `sunday_7_8_count` int(5) DEFAULT '0',
  `sunday_8_9_count` int(5) DEFAULT '0',
  `sunday_9_10_count` int(5) DEFAULT '0',
  `sunday_10_11_count` int(5) DEFAULT '0',
  `sunday_11_12_count` int(5) DEFAULT '0',
  `sunday_12_13_count` int(5) DEFAULT '0',
  `sunday_13_14_count` int(5) DEFAULT '0',
  `sunday_14_15_count` int(5) DEFAULT '0',
  `sunday_15_16_count` int(5) DEFAULT '0',
  `sunday_16_17_count` int(5) DEFAULT '0',
  `sunday_17_18_count` int(5) DEFAULT '0',
  `sunday_18_19_count` int(5) DEFAULT '0',
  `sunday_19_20_count` int(5) DEFAULT '0',
  `sunday_20_21_count` int(5) DEFAULT '0',
  `sunday_21_22_count` int(5) DEFAULT '0',
  `sunday_22_23_count` int(5) DEFAULT '0',
  `sunday_23_0_count` int(5) DEFAULT '0',
  `monday_0_1_count` int(5) DEFAULT '0',
  `monday_1_2_count` int(5) DEFAULT '0',
  `monday_2_3_count` int(5) DEFAULT '0',
  `monday_3_4_count` int(5) DEFAULT '0',
  `monday_4_5_count` int(5) DEFAULT '0',
  `monday_5_6_count` int(5) DEFAULT '0',
  `monday_6_7_count` int(5) DEFAULT '0',
  `monday_7_8_count` int(5) DEFAULT '0',
  `monday_8_9_count` int(5) DEFAULT '0',
  `monday_9_10_count` int(5) DEFAULT '0',
  `monday_10_11_count` int(5) DEFAULT '0',
  `monday_11_12_count` int(5) DEFAULT '0',
  `monday_12_13_count` int(5) DEFAULT '0',
  `monday_13_14_count` int(5) DEFAULT '0',
  `monday_14_15_count` int(5) DEFAULT '0',
  `monday_15_16_count` int(5) DEFAULT '0',
  `monday_16_17_count` int(5) DEFAULT '0',
  `monday_17_18_count` int(5) DEFAULT '0',
  `monday_18_19_count` int(5) DEFAULT '0',
  `monday_19_20_count` int(5) DEFAULT '0',
  `monday_20_21_count` int(5) DEFAULT '0',
  `monday_21_22_count` int(5) DEFAULT '0',
  `monday_22_23_count` int(5) DEFAULT '0',
  `monday_23_0_count` int(5) DEFAULT '0',
  `tuesday_0_1_count` int(5) DEFAULT '0',
  `tuesday_1_2_count` int(5) DEFAULT '0',
  `tuesday_2_3_count` int(5) DEFAULT '0',
  `tuesday_3_4_count` int(5) DEFAULT '0',
  `tuesday_4_5_count` int(5) DEFAULT '0',
  `tuesday_5_6_count` int(5) DEFAULT '0',
  `tuesday_6_7_count` int(5) DEFAULT '0',
  `tuesday_7_8_count` int(5) DEFAULT '0',
  `tuesday_8_9_count` int(5) DEFAULT '0',
  `tuesday_9_10_count` int(5) DEFAULT '0',
  `tuesday_10_11_count` int(5) DEFAULT '0',
  `tuesday_11_12_count` int(5) DEFAULT '0',
  `tuesday_12_13_count` int(5) DEFAULT '0',
  `tuesday_13_14_count` int(5) DEFAULT '0',
  `tuesday_14_15_count` int(5) DEFAULT '0',
  `tuesday_15_16_count` int(5) DEFAULT '0',
  `tuesday_16_17_count` int(5) DEFAULT '0',
  `tuesday_17_18_count` int(5) DEFAULT '0',
  `tuesday_18_19_count` int(5) DEFAULT '0',
  `tuesday_19_20_count` int(5) DEFAULT '0',
  `tuesday_20_21_count` int(5) DEFAULT '0',
  `tuesday_21_22_count` int(5) DEFAULT '0',
  `tuesday_22_23_count` int(5) DEFAULT '0',
  `tuesday_23_0_count` int(5) DEFAULT '0',
  `wednesday_0_1_count` int(5) DEFAULT '0',
  `wednesday_1_2_count` int(5) DEFAULT '0',
  `wednesday_2_3_count` int(5) DEFAULT '0',
  `wednesday_3_4_count` int(5) DEFAULT '0',
  `wednesday_4_5_count` int(5) DEFAULT '0',
  `wednesday_5_6_count` int(5) DEFAULT '0',
  `wednesday_6_7_count` int(5) DEFAULT '0',
  `wednesday_7_8_count` int(5) DEFAULT '0',
  `wednesday_8_9_count` int(5) DEFAULT '0',
  `wednesday_9_10_count` int(5) DEFAULT '0',
  `wednesday_10_11_count` int(5) DEFAULT '0',
  `wednesday_11_12_count` int(5) DEFAULT '0',
  `wednesday_12_13_count` int(5) DEFAULT '0',
  `wednesday_13_14_count` int(5) DEFAULT '0',
  `wednesday_14_15_count` int(5) DEFAULT '0',
  `wednesday_15_16_count` int(5) DEFAULT '0',
  `wednesday_16_17_count` int(5) DEFAULT '0',
  `wednesday_17_18_count` int(5) DEFAULT '0',
  `wednesday_18_19_count` int(5) DEFAULT '0',
  `wednesday_19_20_count` int(5) DEFAULT '0',
  `wednesday_20_21_count` int(5) DEFAULT '0',
  `wednesday_21_22_count` int(5) DEFAULT '0',
  `wednesday_22_23_count` int(5) DEFAULT '0',
  `wednesday_23_0_count` int(5) DEFAULT '0',
  `thursday_0_1_count` int(5) DEFAULT '0',
  `thursday_1_2_count` int(5) DEFAULT '0',
  `thursday_2_3_count` int(5) DEFAULT '0',
  `thursday_3_4_count` int(5) DEFAULT '0',
  `thursday_4_5_count` int(5) DEFAULT '0',
  `thursday_5_6_count` int(5) DEFAULT '0',
  `thursday_6_7_count` int(5) DEFAULT '0',
  `thursday_7_8_count` int(5) DEFAULT '0',
  `thursday_8_9_count` int(5) DEFAULT '0',
  `thursday_9_10_count` int(5) DEFAULT '0',
  `thursday_10_11_count` int(5) DEFAULT '0',
  `thursday_11_12_count` int(5) DEFAULT '0',
  `thursday_12_13_count` int(5) DEFAULT '0',
  `thursday_13_14_count` int(5) DEFAULT '0',
  `thursday_14_15_count` int(5) DEFAULT '0',
  `thursday_15_16_count` int(5) DEFAULT '0',
  `thursday_16_17_count` int(5) DEFAULT '0',
  `thursday_17_18_count` int(5) DEFAULT '0',
  `thursday_18_19_count` int(5) DEFAULT '0',
  `thursday_19_20_count` int(5) DEFAULT '0',
  `thursday_20_21_count` int(5) DEFAULT '0',
  `thursday_21_22_count` int(5) DEFAULT '0',
  `thursday_22_23_count` int(5) DEFAULT '0',
  `thursday_23_0_count` int(5) DEFAULT '0',
  `friday_0_1_count` int(5) DEFAULT '0',
  `friday_1_2_count` int(5) DEFAULT '0',
  `friday_2_3_count` int(5) DEFAULT '0',
  `friday_3_4_count` int(5) DEFAULT '0',
  `friday_4_5_count` int(5) DEFAULT '0',
  `friday_5_6_count` int(5) DEFAULT '0',
  `friday_6_7_count` int(5) DEFAULT '0',
  `friday_7_8_count` int(5) DEFAULT '0',
  `friday_8_9_count` int(5) DEFAULT '0',
  `friday_9_10_count` int(5) DEFAULT '0',
  `friday_10_11_count` int(5) DEFAULT '0',
  `friday_11_12_count` int(5) DEFAULT '0',
  `friday_12_13_count` int(5) DEFAULT '0',
  `friday_13_14_count` int(5) DEFAULT '0',
  `friday_14_15_count` int(5) DEFAULT '0',
  `friday_15_16_count` int(5) DEFAULT '0',
  `friday_16_17_count` int(5) DEFAULT '0',
  `friday_17_18_count` int(5) DEFAULT '0',
  `friday_18_19_count` int(5) DEFAULT '0',
  `friday_19_20_count` int(5) DEFAULT '0',
  `friday_20_21_count` int(5) DEFAULT '0',
  `friday_21_22_count` int(5) DEFAULT '0',
  `friday_22_23_count` int(5) DEFAULT '0',
  `friday_23_0_count` int(5) DEFAULT '0',
  `saturday_0_1_count` int(5) DEFAULT '0',
  `saturday_1_2_count` int(5) DEFAULT '0',
  `saturday_2_3_count` int(5) DEFAULT '0',
  `saturday_3_4_count` int(5) DEFAULT '0',
  `saturday_4_5_count` int(5) DEFAULT '0',
  `saturday_5_6_count` int(5) DEFAULT '0',
  `saturday_6_7_count` int(5) DEFAULT '0',
  `saturday_7_8_count` int(5) DEFAULT '0',
  `saturday_8_9_count` int(5) DEFAULT '0',
  `saturday_9_10_count` int(5) DEFAULT '0',
  `saturday_10_11_count` int(5) DEFAULT '0',
  `saturday_11_12_count` int(5) DEFAULT '0',
  `saturday_12_13_count` int(5) DEFAULT '0',
  `saturday_13_14_count` int(5) DEFAULT '0',
  `saturday_14_15_count` int(5) DEFAULT '0',
  `saturday_15_16_count` int(5) DEFAULT '0',
  `saturday_16_17_count` int(5) DEFAULT '0',
  `saturday_17_18_count` int(5) DEFAULT '0',
  `saturday_18_19_count` int(5) DEFAULT '0',
  `saturday_19_20_count` int(5) DEFAULT '0',
  `saturday_20_21_count` int(5) DEFAULT '0',
  `saturday_21_22_count` int(5) DEFAULT '0',
  `saturday_22_23_count` int(5) DEFAULT '0',
  `saturday_23_0_count` int(5) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 


DROP TABLE IF EXISTS `review`;
CREATE TABLE `review` (
  `review_id` char(22) NOT NULL,
  `user_id` char(22) NOT NULL,
  `business_id` char(22) NOT NULL,
  `stars` float DEFAULT NULL,
  `date` date DEFAULT NULL,
  `text` text,
  `useful` int(5) DEFAULT '0',
  `funny` int(5) DEFAULT '0',
  `cool` int(5) DEFAULT '0',
  PRIMARY KEY (`review_id`),
  KEY `idx_rtxt` (`text`(9))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `user_friends`;
CREATE TABLE `user_friends` (
  `user_id` char(22) NOT NULL,
  `friend_id` char(22) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 


DROP TABLE IF EXISTS `tip`;
CREATE TABLE `tip` (
  `user_id` char(22) NOT NULL,
  `business_id` char(22) NOT NULL,
  `date` date DEFAULT NULL,
  `text` text,
  `likes` int(5) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `user_id` char(22) NOT NULL,
  `name` varchar(60) NOT NULL,
  `review_count` int(5) DEFAULT NULL,
  `average_stars` float DEFAULT NULL,
  `funny_vote_count` int(5) DEFAULT '0',
  `useful_vote_count` int(5) DEFAULT '0',
  `cool_vote_count` int(5) DEFAULT '0',
  `yelping_since` date DEFAULT NULL,
  `fans` int(5) DEFAULT '0',
  `compliment_plain` int(5) DEFAULT '0',
  `compliment_note` int(5) DEFAULT '0',
  `compliment_profile` int(5) DEFAULT '0',
  `compliment_writer` int(5) DEFAULT '0',
  `compliment_cute` int(5) DEFAULT '0',
  `compliment_cool` int(5) DEFAULT '0',
  `compliment_list` int(5) DEFAULT '0',
  `compliment_more` int(5) DEFAULT '0',
  `compliment_funny` int(5) DEFAULT '0',
  `compliment_hot` int(5) DEFAULT '0',
  `compliment_photos` int(5) DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;


SET FOREIGN_KEY_CHECKS = 0;
LOAD DATA
    LOCAL
    INFILE 'tip.csv' REPLACE
    INTO TABLE tip
    FIELDS 
      TERMINATED BY ';'
      -- ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
        (business_id,likes,date,text,user_id);
        -- SET
        -- yearID  = if(@vyearID='', 0, @vyearID),
        -- stint   = if(@vstint='', 0, @vstint),
        -- G       = if(@vG='', 0, @vG),
        -- PO      = if(@vPO='', 0, @vPO),
        -- A       = if(@vA='', 0, @vA),
        -- E       = if(@vE='', 0, @vE),
        -- DP      = if(@vDP='', 0, @vDP);
SET FOREIGN_KEY_CHECKS = 1;