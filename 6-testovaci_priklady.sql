--- The hotel and its reservation system - test script that would demonstrate the functionality.

-- Please, run the script 2.0 with demo-data before running this script.

--- Tests of integrity constraints ---

----------------------Guests Table-------------------------

--first_name column cannot be NULL
INSERT INTO Guests (first_name, last_name, email, phone)
VALUES (NULL, 'Po', 'rh@bba.com', '9184506614');

--last_name column cannot be NULL
INSERT INTO Guests (first_name, last_name, email, phone)
VALUES ('Bug', NULL, 'rh@bba.com', '9184506614');
--Cannot insert the value NULL into column 'last_name', table 'student.u14043439.Guests'; column does not allow nulls. INSERT fails.

--email column cannot be NULL
INSERT INTO Guests (first_name, last_name, email, phone)
VALUES ('Bug', 'Po', NULL, '9184506614');

--phone column cannot be NULL
INSERT INTO Guests (first_name, last_name, email, phone)
VALUES ('Bug', 'Po', 'rh@bba.com', NULL);

--Invalid e-mail address
INSERT INTO Guests (first_name, last_name, email, phone)
VALUES ('Bug', 'Po', '@bba.com', '7184506614');
--The INSERT statement conflicted with the CHECK constraint "CK__Guests__email__008BB26A". The conflict occurred in database "student", table "u14043439.Guests", column 'email'.

--Existing phone number
INSERT INTO Guests (first_name, last_name, email, phone)
VALUES ('Bug', 'Po', 'l@bba.com', '8184506614');
--Violation of UNIQUE KEY constraint 'UQ__Guests__B43B145FA5792F15'. Cannot insert duplicate key in object 'u14043439.Guests'. The duplicate key value is (8184506614).

--Existing e-mail address
INSERT INTO Guests (first_name, last_name, email, phone)
VALUES ('Bug', 'Po', 'rharrop0@phpbba.com', '6184506614');
--Violation of UNIQUE KEY constraint 'UQ__Guests__AB6E616431FA70CF'. Cannot insert duplicate key in object 'u14043439.Guests'. The duplicate key value is (rharrop0@phpbba.com).
-----------------------------------------------------------

-----------------RoomTypes Table---------------------------

--Room Type description cannot be NULL
INSERT INTO RoomTypes (description)
VALUES (NULL);
--Cannot insert the value NULL into column 'description', table 'student.u14043439.RoomTypes'; column does not allow nulls. INSERT fails.
-----------------------------------------------------------

---------------------Rooms Table---------------------------

--room_type column cannot be NULL
INSERT INTO Rooms (room_id, room_type, occupancy_limit, price_per_night)
VALUES (101, NULL, 1, 165.00);
--Cannot insert the value NULL into column 'room_type', table 'student.u14043439.Rooms'; column does not allow nulls. INSERT fails.

--occupancy_limit column cannot be NULL
INSERT INTO Rooms (room_id, room_type, occupancy_limit, price_per_night)
VALUES (101, 1, NULL, 165.00);
--Cannot insert the value NULL into column 'occupancy_limit', table 'student.u14043439.Rooms'; column does not allow nulls. INSERT fails.

--price_per_night column cannot be NULL
INSERT INTO Rooms (room_id, room_type, occupancy_limit, price_per_night)
VALUES (101, 1, 1, NULL);
--Cannot insert the value NULL into column 'price_per_night', table 'student.u14043439.Rooms'; column does not allow nulls. INSERT fails.
-----------------------------------------------------------

--------------------Bookings Table-------------------------

--guest_id column cannot be NULL
INSERT INTO Bookings (guest_id, room_id, check_in_date, check_out_date)
VALUES (NULL, 101, '2021-06-22 14:00:00', '2021-08-10 12:00:00');

--room_id column cannot be NULL
INSERT INTO Bookings (guest_id, room_id, check_in_date, check_out_date)
VALUES (4, NULL, '2021-06-22 14:00:00', '2021-08-10 12:00:00');
--Cannot insert the value NULL into column 'room_id', table 'student.u14043439.Bookings'; column does not allow nulls. INSERT fails.

