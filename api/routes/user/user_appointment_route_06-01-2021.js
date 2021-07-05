express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');

var UserAppointmentController = require('../../controller/user/user_appointment_controller');

// route for get booking for user from user_id
// requre user_id
router.post('/set-appointment', CheckAuth, UserAppointmentController.setAppointment);
// router.post('/get-all-appointment', CheckAuth, UserAppointmentController.allAppointments);

module.exports = router;