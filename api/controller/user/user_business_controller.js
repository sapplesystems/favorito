var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var async = require('async');


// exports.searchByName = function(req, res, next) {
//     var where = "WHERE "
//     var weekdays = new Array(7);
//     weekdays[0] = "Sunday";
//     weekdays[1] = "Monday";
//     weekdays[2] = "Tuesday";
//     weekdays[3] = "Wednesday";
//     weekdays[4] = "Thursday";
//     weekdays[5] = "Friday";
//     weekdays[6] = "Saturday";
//     var current_date = new Date();
//     weekday_value = current_date.getDay();
//     current_day = weekdays[weekday_value].substring(0, 3)
//     try {
//         // return res.send(req.body.user_id)
//         if (req.body.keyword == null || req.body.keyword == undefined || req.body.keyword == '') {
//             where += "b_m.business_id = b_h.business_id AND b_h.`start_hours` < CURRENT_TIME() AND end_hours > CURRENT_TIME() AND  `day` = '" + current_day + "'"
//             var sql = "SELECT \n\
//             b_m.business_id,business_name, postal_code, business_phone, landline, reach_whatsapp, business_email, CONCAT('" + img_path + "', photo) as photo, town_city, short_description \n\
//             FROM business_master AS b_m JOIN business_hours AS b_h \n\
//             " + where + "  \n\
//             GROUP BY b_m.`business_id`"
//         } else {
//             where += "b_m.business_id = b_h.business_id AND b_h.`start_hours` < CURRENT_TIME() AND end_hours > CURRENT_TIME() AND  `day` = '" + current_day + "' AND business_name LIKE '%" + req.body.keyword + "%'"
//             var sql = "SELECT \n\
//             b_m.business_id,business_name, postal_code, business_phone, landline, reach_whatsapp, business_email, CONCAT('" + img_path + "', photo) as photo, town_city, short_description \n\
//             FROM business_master AS b_m JOIN business_hours AS b_h \n\
//             " + where + "  \n\
//             GROUP BY b_m.`business_id`"
//         }
//         db.query(sql, function(err, result) {
//             if (err) {
//                 return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
//             }
//             return res.status(200).send({ status: 'success', message: 'Successfull', data: result })
//         })
//     } catch (error) {
//         res.status(500).json({ status: 'error', message: 'Something went wrong.', error: error })
//     }
// }


exports.searchByName = async function(req, res, next) {
    try {
        var d = new Date();
        var weekday = new Array(7);
        weekday[0] = "Sunday";
        weekday[1] = "Monday";
        weekday[2] = "Tuesday";
        weekday[3] = "Wednesday";
        weekday[4] = "Thursday";
        weekday[5] = "Friday";
        weekday[6] = "Saturday";

        var day = weekday[d.getDay()].substring(0, 3);
        if (req.body.keyword == null || req.body.keyword == undefined || req.body.keyword == '') {
            var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,b_h.start_hours, b_h.end_hours, 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m JOIN business_hours as b_h  JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id AND b_m.business_id = b_h.business_id WHERE b_m.is_activated='1' AND b_h.day = '" + day + "' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";
        } else {
            var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,b_h.start_hours, b_h.end_hours, 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m JOIN business_hours as b_h  JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id AND b_m.business_id = b_h.business_id WHERE b_m.is_activated='1' AND b_m.business_name LIKE '%" + req.body.keyword + "%' AND b_h.day = '" + day + "' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";
        }

        result_master = await exports.run_query(sql)
        final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                    // final_data.push(data)
                    // callback();
            });

            db.query(`SELECT b_a_m.attribute_name as attribute_name FROM business_attributes as b_a LEFT JOIN business_attributes_master as b_a_m ON b_a_m.id = b_a.attributes_id WHERE b_a.business_id= '${data.business_id}'`, function(error, results2, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
                }
                data.attributes = results2
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }

            // adding the attribute to the business

            // sql = "SELECT b_a_m.attribute_name as attribute_name FROM business_attributes as b_a LEFT JOIN business_attribute "

            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
};

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