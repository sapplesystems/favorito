express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserCheckinController = require('../../controller/user/user_checkin_controller');

// To set the checkin by scanning the qr code and get the detail of the business 
router.post('/set-checkin', CheckAuth, UserCheckinController.userSetCheckin)

// get the all the detial of the user
router.post('/get-checkin', CheckAuth, UserCheckinController.userGetCheckin)


module.exports = router;