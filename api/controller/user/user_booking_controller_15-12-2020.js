var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var moment = require('moment');

// get all booking by user_id
exports.getBookings = async function(req, res, next) {
    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
        var condition = "WHERE user_id = '" + req.body.user_id + "' AND deleted_at IS NULL"
    } else {
        var condition = ""
    }

    var sql = "SELECT * FROM business_booking " + condition;
    try {
        db.query(sql, function(err, result) {
            res.send(result)
        })
    } catch (error) {
        res.send(error)
    }
}

// edit the booking by booking_id business_id and user_id 
exports.setUpdateBooking = async function(req, res, next) {
    if (
        (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') &&
        (req.body.booking_id != null && req.body.booking_id != undefined && req.body.booking_id != '') &&
        (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '')
    ) {
        var condition = " WHERE user_id = '" + req.body.user_id + "' AND id = '" + req.body.booking_id + "' AND business_id = '" + req.body.business_id + "' AND deleted_at IS NULL"
    } else {
        return res.status(403).send({ status: 'failed', message: 'wrong input' })
    }

    var set = " updated_at=NOW() ";

    if ((req.body.name != null && req.body.name != undefined && req.body.name != '')) {
        set += ",name='" + req.body.name + "'";
    }

    if ((req.body.no_of_person != null && req.body.no_of_person != undefined && req.body.no_of_person != '')) {
        set += ",no_of_person = '" + req.body.no_of_person + "'"
    }

    if ((req.body.contact != null && req.body.contact != undefined && req.body.contact != '')) {
        set += ",contact = '" + req.body.contact + "'"
    }

    var sql = "UPDATE business_booking SET " + set + condition;
    try {
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).send(err);
            }
            return res.status(200).send({ status: 'success', message: 'success' })
        })
    } catch (error) {
        return res.status(500).send(error);
    }
}

//  add user notes by user_id and booking id 
exports.setBookingNote = async function(req, res, next) {
    if ((req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') &&
        (req.body.booking_id != null && req.body.booking_id != undefined && req.body.booking_id != '') &&
        (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') &&
        (req.body.special_notes != null && req.body.special_notes != undefined && req.body.special_notes != '')) {
        var condition = " WHERE user_id = '" + req.body.user_id + "' AND id = '" + req.body.booking_id + "' AND business_id = '" + req.body.business_id + "' AND deleted_at IS NULL"
    } else {
        return res.status(403).send({ status: 'failed', message: 'wrong input' })
    }

    var sql = "UPDATE business_booking SET special_notes = '" + req.body.special_notes + "'" + condition;
    try {
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).send({ status: 'Failed', message: 'Failed', error: err });
            } else {
                return res.status(200).send({ status: 'success', message: 'success', result: result })
            }
        })
    } catch (error) {
        return res.status(500).send(error);
    }
}


// delete api for the user by user_id , booking_id and business_id
exports.deleteBooking = async function(req, res, next) {
    if ((req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') &&
        (req.body.booking_id != null && req.body.booking_id != undefined && req.body.booking_id != '') &&
        (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '')
    ) {
        var condition = " WHERE user_id = '" + req.body.user_id + "' AND id = '" + req.body.booking_id + "' AND business_id = '" + req.body.business_id + "' AND deleted_at IS NULL"
    } else {
        return res.status(403).send({ status: 'failed', message: 'wrong input' })
    }
    // setting the deleted_at 1 as it denote that it is deleted
    var sql = "UPDATE business_booking SET deleted_at = '" + moment(new Date()).format('YYYY:MM:DD h:mm:ss') + "'" + condition;
    try {
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(400).send({ status: "failed", message: "Could not delete the request", error: err })
            } else {
                console.log('result' + result);
                return res.status(200).send({ status: 'success', message: 'success' })
            }
        })
    } catch (error) {
        return res.send(error)
    }
}

// setting the booking booked by the user
exports.setBookings = async function(req, res, next) {
    if ((req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') &&
        (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') &&
        (req.body.name != null && req.body.name != undefined && req.body.name != '') &&
        (req.body.contact != null && req.body.contact != undefined && req.body.contact != '') &&
        (req.body.service_id != null && req.body.service_id != undefined && req.body.service_id != '') &&
        (req.body.person_id != null && req.body.person_id != undefined && req.body.person_id != '') &&
        (req.body.datetime != null && req.body.datetime != undefined && req.body.datetime != '')
    ) {
        var sql = "INSERT INTO business_appointment (business_id, user_id, name, contact, service_id, person_id, created_datetime) values('" + req.body.business_id + "','" + req.body.user_id + "','" + req.body.name + "','" + req.body.contact + "','" + req.body.service_id + "','" + req.body.person_id + "','" + req.body.datetime + "')";
    } else {
        return res.status(403).send({ status: 'failed', message: 'wrong input' })
    }
    try {
        db.query(sql, function(err, result) {
            if (err) {
                res.status(500).send({ status: "failed", message: "Database error" })
            }
            return res.status(200).send({ status: 'success', message: 'success' })
        })
    } catch (error) {
        res.status(500).send({ status: "failed", message: "Something went wrong" })
    }
}

// Join waitlist
exports.setJoinWaitlist = function(req, res, next) {
    if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
        return res.status(403).json({ status: 'error', message: 'business_id is required' });
    } else if (req.body.user_id == '' || req.body.user_id == 'undefined' || req.body.user_id == null) {
        return res.status(403).json({ status: 'error', message: 'user_id is required' });
    }
}

exports.setBookTable = function(req, res, next) {
    try {

        if (req.body.user_id == '' || req.body.user_id == 'undefined' || req.body.user_id == null) {
            return res.status(403).json({ status: 'error', message: 'user_id not found.' });
        } else if (req.body.no_of_person == '' || req.body.no_of_person == 'undefined' || req.body.no_of_person == null) {
            return res.status(403).json({ status: 'error', message: 'Number of guest not found.' });
        } else if (req.body.date_time == '' || req.body.date_time == 'undefined' || req.body.date_time == null) {
            return res.status(403).json({ status: 'error', message: 'Date or time not found.' });
        } else if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.phone == '' || req.body.phone == 'undefined' || req.body.phone == null) {
            return res.status(403).json({ status: 'error', message: 'Phone not found.' });
        } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
            return res.status(403).json({ status: 'error', message: 'business_id not found.' });
        }

        dataToInsert = {
            user_id: req.body.user_id,
            no_of_person: req.body.no_of_person,
            created_datetime: req.body.date_time,
            name: req.body.name,
            contact: req.body.contact,
            business_id: req.body.business_id,
        }

        if (req.body.special_notes != '') {
            dataToInsert.special_notes = req.body.special_notes
        }
        var sql = "INSERT INTO business_booking SET ?";
        db.query(sql, dataToInsert, function(error, result) {
            if (error) {
                return res.status(500).send({ status: "failed", message: "Something went wrong", error: error })
            } else {
                return res.status(200).send({ status: "success", message: "Table is booked" })
            }
        })
    } catch (error) {
        res.status(500).send({ status: "failed", message: "Something went wrong", error: error })
    }
}