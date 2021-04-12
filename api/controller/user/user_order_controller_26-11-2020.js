var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

exports.getOrderList = function(req, res, next) {
    if (req.body.user_id == null || req.body.user_id == undefined || req.body.user_id == '') {
        return res.status(400).json({ status: 'error', message: 'User id is not found' });
    }
    try {
        var sql = "SELECT * FROM business_orders AS a  JOIN business_order_detail AS b ON a.order_id = b.order_id  WHERE a.user_id = '" + req.body.user_id + "' GROUP BY b.item_id"
        db.query(sql, function(error, result) {
            if (error) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'Successfull', data: result })
        })
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

exports.getOrderDetail = function(req, res, next) {
    if (req.body.user_id == null || req.body.user_id == undefined || req.body.user_id == '') {
        return res.status(400).json({ status: 'error', message: 'User id is not found' });
    }
    try {
        var sql = "SELECT * FROM business_order_detail WHERE user_id = '" + req.body.user_id + "'"
        db.query(sql, function(error, result) {
            if (error) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).send({ status: 'success', message: 'Successfull', data: result })
        })
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}