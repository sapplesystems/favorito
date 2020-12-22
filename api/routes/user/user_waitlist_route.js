var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserWaitlistController = require('../../controller/user/user_waitlist_controller');

router.post('/get-waitlist', CheckAuth, UserWaitlistController.business_waitlist);
router.post('/set-waitlist', CheckAuth, UserWaitlistController.set_waitlist);
router.post('/cancel-waitlist', CheckAuth, UserWaitlistController.cancel_waitlist);

module.exports = router;