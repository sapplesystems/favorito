var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.searchByName = function(req, res, next) {
    try {
        // return res.send(req.body.user_id)
        if (req.body.keyword == null || req.body.keyword == undefined || req.body.keyword == '') {
            var sql = "SELECT business_name, postal_code, business_phone, landline, reach_whatsapp, business_email, CONCAT('" + img_path + "',photo) as photo, address1, address2 ,address3, pincode, town_city, state_id,country_id, location, by_appointment_only, working_hours,website, short_description, business_status, is_profile_completed FROM business_master LIMIT 5"
        } else {
            var sql = "SELECT business_name, postal_code, business_phone, landline, reach_whatsapp, business_email, CONCAT('" + img_path + "',photo) as photo, address1, address2 ,address3, pincode, town_city, state_id,country_id, location, by_appointment_only, working_hours,website, short_description, business_status, is_profile_completed FROM business_master WHERE business_name LIKE '%" + req.body.keyword + "%'"
        }
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).send({ status: 'success', message: 'Successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.', error: error })
    }
}