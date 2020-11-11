var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserProfileController = require('../../controller/user/user_profile_controller')

router.post('/business-carousel', CheckAuth, UserProfileController.businessCarouselList)
module.exports = router;