--check_in_date column cannot be NULL
INSERT INTO Bookings (guest_id, room_id, check_in_date, check_out_date)
VALUES (4, 101, NULL, '');

--check_out_date column cannot be NULL
INSERT INTO Bookings (guest_id, room_id, check_in_date, check_out_date)
VALUES (4, 101, '2021-06-22 14:00:00', NULL);

--Checkout date cannot be less than check in date
INSERT INTO Bookings (guest_id, room_id, check_in_date, check_out_date)
VALUES (4, 101, '2021-08-10 12:00:00', '2021-06-22 14:00:00');
-----------------------------------------------------------

--------------------Payments Table-------------------------

--booking_id column cannot be NULL
INSERT INTO Payments (booking_id, payment_date, amount)
VALUES (NULL, '2021-06-22', 8580);

--payment_date column cannot be NULL
INSERT INTO Payments (booking_id, payment_date, amount)
VALUES (1, NULL, 8580);

--amount column cannot be NULL
INSERT INTO Payments (booking_id, payment_date, amount)
VALUES (1, '2021-06-22', NULL);
-----------------------------------------------------------

-------------------Amenities Table-------------------------

--Amenities description cannot be NULL
INSERT INTO Amenities (description)
VALUES (NULL);
-----------------------------------------------------------

----------------RoomAmenities Table------------------------

--room_id column cannot be NULL
INSERT INTO RoomAmenities (room_id, amenity_id)
VALUES (NULL, 1);

--amenity_id column cannot be NULL
INSERT INTO RoomAmenities (room_id, amenity_id)
VALUES (101, NULL);
-----------------------------------------------------------

------------------RoomReviews Table------------------------

--guest_id collumn cannot be NULL
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (NULL, 101, 'Great room.', 4.5, '2021-07-15');

--room_id collumn cannot be NULL
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (4, NULL, 'Great room.', 4.5, '2021-07-15');

--rating collumn cannot be NULL
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (4, 101, 'Great room.', NULL, '2021-07-15');

--review_date collumn cannot be NULL
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (4, 101, 'Great room.', 4.5, NULL);

--Rating cannot be less than 1
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (4, 101, 'Great room.', 0, '2021-07-15');

--Rating cannot be greater than 1
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (4, 101, 'Great room.', 6, '2021-07-15');
-----------------------------------------------------------


--- Tests of triggers ---

---------------------CreateBooking-------------------------

--Bookings overlaping (cannot create the booking for the room, if the dates of new booking overlaps with exisiting bookings for this room)

--Delete any bookings for the room 201 for testing purposes
DELETE FROM Bookings WHERE room_id = 201
--Create a new booking for this room
INSERT INTO Bookings(guest_id, room_id, check_in_date, check_out_date)
VALUES (1, 201, '2023-12-01 12:00', '2023-12-15 12:00')
--Try to create one more booking that overlaps with existing one
--Getting an error 'Room is unavailable for booking.'
INSERT INTO Bookings(guest_id, room_id, check_in_date, check_out_date)
VALUES (2, 201, '2023-12-08 12:00', '2023-12-18 12:00')
-----------------------------------------------------------

---------------------UpdateAverageRating-------------------------

--Checking the correctness of an UpdateAverageRating trigger, that must update the average rating of a room based on the reviews of this room.

DELETE FROM RoomReviews WHERE room_id = 102
--Let's take the room, that doesn't have reviews yet. The result must be NULL
SELECT average_rating FROM Rooms WHERE room_id = 102
--Add new room review for this room
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (4, 102, 'Everything was amazing!', 5, '2021-07-15');
--Check the room rating. It must 5 for now
SELECT average_rating FROM Rooms WHERE room_id = 102
--Add another review
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (1, 102, 'Good', 4, '2022-03-05');
--Check the rating again. Now the rating should be the average of two reviews with ratings 5 and 4. In total (5 + 4) / 2 = 4.5
SELECT average_rating FROM Rooms WHERE room_id = 102
-----------------------------------------------------------

