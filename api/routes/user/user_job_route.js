var express = require('express');
var router = express.Router();
var CheckAuth = require('../../middleware/auth');
var UserJobController = require('../../controller/user/user_job_controller');

router.post('/detail', CheckAuth, UserJobController.getDetailJob);

module.exports = router;