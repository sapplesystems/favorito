var express = require('express');
var router = express.Router();
var BusinessTagController = require('../controller/business_tag');
var CheckAuth = require('../middleware/auth');
//router.use(bodyParser.json());

router.post('/add', CheckAuth, BusinessTagController.addTag);

router.post('/list', BusinessTagController.listTag);

router.post('/update', CheckAuth, BusinessTagController.updateTag);

router.post('/delete', CheckAuth, BusinessTagController.deleteTag);

module.exports = router;
