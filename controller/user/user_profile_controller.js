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


// exports.userPhotos = async function(req, res, next) {
//     try {
//         var sql = "SELECT  FROM user_review_rating WHERE id = '" + req.body.user_id + "'"
//         db.query(sql, function(err, result) {
//             if (err) {
//                 return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
//             }
//             return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
//         })
//     } catch (error) {
//         res.status(500).json({ status: 'error', message: 'Something went wrong.' })
//     }
// }