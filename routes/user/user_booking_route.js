express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');

var UserBookingController = require('../../controller/user/user_booking_controller');

// route for get booking for user from user_id
// requre user_id
router.post('/get-booking', CheckAuth, UserBookingController.getBookings);

// update booking by business id  
router.post('/update-booking', CheckAuth, UserBookingController.setUpdateBooking)

// booking delete api for the user by user id , booking id and business id
router.post('/delete-booking', CheckAuth, UserBookingController.deleteBooking)

// setting the booking order for the user booking
router.post('/set-booking', CheckAuth, UserBookingController.setBookings)

// addig user note 
router.post('/set-booking-usernote', CheckAuth, UserBookingController.setBookingNote);

module.exports = router;