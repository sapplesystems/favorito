var db = require('../config/db');
var async = require('async');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
const NodeGeocoder = require('node-geocoder');
const options = {
    provider: 'google',
    apiKey: process.env.GOOGLE_MAP_API, // for Mapquest, OpenCage, Google Premier
};
const geocoder = NodeGeocoder(options);
exports.getDashboardDetail = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id, business_id, business_name, CONCAT('" + img_path + "', photo) as photo, business_status, is_profile_completed, is_information_completed, is_phone_verified, is_email_verified, is_verified FROM `business_master` WHERE business_id='" + business_id + "' AND deleted_at IS NULL";
        try {
            sql_data_ads_spent = `select free_credits,paid_credits from business_ad_credits where business_id = '${business_id}'`
            result_data_ads_spent = await exports.run_query(sql_data_ads_spent)
            sql_data_total_ads_spent = `select total_spent from business_ad_spent_campaign where business_id = '${business_id}'`
            result_data_total_ads_spent = await exports.run_query(sql_data_total_ads_spent)
            var sql_number_order = `SELECT COUNT(id) as count FROM business_orders WHERE business_id = '${business_id}'`
            var result_number_order = await exports.run_query(sql_number_order)
            var sql_number_catalogs = `SELECT COUNT(id) as count FROM business_catalogs WHERE business_id = '${business_id}'`
            var result_number_catalogs = await exports.run_query(sql_number_catalogs)
            var sql_avg_rating = `SELECT ifnull(AVG(rating),0) as avg_rating FROM business_ratings WHERE business_id = '${business_id}'`
            var result_avg_rating = await exports.run_query(sql_avg_rating)
            var sql_rating_count = `SELECT ifnull(count(rating),0) as rating_count FROM business_ratings WHERE business_id = '${business_id}'`
            var result_rating_count = await exports.run_query(sql_rating_count)
            var sql_number_checkin = `SELECT COUNT(id) as count FROM business_check_in WHERE business_id = '${business_id}'`
            var result_number_checkin = await exports.run_query(sql_number_checkin)
            var sql_get_accepting_order_status = `SELECT accepting_order from business_menu_setting where business_id = '${business_id}'`
            var result_get_accepting_order_status = await exports.run_query(sql_get_accepting_order_status)
            if (result_get_accepting_order_status != '') {
                accepting_order_status = result_get_accepting_order_status[0].accepting_order
            } else {
                accepting_order_status = 0
            }
        } catch (error) {
            return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
        }
        db.query(sql, function(err, result_set, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (result_set.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No record found.' });
            }
            var row = result_set[0];
            if (result_data_total_ads_spent[0] && result_data_total_ads_spent[0].total_spent) {
                total_spent = result_data_total_ads_spent[0].total_spent
            } else {
                total_spent = 0
            }
            if (result_data_ads_spent[0] && result_data_ads_spent[0].free_credits) {
                free_credits = result_data_ads_spent[0].free_credits
            } else {
                free_credits = 0
            }
            if (result_data_ads_spent[0] && result_data_ads_spent[0].paid_credits) {
                paid_credits = result_data_ads_spent[0].paid_credits
            } else {
                paid_credits = 0
            }
            var data = {
                id: row.id,
                business_id: row.business_id,
                status: accepting_order_status,
                business_name: row.business_name,
                photo: row.photo,
                business_status: row.business_status,
                is_profile_completed: row.is_profile_completed,
                is_information_completed: row.is_information_completed,
                is_phone_verified: row.is_phone_verified,
                is_email_verified: row.is_email_verified,
                is_verified: row.is_verified,
                check_ins: result_number_checkin[0].count,
                ratings: result_avg_rating[0].avg_rating,
                rating_count: result_rating_count[0].rating_count,
                catalogoues: result_number_catalogs[0].count,
                orders: result_number_order[0].count,
                total_spent: total_spent,
                free_credit: free_credits,
                paid_credit: paid_credits,
            };
            return res.status(200).json({ status: 'success', message: 'success', data: data });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

var user_pincode = (user_id) => {
    return new Promise(async(resolve, reject) => {
        try {
            pincode_user = ''
            sql_users_address_pincode_default = `select pincode from user_address where user_id = '${user_id}}' and default_address = 1`
            result_users_address_pincode_default = await exports.run_query(sql_users_address_pincode_default)
            if (result_users_address_pincode_default != '') {
                pincode_user = result_users_address_pincode_default[0].pincode
            }
            if (pincode_user == '') {
                sql_users_address_pincode = `select pincode from user_address where user_id = '${user_id}}'`
                result_users_address_pincode = await exports.run_query(sql_users_address_pincode)
                if (result_users_address_pincode && result_users_address_pincode[0] && result_users_address_pincode[0].pincode) {
                    pincode_user = result_users_address_pincode[0].pincode
                } else {
                    pincode_user = ''
                }
            }
            if (pincode_user == '') {
                sql_get_pincode_user = `select postal from users where id = '${user_id}'`
                pincode_user = (await exports.run_query(sql_get_pincode_user))[0].postal
            }
            if (pincode_user == '' || pincode_user == null) {
                reject('Something went wrong')
            }
            resolve(pincode_user)
        } catch (error) {
            reject('Something went wrong')
        }
    })
}

/* 
It will return the business only if it is available on that day and inside the time limit 
Return the data on basis of nearest by the calculation of the distance from the two lat and long
If the lat and long is not provided then it will the by the pincode
*/
exports.trendingNearby = async function(req, res, next) {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }

        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        limit = 10
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
        if (latitude != undefined && longitude != undefined) {
            var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, \n\
        IFNULL((SELECT AVG(rating) FROM business_ratings WHERE business_id = b_m.business_id),0) as avg_rating,\n\
        b_h.start_hours, b_h.end_hours, \n\
         SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
            POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
        ,business_category_id,b_m.pincode as pincode, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status \n\
        FROM business_master AS b_m \n\
        LEFT JOIN business_hours as b_h ON b_m.business_id = b_h.business_id \n\
        WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_h.day = '${day}' AND b_m.deleted_at IS NULL \n\
        AND b_h.start_hours < NOW() AND b_h.end_hours > NOW() \n\
        GROUP BY b_m.business_id  ORDER BY distance is null,distance LIMIT ${limit} OFFSET ${offset}`;
        }
        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`SELECT start_hours, end_hours FROM business_hours WHERE business_id = '${data.business_id}' AND day = '${day}'`, function(error, results2, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
                }
                if (results2 && results2[0]) {
                    data.start_hours = results2[0].start_hours
                    data.end_hours = results2[0].end_hours
                } else {
                    data.start_hours = '00:00:00'
                    data.end_hours = '23:59:59'
                }
            });

            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            if (final_data != '') {
                return res.status(200).send({ status: 'success', message: 'success', data: final_data });
            } else {
                return res.status(200).send({ status: 'success', message: 'No result is found' });
            }
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
};

var get_day_name = (date_object = false) => {
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
    return day
}

exports.newBusiness = async function(req, res, next) {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }
        limit = 10
        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
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

        if (latitude != undefined && longitude != undefined) {
            var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, \n\
        IFNULL((SELECT AVG(rating) FROM business_ratings WHERE business_id = b_m.business_id),0) as avg_rating,\n\
        b_h.start_hours, b_h.end_hours, \n\
         SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
            POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
        ,business_category_id,b_m.pincode as pincode, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status \n\
        FROM business_master AS b_m \n\
        LEFT JOIN business_hours as b_h ON b_m.business_id = b_h.business_id \n\
        WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_h.day = '${day}' AND b_m.deleted_at IS NULL \n\
        AND b_h.start_hours < NOW() AND b_h.end_hours > NOW() \n\
        GROUP BY b_m.business_id  ORDER BY distance IS NULL , distance,b_m.created_at LIMIT ${limit} OFFSET ${offset}`;
        }
        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
};

/* 
Return the businesss according to the top rating from the table rating 
*/
exports.topRated = async function(req, res, next) {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }
        limit = 10
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

        if (latitude != undefined && longitude != undefined) {
            var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, \n\
        IFNULL((SELECT AVG(rating) FROM business_ratings WHERE business_id = b_m.business_id),0) as avg_rating,\n\
        b_h.start_hours, b_h.end_hours, \n\
         SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
            POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
        ,business_category_id,b_m.pincode as pincode, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status \n\
        FROM business_master AS b_m \n\
        LEFT JOIN business_hours as b_h ON b_m.business_id = b_h.business_id \n\
        WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_h.day = '${day}' AND b_m.deleted_at IS NULL \n\
        AND b_h.start_hours < NOW() AND b_h.end_hours > NOW() \n\
        GROUP BY b_m.business_id ORDER BY avg_rating DESC, distance is null, distance LIMIT ${limit} OFFSET ${offset}`;
        }

        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.mostPopular = async function(req, res, next) {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }
        limit = 10
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

        if (latitude != undefined && longitude != undefined) {
            var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, \n\
        IFNULL((SELECT AVG(rating) FROM business_ratings WHERE business_id = b_m.business_id),0) as avg_rating,\n\
        b_h.start_hours, b_h.end_hours, \n\
         SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
            POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
        ,business_category_id,b_m.pincode as pincode, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status \n\
        FROM business_master AS b_m \n\
        LEFT JOIN business_hours as b_h ON b_m.business_id = b_h.business_id \n\
        WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_h.day = '${day}' AND b_m.deleted_at IS NULL \n\
        AND b_h.start_hours < NOW() AND b_h.end_hours > NOW() \n\
        GROUP BY b_m.business_id ORDER BY avg_rating DESC, distance is null, distance LIMIT ${limit} OFFSET ${offset}`;
        }

        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.sponsored = async function(req, res, next) {
    try {
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }
        limit = 10
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

        var sql = "SELECT b_m.id, b_m.business_id,b_m.is_activated, \n\
        IFNULL((SELECT AVG(rating) FROM business_ratings WHERE business_id = b_m.business_id),0) as avg_rating,\n\
         b_h.start_hours, b_h.end_hours, 2 as distance,business_category_id,b_m.pincode as pincode, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status \n\
         FROM `business_master` AS b_m \n\
         LEFT JOIN business_hours as b_h ON b_m.business_id = b_h.business_id \n\
         WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_h.day = '" + day + "' AND b_m.deleted_at IS NULL \n\
         AND b_h.start_hours < NOW() AND b_h.end_hours > NOW() \n\
        GROUP BY b_m.business_id LIMIT " + limit + " OFFSET " + offset + " ";
        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
    }
};

