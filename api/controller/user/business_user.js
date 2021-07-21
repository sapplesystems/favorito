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
        location, by_appointment_only, working_hours, ifnull(website , '') as website ,short_description,business_status \n\
        FROM business_master WHERE  business_id='" + business_id + "' and deleted_at is null";

        db.query(sql, function(err, rows, fields) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            } else if (rows.length === 0) {
                return res.status(403).json({ status: 'error', message: 'No recored found.', data: {} });
            } else {
                var hours_drop_down_list = ['Select Hours', 'Always Open'];
                var website = [];
                if (rows[0]['website'] != '' && rows[0]['website'] != 'undefined') {
                    var x = rows[0]['website'];
                    website = x.split('|_|');
                    rows[0]['website'] = website;
                }
                if (rows[0]['website'] == null || rows[0]['website'] == '') {
                    rows[0]['website'] = ' ';
                }

                if (rows[0]['working_hours'] === 'Select Hours') {
                    var q2 = "select `day`,start_hours,end_hours from business_hours \n\
                                where business_id='" + business_id + "' and deleted_at is null";
                    db.query(q2, function(error, hours) {
                        // code for the make the group of same time
                        let final_hours = []
                        if (hours[0]) {
                            let start_day = hours[0].day
                            let end_day = ''
                            for (let i = 0; i < hours.length; i++) {
                                const element = hours[i];
                                if (hours[i + 1] && element.start_hours == hours[i + 1].start_hours && element.end_hours == hours[i + 1].end_hours) {
                                    end_day = hours[i + 1].day
                                } else {
                                    if (end_day) {
                                        hours[i].day = `${start_day} - ${end_day}`
                                        end_day = ''
                                    } else {
                                        hours[i].day = `${start_day}`
                                    }
                                    final_hours.push(hours[i])
                                    if (hours[i + 1]) {
                                        start_day = hours[i + 1].day
                                    }
                                }
                            }
                            rows[0].hours = final_hours;
                        }

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
                    return res.status(401).json({ status: 'Fail', message: 'Incorrect username or password.' });
                }
                bcrypt.compare(req.body.password, result[0].password, function(err, enc_result) {
                    if (err) {
                        return res.status(200).json({ status: 'Fail', message: 'Password not matched', data: err });
                    }
                    // change token expire here
                    if (enc_result == true) {
                        var token = jwt.sign({
                            email: result[0].business_email,
                            phone: result[0].business_phone,
                            id: result[0].id,
                            business_id: result[0].business_id,
                            role:'business',
                            fb_key:result[0].firebase_chat_id
                        }, 'secret', {
                            expiresIn: "1 day"
                        });

                        var user_data = {
                            id: result[0].id,
                            business_id: result[0].business_id,
                            email: result[0].business_email,
                            phone: result[0].business_phone,
                            fb_key:result[0].firebase_chat_id,
                            role:'business',
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
                        return res.status(401).json({ status: 'error', message: 'Incorrect username or password', data: {}, token: null });
                    }
                });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.getBusinessWebsite = async(req, res) => {
    try {
        var business_id = req.userdata.business_id;
        sqlGetWebsite = `select ifnull(website, '') as website from business_master where business_id = '${business_id}'`
        resultGetWebsite = await exports.run_query(sqlGetWebsite)
        var website = [];
        if (resultGetWebsite[0]['website'] != '' && resultGetWebsite[0]['website'] != 'undefined') {
            var x = resultGetWebsite[0]['website'];
            website_array_split = x.split('|_|');
            for (let i = 0; i < website_array_split.length; i++) {
                const element = website_array_split[i];
                if (element != '' && element != null) {
                    website.push(element)
                }
            }
            resultGetWebsite[0]['website'] = website;
        }
        if (resultGetWebsite[0]['website'] == null || resultGetWebsite[0]['website'] == '') {
            resultGetWebsite[0]['website'] = ' ';
        }
        return res.status(200).json({ status: 'success', message: 'success', data: website });
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

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
        if (req.body.email != '' && req.body.email != 'undefined' && req.body.email != null) {
            update_columns += ", email='" + req.body.email + "' ";
        }
        if (req.body.phone != '' && req.body.phone != 'undefined' && req.body.phone != null) {
            update_columns += ", phone='" + req.body.phone + "' ";
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
        var sql = "SELECT CONCAT('" + img_path + "',photo) as photo,short_description FROM business_master WHERE business_id = '" + req.userdata.business_id + "' AND deleted_at IS NULL"
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

// All chat functions

exports.getRoomId = async function(req, res, next) {
    if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
        var source_id = req.userdata.business_id;
    } else if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
        var source_id = req.userdata.id;
    }

    if (req.body.target_id != null && req.body.target_id != undefined && req.body.target_id != '') {
        target_id = req.body.target_id
    } else {
        return res.status(400).json({ status: 'error', message: 'target_id is missing' });
    }

    sql_exist_room_id = `SELECT room_id from business_chat_messages \n\
    where (source_id = '${source_id}' and target_id = '${target_id}') \n\
    or (source_id = '${target_id}' and target_id = '${source_id}') limit 1`
    try {
        result_exist_room_id = await exports.run_query(sql_exist_room_id)
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong', error });
    }
    if (result_exist_room_id == '') {
        sql_new_get_room_id = `SELECT MAX(room_id) as room_id FROM business_chat_messages`
        try {
            result_get_room_id = await exports.run_query(sql_new_get_room_id)
        } catch (error) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong', error });
        }
        if (result_get_room_id[0].room_id == null) {
            room_id = 1
        } else {
            room_id = result_get_room_id[0].room_id + 1
        }
    } else {
        room_id = result_exist_room_id[0].room_id
    }
    return res.status(200).json({ status: 'success', message: 'success', data: [{ room_id }] });
}

exports.getChats = async(req, res, next) => {

    // getting the room id form the req if not found then from the token 
    if (req.body.room_id) {
        room_id = req.body.room_id
    } else {
        if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
            var source_id = req.userdata.business_id;
        } else if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
            var source_id = req.userdata.id;
        }

        if (req.body.target_id != null && req.body.target_id != undefined && req.body.target_id != '') {
            target_id = req.body.target_id
        } else {
            return res.status(400).json({ status: 'error', message: 'target_id is missing' });
        }

        sql_exist_room_id = `SELECT room_id from business_chat_messages \n\
        where (source_id = '${source_id}' and target_id = '${target_id}') \n\
        or (source_id = '${target_id}' and target_id = '${source_id}') limit 1`
        try {
            room_id = (await exports.run_query(sql_exist_room_id))[0].room_id
        } catch (error) {
            return res.status(500).json({ status: 'error', message: 'Something went wrong', error });
        }
    }


    if (req.body.current_no_msg) {
        current_no_msg = req.body.current_no_msg
    } else {
        current_no_msg = 0
    }
    offset = current_no_msg
    limit = 20

    try {
        sql_get_messages = `SELECT id, source_id, target_id, message, concat('${img_path}chat_files/',file) as file, DATE_FORMAT(created_at, '%d-%b-%Y %H:%i:%s') AS created_at from business_chat_messages where room_id = '${room_id}' ORDER BY created_at DESC LIMIT ${limit} OFFSET ${offset}`
        result_get_message = await exports.run_query(sql_get_messages)
    } catch (error) {
        return res.status(500).send({ status: 'failed', message: 'failed', error })
    }
    if (result_get_message != '') {
        return res.status(200).send({ status: 'success', message: 'success', data: result_get_message })
    } else {
        return res.status(400).send({ status: 'success', message: 'There is no message to show.', data: [] })
    }
}

exports.setChat = async(req, res) => {
    if (req.userdata.business_id) {
        source_id = req.userdata.business_id
        if (!req.body.user_id) {
            return res.status(400).json({ status: 'error', message: 'user_id is missing' });
        } else {
            target_id = req.body.user_id
        }
    } else {
        source_id = req.userdata.id
        if (!req.body.business_id) {
            return res.status(400).json({ status: 'error', message: 'business_id is missing' });
        } else {
            target_id = req.body.business_id
        }
    }

    if (!req.body.message && !req.file) {
        return res.status(400).json({ status: 'error', message: 'message or file is missing' });
    }

    if (!req.body.room_id) {
        return res.status(400).json({ status: 'error', message: 'room_id is missing' });
    } else {
        room_id = req.body.room_id
    }

    dataToInsert = {
        source_id: source_id,
        target_id: target_id,
        room_id: room_id,
        message: req.body.message ? req.body.message : null,
        file: req.file ? req.file.filename : null
    }

    sqlInsertChat = `insert into business_chat_messages set ?`
    try {
        await exports.run_query(sqlInsertChat, dataToInsert)
        return res.status(200).json({ status: 'success', message: 'Message is saved' });
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong' });
    }

}

exports.getChatList = async(req, res) => {
    if (req.body.current_no_list) {
        offset = req.body.current_no_list
    } else {
        offset = 0
    }
    limit = 10

    if (req.userdata.business_id) {
        source_id = req.userdata.business_id
    } else {
        source_id = req.userdata.id
    }


    //     sqlGetChatList = `select bcm.source_id, bcm.target_id,bcm.room_id,\n\
    //     ifnull(u.full_name,bm.business_name) as name,\n\
    //     ifnull(concat('${img_path}',u.photo),concat('${img_path}',bm.photo)) as photo, \n\
    //     ifnull(u.short_description,bm.short_description) as short_description,\n\
    //    (select count(bcms.id) from business_chat_messages as bcms where source_id = '${source_id}' and target_id = bcm.target_id) as unseen_count\n\
    //     from business_chat_messages as bcm \n\
    //     left join users as u on bcm.target_id = u.id or bcm.source_id = u.id\n\
    //     left join business_master as bm on bcm.target_id = bm.business_id or bcm.source_id = bm.business_id
    //     where source_id = '${source_id}'  group by bcm.room_id order by bcm.id desc limit ${limit} offset ${offset}`


    sqlGetChatList = `select bcm.source_id, bcm.target_id,bcm.room_id,\n\
        if('${source_id} ' = bcm.source_id ,ifnull((select full_name from users where id = bcm.target_id),(select business_name from business_master where business_id = bcm.target_id)), ifnull((select full_name from users where id = bcm.source_id),(select business_name from business_master where business_id = bcm.source_id))) as name,\n\
        if('${source_id} ' = bcm.source_id ,ifnull((select concat('${img_path}',photo) from users where id = bcm.target_id),(select concat('${img_path}',photo) from business_master where business_id = bcm.target_id)), ifnull((select concat('${img_path}',photo) from users where id = bcm.source_id),(select concat('${img_path}',photo) from business_master where business_id = bcm.source_id))) as photo, \n\
        if('${source_id} ' = bcm.source_id ,ifnull((select short_description from users where id = bcm.target_id),(select short_description from business_master where business_id = bcm.target_id)), ifnull((select short_description from users where id = bcm.source_id),(select short_description from business_master where business_id = bcm.source_id))) as short_description,\n\
       (select count(bcms.id) from business_chat_messages as bcms where source_id = '${source_id}' and target_id = bcm.target_id) as unseen_count\n\
        from business_chat_messages as bcm \n\
        where source_id = '${source_id}' or target_id = '${source_id}' group by bcm.room_id order by bcm.id desc limit ${limit} offset ${offset}`

    try {
        resultGetChatList = await exports.run_query(sqlGetChatList)
        if (resultGetChatList == '') {
            return res.status(200).json({ status: 'success', message: 'No chat exists', data: [{ target_id: null, room_id: null, name: null, photo: null, short_description: null, unseen_count: null }] });
        }
        return res.status(200).json({ status: 'success', message: 'success', data: resultGetChatList });
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong', error });
    }
}

exports.firebaseId = async(req, res) => {
    let table = null
    let api_type = null
    let id = null
    let column = null
    let firebase_id = null
    if (!req.body.api_type) {
        return res.status(400).json({ status: 'error', message: 'api_type is missing either set or get' });
    } else {
        api_type = req.body.api_type
        if (api_type == 'set') {
            if (!req.body.firebase_id) {
                return res.status(400).json({ status: 'error', message: 'firebase_id is missing' });
            } else {
                firebase_id = req.body.firebase_id
            }
        }
    }

    if (id = req.body.id) {
        if (isNaN(id)) {
            table = 'business_master'
            column = 'business_id'
        } else {
            table = 'users'
            column = 'id'
        }
    } else {
        if (req.userdata.business_id) {
            id = req.userdata.business_id
            table = 'business_master'
            column = 'business_id'
        } else {
            id = req.userdata.id
            table = 'users'
            column = 'id'
        }
    }

    try {
        if (api_type == 'set') {
            sql = `update ${table} set firebase_chat_id = '${firebase_id}' where ${column} = '${id}'`
            result = await exports.run_query(sql)
            return res.status(200).json({ status: 'success', message: 'Updated successfully', });
        } else {
            sql = `select firebase_chat_id from ${table} where ${column} = '${id}'`
            result = await exports.run_query(sql)
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        }
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong', error });
    }
}

/*create chat connection */
exports.createChatConnected = async function(req, res, next) {
    try {
        if (req.body.targetid == '' || req.body.targetid == 'undefined' || req.body.targetid == null) {
            return res.status(403).json({ status: 'error', message: 'Target id not found' });
        }
        let source_id=req.userdata.fb_key;
        let target_id = req.body.targetid;
        let target_role = req.body.target_role;
        let source_role = req.userdata.role;
        var sqlChatConnected = "Insert into business_chat (source_id,target_id,target_role,source_role,target_role) values('" + source_id + "','" + target_id + "','"+source_role+"','"+target_role+"')";
        resultChatConnected = await exports.run_query(sqlChatConnected);
        if(resultChatConnected.affectedRows>0){
            return res.status(200).json({ status: 'success', message: 'Inserted successfully' });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.'+e });
    }
}

exports.getChatConnectedList = async function(req, res, next) {
    try {
        var source_id=req.userdata.fb_key;
        var sqlChatConnected = "SELECT id,CASE WHEN `target_id`!='"+source_id+"' THEN target_id ELSE `source_id` END AS target_id,CASE WHEN `target_id`!='"+source_id+"' THEN target_role ELSE `source_role` END AS target_role FROM `business_chat` WHERE (`source_id`='"+source_id+"' OR `target_id`='"+source_id+"' ) AND ( NOT FIND_IN_SET('"+source_id+"',`deleted_by`) OR deleted_by IS NULL )";
        resultChatConnected = await exports.run_query(sqlChatConnected);
        if(resultChatConnected!=''){
            for(var i=0;i<resultChatConnected.length;i++){
                 let table_name=(resultChatConnected[i].target_role=='business')?'business_master':'users';
                 let sql="SELECT * FROM "+table_name+" WHERE `firebase_chat_id`='"+resultChatConnected[i].target_id+"'";
                 let result=await exports.run_query(sql);
                if(result!=''){
                    resultChatConnected[i].name=(resultChatConnected[i].target_role!='business')?result[0].first_name+" "+result[0].last_name:result[0].business_name;
                    resultChatConnected[i].photo=(resultChatConnected[i].target_role!='business')?img_path+result[0].PHOTO:img_path+result[0].photo;
                    resultChatConnected[i].short_description=(resultChatConnected[i].target_role!='business')?result[0].short_description:result[0].short_description;
                }
            }
            return res.status(200).json({ status: 'success', message: 'success',data:resultChatConnected });
        }else{
            return res.status(200).json({ status: 'success', message: 'No data exist',data:[] });  
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.'+e });
    }
}

exports.DeleteChatConnectedList = async function(req, res, next) {
    try {
        if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
            return res.status(403).json({ status: 'error', message: 'id not found' });
        }
        var source_id=req.userdata.fb_key;
        var id=req.body.id;
        var sqlChatConnected = "SELECT * FROM `business_chat` WHERE (`source_id`='"+source_id+"' OR `target_id`='"+source_id+"' ) AND id='"+id+"'";
        resultChatConnected = await exports.run_query(sqlChatConnected);
        if(resultChatConnected!=''){
            var deleted_key=(resultChatConnected[0].deleted_by==null)?source_id:resultChatConnected[0].deleted_by+','+source_id;
            var updateChatConnected="UPDATE `business_chat` SET `deleted_by`='"+deleted_key+"' WHERE `id`='"+id+"'";
            resultupdateChatConnected = await exports.run_query(updateChatConnected);
            if(resultupdateChatConnected.affectedRows>0){
                return res.status(200).json({ status: 'success', message: 'Deleted Successfully' });
            }
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
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