var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var uniqid = require('uniqid');
var moment = require('moment')
const DELIVERY = 1
const DINE_IN = 2
const TAKE_AWAY = 3

exports.getOrderList = async function(req, res, next) {
    if (req.body.user_id != null || req.body.user_id != undefined || req.body.user_id != '') {
        user_id = req.body.user_id
    } else if (req.userdata.id) {
        user_id = req.userdata.id
    } else {
        return res.status(400).json({ status: 'error', message: 'User id is not found' });
    }
    try {
        var sql = "SELECT b_o.business_id,b_m.business_name as business_name,CONCAT('" + img_path + "',b_m.photo) as business_photo,b_m.address1 as address,b_m.town_city as city, b_o.order_id,name, b_o.mobile, b_o.notes, b_o.order_type, b_o.order_status,b_o.total_amount,b_o.payment_type, b_o.created_at FROM business_orders AS b_o JOIN business_order_detail AS b_o_d JOIN business_master as b_m ON b_o.order_id = b_o_d.order_id AND b_o.business_id = b_m.business_id  WHERE b_o.user_id = '" + user_id + "' GROUP BY b_o.order_id"
        result_sql = await exports.run_query(sql)
        final_data = []
        for (let i = 0; i < result_sql.length; i++) {
            // let temp = {}
            const order = result_sql[i];
            // temp.order = order
            try {
                var sql_detail_order = `SELECT b_m_i.id as item_id , b_m_i.title as item,b_o_d.quantity as qty FROM business_orders as b_o JOIN business_order_detail as b_o_d JOIN business_menu_item as b_m_i ON b_o.order_id = b_o_d.order_id AND b_m_i.id =b_o_d.item_id WHERE b_o_d.order_id = '${order.order_id}'`
                result_detail_order = await exports.run_query(sql_detail_order)
                order.order_detail = result_detail_order
            } catch (error) {
                return res.send(error)
            }

        }
        return res.status(200).send({ status: 'success', message: 'Successfull', data: result_sql })
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

exports.getOrderDetail = async function(req, res, next) {
    if (req.body.order_id) {
        order_id = req.body.order_id
    } else {
        return res.status(400).json({ status: 'failed', message: 'order_id is missing' });
    }
    var sql_order = "SELECT b_o.business_id,b_m.business_name as business_name,CONCAT('" + img_path + "',b_m.photo) as business_photo,b_m.address1 as address,b_m.town_city as city, b_o.order_id,name, b_o.mobile, b_o.notes, b_o.order_type, b_o.order_status,b_o.total_amount,b_o.payment_type, b_o.created_at FROM business_orders AS b_o JOIN business_order_detail AS b_o_d JOIN business_master as b_m ON b_o.order_id = b_o_d.order_id AND b_o.business_id = b_m.business_id  WHERE b_o.order_id = '" + order_id + "' GROUP BY b_o.order_id"
    var sql_order_detail = `SELECT b_m_i.id as item_id , b_m_i.title as item,b_o_d.quantity,b_m_i.price as per_price,b_m_i.type as type FROM business_orders as b_o JOIN business_order_detail as b_o_d JOIN business_menu_item as b_m_i ON b_o.order_id = b_o_d.order_id AND b_m_i.id =b_o_d.item_id WHERE b_o_d.order_id = '${order_id}'`

    try {
        result_order = await exports.run_query(sql_order)
        result_order[0].delivery_charge = result_order[0].total_amount * 5 / 100
        result_order_detail = await exports.run_query(sql_order_detail)
        for (let i = 0; i < result_order_detail.length; i++) {
            const element = result_order_detail[i];
            element.total_price = element.per_price * element.quantity
        }
        return res.status(200).send({ status: 'success', message: 'Successfull', data: [{ order: result_order[0], order_detail: result_order_detail }] })
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
    }

}

// Validation order 
orderValidation = (req, res) => {
    return new Promise(async(resolve, reject) => {
        if (!req.body.business_id) {
            return res.status(403).json({ status: 'error', message: 'business_id is missing' });
        } else {
            business_id = req.body.business_id
        }
        if (!req.body.order_type) {
            return res.status(403).json({ status: 'error', message: 'order_type is missing' });
        } else {
            order_type = req.body.order_type
        }

        sql_get_setting = `SELECT * from business_menu_setting where business_id = '${business_id}'`
        result_get_setting = await exports.run_query(sql_get_setting)

        // resolve({ order_type, DELIVERY })
        switch (parseInt(order_type)) {
            case DELIVERY:
                console.log('delivery')
                delivery = result_get_setting[0].delivery
                if (delivery == 0) {
                    resolve(false)
                }
                delivery_start_time = moment(result_get_setting[0].delivery_start_time, 'H:mm:ss')
                delivery_end_time = moment(result_get_setting[0].delivery_end_time, 'H:mm:ss')
                current_time = moment(moment(), 'H:mm:ss')
                if (delivery_start_time.isBefore(current_time) && current_time.isBefore(delivery_end_time)) {
                    resolve(true)
                } else {
                    resolve(false)
                }
                break;
            case DINE_IN:
                console.log('DINE_IN')

                dine_in = result_get_setting[0].dine_in
                if (dine_in == 0) {
                    resolve(false)
                }
                dine_in_start_time = moment(result_get_setting[0].dine_in_start_time, 'H:mm:ss')
                dine_in_end_time = moment(result_get_setting[0].dine_in_end_time, 'H:mm:ss')
                current_time = moment(moment(), 'H:mm:ss')
                if (dine_in_start_time.isBefore(current_time) && current_time.isBefore(dine_in_end_time)) {
                    resolve(true)
                } else {
                    resolve(false)
                }
                break;
            case TAKE_AWAY:
                console.log('TAKE_AWAY')
                take_away = result_get_setting[0].take_away
                if (take_away == 0) {
                    resolve(false)
                }
                take_away_start_time = moment(result_get_setting[0].take_away_start_time, 'H:mm:ss')
                take_away_end_time = moment(result_get_setting[0].take_away_end_time, 'H:mm:ss')
                current_time = moment(moment(), 'H:mm:ss')
                if (take_away_start_time.isBefore(current_time) && current_time.isBefore(take_away_end_time)) {
                    resolve(true)
                } else {
                    resolve(false)
                }
                break;

            default:
                resolve('invalid_order')
                break;
        }
    })

}

/**
 * CREATE NEW ORDER
 */
exports.createOrder = async function(req, res, next) {
    try {
        is_order_valid = await orderValidation(req, res)
        if (is_order_valid == 'invalid_order') {
            return res.status(403).json({ status: 'error', message: 'Invalid order_type' });
        }
        if (!is_order_valid) {
            return res.status(200).json({ status: 'success', message: 'Not accepting the order at this time' });
        }
        var user_id = req.userdata.id;
        var category;
        var item;
        if (req.body.notes == '' || req.body.notes == 'undefined' || req.body.notes == null) {
            return res.status(403).json({ status: 'error', message: 'Notes not found.' });
        } else if (req.body.order_type == '' || req.body.order_type == 'undefined' || req.body.order_type == null) {
            return res.status(403).json({ status: 'error', message: 'Order type not found.' });
        } else if (req.body.category == '' || req.body.category == 'undefined' || req.body.category == null) {
            return res.status(403).json({ status: 'error', message: 'No category selected.' });
        } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business id is missing' });
        } else {
            category = req.body.category;
            if (category[0].category_item == '' || category[0].category_item == '' || category[0].category_item == null) {
                return res.status(403).json({ status: 'error', message: 'No item selected.' });
            }
        }
        if (req.userdata) {
            sql_user_detail = `SELECT full_name,phone FROM users WHERE id = '${req.userdata.id}'`
            result_user_detail = await exports.run_query(sql_user_detail)
            user_name = result_user_detail[0].full_name
            user_mobile = result_user_detail[0].phone
        }

        var order_id = uniqid();
        order_id = order_id.toUpperCase();

        var category_length = category.length;
        var total_price = 0;
        var total_tax = 0;
        var total_amount = 0;

        // for (var i = 0; i < category_length; i++) {
        //     var category_id = category[i].category_id;
        //     var category_items = category[i].category_item;
        //     var category_item_length = category_items.length;
        //     for (var j = 0; j < category_item_length; j++) {
        //         var item_id = category_items[j].item_id;
        //         var qty = Number(category_items[j].qty);
        //         var price = Number(category_items[j].price);
        //         var tax = Number(category_items[j].tax) * qty;
        //         var amount = (price * qty) + tax;

        //         total_price = (total_price + price);
        //         total_tax = (total_tax + tax);
        //         total_amount = (total_amount + amount);

        //         var order_detail = {
        //             business_id: req.body.business_id,
        //             order_id: order_id,
        //             category_id: category_id,
        //             item_id: item_id,
        //             quantity: qty,
        //             price: price,
        //             tax: tax,
        //             amount: amount,
        //             user_id: user_id
        //         };

        //         var sql = "INSERT INTO business_order_detail set ?";
        //         db.query(sql, order_detail)
        //     }
        // }

        // getting order type name from the table order_type_master

        sql_order_type = `select order_type from order_type_master where id = '${req.body.order_type}'`
        result_order_type = (await exports.run_query(sql_order_type))[0].order_type

        // making data for the order creation
        for (var i = 0; i < category_length; i++) {
            var category_id = category[i].category_id;
            var category_items = category[i].category_item;
            var category_item_length = category_items.length;
            for (var j = 0; j < category_item_length; j++) {
                var item_id = category_items[j].item_id;
                var qty = Number(category_items[j].qty);
                var price = Number(category_items[j].price);
                // var tax_percent = Number(category_items[j].tax)
                var tax = Number(category_items[j].tax) * qty;
                var amount = (price * qty) + tax;

                total_price = (total_price + price);
                total_tax = (total_tax + tax);
                total_amount = (total_amount + amount);

                var order_detail = {
                    business_id: req.body.business_id,
                    order_id: order_id,
                    category_id: category_id,
                    item_id: item_id,
                    quantity: qty,
                    price: price,
                    tax: tax,
                    amount: amount,
                    user_id: user_id
                };

                var sql = "INSERT INTO business_order_detail set ?";
                db.query(sql, order_detail)
            }
        }

        var order = {
            business_id: req.body.business_id,
            order_id: order_id,
            name: user_name,
            mobile: user_mobile,
            notes: req.body.notes,
            order_type: result_order_type,
            total_amount: total_amount,
            payment_type: req.body.payment_type,
            user_id: user_id
        };


        var sql = "INSERT INTO business_orders set ?";

        db.query(sql, order, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Order created successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/* 
Create order verbose
 */

exports.createOrderVerbose = async(req, res, next) => {
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

    sql_payment = `SELECT payment_method from business_informations where business_id = '${business_id}'`
    result_peyment = await exports.run_query(sql_payment)
    payment_methods = result_peyment[0].payment_method.split(',')
    console.log(payment_methods)
    return res.status(200).json({ status: 'success', message: 'success', data: { order_type: final_data, payment_type: payment_methods } });
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