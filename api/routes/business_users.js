var express = require('express');
var router = express.Router();
//var bodyParser = require('body-parser');
var UserController = require('../controller/business_user');
var UserRegisterController = require('../controller/business_user_register');
var CheckAuth = require('../middleware/auth');
//router.use(bodyParser.json());
//router.use(bodyParser.urlencoded({extended: true}));

/* GET users listing. */
router.get('/', function (req, res, next) {
  res.json('respond with a resource');
});

router.post('/register', UserRegisterController.register);

router.post('/login', UserController.login);

router.post('/profile', CheckAuth, UserController.getProfile);

module.exports = router;
