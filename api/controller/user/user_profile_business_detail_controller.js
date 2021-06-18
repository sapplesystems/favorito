const { reduceRight } = require('async');
var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.businessDetail = async function(req, res, next) {
    await exports.getBusinessDetail(req, res)
}

// Details of business by business id 
// exports.getBusinessDetail = async function(req, res) {
//     try {
//         if (req.body.business_id == null || req.body.business_id == undefined || req.body.business_id == '') {
//             return res.status(400).json({ status: 'error', message: 'business_id is missing' });
//         } else {
//             business_id = req.body.business_id
//         }
//         // var sql = "SELECT b_m.id, b_m.business_id, b_m.postal_code postal_code,b_m.business_phone as phone,b_m.landline as landline,b_m.business_email, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,(SELECT COUNT(business_id) FROM business_reviews WHERE business_id = '" + business_id + "') as total_reviews,b_h.start_hours, b_h.end_hours, 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m JOIN business_hours as b_h  JOIN business_ratings AS b_r JOIN business_reviews as b_rev ON b_m.business_id = b_r.business_id AND b_m.business_id = b_rev.business_id AND b_m.business_id = b_h.business_id WHERE b_m.is_activated='1' AND b_m.business_id = '" + business_id + "' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ";
//         var sql = "SELECT b_m.id, b_m.business_id, b_m.postal_code postal_code,b_m.business_phone as phone,b_m.landline as landline,b_m.business_email, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,IFNULL((SELECT COUNT(business_id) FROM business_reviews WHERE business_id = '" + business_id + "' AND parent_id = 0) ,0) as total_reviews,b_h.start_hours, b_h.end_hours, 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m JOIN business_hours as b_h  JOIN business_ratings AS b_r LEFT JOIN business_reviews as b_rev ON b_m.business_id = b_r.business_id AND b_m.business_id = b_rev.business_id AND b_m.business_id = b_h.business_id WHERE b_m.is_activated='1' AND b_m.business_id = '" + business_id + "' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ";
//         db.query(sql, function(err, result) {
//             if (err) {
//                 return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
//             }
//             return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
//         })
//     } catch (error) {
//         res.status(500).json({ status: 'error', message: 'Something went wrong.' })
//     }
// }

