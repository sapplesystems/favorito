var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

exports.getProfile = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(500).send({ status: 'error', message: 'Id not found' });
    } else {
        var id = req.body.id;
        var sql = "SELECT * FROM users WHERE id='" + id + "' and deleted_at is null";
        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.', data: err });
            } else {
                return res.status(200).json({ status: 'success', message: 'success', data: rows });
            }

            //res.json(rows);
        });
    }

};

/* USER LOGIN START HERE */
exports.login = function (req, res, next) {
    if (req.body.username == '' || req.body.username == null) {
        return res.json({ status: 'error', message: 'username', data: 'Param required' });
    } else if (req.body.password == '' || req.body.password == null) {
        return res.json({ status: 'error', message: 'password', data: 'Param required' });
    }
    var username = req.body.username;

    var sql = "select * from users where username='" + username + "'";
    db.query(sql, function (err, result) {
        if (err) {
            return res.json({ status: 'error', message: 'Something went wrong.', data: err });
        } else {

            bcrypt.compare(req.body.password, result[0].password, function (err, enc_result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrongggggggg.', data: err });
                }
                if (enc_result == true) {
                    var token = jwt.sign({
                        username: result[0].username,
                        id: result[0].id,
                    }, 'secret', {
                        expiresIn: "1h"
                    });
                    return res.json({ status: 'success', message: 'success', data: result, token: token });
                } else {
                    return res.status(500).json({ status: 'error', message: 'Incorrect username or password' });
                }
            });
        }
    });
};
/* USER LOGIN END HERE */