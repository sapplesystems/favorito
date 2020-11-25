var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserProfileController = require('../../controller/user/user_profile_controller');
var UserProfileBusinessDetailController = require('../../controller/user/user_profile_business_detail_controller');
var UserProfilBusinessOverview = require('../../controller/user/user_profile_business_detail_controller');

router.post('/business-carousel', CheckAuth, UserProfileController.businessCarouselList);
router.post('/user-review', CheckAuth, UserProfileController.getUserReview);
router.post('/business-detail', CheckAuth, UserProfileBusinessDetailController.businessDetail);
router.post('/business-overview', CheckAuth, UserProfilBusinessOverview.businessDetail);
router.post('/business-catalog-list', CheckAuth, UserProfileBusinessDetailController.getListCatalog);
router.post('/business-review-list', CheckAuth, UserProfileBusinessDetailController.all_business_reviewlist);
router.post('/user-profile-photo', CheckAuth, UserProfileController.userProfilePhoto);
router.post('/user-all-photo', CheckAuth, UserProfileController.userAllPhoto);
router.post('/user-favourite-business', CheckAuth, UserProfileController.userFavouriteBusiness);
router.post('/user-get-badges', CheckAuth, UserProfileController.userGetBadges);




module.exports = router;