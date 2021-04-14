const { log } = require('debug');
var db = require('../config/db');

var today = new Date();
var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();

/**
 * STATIC VARIABLES
 */
exports.dd_verbose = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var person_list = await exports.getAllPersons(business_id);
        var service_list = await exports.getAllServices(business_id);
        var data = {
            person_list: person_list,
            service_list: service_list
        };
        return res.status(200).json({ status: 'success', message: 'success', data: data });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

exports.appointment_service = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var service_list = await exports.getAllServices(business_id);
        return res.status(200).json({ status: 'success', message: 'success', data: service_list });
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

/**
 * SAVE PERSON
 */
exports.savePerson = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.person_name == '' || req.body.person_name == 'undefined' || req.body.person_name == null) {
            return res.status(403).json({ status: 'error', message: 'Person not found.' });
        } else if (req.body.service_id == '' || req.body.service_id == 'undefined' || req.body.service_id == null) {
            return res.status(403).json({ status: 'error', message: 'Service not found.' });
        }

        var postval = {
            business_id: business_id,
            person_name: req.body.person_name,
            service_id: req.body.service_id
        };
        if (req.body.person_mobile != '' && req.body.person_mobile != 'undefined' && req.body.person_mobile != null) {
            postval.person_mobile = req.body.person_mobile;
        }
        if (req.body.person_email != '' && req.body.person_email != 'undefined' && req.body.person_email != null) {
            postval.person_email = req.body.person_email;
        }

        var sql = "INSERT INTO business_appointment_person SET ?";
        db.query(sql, postval, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Person saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * SAVE SERVICE
 */
exports.saveService = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.service_name == '' || req.body.service_name == 'undefined' || req.body.service_name == null) {
            return res.status(403).json({ status: 'error', message: 'Service not found.' });
        }

        var postval = {
            business_id: business_id,
            service_name: req.body.service_name
        };

        var sql = "INSERT INTO business_appointment_service SET ?";
        db.query(sql, postval, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Service saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * SAVE RESTRICTION
 */
exports.saveRestriction = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var postval = { business_id: business_id };
        if (req.body.person_id != '' && req.body.person_id != 'undefined' && req.body.person_id != null) {
            postval.person_id = req.body.person_id;
        }
        if (req.body.service_id != '' && req.body.service_id != 'undefined' && req.body.service_id != null) {
            postval.service_id = req.body.service_id;
        }

        if (req.body.start_datetime == '' || req.body.start_datetime == 'undefined' || req.body.start_datetime == null) {
            return res.status(403).json({ status: 'error', message: 'Start date & time not found.' });
        } else if (req.body.end_datetime == '' || req.body.end_datetime == 'undefined' || req.body.end_datetime == null) {
            return res.status(403).json({ status: 'error', message: 'End date & time not found.' });
        }

        postval.start_datetime = req.body.start_datetime;
        postval.end_datetime = req.body.end_datetime;

        var sql = "INSERT INTO business_appointment_restriction SET ?";
        db.query(sql, postval, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Restriction saved successfully.' });
        });

    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET ALL PERSON LIST
 */
exports.getAllPersonList = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var data = await exports.getAllPersons(business_id);
        return res.status(200).json({ status: 'success', message: 'success.', data: data });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET ALL SERVICE LIST
 */
exports.getAllServiceList = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var data = await exports.getAllServices(business_id);
        return res.status(200).json({ status: 'success', message: 'success.', data: data });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET ALL RESTRICTION LIST
 */
exports.getAllRestrictionList = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var data = await exports.getAllRestriction(business_id);
        return res.status(200).json({ status: 'success', message: 'success.', data: data });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET ALL PERSONS
 */
exports.getAllPersons = function(business_id) {
    return new Promise(function(resolve, reject) {
        // var sql = "SELECT id,person_name,person_mobile,person_email,service_id, \n\
        // (select service_name from business_appointment_service where id=service_id) as service_name, \n\
        // is_active FROM business_appointment_person WHERE business_id='" + business_id + "' AND is_active='1'";
        var sql = "SELECT id,person_name,person_mobile,person_email,service_id, \n\
        (select service_name from business_appointment_service where id=service_id) as service_name, \n\
        is_active FROM business_appointment_person WHERE business_id='" + business_id + "'";
        db.query(sql, function(err, person_list) {
            resolve(person_list);
        });
    });
};

