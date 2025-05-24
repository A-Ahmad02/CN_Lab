create schema if not exists hotelBooking;
use hotelBooking;
drop table if exists  `hotelBooking`.`booking`;
drop table if exists  `hotelBooking`.`room`;
drop table if exists  `hotelBooking`.`guest`;
drop table if exists  `hotelBooking`.`hotel`;

create table hotel( 
	hotelno varchar(10) primary key, 
    hotelname varchar(20), 
    city varchar(20) 
);
insert into hotel values('fb01', 'Grosvenor', 'London');
insert into hotel values('fb02', 'Watergate', 'Paris');
insert into hotel values('ch01', 'Omni Shoreham', 'London');
insert into hotel values('ch02', 'Phoenix Park', 'London');
insert into hotel values('dc01', 'Latham', 'Berlin');

create table room( 
	roomno numeric(5), 
    hotelno varchar(10), 
    type varchar(10), 
    price decimal(5,2), 
    primary key (roomno, hotelno), 
    foreign key (hotelno) REFERENCES hotel(hotelno) 
);
insert into room values(501, 'fb01', 'single', 19);
insert into room values(601, 'fb01', 'double', 29);
insert into room values(701, 'fb01', 'family', 39);
insert into room values(1001, 'fb02', 'single', 58);
insert into room values(1101, 'fb02', 'double', 86);
insert into room values(1001, 'ch01', 'single', 29.99);
insert into room values(1101, 'ch01', 'family', 59.99);
insert into room values(701, 'ch02', 'single', 10);
insert into room values(801, 'ch02', 'double', 15);
insert into room values(901, 'dc01', 'single', 18);
insert into room values(1001, 'dc01', 'double', 30);
insert into room values(1101, 'dc01', 'family', 35);

create table guest( 
	guestno numeric(5), 
    guestname varchar(20), 
    guestaddress varchar(50),
	primary key (guestno) 
);
insert into guest values(10001, 'John Kay', '56 High St, London');
insert into guest values(10002, 'Mike Ritchie', '18 Tain St, London');
insert into guest values(10003, 'Mary Tregear', '5 Tarbot Rd, Aberdeen'); 
insert into guest values(10004, 'Joe Keogh', '2 Fergus Dr, Aberdeen'); 
insert into guest values(10005, 'Carol Farrel', '6 Achray St, Glasgow'); 
insert into guest values(10006, 'Tina Murphy', '63 Well St, Glasgow'); 
insert into guest values(10007, 'Tony Shaw', '12 Park Pl, Glasgow');

create table booking( 
	hotelno varchar(10), 
	guestno numeric(5), 
	datefrom datetime, 
    dateto datetime, 
    roomno numeric(5), 
    primary key (hotelno, guestno, datefrom), 
    foreign key (roomno, hotelno) REFERENCES room(roomno, hotelno), 
    foreign key (guestno) REFERENCES guest(guestno) 
);
insert into booking values('fb01', 10001, '02-04-01', '02-04-08', 501);
insert into booking values('fb01', 10004, '04-04-15', '04-05-15', 601);
insert into booking values('fb01', 10005, '03-05-02', '03-05-07', 501);
insert into booking values('fb01', 10001, '04-05-01', null, 701);
insert into booking values('fb02', 10003, '09-04-05', '10-04-04', 1001);
insert into booking values('ch01', 10006, '04-04-21', null, 1101);
insert into booking values('ch02', 10002, '04-04-25', '04-05-06', 801);
insert into booking values('dc01', 10007, '06-05-13', '06-05-15', 1001);
insert into booking values('dc01', 10003, '12-05-20', null, 1001);

-- TASK 1: List the names and addresses of all guests in London, alphabetically ordered by name.
SELECT guestname, guestaddress
FROM guest
WHERE guestno in (
		SELECT guestno
        FROM booking AS b
			INNER JOIN hotel AS h
            ON b.hotelno = h.hotelno
        WHERE city = 'London'
	)
ORDER BY guestname ASC;

