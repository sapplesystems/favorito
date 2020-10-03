var express = require('express');
var router = express.Router();
var BusinessAppointmentController = require('../controller/business_appointment');
var CheckAuth = require('../middleware/auth');
var multer = require('multer');

/**
 * STATIC VARIABLES
 */
router.post('/dd-verbose', CheckAuth, BusinessAppointmentController.dd_verbose);

/**
 * SAVE PERSON
 */
router.post('/save-person', CheckAuth, BusinessAppointmentController.savePerson);

/**
 * SAVE SERVICE
 */
router.post('/save-service', CheckAuth, BusinessAppointmentController.saveService);

/**
 * SAVE RESTRICTION
 */
router.post('/save-restriction', CheckAuth, BusinessAppointmentController.saveRestriction);

/**
 * GET ALL PERSON LIST
 */
router.post('/get-all-person', CheckAuth, BusinessAppointmentController.getAllPersonList);


/**
 * GET ALL SERVICE LIST
 */
router.post('/get-all-service', CheckAuth, BusinessAppointmentController.getAllServiceList);


/**
 * GET ALL RESTRICTION LIST
 */
router.post('/get-all-restriction', CheckAuth, BusinessAppointmentController.getAllRestrictionList);


/**
 * DELETE RESTRICTION
 */
router.post('/delete-restriction', CheckAuth, BusinessAppointmentController.deleteRestriction);


/**
 * GET RESTRICTION DETAIL
 */
router.post('/get-restriction-detail', CheckAuth, BusinessAppointmentController.getRestrictionDetail);


/**
 * EDIT RESTRICTION
 */
router.post('/edit-restriction', CheckAuth, BusinessAppointmentController.editRestriction);


/**
 * SAVE SETTING
 */
router.post('/save-setting', CheckAuth, BusinessAppointmentController.save_setting);

/**
 * GET SETTING
 */
router.post('/setting', CheckAuth, BusinessAppointmentController.get_setting);

module.exports = router;
