var express = require('express');
var router = express.Router();
var BusinessWaitlistController = require('../controller/business_waitlist');
var CheckAuth = require('../middleware/auth');
var multer = require('multer');


/**
 * FETCH ALL BUSINESS WAITLIST
 */
router.post('/list', CheckAuth, BusinessWaitlistController.all_business_waitlist);

/**
 * CREATE A NEW MANUAL WAITLIST
 */
router.post('/create', CheckAuth, BusinessWaitlistController.create_manual_waitlist);

/**
 * DELETE MANUAL WAITLIST
 */
router.post('/delete', CheckAuth, BusinessWaitlistController.delete_manual_waitlist);

/**
 * SAVE MANUAL WAITLIST SETTING
 */
router.post('/save-setting', multer().array(), CheckAuth, BusinessWaitlistController.save_setting);

/**
 * GET MANUAL WAITLIST SETTING
 */
router.post('/setting', CheckAuth, BusinessWaitlistController.get_setting);

/**
 * WAITLIST ACCEPT/REJECT/PENDING
 **/
router.post('/update-status', CheckAuth, BusinessWaitlistController.updateWaitlistStatus);
module.exports = router;