/**
 * GET ALL SERVICES
 */
exports.getAllServices = function(business_id) {
    return new Promise(function(resolve, reject) {
        // var sql = "SELECT id,service_name,is_active FROM business_appointment_service WHERE business_id='" + business_id + "' AND is_active='1'";
        var sql = "SELECT id,service_name,is_active FROM business_appointment_service WHERE business_id='" + business_id + "'";
        db.query(sql, function(err, service_list) {
            resolve(service_list);
        });
    });
};

/**
 * GET ALL RESTRICTIONS
 */
exports.getAllRestriction = function(business_id) {
    return new Promise(function(resolve, reject) {
        // var sql = "SELECT id, \n\
        //         person_id, (SELECT person_name FROM business_appointment_person WHERE id=person_id) AS person_name, \n\
        //         service_id, (SELECT service_name FROM business_appointment_service WHERE id=service_id) AS service_name, \n\
        //         CONCAT(DATE_FORMAT(start_datetime, '%d'), '-', DATE_FORMAT(end_datetime, '%d %b')) AS date_time \n\
        //         FROM business_appointment_restriction \n\
        //         WHERE business_id='" + business_id + "' AND deleted_at IS NULL";

        var sql = "SELECT id, \n\
                person_id, (SELECT person_name FROM business_appointment_person WHERE id=person_id) AS person_name, \n\
                service_id, (SELECT service_name FROM business_appointment_service WHERE id=service_id) AS service_name, \n\
                CONCAT(DATE_FORMAT(start_datetime, '%Y-%m-%d %H:%i:%s'), ' - ', DATE_FORMAT(end_datetime, '%Y-%m-%d %H:%i:%s')) AS date_time \n\
                FROM business_appointment_restriction \n\
                WHERE business_id='" + business_id + "' AND deleted_at IS NULL";
        db.query(sql, function(err, restriction_list) {
            resolve(restriction_list);
        });
    });
};


/**
 * DELETE RESTRICTION
 */
exports.deleteRestriction = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.restriction_id == '' || req.body.restriction_id == 'undefined' || req.body.restriction_id == null) {
            return res.status(403).json({ status: 'error', message: 'Restriction id not found.' });
        }

        var sql = "UPDATE business_appointment_restriction SET deleted_at=NOW() WHERE id='" + req.body.restriction_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Restriction deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET RESTRICTION DETAIL
 */
exports.getRestrictionDetail = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.restriction_id == '' || req.body.restriction_id == 'undefined' || req.body.restriction_id == null) {
            return res.status(403).json({ status: 'error', message: 'Restriction id not found.' });
        }
        var restriction_id = req.body.restriction_id;
        var sql = "SELECT person_id, service_id, start_datetime, end_datetime FROM business_appointment_restriction WHERE id='" + restriction_id + "' AND deleted_at IS NULL";
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
 * EDIT RESTRICTION
 */
exports.editRestriction = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.restriction_id == '' || req.body.restriction_id == 'undefined' || req.body.restriction_id == null) {
            return res.status(403).json({ status: 'error', message: 'Restriction id not found.' });
        }
        var restriction_id = req.body.restriction_id;

        var update_column = " updated_at=NOW() ";
        if (req.body.person_id != '' && req.body.person_id != 'undefined' && req.body.person_id != null) {
            update_column += ", person_id='" + req.body.person_id + "'";
        }
        if (req.body.service_id != '' && req.body.service_id != 'undefined' && req.body.service_id != null) {
            update_column += ", service_id='" + req.body.service_id + "'";
        }
        if (req.body.start_datetime != '' && req.body.start_datetime != 'undefined' && req.body.start_datetime != null) {
            update_column += ", start_datetime='" + req.body.start_datetime + "'";
        }
        if (req.body.end_datetime != '' && req.body.end_datetime != 'undefined' && req.body.end_datetime != null) {
            update_column += ", end_datetime='" + req.body.end_datetime + "'";
        }

        var sql = "UPDATE business_appointment_restriction SET " + update_column + " WHERE id='" + restriction_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Restriction saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

