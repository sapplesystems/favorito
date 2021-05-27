var db = require('../config/db');
var contact_via = ['Phone', 'Email'];
const NodeGeocoder = require('node-geocoder');
const options = {
    provider: 'google',
    apiKey: process.env.GOOGLE_MAP_API, // for Mapquest, OpenCage, Google Premier
};
const geocoder = NodeGeocoder(options);

exports.all_jobs = function(req, res, next) {
    try {
        if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
            business_id = req.body.business_id
        } else {
            var business_id = req.userdata.business_id;
        }
        var where_condition = " WHERE business_id='" + business_id + "' AND deleted_at IS NULL ";

        if (req.body.job_id != '' && req.body.job_id != 'undefined' && req.body.job_id != null) {
            where_condition += " AND id='" + req.body.job_id + "' ";
        }

        var sql = "SELECT id,title,description,no_of_position FROM jobs " + where_condition;
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({
                status: 'success',
                message: 'success',
                contact_via: contact_via,
                data: result
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * FETCH ALL JOB
 */
// exports.all_jobs = async function(req, res, next) {
//     try {
//         if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
//             business_id = req.body.business_id
//         } else if (req.userdata.business_id) {
//             var business_id = req.userdata.business_id;
//         } else {
//             return res.status(400).json({ status: 'error', message: 'business_id is missing.' });
//         }
//         if (business_id) {

//             var where_condition = " WHERE business_id='" + business_id + "' AND deleted_at IS NULL ";

//             if (req.body.job_id != '' && req.body.job_id != 'undefined' && req.body.job_id != null) {
//                 where_condition += " AND id='" + req.body.job_id + "' ";
//             }

//             var sql = "SELECT id,title,description,no_of_position FROM jobs " + where_condition;
//             db.query(sql, function(err, result) {
//                 if (err) {
//                     return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//                 }
//                 return res.status(200).json({
//                     status: 'success',
//                     message: 'success',
//                     contact_via: contact_via,
//                     data: result
//                 });
//             });
//         } else if (req.body.job_keyword) {
//             try {
//                 let latitude = undefined
//                 let longitude = undefined
//                 if (req.body.current_no_business) {
//                     offset = req.body.current_no_business
//                 } else {
//                     offset = 0
//                 }
//                 limit = 10
//                 if (req.body.latitude && req.body.longitude) {
//                     latitude = req.body.latitude
//                     longitude = req.body.longitude
//                 } else {
//                     try {
//                         pincode_user = await user_pincode(req.userdata.id)
//                     } catch (error) {
//                         return res.status(403).json({ status: 'error', message: 'Pincode is not found , please update the pincode' });
//                     }
//                     const geo_location_detail = (await geocoder.geocode(pincode_user));
//                     latitude = geo_location_detail[0].latitude
//                     longitude = geo_location_detail[0].longitude
//                 }

//                 var d = new Date();
//                 var weekday = new Array(7);
//                 weekday[0] = "Sunday";
//                 weekday[1] = "Monday";
//                 weekday[2] = "Tuesday";
//                 weekday[3] = "Wednesday";
//                 weekday[4] = "Thursday";
//                 weekday[5] = "Friday";
//                 weekday[6] = "Saturday";

//                 var day = weekday[d.getDay()].substring(0, 3);
//                 if (req.body.keyword == null || req.body.keyword == undefined || req.body.keyword == '') {
//                     var sql = `SELECT b_m.id, b_m.business_id, b_m.business_phone as phone, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,b_h.start_hours, b_h.end_hours,  \n\
//                     SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
//                        POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
//                        ,business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m \n\
//                     LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id\n\
//                     LEFT JOIN business_hours as b_h ON b_m.business_id = b_h.business_id\n\
//                     WHERE b_m.is_activated='1' and b_m.is_verified = 1\n\
//                     AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ORDER BY distance is null,distance LIMIT ${limit} OFFSET ${offset}`;
//                 } else {

//                     keyword = req.body.keyword.trim()
//                         // global replacement
//                     keyword = `%${keyword.replace(/ /g, '%-%')}%`
//                     keyword = ` b_m.business_name LIKE ${keyword.replace(/-/g," OR b_m.business_name LIKE ")}`
//                     keyword = keyword.replace(/ %/g, " '%")
//                     keyword = keyword.replace(/% /g, "%' ")
//                     keyword = `${keyword}' `


//                     var sql = `SELECT b_m.id, b_m.business_id, b_m.business_phone as phone, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , \n\
//                     SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
//                        POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
//                        , business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m \n\
//                     LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id \n\
//                     WHERE b_m.is_activated='1' and b_m.is_verified = 1 AND ${keyword} AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ORDER BY distance is null,distance LIMIT ${limit} OFFSET ${offset}`;
//                 }

//                 result_master = await exports.run_query(sql)

//                 final_data = []
//                 async.eachSeries(result_master, function(data, callback) {
//                     db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
//                         if (error) {
//                             return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
//                         }
//                         data.sub_category = results1
//                     });

//                     db.query(`select day,start_hours,end_hours from business_hours where business_id = '${data.business_id}' AND day = '${day}'AND start_hours < NOW() AND end_hours > NOW()`, function(error, result_hour, filelds) {
//                         if (error) {
//                             return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
//                         }
//                         if (data.business_status == 'online' || data.business_status == 'Online') {
//                             if (result_hour == '') {
//                                 data.start_hours = null
//                                 data.end_hours = null
//                                 data.business_status = 'offline'
//                             } else {
//                                 data.start_hours = result_hour[0].start_hours
//                                 data.end_hours = result_hour[0].end_hours
//                                 data.business_status = 'online'

//                             }
//                         } else {
//                             data.start_hours = null
//                             data.end_hours = null
//                         }
//                     });


//                     db.query(`SELECT b_a_m.attribute_name as attribute_name FROM business_attributes as b_a LEFT JOIN business_attributes_master as b_a_m ON b_a_m.id = b_a.attributes_id WHERE b_a.business_id= '${data.business_id}'`, function(error, results2, filelds) {
//                         if (error) {
//                             return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
//                         }
//                         data.attributes = results2
//                         final_data.push(data)
//                         callback();
//                     });

//                 }, function(err, results) {
//                     if (err) {
//                         return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
//                     }

//                     // adding the attribute to the business

//                     // sql = "SELECT b_a_m.attribute_name as attribute_name FROM business_attributes as b_a LEFT JOIN business_attribute "
//                     if (final_data == '') {
//                         return res.status(200).send({ status: 'success', message: 'Could not find such business', data: [] });
//                     }
//                     return res.status(200).send({ status: 'success', message: 'success', data: final_data });
//                 });
//             } catch (error) {
//                 return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
//             }
//         }
//     } catch (e) {
//         return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//     }
// };


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

/**
 * STATIC DROP DONW DETAI TO CREATE THE JOB
 */
exports.dd_verbose = async function(req, res, next) {
    try {
        var verbose = {};
        verbose.contact_via = contact_via;
        verbose.skill_list = await exports.getSkillList();
        verbose.city_list = await exports.getCityList();
        return res.status(200).json({ status: 'success', message: 'success', data: verbose });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET SKILL LIST
 */
exports.getSkillList = function() {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT id,skill FROM skills";
        db.query(sql, function(err, skill_list) {
            resolve(skill_list);
        });
    });
}


/**
 * GET CITY LIST
 */
exports.getCityList = function() {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT id,city FROM cities";
        db.query(sql, function(err, city_list) {
            resolve(city_list);
        });
    });
}


/**
 * GET PINCODE LIST OF THE CITY
 */
// exports.city_pincode = function(req, res, next) {
//     try {
//         if (req.body.city_id == '' || req.body.city_id == 'undefined' || req.body.city_id == null) {
//             return res.status(403).json({ status: 'error', message: 'City id not found.' });
//         }
//         var city_id = req.body.city_id;
//         var sql = "SELECT id,pincode FROM pincodes where city_id='" + city_id + "'";
//         db.query(sql, function(err, pincode) {
//             return res.status(200).json({ status: 'success', message: 'success', data: pincode });
//         });
//     } catch (e) {
//         return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//     }
// }


/**
 * GET CITY NAME FROM PINCODE
 */
exports.city_from_pincode = function(req, res, next) {
    try {
        if (req.body.pincode == '' || req.body.pincode == 'undefined' || req.body.pincode == null) {
            return res.status(403).json({ status: 'error', message: 'Pincode not found.' });
        }
        var pincode = req.body.pincode;
        var sql = "SELECT id,city,state_id,(SELECT state FROM states WHERE id=cities.state_id) AS state_name \n\
        FROM cities WHERE id IN(SELECT city_id FROM pincodes WHERE pincode='" + pincode + "' GROUP BY city_id)";
        db.query(sql, function(err, result) {
            var data = {};
            var message = 'Pincode not found';
            if (result.length > 0) {
                message = 'success';
                data = result[0];
            }
            return res.status(200).json({ status: 'success', message: message, data: data });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}


/**
 * STATIC DROP DONW AND JOB DETAI TO EDIT THE JOB
 */
exports.detail_job = function(req, res, next) {
    try {
        if (req.body.job_id == '' || req.body.job_id == 'undefined' || req.body.job_id == null) {
            return res.status(403).json({ status: 'error', message: 'Job id not found.' });
        }

        var verbose = {};
        verbose.contact_via = contact_via;
        var sql = "SELECT id,skill FROM skills";
        db.query(sql, function(err, skill_list) {
            verbose.skill_list = skill_list;
            var sql = "SELECT id,city FROM cities";
            db.query(sql, function(err, city_list) {
                verbose.city_list = city_list;

                var sql = "SELECT id,title,description,skills,contact_via,contact_value,city,pincode FROM jobs WHERE id='" + req.body.job_id + "'";
                db.query(sql, function(err, result) {
                    if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                    }
                    return res.status(200).json({
                        status: 'success',
                        message: 'success',
                        verbose: verbose,
                        data: result
                    });
                });
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE NEW JOB
 */
exports.add_job = async function(req, res, next) {
    try {
        if (req.body.title == '' || req.body.title == 'undefined' || req.body.title == null) {
            return res.status(403).json({ status: 'error', message: 'Job title not found.' });
        } else if (req.body.description == '' || req.body.description == 'undefined' || req.body.description == null) {
            return res.status(403).json({ status: 'error', message: 'Job description not found.' });
        } else if (req.body.skills == '' || req.body.skills == 'undefined' || req.body.skills == null) {
            return res.status(403).json({ status: 'error', message: 'Job skills not found.' });
        } else if (req.body.contact_via == '' || req.body.contact_via == 'undefined' || req.body.contact_via == null) {
            return res.status(403).json({ status: 'error', message: 'Contact via not found.' });
        } else if (req.body.contact_value == '' || req.body.contact_value == 'undefined' || req.body.contact_value == null) {
            return res.status(403).json({ status: 'error', message: 'Contact value not found.' });
        } else if (req.body.postal_code == '' || req.body.postal_code == 'undefined' || req.body.postal_code == null) {
            return res.status(403).json({ status: 'error', message: 'Pincode not found.' });
        }

        var business_id = req.userdata.business_id;
        var title = req.body.title;
        var description = req.body.description;
        var skills = req.body.skills;
        var contact_via = req.body.contact_via;
        var contact_value = req.body.contact_value;
        var pincode = req.body.postal_code;
        let city = await Citycode(pincode);
        if (city != '') {
            var postval = {
                business_id: business_id,
                title: title,
                description: description,
                skills: skills,
                contact_via: contact_via,
                contact_value: contact_value,
                city: city,
                pincode: pincode
            };

            var sql = "INSERT INTO jobs set ?";
            db.query(sql, postval, function(err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                }
                return res.status(200).json({ status: 'success', message: 'Job created successfully.' });
            });
        } else {
            return res.status(403).json({ status: 'error', message: 'City not found for this pincode' });
        }

    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * EDIT JOB
 */
exports.edit_job = async function(req, res, next) {
    try {
        if (req.body.job_id == '' || req.body.job_id == 'undefined' || req.body.job_id == null) {
            return res.status(403).json({ status: 'error', message: 'Job id not found.' });
        }

        var business_id = req.userdata.business_id;
        var job_id = req.body.job_id;
        var update_columns = " updated_at=now() ";
        if (req.body.title != '' && req.body.title != 'undefined' && req.body.title != null) {
            update_columns += ", title='" + req.body.title + "' ";
        }
        if (req.body.description != '' && req.body.description != 'undefined' && req.body.description != null) {
            update_columns += ", description='" + req.body.description + "' ";
        }
        if (req.body.skills != '' && req.body.skills != 'undefined' && req.body.skills != null) {
            update_columns += ", `skills`='" + req.body.skills + "' ";
        }
        if (req.body.contact_via != '' && req.body.contact_via != 'undefined' && req.body.contact_via != null) {
            update_columns += ", contact_via='" + req.body.contact_via + "' ";
        }
        if (req.body.contact_value != '' && req.body.contact_value != 'undefined' && req.body.contact_value != null) {
            update_columns += ", contact_value='" + req.body.contact_value + "' ";
        }
        if (req.body.postal_code != '' && req.body.postal_code != 'undefined' && req.body.postal_code != null) {
            update_columns += ", pincode='" + req.body.postal_code + "' ";
        }
        let city = await Citycode(req.body.postal_code);
        if (city != '') {
            update_columns += ", city='" + city + "' ";
        }

        var sql = "update jobs set " + update_columns + "  WHERE id='" + job_id + "' AND business_id='" + business_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({
                status: 'success',
                message: 'Job updated successfully.',
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', e });
    }
};

/*
 *Get city code from pincode
 **/
async function Citycode(pincode) {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT `city_id` FROM `pincodes` WHERE `pincode`='" + pincode + "' LIMIT 1";
        db.query(sql, function(err, result) {
            resolve(result[0].city_id);
        });
    });
}