-- TASK 2: Display the names of all the hotels along with the number of rooms present in each of them. 
SELECT h.hotelname, count(r.roomno) AS NumberOfRooms
FROM hotel AS h
	INNER JOIN room AS r
    ON h.hotelno = r.hotelno
GROUP BY hotelname;

-- TASK 3: Display the AVG price of each hotel situated in London. 
SELECT h.hotelname, avg(r.price) AS AveragePrice
FROM hotel AS h
	INNER JOIN room AS r
    ON h.hotelno = r.hotelno
WHERE h.city = 'London'
GROUP BY hotelname;

-- TASK 4: Display the most expensive double, single and family rooms respectively. 
SELECT r.type, h.hotelname, r.roomno, r.price as MaxPrice
FROM hotel AS h
	INNER JOIN room AS r
    ON h.hotelno = r.hotelno
WHERE (r.type,r.price) in (
	SELECT type, max(price) AS MaxPrice
	FROM room
	GROUP BY type
);

-- TASK 5: Display hotelname, cityname along with distinct number of room types 
-- available in each of them. 
SELECT h.hotelname, h.city, count(r.type) AS NumberOfRoomTypes
FROM hotel AS h
	INNER JOIN room AS r
    ON h.hotelno = r.hotelno
GROUP BY h.hotelno;

-- TASK 6: Display the name and city of the hotel where guests from London are staying. 
-- The list should not contain any hotel twice. 
SELECT distinct hotelname, city
FROM hotel
WHERE hotelno in (
	SELECT b.hotelno
    FROM booking AS b
		INNER JOIN guest AS g
        ON b.guestno = g.guestno
	WHERE g.guestaddress LIKE '%London%'
);

-- TASK 7: Display the name, city of all the hotels along with the number of 
-- reservations it has, in descending order. 
SELECT h.hotelname, h.city, count(b.hotelno) AS NumberOfReservations
FROM hotel AS h
	INNER JOIN booking AS b
    ON h.hotelno = b.hotelno
GROUP BY b.hotelno
ORDER BY NumberOfReservations DESC;

-- TASK 8: Display the names of all the guests who have not provided with the 
-- end date of their reservations. 
SELECT guestname
FROM guest
WHERE guestno in (
	SELECT guestno
    FROM booking
    WHERE dateto IS NULL
);

-- TASK 9: Display the HotelName and RoomNo which was reserved in either year 
-- 2003 or 2004, also display the Guest No of the respective guest. 
SELECT h.hotelname, b.roomno, b.guestno
FROM hotel AS h
	INNER JOIN booking AS b
    ON h.hotelno = b.hotelno
WHERE YEAR(datefrom) BETWEEN 2003 AND 2004;

-- TASK 10: Display the name of the hotel and city which has not been reserved. 
-- -- Never reserved
SELECT hotelname, city
FROM hotel
WHERE hotelno NOT IN (
	SELECT distinct hotelno
    FROM booking
);

-- -- Currently not reserved
SELECT distinct h.hotelname, h.city
FROM hotel h
	LEFT JOIN booking b
    ON h.hotelno = b.hotelno
WHERE b.guestno IS NULL OR b.dateto < NOW();

-- TASK 11: How many different guests have made bookings till May, 2015? 
SELECT count(distinct guestno) AS NumberOfDifferentGuestsBookingTillMay2015
FROM booking
WHERE datefrom < '2015-05-01 00:00:00';

-- TASK 12: What is the total revenue per night from all double rooms? 
SELECT AVG(price)
FROM room
WHERE type = 'double';

-- TASK 13: How many different guests have made bookings for August? 
SELECT count(distinct guestno) AS NumberOfDifferentGuestsBookingInAugust
FROM booking
WHERE MONTH(datefrom) = 8;

-- TASK 14: List the price and type of all rooms at the ‘Avari’ Hotel in Lahore. 
SELECT type, price
FROM room
WHERE hotelno in (
	SELECT hotelno
    FROM hotel
    WHERE hotelname = 'Avari' AND city = 'Lahore'
);

