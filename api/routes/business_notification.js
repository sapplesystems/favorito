const { Router } = require('express');
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
 * VERIFY PINCODE
 */
router.post('/verify-pincode', CheckAuth, BusinessNotificatonController.verify_pincode);


/**
 * CREATE NEW NOTIFICATION ROUTE
 */
router.post('/add', CheckAuth, BusinessNotificatonController.add_notification);

/**
 * VIEW ONLY ONE NOTIFICATION
 */

router.post('/detail', CheckAuth, BusinessNotificatonController.detail_notification);


/*
 * DELETE NOTIFICATION BY ID  
 */

router.post('/delete', CheckAuth, BusinessNotificatonController.delete_notification)
module.exports = router;