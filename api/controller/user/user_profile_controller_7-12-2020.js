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

exports.setUserProfilePhoto = async function(req, res, next) {
    try {
        if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
            user_id = req.userdata.id;
        } else if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
            user_id = req.body.id;
        } else {
            return res.status(500).json({ status: 'error', message: 'user_id is missing' });
        }
        if (req.file && req.file.filename != '') {
            var sql = `UPDATE users set photo = '${req.file.filename}' where id = ${user_id}`
            db.query(sql, function(err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                }
                return res.status(200).send({ status: 'success', message: 'respone successfull' })
            })
        }
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

// exports.userFavouriteBusiness = async function(req, res, next) {
//     getFavouriteId = new Promise(function(resolve, reject) {
//         var sql = "SELECT business_id, business_type_id, business_category_id, business_name,business_phone,landline, business_email, concat('" + img_path + "',photo) as photo, address1,address2, address3,location, short_description,business_status FROM business_master INNER JOIN user_relationships ON business_master.business_id = user_relationships.target_id WHERE user_relationships.source_id = '" + req.body.user_id + "' AND relation_type = 'favourite' AND business_master.deleted_at IS NULL"
//         try {
//             db.query(sql, function(err, result) {
//                 if (err) {
//                     return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
//                 }
//                 resolve(result)
//             })
//         } catch (error) {
//             return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
//         }
//     })

//     query_result = await getFavouriteId
//     return res.status(200).send({ status: 'success', message: 'respone successfull', data: query_result })
// }

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





// Favorite function

//  set favorite 

// exports.setFavorite = (req, res, next) => {
//     if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
//         var business_id = req.userdata.business_id;
//         source_id = business_id;
//         if (req.body.target_id != null && req.body.target_id != undefined && req.body.target_id != '') {
//             var target_id = req.body.target_id;
//         } else {
//             return res.status(500).json({ status: 'error', message: 'user_id is missing' });
//         }
//     } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
//         var target_id = req.body.business_id;
//         if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
//             var source_id = req.userdata.id;
//         } else {
//             return res.status(500).json({ status: 'error', message: 'user_id is missing' });
//         }
//     } else {
//         return res.status(500).json({ status: 'error', message: 'business_id is missing' });
//     }
//     if (req.body.relation_type != null && req.body.relation_type != undefined && req.body.relation_type != '') {
//         return res.status(500).json({ status: 'error', message: 'relation_type is missing' });
//     }

//     var sql = `SELECT COUNT(*) FROM user_business_relation WHERE source_id = ${source_id} AND target_id = ${target_id} AND relation_type = `

//     result_count = exports.run_query(sql)
//     return res.send(result)


// }

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