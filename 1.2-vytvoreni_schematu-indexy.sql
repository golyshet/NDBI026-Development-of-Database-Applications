--- The hotel and its reservation system - Creation of the whole schema.

--Indexes for optimizing the queries

--Indexes for the Guest table
CREATE UNIQUE INDEX Guests_email ON Guests(email);
CREATE UNIQUE INDEX Guests_phone ON Guests(phone);

--Indexes for the Rooms table
CREATE INDEX Rooms_room_type ON Rooms(room_type);
CREATE INDEX Rooms_price_per_night ON Rooms(price_per_night);

--Indexes for the Bookings table
CREATE INDEX Bookings_guest_id ON Bookings(guest_id);
CREATE INDEX Bookings_room_id ON Bookings(room_id);
CREATE INDEX Bookings_check_in_date ON Bookings(check_in_date);
CREATE INDEX Bookings_check_out_date ON Bookings(check_out_date);

--Indexes for the Payments table
CREATE INDEX Payments_booking_id ON Payments(booking_id);
CREATE INDEX Payments_payment_date ON Payments(payment_date);

--Indexes for the RoomAmenities table
CREATE INDEX RoomAmenities_amenity_id ON RoomAmenities(amenity_id);

--Indexes for the RoomReviews table
CREATE INDEX RoomReviews_guest_id ON RoomReviews(guest_id);
CREATE INDEX RoomReviews_room_id ON RoomReviews(room_id);
CREATE INDEX RoomReviews_rating ON RoomReviews(rating);
CREATE INDEX RoomReviews_review_date ON RoomReviews(review_date);