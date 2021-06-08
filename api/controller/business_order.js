var db = require('../config/db');
var menu_type_id = 1;
var order_type = ['Dine-In', 'Take Away', 'Delivery'];
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var uniqid = require('uniqid');

/**
 * GET STATIC VARIABLE
 */
exports.dd_verbose = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var data = {
            category: await exports.getCategories(business_id, req),
            order_type: order_type
        };
        return res.status(200).json({ status: 'success', message: 'success', data: data });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET MENU CATEGORY
 */
exports.getCategories = function(business_id, req) {
    try {
        return new Promise(async function(resolve, reject) {
            var business_id = req.userdata.business_id;
            var cat = await exports.getOnlyCategoryList(business_id, req);
            if (cat.length) {
                var len = cat.length;
                var dataset = [];
                for (var i = 0; i < len; i++) {
                    var data = {
                        "category_id": cat[i].id,
                        "category_name": cat[i].category_name,
                        "category_item": await exports.getCategoryItems(cat[i].id)
                    };
                    dataset.push(data);
                }
                return resolve(dataset);
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET CATEGORY LIST
 */
exports.getCategoryList = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var data = await exports.getOnlyCategoryList(business_id, req);
        if (data.length) {
            return res.status(200).json({ status: 'success', message: 'success', data: data });
        } else {
            return res.status(200).json({ status: 'success', message: 'no record found', data: [] });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * GET ITEM LIST BY CATEGORY ID
 */
exports.getItemByCategoryId = async function(req, res, next) {
    try {
        if (req.body.category_id == '' || req.body.category_id == 'undefined' || req.body.category_id == null) {
            return res.status(403).json({ status: 'error', message: 'Category id not found.' });
        }
        var business_id = req.userdata.business_id;
        var category_id = req.body.category_id;
        var data = await exports.getCategoryItems(category_id);
        if (data.length) {
            return res.status(200).json({ status: 'success', message: 'success', data: data });
        } else {
            return res.status(200).json({ status: 'success', message: 'no record found', data: [] });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET ONLY CATEGORY LIST
 */
exports.getOnlyCategoryList = function(business_id, req) {
    try {
        return new Promise(function(resolve, reject) {
            var COND = "business_id='" + business_id + "' AND menu_type_id='" + menu_type_id + "' AND is_activated='1' AND deleted_at IS NULL";
            COND += " AND CURTIME() >= slot_start_time && CURTIME() <= slot_end_time AND FIND_IN_SET(DATE_FORMAT(CURDATE(),'%a'), available_on) ";
            if (req.body.category_id != '' && req.body.category_id != 'undefined' && req.body.category_id != null) {
                COND += " AND id='" + req.body.category_id + "'";
            }

            var sql = "SELECT id, category_name FROM business_menu_category WHERE " + COND;
            db.query(sql, async function(e, cat) {
                resolve(cat);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET CATEGORY ITEMS
 */
exports.getCategoryItems = function(category_id) {
    try {
        return new Promise(function(resolve, reject) {
            var sql2 = "SELECT id, title, price, quantity, max_qty_per_order FROM business_menu_item WHERE menu_category_id='" + category_id + "'";
            db.query(sql2, function(e2, item) {
                resolve(item);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE NEW ORDER
 */
exports.createNewOrder = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
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
                    business_id: business_id,
                    order_id: order_id,
                    category_id: category_id,
                    item_id: item_id,
                    quantity: qty,
                    price: price,
                    tax: tax,
                    amount: amount,
                };

                var sql = "INSERT INTO business_order_detail set ?";
                db.query(sql, order_detail);
            }
        }

        var order = {
            business_id: business_id,
            order_id: order_id,
            name: req.body.name,
            mobile: req.body.mobile,
            notes: req.body.notes,
            order_type: req.body.order_type,
            total_amount: total_amount,
            payment_type: req.body.payment_type
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


/**
 * LIST ALL ORDERS
 */
exports.listAllOrder = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var COND = "business_id='" + business_id + "' AND deleted_at IS NULL ";

        if (req.body.order_id != '' && req.body.order_id != 'undefined' && req.body.order_id != null) {
            COND += " AND order_id='" + req.body.order_id + "' ";
        }

        var sql = "SELECT order_id,`name`,`mobile`,`notes`,order_type,total_amount,order_status,DATE_FORMAT(created_at,'%d-%b-%Y at %H:%i') AS order_date,payment_type \n\
                    FROM business_orders WHERE " + COND;

        db.query(sql, async function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            if (result.length == 0) {
                return res.status(200).json({ status: 'success', message: 'No order found', data: [] });
            }

            var len = result.length;
            var dataset = [];
            // for (var i = 0; i < len; i++) {
            //     var data = {
            //         "order": result[i],
            //         "detail": await exports.orderItemDetail(business_id, result[i].order_id)
            //     };
            //     dataset.push(data);
            // }
            // return res.status(200).json({ status: 'success', message: 'success', data: dataset });
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * GET ORDER ITEM DETAIL
 */
exports.orderItemDetail = function(business_id, order_id) {
    try {
        return new Promise(async function(resolve, reject) {
            var sql = "SELECT category_id, \n\
                        (SELECT category_name FROM business_menu_category WHERE id=category_id) AS category_name, \n\
                        item_id, \n\
                        (SELECT title FROM business_menu_item WHERE id=item_id) AS category_name, \n\
                        quantity,price,tax,amount \n\
                        FROM business_order_detail \n\
                        WHERE business_id='" + business_id + "' AND order_id='" + order_id + "'";
            db.query(sql, function(err, result) {
                console.log(result)
                resolve(result);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * UPDATE ORDER STATUS 
 **/

exports.updateOrderStatus = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
            return res.status(403).json({ status: 'error', message: 'Order Id Not Found.' });
        } else if (req.body.status == '' || req.body.status == 'undefined' || req.body.status == null) {
            return res.status(403).json({ status: 'error', message: 'Order Status Not Found' });
        }
        var order_id = req.body.id;

        var update_columns = " updated_at=now() ";

        if (req.body.status != '' && req.body.status != 'undefined' && req.body.status != null) {
            if (req.body.status == 'accepted' || req.body.status == 'rejected' || req.body.status == 'pending') {
                update_columns += ", order_status='" + req.body.status + "' ";
                var sql = "UPDATE business_orders SET " + update_columns + " WHERE order_id='" + order_id + "' AND business_id='" + business_id + "'";
                db.query(sql, function(err, result) {
                    if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                    }
                    return res.status(200).json({
                        status: 'success',
                        message: 'Order updated successfully.',
                    });
                });
            } else {
                return res.status(200).json({ status: 'error', message: 'Please Send Correct Status' });
            }
        } else {
            return res.status(200).json({ status: 'error', message: 'Please Dont send null status' });
        }

    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * DELETE ORDER
 */
exports.deleteOrder = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.order_id == '' || req.body.order_id == 'undefined' || req.body.order_id == null) {
            return res.status(403).json({ status: 'error', message: 'Order id not found.' });
        }

        var order_id = req.body.order_id;

        var sql = "UPDATE business_orders SET deleted_at = NOW() WHERE id='" + order_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Order deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};