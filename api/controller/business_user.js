var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');
var nodemailer = require('nodemailer');


var user_role = ['Owner', 'Manager', 'Employee'];

var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

/**
 * GET BUSINESS MASTER PROFILE
 */

exports.getProfile = function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;
        var sql = "SELECT id,business_id,business_name,postal_code,business_phone,landline,reach_whatsapp, \n\
        business_email,concat('" + img_path + "',photo) as photo, address1,address2,address3,pincode,town_city,state_id,country_id, \n\
        location, by_appointment_only, working_hours, website,short_description,business_status \n\
        FROM business_master WHERE id='" + id + "' and business_id='" + business_id + "' and is_activated=1 and deleted_at is null";

        db.query(sql, function(err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(403).json({ status: 'error', message: 'No recored found.' });
            } else {
                var hours_drop_down_list = ['Select Hours', 'Always Open'];
                var website = [];
                if (rows[0]['website'] != '' && rows[0]['website'] != null && rows[0]['website'] != 'undefined') {
                    var x = rows[0]['website'];
                    website = x.split('|_|');
                    rows[0]['website'] = website;
                }
                if (rows[0]['working_hours'] === 'Select Hours') {
                    var q2 = "select id,`day`,start_hours,end_hours from business_hours \n\
                                where business_id='" + business_id + "' and deleted_at is null";
                    db.query(q2, function(error, hours) {
                        rows[0].hours = hours;
                        return res.status(200).json({ status: 'success', message: 'success', data: rows[0], hours_drop_down_list: hours_drop_down_list });
                    });
                } else {
                    return res.status(200).json({ status: 'success', message: 'success', data: rows[0], hours_drop_down_list: hours_drop_down_list });
                }
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * USER LOGIN START HERE
 */
exports.login = function(req, res, next) {
    try {
        if (req.body.username == '' || req.body.username == null) {
            return res.status(403).json({ status: 'error', message: 'Business email or phone required.' });
        } else if (req.body.password == '' || req.body.password == null) {
            return res.status(403).json({ status: 'error', message: 'Password required.' });
        }
        var username = req.body.username;

        var sql = "select * from business_master where (business_email='" + username + "' or business_phone='" + username + "')  and deleted_at is null";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
            } else {
                if (result.length === 0) {
                    return res.status(200).json({ status: 'Fail', message: 'Incorrect username or password.' });
                }
                bcrypt.compare(req.body.password, result[0].password, function(err, enc_result) {
                    if (err) {
                        return res.status(200).json({ status: 'Fail', message: 'Password not matched', data: err });
                    }
                    // change token expire here
                    if (enc_result == true) {
                        var token = jwt.sign({
                            email: result[0].email,
                            phone: result[0].phone,
                            id: result[0].id,
                            business_id: result[0].business_id,
                        }, 'secret', {
                            expiresIn: "1 day"
                        });

                        var user_data = {
                            id: result[0].id,
                            business_id: result[0].business_id,
                            email: result[0].email,
                            phone: result[0].phone,
                        };

                        // extra code for to mail the token to the Rohit sir for the testing purpose 
                        var transporter = nodemailer.createTransport({
                            service: 'gmail',
                            auth: {
                                user: 'amittullu11@gmail.com',
                                pass: '9450533280'
                            }
                        });

                        var transporter = nodemailer.createTransport({
                            service: 'gmail',
                            auth: {
                                user: 'amittullu11@gmail.com',
                                pass: '9450533280'
                            }
                        });

                        var mailOptions = {
                            from: 'amittullu11@gmail.com',
                            to: 'rohit.shukla@sapple.co.in',
                            subject: 'Token',
                            text: `
                            Token for new login is:- 
                            ${token}`
                                // html: '<h1>Hi Smartherd</h1><p>Your Messsage</p>'        
                        };

                        transporter.sendMail(mailOptions, function(error, info) {
                            if (error) {
                                console.log(error);
                            } else {
                                console.log('Email sent: ' + info.response);
                            }
                        });
                        // extra code end

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


/**
 * FETCH BUSINESS USER PROFILE INFORMATION (BUSINESS USER) START HERE
 */
exports.getBusinessOwnerProfile = function(req, res, next) {
    try {
        var id = req.userdata.id;
        var business_id = req.userdata.business_id;
        var sql = "SELECT id,business_id,first_name,last_name,email,phone,`role`,bank_ac_holder_name,account_number,ifsc_code,upi \n\
        FROM business_users where business_id='" + business_id + "' and is_deleted=0 and deleted_at is null";

        db.query(sql, function(err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(403).json({ status: 'error', message: 'No recored found.' });
            } else {

                var bsql = "SELECT id as branch_id, business_name AS branch_name, \n\
                            CONCAT(address1, ', ', address2, ', ', address3) AS branch_address, \n\
                            CONCAT('" + img_path + "', photo) AS branch_photo \n\
                            FROM business_master WHERE id \n\
                            IN( SELECT branch_id FROM business_branches \n\
                                WHERE business_id='" + business_id + "' AND is_deleted='0' AND deleted_at IS NULL)";
                db.query(bsql, function(error, branches) {
                    rows[0].branches = branches;
                    return res.status(200).json({ status: 'success', message: 'success', user_role: user_role, data: rows[0] });
                });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * SEARCH BUSINESS BRANCH TO ADD
 */
exports.searchBranch = function(req, res, next) {
    try {

        if (req.body.search_branch == '' || req.body.search_branch == 'undefined' || req.body.search_branch == null) {
            return res.status(403).json({ status: 'error', message: 'Search branch keyword not found.' });
        }

        var business_id = req.userdata.business_id;
        var search_branch = req.body.search_branch;

        var sql = "select id, business_name, concat(address1, ', ', address2, ', ', address3) as business_address, \n\
                    concat('" + img_path + "', photo) as photo from business_master where \n\
                    business_name like '%" + search_branch + "%' or address1 like '%" + search_branch + "%' or \n\
                    address2 like '%" + search_branch + "%' or address3 like '%" + search_branch + "%'";
        db.query(sql, function(err, rows) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: rows });
        });

    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * BUSINESS USER PROFILE INFORMATION (BUSINESS USER) START HERE
 */
exports.updateBusinessOwnerProfile = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var update_columns = " updated_at=now() ";
        if (req.body.first_name != '' && req.body.first_name != 'undefined' && req.body.first_name != null) {
            update_columns += ", first_name='" + req.body.first_name + "' ";
        }
        if (req.body.last_name != '' && req.body.last_name != 'undefined' && req.body.last_name != null) {
            update_columns += ", last_name='" + req.body.last_name + "' ";
        }
        if (req.body.role != '' && req.body.role != 'undefined' && req.body.role != null) {
            update_columns += ", `role`='" + req.body.role + "' ";
        }
        if (req.body.bank_ac_holder_name != '' && req.body.bank_ac_holder_name != 'undefined' && req.body.bank_ac_holder_name != null) {
            update_columns += ", bank_ac_holder_name='" + req.body.bank_ac_holder_name + "' ";
        }
        if (req.body.account_number != '' && req.body.account_number != 'undefined' && req.body.account_number != null) {
            update_columns += ", account_number='" + req.body.account_number + "' ";
        }
        if (req.body.ifsc_code != '' && req.body.ifsc_code != 'undefined' && req.body.ifsc_code != null) {
            update_columns += ", ifsc_code='" + req.body.ifsc_code + "' ";
        }
        if (req.body.upi != '' && req.body.upi != 'undefined' && req.body.upi != null) {
            update_columns += ", upi='" + req.body.upi + "' ";
        }

        var bid = req.body.bid;
        if (bid && bid != 'undefined') {
            var bid_len = bid.length;
            var dq = "UPDATE business_branches SET is_deleted='1', deleted_at=NOW() WHERE business_id='" + business_id + "'";
            db.query(dq, function(e, r) {
                for (var x = 0; x < bid_len; x++) {
                    var branchid = bid[x];
                    //var branch_address = req.body.branch_address[x];
                    //var branch_contact = req.body.branch_contact[x];
                    var q = "INSERT INTO business_branches (business_id, branch_id) VALUES('" + business_id + "','" + branchid + "')";
                    db.query(q);
                }
            });
        }

        var sql = "update business_users set " + update_columns + " where business_id='" + business_id + "'";
        db.query(sql, function(err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(403).json({ status: 'error', message: 'No recored found.' });
            } else {
                return res.status(200).json({ status: 'success', message: 'Profile updated successfully.' });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' + e });
    }
};

/**
 * BUSINESS OWNER PROFILE ADD ANOTHER BRANCH
 */
exports.addAnotherBranch = function(req, res, next) {
    try {
        if (req.body.branch_address == '' || req.body.branch_address == 'undefined' || req.body.branch_address == null) {
            return res.status(403).json({ status: 'error', message: 'Branch address not found' });
        } else if (req.body.branch_contact == '' || req.body.branch_contact == 'undefined' || req.body.branch_contact == null) {
            return res.status(403).json({ status: 'error', message: 'Branch contact not found.' });
        }
        var business_id = req.userdata.business_id;
        var b_addr = req.body.branch_address;
        var b_addr_len = b_addr.length;
        for (var x = 0; x < b_addr_len; x++) {
            var branch_address = req.body.branch_address[x];
            var branch_contact = req.body.branch_contact[x];
            var q = "insert into business_branches (business_id,branch_address,branch_contact) values('" + business_id + "','" + branch_address + "','" + branch_contact + "')";
            db.query(q);
        }
        return res.status(200).json({ status: 'success', message: 'Branch added successfully' });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getProfilePhoto = function(req, res, next) {
    if (req.userdata.business_id) {
        var sql = "SELECT CONCAT('" + img_path + "',photo) as photo FROM business_master WHERE business_id = '" + req.userdata.business_id + "' AND deleted_at IS NULL"
            // var sql = "SELECT * FROM business_master WHERE business_id = '" + req.userdata.business_id + "'AND deleted_at IS NULL"
        try {
            db.query(sql, function(error, result) {
                if (error) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: error });
                }
                return res.status(200).json({ status: 'success', message: ' result successfully', result: result });
            })
        } catch (error) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
        }

    }
}

exports.getRegisteredEmailMobile = function(req, res, next) {
    if (req.userdata.business_id) {
        var sql = "SELECT business_email, business_phone, is_email_verified, is_phone_verified FROM business_master WHERE business_id = '" + req.userdata.business_id + "' AND deleted_at IS NULL"
        try {
            db.query(sql, function(error, result) {
                if (error) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: error });
                }
                return res.status(200).json({ status: 'success', message: ' result successfully', result: result });
            })
        } catch (error) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
        }

    }
}

// exports.getRoomId = async function(req, res, next) {

//     if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
//         var source_id = req.userdata.business_id;
//     } else if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
//         var source_id = req.userdata.id;
//     }

//     if (req.body.target_id != null && req.body.target_id != undefined && req.body.target_id != '') {
//         target_id = req.body.target_id
//     } else {
//         return res.status(400).json({ status: 'error', message: 'target_id is missing' });
//     }

//     sql_exist_room_id = `SELECT room_id from business_chat_messages where source_id = '${}'`

//     sql_new_get_room_id = `SELECT MAX(room_id) as room_id FROM business_chat_messages`
//     result_get_room_id = await exports.run_query(sql_new_get_room_id)
//     return res.send()
//         // if (result_get_room_id[0].room_id == null) {
//         //     room_id = 1
//         // } else {
//         //     room_id = result_get_room_id[0].room_id + 1
//         // }
//         // return res.send({ t: room_id })

//     // return res.send({ user_id, business_id })
// }

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