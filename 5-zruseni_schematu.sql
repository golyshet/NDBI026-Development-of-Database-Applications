-- The hotel and its reservation system - Dropping of the whole schema content

DROP VIEW AvailableRoomsView;
DROP VIEW CurrentBookingsView;
DROP VIEW GuestPastStaysWithReviewsView;
DROP VIEW RoomsWithAmenitiesView;
DROP VIEW RoomsWithReviewsView;
DROP VIEW GuestBookingsWithPaymentsView;
DROP VIEW PopularRoomsView;
DROP VIEW GuestHistory;

DROP PROCEDURE LateCheckOut;
DROP PROCEDURE ChangeRoomPrice;
DROP PROCEDURE CancelBooking;
DROP PROCEDURE AddRoomAmenity;
DROP PROCEDURE GetRoomReviews;

DROP TRIGGER CreateBooking;
DROP TRIGGER UpdateAverageRating;
DROP TRIGGER UpdateRoomPopularity;

DROP FUNCTION IsAmenityAvailableInRoom;
DROP FUNCTION GetTotalProceedsByMonth;
DROP FUNCTION CalculateRoomPopularity;

ALTER TABLE Rooms DROP CONSTRAINT FK_Rooms_RoomTypes;
ALTER TABLE Bookings DROP CONSTRAINT FK_Bookings_Guests;
ALTER TABLE Bookings DROP CONSTRAINT FK_Bookings_Rooms;
ALTER TABLE Payments DROP CONSTRAINT FK_Payments_Bookings;
ALTER TABLE RoomAmenities DROP CONSTRAINT FK_RoomAmenities_Rooms;
ALTER TABLE RoomAmenities DROP CONSTRAINT FK_RoomAmenities_Amenities;
ALTER TABLE RoomReviews DROP CONSTRAINT FK_RoomReviews_Guests;
ALTER TABLE RoomReviews DROP CONSTRAINT FK_RoomReviews_Rooms;

DROP TABLE Guests;
DROP TABLE RoomTypes;
DROP TABLE Rooms;
DROP TABLE Bookings;
DROP TABLE Payments;
DROP TABLE Amenities;
DROP TABLE RoomAmenities;
DROP TABLE RoomReviews;