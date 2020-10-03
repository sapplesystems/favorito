var express = require('express');
var router = express.Router();
var BusinessAppoinmentController = require('../controller/business_appoinment');
var CheckAuth = require('../middleware/auth');
var multer = require('multer');

/**
 * STATIC VARIABLES
 */
router.post('/dd-verbose', CheckAuth, BusinessAppoinmentController.dd_verbose);

/**
 * SAVE PERSON
 */
router.post('/save-person', CheckAuth, BusinessAppoinmentController.savePerson);

/**
 * SAVE SERVICE
 */
router.post('/save-service', CheckAuth, BusinessAppoinmentController.saveService);

/**
 * SAVE RESTRICTION
 */
router.post('/save-restriction', CheckAuth, BusinessAppoinmentController.saveRestriction);

/**
 * GET ALL PERSON LIST
 */
router.post('/get-all-person', CheckAuth, BusinessAppoinmentController.getAllPersonList);


/**
 * GET ALL SERVICE LIST
 */
router.post('/get-all-service', CheckAuth, BusinessAppoinmentController.getAllServiceList);


/**
 * GET ALL RESTRICTION LIST
 */
router.post('/get-all-restriction', CheckAuth, BusinessAppoinmentController.getAllRestrictionList);


/**
 * DELETE RESTRICTION
 */
router.post('/delete-restriction', CheckAuth, BusinessAppoinmentController.deleteRestriction);


/**
 * GET RESTRICTION DETAIL
 */
router.post('/get-restriction-detail', CheckAuth, BusinessAppoinmentController.getRestrictionDetail);


/**
 * EDIT RESTRICTION
 */
router.post('/edit-restriction', CheckAuth, BusinessAppoinmentController.editRestriction);


/**
 * SAVE SETTING
 */
router.post('/save-setting', CheckAuth, BusinessAppoinmentController.save_setting);

/**
 * GET SETTING
 */
router.post('/setting', CheckAuth, BusinessAppoinmentController.get_setting);

module.exports = router;
