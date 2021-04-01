var db = require('../config/db');
var moment = require('moment');


/**
 * FETCH ALL BUSINESS WAITLIST
 */
exports.all_business_waitlist = async function(req, res, next) {

    // var beginningTime = moment('20:00', 'h:mm');
    // var endTime = moment('19:00', 'h:mm');
    // // console.log(endTime)
    // console.log(beginningTime.isAfter(endTime)); // true
    // return res.send({ t: beginningTime.isBefore(endTime) })
    try {
        var business_id = req.userdata.business_id;
        let slots = await getSlots(business_id)
        if (slots === false) {
            return res.status(400).json({ status: 'failed', message: 'Please save the wailist settings before accepting waitlist', data: [] });
        }
        var sql = "SELECT b_w.id,b_w.name, u.full_name as booked_by,b_w.contact,b_w.no_of_person,b_w.special_notes,b_w.waitlist_status, DATE_FORMAT(b_w.created_at, '%d %b') as waitlist_date, \n\
        DATE_FORMAT(b_w.created_at, '%H:%i') AS walkin_at FROM business_waitlist as b_w left join users u on b_w.user_id = u.id WHERE b_w.business_id='" + business_id + "' AND b_w.deleted_at IS NULL";
        // var sql = "SELECT id,`name`,contact,no_of_person,special_notes,waitlist_status, DATE_FORMAT(created_at, '%d %b') as waitlist_date, \n\
        // DATE_FORMAT(created_at, '%H:%i') AS walkin_at FROM business_waitlist WHERE business_id='" + business_id + "' AND deleted_at IS NULL";
        let result = await exports.run_query(sql)
        for (let r = 0; r < result.length; r++) {
            for (let i = 0; i < slots.length; i++) {
                // console.log(slots[i][0].substring(11, 15))
                var beginningTime = moment(slots[i][0].substring(11, 15), 'hh:mm');
                var endTime = moment(slots[i][1].substring(11, 15), 'hh:mm');
                var waitlist_book_time = moment(result[r].walkin_at, 'hh:mm')
                if ((beginningTime.isBefore(waitlist_book_time) && waitlist_book_time.isBefore(endTime)) || waitlist_book_time.isSame(endTime)) {
                    // slots[i][0].substring(slots[i][0].length - 1, slots[i][0].length)
                    // result[r].slots = slots[i][0].substring(slots[i][0].length - 1, slots[i][0].length)
                    // console.log([slots[i][0].substring(10, 16), slots[i][1].substring(10, 16)])
                    result[r].slots = [slots[i][0].substring(10, 16), slots[i][1].substring(10, 16)]
                }
            }
        }
        if (result.length > 0) {
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        } else {
            return res.status(200).json({ status: 'success', message: 'NO Data Found', data: [] });
        }
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

var getSlots = async(business_id) => {
    return new Promise(async(resolve, reject) => {
        current_time = moment(new Date(), 'HHmmss').format('YYYY-MM-DD HH:MM:SS')
        sql_get_slot_setting = `SELECT start_time,end_time , slot_length,booking_per_slot,minium_wait_time FROM business_waitlist_setting \n\
                WHERE business_id = '${business_id}'`
        result_get_slot_setting = await exports.run_query(sql_get_slot_setting)
            // console.log(result_get_slot_setting)
        if (result_get_slot_setting && result_get_slot_setting[0].start_time == null && result_get_slot_setting[0].end_time == null && result_get_slot_setting[0].slot_length == 0) {
            return resolve(false)
        }

        array_slots = []
        start_time = result_get_slot_setting[0].start_time
        end_time = result_get_slot_setting[0].end_time
        available_time = current_time
        available_time = available_time.substring(0, 14) + '00' + available_time.substring(16);

        for (i = parseInt(start_time.substring(0, 2)); i < parseInt(end_time.substring(0, 2)); i = i + result_get_slot_setting[0].slot_length) {
            available_time_slots = available_time.substring(0, 11) + i + available_time.substring(13);
            if (available_time_slots.length == 18) {
                available_time_slots = available_time.substring(0, 11) + '0' + i + available_time.substring(13);
            }
            array_slots.push(available_time_slots)
        }
        final_arr_slots = []
        for (let index = 0; index < array_slots.length - 1; index++) {
            final_arr_slots.push([array_slots[index], array_slots[index + 1]])
        }
        // console.log(final_arr_slots);
        resolve(final_arr_slots)
    })
}

/**
 * CREATE A NEW MANUAL WAITLIST
 */
exports.create_manual_waitlist = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        // checking whether waitlist settings are saved or not

        sql_get_slot_setting = `SELECT start_time,end_time , slot_length,booking_per_slot,minium_wait_time FROM business_waitlist_setting \n\
                WHERE business_id = '${business_id}'`
        result_get_slot_setting = await exports.run_query(sql_get_slot_setting)
        if (result_get_slot_setting && result_get_slot_setting[0].start_time == null && result_get_slot_setting[0].end_time == null && result_get_slot_setting[0].slot_length == 0) {
            return res.status(400).json({ status: 'failed', message: 'Please save the wailist setting before accepting waitlist', data: [] });
        }

        if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.contact == '' || req.body.contact == 'undefined' || req.body.contact == null) {
            return res.status(403).json({ status: 'error', message: 'Contact not found.' });
        } else if (req.body.no_of_person == '' || req.body.no_of_person == 'undefined' || req.body.no_of_person == null) {
            return res.status(403).json({ status: 'error', message: 'Number of person not found.' });
        } else if (req.body.special_notes == '' || req.body.special_notes == 'undefined' || req.body.special_notes == null) {
            return res.status(403).json({ status: 'error', message: 'Special notes not found.' });
        }

        var name = req.body.name;
        var contact = req.body.contact;
        var no_of_person = req.body.no_of_person;
        var special_notes = req.body.special_notes;

        var sql = "INSERT INTO business_waitlist (user_id,business_id,`name`,contact,no_of_person,special_notes) VALUES('" + 0 + "','" + business_id + "','" + name + "','" + contact + "','" + no_of_person + "','" + special_notes + "')";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', err });
            }
            return res.status(200).json({ status: 'success', message: 'Waitlist added successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * DELETE MANUAL WAITLIST
 */
exports.delete_manual_waitlist = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.waitlist_id == '' || req.body.waitlist_id == 'undefined' || req.body.waitlist_id == null) {
            return res.status(403).json({ status: 'error', message: 'Waitlist id not found.' });
        }

        var waitlist_id = req.body.waitlist_id;

        var sql = "UPDATE business_waitlist SET deleted_at = NOW() WHERE id='" + waitlist_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Waitlist deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * SAVE MANUAL WAITLIST SETTING
 */
exports.save_setting = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var update_column = " updated_at=NOW() ";

        if (req.body.start_time != '' && req.body.start_time != 'undefined' && req.body.start_time != null) {
            update_column += ",start_time='" + req.body.start_time + "'";
        }
        if (req.body.end_time != '' && req.body.end_time != 'undefined' && req.body.end_time != null) {
            update_column += ",end_time='" + req.body.end_time + "'";
        }
        if (req.body.available_resource != '' && req.body.available_resource != 'undefined' && req.body.available_resource != null) {
            update_column += ",available_resource='" + req.body.available_resource + "'";
        }
        if (req.body.minium_wait_time != '' && req.body.minium_wait_time != 'undefined' && req.body.minium_wait_time != null) {
            update_column += ",minium_wait_time='" + req.body.minium_wait_time + "'";
        }
        if (req.body.slot_length != '' && req.body.slot_length != 'undefined' && req.body.slot_length != null) {
            update_column += ",slot_length='" + req.body.slot_length + "'";
        }
        if (req.body.booking_per_slot != '' && req.body.booking_per_slot != 'undefined' && req.body.booking_per_slot != null) {
            update_column += ",booking_per_slot='" + req.body.booking_per_slot + "'";
        }
        if (req.body.booking_per_day != '' && req.body.booking_per_day != 'undefined' && req.body.booking_per_day != null) {
            update_column += ",booking_per_day='" + req.body.booking_per_day + "'";
        }
        if (req.body.waitlist_manager_name != '' && req.body.waitlist_manager_name != 'undefined' && req.body.waitlist_manager_name != null) {
            update_column += ",waitlist_manager_name='" + req.body.waitlist_manager_name + "'";
        }
        if (req.body.announcement != '' && req.body.announcement != 'undefined' && req.body.announcement != null) {
            update_column += ",announcement='" + req.body.announcement + "'";
        }
        if (req.body.except_days != '' && req.body.except_days != 'undefined' && req.body.except_days != null) {
            update_column += ",except_days='" + req.body.except_days + "'";
        }

        var sql = "UPDATE business_waitlist_setting SET " + update_column + " WHERE business_id='" + business_id + "'";

        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Waitlist settings saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET MANUAL WAITLIST SETTING
 */
exports.get_setting = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT start_time,end_time,available_resource,minium_wait_time,slot_length,booking_per_slot,\n\
                    booking_per_day,waitlist_manager_name,announcement,except_days \n\
                    FROM business_waitlist_setting WHERE business_id='" + business_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * UPDATE WAITLIST STATUS 
 **/
exports.updateWaitlistStatus = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.waitlist_id == '' || req.body.waitlist_id == 'undefined' || req.body.waitlist_id == null) {
            return res.status(403).json({ status: 'error', message: 'waitlist_id Not Found.' });
        } else if (req.body.status == '' || req.body.status == 'undefined' || req.body.status == null) {
            return res.status(403).json({ status: 'error', message: 'Waitlist Status Not Found' });
        }

        var update_columns = " updated_at=now() ";

        if (req.body.status != '' && req.body.status != 'undefined' && req.body.status != null) {
            if (req.body.status == 'accepted' || req.body.status == 'rejected' || req.body.status == 'pending') {
                update_columns += ", waitlist_status='" + req.body.status + "' ";
                var sql = "UPDATE business_waitlist SET " + update_columns + " WHERE id='" + req.body.waitlist_id + "'";
                db.query(sql, function(err, result) {
                    if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                    }
                    if (result.affectedRows > 0) {
                        return res.status(200).json({ status: 'success', message: 'Waitlist updated successfully.' });
                    } else {
                        return res.status(200).json({ status: 'success', message: 'Waitlist has not been updated' });
                    }
                });
            } else {
                return res.status(200).json({ status: 'error', message: 'Please try again' });
            }

        } else {
            return res.status(200).json({ status: 'error', message: 'Please Dont send null status' });
        }

    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

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