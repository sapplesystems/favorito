var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/*CREATE BUSINESS CATEGORY*/
exports.add_business_category = function (req, res, next) {
    if (req.body.category_name == '' || req.body.category_name == null) {
        return res.status(500).json({status: 'error', message: 'category_name', data: 'Param required'});
    }
    var category_name = req.body.category_name;

    var sql = "INSERT INTO business_categories (name) values('" + category_name + "')";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        return  res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};

/*SELECT ALL BUSINESS CATEGORY*/
exports.all_business_category = function (req, res, next) {
    var sql = "SELECT id, `name` FROM business_categories WHERE deleted_at IS NULL";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        return res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};

/*SELECT FIND BUSINESS CATEGORY*/
exports.find_business_category = function (req, res, next) {
    if (req.body.category_id == '' || req.body.category_id == null) {
        return res.status(500).json({status: 'error', message: 'business_id', data: 'Param required'});
    }
    var category_id = req.body.category_id;
    var sql = "SELECT id, `name` FROM business_categories WHERE deleted_at IS NULL AND id = '" + category_id + "'";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        return res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};

/*UPDATE BUSINESS CATEGORY*/
exports.update_business_category = function (req, res, next) {
    if (req.body.category_id == '' || req.body.category_id == null) {
        return res.status(500).json({status: 'error', message: 'business_id', data: 'Param required'});
    }
    if (req.body.category_name == '' || req.body.category_name == null) {
        return res.status(500).json({status: 'error', message: 'business_name', data: 'Param required'});
    }
    var category_id = req.body.category_id;
    var category_name = req.body.category_name;

    var sql = "update business_categories set name = '" + category_name + "' where id = '" + category_id + "'";
    db.query(sql, function (err, result) {
        if (err) {
            res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};

/*DELETE BUSINESS CATEGORY*/
exports.delete_business_category = function (req, res, next) {
    if (req.body.category_id == '' || req.body.category_id == null) {
        return res.status(500).json({status: 'error', message: 'business_id', data: 'Param required'});
    }
    var category_id = req.body.category_id;

    var sql = "update business_categories set deleted_at = now() where id = '" + category_id + "'";
    db.query(sql, function (err, result) {
        if (err) {
            res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};