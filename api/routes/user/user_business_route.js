// business name search 
var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserBusinessController = require('../../controller/user/user_business_controller');


router.post('/search-by-name', CheckAuth, UserBusinessController.searchByName);

module.exports = router;