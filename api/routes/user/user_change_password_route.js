var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');

var userChangePasswordController = require('../../controller/user/user_change_password_controller');

router.post('/change-password-by-old', CheckAuth, userChangePasswordController.changePasswordByOld);

/* Send email with the otp and return the business id with success msg */
router.post('/send-otp-change-password', userChangePasswordController.sendOtpChangePassword);

/* to verify otp and change the password */
router.post('/verify-otp-change-password', userChangePasswordController.verifyOtpChangePassword);


module.exports = router;