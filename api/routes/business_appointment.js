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
 * appointment  service
 */
router.post('/appointment-service', CheckAuth, BusinessAppointmentController.appointment_service);

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


// SAVE MULTI RESTRICTION 
router.post('/save-multi-restriction', CheckAuth, BusinessAppointmentController.saveMultiRestriction);

// get active person by service id
router.post('/get-person-by-service', CheckAuth, BusinessAppointmentController.getPersonByService);

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
 * set person status active or in active
 */
router.post('/set-person-status', CheckAuth, BusinessAppointmentController.setPersonStatus);

/**
 * set service status active or in active
 */
router.post('/set-service-status', CheckAuth, BusinessAppointmentController.setServiceStatus);


/**
 * SAVE SETTING
 */
router.post('/save-setting', CheckAuth, BusinessAppointmentController.save_setting);

/**
 * GET SETTING
 */
router.post('/setting', CheckAuth, BusinessAppointmentController.get_setting);

/**
 * CREATE A NEW APPOINTMENT
 */
router.post('/create', CheckAuth, BusinessAppointmentController.createAppointment);

/**
 * FIND BUSINESS APPOINTENT BY ID
 */
router.post('/detail', CheckAuth, BusinessAppointmentController.findAppointmentById);

/**
 * EDIT BUSINESS APPOINTENT BY ID
 */
router.post('/edit', CheckAuth, BusinessAppointmentController.editAppointment);

/**
 * DELETE MANUAL APPOINTMENT
 */
router.post('/delete', CheckAuth, BusinessAppointmentController.deleteAppointment);


/**
 * FETCH ALL BUSINESS APPOINTMENT
 */
router.post('/list', CheckAuth, BusinessAppointmentController.listAllAppointment);


/**
 * APPOINTMENT ACCEPT/REJECT/PENDING
 **/
router.post('/update-status', CheckAuth, BusinessAppointmentController.updateAppointmentStatus);

module.exports = router;