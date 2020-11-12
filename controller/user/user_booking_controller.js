var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';

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
    console.log(sql);
    try {
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).send(error);
            }
            return res.status(200).send({ status: 'success', message: 'success' })
        })
    } catch (error) {
        return res.status(500).send(error);
    }
}