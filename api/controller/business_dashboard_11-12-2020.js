var db = require('../config/db');
var async = require('async');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.getDashboardDetail = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id, business_id, business_name, CONCAT('" + img_path + "', photo) as photo, business_status, is_profile_completed, is_information_completed, is_phone_verified, is_email_verified, is_verified FROM `business_master` \n\
                    WHERE business_id='" + business_id + "' AND is_activated='1' AND deleted_at IS NULL";
        db.query(sql, function(err, result_set, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (result_set.length === 0) {
                return res.status(403).send({ status: 'error', message: 'No record found.' });
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

// exports.trendingNearby = async function(req, res, next) {
//     try {
//         var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";
//         // var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r JOIN busienss_categories as b_c ON b_m.business_id = b_r.business_id AND b_m.business_category_id = b_c.parent_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 10";

//         result_master = await exports.run_query(sql)
//         final_data = []
//         async.eachSeries(result_master, function(data, callback) {
//             db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
//                 if (error) {
//                     return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
//                 }
//                 data.sub_category = results1
//                 final_data.push(data)
//                 callback();
//             });
//         }, function(err, results) {
//             if (err) {
//                 return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
//             }
//             return res.status(200).send({ status: 'success', message: 'success', data: final_data });
//         });
//     } catch (error) {
//         return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
//     }
// };

exports.trendingNearby = async function(req, res, next) {
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

        // var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";

        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,b_h.start_hours, b_h.end_hours, 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m JOIN business_hours as b_h  JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id AND b_m.business_id = b_h.business_id WHERE b_m.is_activated='1' AND b_h.day = '" + day + "' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";

        result_master = await exports.run_query(sql)
        final_data = []
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

exports.newBusiness = async function(req, res, next) {
    try {
        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";
        // var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r JOIN busienss_categories as b_c ON b_m.business_id = b_r.business_id AND b_m.business_category_id = b_c.parent_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 10";

        result_master = await exports.run_query(sql)
        final_data = []
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

exports.topRated = async function(req, res, next) {
    try {
        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";

        result_master = await exports.run_query(sql)
        final_data = []
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
        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id,b_m.by_appointment_only as appointment_only, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.by_appointment_only = 1 AND b_m.business_type_id = 2 AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";

        result_master = await exports.run_query(sql)
        final_data = []
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
        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id,b_m.by_appointment_only as appointment_only, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo,b_m.business_type_id, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.by_appointment_only = 0 AND b_m.business_type_id = 1 AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";

        result_master = await exports.run_query(sql)
        final_data = []
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

exports.mostPopular = async function(req, res, next) {
    try {
        var sql = "SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5";

        result_master = await exports.run_query(sql)
        final_data = []
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

exports.getBusinessByJob = async function(req, res, next) {
    try {

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
        var sql = `SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT(' ${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m JOIN business_ratings AS b_r  ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND b_m.business_id RLIKE '${regex}' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id`;

        result_master = await exports.run_query(sql)
        final_data = []
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
        var sql_main_category_id = `SELECT id, parent_id, category_name FROM business_categories WHERE category_name LIKE '%food%' AND parent_id = 0 LIMIT 1`
        var result_main_category_id = await exports.run_query(sql_main_category_id)
        regex = result_main_category_id[0].id

        var sql_sub_category_id = `SELECT id, parent_id, category_name FROM business_categories WHERE parent_id = ${result_main_category_id[0].id}`
        var result_sub_category_id = await exports.run_query(sql_sub_category_id)
        result_sub_category_id.forEach(element => {
            regex += '|' + element.id
        });
        var sql = `SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND business_category_id  RLIKE '${regex}' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5`;

        result_master = await exports.run_query(sql)
        final_data = []
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
        var sql_main_category_id = `SELECT id, parent_id, category_name FROM business_categories WHERE category_name LIKE '%doctor%' AND parent_id = 0 LIMIT 1`
        var result_main_category_id = await exports.run_query(sql_main_category_id)
        if (result_main_category_id != 0) {
            regex = result_main_category_id[0].id
            var sql_sub_category_id = `SELECT id, parent_id, category_name FROM business_categories WHERE parent_id = ${result_main_category_id[0].id}`
            var result_sub_category_id = await exports.run_query(sql_sub_category_id)
            result_sub_category_id.forEach(element => {
                regex += '|' + element.id
            });
            var sql = `SELECT b_m.id, b_m.business_id, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id WHERE b_m.is_activated='1' AND business_category_id  RLIKE '${regex}' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id LIMIT 5`;

            result_master = await exports.run_query(sql)
            final_data = []
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