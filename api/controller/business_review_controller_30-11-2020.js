var db = require('../config/db');
exports.all_business_reviewlist = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
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