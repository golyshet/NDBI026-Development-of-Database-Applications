--- The hotel and its reservation system - Creation of the whole schema.

--Stored procedure for allowing late check-out with penalty
CREATE PROCEDURE LateCheckOut
    @booking_id INT
AS
BEGIN
    DECLARE @check_out_date DATETIME;
    DECLARE @price_per_night DECIMAL(10, 2);
    DECLARE @penalty DECIMAL(10, 2);

    SELECT @check_out_date = check_out_date
    FROM Bookings
    WHERE booking_id = @booking_id;

    SELECT @price_per_night = price_per_night
    FROM Rooms R
    INNER JOIN Bookings B ON R.room_id = B.room_id
    WHERE B.booking_id = @booking_id;

    --Calculate penalty if it is needed
    IF GETDATE() > @check_out_date
    BEGIN
        DECLARE @hours_difference INT;
        SET @hours_difference = DATEDIFF(HOUR, @check_out_date, GETDATE());

        --Calculate penalty: guest pays 10% of the price per night for each hour of delay
        SET @penalty = @price_per_night * 0.10 * @hours_difference;
    END
    ELSE
    BEGIN
        SET @penalty = 0;
    END;

 --Insert penalty payment if it is needed
 IF @penalty > 0
    BEGIN
        INSERT INTO Payments(booking_id, payment_date, amount)
        VALUES (@booking_id, GETDATE(), @penalty);
    END;
END;
GO

-- Stored procedure for changing room price by a certain percentage
CREATE PROCEDURE ChangeRoomPrice
    @room_type_id INT,
    @percent_change INT
AS
BEGIN
    --Check if percentage is non-zero
    IF @percent_change = 0
    BEGIN
        RAISERROR('Percentage must be non-zero.', 16, 1);
        RETURN;
    END;

    --Calculate the full percentage
    DECLARE @full_percent DECIMAL(10, 2) = 1 + (@percent_change / CAST(100 AS FLOAT));

    --Update the price per night of all rooms of the given type
    UPDATE Rooms
    SET price_per_night = price_per_night * @full_percent
    WHERE room_type = @room_type_id;
END;
GO

--Stored procedure for canceling a booking
CREATE PROCEDURE CancelBooking
    @booking_id INT
AS
BEGIN
    DECLARE @cancellation_fee DECIMAL(10, 2);
    DECLARE @total_amount DECIMAL(10, 2);
    DECLARE @room_id INT;
    DECLARE @check_in_date DATE;
	DECLARE @check_out_date DATE;
	DECLARE @days_count INT;
	DECLARE @price_per_night INT;

    --Check if booking exists and is not canceled
    IF NOT EXISTS (SELECT 1 FROM Bookings WHERE booking_id = @booking_id)
    BEGIN
        RAISERROR('Booking not found.', 16, 1);
        RETURN;
    END;
	ELSE IF ((SELECT booking_status FROM Bookings WHERE booking_id = @booking_id) = 'Canceled')
	BEGIN
        RAISERROR('Booking already canceled.', 16, 1);
        RETURN;
    END;

	--Get the total amount of the booking
    SELECT @total_amount = amount FROM Payments WHERE booking_id = @booking_id;

    SELECT @check_in_date = check_in_date, @room_id = room_id, @check_out_date = check_out_date
    FROM Bookings WHERE booking_id = @booking_id;

	SELECT @price_per_night = price_per_night FROM Rooms WHERE room_id = @room_id;

	SET @days_count = DATEDIFF(DAY, @check_in_date, @check_out_date);

	SET @total_amount = @days_count * @price_per_night;

    --Calculate the cancellation fee based on the number of days left until check-in
    --If there are more than 3 days left, the cancellation fee is 0
    IF DATEDIFF(DAY, GETDATE(), @check_in_date) >= 4
    BEGIN
        SET @cancellation_fee = 0.00;
    END
    --If there are 1-3 days left, the cancellation fee is price per night
    ELSE IF DATEDIFF(DAY, GETDATE(), @check_in_date) > 1
    BEGIN
        SET @cancellation_fee = @price_per_night;
    END
    --Otherwise, the cancellation fee is the total amount of the booking
    ELSE
    BEGIN
        SET @cancellation_fee = @total_amount;
    END;

    --Update the booking status and insert the cancellation fee payment if it is needed
	UPDATE Bookings SET booking_status = 'Canceled' WHERE booking_id = @booking_id;
	
	IF @cancellation_fee > 0
	BEGIN
		INSERT INTO Payments (booking_id, payment_date, amount)
		VALUES (@booking_id, GETDATE(), @cancellation_fee);
	END;
