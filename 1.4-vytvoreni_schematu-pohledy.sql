--- The hotel and its reservation system - Creation of the whole schema.

--View for available rooms: room without bookings or with bookings that have already ended.
--Employees can use this view to see which rooms are available for new bookings.
CREATE VIEW AvailableRoomsView AS
SELECT
    R.room_id,
    R.occupancy_limit,
    R.price_per_night
FROM
    Rooms R
LEFT JOIN (
    SELECT room_id, MAX(check_out_date) AS last_check_out
    FROM Bookings
    GROUP BY room_id
) B ON R.room_id = B.room_id
WHERE
	B.last_check_out <= GETDATE() OR R.room_id NOT IN (
	SELECT DISTINCT 
	room_id 
	FROM Bookings);
GO

--A better option
CREATE VIEW AvailableRoomsViewUPDATE AS
SELECT
    R.room_id,
    R.occupancy_limit,
    R.price_per_night
FROM
    Rooms R
LEFT OUTER JOIN Bookings B ON R.room_id = B.room_id
GROUP BY
    R.room_id,
    R.occupancy_limit,
    R.price_per_night
HAVING
    MAX(B.check_out_date) <= GETDATE() OR COUNT(B.room_id) = 0;
GO

--View for current bookings: bookings guests who are currently staying at the hotel.
--Employees can use this view to see which guests are currently staying at the hotel.
CREATE VIEW CurrentBookingsView AS
SELECT
    G.guest_id,
    G.first_name,
    G.last_name,
    G.email,
    G.phone,
    B.booking_id,
    B.check_in_date,
    B.check_out_date,
    R.room_id,
    R.occupancy_limit,
    R.price_per_night,
    RT.description AS room_type
FROM
    Guests G
LEFT JOIN
    Bookings B ON G.guest_id = B.guest_id
LEFT JOIN
    Rooms R ON B.room_id = R.room_id
LEFT JOIN
    RoomTypes RT ON R.room_type = RT.room_type_id
WHERE
    B.check_out_date >= GETDATE() AND B.check_in_date <= GETDATE();
GO

--View for guests with past stays: guests who have stayed at the hotel more time.
--Employees can use this view for better customer service.
CREATE VIEW GuestPastStaysWithReviewsView AS
SELECT
    G.guest_id,
    G.first_name,
    G.last_name,
    R.room_id AS past_room_number,
    RR.review_id,
    RR.review_text,
    RR.rating,
    RR.review_date
FROM
    Guests G
JOIN
    Bookings B ON G.guest_id = B.guest_id
JOIN
    Rooms R ON B.room_id = R.room_id
JOIN
    RoomReviews RR ON R.room_id = RR.room_id
WHERE
    B.check_out_date >= GETDATE() AND B.check_in_date <= GETDATE()
    AND G.guest_id IN
    (
        SELECT G.guest_id
        FROM Guests G
        JOIN Bookings B ON G.guest_id = B.guest_id
        WHERE B.check_out_date <= GETDATE()
        AND G.guest_id IN
        (
            SELECT G.guest_id
            FROM Guests G
            JOIN Bookings B ON G.guest_id = B.guest_id
            GROUP BY G.guest_id
            HAVING COUNT(*) > 1
        )
    )
GO

--View rooms with amenities: rooms with their amenities.
--Employees can use this view to see which amenities are available in each room for better customer service.
CREATE VIEW RoomsWithAmenitiesView AS
SELECT
    R.room_id,
    R.occupancy_limit,
    R.price_per_night,
    RT.description AS room_type,
    STRING_AGG(A.description, ', ') AS amenity_descriptions
FROM
    Rooms R
LEFT JOIN
    RoomTypes RT ON R.room_type = RT.room_type_id
LEFT JOIN
    RoomAmenities RA ON R.room_id = RA.room_id
LEFT JOIN
    Amenities A ON RA.amenity_id = A.amenity_id
GROUP BY
    R.room_id,
    R.occupancy_limit,
    R.price_per_night,
    RT.description;
GO

--View rooms with reviews: rooms with their reviews.
--Employees can use this view to see which reviews are available for each room for better customer service and marketing.
CREATE VIEW RoomsWithReviewsView AS
SELECT
    R.room_id,
    R.occupancy_limit,
    R.price_per_night,
    RT.description AS room_type,
    AVG(RR.rating) AS average_rating,
    COUNT(RR.review_id) AS total_reviews,
    STRING_AGG(RR.review_text, '   ') AS all_reviews
FROM
    Rooms R
LEFT JOIN
    RoomTypes RT ON R.room_type = RT.room_type_id
LEFT JOIN
    RoomReviews RR ON R.room_id = RR.room_id
GROUP BY
    R.room_id,
    R.occupancy_limit,
    R.price_per_night,
    RT.description;
GO

--View guests with bookings and payments: guests with their bookings information and payments.
--Employees can use this view to see which guests have made payments for their bookings.
CREATE VIEW GuestBookingsWithPaymentsView AS
SELECT
    G.guest_id,
    G.first_name,
    G.last_name,
    B.booking_id,
    B.check_in_date,
    B.check_out_date,
    R.room_id,
    R.price_per_night,
    RT.description AS room_type,
    P.payment_id,
    P.payment_date,
    P.amount
FROM
    Guests G
LEFT JOIN
    Bookings B ON G.guest_id = B.guest_id
LEFT JOIN
    Rooms R ON B.room_id = R.room_id
LEFT JOIN
    RoomTypes RT ON R.room_type = RT.room_type_id
LEFT JOIN
    Payments P ON B.booking_id = P.booking_id;
GO

--View for popular rooms: rooms with popularity greater than 0.2.
--Employees can use this view to see which rooms are popular for better marketing and recommending.
CREATE VIEW PopularRoomsView AS
SELECT
    R.room_id,
    R.room_type,
    R.occupancy_limit,
    R.price_per_night,
    R.average_rating,
    R.popularity
FROM Rooms R
WHERE R.popularity >= 0.2;
GO

--View for guest history: guests with their past bookings.
--Employees can use this view to see which guests have stayed at the hotel in the past for better customer service.
CREATE VIEW GuestHistory AS
SELECT
	B.guest_id,
    B.booking_id,
    B.check_in_date,
    B.check_out_date,
    R.room_id,
    R.room_type,
    R.price_per_night,
    R.average_rating
FROM
    Bookings B
INNER JOIN
    Rooms R ON B.room_id = R.room_id
WHERE
    B.check_out_date <= GETDATE();
GO