var express = require('express');
var router = express.Router();
//var bodyParser = require('body-parser');
var UserController = require('../controller/business_user');
var UserRegisterController = require('../controller/business_user_register');
var UpdateBusinessUserProfileController = require('../controller/business_user_profile_update');
var CheckAuth = require('../middleware/auth');
const mkdirp = require('mkdirp');
//router.use(bodyParser.json());
//router.use(bodyParser.urlencoded({extended: true}));

/*to upload the media use multer: start here*/
var multer = require('multer');
var storage_business_profile = multer.diskStorage({
  destination: function (req, file, cb) {
    mkdirp.sync('./public/uploads/business_user/profile/');
    cb(null, './public/uploads/business_user/profile/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  }
});
var upload_business_profile = multer({ storage: storage_business_profile });
/*to upload the media use multer: end here*/


/* GET users listing. */
router.get('/', function (req, res, next) {
  res.json('respond with a resource');
});

router.post('/register', UserRegisterController.register);

router.post('/login', UserController.login);

router.post('/profile', CheckAuth, UserController.getProfile);

router.post('/profile/update', upload_business_profile.single('photo'), CheckAuth, UpdateBusinessUserProfileController.updateProfile);

router.post('/owner-profile', CheckAuth, UserController.getBusinessOwnerProfile);

router.post('/update-owner-profile', multer().array(), CheckAuth, UserController.updateBusinessOwnerProfile);

module.exports = router;
