# NDBI026-Development-of-Database-Applications

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
