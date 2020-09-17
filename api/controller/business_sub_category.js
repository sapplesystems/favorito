var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/*SELECT ALL BUSINESS CATEGORY*/
exports.all_business_sub_category = function (req, res, next) {
    if (req.body.category_id == '' || req.body.category_id == 'undefined' || req.body.category_id == null) {
        return res.status(404).json({ status: 'error', message: 'Business category id required' });
    }
    var sql = "SELECT id, `sub_category_name` FROM business_sub_categories WHERE business_category_id='" + req.body.category_id + "' and is_activated='1' and deleted_at IS NULL";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
        }
        return res.status(200).json({ status: 'success', message: 'success', data: result });
    });
};