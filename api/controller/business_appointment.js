var db = require('../config/db');

var today = new Date();
var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();

/**
 * STATIC VARIABLES
 */
exports.dd_verbose = async function (req, res, next) {
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

/**
 * SAVE PERSON
 */
exports.savePerson = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.person_name == '' || req.body.person_name == 'undefined' || req.body.person_name == null) {
            return res.status(403).json({ status: 'error', message: 'Person not found.' });
        }

        var postval = {
            business_id: business_id,
            person_name: req.body.person_name
        };

        var sql = "INSERT INTO business_appointment_person SET ?";
        db.query(sql, postval, function (err, result) {
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
exports.saveService = function (req, res, next) {
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
        db.query(sql, postval, function (err, result) {
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
exports.saveRestriction = function (req, res, next) {
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
        db.query(sql, postval, function (err, result) {
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
exports.getAllPersonList = async function (req, res, next) {
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
exports.getAllServiceList = async function (req, res, next) { 
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
exports.getAllRestrictionList = async function (req, res, next) {
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
exports.getAllPersons = function (business_id) {
    return new Promise(function (resolve, reject) {
        var sql = "SELECT id,person_name,is_active FROM business_appointment_person WHERE business_id='" + business_id + "' AND is_active='1'";
        db.query(sql, function (err, person_list) {
            resolve(person_list);
        });
    });
};

/**
 * GET ALL SERVICES
 */
exports.getAllServices = function (business_id) {
    return new Promise(function (resolve, reject) {
        var sql = "SELECT id,service_name,is_active FROM business_appointment_service WHERE business_id='" + business_id + "' AND is_active='1'";
        db.query(sql, function (err, service_list) {
            resolve(service_list);
        });
    });
};

/**
 * GET ALL RESTRICTIONS
 */
exports.getAllRestriction = function (business_id) {
    return new Promise(function (resolve, reject) {
        var sql = "SELECT id, \n\
                person_id, (SELECT person_name FROM business_appointment_person WHERE id=person_id) AS person_name, \n\
                service_id, (SELECT service_name FROM business_appointment_service WHERE id=service_id) AS service_name, \n\
                CONCAT(DATE_FORMAT(start_datetime, '%d'), '-', DATE_FORMAT(end_datetime, '%d %b')) AS date_time \n\
                FROM business_appointment_restriction \n\
                WHERE business_id='"+ business_id + "' AND deleted_at IS NULL";
        db.query(sql, function (err, restriction_list) {
            resolve(restriction_list);
        });
    });
};


/**
 * DELETE RESTRICTION
 */
exports.deleteRestriction = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.restriction_id == '' || req.body.restriction_id == 'undefined' || req.body.restriction_id == null) {
            return res.status(403).json({ status: 'error', message: 'Restriction id not found.' });
        }

        var sql = "UPDATE business_appointment_restriction SET deleted_at=NOW() WHERE id='" + req.body.restriction_id + "'";
        db.query(sql, function (err, result) {
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
exports.getRestrictionDetail = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.restriction_id == '' || req.body.restriction_id == 'undefined' || req.body.restriction_id == null) {
            return res.status(403).json({ status: 'error', message: 'Restriction id not found.' });
        }
        var restriction_id = req.body.restriction_id;
        var sql = "SELECT person_id, service_id, start_datetime, end_datetime FROM business_appointment_restriction WHERE id='" + restriction_id + "' AND deleted_at IS NULL";
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
 * EDIT RESTRICTION
 */
exports.editRestriction = function (req, res, next) {
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
        db.query(sql, function (err, result) {
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
 * SAVE SETTING
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

        var sql = "UPDATE business_appointment_setting SET " + update_column + " WHERE business_id='" + business_id + "'";
        db.query(sql, function (err, result) {
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
exports.get_setting = async function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
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
                    FROM business_appointment_setting WHERE business_id='"+ business_id + "'";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }

            return res.status(200).json({ status: 'success', message: 'success', verbose: verbose, data: result });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};