---------------------UpdateRoomPopularity-------------------------

--Checking the correctness of an UpdateRoomPopularity trigger, that must update the room popularity.
--Room popularity is the ratio of reviews for this room to the totalnumber of reviews.

--Let'ss see how the rooms popularities looks now
SELECT * FROM Rooms
--Now let's see how much reviews there are in total and how much reviews are there for the room with room_id = 102
--As the result we must get 9 as the total number of reviews and 2 as reviews number for room 102. 2/9 = 0.22 which is the same,
--that we have in column 'popularity' for room_id = 102 from the SELECT statement above
SELECT COUNT(*) AS TotalReviewsCount FROM RoomReviews
SELECT COUNT(*) AS ReviewsForRoom102 FROM RoomReviews WHERE room_id = 102
--Let's add one new review for the room 102. Now the total number of revies is 10 and the number of reviews for room 102 is 3. The result must be 3/10 = 0.30
INSERT INTO RoomReviews (guest_id, room_id, review_text, rating, review_date)
VALUES (2, 102, 'Was dirty', 3.5, '2022-03-05');
SELECT popularity FROM Rooms WHERE room_id = 102
--And also we can take a look at the other rooms popularities and ensure, that they are also has been changed
SELECT * FROM Rooms
--Now lets delete the last inserted review, so the testing script is consistent
DELETE FROM RoomReviews
WHERE review_id = (
    SELECT MAX(review_id)
    FROM RoomReviews
);
--And we can also take a look at the rooms popularities again. We can see that they are returned to the initial state.
SELECT * FROM Rooms
-----------------------------------------------------------


--- Tests of procedures and functions ---

----------------------LateCheckOut-------------------------

--This procedure must apply penalty in case of late check out. The penalty is 10% of price per night for each hour.

--Let's see the payments table
SELECT * FROM Payments
--And let's take a look on a Bookings table.The last booking has the check out date set to the december of 2023.
SELECT * FROM Bookings
--Now we can try to apply the LateCheckOut procedure to this booking and see what happened.
DECLARE @lastID INT;
SELECT @lastID = MAX(booking_id) FROM Bookings;
EXECUTE LateCheckOut @lastID
--As we can see, the payments table didn't changed.
SELECT * FROM Payments
--Now let's create new booking, that would have the checkout date, that have been expired 10 hours ago.
INSERT INTO Bookings(guest_id, room_id, check_in_date, check_out_date)
SELECT 1, 201, DATEADD(Day, -2, GETDATE()), DATEADD(HOUR, -10, GETDATE());
--Let's see if it was created.
SELECT * FROM Bookings
--Getting the id of newly created booking.
SELECT @lastID = MAX(booking_id) FROM Bookings;
--Executing the procuder for this booking.
EXECUTE LateCheckOut @lastID
--As the result we should see a new payment with booking_id = @lastID with the amount equals to 10 * 0.1 * price_per_nigght of the room 201.
--So in total the amount of penalty equals to price per one night at this room.
SELECT * FROM Payments
--And let's see the price per night at room 201. As we can see the result is correct!
SELECT price_per_night FROM Rooms WHERE room_id = 201
--And let's return the tables to the initial state for the testing script consistency
DELETE FROM Payments
WHERE booking_id = (
	SELECT MAX(booking_id)
	FROM Bookings
);
DELETE FROM Bookings
WHERE booking_id = (
	SELECT MAX(booking_id)
	FROM Bookings
);
-----------------------------------------------------------

----------------------ChangeRoomPrice----------------------

--This procedure changes the price of the rooms with specified room type

--Let's check the room prices for now
SELECT room_id, room_type, price_per_night FROM Rooms
--Now, let's increase the price of the rooms with room_type = 4
EXECUTE ChangeRoomPrice 4, 10
--Let's see the room prices now. As we can see the prices of a rooms with room_type = 4 are increased by 10%
SELECT room_id, room_type, price_per_night FROM Rooms
--Return the room prices to their initial state
UPDATE Rooms SET price_per_night = price_per_night / 1.1 WHERE room_type = 4
SELECT room_id, room_type, price_per_night FROM Rooms

