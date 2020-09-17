var db = require('../config/db');
var bcrypt = require('bcrypt');
var jwt = require('jsonwebtoken');

/**
 * GET BUSINESS MASTER PROFILE
 */

exports.getProfile = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(404).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.status(404)({ status: 'error', message: 'Business id not found.' });
    } else {
        var id = req.body.id;
        var business_id = req.body.business_id;
        var sql = "SELECT id,business_id,business_name,postal_code,business_phone,landline,reach_whatsapp, \n\
        business_email,photo, address1,address2,address3,pincode,town_city,state_id,country_id, \n\
        location, by_appointment_only, working_hours, website,short_description,business_status \n\
        FROM business_master WHERE id='" + id + "' and business_id='" + business_id + "' and is_activated=1 and deleted_at is null";

        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(404).send({ status: 'error', message: 'No recored found.' });
            } else {
                var website = [];
                if (rows[0]['website'] != '' && rows[0]['website'] != null && rows[0]['website'] != 'undefined') {
                    var x = rows[0]['website'];
                    website = x.split('|_|');
                    rows[0]['website'] = website;
                }
                if (rows[0]['working_hours'] === 'Select Hours') {
                    var q2 = "select id,`day`,start_hours,end_hours from business_hours \n\
                                where business_id='" + business_id + "' and deleted_at is null";
                    db.query(q2, function (error, hours) {
                        console.log(hours);
                        rows[0].hours = hours;
                        return res.status(200).json({ status: 'success', message: 'success', data: rows[0] });
                    });
                } else {
                    return res.status(200).json({ status: 'success', message: 'success', data: rows[0] });
                }
            }
        });
    }

};

/**
 * USER LOGIN START HERE
 */
exports.login = function (req, res, next) {
    if (req.body.username == '' || req.body.username == null) {
        return res.status(404)({ status: 'error', message: 'Business email or phone required.' });
    } else if (req.body.password == '' || req.body.password == null) {
        return res.status(404)({ status: 'error', message: 'Password required.' });
    }
    var username = req.body.username;

    var sql = "select * from business_users where (email='" + username + "' or phone='" + username + "') and is_deleted=0 and deleted_at is null";
    db.query(sql, function (err, result) {
        if (err) {
            return res.status(500)({ status: 'error', message: 'Something went wrong.', data: err });
        } else {
            if (result.length === 0) {
                return res.status(404).json({ status: 'error', message: 'Incorrect username or password' });
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
                        expiresIn: "2 days"
                    });

                    var user_data = {
                        id: result[0].id,
                        business_id: result[0].business_id,
                        email: result[0].email,
                        phone: result[0].phone,
                    };
                    return res.status(200)({ status: 'success', message: 'success', data: user_data, token: token });
                } else {
                    return res.status(404).json({ status: 'error', message: 'Incorrect username or password' });
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
        return res.status(404).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.status(404)({ status: 'error', message: 'Business id not found.' });
    } else {
        var id = req.body.id;
        var business_id = req.body.business_id;
        var sql = "SELECT id,business_id,first_name,last_name,email,phone,`role`,bank_ac_holder_name,account_number,ifsc_code,upi \n\
        FROM business_users where business_id='" + business_id + "' and is_deleted=0 and deleted_at is null";

        db.query(sql, function (err, rows, fields) {
            if (err) {
                return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(404).send({ status: 'error', message: 'No recored found.' });
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
        return res.status(404).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.status(404)({ status: 'error', message: 'Business id not found.' });
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
                return res.status(404).send({ status: 'error', message: 'No recored found.' });
            } else {
                return res.status(200).json({ status: 'success', message: 'Profile updated successfully.' });
            }
        });
    }

};

/**
 * BUSINESS OWNER PROFILE ADD ANOTHER BRANCH
 */
exports.addAnotherBranch = function (req, res, next) {
    if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
        return res.status(404).send({ status: 'error', message: 'Id not found' });
    } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.status(404)({ status: 'error', message: 'Business id not found.' });
    } else if (req.body.branch_address == '' || req.body.branch_address == 'undefined' || req.body.branch_address == null) {
        return res.status(404).send({ status: 'error', message: 'Branch address found' });
    } else if (req.body.branch_contact == '' || req.body.branch_contact == 'undefined' || req.body.branch_contact == null) {
        return res.status(404)({ status: 'error', message: 'Branch contact not found.' });
    }
    var business_id = req.body.business_id;
    var b_addr = req.body.branch_address;
    var b_addr_len = b_addr.length;
    for (var x = 0; x < b_addr_len; x++) {
        var branch_address = req.body.branch_address[x];
        var branch_contact = req.body.branch_contact[x];
        var q = "insert into business_branches (business_id,branch_address,branch_contact) values('" + business_id + "','" + branch_address + "','" + branch_contact + "')";
        db.query(q);
    }
    return res.status(200).json({ status: 'success', message: 'Branch added successfully' });
};