var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
const mkdirp = require('mkdirp');

var UserProfileController = require('../../controller/user/user_profile_controller');
var UserProfileBusinessDetailController = require('../../controller/user/user_profile_business_detail_controller');
var UserProfilBusinessOverview = require('../../controller/user/user_profile_business_detail_controller');


var multer = require('multer');
var storage_user_profile = multer.diskStorage({
    destination: function(req, file, cb) {
        mkdirp.sync('./public/uploads/');
        cb(null, './public/uploads/');
    },
    filename: function(req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
var upload_profile_photo = multer({ storage: storage_user_profile });

router.post('/business-carousel', CheckAuth, UserProfileController.businessCarouselList);
router.post('/user-review', CheckAuth, UserProfileController.getUserReview);
router.post('/business-detail', CheckAuth, UserProfileBusinessDetailController.businessDetail);
router.post('/business-overview', CheckAuth, UserProfilBusinessOverview.getBusinessOverview);
router.post('/business-catalog-list', CheckAuth, UserProfileBusinessDetailController.getListCatalog);
router.post('/business-review-list', CheckAuth, UserProfileBusinessDetailController.all_business_reviewlist);
router.post('/user-profile-photo', CheckAuth, UserProfileController.userProfilePhoto);
router.post('/set-user-profile-photo', upload_profile_photo.single('photo'), CheckAuth, UserProfileController.setUserProfilePhoto);
// router.post('/set-user-profile-photo', CheckAuth, UserProfileController.setUserProfilePhoto);

router.post('/user-all-photo', CheckAuth, UserProfileController.userAllPhoto);
router.post('/user-favourite-business', CheckAuth, UserProfileController.userFavouriteBusiness);
router.post('/user-get-badges', CheckAuth, UserProfileController.userGetBadges);

// get name address profile_id and photo by type name mobile profile_id
router.post('/user-detail-by-typing', CheckAuth, UserProfileController.userDetailByTyping);

// Relation apis
router.post('/user-business-relation', CheckAuth, UserProfileController.userBusinessRelation);
// end relation by relation_id
router.post('/end-relation', CheckAuth, UserProfileController.endRelation);
// get all relation by the relation_type
router.post('/get-all-relation', CheckAuth, UserProfileController.getAllRelation);

// This is use for the set and the get of the user detial 
router.post('/user-detail', CheckAuth, UserProfileController.userDetail);

// terms and condition for the user link
router.get('/user-terms-condition', (req, res) => {
    res.render('terms_condition_user.hbs')
});

// privacy policy for the user link
router.get('/user-privacy-policy', (req, res) => {
    res.render('privacy_policy_user.hbs')
});

module.exports = router;