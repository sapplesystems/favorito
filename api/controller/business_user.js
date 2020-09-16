var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/**
 * GET BUSINESS MASTER PROFILE
 */

exports.getProfile = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(500).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.json({ status: 'error', message: 'Business id not found.' });
    } else {
        var id = req.body.id;
        var business_id = req.body.business_id;
        var sql = "SELECT id,business_id,business_name,postal_code,business_phone,landline,reach_whatsapp, \n\
        business_email,photo, address1,address2,address3,pincode,town_city,state_id,country_id,website,short_description,business_status \n\
        FROM business_master WHERE id='" + id + "' and business_id='" + business_id + "' and is_activated=1 and deleted_at is null";

        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(500).send({ status: 'error', message: 'No recored found.' });
            } else {
                var website = [];
                if (rows[0]['website'] != '' && rows[0]['website'] != null && rows[0]['website'] != 'undefined') {
                    var x = rows[0]['website'];
                    website = x.split('|_|');
                    rows[0]['website'] = website;
                }
                return res.status(200).json({ status: 'success', message: 'success', data: rows[0] });
            }
        });
    }

};

/**
 * USER LOGIN START HERE
 */
exports.login = function (req, res, next) {
    if (req.body.username == '' || req.body.username == null) {
        return res.json({ status: 'error', message: 'Business email or phone required.' });
    } else if (req.body.password == '' || req.body.password == null) {
        return res.json({ status: 'error', message: 'Password required.' });
    }
    var username = req.body.username;

    var sql = "select * from business_users where (email='" + username + "' or phone='" + username + "') and is_deleted=0 and deleted_at is null";
    db.query(sql, function (err, result) {
        if (err) {
            return res.json({ status: 'error', message: 'Something went wrong.', data: err });
        } else {
            if (result.length === 0) {
                return res.status(500).json({ status: 'error', message: 'Incorrect username or password' });
            }
            bcrypt.compare(req.body.password, result[0].password, function (err, enc_result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.', data: err });
                }
                if (enc_result == true) {
                    var token = jwt.sign({
                        email: result[0].email,
                        phone: result[0].phone,
                        id: result[0].id,
                        business_id: result[0].business_id,
                    }, 'secret', {
                        expiresIn: "1h"
                    });

                    var user_data = {
                        id: result[0].id,
                        business_id: result[0].business_id,
                        email: result[0].email,
                        phone: result[0].phone,
                    };
                    return res.json({ status: 'success', message: 'success', data: user_data, token: token });
                } else {
                    return res.status(500).json({ status: 'error', message: 'Incorrect username or password' });
                }
            });
        }
    });
};


/**
 * FETCH BUSINESS USER PROFILE INFORMATION (BUSINESS USER) START HERE
 */
exports.getBusinessOwnerProfile = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(500).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.json({ status: 'error', message: 'Business id not found.' });
    } else {
        var id = req.body.id;
        var business_id = req.body.business_id;
        var sql = "SELECT id,business_id,first_name,last_name,email,phone,`role`,bank_ac_holder_name,account_number,ifsc_code,upi \n\
        FROM business_users where business_id='" + business_id + "' and is_deleted=0 and deleted_at is null";

        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(500).send({ status: 'error', message: 'No recored found.' });
            } else {

                var bsql = "select id,branch_address,branch_contact from business_branches \n\
                where business_id='" + business_id + "' and id_deleted='0'";
                db.query(bsql, function (error, branches) {
                    rows[0].branches = branches;
                    return res.status(200).json({ status: 'success', message: 'success', data: rows[0] });
                });
            }
        });
    }

};


/**
 * BUSINESS USER PROFILE INFORMATION (BUSINESS USER) START HERE
 */
exports.updateBusinessOwnerProfile = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(500).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.json({ status: 'error', message: 'Business id not found.' });
    } else {
        var business_id = req.body.business_id;
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
            for (var x = 0; x < bid_len; x++) {
                var branchid = bid[x];
                var branch_address = req.body.branch_address[x];
                var branch_contact = req.body.branch_contact[x];
                var q = "UPDATE business_branches SET branch_address='" + branch_address + "', branch_contact='" + branch_contact + "', updated_at=NOW() WHERE id='" + branchid + "'";
                db.query(q);
            }
        }

        var sql = "update business_users set " + update_columns + " where business_id='" + business_id + "'";
        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(500).send({ status: 'error', message: 'No recored found.' });
            } else {
                return res.status(200).json({ status: 'success', message: 'Profile updated successfully.' });
            }
        });
    }

};