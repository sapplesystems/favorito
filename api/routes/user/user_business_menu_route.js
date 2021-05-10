var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserBusinessMenuController = require('../../controller/user/user_business_menu_controller');

// get category menu by business_id
router.post('/get-category', CheckAuth, UserBusinessMenuController.getMenuCategories);

// get item details by menu_category_id and business_id
router.post('/get-category-item', CheckAuth, UserBusinessMenuController.getItemOfCategory);

// search item category by 
router.post('/search-item-category', CheckAuth, UserBusinessMenuController.searchItemCategory);

router.post('/get-menu-setting', CheckAuth, UserBusinessMenuController.businessMenuSetting);

router.post('/get-item-customization-detail', CheckAuth, UserBusinessMenuController.getItemCustomizationDetial);

router.post('/get-business-isfood', CheckAuth, UserBusinessMenuController.getBusinessIsFood);

module.exports = router;