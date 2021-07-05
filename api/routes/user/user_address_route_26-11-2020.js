express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');

var UserAddressController = require('../../controller/user/user_address_controller');

// route for get booking for user from user_id
// requre user_id
router.post('/get-address', CheckAuth, UserAddressController.getAddress);
// router.post('/get-all-appointment', CheckAuth, UserAppointmentController.allAppointments);

module.exports = router;