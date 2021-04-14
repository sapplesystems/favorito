var express = require('express');
var router = express.Router();
var BusinessReviewController = require('../controller/business_review_controller');
var CheckAuth = require('../middleware/auth');

router.post('/review-list', CheckAuth, BusinessReviewController.all_business_reviewlist);

// get reviews with replies by user_id and review_id and business_id form table business_review
router.post('/get-review-replies', CheckAuth, BusinessReviewController.get_review_with_replies);

module.exports = router;