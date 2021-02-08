var db = require('../config/db');

exports.addAttribute = function(req, res, next) {
    try {
        if (req.body.attribute_name == '' || req.body.attribute_name == 'undefined' || req.body.attribute_name == null) {
            return res.status(403).json({ status: 'error', message: 'Attribute name not found.' });
        }
        var postval = { attribute_name: req.body.attribute_name };

        var sql = "INSERT INTO business_attributes_master SET ?";
        db.query(sql, postval, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Attribute added successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.listAttribute = function(req, res, next) {
    try {
        var cond = "";
        if (req.body.attribute_id != '' && req.body.attribute_id != 'undefined' && req.body.attribute_id != null) {
            cond = " AND id='" + req.body.attribute_id + "'";
        }
        var sql = "SELECT id, `attribute_name` FROM business_attributes_master WHERE deleted_at IS NULL" + cond;
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: (req.body.attribute_id) ? result[0] : result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.updateAttribute = function(req, res, next) {
    try {
        if (req.body.attribute_id == '' || req.body.attribute_id == 'undefined' || req.body.attribute_id == null) {
            return res.status(403).json({ status: 'error', message: 'Attribute id required.' });
        }
        if (req.body.attribute_name == '' || req.body.attribute_name == 'undefined' || req.body.attribute_name == null) {
            return res.status(403).json({ status: 'error', message: 'Attribute name required.' });
        }
        var attribute_id = req.body.attribute_id;
        var attribute_name = req.body.attribute_name;

        var sql = "update business_attributes_master set attribute_name = '" + attribute_name + "', updated_at=now() where id = '" + attribute_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            res.status(200).json({ status: 'success', message: 'Attribute updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.deleteAttribute = function(req, res, next) {
    try {
        if (req.body.attribute_id == '' || req.body.attribute_id == 'undefined' || req.body.attribute_id == null) {
            return res.status(403).json({ status: 'error', message: 'Attribute id required.' });
        }
        var attribute_id = req.body.attribute_id;

        var sql = "update business_attributes_master set deleted_at = now() where id = '" + attribute_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            res.status(200).json({ status: 'success', message: 'Attribute deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};