// return all the business which have by appoinment is 1 and business type is 2 
// this is for the freelancer
exports.getBusinessByAppointment = async function(req, res, next) {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }

        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        limit = 10

        var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , \n\
        SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
           POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\,business_category_id,b_m.by_appointment_only as appointment_only, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_m.by_appointment_only = 1 AND b_m.business_type_id = 2 AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ORDER BY distance is null, distance LIMIT ${limit} OFFSET ${offset}`;

        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
    }
};

// return all the business which have by appoinment is 1 and business type is 2 
// this is for the freelancer
// same as above for now
exports.getBusinessByFreelancer = async function(req, res, next) {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }

        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        limit = 10

        var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,  \n\
        SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
           POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\,business_category_id,b_m.by_appointment_only as appointment_only, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM 
        business_master  AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_m.by_appointment_only = 1 AND b_m.business_type_id = 2 AND b_m.deleted_at IS NULL GROUP BY b_m.business_id  ORDER BY distance is null, distance LIMIT ${limit} OFFSET ${offset}`;

        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
    }
};

// get all the business for book table whose by_appointment =0 and business_type_id = 1
exports.getBusinessByBookTable = async(req, res, next) => {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }

        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        limit = 10

        var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , \n\
        SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
           POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
           ,business_category_id,b_m.by_appointment_only as appointment_only, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo,b_m.business_type_id, b_m.business_status FROM
        business_master  AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_m.by_appointment_only = 0 AND b_m.business_type_id = 1 AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ORDER BY distance is null, distance LIMIT ${limit} OFFSET ${offset}`;

        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
    }
}

exports.getBusinessByJob = async function(req, res, next) {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }

        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        limit = 10
        var sql_get_business_id = `SELECT business_id FROM jobs`
        var result_sql_get_business_id = await exports.run_query(sql_get_business_id)
        regex = ''
        result_sql_get_business_id.forEach(element => {
            if (regex.length == '') {
                regex += element.business_id
            } else {
                regex += '|' + element.business_id
            }
        });

        var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , \n\
        SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
           POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
           ,business_category_id, b_m.business_name, b_m.town_city, CONCAT(' ${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m JOIN business_ratings AS b_r  ON b_m.business_id = b_r.business_id WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND b_m.business_id RLIKE '${regex}' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id order by distance is null, distance LIMIT ${limit} OFFSET ${offset}`;

        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
};

