<<<<<<< HEAD
var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');

var userChangePasswordController = require('../../controller/user/user_change_password_controller');

router.post('/change-password-by-old', CheckAuth, userChangePasswordController.changePasswordByOld);

/* Send email with the otp and return the business id with success msg */
router.post('/send-otp-change-password', userChangePasswordController.sendOtpChangePassword);

/* to verify otp and change the password */
router.post('/verify-otp-change-password', userChangePasswordController.verifyOtpChangePassword);


=======
var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');

var userChangePasswordController = require('../../controller/user/user_change_password_controller');

router.post('/change-password-by-old', CheckAuth, userChangePasswordController.changePasswordByOld);

/* Send email with the otp and return the business id with success msg */
router.post('/send-otp-change-password', userChangePasswordController.sendOtpChangePassword);

/* to verify otp and change the password */
router.post('/verify-otp-change-password', userChangePasswordController.verifyOtpChangePassword);


>>>>>>> f0f784ca80ea38c4df8f1907cb0ffd4f04b85275
module.exports = router;