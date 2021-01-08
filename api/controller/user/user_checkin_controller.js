var db = require('../../config/db');
var moment = require('moment');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';


exports.userSetCheckin = async(req, res, next) => {
    data_to_insert = {}
    if (req.body.business_id) {
        business_id = req.body.business_id
    } else {
        return res.status(400).json({ status: 'failed', message: 'business_id is missing' });
    }

    if (req.userdata.id) {
        user_id = req.userdata.id
    }

    data_to_insert.user_id = user_id
    data_to_insert.business_id = business_id

    var sql_count_rating = "SELECT AVG(rating) as count FROM business_ratings WHERE business_id = '" + business_id + "'"

    var sql_detail = "SELECT b_m.id, b_m.business_id, b_m.postal_code postal_code, IFNULL(b_m.location,'0,0') as location,b_m.business_phone as phone,b_m.landline as landline,b_m.business_email, b_m.business_name, b_m.town_city, b_m.address1 as address1,b_m.address2 as address2,b_m.address3 as address3,b_m.short_description as short_description,b_i.payment_method as payment_method, CONCAT('" + img_path + "', photo) as photo, b_m.business_status FROM `business_master` AS b_m JOIN business_informations as b_i ON b_i.business_id = b_m.business_id WHERE b_m.is_activated='1' AND b_m.business_id = '" + business_id + "' AND b_m.deleted_at IS NULL GROUP BY b_m.business_id ";
    sql_insert_checkin = `INSERT INTO business_check_in SET ?`
    try {
        result_count_rating = await exports.run_query(sql_count_rating)
        result_detail = await exports.run_query(sql_detail)
        result_detail[0].avg_rating = result_count_rating[0].count
        result_insert_checkin = await exports.run_query(sql_insert_checkin, data_to_insert)
        return res.status(200).json({ status: 'success', message: 'Data is saved', data: result_detail });
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'Error occured in database', error });
    }
}

exports.userGetCheckin = async(req, res, next) => {
    let condition = ''
    if (req.body.user_id) {
        user_id = req.body.user_id
        condition = `user_id = '${user_id}'  `
    } else if (req.userdata.id) {
        user_id = req.userdata.id
        condition = `user_id = '${user_id}'  `
    }

    if (req.body.business_id) {
        business_id = req.body.business_id
        condition = `${condition} business_id = '${business_id}'  `
    } else if (req.body.business_id) {
        business_id = req.body.business_id
        condition = `${condition} business_id = '${business_id}'  `
    }

    if (req.body.checkin_id) {
        condition = `id = '${req.body.checkin_id}'`
    }

    condition = 'WHERE ' + condition.trim().replace('  ', ' AND ')
    sql_get_data = `SELECT id, user_id, business_id,created_at FROM business_check_in ${condition}`

    try {

        result_get_data = await exports.run_query(sql_get_data)

        return res.status(200).json({ status: 'success', message: 'success', data: result_get_data });
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'failed', error });
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