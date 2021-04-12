var express = require('express');
var router = express.Router();
var BusinessReviewController = require('../controller/business_review_controller');
var CheckAuth = require('../middleware/auth');

router.post('/review-list', CheckAuth, BusinessReviewController.all_business_reviewlist);

module.exports = router;