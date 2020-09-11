var db = require('../config/db');
var bcrypt = require('bcrypt');
const nodemailer = require("nodemailer");
var jwt = require('jsonwebtoken');
var uniqid = require('uniqid');

exports.register = function (req, res, next) {
    if (req.body.business_type_id == '' || req.body.business_type_id == null) {
        return res.status(500).json({ status: 'error', message: 'Business type is required' });
    } else if (req.body.business_category_id == '' || req.body.business_category_id == null) {
        return res.status(500).json({ status: 'error', message: 'Business category is required' });
    } else if (req.body.business_name == '' || req.body.business_name == null) {
        return res.status(500).json({ status: 'error', message: 'Business name is required' });
    } else if (req.body.postal_code == '' || req.body.postal_code == null) {
        return res.status(500).json({ status: 'error', message: 'Postal code is required' });
    } if (req.body.business_phone == '' || req.body.business_phone == null) {
        return res.status(500).json({ status: 'error', message: 'Business phone is required' });
    } else if (req.body.business_email == '' || req.body.business_email == null) {
        return res.status(500).json({ status: 'error', message: 'Business Email is required' });
    } else if (req.body.password == '' || req.body.password == null) {
        return res.status(500).json({ status: 'error', message: 'Password is required' });
    } else if (req.body.cpassword == '' || req.body.cpassword == null) {
        return res.status(500).json({ status: 'error', message: 'Confirm password is required' });
    }

    var business_id = uniqid();
    business_id = business_id.toUpperCase();
    var business_type_id = req.body.business_type_id;
    var business_category_id = req.body.business_category_id;
    var business_name = req.body.business_name;
    var postal_code = req.body.postal_code;
    var business_phone = req.body.business_phone;
    var business_email = req.body.business_email;
    var password = req.body.password;
    var cpassword = req.body.cpassword;
    var reach_whatsapp = 0;
    if (req.body.reach_whatsapp != '' && req.body.reach_whatsapp != null) {
        reach_whatsapp = 1;
    }

    if (password !== cpassword) {
        return res.status(500).json({ status: 'error', message: 'Passwrod and confirm password does not match' });
    }

    bcrypt.hash(password, 10, function (err, hash) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Password encryption failed' });
        }
        var cslq = "select count(*) as c from business_users where (business_email='" + business_email + "' or business_phone='" + business_phone + "') and is_activated=1 and deleted_at is null";
        db.query(cslq, function (chkerr, check) {
            if (chkerr) {
                return res.json({ status: 'error', message: 'Something went wrong.' });
            } else {
                if (check[0].c === 0) {
                    var sql = "INSERT INTO business_users (business_id, business_type_id, business_category_id, business_name, postal_code, business_phone, reach_whatsapp, business_email, password, org_password) values('" + business_id + "','" + business_type_id + "','" + business_category_id + "','" + business_name + "','" + postal_code + "','" + business_phone + "','" + reach_whatsapp + "','" + business_email + "','" + hash + "','" + password + "')";
                    db.query(sql, function (err, result) {
                        if (err) {
                            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                        }

                        /**insert row into business_informations table */
                        var bi_sql = "INSERT INTO business_informations (business_user_id, business_id) VALUES ('" + result.insertId + "', '" + business_id + "')";
                        db.query(bi_sql, function (bierr, biresult) {
                            if (bierr) throw bierr;
                        });

                        /**insert row into business_owner_profile table */
                        var bop_sql = "INSERT INTO business_owner_profile (business_user_id, business_id) VALUES ('" + result.insertId + "', '" + business_id + "')";
                        db.query(bop_sql, function (boperr, bopresult) {
                            if (boperr) throw boperr;
                        });


                        var token = jwt.sign({
                            business_email: business_email,
                            business_phone: business_phone,
                            id: result.insertId,
                            business_id: business_id,
                        }, 'secret', {
                            expiresIn: "1h"
                        });

                        var messageId = main(res, result.insertId, result).catch(console.error);
                        if (messageId) {
                            return res.status(200).json({ status: 'success', message: 'User Registered Successfully, mail sent.', id: result.insertId, business_email: business_email, business_phone: business_phone, token: token });
                        } else {
                            return res.status(200).json({ status: 'success', message: 'User Registered Successfully, mail sending failed.', id: result.insertId, business_email: business_email, business_phone: business_phone, token: token });
                        }
                    });
                } else {
                    return res.status(500).json({ status: 'error', message: 'Username already exist' });
                }
            }
        });
    });
};

// async..await is not allowed in global scope, must use a wrapper
async function main() {
    // Generate test SMTP service account from ethereal.email
    // Only needed if you don't have a real mail account for testing
    let testAccount = await nodemailer.createTestAccount();

    // create reusable transporter object using the default SMTP transport
    let transporter = nodemailer.createTransport({
        host: "smtp.ethereal.email",
        port: 587,
        secure: false, // true for 465, false for other ports
        auth: {
            user: testAccount.user, // generated ethereal user
            pass: testAccount.pass, // generated ethereal password
        },
    });

    // send mail with defined transport object
    let info = await transporter.sendMail({
        from: '"Fred Foo 👻" <foo@example.com>', // sender address
        to: "bar@example.com, baz@example.com", // list of receivers
        subject: "Hello ✔", // Subject line
        text: "Hello world?", // plain text body
        html: "<b>Hello world?</b>", // html body
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