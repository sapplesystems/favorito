var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var BusinessTypeController = require('../controller/business_type');
var CheckAuth = require('../middleware/auth');
//router.use(bodyParser.json());

router.post('/add', CheckAuth, BusinessTypeController.add_business_type);

router.post('/list', CheckAuth, BusinessTypeController.all_business_type);

router.post('/find', CheckAuth, BusinessTypeController.find_business_type);

router.post('/update', CheckAuth, BusinessTypeController.update_business_type);

router.post('/delete', CheckAuth, BusinessTypeController.delete_business_type);

module.exports = router;