-- -- As there is no ‘Avari’ Hotel in the database, so replaced with 'Latham'
SELECT type, price
FROM room
WHERE hotelno in (
	SELECT hotelno
    FROM hotel
    WHERE hotelname = 'Latham' AND city = 'Berlin'
);

-- TASK 15: List all guests currently staying at the ‘Marriott’ Hotel. 
-- (‘system date’ is used to determine current date) 
SELECT guestname
FROM guest
WHERE guestno in (
	SELECT guestno
    FROM booking
    WHERE (dateto > NOW() OR dateto IS NULL) AND hotelno in (
		SELECT hotelno
        FROM hotel
        WHERE hotelname = 'Marriott'
    )
);

-- -- As there is no ‘Marriott’ Hotel in the database, so replaced with 'Omni Shoreham'
SELECT guestname
FROM guest
WHERE guestno in (
	SELECT guestno
    FROM booking
    WHERE (dateto > NOW() OR dateto IS NULL) AND hotelno in (
		SELECT hotelno
        FROM hotel
        WHERE hotelname = 'Omni Shoreham'
    )
);

-- TASK 16: What is the total income from bookings for the ‘Hotel Inn’ Hotel today? 
-- -- Shows just the Revenue Generated by required hotel
SELECT SUM(r.price) AS RevenueGeneratedToday
FROM room AS r
	INNER JOIN booking AS b
    ON r.roomno = b.roomno AND r.hotelno = b.hotelno
WHERE ( b.dateto IS NULL OR b.dateto > CURDATE() )
	AND b.hotelno in (
	SELECT hotelno 
    FROM hotel
    WHERE hotelname = 'Hotel Inn'
)
ORDER BY r.hotelno ASC;

-- -- As there is no ‘Hotel Inn’ Hotel in the database, so replaced with 'Omni Shoreham'
SELECT SUM(r.price) AS RevenueGeneratedToday
FROM room AS r
	INNER JOIN booking AS b
    ON r.roomno = b.roomno AND r.hotelno = b.hotelno
WHERE ( b.dateto IS NULL OR b.dateto > CURDATE() )
	AND b.hotelno in (
	SELECT hotelno 
    FROM hotel
    WHERE hotelname = 'Omni Shoreham'
)
ORDER BY r.hotelno ASC;

-- -- Table printed to confirm Relevant Data and form Required Query
-- SELECT h.hotelname, r.hotelno, r.roomno, r.price, DATEDIFF(IFNULL(b.dateto, NOW()), b.datefrom) AS NumberOfDays, (r.price * DATEDIFF(IFNULL(b.dateto, NOW()), b.datefrom)) AS RevenueGenerated
-- FROM room AS r
-- 	INNER JOIN booking AS b
--     ON r.roomno = b.roomno AND r.hotelno = b.hotelno
--     INNER JOIN hotel AS h
--     ON r.hotelno = h.hotelno
-- ORDER BY r.hotelno ASC;

-- -- Shows Revenue Generated by all hotels
-- SELECT h.hotelname,  SUM(r.price * DATEDIFF(IFNULL(b.dateto, NOW()), b.datefrom)) AS RevenueGeneratedToDate
-- FROM room AS r
-- 	INNER JOIN booking AS b
--     ON r.roomno = b.roomno AND r.hotelno = b.hotelno
--     INNER JOIN hotel AS h
--     ON r.hotelno = h.hotelno
-- GROUP BY h.hotelname
-- ORDER BY h.hotelname ASC;

-- -- Shows Revenue Generated by required hotel with hotelname
-- SELECT h.hotelname,  SUM(r.price * DATEDIFF(IFNULL(b.dateto, NOW()), b.datefrom)) AS RevenueGeneratedToDate
-- FROM room AS r
-- 	INNER JOIN booking AS b
--     ON r.roomno = b.roomno AND r.hotelno = b.hotelno
--     INNER JOIN hotel AS h
--     ON r.hotelno = h.hotelno
-- WHERE h.hotelname = 'Latham'
-- -- GROUP BY h.hotelname
-- ORDER BY h.hotelname ASC;

