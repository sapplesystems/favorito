var db = require('../config/db');
var jwt = require('jsonwebtoken');
var nodemailer = require('nodemailer');
const fast2sms = require('fast-two-sms');
var full_url = process.env.BASE_URL + ':' + process.env.APP_PORT;

var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

/*CREATE BUSINESS CATEGORY*/
exports.addClaim = async function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        var claim_count = await checkClaimCount(business_id);

        if (claim_count >= 3) {
            return res.status(200).json({ status: 'fail', message: 'You can not claim to this business as you have already claimed more than ' + claim_count + ' times.' });
        }

        var postval = { business_id: business_id };

        if (req.body.phone != '' && req.body.phone != 'undefined' && req.body.phone != null) {
            postval.phone = req.body.phone;
        }
        if (req.body.email != '' && req.body.email != 'undefined' && req.body.email != null) {
            postval.email = req.body.email;
        }

        var sql = "INSERT INTO business_claim SET ?";
        db.query(sql, postval, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            if (req.files && req.files.length) {
                var file_count = req.files.length;
                for (var i = 0; i < file_count; i++) {
                    var filename = req.files[i].filename;
                    var sql = "INSERT INTO `business_claim_upload`(business_id, document) VALUES ('" + business_id + "','" + filename + "')";
                    db.query(sql);
                }
            }
            return res.status(200).json({ status: 'success', message: 'Claimed successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' + e });
    }
};

/**
 * BUSINESS CATALOG ADD PHOTO
 */
exports.addClaimPhotos = async function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;

        var claim_count = await checkClaimCount(business_id);

        if (claim_count >= 3) {
            return res.status(403).json({ status: 'error', message: 'You can not claim to this business as you have already claimed ' + claim_count + ' times.' });
        }

        if (req.files && req.files.length) {
            var file_count = req.files.length;
            for (var i = 0; i < file_count; i++) {
                var filename = req.files[i].filename;
                var sql = "INSERT INTO `business_claim_upload`(business_id, document) VALUES ('" + business_id + "','" + filename + "')";
                db.query(sql);
            }
            return res.status(200).json({ status: 'success', message: 'Photo uploaded successfully.' });
        } else {
            return res.status(200).json({ status: 'success', message: 'No photo found to upload.' });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getClaim = async function(req, res, next) {
    business_id = await req.userdata.business_id;
    try {
        var sql = 'SELECT business_phone, business_email, is_phone_verified,is_email_verified FROM business_master WHERE business_id="' + business_id + '"'
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            if (result.is_phone_verified == null || result.is_email_verified == null) {
                return res.status(500).json({ status: 'error', message: 'Either email or phone is not found' });
            }
            return res.status(200).send({ status: 'success', message: 'respone successfull', data: result[0] })
        })
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

/**
 * CHECK TOTAL CLAIM COUNT
 */
function checkClaimCount(business_id) {
    return new Promise(function(resolve, reject) {
        var sql = "select count(*) as c from business_claim where business_id='" + business_id + "'";
        db.query(sql, function(err, result) {
            resolve(result[0].c);
        });
    });
}

exports.sendEmailVerifyLink = function(req, res, next) {
    if (req.userdata.business_id == '' || req.userdata.email == '') {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }

    var token = jwt.sign({
        business_id: req.userdata.business_id,
        email: req.userdata.email
    }, 'email_validation_secret', {
        expiresIn: process.env.EMAIL_VALIDATION_VALIDITY
    });

    var transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL_AUTH_USER,
            pass: process.env.EMAIL_AUTH_PASSWORD
        }
    });

    var mailOptions = {
        from: process.env.EMAIL_AUTH_USER,
        to: req.userdata.email,
        subject: 'Verification link',
        text: `Verification link`,
        html: `<h1>Welcome</p><br><a href="${full_url}/api/business-claim/let-me-verify/${token}">Click here to verify the Email</a>`
    };

    transporter.sendMail(mailOptions, function(error, info) {
        if (error) {
            console.log(`Error in sending the mail ${error}`);
        } else {
            console.log('Email sent: ' + info.response);
            res.status(200).send({ status: "success", message: "email sent" })
        }
    });
}

