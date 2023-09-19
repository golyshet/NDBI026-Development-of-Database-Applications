--- The hotel and its reservation system - Creation of the whole schema.

--Trigger fot creating a new booking
CREATE TRIGGER CreateBooking
ON Bookings
INSTEAD OF INSERT
AS
BEGIN
    --Variables to store the inserted values
    DECLARE @InsertedGuestID INT, @InsertedRoomID INT, @InsertedCheckIn DATETIME, @InsertedCheckOut DATETIME;

    --Cursor to loop through the inserted rows
    DECLARE BookingCursor CURSOR FOR
    SELECT 
		I.guest_id,
        I.room_id,
        I.check_in_date,
        I.check_out_date
    FROM INSERTED I;

    OPEN BookingCursor;

    --Fetch the row
    FETCH NEXT FROM BookingCursor INTO @InsertedGuestID, @InsertedRoomID, @InsertedCheckIn, @InsertedCheckOut;

    --Loop through the rows
    WHILE @@FETCH_STATUS = 0
    BEGIN
        --Check for NULL values and other constraints
		IF @InsertedGuestID IS NULL
		BEGIN
			RAISERROR('Column guest_id cannot be NULL.', 16, 1);
		END;
		ELSE IF @InsertedRoomID IS NULL
		BEGIN
			RAISERROR('Column room_id cannot be NULL.', 16, 1);
		END;
		ELSE IF @InsertedCheckIn IS NULL
		BEGIN
			RAISERROR('Column check_in_date cannot be NULL.', 16, 1);
		END;
		ELSE IF @InsertedCheckOut IS NULL
		BEGIN
			RAISERROR('Column check_out_date cannot be NULL.', 16, 1);
		END;
		ELSE IF @InsertedCheckOut <= @InsertedCheckIn
		BEGIN
			RAISERROR('Checkout date cannot be less than check in date.', 16, 1);
		END;
        --Check for conflicts: if there is a booking for the same room in the same period, the booking is not inserted
        ELSE IF NOT EXISTS (
            SELECT 1
            FROM Bookings B
            WHERE B.room_id = @InsertedRoomID
				AND B.booking_status = 'Confirmed' 
				AND NOT (@InsertedCheckOut <= B.check_in_date OR @InsertedCheckIn >= B.check_out_date)
        )
        BEGIN
            --Insert the row if there are no conflicts
            INSERT INTO Bookings (guest_id, room_id, check_in_date, check_out_date, booking_status)
			VALUES (@InsertedGuestID, @InsertedRoomID, @InsertedCheckIn, @InsertedCheckOut, 'Confirmed'); 
            PRINT 'Booking inserted successfully. Guest ID: ' + CAST(@InsertedGuestID AS VARCHAR(10)) + ';';
        END
        ELSE
        BEGIN
            RAISERROR('Room is unavailable for booking.', 16, 1);
        END;

        --Fetch the next row
        FETCH NEXT FROM BookingCursor INTO @InsertedGuestID, @InsertedRoomID, @InsertedCheckIn, @InsertedCheckOut;
    END;

    --Close and deallocate the cursor
    CLOSE BookingCursor;
    DEALLOCATE BookingCursor;
END;
GO

--Trigger for updating average rating after a review is inserted or deleted
CREATE TRIGGER UpdateAverageRating
ON RoomReviews
AFTER INSERT, DELETE
AS
BEGIN
    DECLARE @roomId INT;

    --Cursor to loop through the room id
	DECLARE RoomReviewCursor CURSOR FOR
	SELECT 
		I.room_id
	FROM INSERTED I
	UNION
	SELECT
		D.room_id
	FROM DELETED D;

	OPEN RoomReviewCursor;

	FETCH NEXT FROM RoomReviewCursor INTO @roomId;

	WHILE @@FETCH_STATUS = 0
	BEGIN
	    --Update the average rating for the room
		UPDATE Rooms
		SET average_rating = (
			SELECT AVG(rating)
			FROM RoomReviews
			WHERE room_id = @roomId
		)
		WHERE room_id = @roomId;

		FETCH NEXT FROM RoomReviewCursor INTO @roomId;
	END;

	CLOSE RoomReviewCursor;
	DEALLOCATE RoomReviewCursor;
END;
GO

--Trigger for updating room popularity after a review is inserted or deleted
CREATE TRIGGER UpdateRoomPopularity
ON RoomReviews
AFTER INSERT, DELETE
AS
BEGIN
	DECLARE @roomId INT;

	DECLARE RoomPopularityCursor CURSOR FOR
	SELECT 
		R.room_id
	FROM Rooms R;

	OPEN RoomPopularityCursor;

	FETCH NEXT FROM RoomPopularityCursor INTO @roomId;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    --Update the room popularity
		UPDATE Rooms
		SET popularity = u14043439.CalculateRoomPopularity(@roomId)
		WHERE room_id = @roomId;

		FETCH NEXT FROM RoomPopularityCursor INTO @roomId;
	END;
		
	CLOSE RoomPopularityCursor;
	DEALLOCATE RoomPopularityCursor;
END;
GO


