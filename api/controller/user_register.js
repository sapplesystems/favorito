var db = require('../config/db');
var bcrypt = require('bcrypt');
const nodemailer = require("nodemailer");
var jwt = require('jsonwebtoken');

exports.register = function (req, res, next) {
    if (req.body.business_type == '' || req.body.business_type == null) {
        return res.status(500).json({ status: 'error', message: 'Business type is required' });
    } else if (req.body.business_category == '' || req.body.business_category == null) {
        return res.status(500).json({ status: 'error', message: 'Business category is required' });
    } else if (req.body.business_name == '' || req.body.business_name == null) {
        return res.status(500).json({ status: 'error', message: 'Business name is required' });
    } else if (req.body.postal_code == '' || req.body.postal_code == null) {
        return res.status(500).json({ status: 'error', message: 'Postal code is required' });
    } if (req.body.business_phone == '' || req.body.business_phone == null) {
        return res.status(500).json({ status: 'error', message: 'Business phone is required' });
    } else if (req.body.username == '' || req.body.username == null) {
        return res.status(500).json({ status: 'error', message: 'Username is required' });
    } else if (req.body.email == '' || req.body.email == null) {
        return res.status(500).json({ status: 'error', message: 'Email is required' });
    } else if (req.body.password == '' || req.body.password == null) {
        return res.status(500).json({ status: 'error', message: 'Password is required' });
    } else if (req.body.cpassword == '' || req.body.cpassword == null) {
        return res.status(500).json({ status: 'error', message: 'Confirm password is required' });
    }
    var business_type = req.body.business_type;
    var business_category = req.body.business_category;
    var business_name = req.body.business_name;
    var postal_code = req.body.postal_code;
    var business_phone = req.body.business_phone;
    var username = req.body.username;
    var email = req.body.email;
    var password = req.body.password;
    var cpassword = req.body.cpassword;

    if (password !== cpassword) {
        return res.status(500).json({ status: 'error', message: 'Passwrod and confirm password does not match' });
    }

    bcrypt.hash(password, 10, function (err, hash) {
        if (err) {
            return res.status(500).json({ status: 'error', message: 'Password encryption failed' });
        }
        var cslq = "select count(*) as c from users where username='" + username + "' and deleted_at is null";
        db.query(cslq, function (chkerr, check) {
            if (chkerr) {
                return res.json({ status: 'error', message: 'Something went wrong.' });
            } else {
                if(check[0].c === 0){
                    var sql = "INSERT INTO users (business_type, business_category, business_name, postal_code, business_phone, username, email, password, org_password) values('" + business_type + "','" + business_category + "','" + business_name + "','" + postal_code + "','" + business_phone + "','" + username + "','" + email + "','" + hash + "','" + password + "')";
                    db.query(sql, function (err, result) {
                        if (err) {
                            return res.status(500).json({ status: 'error', message: 'Something went wrong.'});
                        }
                        var token = jwt.sign({
                            username: username,
                            id: result.insertId,
                        }, 'secret', {
                            expiresIn: "1h"
                        });
    
                        var messageId = main(res, result.insertId, result).catch(console.error);
                        if (messageId) {
                            return res.status(200).json({ status: 'success', message: 'User Registered Successfully, mail sent.', id: result.insertId, username: username, token: token });
                        } else {
                            return res.status(200).json({ status: 'success', message: 'User Registered Successfully, mail sending failed.', id: result.insertId, username: username, token: token });
                        }
                    });
                }else{
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