-- TASK 17: List the rooms which are currently unoccupied at the ‘Hotel Inn’ Hotel. 
SELECT r.roomno AS VacantRoomNo
FROM room r
	LEFT JOIN booking b
    ON b.datefrom = (SELECT b.datefrom FROM booking b
					WHERE r.roomno = b.roomno AND r.hotelno = b.hotelno
					ORDER BY b.datefrom DESC
					LIMIT 1)
WHERE b.guestno IS NOT NULL AND IFNULL(b.dateto, NOW()) < NOW() AND b.hotelno in (
	SELECT hotelno
    FROM hotel
    WHERE hotelname = 'Hotel Inn' 
);

-- -- As there is no ‘Hotel Inn’ Hotel in the database, so replaced with 'Grosvenor'
SELECT r.roomno AS VacantRoomNo
FROM room r
	LEFT JOIN booking b
    ON b.datefrom = (SELECT b.datefrom FROM booking b
					WHERE r.roomno = b.roomno AND r.hotelno = b.hotelno
					ORDER BY b.datefrom DESC
					LIMIT 1)
WHERE b.guestno IS NOT NULL AND IFNULL(b.dateto, NOW()) < NOW() AND b.hotelno in (
	SELECT hotelno
    FROM hotel
    WHERE hotelname = 'Grosvenor' 
);

-- TASK 18: What is the lost income from unoccupied rooms at the ‘Hotel Inn’ Hotel? 
SELECT SUM(r.price) AS IncomeLostToday
FROM room r
	LEFT JOIN booking b
    ON b.datefrom = (SELECT b.datefrom FROM booking b
					WHERE r.roomno = b.roomno AND r.hotelno = b.hotelno
					ORDER BY b.datefrom DESC
					LIMIT 1)
WHERE b.guestno IS NOT NULL AND IFNULL(b.dateto, NOW()) < NOW() AND b.hotelno in (
	SELECT hotelno
    FROM hotel
    WHERE hotelname = '‘Hotel Inn' 
);

-- -- As there is no ‘Hotel Inn’ Hotel in the database, so replaced with 'Grosvenor'
SELECT SUM(r.price) AS IncomeLostToday
FROM room r
	LEFT JOIN booking b
    ON b.datefrom = (SELECT b.datefrom FROM booking b
					WHERE r.roomno = b.roomno AND r.hotelno = b.hotelno
					ORDER BY b.datefrom DESC
					LIMIT 1)
WHERE b.guestno IS NOT NULL AND IFNULL(b.dateto, NOW()) < NOW() AND b.hotelno in (
	SELECT hotelno
    FROM hotel
    WHERE hotelname = 'Grosvenor' 
);

-- TASK 19: What is the lost income from unoccupied rooms at each hotel today? 
SELECT h.hotelname, SUM(r.price) AS IncomeLostToday
FROM room r
	LEFT JOIN booking b
    ON b.datefrom = (SELECT b.datefrom FROM booking b
					WHERE r.roomno = b.roomno AND r.hotelno = b.hotelno
					ORDER BY b.datefrom DESC
					LIMIT 1)
	LEFT JOIN hotel AS h
    ON r.hotelno = h.hotelno
WHERE b.guestno IS NULL OR (b.datefrom IS NOT NULL AND IFNULL(b.dateto, NOW()) < NOW())
GROUP BY h.hotelno;

-- TASK 20: For each hotel with more than two different types of rooms, what is the lost income from unoccupied rooms? 
SELECT h.hotelname, SUM(r.price) AS IncomeLostToday
FROM room r
	LEFT JOIN booking b
    ON b.datefrom = (SELECT b.datefrom FROM booking b
					WHERE r.roomno = b.roomno AND r.hotelno = b.hotelno
					ORDER BY b.datefrom DESC
					LIMIT 1)
	LEFT JOIN hotel AS h
    ON r.hotelno = h.hotelno
WHERE (b.guestno IS NULL OR (b.datefrom IS NOT NULL AND IFNULL(b.dateto, NOW()) < NOW()))
    AND r.hotelno IN (SELECT hotelno FROM room
					GROUP BY hotelno
					HAVING COUNT(type) > 2)
GROUP BY h.hotelno;
