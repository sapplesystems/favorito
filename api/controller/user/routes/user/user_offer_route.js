var express = require('express');
var router = express.Router();
var UserofferController = require('../../controller/user/user_offer_controller');
var CheckAuth = require('../../middleware/auth');

/**
 * FETCH ALL OFFER ROUTE
 */
 router.post('/list', CheckAuth, UserofferController.all_offers);

 /**
 * UPDATE USER OFFER
 */
  router.post('/offer-status', CheckAuth, UserofferController.offer_status);

module.exports = router;