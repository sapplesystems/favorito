express = require('express');
router = express.Router();
var CheckAuth = require('../../middleware/auth');

var UserAdsController = require('../../controller/user/user_ads_controller');

router.post('/click', CheckAuth, UserAdsController.clickOnAd);

module.exports = router;