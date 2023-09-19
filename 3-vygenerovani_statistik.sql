-- The hotel and its reservation system - Generating statistics

UPDATE STATISTICS Guests;
UPDATE STATISTICS RoomTypes;
UPDATE STATISTICS Rooms;
UPDATE STATISTICS Bookings;
UPDATE STATISTICS Payments;
UPDATE STATISTICS Amenities;
UPDATE STATISTICS RoomAmenities;
UPDATE STATISTICS RoomReviews;

CREATE STATISTICS CheckInDate_statistic ON Bookings (check_in_date) WITH FULLSCAN;
CREATE STATISTICS PricePerNight_statistic ON Rooms (price_per_night) WITH FULLSCAN;
CREATE STATISTICS Rating_statistic ON RoomReviews (rating) WITH FULLSCAN;


