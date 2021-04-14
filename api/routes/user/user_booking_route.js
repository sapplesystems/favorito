express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');

var UserBookingController = require('../../controller/user/user_booking_controller');

// route for get booking for user from user_id
// requre user_id

//get business booking verbose api
router.post('/get-booking-verbose', CheckAuth, UserBookingController.getBookingVerbose);

// addig user note 
router.post('/set-booking-usernote', CheckAuth, UserBookingController.setBookingNote);

// set book table and update appointment
router.post('/set-book-table', CheckAuth, UserBookingController.setBookTable);

// get booked table appointment
router.post('/get-book-table', CheckAuth, UserBookingController.getBookTable);

// get booking and appointment
router.post('/get-bookings-appointments', CheckAuth, UserBookingController.getBookingAndAppointment);

// delete book table appointment
router.post('/delete-book-table', CheckAuth, UserBookingController.deleteBookTable);

module.exports = router;