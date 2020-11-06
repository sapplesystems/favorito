var express = require('express');
var router = express.Router();
var BusinessAdSpentCampaignController = require('../controller/business_ad_spent_campaign');
var CheckAuth = require('../middleware/auth');
var multer = require('multer');


/**
 * FETCH ALL BUSINESS AD SPENT CAMPAIGN
 */
router.post('/list', CheckAuth, BusinessAdSpentCampaignController.all_business_campaign);

/**
 * STATIC DROP DONW DETAI TO CREATE THE CAMPAIGN
 */
router.post('/dd-verbose', CheckAuth, BusinessAdSpentCampaignController.dd_verbose);

/**
 * CREATE A NEW MANUAL AD SPENT CAMPAIGN
 */
router.post('/create', multer().array(), CheckAuth, BusinessAdSpentCampaignController.create_campaign);

/**
 * FIND AD SPENT CAMPAIGN BY ID
 */
router.post('/detail', CheckAuth, BusinessAdSpentCampaignController.find_campaign);

/**
 * EDIT A MANUAL AD SPENT CAMPAIGN
 */
router.post('/edit', multer().array(), CheckAuth, BusinessAdSpentCampaignController.edit_campaign);

/**
 * DELETE MANUAL AD SPENT CAMPAIGN
 */
router.post('/delete', CheckAuth, BusinessAdSpentCampaignController.delete_campaign);

module.exports = router;
