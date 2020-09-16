var express = require('express');
var router = express.Router();
var CheckAuth = require('../middleware/auth');
var BusinessDD = require('../controller/business_hours_dd_list');

router.post('/', CheckAuth, BusinessDD.getBusinessWorkingHoursDD);

module.exports = router;
