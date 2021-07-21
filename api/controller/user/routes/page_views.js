var express = require('express');
var router = express.Router();
var CheckAuth = require('../middleware/auth');
var PageViewsController = require('../controller/page_views');

/* get method for fetch all products. */
router.post('/', CheckAuth, PageViewsController.info);

module.exports = router;
