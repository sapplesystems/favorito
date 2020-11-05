var express = require('express');
var router = express.Router();
var BusinessChecklistController = require('../controller/business_checklist');
var CheckAuth = require('../middleware/auth');



/**
 * FETCH ALL BUSINESS REVIEW LIST
 */
router.post('/list', CheckAuth, BusinessChecklistController.all_business_reviewlist);

/**
 * FETCH  REVIEW 
 */
router.post('/check-in-list', CheckAuth, BusinessChecklistController.business_check_in_list);

module.exports = router;