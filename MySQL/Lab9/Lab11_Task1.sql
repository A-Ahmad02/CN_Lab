-- Setting up Database lab11_task1, and delete if table already exists
CREATE DATABASE IF NOT EXISTS lab11_task1;
USE lab11_task1;
DROP TABLE IF EXISTS `lab11_task1`.`booking`;
DROP TABLE IF EXISTS `lab11_task1`.`room`;
DROP TABLE IF EXISTS `lab11_task1`.`hotel`;
DROP TABLE IF EXISTS `lab11_task1`.`guest`;

-- TASK 1-1: Creating Empty Tables 
CREATE TABLE HOTEL (
	HotelNo INT PRIMARY KEY, 
    HotelName VARCHAR(50) NOT NULL, 
    City VARCHAR(50)
    );
CREATE TABLE GUEST (
	GuestNo INT PRIMARY KEY, 
    GuestName VARCHAR(50) NOT NULL, 
    GuestAddress VARCHAR(50)
	);
CREATE TABLE ROOM (
	RoomNo INT,
    HotelNo INT, 
    RoomType VARCHAR(50), 
    Price FLOAT,
    PRIMARY KEY (RoomNo, HotelNo), -- declaring a COMPOSITE KEY
    FOREIGN KEY (HotelNo) REFERENCES HOTEL (HotelNo)
    );
CREATE TABLE BOOKING (
	HotelNo INT , 
    GuestNo INT, 
    DateFrom DateTime NOT NULL, 
    DateTo DateTime, 
    RoomNo INT, 
    FOREIGN KEY (HotelNo) REFERENCES HOTEL (HotelNo),
    FOREIGN KEY (GuestNo) REFERENCES GUEST (GuestNo)
    );
    
-- TASK 1-2: Importing Data from csvs into Empty Tables

-- First, enable local_infile using MySQL Command Line (for Error Code: 3948)
-- mysql> SET GLOBAL local_infile=1;
-- mysql> SET GLOBAL local_infile = 'ON';
-- mysql> set global local_infile=true;
-- Query OK, 0 rows affected (0.00 sec)
-- mysql> SHOW GLOBAL VARIABLES LIKE 'local_infile';
-- +---------------+-------+
-- | Variable_name | Value |
-- +---------------+-------+
-- | local_infile  | ON    |
-- +---------------+-------+
-- 1 row in set (0.00 sec)
-- mysql> quit

-- And edit the C:\ProgramData\MySQL\MySQL Server 8.4\my.ini (for Error Code: 2068)
-- [client]
-- local-infile=1
-- [mysql]
-- local-infile=1
-- [mysqld]
-- local-infile=1

-- Add OPT_LOCAL_INFILE=1 in Database>Manage Connections>Connection>Advanced>Others:
-- Then, restart Workbench

-- Set format for datetime when importing (for Error Code: 1262 Data Truncated for DateTime enteries)
-- or, use YYYYmmdd format for date in csv

LOAD DATA LOCAL INFILE 'C:/DriveA/Workspaces/MySQL/Lab11/HOTEL.csv' 
INTO TABLE HOTEL 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS (`HotelNo`,`HotelName`,`City`);

LOAD DATA LOCAL INFILE 'C:/DriveA/Workspaces/MySQL/Lab11/GUEST.csv' 
INTO TABLE GUEST 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS (`GuestNo`,`GuestName`,`GuestAddress`);

LOAD DATA LOCAL INFILE 'C:/DriveA/Workspaces/MySQL/Lab11/ROOM.csv' 
INTO TABLE ROOM
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS (`RoomNo`,`HotelNo`,`RoomType`,`Price`);

LOAD DATA LOCAL INFILE 'C:/DriveA/Workspaces/MySQL/Lab11/BOOKING.csv' 
INTO TABLE BOOKING
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS (HotelNo,GuestNo,@DateFrom,@DateTo,RoomNo)
SET DateFrom = STR_TO_DATE(@DateFrom,'%d/%m/%Y'), DateTo = STR_TO_DATE(@DateTo,'%d/%m/%Y');

-- TASK 1-3: Exporting DataBase to csv

-- Edit the C:\ProgramData\MySQL\MySQL Server 8.4\my.ini (for Error Code: 1290)
-- [mysqld]
-- secure-file-priv=""

-- Then, restart Workbench and confirm changes saved using MySQL Command Line
-- mysql> SHOW VARIABLES LIKE "secure_file_priv";
-- +------------------+-------+
-- | Variable_name    | Value |
-- +------------------+-------+
-- | secure_file_priv |       |
-- +------------------+-------+
-- 1 row in set (0.01 sec)

SELECT *
FROM HOTEL
INTO OUTFILE 'C:/DriveA/Workspaces/MySQL/Lab11/HOTEL_out.csv' 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

SELECT *
FROM GUEST
INTO OUTFILE 'C:/DriveA/Workspaces/MySQL/Lab11/GUEST_out.csv' 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

-- Error Code: 1086. File already exists
-- Due to security reasons MySQL can not overwite or delete Files
-- so, delete output files HOTEL_out and GUEST_out before running 
