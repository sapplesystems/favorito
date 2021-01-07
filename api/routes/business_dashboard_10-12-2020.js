var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var CheckAuth = require('../middleware/auth');
var dashboardController = require('../controller/business_dashboard');

//router.use(bodyParser.json()); // for parsing application/json
//router.use(bodyParser.urlencoded({extended: true})); // for parsing application/x-www-form-urlencoded

/*get method for fetch single product*/
router.post('/detail', CheckAuth, dashboardController.getDashboardDetail);

router.post('/get-trending-nearby', CheckAuth, dashboardController.trendingNearby);

router.post('/get-new-business', CheckAuth, dashboardController.newBusiness);

router.post('/get-top-rated', CheckAuth, dashboardController.topRated);

router.post('/get-most-popular', CheckAuth, dashboardController.mostPopular);

module.exports = router;