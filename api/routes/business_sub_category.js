var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var BusinessSubCategoryController = require('../controller/business_sub_category');
var CheckAuth = require('../middleware/auth');
//router.use(bodyParser.json());

//router.post('/add', CheckAuth, BusinessSubCategoryController.add_business_sub_category);

router.post('/list', BusinessSubCategoryController.all_business_sub_category);

router.post('/list-main-category', BusinessSubCategoryController.all_business_main_category);

router.post('/list-sub-category-business', BusinessSubCategoryController.getSubCategoriesByBusiness);

// delete the sub category and update the related menu
router.post('/delete-sub-category', CheckAuth, BusinessSubCategoryController.deleteSubCategory);

//router.post('/find', CheckAuth, BusinessSubCategoryController.find_business_sub_category);

//router.post('/update', CheckAuth, BusinessSubCategoryController.update_business_sub_category);

//router.post('/delete', CheckAuth, BusinessSubCategoryController.delete_business_sub_category);

module.exports = router;