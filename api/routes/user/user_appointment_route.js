express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');

var UserAppointmentController = require('../../controller/user/user_appointment_controller');

// route for get booking for user from user_id
// requre user_id
router.post('/set-appointment', CheckAuth, UserAppointmentController.setAppointment);
// router.post('/get-all-appointment', CheckAuth, UserAppointmentController.allAppointments);

// get verbose of appointment
router.post('/get-appointment-verbose', CheckAuth, UserAppointmentController.getVerboseAppointment);

// get all person by service id 
router.post('/get-person-by-service', CheckAuth, UserAppointmentController.getPersonByServiceId);

// get all person by service id 
router.post('/get-person-by-service', CheckAuth, UserAppointmentController.getPersonByServiceId);

router.post('/get-booking-appointment', CheckAuth, UserAppointmentController.getBookingAppointment);


// setting the booking order for the user booking
router.post('/set-booking-appointment', CheckAuth, UserAppointmentController.setBookingAppointment)

// Change the user note
router.post('/set-usernote-appointment', CheckAuth, UserAppointmentController.setAppointmentNote)

// update booking by business id  
router.post('/update-booking-appointment', CheckAuth, UserAppointmentController.setBookingAppointment)

// booking delete api for the user by user id , booking id and business id
router.post('/delete-booking-appointment', CheckAuth, UserAppointmentController.deleteBookingAppointment)

module.exports = router;