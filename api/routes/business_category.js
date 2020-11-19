var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var BusinessCategoryController = require('../controller/business_category');
var CheckAuth = require('../middleware/auth');
//router.use(bodyParser.json());

router.post('/add', CheckAuth, BusinessCategoryController.add_business_category);

router.post('/list', BusinessCategoryController.all_business_category);

router.post('/find', CheckAuth, BusinessCategoryController.find_business_category);

router.post('/update', CheckAuth, BusinessCategoryController.update_business_category);

router.post('/delete', CheckAuth, BusinessCategoryController.delete_business_category);

module.exports = router;
