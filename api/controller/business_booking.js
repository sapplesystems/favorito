var db = require('../config/db');

var today = new Date();
var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();

/**
 * FETCH ALL BUSINESS BOOKING
 */
exports.all_business_booking = async function (req, res, next) {
    try {
        var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        var business_id = req.userdata.business_id;

        var Condition = " business_id='" + business_id + "' AND deleted_at IS NULL ";

        if (req.body.booking_date != '' && req.body.booking_date != 'undefined' && req.body.booking_date != null) {
            today_date = req.body.booking_date
        }
        Condition += " AND DATE(created_datetime) = '" + today_date + "' ";

        var slots = await exports.getBookingSlots(business_id, today_date);

        var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
                    DATE_FORMAT(created_datetime, '%d %b') AS created_date, \n\
                    DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
                    FROM business_booking WHERE " + Condition;
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', slots: slots, data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * FIND BUSINESS BOOKING BY ID
 */
exports.find_business_booking = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.booking_id == '' || req.body.booking_id == 'undefined' || req.body.booking_id == null) {
            return res.status(403).json({ status: 'error', message: 'Booking id not found.' });
        }
        var booking_id = req.body.booking_id;
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
                    DATE_FORMAT(created_datetime, '%d-%m-%Y') AS created_date, \n\
                    DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
                    FROM business_booking WHERE id='"+ booking_id + "' AND business_id='" + business_id + "' AND deleted_at IS NULL";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', data: result[0] });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * CREATE A NEW MANUAL BOOKING
 */
exports.create_manual_booking = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.contact == '' || req.body.contact == 'undefined' || req.body.contact == null) {
            return res.status(403).json({ status: 'error', message: 'Contact not found.' });
        } else if (req.body.no_of_person == '' || req.body.no_of_person == 'undefined' || req.body.no_of_person == null) {
            return res.status(403).json({ status: 'error', message: 'Number of person not found.' });
        } else if (req.body.special_notes == '' || req.body.special_notes == 'undefined' || req.body.special_notes == null) {
            return res.status(403).json({ status: 'error', message: 'Special notes not found.' });
        } else if (req.body.created_date == '' || req.body.created_date == 'undefined' || req.body.created_date == null) {
            return res.status(403).json({ status: 'error', message: 'Date not found.' });
        } else if (req.body.created_time == '' || req.body.created_time == 'undefined' || req.body.created_time == null) {
            return res.status(403).json({ status: 'error', message: 'Time not found.' });
        }

        var name = req.body.name;
        var contact = req.body.contact;
        var no_of_person = req.body.no_of_person;
        var special_notes = req.body.special_notes;
        var created_datetime = req.body.created_date + ' ' + req.body.created_time;

        var sql = "INSERT INTO business_booking (business_id,`name`,contact,no_of_person,special_notes,created_datetime) \n\
                    VALUES('" + business_id + "','" + name + "','" + contact + "','" + no_of_person + "','" + special_notes + "','" + created_datetime + "')";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Manual booking created successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * DELETE MANUAL BOOKING
 */
exports.delete_manual_booking = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.booking_id == '' || req.body.booking_id == 'undefined' || req.body.booking_id == null) {
            return res.status(403).json({ status: 'error', message: 'Booking id not found.' });
        }

        var booking_id = req.body.booking_id;

        var sql = "UPDATE business_booking SET deleted_at = NOW() WHERE id='" + booking_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Manual booking deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * SAVE MANUAL WAITLIST BOOKING
 */
exports.save_setting = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var update_column = " updated_at=NOW() ";

        if (req.body.start_time != '' && req.body.start_time != 'undefined' && req.body.start_time != null) {
            update_column += ",start_time='" + req.body.start_time + "'";
        }
        if (req.body.end_time != '' && req.body.end_time != 'undefined' && req.body.end_time != null) {
            update_column += ",end_time='" + req.body.end_time + "'";
        }
        if (req.body.advance_booking_start_days != '' && req.body.advance_booking_start_days != 'undefined' && req.body.advance_booking_start_days != null) {
            update_column += ",advance_booking_start_days='" + req.body.advance_booking_start_days + "'";
        }
        if (req.body.advance_booking_end_days != '' && req.body.advance_booking_end_days != 'undefined' && req.body.advance_booking_end_days != null) {
            update_column += ",advance_booking_end_days='" + req.body.advance_booking_end_days + "'";
        }
        if (req.body.advance_booking_hours != '' && req.body.advance_booking_hours != 'undefined' && req.body.advance_booking_hours != null) {
            update_column += ",advance_booking_hours='" + req.body.advance_booking_hours + "'";
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
        if (req.body.announcement != '' && req.body.announcement != 'undefined' && req.body.announcement != null) {
            update_column += ",announcement='" + req.body.announcement + "'";
        }

        var sql = "UPDATE business_booking_setting SET " + update_column + " WHERE business_id='" + business_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Manual booking setting saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET MANUAL WAITLIST BOOKING
 */
exports.get_setting = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT start_time,end_time,advance_booking_start_days,advance_booking_end_days, \n\
                    advance_booking_hours,slot_length,booking_per_slot,booking_per_day,announcement \n\
                    FROM business_booking_setting WHERE business_id='"+ business_id + "'";
        db.query(sql, function (err, result) {
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
 * GET THE BOOKING SLOTS
 */
exports.getBookingSlots = async function (business_id, date) {
    try {
        return new Promise(function (resolve, reject) {
            var sql = "SELECT start_time,end_time,slot_length \n\
                        FROM business_booking_setting WHERE business_id='"+ business_id + "'";
            db.query(sql, function (err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                }
                var starttime = result[0].start_time;
                var endtime = result[0].end_time;
                var interval = result[0].slot_length;
                var timeslots = [];//[starttime];

                while (starttime <= endtime) {
                    var start_datetime = date + ' ' + starttime;
                    starttime = addMinutes(starttime, interval);
                    var end_datetime = date + ' ' + starttime;

                    var sql = "SELECT COUNT(*) AS c, DATE_FORMAT('" + start_datetime + "','%H:%i') AS start_time, \n\
                                DATE_FORMAT('"+ end_datetime + "','%H:%i') AS end_time \n\
                                FROM business_booking WHERE business_id='" + business_id + "' \n\
                    AND created_datetime>='" + start_datetime + "' AND created_datetime <'" + end_datetime + "' \n\
                    AND deleted_at IS NULL";
                    db.query(sql, function (e, r) {
                        var obj = { start: r[0].start_time, end: r[0].end_time, booking_count: r[0].c };
                        timeslots.push(obj);
                    });
                }
                resolve(timeslots);
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

/**
 * ADDING MINUTE IN TIME TO CREATE SLOTS
 */
function addMinutes(time, minutes) {
    var date = new Date(new Date(today_date + ' ' + time).getTime() + minutes * 60000);
    var tempTime = ((date.getHours().toString().length == 1) ? '0' + date.getHours() : date.getHours()) + ':' +
        ((date.getMinutes().toString().length == 1) ? '0' + date.getMinutes() : date.getMinutes()) + ':' +
        ((date.getSeconds().toString().length == 1) ? '0' + date.getSeconds() : date.getSeconds());
    return tempTime;
}