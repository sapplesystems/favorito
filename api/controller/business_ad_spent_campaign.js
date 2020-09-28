var db = require('../config/db');
var cpc = [0.5, 0.10, 0.50, 1.00];

/**
 * FETCH ALL BUSINESS AD SPENT CAMPAIGN
 */
exports.all_business_campaign = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id,`name`,keyword,cpc,total_budget,impressions,clicks,status \n\
        FROM business_ad_spent_campaign WHERE business_id='" + business_id + "' AND deleted_at IS NULL";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({
                status: 'success',
                message: 'success',
                total_spent: 1000,
                free_credit: 400,
                paid_credit: 800,
                data: result
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * FIND AD SPENT CAMPAIGN BY ID
 */
exports.find_campaign = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.campaign_id == '' || req.body.campaign_id == 'undefined' || req.body.campaign_id == null) {
            return res.status(403).json({ status: 'error', message: 'Ad Campaign id not found.' });
        }

        var id = req.body.campaign_id;
        var sql = "SELECT id,`name`,keyword,cpc,total_budget,impressions,clicks,status \n\
        FROM business_ad_spent_campaign WHERE business_id='" + business_id + "'AND id='" + id + "' AND deleted_at IS NULL";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({
                status: 'success',
                message: 'success',
                verbose_cpc: cpc,
                data: result
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * STATIC DROP DONW DETAI TO CREATE THE CAMPAIGN
 */
exports.dd_verbose = function (req, res, next) {
    try {
        var verbose = {};
        verbose.cpc = cpc;
        return res.status(200).json({ status: 'success', message: 'success', data: verbose });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE A NEW MANUAL AD SPENT CAMPAIGN
 */
exports.create_campaign = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.keyword == '' || req.body.keyword == 'undefined' || req.body.keyword == null) {
            return res.status(403).json({ status: 'error', message: 'Keyword not found.' });
        } else if (req.body.cpc == '' || req.body.cpc == 'undefined' || req.body.cpc == null) {
            return res.status(403).json({ status: 'error', message: 'Cost per click not found.' });
        } else if (req.body.total_budget == '' || req.body.total_budget == 'undefined' || req.body.total_budget == null) {
            return res.status(403).json({ status: 'error', message: 'Total budget not found.' });
        }

        var name = req.body.name;
        var keyword = req.body.keyword;
        var cpc = req.body.cpc;
        var total_budget = req.body.total_budget;
        keyword = keyword.join();

        var sql = "INSERT INTO business_ad_spent_campaign (business_id,`name`,keyword,cpc,total_budget) \n\
        VALUES('" + business_id + "','" + name + "','" + keyword + "','" + cpc + "','" + total_budget + "')";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Ad campaign saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * EDIT A MANUAL AD SPENT CAMPAIGN
 */
exports.edit_campaign = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.campaign_id == '' || req.body.campaign_id == 'undefined' || req.body.campaign_id == null) {
            return res.status(403).json({ status: 'error', message: 'Ad Campaign id not found.' });
        }

        var update_column = " updated_at=now() ";
        if (req.body.name != '' && req.body.name != 'undefined' && req.body.name != null) {
            update_column += ",name='" + req.body.name + "'";
        }
        if (req.body.keyword != '' && req.body.keyword != 'undefined' && req.body.keyword != null) {
            var keyword = req.body.keyword;
            keyword = keyword.join();
            update_column += ",keyword='" + keyword + "'";
        }
        if (req.body.cpc != '' && req.body.cpc != 'undefined' && req.body.cpc != null) {
            update_column += ",cpc='" + req.body.cpc + "'";
        }
        if (req.body.total_budget != '' && req.body.total_budget != 'undefined' && req.body.total_budget != null) {
            update_column += ",total_budget='" + req.body.total_budget + "'";
        }
        if (req.body.status != '' && req.body.status != 'undefined' && req.body.status != null) {
            update_column += ",status='" + req.body.status + "'";
        }

        var id = req.body.campaign_id;
        var name = req.body.name;
        var keyword = req.body.keyword;
        var cpc = req.body.cpc;
        var total_budget = req.body.total_budget;
        keyword = keyword.join();

        var sql = "update business_ad_spent_campaign set " + update_column + " where id='" + id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Ad campaign saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * DELETE MANUAL AD SPENT CAMPAIGN
 */
exports.delete_campaign = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.campaign_id == '' || req.body.campaign_id == 'undefined' || req.body.campaign_id == null) {
            return res.status(403).json({ status: 'error', message: 'Ad campaign id not found.' });
        }

        var campaign_id = req.body.campaign_id;

        var sql = "UPDATE business_ad_spent_campaign SET deleted_at = NOW() WHERE id='" + campaign_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Campaign deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};