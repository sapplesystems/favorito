var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

// get all waitlist by business_id

exports.business_waitlist = function(req, res, next) {
    try {
        var business_id = req.body.business_id;
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes,waitlist_status, DATE_FORMAT(created_at, '%d %b') as waitlist_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS walkin_at FROM business_waitlist WHERE business_id='" + business_id + "' AND deleted_at IS NULL";
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

exports.set_waitlist = function(req, res, next) {

}