// get all the business which deals with food as category and sub category
exports.getBusinessByFood = async(req, res, next) => {
    try {
        let latitude = undefined
        let longitude = undefined
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }

        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        limit = 10

        var sql_main_category_id = `SELECT id, parent_id, category_name FROM business_categories WHERE category_name LIKE '%food%' AND parent_id = 0 LIMIT 1`
        var result_main_category_id = await exports.run_query(sql_main_category_id)
        regex = result_main_category_id[0].id

        var sql_sub_category_id = `SELECT id, parent_id, category_name FROM business_categories WHERE parent_id = ${result_main_category_id[0].id}`
        var result_sub_category_id = await exports.run_query(sql_sub_category_id)
        result_sub_category_id.forEach(element => {
            regex += '|' + element.id
        });
        var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,\n\
        SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
           POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
           ,business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND business_category_id  RLIKE '${regex}' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id order by distance is null, distance LIMIT ${limit} OFFSET ${offset}`;

        result_master = await exports.run_query(sql)
        var final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
    }
}

// get all the business which deal with the doctor as category and sub category
exports.getBusinessByDoctor = async(req, res, next) => {
    try {

        let latitude = undefined
        let longitude = undefined
        if (req.body.current_no_business) {
            offset = req.body.current_no_business
        } else {
            offset = 0
        }

        if (req.body.latitude && req.body.longitude) {
            latitude = req.body.latitude
            longitude = req.body.longitude
        } else {
            try {
                pincode_user = await user_pincode(req.userdata.id)
            } catch (error) {
                return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
            }
            const geo_location_detail = (await geocoder.geocode(pincode_user));
            latitude = geo_location_detail[0].latitude
            longitude = geo_location_detail[0].longitude
        }
        limit = 10

        var sql_main_category_id = `SELECT id, parent_id, category_name FROM business_categories WHERE category_name LIKE '%doctor%' AND parent_id = 0 LIMIT 1`
        var result_main_category_id = await exports.run_query(sql_main_category_id)
        if (result_main_category_id != 0) {
            regex = result_main_category_id[0].id
            var sql_sub_category_id = `SELECT id, parent_id, category_name FROM business_categories WHERE parent_id = ${result_main_category_id[0].id}`
            var result_sub_category_id = await exports.run_query(sql_sub_category_id)
            result_sub_category_id.forEach(element => {
                regex += '|' + element.id
            });
            var sql = `SELECT b_m.id, b_m.business_id,b_m.is_activated, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , \n\
            SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
               POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
               ,business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_verified='1' AND b_m.is_activated = '1' AND business_category_id  RLIKE '${regex}' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id order by distance is null , distance LIMIT ${limit} OFFSET ${offset}`;

            result_master = await exports.run_query(sql)
            var final_data = []
            async.eachSeries(result_master, function(data, callback) {
                db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                    if (error) {
                        return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                    }
                    data.sub_category = results1
                    final_data.push(data)
                    callback();
                });
            }, function(err, results) {
                if (err) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                return res.status(200).send({ status: 'success', message: 'success', data: final_data });
            });
        } else {
            return res.status(200).send({ status: 'success', message: 'Category not found' });
        }
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
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