exports.getBusinessDetail = async function(req, res) {
    try {
        let isVisited = 0

        if (!req.body.business_id && !req.body.firebase_id) {
            return res.status(400).json({ status: 'error', message: 'business_id or firebase_id is missing' });
        } else {
            user_id = req.userdata.id
            if (req.body.business_id) {
                business_id = req.body.business_id
                sqlGetBusinessIdByFirebaseId = `select business_id,location from business_master where business_id = '${business_id}'`
                resultGetBusinessIdByFirebaseId = await exports.run_query(sqlGetBusinessIdByFirebaseId)
            } else {
                firebase_chat_id = req.body.firebase_id
                sqlGetBusinessIdByFirebaseId = `select business_id,location from business_master where firebase_chat_id = '${firebase_chat_id}'`
                try {
                    resultGetBusinessIdByFirebaseId = await exports.run_query(sqlGetBusinessIdByFirebaseId)
                    if (resultGetBusinessIdByFirebaseId != '') {
                        business_id = resultGetBusinessIdByFirebaseId[0].business_id
                    } else {
                        return res.status(400).json({ status: 'error', message: 'This firebase id do not exist' });
                    }
                } catch (error) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
                }
            }
        }
        try {

            sql_count_rating = "SELECT AVG(rating) as count FROM business_ratings WHERE business_id = '" + business_id + "'"
            result_count_rating = await exports.run_query(sql_count_rating)
            sql_attributes = `SELECT b_a_m.attribute_name as attribute_name FROM business_attributes as b_a LEFT JOIN business_attributes_master as b_a_m ON b_a_m.id = b_a.attributes_id WHERE b_a.business_id= '${business_id}'`
            result_attributes = await exports.run_query(sql_attributes)

            // getting the booking setting

            sqlGetBookingSetting = `select id from business_booking_setting where business_id = '${business_id}'`
            resultGetBookingSetting = await exports.run_query(sqlGetBookingSetting)

            // getting the menu setting 
            sqlGetMenuSetting = `select id from business_menu_setting where business_id = '${business_id}'`
            resultGetMenuSetting = await exports.run_query(sqlGetMenuSetting)

            // getting the menu setting 
            sqlGetWaitlistSetting = `select id from business_waitlist_setting where business_id = '${business_id}'`
            resultGetWaitlistSetting = await exports.run_query(sqlGetWaitlistSetting)

            // getting the menu setting 
            sqlGetAppointmentSetting = `select id from business_appointment_setting where business_id = '${business_id}'`
            resultGetAppointmentSetting = await exports.run_query(sqlGetAppointmentSetting)
                // return res.send(resultGetMenuSetting)

            // checking if this user is involved in any of the activity of this business like waitlist booking order or appointment.

            // booking

            sqlIsBooking = `select id from business_booking where user_id = '${user_id}' and business_id = '${business_id}'`
            resultIsBooking = await exports.run_query(sqlIsBooking)

            // waitlist
            sqlIsWaitlist = `select id from business_waitlist where user_id = '${user_id}'  and business_id = '${business_id}'`
            resultIsWaitlist = await exports.run_query(sqlIsWaitlist)

            //appointment  
            sqlIsAppointment = `select id from business_appointment where user_id = '${user_id}' and business_id = '${business_id}'`
            resultIsAppointment = await exports.run_query(sqlIsAppointment)

            // order 
            sqlIsOrder = `select id from business_orders where user_id = '${user_id}' and business_id = '${business_id}'`
            resultIsOrder = await exports.run_query(sqlIsOrder)

            // also checking if the user is in the radius of 500m to the business 

            if (!resultGetBusinessIdByFirebaseId[0].location) {
                return res.status(500).json({ status: 'error', message: 'Business location is not set.' })
            }
            locationBusiness = resultGetBusinessIdByFirebaseId[0].location.split(',')

            sqlUserLocation = `select latitude, longitude from user_address where  default_address = 1 and user_id  = "${user_id}"`
            resultUserLocation = await exports.run_query(sqlUserLocation)
                // var distance = await getDistanceFromLatLonInKm(resultUserLocation[0].latitude, resultUserLocation[0].longitude, locationBusiness[0], locationBusiness[1])

            if (!resultUserLocation[0]) {
                return res.status(403).json({ status: 'error', message: 'User location is not set.' })
            }

            if (resultUserLocation[0]) {
                var distance = await getDistanceFromLatLonInKm(resultUserLocation[0].latitude, resultUserLocation[0].longitude, locationBusiness[0], locationBusiness[1])
            } else {
                distance = null
            }

            if (resultIsBooking == '' && resultIsWaitlist == '' && resultIsAppointment == '' && resultIsOrder == '') {
                isVisited = 0
            } else {
                isVisited = 1
            }
            if (distance < 500) {
                isVisited = 1
            }

            // removing the attribute if settings are not saved
            for (let i = 0; i < result_attributes.length; i++) {
                const element = result_attributes[i];
                if (element.attribute_name == 'Booking' && resultGetBookingSetting == '') {
                    result_attributes.splice(i, 1)
                }

                if (element.attribute_name == 'Online Menu' && resultGetMenuSetting == '') {
                    result_attributes.splice(i, 1)
                }

                if (element.attribute_name == 'Take away' && resultGetMenuSetting == '') {
                    result_attributes.splice(i, 1)
                }

                if (element.attribute_name == 'Waitlist' && resultGetWaitlistSetting == '') {
                    result_attributes.splice(i, 1)
                }

                if (element.attribute_name == 'Appointment' && resultGetAppointmentSetting == '') {
                    result_attributes.splice(i, 1)
                }
            }

            sql_relation = `SELECT r_c.relationship_description as relation FROM user_business_relation AS u_b_r LEFT JOIN relationship_code AS r_c ON u_b_r.relation_type = r_c.relationship_code WHERE source_id = '${user_id}' AND target_id = '${business_id}'`

            result_relation = await exports.run_query(sql_relation)
            if (result_count_rating[0].count == null) {
                avg_rating = 0
            } else {
                avg_rating = result_count_rating[0].count
            }
        } catch (error) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
        }
        var sql = "SELECT b_m.id, b_m.business_id,b_m.firebase_chat_id ,IFNULL(b_m.short_description,'') as short_desciption,IFNULL(b_i.price_range ,0) AS price_range, b_m.postal_code postal_code,b_m.business_phone as phone,b_m.landline as landline,b_m.business_email,IFNULL((SELECT COUNT(business_id) FROM business_reviews WHERE business_id = '" + business_id + "' AND parent_id = 0) ,0) as total_reviews,b_h.start_hours, b_h.end_hours, 2 as distance,business_category_id, b_m.business_name, b_m.town_city, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m JOIN business_informations AS b_i LEFT JOIN business_hours as b_h ON  b_m.business_id = b_h.business_id WHERE b_m.is_activated='1' AND b_m.business_id = '" + business_id + "' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ";

        result = await exports.run_query(sql)
        if (result == '') {
            return res.status(200).send({ status: 'success', message: 'No content found', data: result })
        }

        // checking the online or offline

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

        sql_hour = `select day,start_hours,end_hours from business_hours where business_id = '${business_id}' AND day = '${day}'AND start_hours < NOW() AND end_hours > NOW()`
        result_hour = await exports.run_query(sql_hour)
        if (result[0].business_status == 'online' || result[0].business_status == 'Online') {
            if (result_hour == '') {
                result[0].start_hours = null
                result[0].end_hours = null
                result[0].business_status = 'offline'
            } else {
                result[0].start_hours = result_hour[0].start_hours
                result[0].end_hours = result_hour[0].end_hours
                result[0].business_status = 'online'

            }
        }
        result[0].avg_rating = avg_rating;
        result[0].attributes = result_attributes;
        result[0].relation = result_relation;
        result[0].is_visited = isVisited;

        return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })

    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

function getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    return new Promise((resolve, reject) => {
        var R = 6371;
        var dLat = deg2rad(lat2 - lat1);
        var dLon = deg2rad(lon2 - lon1);
        var a =
            Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) * Math.sin(dLon / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        var d = (R * c) * 1000; // converting it in m.

        resolve(d);
    })
}

function deg2rad(deg) {
    return deg * (Math.PI / 180)
}

// Detail of the overview of the business
exports.getBusinessOverview = async function(req, res) {
    try {
        if (req.body.business_id == null || req.body.business_id == undefined || req.body.business_id == '') {
            return res.status(400).json({ status: 'error', message: 'business_id is missing' });
        } else {
            business_id = req.body.business_id
        }
        // var sql = "SELECT id,business_id,business_name,postal_code,business_phone,landline,reach_whatsapp, \n\
        // business_email,concat('" + img_path + "',photo) as photo, address1,address2,address3,pincode,town_city,state_id,country_id, \n\
        // location, by_appointment_only, working_hours, website,short_description,business_status \n\
        // FROM business_master WHERE business_id='" + business_id + "' and is_activated=1 and deleted_at is null";


        var sql = "SELECT b_m.id, b_m.business_id, b_m.postal_code postal_code, IFNULL(b_m.location,'0,0') as location,b_m.business_phone as phone,b_m.landline as landline,b_m.business_email, IFNULL(AVG(b_r.rating) , 0) AS avg_rating ,b_m.website, 2 as distance,business_category_id, b_m.business_name, b_m.town_city, b_m.address1 as address1,b_m.address2 as address2,b_m.address3 as address3,b_m.short_description as short_description,b_i.payment_method as payment_method, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m JOIN business_informations as b_i LEFT JOIN business_ratings  AS b_r ON b_m.business_id = b_r.business_id AND  b_i.business_id = b_m.business_id WHERE b_m.is_activated='1' AND b_m.business_id = '" + business_id + "' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ";




        sql_business_hours = `SELECT start_hours, end_hours FROM business_hours WHERE business_id ='${business_id}' AND day = '${get_day_name()}'`

        result_business_hours = await exports.run_query(sql_business_hours)
            // return res.send(result_business_hours[0])

        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            if (result_business_hours.length > 0) {
                result[0].start_hours = result_business_hours[0].start_hours
                result[0].end_hours = result_business_hours[0].end_hours
            } else {
                result[0].start_hours = '00:00:00'
                result[0].end_hours = '23:59:59'
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

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

/**
 * LIST ALL CATALOG
 */
exports.getListCatalog = function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.body.business_id;
        var cond = '';
        if (req.body.catalog_id != '' && req.body.catalog_id != 'undefined' && req.body.catalog_id != null) {
            cond = " AND c.id='" + req.body.catalog_id + "' ";
        }

        var sql = "SELECT c.id,catalog_title,catalog_price,catalog_desc,product_url,product_id,GROUP_CONCAT(p.id) AS photos_id,GROUP_CONCAT('" + img_path + "',p.photos) AS photos \n\
                FROM business_catalogs AS c  \n\
                LEFT JOIN business_catalog_photos AS p ON  \n\
                c.id=p.business_catalog_id \n\
                WHERE c.business_id='" + business_id + "' " + cond + " AND c.deleted_at IS NULL AND p.deleted_at IS NULL \n\
                GROUP BY c.id";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.all_business_reviewlist = function(req, res, next) {
    try {
        var business_id = req.body.business_id;
        var sql = "SELECT id, reviews , rating , name , DATE_FORMAT(created_at, '%Y-%m-%d') as review_date, \n\
        DATE_FORMAT(created_at, '%H:%i') AS review_at FROM business_reviews WHERE business_id='" + business_id + "' AND deleted_at IS NULL ORDER BY id DESC";
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

exports.getAllHoursBusiness = async function(req, res, next) {
    if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
        business_id = req.body.business_id
    } else if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
        business_id = req.body.business_id
    } else {
        return res.status(400).json({ status: 'error', message: 'business_id is missing' });
    }

    try {
        var sql_get_hours = `SELECT business_id,day, start_hours,end_hours FROM business_hours WHERE business_id = '${business_id}'`
        var result_get_hours = await exports.run_query(sql_get_hours)
        return res.status(200).json({ status: 'success', message: 'success', data: result_get_hours });
    } catch (error) {
        return res.status(400).json({ status: 'error', message: 'Something went wrong', error });
    }
}

exports.getContactBusiness = async(req, res) => {
    if (!req.body.business_id && !req.body.firebase_id) {
        return res.status(400).json({ status: 'error', message: 'business_id or firebase_id is missing' });
    } else {
        if (req.body.business_id) {
            business_id = req.body.business_id
            sqlContactBusiness = `select business_phone, landline from business_master where business_id = '${business_id}'`
        } else {
            firebase_chat_id = req.body.firebase_id
            sqlContactBusiness = `select business_phone, landline from business_master where firebase_chat_id = '${firebase_chat_id}'`
        }
    }

    try {
        resultContactBusiness = await exports.run_query(sqlContactBusiness)
        if (resultContactBusiness == '') {
            return res.status(200).json({ status: 'success', message: 'No content found', data: resultContactBusiness });
        } else {
            return res.status(200).json({ status: 'success', message: 'success', data: resultContactBusiness });
        }
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
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