// business name search 
var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserBusinessController = require('../../controller/user/user_business_controller');
var UserProfilBusinessOverview = require('../../controller/user/user_profile_business_detail_controller');


router.post('/search-by-name', CheckAuth, UserBusinessController.searchByName);

router.post('/get-business-hours', CheckAuth, UserProfilBusinessOverview.getAllHoursBusiness);

module.exports = router;