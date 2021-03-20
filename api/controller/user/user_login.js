var db = require('../../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');
var validator = require('validator')

var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

/**
 * USER LOGIN START HERE
 */
exports.login = function(req, res, next) {
    try {
        if (req.body.username == '' || req.body.username == null) {
            return res.status(403).json({ status: 'error', message: 'User email or phone required.' });
        } else if (req.body.password == '' || req.body.password == null) {
            return res.status(403).json({ status: 'error', message: 'Password required.' });
        }
        var username = req.body.username;

        var sql = "select * from users where (email='" + username + "' or phone='" + username + "') and deleted_at is null";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            } else {
                if (result.length === 0) {
                    return res.status(200).json({ status: 'Fail', message: 'Incorrect username or password' });
                }
                bcrypt.compare(req.body.password, result[0].password, function(err, enc_result) {
                    if (err) {
                        return res.status(200).json({ status: 'Fail', message: 'Password not matched', data: err });
                    }
                    if (enc_result == true) {
                        var token = jwt.sign({
                            email: result[0].email,
                            phone: result[0].phone,
                            id: result[0].id
                        }, 'secret', {
                            expiresIn: "2 days"
                        });

                        var user_data = {
                            id: result[0].id,
                            email: result[0].email,
                            phone: result[0].phone,
                            postal: result[0].postal
                        };
                        return res.status(200).json({ status: 'success', message: 'success', data: user_data, token: token });
                    } else {
                        return res.status(403).json({ status: 'error', message: 'Incorrect username or password' });
                    }
                });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.sendLoginOtp = async(req, res) => {
    try {
        // if (!req.body.username) {
        //     return res.status(403).json({ status: 'error', message: 'User email or phone required.' });
        // } else {
        //     username = req.body.username;
        // }
        // var sql_check_valid_username = "select * from users where (email='" + username + "' or phone='" + username + "') and deleted_at is null";
        // var result_check_valid_username = await this.run_query(sql_check_valid_username)
        // if (result_check_valid_username.length === 0) {
        //     return res.status(200).json({ status: 'Fail', message: 'Username is incorrect' });
        // }
        console.log(req.body.username)
        console.log(Number.isNaN(req.body.username))


    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

exports.verifyLoginOtp = async(req, res) => {
    return res.send('login otp')
}

exports.run_query = (sql, param = false) => {
    if (param == false) {
        return new Promise((resolve, reject) => {
            db.query(sql, (error, result) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    } else {
        return new Promise((resolve, reject) => {
            db.query(sql, param, (error, result) => {
                if (error) {
                    console.log(error)
                    reject(error);
                } else {
                    resolve(result);
                }
            })
        })
    }
}