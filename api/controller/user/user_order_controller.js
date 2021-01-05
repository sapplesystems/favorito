var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var uniqid = require('uniqid');


exports.getOrderList = function(req, res, next) {
    if (req.body.user_id == null || req.body.user_id == undefined || req.body.user_id == '') {
        return res.status(400).json({ status: 'error', message: 'User id is not found' });
    }
    try {
        var sql = "SELECT * FROM business_orders AS a  JOIN business_order_detail AS b ON a.order_id = b.order_id  WHERE a.user_id = '" + req.body.user_id + "' GROUP BY b.item_id"
        db.query(sql, function(error, result) {
            if (error) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'Successfull', data: result })
        })
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

exports.getOrderDetail = function(req, res, next) {
    if (req.body.user_id == null || req.body.user_id == undefined || req.body.user_id == '') {
        return res.status(400).json({ status: 'error', message: 'User id is not found' });
    }
    try {
        var sql = "SELECT * FROM business_order_detail WHERE user_id = '" + req.body.user_id + "'"
        db.query(sql, function(error, result) {
            if (error) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'Successfull', data: result })
        })
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

/**
 * CREATE NEW ORDER
 */
exports.createOrder = function(req, res, next) {
    try {
        var user_id = req.userdata.id;
        var category;
        var item;
        if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.mobile == '' || req.body.mobile == 'undefined' || req.body.mobile == null) {
            return res.status(403).json({ status: 'error', message: 'Mobile number not found.' });
        } else if (req.body.notes == '' || req.body.notes == 'undefined' || req.body.notes == null) {
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

        var order_id = uniqid();
        order_id = order_id.toUpperCase();

        var category_length = category.length;
        var total_price = 0;
        var total_tax = 0;
        var total_amount = 0;

        for (var i = 0; i < category_length; i++) {
            var category_id = category[i].category_id;
            var category_items = category[i].category_item;
            var category_item_length = category_items.length;
            for (var j = 0; j < category_item_length; j++) {
                var item_id = category_items[j].item_id;
                var qty = Number(category_items[j].qty);
                var price = Number(category_items[j].price);
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
            name: req.body.name,
            mobile: req.body.mobile,
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