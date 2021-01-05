var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserOrderController = require('../../controller/user/user_order_controller');

router.post('/get-order-list', CheckAuth, UserOrderController.getOrderList);

router.post('/get-order-detail', CheckAuth, UserOrderController.getOrderDetail);

router.post('/create-order', CheckAuth, UserOrderController.createOrder);

module.exports = router;