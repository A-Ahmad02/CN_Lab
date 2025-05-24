-- Setting up Schemas lab12, and delete if table already exists
CREATE DATABASE IF NOT EXISTS lab12;
USE lab12;
DROP TABLE IF EXISTS `lab12`.`reserve`;
DROP TABLE IF EXISTS `lab12`.`sailor`;
DROP TABLE IF EXISTS `lab12`.`boat`;

CREATE TABLE SAILOR(
	sid INT PRIMARY KEY,
    sname VARCHAR(20),
    rating INT,
    age INT
);

CREATE TABLE BOAT(
	bid INT PRIMARY KEY,
    bname VARCHAR(20),
    color VARCHAR(20)
);
CREATE TABLE RESERVE(
	sid INT,
    bid INT,
    day_reserved DateTime,
    FOREIGN KEY (sid) REFERENCES SAILOR (sid),
    FOREIGN KEY (bid) REFERENCES BOAT (bid)
);

-- Importing Data from csvs into Empty Tables

LOAD DATA LOCAL INFILE 'C:/DriveA/Workspaces/MySQL/Lab12/sailor.csv' 
INTO TABLE SAILOR 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/DriveA/Workspaces/MySQL/Lab12/boat.csv' 
INTO TABLE BOAT
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/DriveA/Workspaces/MySQL/Lab12/reserve.csv' 
INTO TABLE RESERVE 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS (sid,bid,@day_reserved)
SET day_reserved = STR_TO_DATE(@day_reserved,'%d/%m/%Y');

-- TASK 1: Find the names and ages of all sailors
SELECT sname, age
FROM SAILOR;

-- TASK 2: Find all sailors with a rating above 7
SELECT *
FROM SAILOR
WHERE rating > 7;

-- TASK 3: Find the names of sailors who have reserved boat number 103
SELECT sname
FROM SAILOR
WHERE sid in (
	SELECT sid
	FROM RESERVE
	WHERE bid = 103
);

-- TASK 4: Find the sids of sailors who have reserved a red boat.
SELECT sid
FROM RESERVE
WHERE bid in (
	SELECT bid
    FROM BOAT
    WHERE color = 'red'
);

-- TASK 5: Find the names of sailors who have reserved a red boat
SELECT sname FROM SAILOR
WHERE sid in (
	SELECT sid FROM RESERVE
	WHERE bid in (
		SELECT bid FROM BOAT
		WHERE color = 'red'
	)
);

-- TASK 6: Find the colors of boats reserved by Lubber
SELECT color FROM BOAT
WHERE bid in (
	SELECT bid FROM RESERVE
    WHERE sid in (
		SELECT sid FROM SAILOR
        WHERE sname = 'Lubber'
    )
);

-- TASK 7: Find the names of sailors who have reserved at least one boat
SELECT sname
FROM SAILOR
WHERE sid in (
	SELECT sid
    FROM RESERVE
);

-- TASK 8: Find the ages of sailors whose name begins and ends with B and has at least three characters
SELECT age 
FROM SAILOR
WHERE sname LIKE "b_%b";

-- TASK 9: Find the names of sailors who have reserved a red or a green boat.
SELECT sname FROM SAILOR
WHERE sid in (
	SELECT sid FROM RESERVE
    WHERE bid in (
		SELECT bid FROM BOAT
        WHERE color = 'red' or color = 'green'
    )
);

-- TASK 10: Find all sids of sailors who have a rating of 10 or reserved boat 104
SELECT sid
FROM RESERVE
WHERE bid = 104 or sid in (
	SELECT sid FROM SAILOR
    WHERE rating = 10
);

