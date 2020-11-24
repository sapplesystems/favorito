var express = require('express');
var router = express.Router();
var BusinessAttributeController = require('../controller/business_attribute');
var CheckAuth = require('../middleware/auth');
//router.use(bodyParser.json());

router.post('/add', CheckAuth, BusinessAttributeController.addAttribute);

router.post('/list', BusinessAttributeController.listAttribute);

router.post('/update', CheckAuth, BusinessAttributeController.updateAttribute);

router.post('/delete', CheckAuth, BusinessAttributeController.deleteAttribute);

module.exports = router;
