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

// code for auto hit the server
// router.post('/auto-hit', (req, res) => {
//     setInterval(() => {
//         data = new Date()
//         console.log(`Server keep up ... ${data.getHours()}:${data.getMinutes()}:${data.getSeconds()}`)
//     }, 900000)
//     return res.status(200).send('keeping server up....')
// })

request = require('request')
router.get('/auto-hit-1', (req, res) => {
    var requestLoop = setInterval(function() {
        request({
            url: "http://localhost:3000/api/user/auto-hit-2",
            method: "GET",
            timeout: 10000,
            followRedirect: true,
            maxRedirects: 10
        }, function(error, response, body) {
            if (error) {
                console.log('error' + response.statusCode);
                return res.status(403).send({ error: 'error in auto-hit-1 api' })
            }
        });
    }, 900000);
    return res.status(200).send('done')
})

router.get('/auto-hit-2', (req, res) => {
    data = new Date()
    console.log(`Auto hit ${data.getHours()}:${data.getMinutes()}:${data.getSeconds()}`)
    return res.send('Auto hit running')
})

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