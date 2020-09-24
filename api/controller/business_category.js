var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/*CREATE BUSINESS CATEGORY*/
exports.add_business_category = function (req, res, next) {
    try {
        if (req.body.category_name == '' || req.body.category_name == null) {
            return res.status(403).json({ status: 'error', message: 'Business category name required.' });
        }
        var category_name = req.body.category_name;

        var sql = "INSERT INTO business_categories (category_name) values('" + category_name + "')";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Business category added successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/*SELECT ALL BUSINESS CATEGORY*/
exports.all_business_category = function (req, res, next) {
    try {
        if (req.body.type_id == '' || req.body.type_id == 'undefined' || req.body.type_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business type id required' });
        }
        var sql = "SELECT id, `category_name` FROM business_categories WHERE business_type_id='" + req.body.type_id + "' and is_activated='1' and deleted_at IS NULL";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/*SELECT FIND BUSINESS CATEGORY*/
exports.find_business_category = function (req, res, next) {
    try {
        if (req.body.category_id == '' || req.body.category_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business category id required' });
        }
        var category_id = req.body.category_id;
        var sql = "SELECT id, `category_name` FROM business_categories WHERE is_activated='1' and deleted_at IS NULL AND id = '" + category_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/*UPDATE BUSINESS CATEGORY*/
exports.update_business_category = function (req, res, next) {
    try {
        if (req.body.category_id == '' || req.body.category_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business category id required.' });
        }
        if (req.body.category_name == '' || req.body.category_name == null) {
            return res.status(403).json({ status: 'error', message: 'Business category name required.' });
        }
        var category_id = req.body.category_id;
        var category_name = req.body.category_name;

        var sql = "update business_categories set category_name = '" + category_name + "' where id = '" + category_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            res.status(200).json({ status: 'success', message: 'Business category updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/*DELETE BUSINESS CATEGORY*/
exports.delete_business_category = function (req, res, next) {
    try {
        if (req.body.category_id == '' || req.body.category_id == null) {
            return res.status(403).json({ status: 'error', message: 'business_id', data: 'Param required' });
        }
        var category_id = req.body.category_id;

        var sql = "update business_categories set is_activated=0, deleted_at = now() where id = '" + category_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            res.status(200).json({ status: 'success', message: 'Business category deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};