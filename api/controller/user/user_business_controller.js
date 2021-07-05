var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var async = require('async');
const NodeGeocoder = require('node-geocoder');
const options = {
    provider: 'google',
    apiKey: process.env.GOOGLE_MAP_API, // for Mapquest, OpenCage, Google Premier
};
const geocoder = NodeGeocoder(options);

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

exports.searchByName = async function(req, res, next) {
    try {
        var result_master=[];
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
        if (req.body.keyword == null || req.body.keyword == undefined || req.body.keyword == '') {
            var sql = `SELECT b_m.id, b_m.business_id, b_m.business_phone as phone, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,b_h.start_hours, b_h.end_hours,  \n\
            SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
               POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
               ,business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m \n\
            LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id\n\
            LEFT JOIN business_hours as b_h ON b_m.business_id = b_h.business_id\n\
            WHERE b_m.is_activated='1' and b_m.is_verified = 1\n\
            AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ORDER BY distance is null,distance LIMIT ${limit} OFFSET ${offset}`;
            result_master = await exports.run_query(sql)

        } else {
            
            let keypro=req.body.keyword.trim();
            keyword = req.body.keyword.trim()
                // global replacement    
            keyword = `%${keyword.replace(/ /g, '%-%')}%`
            var tag_name=keyword;
            var tagid = await exports.getTagid(tag_name);
            if(tagid!=''){
                var camp_businessids=await exports.getBusinessCampignid(tagid);
                if(camp_businessids!='' && camp_businessids!=null && camp_businessids!=undefined){
                    var businessid= "'"+camp_businessids.split(",").join("','")+"'"; 
                    if(businessid!="" && businessid!=undefined){
                        let sql1 = `SELECT b_m.id, b_m.business_id, b_m.business_phone as phone,1 AS is_pro,'${tagid}' AS pro_key, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , \n\
                        SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
                           POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
                           , business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m \n\
                        LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id \n\
                        WHERE b_m.business_id IN(${businessid}) AND b_m.is_activated='1' and b_m.is_verified = 1 AND  b_m.deleted_at IS NULL GROUP BY b_m.business_id ORDER BY distance is null,distance LIMIT ${limit} OFFSET ${offset}`;
                        let result1 = await exports.run_query(sql1);
                        if(result1!=''){
                            result_master.push(...result1);
                        }
                    }
                }
            }
            
            keyword = ` b_m.business_name LIKE ${keyword.replace(/-/g," OR b_m.business_name LIKE ")}`
            keyword = keyword.replace(/ %/g, " '%")
            keyword = keyword.replace(/% /g, "%' ") 
            keyword=  `${keyword}' ` 
            let sql2 = `SELECT b_m.id, b_m.business_id, b_m.business_phone as phone,0 AS is_pro,'' AS pro_key, IFNULL(AVG(b_r.rating) , 0) AS avg_rating , \n\
            SQRT(POW(69.1 * (trim(substring_index(location,',',1)) - ${latitude}), 2) +\n\
               POW(69.1 * (${longitude} - trim(substring_index(location,',',-1))) * COS(trim(substring_index(location,',',1)) / 57.3), 2)) AS distance\n\
               , business_category_id, b_m.business_name, b_m.town_city, CONCAT('${img_path}', photo) as photo, b_m.business_status FROM business_master AS b_m \n\
            LEFT JOIN business_ratings AS b_r ON b_m.business_id = b_r.business_id \n\
            WHERE ${keyword} AND b_m.is_activated='1' and b_m.is_verified = 1 AND  b_m.deleted_at IS NULL GROUP BY b_m.business_id ORDER BY distance is null,distance LIMIT ${limit} OFFSET ${offset}`;
            let result2 = await exports.run_query(sql2);
            if(result2!=''){
                result_master.push(...result2);
            }
        }
        final_data = []
        async.eachSeries(result_master, function(data, callback) {
            db.query(`Select id, category_name FROM business_categories WHERE parent_id = ${data.business_category_id} LIMIT 5`, function(error, results1, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.sub_category = results1
            });

            db.query(`select day,start_hours,end_hours from business_hours where business_id = '${data.business_id}' AND day = '${day}'AND start_hours < NOW() AND end_hours > NOW()`, function(error, result_hour, filelds) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                if (data.business_status == 'online' || data.business_status == 'Online') {
                    if (result_hour == '') {
                        data.start_hours = null
                        data.end_hours = null
                        data.business_status = 'offline'
                    } else {
                        data.start_hours = result_hour[0].start_hours
                        data.end_hours = result_hour[0].end_hours
                        data.business_status = 'online'

                    }
                } else {
                    data.start_hours = null
                    data.end_hours = null
                }
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
                return res.status(500).send({ status: 'error', message: 'Something went wrong.'+e });
            }

            // adding the attribute to the business

            // sql = "SELECT b_a_m.attribute_name as attribute_name FROM business_attributes as b_a LEFT JOIN business_attribute "
            if (final_data == '') {
                return res.status(200).send({ status: 'success', message: 'Could not find such business', data: [] });
            }
            return res.status(200).send({ status: 'success', message: 'success', data: final_data });
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
};

/**added by shashank garg on 23-6-2021*
 * method func:- Get tag or keyword id by tag name
*/
exports.getTagid =async function(tag_name) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "SELECT id FROM business_tags_master WHERE `tag_name` LIKE '"+tag_name+"' AND deleted_at IS NULL";
            db.query(sql, function(err, result) {
                if(result!=''){
                    resolve(result[0].id);
                }else{
                    resolve(result); 
                }
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


exports.getBusinessCampignid =async function(tagid) {
    try {
        return new Promise(function(resolve, reject) {
            var sql = "SELECT GROUP_CONCAT(DISTINCT (badsc.`business_id`))AS bids FROM `business_ad_spent_campaign`AS badsc WHERE FIND_IN_SET("+tagid+",badsc.`keyword`) AND badsc.status='Active'";
            db.query(sql, function(err, result) {
                if(result!=''){
                    resolve(result[0].bids);
                }else{
                    resolve(result); 
                }

            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
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