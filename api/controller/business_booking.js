var db = require('../config/db');

/**
 * FETCH ALL BUSINESS BOOKING
 */
exports.all_business_booking = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
                    DATE_FORMAT(created_datetime, '%d-%m-%Y') AS created_date, \n\
                    DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
                    FROM business_booking WHERE business_id='" + business_id + "' AND deleted_at IS NULL";
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
            return res.status(200).json({ status: 'success', message: 'success', data: result });
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

        if (req.body.advance_booking_days != '' && req.body.advance_booking_days != 'undefined' && req.body.advance_booking_days != null) {
            update_column += ",advance_booking_days='" + req.body.advance_booking_days + "'";
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
        var sql = "SELECT advance_booking_days,advance_booking_hours,slot_length,\n\
                            booking_per_slot,booking_per_day,announcement \n\
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