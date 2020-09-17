var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/**
 * CREATE NEW NOTIFICATION
 */
exports.add_business_category = function (req, res, next) {
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

/**
 * FETCH ALL NOTIFICATION
 */
exports.all_business_category = function (req, res, next) {
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