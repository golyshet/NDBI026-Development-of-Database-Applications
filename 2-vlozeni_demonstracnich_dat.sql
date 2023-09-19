--- The hotel and its reservation system - Insertion of demo-data

DELETE FROM Payments;
DELETE FROM Bookings;
DELETE FROM RoomAmenities;
DELETE FROM RoomReviews;
DELETE FROM Rooms;
DELETE FROM RoomTypes;
DELETE FROM Amenities;
DELETE FROM Guests;

IF EXISTS (SELECT * FROM sys.identity_columns WHERE OBJECT_NAME(OBJECT_ID) = 'Payments' AND last_value IS NOT NULL) 
    DBCC CHECKIDENT ('Payments', RESEED, 0);
IF EXISTS (SELECT * FROM sys.identity_columns WHERE OBJECT_NAME(OBJECT_ID) = 'Bookings' AND last_value IS NOT NULL) 
    DBCC CHECKIDENT ('Bookings', RESEED, 0);
IF EXISTS (SELECT * FROM sys.identity_columns WHERE OBJECT_NAME(OBJECT_ID) = 'RoomReviews' AND last_value IS NOT NULL) 
    DBCC CHECKIDENT ('RoomReviews', RESEED, 0);
IF EXISTS (SELECT * FROM sys.identity_columns WHERE OBJECT_NAME(OBJECT_ID) = 'RoomTypes' AND last_value IS NOT NULL) 
    DBCC CHECKIDENT ('RoomTypes', RESEED, 0);
IF EXISTS (SELECT * FROM sys.identity_columns WHERE OBJECT_NAME(OBJECT_ID) = 'Amenities' AND last_value IS NOT NULL) 
    DBCC CHECKIDENT ('Amenities', RESEED, 0);
IF EXISTS (SELECT * FROM sys.identity_columns WHERE OBJECT_NAME(OBJECT_ID) = 'Guests' AND last_value IS NOT NULL) 
    DBCC CHECKIDENT ('Guests', RESEED, 0);

INSERT INTO Guests (first_name, last_name, email, phone)
VALUES
    ('Renata', 'Harrop', 'rharrop0@phpbba.com', '8184506614'),
    ('Kyrstin', 'MacPike', 'kmacpike1@who.int', '3832553610'),
    ('Gib', 'Cracknell', 'gcracknell2@zimbio.com', '5402657058'),
    ('Any', 'Rivalland', 'arivalland3@marriott.com', '3387056847'),
    ('Dexter', 'Seabrocke', 'dseabrocke4@jigsy.com', '6208141250'),
    ('Hansiain', 'Callacher', 'hcallacher5@foxnews.com', '6483664948'),
    ('Fabien', 'Hurley', 'fhurley6@dagondesign.com', '3663230729'),
    ('Josselyn', 'Wetheril', 'jwetheril7@si.edu', '2969722429'),
    ('Andeee', 'Antonoyev', 'aantonoyev8@arstechnica.com', '2537545180'),
    ('Jordain', 'Mowat', 'jmowat9@dyndns.org', '5508961764'),
    ('Kellby', 'Kloster', 'kklostera@shutterfly.com', '3688190644'),
    ('Sylvan', 'Pursglove', 'spursgloveb@google.com.br', '7328976728'),
    ('Lucita', 'Castel', 'lcastelc@cnet.com', '3416202535'),
    ('Kenneth', 'Agerskow', 'kagerskowd@yellowpages.com', '5597424188'),
    ('Tab', 'Mottley', 'tmottleye@soundcloud.com', '9356485916');

INSERT INTO RoomTypes (description)
VALUES
    ('Lite'),
    ('Standard'),
    ('Deluxe'),
    ('Exclusive');

INSERT INTO Rooms (room_id, room_type, occupancy_limit, price_per_night)
VALUES
    (101, 1, 1, 165.00),
    (102, 4, 5, 810.00),
    (201, 4, 6, 2172.00),
    (202, 3, 2, 815.00),
    (203, 2, 6, 108.00),
    (301, 3, 2, 546.00),
    (302, 3, 5, 127.00),
    (401, 4, 5, 1062.00),
    (501, 1, 3, 227.00),
    (502, 3, 2, 682.00);

INSERT INTO Bookings (guest_id, room_id, check_in_date, check_out_date)
VALUES
    (4, 101, '2021-06-22 14:00:00', '2021-08-10 12:00:00'),
    (9, 301, '2020-07-12 14:00:00', '2020-07-23 12:00:00'),
    (8, 301, '2018-11-17 14:00:00', '2018-11-30 12:00:00'),
    (7, 202, '2020-07-05 14:00:00', '2020-07-06 12:00:00'),
    (6, 101, '2022-04-01 14:00:00', '2022-04-03 12:00:00'),
    (5, 501, '2018-12-15 14:00:00', '2018-12-29 12:00:00'),
    (4, 101, '2022-10-26 14:00:00', '2022-10-29 12:00:00'),
	(4, 101, '2023-08-27 14:00:00', '2023-08-29 12:00:00'),
    (9, 302, '2023-08-26 14:00:00', '2023-08-30 12:00:00'),
    (8, 301, '2023-08-15 14:00:00', '2023-08-31 12:00:00');

INSERT INTO Payments (booking_id, payment_date, amount)
VALUES
    (1, '2021-06-22', 8580),
    (2, '2020-07-12', 6006),
    (3, '2018-11-16', 7098),
    (4, '2020-07-04', 815),
    (5, '2022-04-01', 331),
    (6, '2018-12-15', 3188),
    (7, '2022-10-26', 496);

INSERT INTO Amenities (description)
VALUES
    ('Free WIFI'),
    ('Mini-bar'),
    ('Kettle'),
    ('Breakfast included'),
    ('Refrigerator'),
    ('Television');

INSERT INTO RoomAmenities (room_id, amenity_id)
VALUES
    (101, 1),
    (102, 1),
    (102, 3),
    (102, 5),
    (102, 6),
    (201, 1),
    (201, 2),
    (201, 3),
    (201, 4),
    (201, 5),
    (201, 6),
    (202, 1),
    (202, 2),
    (202, 5),
    (301, 4),
    (301, 5),
    (301, 6),
    (302, 6),
    (401, 1),
    (401, 2),
    (401, 3),
    (401, 4),
    (401, 5),
    (401, 6),
    (501, 1),
    (502, 1),
    (502, 2);

INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES
    (4, 101, 'Great room.', 4.5, '2021-07-15'),
    (9, 301, 'Had a pleasant stay.', 4.0, '2020-07-30'),
    (8, 301, 'Service could be improved.', 3.0, '2019-01-20'),
    (7, 202, 'Room was clean.', 4.2, '2020-07-06'),
    (6, 101, 'Definitely coming back!', 5.0, '2022-04-02'),
    (5, 501, 'Room was dirty.', 3.5, '2018-12-25'),
    (4, 101, 'Room service could be improved.', 3.8, '2022-10-28');
