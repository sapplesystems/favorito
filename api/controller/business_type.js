var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/*CREATE BUSINESS TYPE*/
exports.add_business_type = function (req, res, next) {
    if (req.body.business_name == '' || req.body.business_name == null) {
        return res.status(500).json({status: 'error', message: 'business_name', data: 'Param required'});
    }
    var business_name = req.body.business_name;

    var sql = "INSERT INTO business_types (name) values('" + business_name + "')";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        return  res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};

/*SELECT ALL BUSINESS TYPE*/
exports.all_business_type = function (req, res, next) {
    var sql = "SELECT id, `name` FROM business_types WHERE deleted_at IS NULL";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        return res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};

/*SELECT FIND BUSINESS TYPE*/
exports.find_business_type = function (req, res, next) {
    if (req.body.business_id == '' || req.body.business_id == null) {
        return res.status(500).json({status: 'error', message: 'business_id', data: 'Param required'});
    }
    var business_id = req.body.business_id;
    var sql = "SELECT id, `name` FROM business_types WHERE deleted_at IS NULL AND id = '" + business_id + "'";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        return res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};

/*UPDATE BUSINESS TYPE*/
exports.update_business_type = function (req, res, next) {
    if (req.body.business_id == '' || req.body.business_id == null) {
        return res.status(500).json({status: 'error', message: 'business_id', data: 'Param required'});
    }
    if (req.body.business_name == '' || req.body.business_name == null) {
        return res.status(500).json({status: 'error', message: 'business_name', data: 'Param required'});
    }
    var business_id = req.body.business_id;
    var business_name = req.body.business_name;

    var sql = "update business_types set name = '" + business_name + "' where id = '" + business_id + "'";
    db.query(sql, function (err, result) {
        if (err) {
            res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};

/*DELETE BUSINESS TYPE*/
exports.delete_business_type = function (req, res, next) {
    if (req.body.business_id == '' || req.body.business_id == null) {
        return res.status(500).json({status: 'error', message: 'business_id', data: 'Param required'});
    }
    var business_id = req.body.business_id;

    var sql = "update business_types set deleted_at = now() where id = '" + business_id + "'";
    db.query(sql, function (err, result) {
        if (err) {
            res.status(500).json({status: 'error', message: 'Something went wrong.', data: err});
        }
        res.status(200).json({status: 'success', message: 'success', id: result.insertId, data: result});
    });
};