var db = require('../config/db');

/**
 * FETCH ALL NOTIFICATION
 */
exports.all_notifications = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(404).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.status(404)({ status: 'error', message: 'Business id not found.' });
    }
    var sql = "SELECT id, title, description FROM business_notifications WHERE business_id='" + req.body.business_id + "' AND business_user_id='" + req.body.id + "' AND is_deleted='0' AND deleted_at IS NULL";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
        }
        return res.status(200).json({ status: 'success', message: 'success', data: result });
    });
};

/**
 * STATIC DROP DONW DETAI TO CREATE THE NOTIFICATION
 */
exports.dd_verbose = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(404).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.status(404)({ status: 'error', message: 'Business id not found.' });
    }
    var sql = "SELECT id, `state` from states order by state";
    db.query(sql, function (err, state_list, fields) {
        if (err) {
            return res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
        }
        var verbose = {};
        verbose.action = ['Call', 'Chat'];
        verbose.audience = ['Paid', 'Free'];
        verbose.area = ['Country', 'State', 'City', 'Pincode'];
        verbose.status = ['New', 'In-Progress', 'Complete'];
        verbose.state_list = state_list;
        return res.status(200).json({ status: 'success', message: 'success', data: verbose });
    });
};


/**
 * VERIFY PINCODE
 */
exports.verify_pincode = function (req, res, next) {
    if (req.body.pincode == '' || req.body.pincode == 'undefined' || req.body.pincode == null) {
        return res.status(404).send({ status: 'error', message: 'Pincode not found' });
    }
    var P = require('pincode-validator');
    var ps = P.validate(req.body.pincode);
    if(ps === true){
        return res.status(200).json({ status: 'success', message: 'Pincode is correct.' });
    }else{
        return res.status(404).json({ status: 'error', message: 'Pincode is incorrect.' });
    }
};


/**
 * CREATE NEW NOTIFICATION
 */
exports.add_notification = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(404).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.status(404)({ status: 'error', message: 'Business id not found.' });
    } else if (req.body.title == '' || req.body.title == 'undefined' || req.body.title == null) {
        return res.status(404)({ status: 'error', message: 'Notification title not found.' });
    } else if (req.body.description == '' || req.body.description == 'undefined' || req.body.description == null) {
        return res.status(404)({ status: 'error', message: 'Notification description not found.' });
    } else if (req.body.action == '' || req.body.action == 'undefined' || req.body.action == null) {
        return res.status(404)({ status: 'error', message: 'Action not found.' });
    } else if (req.body.action === 'Call' && (req.body.contact == '' || req.body.contact == 'undefined' || req.body.contact == null)) {
        return res.status(404)({ status: 'error', message: 'Contact not found.' });
    } else if (req.body.audience == '' || req.body.audience == 'undefined' || req.body.audience == null) {
        return res.status(404)({ status: 'error', message: 'Notification audience not found.' });
    } else if (req.body.area == '' || req.body.area == 'undefined' || req.body.area == null) {
        return res.status(404)({ status: 'error', message: 'Notification area not found.' });
    } else if (req.body.area_detail == '' || req.body.area_detail == 'undefined' || req.body.area_detail == null) {
        return res.status(404)({ status: 'error', message: 'Notification area_detail not found.' });
    } else if (req.body.quantity == '' || req.body.quantity == 'undefined' || req.body.quantity == null) {
        return res.status(404)({ status: 'error', message: 'Notification quantity not found.' });
    }

    var title = req.body.title;
    var description = req.body.description;
    var action = req.body.action;
    var contact = req.body.contact;
    var audience = req.body.audience;
    var area = req.body.area;
    var area_detail = req.body.area_detail;
    var quantity = req.body.quantity;
    var business_id = req.body.business_id;
    var business_user_id = req.body.id;

    var sql = "INSERT INTO business_notifications(title, description, `action`, contact, audience, `area`, area_detail, quantity, business_id, business_user_id) \n\
                VALUES ('"+ title + "','" + description + "','" + action + "','" + contact + "','" + audience + "','" + area + "','" + area_detail + "','" + quantity + "','" + business_id + "','" + business_user_id + "');";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
        }
        return res.status(200).json({ status: 'success', message: 'Notification created successfully.' });
    });
};