var express = require('express');
var router = express.Router();
//var bodyParser = require('body-parser');
var OrderController = require('../controller/business_order');
var CheckAuth = require('../middleware/auth');

/**
 * GET STATIC VARIABLE
 */
router.post('/dd-verbose', CheckAuth, OrderController.dd_verbose);

/**
 * GET ONLY CATEGORY LIST
 */
router.post('/category-list', CheckAuth, OrderController.getCategoryList);

/**
 * GET ITEM LIST BY CATEGORY ID
 */
router.post('/item-list', CheckAuth, OrderController.getItemByCategoryId);

/**
 * CREATE NEW ORDER
 */
router.post('/create', CheckAuth, OrderController.createNewOrder);


/**
 * LIST ALL ORDER
 */
router.post('/list', CheckAuth, OrderController.listAllOrder);
/**
 * ORDER ACCEPT/REJECT/PENDING
 **/
router.post('/update-status', CheckAuth, OrderController.updateOrderStatus);

router.post('/delete', CheckAuth, OrderController.deleteOrder);
module.exports = router;
