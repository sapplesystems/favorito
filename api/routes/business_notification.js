var express = require('express');
var router = express.Router();
var BusinessNotificatonController = require('../controller/business_notification');
var CheckAuth = require('../middleware/auth');

/**
 * CREATE NEW NOTIFICATION ROUTE
 */
router.post('/add', CheckAuth, BusinessNotificatonController.add_business_category);


/**
 * FETCH ALL NOTIFICATION ROUTE
 */
router.post('/list', CheckAuth, BusinessNotificatonController.all_business_category);

module.exports = router;
