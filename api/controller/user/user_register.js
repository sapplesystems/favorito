var db = require('../../config/db');
var bcrypt = require('bcrypt');
const nodemailer = require("nodemailer");
var jwt = require('jsonwebtoken');
var uniqid = require('uniqid');
var full_url = process.env.BASE_URL + ':' + process.env.APP_PORT;
const fast2sms = require('fast-two-sms');


exports.register = async function(req, res, next) {
    try {
        if (req.body.full_name == '' || req.body.full_name == 'undefined' || req.body.full_name == null) {
            return res.status(403).json({ status: 'error', message: 'Name is required' });
        } else if (req.body.email == '' || req.body.email == 'undefined' || req.body.email == null) {
            return res.status(403).json({ status: 'error', message: 'Email is required' });
        } else if (req.body.phone == '' || req.body.phone == 'undefined' || req.body.phone == null) {
            return res.status(403).json({ status: 'error', message: 'Phone is required' });
        } else if (req.body.postal_code == '' || req.body.postal_code == 'undefined' || req.body.postal_code == null) {
            return res.status(403).json({ status: 'error', message: 'Postal code is required' });
        } else if (req.body.password == '' || req.body.password == null) {
            return res.status(403).json({ status: 'error', message: 'Password is required' });
        } else if (req.body.profile_id == '' || req.body.profile_id == null) {
            return res.status(403).json({ status: 'error', message: 'profile_id is required' });
        }
        if (req.body.short_description != '' && req.body.short_description != null) {
            short_description = req.body.short_description
        } else {
            short_description = ''
        }

        if (req.body.profile_id) {
            try {
                sql_check_profile_exist = `SELECT COUNT(id) as count FROM users WHERE profile_id = '${req.body.profile_id}'`
                result_check_profile_exist = await exports.run_query(sql_check_profile_exist)
                if (result_check_profile_exist[0].count > 0) {
                    return res.status(200).json({ status: 'success', message: 'This profile id is already exist' });
                }
            } catch (error) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
            }
        }

        var user_id = uniqid();
        user_id = user_id.toUpperCase();
        var full_name = req.body.full_name;
        var email = req.body.email;
        var phone = req.body.phone;
        var postal = req.body.postal_code;
        var password = req.body.password;
        var term_service = 0;
        if (req.body.reach_whatsapp != '' && req.body.reach_whatsapp != null) {
            reach_whatsapp = req.body.reach_whatsapp;
        } else {
            reach_whatsapp = 0;
        }
        if (req.body.term_service != '' && req.body.term_service != null) {
            term_service = 1;
        }
        full_name = full_name.trim();
        var split_name = full_name.split(' ');
        var first_name = split_name[0];
        var last_name = '';
        if (split_name.length > 0) {
            split_name.shift();
            last_name = split_name.join(' ');;
        }


        bcrypt.hash(password, 10, function(err, hash) {
            if (err) {
                return res.status(403).json({ status: 'error', message: 'Password encryption failed' });
            }
            var cslq = "select count(*) as c from users where (email='" + email + "' or phone='" + phone + "') and deleted_at is null";
            db.query(cslq, function(chkerr, check) {
                if (chkerr) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                } else {
                    if (check[0].c === 0) {
                        var postval = {
                            full_name: full_name,
                            first_name: first_name,
                            last_name: last_name,
                            email: email,
                            phone: phone,
                            postal: postal,
                            password: hash,
                            short_description: short_description,
                            reach_whatsapp: reach_whatsapp,
                            profile_id: req.body.profile_id,
                            org_password: password
                        };

                        var sql = "INSERT INTO users SET ?";
                        db.query(sql, postval, function(err, result) {
                            if (err) {
                                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                            }
                            var token = jwt.sign({
                                email: email,
                                phone: phone,
                            }, 'secret', {
                                expiresIn: "2 days"
                            });

                            var messageId = mail(res, result.insertId, result, email).catch(console.error);
                            if (messageId) {
                                return res.status(200).json({ status: 'success', message: 'User Registered Successfully, mail sent.', id: result.insertId, phone: phone });
                            } else {
                                return res.status(200).json({ status: 'success', message: 'User Registered Successfully, mail sending failed.', id: result.insertId, phone: phone });
                            }
                        });
                    } else {
                        return res.status(403).json({ status: 'error', message: 'Username already exist.' });
                    }
                }
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.isProfileExist = async(req, res, next) => {
    if (req.body.profile_id) {
        sql_check = `SELECT COUNT(id) AS count FROM users WHERE profile_id = '${req.body.profile_id}'`
        result_sql_check = await exports.run_query(sql_check)
        if (result_sql_check[0].count > 0) {
            return res.status(200).json({ status: 'success', message: 'This profile id is already exist, please use another one', data: [{ is_exist: 1 }] });
        } else {
            return res.status(200).json({ status: 'success', message: 'Available', data: [{ is_exist: 0 }] });
        }
    } else {
        return res.status(403).json({ status: 'error', message: 'Profile id is missing' });
    }
}

exports.isAccountExist = async(req, res) => {
    if (!req.body.api_type) {
        return res.status(400).json({ status: 'error', message: 'api_type is missing either mobile or email' });
    }
    if (req.body.api_type == 'mobile') {
        if (!req.body.mobile) {
            return res.status(400).json({ status: 'error', message: 'Mobile number is missing' });
        } else {
            sql_mobile_check = `SELECT id FROM users WHERE phone = '${req.body.mobile}'`
            result_mobile_check = await exports.run_query(sql_mobile_check)
            if (result_mobile_check == '') {
                return res.status(200).json({ status: 'success', message: 'This mobile number is available', data: [{ is_exist: 0 }] });
            } else {
                return res.status(200).json({ status: 'success', message: 'Already exist', data: [{ is_exist: 1 }] });
            }
        }
    }
    if (req.body.api_type == 'email') {
        if (!req.body.email) {
            return res.status(400).json({ status: 'error', message: 'email number is missing' });
        } else {
            sql_email_check = `SELECT id FROM users WHERE email = '${req.body.email}'`
            result_email_check = await exports.run_query(sql_email_check)
            if (result_email_check == '') {
                return res.status(200).json({ status: 'success', message: 'This email is available', data: [{ is_exist: 0 }] });
            } else {
                return res.status(200).json({ status: 'success', message: 'Already exist', data: [{ is_exist: 1 }] });
            }
        }
    }
}


// async..await is not allowed in global scope, must use a wrapper
async function mail(p1, insertId, p3, email) {

    // Generate test SMTP service account from ethereal.email
    // Only needed if you don't have a real mail account for testing
    let testAccount = await nodemailer.createTestAccount();

    // create reusable transporter object using the default SMTP transport
    // let transporter = nodemailer.createTransport({
    //     host: "smtp.ethereal.email",
    //     port: 587,
    //     secure: false, // true for 465, false for other ports
    //     auth: {
    //         user: testAccount.user, // generated ethereal user
    //         pass: testAccount.pass, // generated ethereal password
    //     },

    let transporter = nodemailer.createTransport({
        service: process.env.EMAIL_SERVICE,
        auth: {
            user: process.env.EMAIL_AUTH_USER,
            pass: process.env.EMAIL_AUTH_PASSWORD
        }
    });

    // send mail with defined transport object
    let info = await transporter.sendMail({
        from: process.env.EMAIL_FROM,
        to: email,
        subject: 'Thankyou for this registration',
        text: `
        Hi ,
        Greetings of the day.

        We welcome you on our portal.
        Thank you for chosing this task app.
        Please feel free to contact in case of any query.
        
        Thanks and regards
        Sapple favorito
        `
    });

    console.log("Message sent: %s", info.messageId);
    console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));

    return info.messageId;

    /*if (info.messageId) {
        return res.status(200).json({ status: 'success', message: 'mail sent success', id: last_inserted_id, data: result_data });
    } else {
        return res.status(500).json({ status: 'error', message: 'mail sending failed' });
    }

    console.log("Message sent: %s", info.messageId);
    // Message sent: <b658f8ca-6296-ccf4-8306-87d57a0b4321@example.com>

    // Preview only available when sending through an Ethereal account
    console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));
    // Preview URL: https://ethereal.email/message/WaQKMgKddxQDoou...*/
}

exports.sendEmailVerifyLink = function(req, res, next) {
    if (req.userdata.id == '' || req.userdata.email == '') {
        res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }

    var token = jwt.sign({
        id: req.userdata.id,
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
        html: `<h1>Welcome</p><br><a href="${full_url}/api/user/let-me-verify/${token}">Click here to verify the Email</a>`
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
    // return res.send('hello')
    try {
        var verified_data = jwt.verify(req.params.token, 'email_validation_secret');
    } catch (error) {
        res.status(404).json({
            error: 'Invalid token'
        });
    }
    try {
        var sql = "UPDATE users SET is_email_verify='1' WHERE id='" + verified_data.id + "'";
        var result = await exports.run_query(sql)
        return res.status(200).send("Email is verified")
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' })
    }
}

exports.sendVerifyOtp = async function(req, res, next) {
    try {
        var otp = Math.floor(Math.random() * 90000) + 10000;
        if (req.body.mobile != req.userdata.phone) {
            return res.status(200).json({ status: 'Failed', message: 'Please enter the registered mobile number.' })
        }
        if (req.body.mobile) {
            if (exports.sendSms(req.body.mobile, otp)) {
                var sql = "UPDATE users SET sms_otp='" + otp + "' WHERE id='" + req.userdata.id + "'";
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
            otp_from_db = await exports.getOtpFromDb(req.userdata.id)
            if (req.body.otp == otp_from_db[0].sms_otp) {
                var sql = "UPDATE users SET is_phone_verify='1' WHERE id='" + req.userdata.id + "'";
                try {
                    var result = await exports.run_query(sql)
                    var sql_delete_otp = "UPDATE users SET sms_otp=null WHERE id='" + req.userdata.id + "'";
                    var result_delete_otp = await exports.run_query(sql_delete_otp)
                    return res.status(200).send({ status: 'success', message: 'phone is verified' })
                } catch (error) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' })
                }
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

exports.getOtpFromDb = function(id) {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT sms_otp FROM users WHERE id='" + id + "'";
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