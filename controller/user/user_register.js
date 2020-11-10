var db = require('../../config/db');
var bcrypt = require('bcrypt');
const nodemailer = require("nodemailer");
var jwt = require('jsonwebtoken');
var uniqid = require('uniqid');

exports.register = function(req, res, next) {
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
        }

        var user_id = uniqid();
        user_id = user_id.toUpperCase();
        var full_name = req.body.full_name;
        var email = req.body.email;
        var phone = req.body.phone;
        var postal = req.body.postal_code;
        var password = req.body.password;
        var reach_whatsapp = 0;
        var term_service = 0;
        if (req.body.reach_whatsapp != '' && req.body.reach_whatsapp != null) {
            reach_whatsapp = 1;
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
                                return res.status(200).json({ status: 'success', message: 'User Registered Successfully, mail sent.', id: result.insertId, phone: phone, token: token });
                            } else {
                                return res.status(200).json({ status: 'success', message: 'User Registered Successfully, mail sending failed.', id: result.insertId, phone: phone, token: token });
                            }
                        });
                    } else {
                        return res.status(403).json({ status: 'error', message: 'Username already exist' });
                    }
                }
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

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