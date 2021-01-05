var db = require('../config/db');

exports.addTag = function (req, res, next) {
    try {
        if (req.body.tag_name == '' || req.body.tag_name == 'undefined' || req.body.tag_name == null) {
            return res.status(403).json({ status: 'error', message: 'Tag name not found.' });
        }
        var postval = { tag_name: req.body.tag_name };

        var sql = "INSERT INTO business_tags_master SET ?";
        db.query(sql, postval, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Tag added successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.listTag = function (req, res, next) {
    try {
        var cond = "";
        if (req.body.tag_id != '' && req.body.tag_id != 'undefined' && req.body.tag_id != null) {
            cond = " AND id='" + req.body.tag_id + "'";
        }
        var sql = "SELECT id, `tag_name` FROM business_tags_master WHERE deleted_at IS NULL" + cond;
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: (req.body.tag_id) ? result[0] : result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.updateTag = function (req, res, next) {
    try {
        if (req.body.tag_id == '' || req.body.tag_id == 'undefined' || req.body.tag_id == null) {
            return res.status(403).json({ status: 'error', message: 'Tag id required.' });
        }
        if (req.body.tag_name == '' || req.body.tag_name == 'undefined' || req.body.tag_name == null) {
            return res.status(403).json({ status: 'error', message: 'Tag name required.' });
        }
        var tag_id = req.body.tag_id;
        var tag_name = req.body.tag_name;

        var sql = "update business_tags_master set tag_name = '" + tag_name + "', updated_at=now() where id = '" + tag_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            res.status(200).json({ status: 'success', message: 'Tag updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.deleteTag = function (req, res, next) {
    try {
        if (req.body.tag_id == '' || req.body.tag_id == 'undefined' || req.body.tag_id == null) {
            return res.status(403).json({ status: 'error', message: 'Tag id required.' });
        }
        var tag_id = req.body.tag_id;

        var sql = "update business_tags_master set deleted_at = now() where id = '" + tag_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            res.status(200).json({ status: 'success', message: 'Tag deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};