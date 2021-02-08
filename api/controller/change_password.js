var db = require('../config/db');
var bcrypt = require('bcrypt');
var nodemailer = require('nodemailer');


exports.updatePassword = (req, res, next) => {
    if (req.body.business_id == null || req.body.business_id == undefined || req.body.business_id == '') {
        return res.status(500).json({ status: 'error', message: 'business_id is missing' });
    }
    if (req.body.new_password == null || req.body.new_password == undefined || req.body.new_password == '') {
        return res.status(500).json({ status: 'error', message: 'new_password is missing' });
    }

    bcrypt.hash(req.body.new_password, 10, async function(err, hash) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Somthing went wrong' });
        } else {
            sql_update_password = `UPDATE business_master SET password = '${hash}', updated_at = NOW() WHERE business_id = '${req.body.business_id}'`
            try {
                result = await exports.run_query(sql_update_password)
                if (result.affectedRows > 0) {
                    return res.status(200).json({ status: 'success', message: 'Password is updated' });
                }
            } catch (error) {
                return res.status(500).json({ status: 'error', message: 'Somthing went wrong', error });
            }
        }
    })

}

exports.changePassword = function(req, res, next) {
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
            var sql = "select * from business_users where business_id='" + req.userdata.business_id + "' and is_deleted=0 and deleted_at is null";
            db.query(sql, function(err, result) {
                if (err) {
                    return res.json({ status: 'error', message: 'Something went wrong.', data: err });
                } else {
                    if (result.length === 0) {
                        return res.status(403).json({ status: 'error', message: 'Incorrect business id' });
                    }
                    bcrypt.compare(req.body.old_password, result[0].password, function(err, enc_result) {
                        if (err) {
                            return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
                        } else if (enc_result === false) {
                            return res.status(403).json({ status: 'error', message: 'Old pssword does not match.', data: err });
                        } else {
                            bcrypt.hash(req.body.new_password, 10, function(err, hash) {
                                var uq = "UPDATE business_users SET `password`='" + hash + "', org_password='" + req.body.new_password + "' WHERE business_id='" + req.userdata.business_id + "'";
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
};

/*
Check req is email or phone number accordingly it sends the OTP
And save the OTP in the database in order to check later in the verify OTP 
 */
exports.sendOtpOnEmail = async(req, res, next) => {
    if (!req.body.email_or_phone) {
        return res.status(400).json({ status: 'error', message: 'Email id or Phone number is missing' });
    }

    //  regex of email check
    if (/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(req.body.email_or_phone)) {
        let email = req.body.email_or_phone
        sql_is_email_exist = `SELECT business_id FROM business_master WHERE business_email = '${email}'`

        result_is_email_exist = await exports.run_query(sql_is_email_exist)
        if (result_is_email_exist != '') {
            business_id = result_is_email_exist[0].business_id
        }
        if (result_is_email_exist == '') {
            return res.status(200).json({ status: 'success', message: 'Your business email is invalid , please try again with correct email id .' });
        }

        let otp = Math.floor(Math.random() * 90000) + 10000;
        try {
            is_mail_sent = await sendMail(email, otp)
            if (is_mail_sent) {
                sql_insert_otp = `UPDATE business_master SET email_otp = '${otp}' WHERE business_id = '${business_id}'`
                result_insert_otp = await exports.run_query(sql_insert_otp)
                return res.status(200).json({ status: 'success', message: 'Email is sent with OTP', data: [{ busines_id: business_id }] });
            }
        } catch (error) {
            return res.status(500).json({ status: 'failed', message: 'Email cannot be sent due to some issue.', error });
        }

    } else if (Number.isInteger(req.body.email_or_phone)) {
        return res.send({ t: 'phone' })
    } else {
        return res.status(400).json({ status: 'error', message: 'Not a valid email or password' });
    }
}

/* 
verify the otp and change the password
*/
exports.verifyOtpChangePassword = async(req, res) => {
    if (!req.body.business_id) {
        return res.status(400).json({ status: 'error', message: 'business_id is missing' });
    } else {
        business_id = req.body.business_id
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
        sql_check_otp = `SELECT id FROM business_master WHERE business_id = '${business_id}' AND email_otp = '${otp}'`
        result_check_otp = await exports.run_query(sql_check_otp)
        if (result_check_otp != '') {
            bcrypt.hash(password, 10, function(err, hash) {
                let sql_change_pswrd = "UPDATE business_master SET `password`='" + hash + "' WHERE business_id='" + business_id + "'";
                db.query(sql_change_pswrd, function(error, resp) {
                    if (error) {
                        return res.status(403).json({ status: 'error', message: 'Password could not be changed, Something went wrong' });
                    }
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