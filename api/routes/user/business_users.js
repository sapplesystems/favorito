var express = require('express');
var router = express.Router();
//var bodyParser = require('body-parser');
var UserLoginController = require('../../controller/user/user_login');
var UserRegisterController = require('../../controller/user/user_register');
var CheckAuth = require('../../middleware/auth');
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

router.post('/register', UserRegisterController.register);

router.post('/login', UserLoginController.login);

router.post('/is-profile-exist', UserRegisterController.isProfileExist);

// end-point- /api/user/is-account-exist
router.post('/is-account-exist', UserRegisterController.isAccountExist);

// send otp sms
router.post('/mobile-otp-send', CheckAuth, UserRegisterController.sendVerifyOtp);

router.post('/mobile-otp-verify', CheckAuth, UserRegisterController.verifyOtp);

router.post('/send-email-verify-link', CheckAuth, UserRegisterController.sendEmailVerifyLink);


// router.post('/let-me-verify', CheckAuth, UserRegisterController.verifyEmailLink);

router.get('/let-me-verify/:token', UserRegisterController.verifyEmailLink);




module.exports = router;