// change active on or off of person
exports.setPersonStatus = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.person_id == '' || req.body.person_id == 'undefined' || req.body.person_id == null) {
            return res.status(403).json({ status: 'error', message: 'person id is not found.' });
        }
        var person_id = req.body.person_id;

        var update_column = " updated_at=NOW() ";
        if (req.body.is_active != '' && req.body.is_active != 'undefined' && req.body.is_active != null) {
            update_column += ", is_active='" + req.body.is_active + "'";
        }

        var sql = "UPDATE business_appointment_person SET " + update_column + " WHERE id='" + person_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).json({ status: 'success', message: 'Person status changed' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

// change active on or off of service
exports.setServiceStatus = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.service_id == '' || req.body.service_id == 'undefined' || req.body.service_id == null) {
            return res.status(403).json({ status: 'error', message: 'Service id not found.' });
        }
        var service_id = req.body.service_id;

        var update_column = " updated_at=NOW() ";
        if (req.body.is_active != '' && req.body.is_active != 'undefined' && req.body.is_active != null) {
            update_column += ", is_active='" + req.body.is_active + "'";
        }

        var sql = "UPDATE business_appointment_service SET " + update_column + " WHERE id='" + service_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.', error: err });
            }
            return res.status(200).json({ status: 'success', message: 'Service status changed.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * SAVE SETTING
 */
exports.save_setting = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var update_column = " updated_at=NOW() ";

        if ((req.body.start_time != '') && (req.body.start_time != 'undefined') && (req.body.start_time != 'null')) {
            update_column += ",start_time='" + req.body.start_time + "'";
        } else {
            update_column += ",start_time='" + 00 + "'";
        }
        if (req.body.end_time != '' && req.body.end_time != 'undefined' && req.body.end_time != 'null') {
            update_column += ",end_time='" + req.body.end_time + "'";
        } else {
            update_column += ",end_time='" + 00 + "'";
        }
        if (req.body.advance_booking_start_days != '' && req.body.advance_booking_start_days != 'undefined' && req.body.advance_booking_start_days != 'null') {
            update_column += ",advance_booking_start_days='" + req.body.advance_booking_start_days + "'";
        } else {
            update_column += ",advance_booking_start_days='" + 00 + "'";
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

        var sql = "UPDATE business_appointment_setting SET " + update_column + " WHERE business_id='" + business_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Appointment setting saved successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * GET SETTING
 */
exports.get_setting = async function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        //change here by amit
        // var business_slot = await exports.getBusinessSlot('KIR4WQ4N7KF697HRQ')
        // var business_slot = await exports.getBusinessSlot(business_id)
        // console.log("data" + business_slot)
        // return res.send(business_slot);
        // change end by done
        var person_list = await exports.getAllPersons(business_id);
        var service_list = await exports.getAllServices(business_id);
        var restriction_list = await exports.getAllRestriction(business_id);
        var verbose = {
            person_list: person_list,
            service_list: service_list,
            restriction_list: restriction_list
        };

        var sql = "SELECT start_time,end_time,advance_booking_start_days,advance_booking_end_days, \n\
                    advance_booking_hours,slot_length,booking_per_slot,booking_per_day,announcement \n\
                    FROM business_appointment_setting WHERE business_id='" + business_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }

            return res.status(200).json({ status: 'success', message: 'success', verbose: verbose, data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * API FOR BUSINESS HOUR SLOTS
 */

exports.getBusinessSlot = async function(business_id) {
    var sql = "SELECT working_hours FROM business_master WHERE business_id='" + business_id + "'"
    var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    var today_day = days[new Date().getDay()];
    try {
        var working_hours_type = new Promise(function(resolve, reject) {
            db.query(sql, function(err, result) {
                resolve(result);
            })
        })
        if (((await working_hours_type)[0].working_hours) == 'Select Hours') {
            var sql_select_slot = "SELECT start_hours, end_hours FROM business_hours WHERE business_id = '" + business_id + "' AND day = '" + today_day + "'"
            return new Promise(function(resolve, reject) {
                db.query(sql_select_slot, function(err, result) {
                    if (err) {
                        reject(new Error('Error in query'));
                    } else {
                        resolve(result);
                    }
                })
            })

        }

        // if (((await working_hours_type)[0].working_hours) == 'Always open') {

        // }
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

/**
 * CREATE A NEW MANUAL APPOINTMENT
 */
exports.createAppointment = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.contact == '' || req.body.contact == 'undefined' || req.body.contact == null) {
            return res.status(403).json({ status: 'error', message: 'Contact not found.' });
        } else if (req.body.service_id == '' || req.body.service_id == 'undefined' || req.body.service_id == null) {
            return res.status(403).json({ status: 'error', message: 'Service id not found.' });
        } else if (req.body.person_id == '' || req.body.person_id == 'undefined' || req.body.person_id == null) {
            return res.status(403).json({ status: 'error', message: 'Person id not found.' });
        } else if (req.body.special_notes == '' || req.body.special_notes == 'undefined' || req.body.special_notes == null) {
            return res.status(403).json({ status: 'error', message: 'Special notes not found.' });
        } else if (req.body.created_date == '' || req.body.created_date == 'undefined' || req.body.created_date == null) {
            return res.status(403).json({ status: 'error', message: 'Date not found.' });
        } else if (req.body.created_time == '' || req.body.created_time == 'undefined' || req.body.created_time == null) {
            return res.status(403).json({ status: 'error', message: 'Time not found.' });
        }


        var postval = {
            business_id: business_id,
            name: req.body.name,
            contact: req.body.contact,
            service_id: req.body.service_id,
            person_id: req.body.person_id,
            special_notes: req.body.special_notes,
            created_datetime: req.body.created_date + ' ' + req.body.created_time,
        };

        var sql = "INSERT INTO business_appointment SET ?";
        db.query(sql, postval, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Manual appointment created successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * FIND BUSINESS APPOINTMENT BY ID
 */
exports.findAppointmentById = async function(req, res, next) {
    try {
        if (req.body.appointment_id == '' || req.body.appointment_id == 'undefined' || req.body.appointment_id == null) {
            return res.status(403).json({ status: 'error', message: 'Appointment id not found.' });
        }
        var business_id = req.userdata.business_id;
        var person_list = await exports.getAllPersons(business_id);
        var service_list = await exports.getAllServices(business_id);
        var verbose = {
            person_list: person_list,
            service_list: service_list
        };

        var appointment_id = req.body.appointment_id;
        var sql = "SELECT id,`name`,contact,service_id,person_id,special_notes, \n\
                    DATE_FORMAT(created_datetime, '%d-%m-%Y') AS created_date, \n\
                    DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
                    FROM business_appointment WHERE id='" + appointment_id + "' AND business_id='" + business_id + "' AND deleted_at IS NULL";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'success', verbose: verbose, data: result[0] });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * EDIT BUSINESS APPOINTMENT BY ID
 */
exports.editAppointment = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.appointment_id == '' || req.body.appointment_id == 'undefined' || req.body.appointment_id == null) {
            return res.status(403).json({ status: 'error', message: 'Appointment id not found.' });
        }
        var appointment_id = req.body.appointment_id;
        var update_columns = " updated_at=now() ";

        if (req.body.name != '' && req.body.name != 'undefined' && req.body.name != null) {
            update_columns += ", `name`='" + req.body.name + "' ";
        }
        if (req.body.contact != '' && req.body.contact != 'undefined' && req.body.contact != null) {
            update_columns += ", `contact`='" + req.body.contact + "' ";
        }
        if (req.body.service_id != '' && req.body.service_id != 'undefined' && req.body.service_id != null) {
            update_columns += ", `service_id`='" + req.body.service_id + "' ";
        }
        if (req.body.person_id != '' && req.body.person_id != 'undefined' && req.body.person_id != null) {
            update_columns += ", `person_id`='" + req.body.person_id + "' ";
        }
        if (req.body.special_notes != '' && req.body.special_notes != 'undefined' && req.body.special_notes != null) {
            update_columns += ", `special_notes`='" + req.body.special_notes + "' ";
        }
        var created_date = '';
        var created_time = '';
        if (req.body.created_date != '' && req.body.created_date != 'undefined' && req.body.created_date != null) {
            created_date = req.body.created_date;
        }
        if (req.body.created_time != '' && req.body.created_time != 'undefined' && req.body.created_time != null) {
            created_time = req.body.created_time;
        }

        if (created_date != '' && created_time != '') {
            var created_datetime = created_date + ' ' + created_time;
            update_columns += ", `created_datetime`='" + created_datetime + "' ";
        }

        var sql = "UPDATE `business_appointment` SET " + update_columns + " WHERE id='" + appointment_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Appointment updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * DELETE MANUAL APPOINTMENT
 */
exports.deleteAppointment = function(req, res, next) {
    try {
        if (req.body.appointment_id == '' || req.body.appointment_id == 'undefined' || req.body.appointment_id == null) {
            return res.status(403).json({ status: 'error', message: 'Appointment id not found.' });
        }
        var business_id = req.userdata.business_id;
        var appointment_id = req.body.appointment_id;

        var sql = "UPDATE business_appointment SET deleted_at = NOW() WHERE id='" + appointment_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Manual appointment deleted successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * FETCH ALL BUSINESS APPOINTMENT
 */
exports.listAllAppointment = async function(req, res, next) {
    try {
        var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        var today_day = days[today.getDay()];
        var business_id = req.userdata.business_id;

        var Condition = " business_id='" + business_id + "' AND deleted_at IS NULL ";

        if (req.body.appointment_date != '' && req.body.appointment_date != 'undefined' && req.body.appointment_date != null) {
            today_date = req.body.appointment_date
        }
        Condition += " AND DATE(created_datetime) = '" + today_date + "' ";
        var sql1 = "SELECT start_time,end_time,slot_length,booking_per_slot FROM business_appointment_setting WHERE business_id='" + business_id + "'";
        db.query(sql1, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            var slot_lenght = result[0].slot_length;
            var count_per_slot = result[0].booking_per_slot;
            var starttime = result[0].start_time;
            var endtime = result[0].end_time;
            if (starttime == null && endtime == null) {
                var sql2 = "SELECT * FROM `business_master` AS bm  WHERE bm.`business_id` = '" + business_id + "'";
                db.query(sql2, async function(err, result1) {
                    if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                    } else {
                        if (result1[0].working_hours == 'Select Hours') {
                            var sql3 = "SELECT start_hours,end_hours FROM `business_hours` WHERE `business_id` ='" + business_id + "' AND `day`='" + today_day + "'";
                            db.query(sql3, async function(err, result2) {
                                if (result2.length > 0) {
                                    var slots = await exports.getAppointmentSlots(business_id, today_date, result2[0].start_hours, result2[0].end_hours, slot_lenght);
                                    return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: result2[0].start_hours, endtime: result2[0].end_hours, slots: slots });
                                } else {
                                    return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: '00:00:00', endtime: '00:00:00', slots: [] });
                                }
                            });
                        } else {
                            var slots = await exports.getAppointmentSlots(business_id, today_date, '00:00:00', '23:59:59', slot_lenght);

                            return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: '00:00:00', endtime: '23:59:59', slots: slots });
                        }
                    }
                });
            } else {
                var sql = "SELECT id,`name`,contact,special_notes, \n\
                DATE_FORMAT(created_datetime, '%d %b') AS created_date, \n\
                DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
                FROM business_appointment WHERE " + Condition;
                db.query(sql, async function(err, result) {
                    var slots = await exports.getAppointmentSlots(business_id, today_date, starttime, endtime, slot_lenght);
                    if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                    } else {
                        if (result != null && result != '') {
                            return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: starttime, endtime: endtime, slots: slots });
                        } else {
                            return res.status(200).json({ status: 'success', message: 'No Data Found', count_per_slot: count_per_slot, starttime: starttime, endtime: endtime, slot_lenght: slot_lenght, slots: [] });
                        }
                    }
                });
            }
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * GET THE APPOINTMENT SLOTS
 */
exports.getAppointmentSlots = async function(business_id, date, starttime, endtime, interval) {
    try {
        return new Promise(async function(resolve, reject) {
            var timeslots = [];
            var startdate_time = date + ' ' + starttime;
            var enddate_time = date + ' ' + endtime;
            var parsestart = Date.parse(startdate_time);
            var parseend = Date.parse(enddate_time);
            var parsestart = Date.parse(startdate_time);
            while (parsestart <= parseend) {
                var timestart = startdate_time;
                startdate_time = newstarttime(startdate_time, interval);
                var timeend = startdate_time;
                var timeslotarray = await timeslotdata(business_id, timestart, timeend);

                if (timeslotarray != 'undefined' && timeslotarray != null && timeslotarray != '') {
                    var startDate = new Date(new Date(timestart).getTime());
                    var endDate = new Date(new Date(timeend).getTime());
                    var data = {
                        "slot_start": ((startDate.getHours().toString().length == 1) ? '0' + startDate.getHours() : startDate.getHours()) + ':' +
                            ((startDate.getMinutes().toString().length == 1) ? '0' + startDate.getMinutes() : startDate.getMinutes()),
                        "slot_end": ((endDate.getHours().toString().length == 1) ? '0' + endDate.getHours() : endDate.getHours()) + ':' +
                            ((endDate.getMinutes().toString().length == 1) ? '0' + endDate.getMinutes() : endDate.getMinutes()),
                        "slot_data": timeslotarray
                    };
                    timeslots.push(data);
                }
                parsestart = Date.parse(startdate_time);
            }
            resolve(timeslots);
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * APPOINTMENT ACCEPT/REJECT/PENDING
 **/
exports.updateAppointmentStatus = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.id == '' || req.body.id == 'undefined' || req.body.id == null) {
            return res.status(403).json({ status: 'error', message: 'Appointment Id Not Found.' });
        } else if (req.body.status == '' || req.body.status == 'undefined' || req.body.status == null) {
            return res.status(403).json({ status: 'error', message: 'Appointment Status Not Found' });
        }
        var appointment_id = req.body.id;

        var update_columns = " updated_at=now() ";

        if (req.body.status != '' && req.body.status != 'undefined' && req.body.status != null) {
            if (req.body.status == 'accepted' || req.body.status == 'rejected' || req.body.status == 'pending') {
                update_columns += ", appointment_status='" + req.body.status + "' ";
                var sql = "UPDATE business_appointment SET " + update_columns + " WHERE id='" + appointment_id + "' AND business_id='" + business_id + "'";
                db.query(sql, function(err, result) {
                    if (err) {
                        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                    }
                    return res.status(200).json({ status: 'success', message: 'Appointment updated successfully.' });
                });
            } else {
                return res.status(200).json({ status: 'error', message: 'Please Send Correct Status' });
            }
        } else {
            return res.status(200).json({ status: 'error', message: 'Please Dont send null status' });
        }

    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

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

function newstarttime(datetime, minutes) {
    // var date = new Date(new Date(datetime).getTime() + minutes * 60000);
    // change the minute wise slot into the hour wise
    var date = new Date(new Date(datetime).getTime() + minutes * 60000);
    var tempTime = ((date.getFullYear().toString().length == 1) ? '0' + date.getFullYear() : date.getFullYear()) + '-' + (((date.getMonth() + 1).toString().length == 1) ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1)) + '-' + ((date.getDate().toString().length == 1) ? '0' + date.getDate() : date.getDate()) + ' ' + ((date.getHours().toString().length == 1) ? '0' + date.getHours() : date.getHours()) + ':' +
        ((date.getMinutes().toString().length == 1) ? '0' + date.getMinutes() : date.getMinutes()) + ':' +
        ((date.getSeconds().toString().length == 1) ? '0' + date.getSeconds() : date.getSeconds());
    return tempTime;
}

async function timeslotdata(business_id, startdate_time, timeend) {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT ba.id, ba.`name`,ba.contact,bpa.`person_name`,bas.`service_name`,ba.special_notes, DATE_FORMAT(created_datetime, '%Y-%m-%d') AS created_date,DATE_FORMAT(created_datetime, '%H:%i') AS created_time FROM business_appointment AS ba LEFT JOIN `business_appointment_person` AS bpa ON  bpa.id=ba.`person_id`LEFT JOIN `business_appointment_service` AS bas ON bas.`id`=ba.`service_id` WHERE ba.business_id='" + business_id + "' \n\
        AND ba.created_datetime>='" + startdate_time + "' AND ba.created_datetime <'" + timeend + "' \n\
        AND ba.deleted_at IS NULL";
        db.query(sql, function(err, result) {
            resolve(result);
        });
    });
}