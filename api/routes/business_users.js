var express = require('express');
var router = express.Router();
//var bodyParser = require('body-parser');
var UserController = require('../controller/business_user');
var UserRegisterController = require('../controller/business_user_register');
var UpdateBusinessUserProfileController = require('../controller/business_user_profile_update');
var UpdateBusinessInformationController = require('../controller/business_information');
var CheckAuth = require('../middleware/auth');
const mkdirp = require('mkdirp');
//router.use(bodyParser.json());
//router.use(bodyParser.urlencoded({extended: true}));

/*to upload the media use multer: start here*/
var multer = require('multer');
var storage_business_profile = multer.diskStorage({
    destination: function(req, file, cb) {
        mkdirp.sync('./public/uploads/');
        cb(null, './public/uploads/');
    },
    filename: function(req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
var upload_business_profile = multer({ storage: storage_business_profile });
/*to upload the media use multer: end here*/


/**
 * BUSINESS INFORMATION MEDIA UPLOAD CONFIGURATION START HERE
 */
var storage_business_info_media = multer.diskStorage({
    destination: function(req, file, cb) {
        mkdirp.sync('./public/uploads/');
        cb(null, './public/uploads/');
    },
    filename: function(req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
var upload_business_info_media = multer({ storage: storage_business_info_media });
/**END HERE */


/* GET users listing. */
router.get('/', function(req, res, next) {
    res.json('respond with a resource');
});

router.post('/register', UserRegisterController.register);

router.post('/login', UserController.login);

router.post('/profile', CheckAuth, UserController.getProfile);

router.post('/profile/update', upload_business_profile.single('photo'), CheckAuth, UpdateBusinessUserProfileController.updateProfile);


// updating the working hour
router.post('/profile/update-working-hour', CheckAuth, UpdateBusinessUserProfileController.updateProfileWorkingHour);

router.post('/profile/get-working-hour', CheckAuth, UpdateBusinessUserProfileController.getProfileWorkingHour);

router.post('/profile/update-photo', upload_business_profile.single('photo'), CheckAuth, UpdateBusinessUserProfileController.updateProfilePhoto);

router.post('/profile/update-photo', upload_business_profile.single('photo'), CheckAuth, UpdateBusinessUserProfileController.updateProfilePhoto);

router.post('/owner-profile', CheckAuth, UserController.getBusinessOwnerProfile);

router.post('/search-branch', CheckAuth, UserController.searchBranch);

router.post('/update-owner-profile', multer().array(), CheckAuth, UserController.updateBusinessOwnerProfile);

router.post('/owner-profile/add-branch', multer().array(), CheckAuth, UserController.addAnotherBranch);

router.post('/information', CheckAuth, UpdateBusinessInformationController.getBusinessInformation);

router.post('/information/update', multer().array(), CheckAuth, UpdateBusinessInformationController.getBusinessInformationUpdate);

router.post('/information/add-photo', upload_business_info_media.array('photo[]', 1000), CheckAuth, UpdateBusinessInformationController.addPhotos);

router.post('/profile-photo', CheckAuth, UserController.getProfilePhoto);

router.post('/get-registered-email-phone', CheckAuth, UserController.getRegisteredEmailMobile);

router.get('/business-terms-condition', (req, res) => {
    res.render('terms_condition_business.hbs')
});

router.get('/business-privacy-policy', (req, res) => {
    res.render('privacy_policy_business.hbs')
});

router.post('/get-room-id', CheckAuth, UserController.getRoomId);

router.post('/get-chats', CheckAuth, UserController.getChats);

router.post('/is-account-exist', UserRegisterController.isAccountExist);

module.exports = router;