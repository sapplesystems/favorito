var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var moment = require('moment');
const e = require('express');
const async = require('async');

// setting and updating the appointment booking booked by the user
exports.setBookingAppointment = async function(req, res, next) {
    data_to_insert = {}
    if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
        var business_id = req.userdata.business_id;
        if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
            var user_id = req.body.user_id;
        } else {
            return res.status(500).json({ status: 'error', message: 'user_id is missing' });
        }
    } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
        var business_id = req.body.business_id;
        if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
            var user_id = req.userdata.id;
        } else {
            return res.status(500).json({ status: 'error', message: 'user_id is missing' });
        }
    } else {
        return res.status(500).json({ status: 'error', message: 'business_id is missing' });
    }

    data_to_insert.business_id = business_id
    data_to_insert.user_id = user_id

    if (req.body.name == null || req.body.name == undefined || req.body.name == '') {
        return res.status(400).json({ status: 'error', message: 'name is missing' });
    } else {
        data_to_insert.name = req.body.name
    }

    if (req.body.contact == null || req.body.contact == undefined || req.body.contact == '') {
        return res.status(400).json({ status: 'error', message: 'contact is missing' });
    } else {
        data_to_insert.contact = req.body.contact
    }

    if (req.body.service_id != null && req.body.service_id != undefined && req.body.service_id != '') {
        data_to_insert.service_id = req.body.service_id
    }
    if (req.body.no_of_person != null && req.body.no_of_person != undefined && req.body.no_of_person != '') {
        data_to_insert.no_of_person = req.body.no_of_person
    }
    if (req.body.person_id != null && req.body.person_id != undefined && req.body.person_id != '') {
        data_to_insert.person_id = req.body.person_id
    }

    if (req.body.special_notes != null && req.body.special_notes != undefined && req.body.special_notes != '') {
        data_to_insert.special_notes = req.body.special_notes
    }

    if (req.body.datetime != null && req.body.datetime != undefined && req.body.datetime != '') {
        data_to_insert.datetime = req.body.datetime
        return res.status(400).json({ status: 'error', message: 'datetime is missing' });
    }

    if (req.body.business_appointment_id != '' && req.body.business_appointment_id != null && req.body.business_appointment_id != undefined) {
        var sql = `UPDATE business_appointment SET updated_at = NOW(), ? WHERE id = ${req.body.business_appointment_id}`;
    } else {
        var sql = "INSERT INTO business_appointment SET created_datetime = NOW(), ?";
    }

    try {
        db.query(sql, data_to_insert, function(err, result) {
            if (err) {
                res.status(500).send({ status: "failed", message: "Database error", err })
            }
            return res.status(200).send({ status: 'success', message: 'Data is updated' })
        })
    } catch (error) {
        res.status(500).send({ status: "failed", message: "Something went wrong" })
    }
}

// get all booking by user_id
exports.getBookingAppointment = async function(req, res, next) {
    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {} else {
        return res.status(400).json({ status: 'failed', message: 'user_id is missing' });
    }
    var sql = "SELECT b_a.id, b_a.user_id as user_id, b_a.business_id, IFNULL(b_m.business_name,''), IFNULL(b_m.business_phone,''), b_a.service_id, b_a.person_id,IFNULL(b_a_p.person_name,'') AS person_name,IFNULL(b_a_p.person_email,'') as person_email ,IFNULL(b_a_p.person_mobile,'') as person_mobile, b_a.special_notes,b_a.appointment_status, b_a.created_datetime \n\
    FROM business_appointment as b_a \n\
    JOIN business_appointment_person as b_a_p \n\
    JOIN business_master as b_m \n\
    ON b_m.business_id= b_a.business_id \n\
    AND b_a.person_id = b_a_p.id \n\
    WHERE b_a.user_id = '" + req.body.user_id + "' AND b_a.deleted_at IS NULL GROUP BY business_id"
    result = await exports.run_query(sql);
    try {
        return res.status(200).send({ status: 'success', message: 'Success', data: result })
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
}

// delete api for the user by user_id , booking_id and business_id
exports.deleteBookingAppointment = async function(req, res, next) {
    if (req.body.appointment_booking_id != null && req.body.appointment_booking_id != undefined && req.body.appointment_booking_id != '') {
        appointment_booking_id = req.body.appointment_booking_id
    } else {
        return res.status(400).json({ status: 'failed', message: 'appointment_booking_id is missing' });
    }
    var sql = "UPDATE business_appointment SET deleted_at = NOW() WHERE id = '" + appointment_booking_id + "'";
    try {
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(400).json({ status: 'failed', message: 'Something went wrong', error: err });
            } else {
                return res.status(200).json({ status: 'success', message: 'Data is deleted' });
            }
        })
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'Something went wrong', error });
    }
}