END;
GO

--Stored procedure for adding an amenity to a room
CREATE PROCEDURE AddRoomAmenity
    @room_id INT,
    @amenity_id INT
AS
BEGIN
    --Check if room and amenity exist
	IF NOT EXISTS (SELECT 1 FROM Rooms WHERE room_id = @room_id)
    BEGIN
        RAISERROR('Room not found.', 16, 1);
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM Amenities WHERE amenity_id = @amenity_id)
    BEGIN
        RAISERROR('Amenity not found.', 16, 1);
        RETURN;
    END;

    --Check if amenity is already added to the room
    IF EXISTS (SELECT 1 FROM RoomAmenities WHERE room_id = @room_id AND amenity_id = @amenity_id)
    BEGIN
        RAISERROR('Amenity is already added to the room.', 16, 1);
        RETURN;
    END;

    --Check if room is available
	IF NOT EXISTS (
            SELECT 1
            FROM Bookings B
            WHERE B.room_id = @room_id
              AND NOT (GETDATE() <= B.check_in_date OR GETDATE() >= B.check_out_date)
        )
		    INSERT INTO RoomAmenities (room_id, amenity_id) VALUES (@room_id, @amenity_id);
    ELSE
    BEGIN
        RAISERROR('Amenities can be added only to an available room.', 16, 1);
        RETURN;
    END;
END;
GO

-- Stored procedure for getting room reviews by room id
CREATE PROCEDURE GetRoomReviews
    @room_id INT
AS
BEGIN
    --Check if room exists
    IF NOT EXISTS (SELECT 1 FROM Rooms WHERE room_id = @room_id)
    BEGIN
        RAISERROR('Room not found.', 16, 1);
        RETURN;
    END;

    --Get all reviews for the room
    SELECT review_id, guest_id, review_text, rating, review_date
    FROM RoomReviews
    WHERE room_id = @room_id
    ORDER BY review_date DESC;
END;
GO

--Function for checking if an amenity is available in a room
CREATE FUNCTION IsAmenityAvailableInRoom
(
    @room_id INT,
    @amenity_id INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @is_available BIT;

    --Check if amenity is available in the room
    IF EXISTS (
        SELECT 1
        FROM RoomAmenities
        WHERE room_id = @room_id AND amenity_id = @amenity_id
    )
    BEGIN
        SET @is_available = 1;
    END
    ELSE
    BEGIN
        SET @is_available = 0;
    END;

    RETURN @is_available;
END;
GO

--Function for getting the total proceeds for a month
CREATE FUNCTION GetTotalProceedsByMonth
(
    @year INT,
    @month INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @totalProceeds DECIMAL(10, 2);

    --Get the total proceeds for the month for selected year
    SELECT @totalProceeds = COALESCE(SUM(amount), 0)
    FROM Payments P
    INNER JOIN Bookings B ON P.booking_id = B.booking_id
    WHERE YEAR(B.check_in_date) = @year AND MONTH(B.check_in_date) = @month;

    RETURN @totalProceeds;
END;
GO

--Function for calculating the popularity of a room
CREATE FUNCTION CalculateRoomPopularity
(
    @roomId INT
)
RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @totalReviewsEachRoom INT;
    DECLARE @totalReviews INT;
    DECLARE @popularity DECIMAL(5, 2);

    --Total number of reviews for the room
    SELECT @totalReviewsEachRoom = COUNT(*)
    FROM RoomReviews
    WHERE room_id = @roomId;

    --Total number of reviews for all rooms
    SELECT @totalReviews = COUNT(*)
    FROM RoomReviews

    --Calculate the popularity of the room: total number of reviews for the room / total number of reviews for all rooms
    IF @totalReviewsEachRoom > 0
    BEGIN
        SET @popularity = CAST(@totalReviewsEachRoom AS FLOAT) / @totalReviews;
    END
    ELSE

    BEGIN
        SET @popularity = 0;
    END;

    RETURN @popularity;
END;
GO
