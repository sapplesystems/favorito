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
        var COND = `b_m_c.business_id='${business_id}' AND b_m_c.menu_type_id='${menu_type_id}' AND b_m_c.is_activated='1' AND b_m_c.available_on LIKE '%${day_name}%' AND b_m_c.deleted_at IS NULL AND b_m_c.slot_start_time < '${current_time}' AND b_m_c.slot_end_time >'${current_time}'`

        var sql_menu_category = "SELECT b_m_c.id, b_c.category_name,b_m_c.out_of_stock \n\
        FROM business_menu_category as b_m_c\n\
        LEFT JOIN business_menu_category_master as b_c ON b_c.id = b_m_c.category_id\n\
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
// if category_menu_id is 0 then it return all the category
exports.getItemOfCategory = async(req, res) => {
    if (req.body.keyword) {
        item_type = ''
        category_where_clause = ''
        if (!req.body.business_id) {
            return res.status(400).json({ status: 'error', message: 'business_id is required.' });
        }
        if (req.body.category_id && req.body.category_id != 0) {
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

    } else {
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
        if (category_id == 0) {
            var sql = "SELECT id,menu_category_id, title, price, description, `type`, \n\
                                (SELECT GROUP_CONCAT(id) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photo_id, \n\
                                (SELECT GROUP_CONCAT(CONCAT('" + img_path + "',photo)) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photos \n\
                                FROM business_menu_item \n\
                                WHERE business_id='" + business_id + "' AND  is_activated = 1  " + item_type;
            result_1 = await exports.run_query(sql)

            for (let i = 0; i < result_1.length; i++) {
                const element = result_1[i];
                sql_tax = `SELECT tax FROM business_menu_category WHERE id = '${element.menu_category_id}'`
                result_tax = await exports.run_query(sql_tax)
                result_1[i].tax = result_tax[0].tax
            }

            if (result_1 == '') {
                return res.status(200).json({ status: 'success', message: 'There is no item available in this category.', data: result_1 });
            }
            return res.status(200).json({ status: 'success', message: 'success.', data: result_1 });

        } else {
            var sql = "SELECT id, title, price, description, `type`, \n\
                                (SELECT GROUP_CONCAT(id) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photo_id, \n\
                                (SELECT GROUP_CONCAT(CONCAT('" + img_path + "',photo)) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photos \n\
                                FROM business_menu_item \n\
                                WHERE business_id='" + business_id + "' AND menu_category_id='" + category_id + "' AND is_activated = 1  " + item_type;
            var sql_category_tax = `SELECT tax FROM business_menu_category WHERE id = '${category_id}'`
            var result_category_tax = await exports.run_query(sql_category_tax)
            db.query(sql, async function(error, items) {
                if (error) {
                    return res.status(400).json({ status: 'error', message: 'Something went wrong.' });
                }
                var items_length = items.length;
                for (var i = 0; i < items_length; i++) {
                    if (result_category_tax && result_category_tax[0].tax) {
                        items[i].tax = result_category_tax[0].tax
                    }
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


        // var sql = "SELECT id, title, price, description, quantity, `type`, max_qty_per_order,business_menu_item.is_activated, \n\
        //                     (SELECT GROUP_CONCAT(id) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photo_id, \n\
        //                     (SELECT GROUP_CONCAT(CONCAT('" + img_path + "',photo)) FROM business_menu_photo WHERE business_menu_item_id=business_menu_item.id) AS photos \n\
        //                     FROM business_menu_item \n\
        //                     WHERE business_id='" + business_id + "' AND menu_category_id='" + category_id + "'";

    }
}

// search item by name
exports.searchItemCategory = async(req, res) => {
    item_type = ''
    category_where_clause = ''
    if (!req.body.business_id) {
        return res.status(400).json({ status: 'error', message: 'business_id is required.' });
    }
    if (req.body.category_id && req.body.category_id != 0) {
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

// return the menu setting return attribute only if it come under current time
exports.businessMenuSetting = async(req, res) => {
    if (!req.body.business_id) {
        return res.status(400).json({ status: 'error', message: 'business_id is missing' });
    } else {
        business_id = req.body.business_id
    }

    sql_setting = `SELECT id,business_id, accepting_order ,take_away as take_away_c,delivery as delivery_c, dine_in as dine_in_c,\n\
    IF(take_away_start_time < NOW() AND  take_away_end_time > NOW(), '1','0') AS take_away, \n\
    take_away_minimum_bill, take_away_packaging_charge,\n\
    IF(dine_in_start_time < NOW() AND dine_in_end_time > NOW(), '1','0') AS dine_in,\n\
    IF(delivery_start_time < NOW() AND delivery_end_time > NOW(), '1','0') AS delivery,\n\
    delivery_minium_bill, delivery_packaging_charge \n\
    FROM business_menu_setting\n\
    WHERE business_id = '${business_id}'`

    try {
        result_setting = await exports.run_query(sql_setting)
            // return res.send(result_setting)
        final_data = []

        if (result_setting[0].accepting_order == 0) {
            final_data.push({ accepting_order: 0 })
        } else {
            final_data.push({ accepting_order: 1 })
        }

        if (result_setting[0].take_away == 1 && result_setting[0].take_away_c == 1) {
            final_data.push({ attribute: "take_away", minimum_bill: result_setting[0].take_away_minimum_bill, packaging_charge: result_setting[0].take_away_packaging_charge })
        }

        if (result_setting[0].delivery == 1 && result_setting[0].delivery_c == 1) {
            final_data.push({ attribute: "delivery", minimum_bill: result_setting[0].delivery_minium_bill, packaging_charge: result_setting[0].delivery_packaging_charge })
        }

        if (result_setting[0].dine_in == 1 && result_setting[0].dine_in_c == 1) {
            final_data.push({ attribute: "dine_in" })
        }
        return res.status(200).json({ status: 'success', message: 'success', data: final_data });
    } catch (error) {
        return res.status(400).json({ status: 'error', message: 'Something went wrong', error });
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