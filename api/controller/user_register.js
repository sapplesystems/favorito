var db = require('../config/db');
var bcrypt = require('bcrypt');
const nodemailer = require("nodemailer");

exports.register = function (req, res, next) {
    if (req.body.username == '' || req.body.username == null) {
        res.status(500).json({ status: 'error', message: 'username', data: 'Param required' });
    } else if (req.body.email == '' || req.body.email == null) {
        res.status(500).json({ status: 'error', message: 'email', data: 'Param required' });
    } else if (req.body.password == '' || req.body.password == null) {
        res.status(500).json({ status: 'error', message: 'password', data: 'Param required' });
    } else if (req.body.cpassword == '' || req.body.cpassword == null) {
        res.status(500).json({ status: 'error', message: 'cpassword', data: 'Param required' });
    }
    var username = req.body.username;
    var email = req.body.email;
    var password = req.body.password;
    var cpassword = req.body.cpassword;

    if (password !== cpassword) {
        res.status(500).json({ status: 'error', message: 'error', data: 'Confirm password does not match' });
    }

    bcrypt.hash(password, 10, function (err, hash) {
        if (err) {
            res.status(500).json({ status: 'error', message: err, data: 'Password encryption failed' });
        }
        var sql = "INSERT INTO users (username, email, password, org_password) values('" + username + "','" + email + "','" + hash + "','" + password + "')";
        db.query(sql, function (err, result) {
            if (err) {
                res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            }
            main(res, result.insertId, result).catch(console.error);
            //res.status(200).json({ status: 'success', message: 'success', id: result.insertId, data: result });
        });
    });
};

// async..await is not allowed in global scope, must use a wrapper
async function main(res, last_inserted_id, result_data) {
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

    if (info.messageId) {
        return res.status(200).json({ status: 'success', message: 'mail sent success', id: last_inserted_id, data: result_data });
    } else {
        return res.status(500).json({ status: 'error', message: 'mail sending failed' });
    }

    console.log("Message sent: %s", info.messageId);
    // Message sent: <b658f8ca-6296-ccf4-8306-87d57a0b4321@example.com>

    // Preview only available when sending through an Ethereal account
    console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));
    // Preview URL: https://ethereal.email/message/WaQKMgKddxQDoou...
}