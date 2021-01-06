var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserWaitlistController = require('../../controller/user/user_waitlist_controller');

router.post('/get-waitlist', CheckAuth, UserWaitlistController.get_waitlist);
router.post('/set-waitlist', CheckAuth, UserWaitlistController.set_waitlist);
router.post('/cancel-waitlist', CheckAuth, UserWaitlistController.cancel_waitlist);
router.post('/waitlist-verbose', CheckAuth, UserWaitlistController.business_waitlist_verbose);
<<<<<<< HEAD
=======

>>>>>>> a987c6b2aff3923a7c0ff4d561edd18bffd44cfb

module.exports = router;