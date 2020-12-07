var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.searchByName = function(req, res, next) {
    var where = "WHERE "
    var weekdays = new Array(7);
    weekdays[0] = "Sunday";
    weekdays[1] = "Monday";
    weekdays[2] = "Tuesday";
    weekdays[3] = "Wednesday";
    weekdays[4] = "Thursday";
    weekdays[5] = "Friday";
    weekdays[6] = "Saturday";
    var current_date = new Date();
    weekday_value = current_date.getDay();
    current_day = weekdays[weekday_value].substring(0, 3)
    try {
        // return res.send(req.body.user_id)
        if (req.body.keyword == null || req.body.keyword == undefined || req.body.keyword == '') {
            // var sql = "SELECT \n\
            // business_name, postal_code, business_phone, landline, reach_whatsapp, business_email, CONCAT('" + img_path + "', photo) as photo, town_city, short_description \n\
            // FROM business_master \n\
            // LIMIT 10 "
            where += "b_m.business_id = b_h.business_id AND b_h.`start_hours` < CURRENT_TIME() AND end_hours > CURRENT_TIME() AND  `day` = '" + current_day + "'"
            var sql = "SELECT \n\
            b_m.business_id,business_name, postal_code, business_phone, landline, reach_whatsapp, business_email, CONCAT('" + img_path + "', photo) as photo, town_city, short_description \n\
            FROM business_master AS b_m JOIN business_hours AS b_h \n\
            " + where + "  \n\
            GROUP BY b_m.`business_id`"
        } else {


            where += "b_m.business_id = b_h.business_id AND b_h.`start_hours` < CURRENT_TIME() AND end_hours > CURRENT_TIME() AND  `day` = '" + current_day + "' AND business_name LIKE '%" + req.body.keyword + "%'"
            var sql = "SELECT \n\
            b_m.business_id,business_name, postal_code, business_phone, landline, reach_whatsapp, business_email, CONCAT('" + img_path + "', photo) as photo, town_city, short_description \n\
            FROM business_master AS b_m JOIN business_hours AS b_h \n\
            " + where + "  \n\
            GROUP BY b_m.`business_id`"

            // where += "business_name LIKE '%" + req.body.keyword + "%'"
            // var sql = "SELECT \n\
            // business_name, postal_code, business_phone, landline, reach_whatsapp, business_email, CONCAT('" + img_path + "',photo) as photo, town_city, short_description \n\
            // FROM business_master " + where
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