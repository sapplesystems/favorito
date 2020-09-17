var express = require('express');
var router = express.Router();
var BusinessNotificatonController = require('../controller/business_notification');
var CheckAuth = require('../middleware/auth');


/**
 * FETCH ALL NOTIFICATION ROUTE
 */
router.post('/list', CheckAuth, BusinessNotificatonController.all_notifications);


/**
 * FETCH THE STATIC DROP DONW DETAI TO CREATE THE NOTIFICATION
 */
router.post('/dd-verbose', CheckAuth, BusinessNotificatonController.dd_verbose);


/**
 * CREATE NEW NOTIFICATION ROUTE
 */
router.post('/add', CheckAuth, BusinessNotificatonController.add_notification);

module.exports = router;
