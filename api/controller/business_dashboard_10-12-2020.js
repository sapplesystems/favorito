var db = require('../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.getDashboardDetail = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id, business_id, business_name, CONCAT('" + img_path + "', photo) as photo, business_status, is_profile_completed, is_information_completed, is_phone_verified, is_email_verified, is_verified FROM `business_master` \n\
                    WHERE business_id='" + business_id + "' AND is_activated='1' AND deleted_at IS NULL";
        db.query(sql, function(err, result_set, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (result_set.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No record found.' });
            }
            var row = result_set[0];
            var data = {
                id: row.id,
                business_id: row.business_id,
                business_name: row.business_name,
                photo: row.photo,
                business_status: row.business_status,
                is_profile_completed: row.is_profile_completed,
                is_information_completed: row.is_information_completed,
                is_phone_verified: row.is_phone_verified,
                is_email_verified: row.is_email_verified,
                is_verified: row.is_verified,
                check_ins: 960,
                ratings: 4.5,
                catalogoues: 81,
                orders: 742,
                free_credit: 50,
                paid_credit: 500,

            };
            return res.status(200).json({ status: 'success', message: 'success', data: data });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.trendingNearby = function(req, res, next) {
    try {
        var sql = "SELECT id, business_id, business_name, postal_code, landline, reach_whatsapp, business_email, address1, address2, address3, pincode, town_city, location, website, short_description, CONCAT('" + img_path + "', photo) as photo, business_status FROM `business_master` WHERE is_activated='1' AND deleted_at IS NULL LIMIT 5";
        db.query(sql, function(err, result_set, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.', error: err });
            } else if (result_set.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No record found.' });
            }

            return res.status(200).send({ status: 'success', message: 'success', data: result_set });
        });
    } catch (e) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong...' });
    }
};

exports.newBusiness = function(req, res, next) {
    try {
        // var sql = "SELECT id, business_id, business_name, postal_code, landline, reach_whatsapp, business_email, address1, address2, address3, pincode, town_city, location, website, short_description, CONCAT('" + img_path + "', photo) as photo, business_status FROM `business_master` WHERE is_activated='1' AND deleted_at IS NULL LIMIT 5";
        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 10";
        db.query(sql, function(err, result_set, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.', error: err });
            } else if (result_set.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No record found.' });
            }

            return res.status(200).send({ status: 'success', message: 'success', data: result_set });
        });
    } catch (e) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong...' });
    }
};

exports.topRated = function(req, res, next) {
    try {
        // var sql = "SELECT id, business_id, business_name, postal_code, landline, reach_whatsapp, business_email, address1, address2, address3, pincode, town_city, location, website, short_description, CONCAT('" + img_path + "', photo) as photo, business_status FROM `business_master` WHERE is_activated='1' AND deleted_at IS NULL LIMIT 5";
        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 10";
        db.query(sql, function(err, result_set, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.', error: err });
            } else if (result_set.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No record found.' });
            }

            return res.status(200).send({ status: 'success', message: 'success', data: result_set });
        });
    } catch (e) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong...' });
    }
};
exports.mostPopular = function(req, res, next) {
    try {
        // var sql = "SELECT id, business_id, business_name, postal_code, landline, reach_whatsapp, business_email, address1, address2, address3, pincode, town_city, location, website, short_description, CONCAT('" + img_path + "', photo) as photo, business_status FROM `business_master` WHERE is_activated='1' AND deleted_at IS NULL LIMIT 5";
        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 10";
        db.query(sql, function(err, result_set, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.', error: err });
            } else if (result_set.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No record found.' });
            }

            return res.status(200).send({ status: 'success', message: 'success', data: result_set });
        });
    } catch (e) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong...' });
    }
};