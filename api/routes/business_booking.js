var express = require('express');
var router = express.Router();
var BusinessBookingController = require('../controller/business_booking');
var CheckAuth = require('../middleware/auth');
var multer = require('multer');


/**
 * FETCH ALL BUSINESS BOOKING
 */
router.post('/list', CheckAuth, BusinessBookingController.all_business_booking);

/**
 * FIND BUSINESS BOOKING BY ID
 */
router.post('/detail', CheckAuth, BusinessBookingController.find_business_booking);

/**
 * CREATE A NEW MANUAL BOOKING
 */
router.post('/create', CheckAuth, BusinessBookingController.create_manual_booking);

/**
 * DELETE MANUAL BOOKING
 */
router.post('/delete', CheckAuth, BusinessBookingController.delete_manual_booking);

/**
 * SAVE MANUAL BOOKING SETTING
 */
router.post('/save-setting', multer().array(), CheckAuth, BusinessBookingController.save_setting);

/**
 * GET MANUAL BOOKING SETTING
 */
router.post('/setting', CheckAuth, BusinessBookingController.get_setting);

module.exports = router;
