var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserWaitlistController = require('../../controller/user/user_waitlist_controller');

router.post('/get-waitlist', CheckAuth, UserWaitlistController.business_waitlist);

module.exports = router;