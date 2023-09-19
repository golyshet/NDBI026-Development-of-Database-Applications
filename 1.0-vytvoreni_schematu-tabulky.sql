--- The hotel and its reservation system - Creation of the whole schema.

/**
The hotel and its reservation system.

The hotel provides accommodation services.

In order to make a reservation, the guest must provide information about himself: name, surname, phone number, email.

To create a booking, you must select a room, know the guest ID and the period of stay.

For a successful holiday, you need to pay for the reservation on the day of arrival or the day before for the convenience of guests.

For each room, certain amenities are available, which can be viewed in advance, its type, capacity,
as well as rating, popularity and of course the price per night.

It is also possible to view reviews in order to acsess the relevance of room ratings and choose the most successful option for yourself.

All IDs, except for the id of the room, since it is its number, will be generated automatically for the convenience of their use.

To create a booking in a specific room, it is required to be free in the se lected time interval.
The CreateBooking trigger is responsible for creating it.

Also, the room rating and its popularity are automatically recalculated when adding or deleting reviews.
The UpdateRoomPopularity and UpdateAverageRating triggers are responsible for this.

**/

--Table for storing guest information: id, first name, last name, email, phone number
CREATE TABLE Guests (
    guest_id INT IDENTITY(1,1) PRIMARY KEY CHECK (guest_id > 0),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email LIKE '%_@%_._%'),
    phone VARCHAR(20) UNIQUE NOT NULL
);

--Table for storing room types: id, description
CREATE TABLE RoomTypes (
    room_type_id INT IDENTITY(1,1) PRIMARY KEY CHECK (room_type_id > 0),
    description VARCHAR(100) NOT NULL
);

--Table for storing room information: id, type, occupancy limit, price per night, average rating, popularity
CREATE TABLE Rooms (
    room_id INT PRIMARY KEY CHECK (room_id > 0),
    room_type INT NOT NULL CHECK (room_type > 0),
    occupancy_limit INT NOT NULL CHECK (occupancy_limit > 0),
    price_per_night DECIMAL(10, 2)  NOT NULL CHECK (price_per_night > 0),
    average_rating DECIMAL(3, 2) NULL,
    popularity DECIMAL(3,2) NULL,
    CONSTRAINT FK_Rooms_RoomTypes FOREIGN KEY (room_type) REFERENCES RoomTypes (room_type_id)
);

--Table for storing booking information: id, guest id, room id, check in date, check out date, booking status
CREATE TABLE Bookings (
    booking_id INT IDENTITY(1,1) PRIMARY KEY CHECK (booking_id > 0),
    guest_id INT NOT NULL CHECK (guest_id > 0),
    room_id INT NOT NULL CHECK (room_id > 0),
	check_in_date DATETIME NOT NULL,
    check_out_date DATETIME NOT NULL,
	booking_status VARCHAR(20) DEFAULT 'Confirmed' NOT NULL CHECK (booking_status IN ('Confirmed', 'Canceled')),
    CHECK (check_out_date > check_in_date),
    CONSTRAINT FK_Bookings_Guests FOREIGN KEY (guest_id) REFERENCES Guests (guest_id),
    CONSTRAINT FK_Bookings_Rooms FOREIGN KEY (room_id) REFERENCES Rooms (room_id)
);

--Table for storing payment information: id, booking id, payment date, amount
CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY CHECK (payment_id > 0),
    booking_id INT NOT NULL CHECK (booking_id > 0),
    payment_date DATE NOT NULL,
    amount INT NOT NULL CHECK (amount > 0),
    CONSTRAINT FK_Payments_Bookings FOREIGN KEY (booking_id) REFERENCES Bookings (booking_id)
);

--Table for storing amenities: id, description
CREATE TABLE Amenities (
    amenity_id INT IDENTITY(1,1) PRIMARY KEY CHECK (amenity_id > 0),
    description VARCHAR(100) NOT NULL
);

--Table for connecting rooms and amenities: room id, amenity id
CREATE TABLE RoomAmenities (
    room_id INT NOT NULL CHECK (room_id > 0),
    amenity_id INT NOT NULL CHECK (amenity_id > 0),
    PRIMARY KEY (room_id, amenity_id),
    CONSTRAINT FK_RoomAmenities_Rooms FOREIGN KEY (room_id) REFERENCES Rooms (room_id), 
    CONSTRAINT FK_RoomAmenities_Amenities FOREIGN KEY (amenity_id) REFERENCES Amenities (amenity_id)
);

--Table for storing room reviews: id, guest id, room id, review text, rating, review date
CREATE TABLE RoomReviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY CHECK (review_id > 0),
    guest_id INT NOT NULL CHECK (guest_id > 0),
    room_id INT NOT NULL CHECK (room_id > 0),
    review_text VARCHAR(500),
    rating DECIMAL(3, 2) NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_date DATE NOT NULL,
    CONSTRAINT FK_RoomReviews_Guests FOREIGN KEY (guest_id) REFERENCES Guests (guest_id),
    CONSTRAINT FK_RoomReviews_Rooms FOREIGN KEY (room_id) REFERENCES Rooms (room_id)
);

