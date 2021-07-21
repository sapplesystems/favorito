var db = require('../../config/db');
var bcrypt = require('bcrypt');
var nodemailer = require('nodemailer');
const fast2sms = require('fast-two-sms');

exports.changePasswordByOld = (req, res) => {
    try {
        if (req.body.old_password == '' || req.body.old_password == 'undefined' || req.body.old_password == null) {
            return res.status(403).json({ status: 'error', message: 'Old password not found.' });
        } else if (req.body.new_password == '' || req.body.new_password == 'undefined' || req.body.new_password == null) {
            return res.status(403).json({ status: 'error', message: 'New password not found.' });
        } else if (req.body.confirm_password == '' || req.body.confirm_password == 'undefined' || req.body.confirm_password == null) {
            return res.status(403).json({ status: 'error', message: 'Confirm passwod not found.' });
        } else if (req.body.new_password != req.body.confirm_password) {
            return res.status(403).json({ status: 'error', message: 'New password and confirm password does not match.' });
        } else {
            var sql = "select * from users where id='" + req.userdata.id + "' and deleted_at is null";
            db.query(sql, function(err, result) {
                if (err) {
                    return res.json({ status: 'error', message: 'Something went wrong.', data: err });
                } else {
                    if (result.length === 0) {
                        return res.status(403).json({ status: 'error', message: 'Incorrect user id' });
                    }
                    bcrypt.compare(req.body.old_password, result[0].password, function(err, enc_result) {
                        if (err) {
                            return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
                        } else if (enc_result === false) {
                            return res.status(403).json({ status: 'error', message: 'Old pssword does not match.', data: err });
                        } else {
                            bcrypt.hash(req.body.new_password, 10, function(err, hash) {
                                var uq = "UPDATE users SET `password`='" + hash + "' WHERE id='" + req.userdata.id + "'";
                                db.query(uq, function(error, resp) {
                                    if (error) {
                                        return res.status(403).json({ status: 'error', message: 'Password could not be changed.' });
                                    }
                                    return res.status(200).json({ status: 'success', message: 'Password changed successfully.' });
                                });
                            });
                        }
                    });
                }
            });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

exports.sendOtpChangePassword = async(req, res) => {
    if (!req.body.email_or_phone) {
        return res.status(400).json({ status: 'error', message: 'Email id or Phone number is missing' });
    }
    //  regex of email check
    if (/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(req.body.email_or_phone)) {
        let email = req.body.email_or_phone
        sql_is_email_exist = `SELECT id FROM users WHERE email = '${email}'`
        result_is_email_exist = await exports.run_query(sql_is_email_exist)
        if (result_is_email_exist != '') {
            id = result_is_email_exist[0].id
        }
        if (result_is_email_exist == '') {
            return res.status(200).json({
                status: 'success',
                message: 'Invalid email-id',
                data: [{ response_status: 'failed' }]
            });
        }

        let otp = Math.floor(Math.random() * 90000) + 10000;
        try {
            is_mail_sent = await sendMail(email, otp)
            if (is_mail_sent) {
                sql_insert_otp = `UPDATE users SET password_change_otp = '${otp}' WHERE id = '${id}'`
                result_insert_otp = await exports.run_query(sql_insert_otp)
                return res.status(200).json({ status: 'success', message: 'Email is sent with OTP', data: [{ user_id: id, response_status: 'success' }] });
            }
        } catch (error) {
            return res.status(500).json({ status: 'failed', message: 'Email cannot be sent due to some issue.', error });
        }

    } else if (req.body.email_or_phone != '') {
        let otp = Math.floor(Math.random() * 90000) + 10000;
        let phone = req.body.email_or_phone
        sql_is_phone_exist = `SELECT id FROM users WHERE phone = '${phone}'`
        result_is_phone_exist = await exports.run_query(sql_is_phone_exist)
        if (result_is_phone_exist != '') {
            id = result_is_phone_exist[0].id
        }
        if (result_is_phone_exist == '') {
            return res.status(200).json({
                status: 'success',
                message: 'Invalid phone number',
                data: [{ response_status: 'failed' }]
            });
        } else {
            var options = {
                authorization: process.env.FASTSENDSMS_API_KEY,
                message: `<#> Favorito: Your code is ${otp}
                FA+9qCX9VSu`,
                numbers: [phone]
            }
            fast2sms.sendMessage(options).then(async function(data) {
                // send sms or email otp is saved in the email_otp column and verified from the there only
                sql_insert_otp = `UPDATE users SET password_change_otp = '${otp}' WHERE id = '${id}'`
                result_insert_otp = await exports.run_query(sql_insert_otp)
                return res.status(200).json({ status: 'success', message: 'SMS is sent with OTP', data: [{ user_id: id, response_status: 'success' }] });
            }).catch(function(error) {
                console.log(`Error in sending otp ${error}`)
                return res.status(500).json({ status: 'error', message: 'Something went wrong' });
            })
        }
    } else {
        return res.status(400).json({ status: 'error', message: 'Not a valid email or password' });
    }
}

/* 
verify the otp and change the password
*/
exports.verifyOtpChangePassword = async(req, res) => {
    if (!req.body.user_id) {
        return res.status(400).json({ status: 'error', message: 'user_id is missing' });
    } else {
        id = req.body.user_id
    }
    if (!req.body.password) {
        return res.status(400).json({ status: 'error', message: 'password is missing' });
    } else {
        password = req.body.password
    }
    if (!req.body.otp) {
        return res.status(400).json({ status: 'error', message: 'OTP is missing' });
    } else {
        otp = req.body.otp
    }

    try {
        sql_check_otp = `SELECT id FROM users WHERE id = '${id}' AND password_change_otp = '${otp}'`
        result_check_otp = await exports.run_query(sql_check_otp)
        if (result_check_otp != '') {
            bcrypt.hash(password, 10, function(err, hash) {
                let sql_change_pswrd = "UPDATE users SET `password`='" + hash + "' WHERE id='" + id + "'";
                db.query(sql_change_pswrd, async function(error, resp) {
                    if (error) {
                        return res.status(403).json({ status: 'error', message: 'Password could not be changed, Something went wrong' });
                    }
                    let sql_remove_top = "UPDATE users SET password_change_otp = null WHERE id='" + id + "'";
                    result_remove_top = await exports.run_query(sql_remove_top)
                    return res.status(200).json({ status: 'success', message: 'Password changed successfully.' });
                });
            });
        } else {
            return res.status(200).json({ status: 'failed', message: 'OTP is not correct', data: [{ status: 'invalid' }] });
        }
    } catch (error) {
        return res.status(400).json({ status: 'error', message: 'Something went wrong', error });
    }
}

var sendMail = (email, otp) => {
    return new Promise((resolve, reject) => {
        var transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL_AUTH_USER,
                pass: process.env.EMAIL_AUTH_PASSWORD
            }
        });

        var mailOptions = {
            from: process.env.EMAIL_AUTH_USER,
            to: email,
            subject: 'OTP for the forgot password',
            text: `Your one time password.`,
            html: `<h1>Welcome to Favorito</h1><br><a>Your one time password is ${otp}</a>`
        };

        transporter.sendMail(mailOptions, function(error, info) {
            if (error) {
                reject(`Error in sending the mail ${error}`)
                console.log(`Error in sending the mail ${error}`);
            } else {
                resolve(true)
                console.log('Email sent: ' + info.response);
            }
        });
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