--The percentage cannot be zero. Getting an error
EXECUTE ChangeRoomPrice 4, 0
-----------------------------------------------------------


----------------------CancelBooking------------------------

--Cancels the booking and applies the fee. After the cancelation there would be a new payment connected with this booking,
--tgat wiuld represent the amount was returned to the guest. If refunded amount is equals to 0, there is no new payments in the table.

 --Let's try to cancel the not-existing booking.
 DECLARE @n_id DECIMAL(10,2)
 SELECT @n_id = MAX(booking_id) + 1 FROM Bookings;
 --We must get the error, that such booking not found
 EXECUTE CancelBooking @n_id

 --Now, let's create 3 new bookings. 
 --First one would have check-in in a week
INSERT INTO Bookings(guest_id, room_id, check_in_date, check_out_date)
SELECT 2, 201, DATEADD(Day, 7, GETDATE()), DATEADD(Day, 10, GETDATE());
 --Second one would have check-in in 3 days
INSERT INTO Bookings(guest_id, room_id, check_in_date, check_out_date)
SELECT 3, 101, DATEADD(Day, 3, GETDATE()), DATEADD(Day, 5, GETDATE());
 --And the last one would have check-in in 12 hours
INSERT INTO Bookings(guest_id, room_id, check_in_date, check_out_date)
SELECT 4, 301, DATEADD(HOUR, 12, GETDATE()), DATEADD(Day, 2, GETDATE());
--Let's see, that those bookings are added
SELECT * FROM Bookings

--Now, let's try to cancel those bookings
SELECT @n_id = MAX(booking_id) - 2 FROM Bookings;
EXECUTE CancelBooking @n_id;
SELECT @n_id = MAX(booking_id) - 1 FROM Bookings;
EXECUTE CancelBooking @n_id;
SELECT @n_id = MAX(booking_id) FROM Bookings;
EXECUTE CancelBooking @n_id;
--Let's see on the Payments table
SELECT * FROM Payments;
SELECT * FROM Bookings;

--Now those booking are canceled. Let's try to cancel some of them again. We must get error, that booking is already canceled.
EXECUTE CancelBooking @n_id;

--And let's return the Payemnts and Bookings table to their initial state
SELECT @n_id = MAX(booking_id) FROM Bookings;
DELETE FROM Payments WHERE booking_id = @n_id;
DELETE FROM Bookings WHERE booking_id = @n_id;

SELECT @n_id = MAX(booking_id) FROM Bookings;
DELETE FROM Payments WHERE booking_id = @n_id;
DELETE FROM Bookings WHERE booking_id = @n_id;

SELECT @n_id = MAX(booking_id) FROM Bookings;
DELETE FROM Payments WHERE booking_id = @n_id;
DELETE FROM Bookings WHERE booking_id = @n_id;

SELECT * FROM Payments;
SELECT * FROM Bookings;
-----------------------------------------------------------

---------------------AddRoomAmenity------------------------

--Adds the amenity to the specified room

--Not-existing room
EXECUTE AddRoomAmenity 0, 0
--Not-existing amenity
EXECUTE AddRoomAmenity 101, 100
--The room is already have this amenity
EXECUTE AddRoomAmenity 101, 1
--Add new booking
INSERT INTO Bookings(guest_id, room_id, check_in_date, check_out_date)
SELECT 2, 101, GETDATE(), DATEADD(Day, 2, GETDATE());
--Check the booking
SELECT * FROM Bookings WHERE room_id = 101
--Let's see what amenities does this room have
SELECT * FROM RoomAmenities WHERE room_id = 101
--We can see, that there is only amenity with id 1 is present for this room
--Let's try to add some other. We should end up with an error. It is because the room must be free to add the amenity
EXECUTE AddRoomAmenity 101, 2
--We can delete the previously created booking and try to add amenity again.
SELECT @n_id = MAX(booking_id) FROM Bookings;
DELETE FROM Bookings WHERE booking_id = @n_id;
EXECUTE AddRoomAmenity 101, 2
--And let's take a look on the amenities again. We can see, that now room 101 has amenities 1 and 2
SELECT * FROM RoomAmenities WHERE room_id = 101
--And now let's return the amenitites table to it's initial state
DELETE FROM RoomAmenities WHERE room_id = 101 AND amenity_id = 2
-----------------------------------------------------------

