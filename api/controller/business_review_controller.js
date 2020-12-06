const { query } = require('express');
var db = require('../config/db');
exports.all_business_reviewlist = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.page_size == null || req.body.page_size == undefined || req.body.page_size == '' || req.body.page_size == 0 || req.body.page_size == 1) {
            var data_from = 0;
        } else {
            var num = parseInt(req.body.page_size.trim());
            var data_from = (num - 1) * 8;
        }

        if (req.body.review_id != '' && req.body.review_id != undefined && req.body.review_id != null) {
            var sql = "SELECT b_r.id, u.full_name, b_r.user_id as user_id,b_r.business_id as business_id,b_rate.rating as rating, reviews, DATE_FORMAT(b_r.created_at, '%Y-%m-%d') as review_date, \n\
            DATE_FORMAT(b_r.created_at, '%H:%i') AS review_at \n\
            FROM business_reviews as b_r\n\
            JOIN users as u ON u.id = b_r.user_id  \n\
            JOIN business_ratings as b_rate ON u.id = b_rate.user_id  \n\
            WHERE b_r.business_id='" + business_id + "' AND b_r.deleted_at IS NULL AND b_r.parent_id = 0 AND b_r.id = '" + req.body.review_id + "'  ORDER BY id DESC LIMIT 8 OFFSET " + data_from;
        } else {
            var sql = "SELECT b_r.id, u.full_name, b_r.user_id as user_id,b_r.business_id as business_id,b_rate.rating as rating, reviews, DATE_FORMAT(b_r.created_at, '%Y-%m-%d') as review_date, \n\
            DATE_FORMAT(b_r.created_at, '%H:%i') AS review_at \n\
            FROM business_reviews as b_r\n\
            JOIN users as u ON u.id = b_r.user_id  \n\
            JOIN business_ratings as b_rate ON u.id = b_rate.user_id  \n\
            WHERE b_r.business_id='" + business_id + "' AND b_r.deleted_at IS NULL AND b_r.parent_id = 0 ORDER BY id DESC LIMIT 8 OFFSET " + data_from;
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

// provide user_id, business_id and rating to insert
// provide rating_id to alter
// provide 
exports.rating_review_detail = async function(req, res, next) {
    if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
        var business_id = req.userdata.business_id;
    } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
        var business_id = req.body.business_id;
    } else {
        return res.status(500).json({ status: 'error', message: 'business_id is missing' });
    }

    try {
        var sql_avg = "SELECT AVG(rating) as avg_rating FROM business_ratings WHERE business_id = '" + business_id + "'"
        var sql_rating_points = "SELECT \n\
        (SELECT COUNT(rating) FROM business_ratings WHERE rating = 1 AND business_id = '" + business_id + "') as rating_1, \n\
        (SELECT COUNT(rating) FROM business_ratings WHERE rating = 2 AND business_id = '" + business_id + "') as rating_2, \n\
        (SELECT COUNT(rating) FROM business_ratings WHERE rating = 3 AND business_id = '" + business_id + "') as rating_3, \n\
        (SELECT COUNT(rating) FROM business_ratings WHERE rating = 4 AND business_id = '" + business_id + "') as rating_4, \n\
        (SELECT COUNT(rating) FROM business_ratings WHERE rating = 5 AND business_id = '" + business_id + "') as rating_5 \n\
        FROM business_ratings WHERE business_id = '" + business_id + "' GROUP BY business_id";
        var sql_total_rating = "SELECT COUNT(*) as total_ratings FROM business_ratings WHERE business_id = '" + business_id + "'"
        var sql_total_review = "SELECT COUNT(*) as total_reviews FROM business_reviews WHERE business_id = '" + business_id + "'"
        var total_review = (await exports.run_query(sql_total_review))[0]
        var ratings_by_points = (await exports.run_query(sql_rating_points))[0]
        var total_rating = (await exports.run_query(sql_total_rating))[0]
        var avg_rating_data = (await exports.run_query(sql_avg))[0]

        data = { business_id, total_rating, total_review, avg_rating_data, ratings_by_points }
        return res.status(200).json({ status: 'success', message: 'success', data });
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: error });
    }
}

exports.set_review = async(req, res, next) => {
    var user_id = null;
    var business_id = null;
    var b_to_u = null
    if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
        var business_id = req.userdata.business_id;
        b_to_u = 1;
        if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
            var user_id = req.body.user_id;
        } else {
            return res.status(500).json({ status: 'error', message: 'user_id is missing' });
        }
    } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
        b_to_u = 0;
        var business_id = req.body.business_id;
        if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
            var user_id = req.userdata.id;
        } else {
            return res.status(500).json({ status: 'error', message: 'user_id is missing' });
        }
    } else {
        return res.status(500).json({ status: 'error', message: 'business_id is missing' });
    }
    if (req.body.review != null && req.body.review != undefined && req.body.review != '') {
        var reviews = req.body.review;
    } else {
        return res.status(500).json({ status: 'error', message: 'review is missing' });
    }

    if (req.body.parent_id != null && req.body.parent_id != undefined && req.body.parent_id != '') {
        var parent_id = req.body.parent_id;
    } else {
        parent_id = 0;
    }

    data_insert = {
        business_id,
        user_id,
        reviews,
        b_to_u,
        parent_id,
    }

    sql_insert = "INSERT INTO business_reviews SET ?"
    try {
        result = await exports.run_query(sql_insert, data_insert)
        if (result.affectedRows) {
            return res.status(200).json({ status: 'success', message: 'data inserted successfully' });
        }
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
    }
}

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
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }
}