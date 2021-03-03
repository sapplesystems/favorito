var db = require('../config/db');
var cpc = [0.5, 0.10, 0.50, 1.00];
var ad_status = ['Active', 'Pause', 'Stop'];

/**
 * FETCH ALL BUSINESS AD SPENT CAMPAIGN
 */
exports.all_business_campaign = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var COND = "business_id='" + business_id + "' AND deleted_at IS NULL";
        if (req.body.campaign_id != '' && req.body.campaign_id != 'undefined' && req.body.campaign_id != null) {
            COND += " AND id='" + req.body.campaign_id + "'";
        }

        var sql = "SELECT id,`name`,keyword,cpc,total_budget,impressions,clicks,status \n\
        FROM business_ad_spent_campaign WHERE " + COND;
        db.query(sql, async function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            var res_len = result.length;
            var data = [];
            if (res_len > 0) {
                for (var i = 0; i < res_len; i++) {
                    var keyword = result[i].keyword;
                    result[i].keyword = await exports.getTags(keyword);
                    data.push(result[i]);
                }
            }

            // fetching the data from the ads_spent table 
            sql_data_ads_spent = `select total_spent,free_credits,paid_credits from business_ad_credits where business_id = '${business_id}'`
            result_data_ads_spent = await exports.run_query(sql_data_ads_spent)
            if (result_data_ads_spent[0] && result_data_ads_spent[0].total_spent) {
                total_spent = result_data_ads_spent[0].total_spent
            } else {
                total_spent = 0
            }
            if (result_data_ads_spent[0] && result_data_ads_spent[0].free_credits) {
                free_credits = result_data_ads_spent[0].free_credits
            } else {
                free_credits = 0
            }
            if (result_data_ads_spent[0] && result_data_ads_spent[0].paid_credits) {
                paid_credits = result_data_ads_spent[0].paid_credits
            } else {
                paid_credits = 0
            }
            return res.status(200).json({
                status: 'success',
                message: 'success',
                total_spent: total_spent,
                free_credit: free_credits,
                paid_credit: paid_credits,
                data: data
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * FIND AD SPENT CAMPAIGN BY ID
 */
exports.find_campaign = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.campaign_id == '' || req.body.campaign_id == 'undefined' || req.body.campaign_id == null) {
            return res.status(403).json({ status: 'error', message: 'Ad Campaign id not found.' });
        }

        var id = req.body.campaign_id;
        var sql = "SELECT id,`name`,keyword,cpc,total_budget,impressions,clicks,status \n\
        FROM business_ad_spent_campaign WHERE business_id='" + business_id + "'AND id='" + id + "' AND deleted_at IS NULL";
        db.query(sql, async function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            var keyword = result[0].keyword;
            result[0].keyword = await exports.getTags(keyword);
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
exports.dd_verbose = function(req, res, next) {
    try {
        var verbose = {};
        verbose.cpc = cpc;
        verbose.ad_status = ad_status;
        return res.status(200).json({ status: 'success', message: 'success', data: verbose });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE A NEW MANUAL AD SPENT CAMPAIGN
 */
exports.create_campaign = function(req, res, next) {
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
        } else if (req.body.status == '' || req.body.status == 'undefined' || req.body.status == null) {
            return res.status(403).json({ status: 'error', message: 'Status not found.' });
        }

        var name = req.body.name;
        var keyword = req.body.keyword;
        var cpc = req.body.cpc;
        var total_budget = req.body.total_budget;
        var status = req.body.status;
        keyword = keyword.join();

        var sql = "INSERT INTO business_ad_spent_campaign (business_id,`name`,keyword,cpc,total_budget,status) \n\
        VALUES('" + business_id + "','" + name + "','" + keyword + "','" + cpc + "','" + total_budget + "','" + status + "')";
        db.query(sql, function(err, result) {
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
exports.edit_campaign = function(req, res, next) {
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

        var sql = "update business_ad_spent_campaign set " + update_column + " where id='" + id + "'";
        db.query(sql, function(err, result) {
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
exports.delete_campaign = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.campaign_id == '' || req.body.campaign_id == 'undefined' || req.body.campaign_id == null) {
            return res.status(403).json({ status: 'error', message: 'Ad campaign id not found.' });
        }

        var campaign_id = req.body.campaign_id;

        var sql = "UPDATE business_ad_spent_campaign SET deleted_at = NOW() WHERE id='" + campaign_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Campaign deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getTags = function(tag_ids) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "SELECT id, tag_name FROM business_tags_master \n\
            WHERE id IN(" + tag_ids + ") AND deleted_at IS NULL";
            db.query(sql, function(err, result) {
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.run_query = (sql, param = false) => {
    if (param == false) {
        return new Promise((resolve, reject) => {
            db.query(sql, (error, result) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    } else {
        return new Promise((resolve, reject) => {
            db.query(sql, param, (error, result) => {
                if (error) {
                    console.log(error)
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }
}