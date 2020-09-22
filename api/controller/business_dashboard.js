var db = require('../config/db');

exports.getDashboardDetail = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id, business_id, business_name, photo, business_status, is_profile_completed, is_information_completed, is_phone_verified, is_email_verified, is_verified FROM `business_master` \n\
                    WHERE business_id='" + business_id + "' AND is_activated='1' AND deleted_at IS NULL";
        db.query(sql, function (err, result_set, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (result_set.length === 0) {
                return res.status(404).send({ status: 'error', message: 'No record found.' });
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