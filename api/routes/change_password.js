var express = require('express');
var router = express.Router();
var CheckAuth = require('../middleware/auth');
var ChangePasswordController = require('../controller/change_password');


/* get method for fetch all products. */
router.post('/', CheckAuth, ChangePasswordController.changePassword);

router.post('/update-password', ChangePasswordController.updatePassword);

module.exports = router;