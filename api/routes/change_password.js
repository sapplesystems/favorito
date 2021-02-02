var express = require('express');
var router = express.Router();
var CheckAuth = require('../middleware/auth');
var ChangePasswordController = require('../controller/change_password');


/* get method for fetch all products. */
router.post('/', CheckAuth, ChangePasswordController.changePassword);
router.post('/update-password', ChangePasswordController.updatePassword);

/* Send email with the otp and return the business id with success msg */
router.post('/send-otp-email', ChangePasswordController.sendOtpOnEmail);

/* to verify otp and change the password */
router.post('/verify-otp-change-password', ChangePasswordController.verifyOtpChangePassword);

module.exports = router;