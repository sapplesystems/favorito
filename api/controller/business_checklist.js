const { response } = require('../app');
var db = require('../config/db');
var dateArr = ['2020-11-04', '2020-11-03'];
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';


exports.business_get_checkin = async(req, res, next) => {
    let condition = ''
    if (req.body.user_id) {
        user_id = req.body.user_id
        condition = `b_c.user_id = '${user_id}'  `
    }

    if (req.userdata.business_id) {
        business_id = req.userdata.business_id
        condition = `${condition} b_c.business_id = '${business_id}'  `
    }

    if (req.body.checkin_id) {
        condition = `b_c.id = '${req.body.checkin_id}'`
    }

    condition = 'WHERE ' + condition.trim().replace('  ', ' AND ')
    sql_get_data = `SELECT b_c.id as checkin_id, b_c.user_id as user_id,IFNULL(u_a.city,'') AS city,IFNULL(u_a.state,'') AS state,concat('${img_path}',photo) as photo ,u.full_name,u.email,u.phone,b_c.created_at FROM business_check_in  as b_c \n\
    JOIN users as u LEFT JOIN user_address as u_a  ON b_c.user_id = u.id AND u.id = u_a.user_id
    ${condition} GROUP BY checkin_id`

    try {
        result_get_data = await exports.run_query(sql_get_data)
        return res.send(result_get_data)
        return res.status(200).json({ status: 'success', message: 'success', data: result_get_data });
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'failed', error });
    }
}

/**
 * FETCH ALL REVIEWS
 */
exports.all_business_reviewlist = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
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

/**
 * FETCH CHECK IN LIST
 * type->0 means all, type->1 means pending reviews
 */
exports.business_check_in_list = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.type == '' || req.body.type == 'undefined' || req.body.type == null) {
            return res.status(403).json({ status: 'error', message: 'Type not found.' });
        } else {
            var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
            DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
            db.query(sql, async function(err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                }
                if (result.length > 0) {
                    if (req.body.type == 0) {
                        return res.status(200).json({ status: 'success', message: 'success', data: result });
                    } else if (req.body.type == 1) {
                        var newReview = [];
                        var allReview = [];
                        for (var i = 0; i < result.length; i++) {
                            var reviewdate = result[i].review_date;
                            if (dateArr.indexOf(reviewdate) !== -1) {
                                newReview.push(result[i]);
                            } else {
                                allReview.push(result[i]);
                            }
                        }
                        var DataArr = {
                            "newReview": newReview,
                            "allReview": allReview
                        };
                        return res.status(200).json({ status: 'success', message: 'success', data: DataArr });
                    }
                } else {
                    return res.status(200).json({ status: 'success', message: 'NO Data Found', data: [] });
                }

            });
        }

    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

async function checklistdata(business_id) {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%d %b') as review_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
        db.query(sql, function(err, result) {
            resolve(result);
        });
    });
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
                    console.log(error)
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }
}