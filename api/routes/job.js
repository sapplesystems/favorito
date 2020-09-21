var express = require('express');
var router = express.Router();
var JobController = require('../controller/job');
var CheckAuth = require('../middleware/auth');


/**
 * FETCH ALL JOB ROUTE
 */
router.post('/list', CheckAuth, JobController.all_jobs);


/**
 * FETCH THE STATIC DROP DONW DETAI TO CREATE THE JOB
 */
router.post('/dd-verbose', CheckAuth, JobController.dd_verbose);


/**
 * CREATE NEW JOB ROUTE
 */
router.post('/create', CheckAuth, JobController.add_job);

/**
 * CREATE NEW JOB ROUTE
 */
router.post('/detail', CheckAuth, JobController.detail_job);

/**
 * CREATE NEW JOB ROUTE
 */
router.post('/edit', CheckAuth, JobController.edit_job);

module.exports = router;