---------------------GetRoomReviews------------------------

--Returns the reviews for the specified room

--Not-existing room
EXECUTE GetRoomReviews 1

--Get all reviews
EXECUTE GetRoomReviews 101
-----------------------------------------------------------

----------------IsAmenityAvailableInRoom-------------------

--Returns 1 if amenity is available in the room and 0 otherwise

SELECT u14043439.IsAmenityAvailableInRoom(101, 1) AS Room101Amenity1
SELECT u14043439.IsAmenityAvailableInRoom(101, 2) AS Room101Amenity2
-----------------------------------------------------------

------------------GetTotalProceedsByMonth------------------

--Retruns the amount that was paid in this month

--Let's see on the Payments table.Let's take a look at the July of 2020. There are 2 payments with amounts 6006 and 815, which in total gives 6821 
SELECT * FROM Payments
--After running this function, the result is 6821, that is correct!
SELECT u14043439.GetTotalProceedsByMonth(2020, 7) AS JuleProceeds
-----------------------------------------------------------

------------------CalculateRoomPopularity------------------

--Calculates the popularity of a room based on the reviews

--Lets check the reviews for the room 102. there is only two.
EXECUTE GetRoomReviews 102
--Now lets see how much reviews there at all. As we can see, there is 9 reviews, which means the popularity of a room 102 must be 2/9 = 0.22
SELECT COUNT(*) AS TotlaReviewsCount FROM RoomReviews 
--Let's check the popularity of the room 102. It is 0.22, that is correct!
SELECT u14043439.CalculateRoomPopularity(102) AS Room102Popularity
-----------------------------------------------------------

--- Tests of views ---

-------------------AvailableRoomsView----------------------

--Returns a list of currently available rooms with their price and capacity

SELECT * FROM AvailableRoomsView
SELECT * FROM AvailableRoomsViewUPDATE
-----------------------------------------------------------

-------------------CurrentBookingsView---------------------

--Returns a list of bookings whose guests are at the hotel

SELECT * FROM CurrentBookingsView
-----------------------------------------------------------

---------------GuestPastStaysWithReviewsView---------------

--Returns a list of guests currently staying at the hotel who have already been at the hotel before, along with the feedback they left.

SELECT * FROM GuestPastStaysWithReviewsView
-----------------------------------------------------------

-------------------RoomsWithAmenitiesView------------------

--Returns information about the room with a list of amenities available in it

SELECT * FROM RoomsWithAmenitiesView
-----------------------------------------------------------

--------------------RoomsWithReviewsView-------------------

--Returns the rest of room along with rating and reviews

SELECT * FROM RoomsWithReviewsView

-----------------------------------------------------------

---------------GuestBookingsWithPaymentsView---------------

--Returns full information about the booking and payment, for example, for the selected room

SELECT * FROM GuestBookingsWithPaymentsView WHERE room_id = 101
--Сheck in date
SELECT * FROM GuestBookingsWithPaymentsView WHERE check_in_date = '2021-06-22 14:00:00'
--and so on
-----------------------------------------------------------

---------------------PopularRoomsView----------------------

--Returns a list of rooms that have popularity greater than or equal to 0.2 along with their rating

SELECT * FROM PopularRoomsView
-----------------------------------------------------------

------------------------GuestHistory-----------------------

--Returns a list of bookings for the selected guest

SELECT * FROM GuestHistory WHERE guest_id = 4;
-----------------------------------------------------------