exports.verifyEmailLink = async function(req, res, next) {
    try {
        var verified_data = jwt.verify(req.params.token, 'email_validation_secret');
    } catch (error) {
        res.status(404).json({
            error: 'Invalid token'
        });
    }
    try {
        var sql = "UPDATE business_master SET is_email_verified='1' WHERE business_id='" + verified_data.business_id + "'";
        var result = await exports.run_query(sql)
        var sql_is_phone_verify = `SELECT is_phone_verified from business_master where business_id = '${verified_data.business_id}'`
        var result_is_phone_verify = await exports.run_query(sql_is_phone_verify)
        if (result_is_phone_verify[0].is_phone_verified) {
            var sql_update_is_verify = `UPDATE business_master set is_verified = 1 where business_id = '${verified_data.business_id}'`
            var result_update_is_verify = await exports.run_query(sql_update_is_verify)
        }
        sql_check_all_verified = `SELECT is_verified,is_information_completed,is_profile_completed from business_master where business_id='${verified_data.business_id}'`
        result_check_all_verified = await exports.run_query(sql_check_all_verified)
        if (result_check_all_verified[0].is_verified && result_check_all_verified[0].is_information_completed && result_check_all_verified[0].is_profile_completed) {
            sql_update_is_activated = `UPDATE business_master set is_activated = 1 where business_id = '${verified_data.business_id}'`
            result_update_is_activated = await exports.run_query(sql_update_is_activated)
        }
        return res.status(301).redirect("https://www.sapple.co.in")

    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

exports.sendVerifyOtp = async function(req, res, next) {
    try {
        var otp = Math.floor(Math.random() * 90000) + 10000;
        if (req.body.mobile) {
            if (exports.sendSms(req.body.mobile, otp)) {
                var sql = "UPDATE business_master SET phone_otp='" + otp + "' WHERE business_id='" + req.userdata.business_id + "'";
                db.query(sql, function(err, result) {
                    if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                    }
                    return res.status(200).send({ status: 'success', message: 'OTP sent successfully' })
                })
            } else {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' })
            }
        } else {
            return res.status(400).json({ status: 'error', message: 'Mobile number is missing.' })
        }
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

exports.verifyOtp = async function(req, res, next) {
    if (req.body.otp == null || req.body.otp == '' || req.body.otp == undefined) {
        return res.status(400).json({ status: 'error', message: 'OTP is require' })
    } else {
        try {
            otp_from_db = await exports.getOtpFromDb(req.userdata.business_id)
            if (req.body.otp == otp_from_db[0].phone_otp) {
                var sql = "UPDATE business_master SET is_phone_verified='1' WHERE business_id='" + req.userdata.business_id + "'";
                var result = await exports.run_query(sql)
                var sql_check_is_email_verified = `SELECT is_email_verified from business_master where business_id = '${req.userdata.business_id}'`
                var result_check_is_email_verified = await exports.run_query(sql_check_is_email_verified)
                if (result_check_is_email_verified[0].is_email_verified == '1') {
                    sql_update_is_verified = `UPDATE business_master set is_verified = 1 where business_id = '${req.userdata.business_id}'`
                    result_update_is_verified = await exports.run_query(sql_update_is_verified)
                }
                let sql_check_all_verified = `SELECT is_verified, is_information_completed, is_profile_completed where business_id = '${ req.userdata.business_id}'`
                let result_check_all_verified = await exports.run_query(sql_check_all_verified)
                if (result_check_all_verified[0].is_verified && result_check_all_verified[0].is_information_completed && result_check_all_verified[0].is_profile_completed) {
                    sql_update_is_activated = `UPDATE business_master set is_activated = 1 where business_id = '${req.userdata.business_id}'`
                    result_update_is_activated = await exports.run_query(sql_update_is_activated)
                }
                return res.status(200).send({ status: 'success', message: 'phone is verified' })
            } else {
                return res.status(200).json({ status: 'fail', message: 'OTP is incorrect' })
            }

        } catch (error) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' })
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

exports.getOtpFromDb = function(business_id) {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT phone_otp FROM business_master WHERE business_id='" + business_id + "'";
        db.query(sql, function(err, result) {
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