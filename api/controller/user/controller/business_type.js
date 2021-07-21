var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/*CREATE BUSINESS TYPE*/
exports.add_business_type = function (req, res, next) {
    try {
        if (req.body.type_name == '' || req.body.type_name == null) {
            return res.status(403).json({ status: 'error', message: 'Business type name required.' });
        }
        var type_name = req.body.type_name;

        var sql = "INSERT INTO business_types (type_name) values('" + type_name + "')";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            return res.status(200).json({ status: 'success', message: 'Business type added successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/*SELECT ALL BUSINESS TYPE*/
exports.all_business_type = function (req, res, next) {
    try {
        var sql = "SELECT id, `type_name` FROM business_types WHERE is_activated=1 and deleted_at IS NULL";
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

/*SELECT FIND BUSINESS TYPE*/
exports.find_business_type = function (req, res, next) {
    try {
        if (req.body.type_id == '' || req.body.type_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business type id required.' });
        }
        var type_id = req.body.type_id;
        var sql = "SELECT id, `type_name` FROM business_types WHERE is_activated=1 and deleted_at IS NULL AND id = '" + type_id + "'";
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

/*UPDATE BUSINESS TYPE*/
exports.update_business_type = function (req, res, next) {
    try {
        if (req.body.type_id == '' || req.body.type_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business type id required.' });
        }
        if (req.body.type_name == '' || req.body.type_name == null) {
            return res.status(403).json({ status: 'error', message: 'Business type is required.' });
        }
        var type_id = req.body.type_id;
        var type_name = req.body.type_name;

        var sql = "update business_types set type_name = '" + type_name + "' where id = '" + type_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            res.status(200).json({ status: 'success', message: 'Business type updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/*DELETE BUSINESS TYPE*/
exports.delete_business_type = function (req, res, next) {
    try {
        if (req.body.type_id == '' || req.body.type_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business type id is required.' });
        }
        var type_id = req.body.type_id;

        var sql = "update business_types set is_activated=0, deleted_at = now() where id = '" + type_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            res.status(200).json({ status: 'success', message: 'Business type deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};