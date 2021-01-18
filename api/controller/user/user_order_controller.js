var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var uniqid = require('uniqid');

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
                var sql_detail_order = `SELECT b_m_i.id as item_id , b_m_i.title as item,b_o_d.quantity FROM business_orders as b_o JOIN business_order_detail as b_o_d JOIN business_menu_item as b_m_i ON b_o.order_id = b_o_d.order_id AND b_m_i.id =b_o_d.item_id WHERE b_o_d.order_id = '${order.order_id}'`
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

/**
 * CREATE NEW ORDER
 */
exports.createOrder = async function(req, res, next) {
    try {
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
            order_type: req.body.order_type,
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