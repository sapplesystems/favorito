express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');

var UserBookingController = require('../../controller/user/user_booking_controller');

//get business booking verbose api
router.post('/get-booking-verbose', CheckAuth, UserBookingController.getBookingVerbose);

// route for get booking for user from user_id
// requre user_id
router.post('/get-booking-appointment', CheckAuth, UserBookingController.getBookingAppointment);

// setting the booking order for the user booking
router.post('/set-booking-appointment', CheckAuth, UserBookingController.setBookingAppointment)

// update booking by business id  
router.post('/update-booking-appointment', CheckAuth, UserBookingController.setBookingAppointment)

// booking delete api for the user by user id , booking id and business id
router.post('/delete-booking-appointment', CheckAuth, UserBookingController.deleteBookingAppointment)



// addig user note 
router.post('/set-booking-usernote', CheckAuth, UserBookingController.setBookingNote);

// set book table and update appointment
router.post('/set-book-table', CheckAuth, UserBookingController.setBookTable);

// get booked table appointment
router.post('/get-book-table', CheckAuth, UserBookingController.getBookTable);
// delete book table appointment
router.post('/delete-book-table', CheckAuth, UserBookingController.deleteBookTable);

module.exports = router;