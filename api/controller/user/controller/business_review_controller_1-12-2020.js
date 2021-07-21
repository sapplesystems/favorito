var db = require('../config/db');
exports.all_business_reviewlist = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.review_id != '' && req.body.review_id != undefined && req.body.review_id != null) {
            var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
            DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE id='" + req.body.review_id + "' AND deleted_at IS NULL";
        } else {
            var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
            DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
        }
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            if (result.length > 0) {
                return res.status(200).json({ status: 'success', message: 'success', data: result });
            } else {
                return res.status(200).json({ status: 'success', message: 'NO Data Found', data: [] });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};
exports.get_review_with_replies = function(req, res, next) {
    try {
        var user_id = null;
        var business_id = null;
        if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
            var business_id = req.userdata.business_id;
            if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
                var user_id = req.body.user_id;
            } else {
                return res.status(500).json({ status: 'error', message: 'user_id is missing' });
            }
        } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
            var business_id = req.body.business_id;
            if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
                var user_id = req.userdata.id;
            } else {
                return res.status(500).json({ status: 'error', message: 'user_id is missing' });
            }
        } else {
            return res.status(500).json({ status: 'error', message: 'business_id is missing' });
        }
        if (req.body.review_id != '' && req.body.review_id != undefined && req.body.review_id != null) {
            review_id = req.body.review_id
        } else {
            return res.status(500).json({ status: 'error', message: 'review_id is missing' });
        }
        var sql = "SELECT id, (select first_name from users where id=" + user_id + ") as user_name, reviews, parent_id, b_to_u, created_at FROM `business_reviews` WHERE id>='" + review_id + "' AND user_id='" + user_id + "' and business_id ='" + business_id + "' order by parent_id";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            if (result.length > 0) {
                final_result = []
                var start_id = review_id
                final_result.push(result[0])
                result.forEach(element => {
                    result.forEach((value, index, arr) => {
                        if (value.parent_id == start_id) {
                            final_result.push(value)
                            start_id = value.id
                        }
                    })
                });
                return res.status(200).json({ status: 'success', message: 'success', data: final_result });
            } else {
                return res.status(200).json({ status: 'success', message: 'NO Data Found' });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};