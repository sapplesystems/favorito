var express = require('express');
var router = express.Router();
var CheckAuth = require('../middleware/auth');
var StateController = require('../controller/state_list');
var CityController = require('../controller/city_list');

/* get method for fetch all products. */
router.post('/state-list', CheckAuth, StateController.getAllStateList);

router.post('/city-list', CheckAuth, CityController.getStateCityList);

module.exports = router;
