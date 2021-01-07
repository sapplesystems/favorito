var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
exports.businessCarouselList = async function(req, res, next) {
    await exports.getCaruoselData(res)
}

exports.getCaruoselData = async function(res) {
    try {
        var sql = 'SELECT business_id,CONCAT("' + img_path + '",photo) as photo FROM business_master ORDER BY created_at DESC LIMIT 15'
        await db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

exports.getUserReview = async function(req, res, next) {
    try {
        var sql = "SELECT * FROM user_review_rating WHERE id = '" + req.body.user_id + "'"
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}


exports.userProfilePhoto = async function(req, res, next) {
    try {
        var sql = "SELECT concat('" + img_path + "',photo) as photo  FROM users WHERE id = '" + req.body.user_id + "' AND deleted_at IS NULL"
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

// return all the photos uploaded by the user
exports.userAllPhoto = async function(req, res, next) {
    try {
        var sql = "SELECT concat('" + img_path + "',image) as photo  FROM user_photos WHERE user_id = '" + req.body.user_id + "' AND deleted_at IS NULL"
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

// return all the favourite business
exports.userFavouriteBusiness = async function(req, res, next) {
    getFavouriteId = new Promise(function(resolve, reject) {
        var sql = "SELECT business_id, business_type_id, business_category_id, business_name,business_phone,landline, business_email, concat('" + img_path + "',photo) as photo, address1,address2, address3,location, short_description,business_status FROM business_master INNER JOIN user_relationships ON business_master.business_id = user_relationships.target_id WHERE user_relationships.source_id = '" + req.body.user_id + "' AND relation_type = 'favourite' AND business_master.deleted_at IS NULL"
        try {
            db.query(sql, function(err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
                }
                resolve(result)
            })
        } catch (error) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
        }
    })

    query_result = await getFavouriteId
    return res.status(200).send({ status: 'success', message: 'respone successfull', data: query_result })
}

exports.userProfilePhoto = async function(req, res, next) {
    try {
        var sql = "SELECT concat('" + img_path + "',photo) as photo  FROM users WHERE id = '" + req.body.user_id + "' AND deleted_at IS NULL"
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

exports.userGetBadges = function(req, res, next) {
    try {
        // return res.send(req.body.user_id)
        if (req.body.user_id == null || req.body.user_id == undefined || req.body.user_id == '') {
            return res.status(500).json({ status: 'error', message: 'User id is not found', error: err });
        }
        var sql = "SELECT badge_id FROM user_badges WHERE user_id = '" + req.body.user_id + "'"
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'Successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}