//  add user notes by user_id and booking id 
exports.setBookingNote = async function(req, res, next) {
    if (req.body.booking_id != null && req.body.booking_id != undefined && req.body.booking_id != '') {
        var condition = " WHERE id = '" + req.body.booking_id + "'"
    } else {
        return res.status(403).send({ status: 'failed', message: 'booking_id is missing' })
    }
    if (req.body.special_notes == null || req.body.special_notes == undefined || req.body.special_notes == '') {
        return res.status(403).send({ status: 'failed', message: 'special_notes is missing' })
    }

    var sql = "UPDATE business_booking SET special_notes = '" + req.body.special_notes + "'" + condition;

    try {
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).send({ status: 'Failed', message: 'Failed', error: err });
            } else {
                return res.status(200).send({ status: 'success', message: 'Notes is updates' })
            }
        })
    } catch (error) {
        return res.status(500).send({ status: 'failed', message: 'Something went wrong' });
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

// table name business_booking set and update
exports.setBookTable = function(req, res, next) {
    try {

        data_to_insert = {}
        if (req.userdata.business_id != null && req.userdata.business_id != undefined && req.userdata.business_id != '') {
            var business_id = req.userdata.business_id;
            if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
                var user_id = req.body.user_id;
            } else {
                return res.status(500).json({ status: 'error', message: 'user_id is missing' });
            }
        } else if (req.body.business_id != null && req.body.business_id != undefined && req.body.business_id != '') {
            var business_id = req.body.business_id;
            if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
                var user_id = req.userdata.id;
            } else {
                return res.status(500).json({ status: 'error', message: 'user_id is missing' });
            }
        } else {
            return res.status(500).json({ status: 'error', message: 'business_id is missing' });
        }

        data_to_insert.business_id = business_id
        data_to_insert.user_id = user_id

        if (req.body.no_of_person != null && req.body.no_of_person != undefined && req.body.no_of_person != '') {
            data_to_insert.no_of_person = req.body.no_of_person
        }
        if (req.body.date_time != null && req.body.date_time != undefined && req.body.date_time != '') {
            data_to_insert.created_datetime = req.body.date_time
        } else {
            return res.status(403).json({ status: 'error', message: 'Date or time not found.' });
        }

        if (req.body.phone != null && req.body.phone != undefined && req.body.phone != '') {
            data_to_insert.contact = req.body.phone
        } else {
            return res.status(403).json({ status: 'error', message: 'phone is missing.' });
        }

        if (req.body.name != null && req.body.name != undefined && req.body.name != '') {
            data_to_insert.name = req.body.name
        } else {
            return res.status(403).json({ status: 'error', message: 'name is missing.' });
        }

        if (req.body.special_notes != '') {
            data_to_insert.special_notes = req.body.special_notes
        }

        if (req.body.booking_id != null && req.body.booking_id != undefined && req.body.booking_id != '') {
            var sql = `UPDATE business_booking SET updated_at = NOW(), ? WHERE id = ${req.body.booking_id}`;
        } else {
            var sql = "INSERT INTO business_booking SET ?";
        }

        db.query(sql, data_to_insert, function(error, result) {
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

// get all booking by user_id
exports.getBookTable = async function(req, res, next) {
    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
        var condition = " WHERE b_b.user_id = '" + req.body.user_id + "' AND b_b.deleted_at IS NULL GROUP BY b_b.business_id"
    } else {
        return res.status(400).json({ status: 'failed', message: 'user_id is missing' });
    }

    var sql = "SELECT b_b.id,b_b.user_id, IF(b_b.user_id = b_b.business_id,1,0) as walk_in, '500' as price, b_m.business_name, AVG(b_r.rating) as avg_rating,b_m.business_phone, b_b.business_id,b_b.user_id,b_b.no_of_person,b_b.created_datetime \n\
    FROM business_booking AS b_b \n\
    JOIN business_master AS b_m \n\
    JOIN business_ratings AS b_r \n\
    ON b_m.business_id = b_b.business_id \n\
    AND b_r.business_id = b_b.business_id" + condition;
    try {
        result = await exports.run_query(sql)
        final_data = []
        async.eachSeries(result, function(data, callback) {
            db.query(`SELECT reviews FROM business_reviews WHERE user_id = '${data.user_id}' AND business_id = '${data.business_id}'`, function(error, results1) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                data.review = results1[0].reviews
                final_data.push(data)
                callback();
            });
        }, function(err, results) {
            return res.status(200).send({ status: 'success', message: 'Success', data: final_data })
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
}

// delete book table by booking id
exports.deleteBookTable = async function(req, res, next) {
    if (req.body.booking_id != null && req.body.booking_id != undefined && req.body.booking_id != '') {
        booking_id = req.body.booking_id
    } else {
        return res.status(400).json({ status: 'failed', message: 'booking_id is missing' });
    }
    var sql = "UPDATE business_booking SET deleted_at = NOW() WHERE id = '" + booking_id + "'";
    try {
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(400).json({ status: 'failed', message: 'Something went wrong', error: err });
            } else {
                return res.status(200).json({ status: 'success', message: 'Data is deleted' });
            }
        })
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'Something went wrong', error });
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