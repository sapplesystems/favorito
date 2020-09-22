var express = require('express');
var router = express.Router();
var BusinessOfferController = require('../controller/business_offer');
var CheckAuth = require('../middleware/auth');


/**
 * FETCH ALL OFFER ROUTE
 */
router.post('/list', CheckAuth, BusinessOfferController.all_offers);

/**
 * FETCH THE STATIC DROP DONW DETAI TO CREATE THE OFFER
 */
router.post('/dd-verbose', CheckAuth, BusinessOfferController.dd_verbose);


/**
 * CREATE NEW OFFER ROUTE
 */
router.post('/create', CheckAuth, BusinessOfferController.add_offer);

module.exports = router;
