var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

exports.getProfile = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(500).send({ status: 'error', message: 'Id not found' });
    } else {
        var id = req.body.id;
        var sql = "SELECT * FROM business_users WHERE id='" + id + "' and is_activated=1 and deleted_at is null";
        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else {
                return res.status(200).json({ status: 'success', message: 'success'});
            }

            //res.json(rows);
        });
    }

};

/* USER LOGIN START HERE */
exports.login = function (req, res, next) {
    if (req.body.username == '' || req.body.username == null) {
        return res.json({ status: 'error', message: 'Business email or phone required.'});
    } else if (req.body.password == '' || req.body.password == null) {
        return res.json({ status: 'error', message: 'Password required.'});
    }
    var username = req.body.username;

    var sql = "select * from business_users where (business_email='" + username + "' or business_phone='" + username + "') and is_activated=1 and deleted_at is null";
    db.query(sql, function (err, result) {
        if (err) {
            return res.json({ status: 'error', message: 'Something went wrong.', data: err });
        } else {
            if (result.length === 0) {
                return res.status(500).json({ status: 'error', message: 'Incorrect username or password' });
            }
            bcrypt.compare(req.body.password, result[0].password, function (err, enc_result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
                }
                if (enc_result == true) {
                    var token = jwt.sign({
                        business_email: result[0].business_email,
                        business_phone: result[0].business_phone,
                        id: result[0].id,
                        business_id: result[0].business_id,
                    }, 'secret', {
                        expiresIn: "1h"
                    });

                    var user_data = {
                        id: result[0].id,
                        business_id: result[0].business_id,
                        business_email: result[0].business_email,
                        business_phone: result[0].business_phone,
                        photo: result[0].photo,
                    };
                    return res.json({ status: 'success', message: 'success', data: user_data, token: token });
                } else {
                    return res.status(500).json({ status: 'error', message: 'Incorrect username or password' });
                }
            });
        }
    });
};
/* USER LOGIN END HERE */