var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var menu_type_id = 1; // BY Default for business is 1 and for freelancer is 2
var async = require('async');
var moment = require('moment')


// Return data according to date and time
exports.getMenuCategories = async function(req, res, next) {
    try {
        if (!req.body.business_id) {
            return res.status(400).json({ status: 'error', message: 'business_id is missing.' });
        } else {
            business_id = req.body.business_id
        }
        var day_name = moment().format('dddd').substring(0, 3);
        current_time = moment().format('H:mm:ss')
        var COND = `business_id='${business_id}' AND menu_type_id='${menu_type_id}' AND is_activated='1' AND available_on LIKE '%${day_name}%' AND deleted_at IS NULL AND slot_start_time < '${current_time}' AND slot_end_time >'${current_time}'`

        var sql_menu_category = "SELECT id, category_name \n\
        FROM business_menu_category \n\
        WHERE " + COND
        result_menu_category = await exports.run_query(sql_menu_category)
        if (result_menu_category == '') {
            return res.status(200).send({ status: 'success', message: 'There is no category', data: result_menu_category })
        }
        return res.status(200).send({ status: 'success', message: 'success', data: result_menu_category })
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', e });
    }
};

// get items by category_menu_id
exports.getItemOfCategory = async(req, res) => {
    item_type = ''
    if (!req.body.business_id) {
        return res.status(400).json({ status: 'error', message: 'business_id is required.' });
    }
    if (!req.body.category_id) {
        return res.status(400).json({ status: 'error', message: 'category_id is required.' });
    }
    if (req.body.filter) {
        if (req.body.filter.only_veg == 1) {
            item_type = ` AND type = 'veg'`
        }
    }
    business_id = req.body.business_id
    category_id = req.body.category_id
    var sql = "SELECT id, title, price, description, `type`, \n\
                        (SELECT GROUP_CONCAT(id) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photo_id, \n\
                        (SELECT GROUP_CONCAT(CONCAT('" + img_path + "',photo)) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photos \n\
                        FROM business_menu_item \n\
                        WHERE business_id='" + business_id + "' AND menu_category_id='" + category_id + "' AND is_activated = 1  " + item_type;

    // var sql = "SELECT id, title, price, description, quantity, `type`, max_qty_per_order,business_menu_item.is_activated, \n\
    //                     (SELECT GROUP_CONCAT(id) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photo_id, \n\
    //                     (SELECT GROUP_CONCAT(CONCAT('" + img_path + "',photo)) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photos \n\
    //                     FROM business_menu_item \n\
    //                     WHERE business_id='" + business_id + "' AND menu_category_id='" + category_id + "'";

    db.query(sql, async function(error, items) {
        if (error) {
            return res.status(400).json({ status: 'error', message: 'Something went wrong.' });
        }
        var items_length = items.length;
        for (var i = 0; i < items_length; i++) {
            if (items[i].photo_id != null && items[i].photos != null) {
                // items[i].photo_id = (items[i].photo_id).split(',');
                items[i].photos = (items[i].photos).split(',');
            }
        }
        if (items == '') {
            return res.status(200).json({ status: 'success', message: 'There is no item available in this category.', data: items });
        }
        return res.status(200).json({ status: 'success', message: 'success.', data: items });
    });
}

// search item by name
exports.searchItemCategory = async(req, res) => {
    item_type = ''
    category_where_clause = ''
    if (!req.body.business_id) {
        return res.status(400).json({ status: 'error', message: 'business_id is required.' });
    }
    if (req.body.category_id) {
        category_where_clause = ` AND menu_category_id= '${req.body.category_id}'`
    }
    if (req.body.filter) {
        if (req.body.filter.only_veg == 1) {
            item_type = ` AND type = 'veg'`
        }
    }
    if (req.body.keyword) {
        keyword_like = ''
        keywords = req.body.keyword.trim().split(' ')
        for (let i = 0; i < keywords.length; i++) {
            if (i == 0) {
                keyword_like = `${keyword_like}  title LIKE '%${keywords[i]}%'`;
            } else {
                keyword_like = `${keyword_like} OR title LIKE '%${keywords[i]}%'`;
            }
        }
        // return res.send(keyword_like)
    } else {
        return res.status(400).json({ status: 'error', message: 'Search keyword is missing.' });
    }
    business_id = req.body.business_id
    var sql = "SELECT id, business_id, title, price, description, `type`, \n\
                        (SELECT GROUP_CONCAT(id) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photo_id, \n\
                        (SELECT GROUP_CONCAT(CONCAT('" + img_path + "',photo)) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photos \n\
                        FROM business_menu_item \n\
                        WHERE business_id='" + business_id + "' " + category_where_clause + " AND is_activated = 1  " + item_type + " AND (" + keyword_like + ") ";
    // var sql = "SELECT id, business_id, title, price, description, `type`, \n\
    //                     (SELECT GROUP_CONCAT(id) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photo_id, \n\
    //                     (SELECT GROUP_CONCAT(CONCAT('" + img_path + "',photo)) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photos \n\
    //                     FROM business_menu_item \n\
    //                     WHERE business_id='" + business_id + "' AND menu_category_id='" + category_id + "' AND is_activated = 1  " + item_type + " AND (" + keyword_like + ") ";


    db.query(sql, async function(error, items) {
        if (error) {
            return res.status(400).json({ status: 'error', message: 'Something went wrong.', error });
        }
        var items_length = items.length;
        for (var i = 0; i < items_length; i++) {
            if (items[i].photo_id != null && items[i].photos != null) {
                // items[i].photo_id = (items[i].photo_id).split(',');
                items[i].photos = (items[i].photos).split(',');
            }
        }
        if (items == '') {
            return res.status(200).json({ status: 'success', message: 'There is no item available in this category.', data: items });
        }
        return res.status(200).json({ status: 'success', message: 'success.', data: items });
    });
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