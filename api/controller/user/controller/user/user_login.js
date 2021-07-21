var db = require('../../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');
var validator = require('validator')
var nodemailer = require('nodemailer');
const fast2sms = require('fast-two-sms');

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
                            id: result[0].id,
                            role:'user',
                            fb_key:result[0].firebase_chat_id,
                            created_at:result[0].created_at
                        }, 'secret', {
                            expiresIn: "2 days"
                        });

                        var user_data = {
                            id: result[0].id,
                            email: result[0].email,
                            phone: result[0].phone,
                            postal: result[0].postal,
                            fb_key:result[0].firebase_chat_id,
                            role:'user',
                            
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
        if (!req.body.username) {
            return res.status(403).json({ status: 'error', message: 'User email or phone required.' });
        } else {
            username = req.body.username;
        }
        var sql_check_valid_username = "select * from users where (email='" + username + "' or phone='" + username + "') and deleted_at is null";
        var result_check_valid_username = await this.run_query(sql_check_valid_username)
        if (result_check_valid_username.length === 0) {
            return res.status(200).json({ status: 'Fail', message: 'Username is incorrect' });
        }
        let otp = Math.floor(Math.random() * 90000) + 10000;

        if (validator.isEmail(req.body.username)) {
            var sql_save_otp = "UPDATE users SET password_change_otp ='" + otp + "' WHERE email ='" + req.body.username + "'";
            var result_save_otp = await exports.run_query(sql_save_otp)
            var transporter = nodemailer.createTransport({
                service: 'gmail',
                auth: {
                    user: process.env.EMAIL_AUTH_USER,
                    pass: process.env.EMAIL_AUTH_PASSWORD
                }
            });

            var mailOptions = {
                from: process.env.EMAIL_AUTH_USER,
                to: req.body.username,
                subject: 'Login otp',
                text: `Login otp`,
                html: `<h1>Welcome<h1><br><h2>Your login otp is ${otp} <h2>`
            };

            transporter.sendMail(mailOptions, function(error, info) {
                if (error) {
                    console.log(`Error in sending the mail ${error}`);
                } else {
                    console.log('Email sent: ' + info.response);
                    res.status(200).send({ status: "success", message: "OTP is sent to email!" })
                }
            });
        } else if (validator.isMobilePhone(req.body.username)) {
            if (exports.sendSms(req.body.username, otp)) {
                var sql_save_otp = "UPDATE users SET password_change_otp ='" + otp + "' WHERE phone ='" + req.body.username + "'";
                var result_save_otp = await exports.run_query(sql_save_otp)
                return res.status(200).send({ status: 'success', message: 'OTP is sent to your mobile number' })
            } else {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' })
            }
        } else {
            return res.status(400).json({ status: 'error', message: 'Please enter the valid mobile or email.' });
        }
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

exports.verifyLoginOtp = async(req, res) => {
    if (!req.body.username) {
        return res.status(403).json({ status: 'error', message: 'User email or phone required.' });
    }
    if (!req.body.otp) {
        return res.status(403).json({ status: 'error', message: 'otp is missing' });
    }
    user_detail = await exports.getOtpFromDb(req.body.username)
    if (req.body.otp != user_detail[0].password_change_otp) {
        return res.status(401).json({ status: 'error', message: 'otp is invalid' });
    } else {
        var token = jwt.sign({
            email: user_detail[0].email,
            phone: user_detail[0].phone,
            id: user_detail[0].id
        }, 'secret', {
            expiresIn: "2 days"
        });

        var user_data = {
            id: user_detail[0].id,
            email: user_detail[0].email,
            phone: user_detail[0].phone,
            postal: user_detail[0].postal
        };
        try {
            var sql_save_otp = "UPDATE users SET password_change_otp = NULL WHERE phone ='" + req.body.username + "'";
            var result_save_otp = await exports.run_query(sql_save_otp)
            return res.status(200).json({ status: 'success', message: 'success', data: user_data, token: token });
        } catch (error) {
            return res.status(500).json({ status: 'falied', message: 'Something went wrong', error });
        }
    }
}


exports.sendSms = async function(phone, otp) {
    var options = {
        authorization: process.env.FASTSENDSMS_API_KEY,
        message: `<#> Favorito: Your code is ${otp}
        FA+9qCX9VSu`,
        numbers: [phone]
    }
    fast2sms.sendMessage(options).then(function(data) {
        console.log('OTP is sent successfully', data);
        return true
    }).catch(function(error) {
        console.log(`Error in sending otp ${error}`)
        return false
    })
}

exports.getOtpFromDb = function(user_name) {
    return new Promise(function(resolve, reject) {
        var sql_check_valid_username = "select * from users where (email='" + user_name + "' or phone='" + user_name + "') and deleted_at is null";
        db.query(sql_check_valid_username, function(err, result) {
            if (err) {
                return reject(err)
            }
            return resolve(result)
        })
    })
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