var express = require('express');
var router = express.Router();
var CheckAuth = require('../middleware/auth');
var ChangePasswordController = require('../controller/change_password');


/* get method for fetch all products. */
router.post('/', CheckAuth, ChangePasswordController.changePassword);
router.post('/update-password', ChangePasswordController.updatePassword);

<<<<<<< HEAD
router.post('/update-password', ChangePasswordController.updatePassword);
=======
>>>>>>> a987c6b2aff3923a7c0ff4d561edd18bffd44cfb

module.exports = router;