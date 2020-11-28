var express = require('express');
var router = express.Router();
var BusinessClaimController = require('../controller/business_claim');
var CheckAuth = require('../middleware/auth');
const mkdirp = require('mkdirp');

/*to upload the media use multer: start here*/
var multer = require('multer');
var storage = multer.diskStorage({
    destination: function(req, file, cb) {
        mkdirp.sync('./public/uploads/');
        cb(null, './public/uploads/');
    },
    filename: function(req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
var upload = multer({ storage: storage });
/*to upload the media use multer: end here*/


router.post('/add', CheckAuth, upload.array('photo[]', 1000), BusinessClaimController.addClaim);

router.post('/send-email-verify-link', CheckAuth, BusinessClaimController.sendEmailVerifyLink);
router.get('/let-me-verify/:token', BusinessClaimController.verifyEmailLink);
router.post('/send-otp-sms', CheckAuth, BusinessClaimController.sendVerifyOtp);
router.post('/verify-otp', CheckAuth, BusinessClaimController.verifyOtp);

// router.post('/add-photo', upload.array('photo[]', 1000), CheckAuth, BusinessClaimController.addClaimPhotos);


module.exports = router;