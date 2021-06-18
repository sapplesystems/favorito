const e = require('express');
var db = require('../config/db');

const moment = require('moment')

var today = new Date();
var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();

/**
 * FETCH ALL BUSINESS BOOKING
 */
exports.all_business_booking = async function(req, res, next) {
    try {
        var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        var today_day = days[today.getDay()];
        var business_id = req.userdata.business_id;

        var Condition = " business_id='" + business_id + "' AND deleted_at IS NULL ";

        if (req.body.booking_date != '' && req.body.booking_date != 'undefined' && req.body.booking_date != null) {
            today_date = req.body.booking_date
        }
        Condition += " AND DATE(created_datetime) = '" + today_date + "' ";

        var sql1 = "SELECT start_time,end_time,slot_length,booking_per_slot FROM business_booking_setting WHERE business_id='" + business_id + "'";

        db.query(sql1, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            var slot_lenght = result[0].slot_length;
            var count_per_slot = result[0].booking_per_slot;
            var starttime = result[0].start_time;
            var endtime = result[0].end_time;
            if (slot_lenght == 0) {
                return res.status(500).json({ status: 'error', message: 'Business setting slot length is not saved correctly' });
            }
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
                                    var slots = await exports.getBookingSlots(business_id, today_date, result2[0].start_hours, result2[0].end_hours, slot_lenght);
                                    return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: result2[0].start_hours, endtime: result2[0].end_hours, slots: slots });
                                } else {
                                    return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: '00:00:00', endtime: '00:00:00', slots: [] });
                                }
                            });
                        } else {
                            var slots = await exports.getBookingSlots(business_id, today_date, '00:00:00', '23:59:59', slot_lenght);
                            return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: '00:00:00', endtime: '23:59:59', slots: slots });
                        }
                    }
                });
            } else {

                var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
                DATE_FORMAT(created_datetime, '%d %b') AS created_date, \n\
                DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
                FROM business_booking WHERE " + Condition;
                db.query(sql, async function(err, result) {
                    var slots = await exports.getBookingSlots(business_id, today_date, starttime, endtime, slot_lenght);
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
 * FIND BUSINESS BOOKING BY ID
 */
exports.find_business_booking = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.booking_id == '' || req.body.booking_id == 'undefined' || req.body.booking_id == null) {
            return res.status(403).json({ status: 'error', message: 'Booking id not found.' });
        }
        var booking_id = req.body.booking_id;
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
                    DATE_FORMAT(created_datetime, '%d-%m-%Y') AS created_date, \n\
                    DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
                    FROM business_booking WHERE id='" + booking_id + "' AND business_id='" + business_id + "' AND deleted_at IS NULL";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            if (result.length > 0) {
                return res.status(200).json({ status: 'success', message: 'success', data: result[0] });
            } else {
                return res.status(200).json({ status: 'success', message: 'No data found for this Booking', data: [] });
            }

        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * EDIT BUSINESS BOOKING BY ID
 */
exports.edit_business_booking = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.booking_id == '' || req.body.booking_id == 'undefined' || req.body.booking_id == null) {
            return res.status(403).json({ status: 'error', message: 'Booking id not found.' });
        }
        var booking_id = req.body.booking_id;
        var update_columns = " updated_at=now() ";

        if (req.body.name != '' && req.body.name != 'undefined' && req.body.name != null) {
            update_columns += ", `name`='" + req.body.name + "' ";
        }
        if (req.body.contact != '' && req.body.contact != 'undefined' && req.body.contact != null) {
            update_columns += ", `contact`='" + req.body.contact + "' ";
        }
        if (req.body.no_of_person != '' && req.body.no_of_person != 'undefined' && req.body.no_of_person != null) {
            update_columns += ", `no_of_person`='" + req.body.no_of_person + "' ";
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

        var sql = "UPDATE `business_booking` SET " + update_columns + " WHERE id='" + booking_id + "'";
        db.query(sql, function(err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
            return res.status(200).json({ status: 'success', message: 'Booking updated successfully.' });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};

/**
 * CREATE A NEW MANUAL BOOKING
 */
exports.create_manual_booking = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.contact == '' || req.body.contact == 'undefined' || req.body.contact == null) {
            return res.status(403).json({ status: 'error', message: 'Contact not found.' });
        } else if (req.body.no_of_person == '' || req.body.no_of_person == 'undefined' || req.body.no_of_person == null) {
            return res.status(403).json({ status: 'error', message: 'Number of person not found.' });
        } else if (req.body.created_date == '' || req.body.created_date == 'undefined' || req.body.created_date == null) {
            return res.status(403).json({ status: 'error', message: 'Date not found.' });
        } else if (req.body.created_time == '' || req.body.created_time == 'undefined' || req.body.created_time == null) {
            return res.status(403).json({ status: 'error', message: 'Time not found.' });
        }

        var postval = {
            business_id: business_id,
            name: req.body.name,
            contact: req.body.contact,
            no_of_person: req.body.no_of_person,
            special_notes: req.body.special_notes,
            created_datetime: req.body.created_date + ' ' + req.body.created_time,
        };

        var sql = "INSERT INTO business_booking SET ?";
        db.query(sql, postval, function(err, result) {
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
exports.delete_manual_booking = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.booking_id == '' || req.body.booking_id == 'undefined' || req.body.booking_id == null) {
            return res.status(403).json({ status: 'error', message: 'Booking id not found.' });
        }

        var booking_id = req.body.booking_id;

        var sql = "UPDATE business_booking SET deleted_at = NOW() WHERE id='" + booking_id + "'";
        db.query(sql, function(err, result) {
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
        db.query(sql, function(err, result) {
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
exports.get_setting = function(req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT start_time,end_time,advance_booking_start_days,advance_booking_end_days, \n\
                    advance_booking_hours,slot_length,booking_per_slot,booking_per_day,announcement \n\
                    FROM business_booking_setting WHERE business_id='" + business_id + "'";
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
 * GET THE BOOKING SLOTS
 */
exports.getBookingSlots = async function(business_id, date, starttime, endtime, interval) {
    try {
        return new Promise(async function(resolve, reject) {
            var timeslots = [];
            var startdate_time = date + ' ' + starttime;
            var enddate_time = date + ' ' + endtime;
            var parsestart = Date.parse(startdate_time);
            var parseend = Date.parse(enddate_time);
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

async function timeslotdata(business_id, startdate_time, timeend) {
    return new Promise(function(resolve, reject) {
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes,DATE_FORMAT(created_datetime, '%Y-%m-%d') AS created_date, DATE_FORMAT(created_datetime, '%H:%i') AS created_time FROM business_booking WHERE business_id='" + business_id + "' \n\
                AND created_datetime>='" + startdate_time + "' AND created_datetime <'" + timeend + "' \n\
                AND deleted_at IS NULL";
        db.query(sql, function(err, result) {
            resolve(result);
        });
    });
}

/**
 * FETCH BOOKING DATA AS PER TIME SLOT
 */
async function getBusinessBookingData(business_id, date, start_time, end_time) {
    var start_datetime = date + ' ' + start_time;
    var end_datetime = date + ' ' + end_time;
    return new Promise(function(resolve, reject) {
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
				DATE_FORMAT(created_datetime, '%d %b') AS created_date, \n\
				DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
				FROM business_booking WHERE business_id='" + business_id + "' \n\
				AND created_datetime>='" + start_datetime + "' AND created_datetime <'" + end_datetime + "' \n\
				AND deleted_at IS NULL";
        db.query(sql, function(err, result) {
            resolve(result);
        });
    });
}
/**
 * ADDING MINUTE IN TIME TO CREATE SLOTS
 */
function addMinutes(time, minutes) {
    var date = new Date(new Date(time).getTime() + minutes * 60000);
    var tempTime = ((date.getHours().toString().length == 1) ? '0' + date.getHours() : date.getHours()) + ':' +
        ((date.getMinutes().toString().length == 1) ? '0' + date.getMinutes() : date.getMinutes()) + ':' +
        ((date.getSeconds().toString().length == 1) ? '0' + date.getSeconds() : date.getSeconds());
    return tempTime;
}

function newstarttime(datetime, minutes) {
    var date = new Date(new Date(datetime).getTime() + minutes * 60000);
    // converting the time in the hour
    // var date = new Date(new Date(datetime).getTime() + minutes * 3600 * 1000);
    var tempTime = ((date.getFullYear().toString().length == 1) ? '0' + date.getFullYear() : date.getFullYear()) + '-' + (((date.getMonth() + 1).toString().length == 1) ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1)) + '-' + ((date.getDate().toString().length == 1) ? '0' + date.getDate() : date.getDate()) + ' ' + ((date.getHours().toString().length == 1) ? '0' + date.getHours() : date.getHours()) + ':' +
        ((date.getMinutes().toString().length == 1) ? '0' + date.getMinutes() : date.getMinutes()) + ':' +
        ((date.getSeconds().toString().length == 1) ? '0' + date.getSeconds() : date.getSeconds());
    return tempTime;
}

exports.setRestrictionDate = async(req, res) => {

    business_id = req.userdata.business_id;

    if (!req.body.start_date) {
        return res.status(400).send({ status: 'error', message: 'start_date is missing' });
    } else {
        startDate = req.body.start_date
    }

    endDate = null

    if (req.body.end_date) {
        endDate = req.body.end_date
    }

    array_restricted_date = []

    startDateMoment = moment(moment(startDate))
    if (endDate) {
        endDateMoment = moment(moment(endDate))
    } else {
        endDateMoment = null
    }

    tempDate = startDateMoment

    if (endDateMoment) {
        while (!tempDate.isAfter(endDateMoment)) {
            array_restricted_date.push([business_id, tempDate.format('YYYY-MM-DD')])
            tempDate = tempDate.add(1, 'day')
        }
    } else {
        array_restricted_date.push([business_id, tempDate.format('YYYY-MM-DD')])
    }

    try {

        // sqlDeleteAllRestriction = `delete from business_booking_restriction where business_id = '${business_id}'`
        // resultDeleteAllRestriction = await exports.run_query(sqlDeleteAllRestriction)
        sqlInsertRestriction = `insert into business_booking_restriction (business_id,restriction_date) values ?`
        resultInsertRestriction = await exports.run_query(sqlInsertRestriction, [array_restricted_date])

        // deleting the duplicate data
        sqlDeleteDuplicate = `DELETE c1 FROM business_booking_restriction c1  
        INNER JOIN business_booking_restriction c2   
        WHERE  
            c1.id < c2.id AND  
            c1.restriction_date = c2.restriction_date;`

        resultDuplicate = await exports.run_query(sqlDeleteDuplicate)
        return res.status(200).json({ status: 'success', message: 'Restriction added successfully' });
    } catch (error) {
        return res.status(500).json({ status: 'failed', message: 'Something went wrong' });
    }
}

exports.getRestrictionDate = async(req, res) => {
    try {
        sqlGetRestriction = `select id as restriction_id, DATE_FORMAT(restriction_date, '%Y-%m-%d') as restriction_date from business_booking_restriction where business_id = '${req.userdata.business_id}' and (restriction_date > NOW() or DATE(restriction_date) = CURDATE()) order by restriction_date asc`
        resultGetRestriction = await exports.run_query(sqlGetRestriction)
            // return res.send(resultGetRestriction)
        if (resultGetRestriction == '') {
            return res.status(200).json({ status: 'success', message: 'There is no restricted dates', date: [] });
        }
        let restrictDate = []
        let dateId = [resultGetRestriction[0].restriction_id]
        let startDate = resultGetRestriction[0].restriction_date
        let endDate = ''
        dayCount = 0
        firstRun = 0
        for (let i = 0; i < resultGetRestriction.length; i++) {
            if (resultGetRestriction[i + 1]) {
                if (moment(moment(moment(startDate).add(dayCount + 1, 'd').toDate()).format('YYYY-MM-DD')).isSame(moment(resultGetRestriction[i + 1].restriction_date).format('YYYY-MM-DD'))) {
                    dayCount++;
                    if (firstRun) {
                        dateId.push(resultGetRestriction[i].restriction_id)
                    } else {
                        dateId.push(resultGetRestriction[i + 1].restriction_id)
                    }
                    endDate = moment(resultGetRestriction[i + 1].restriction_date).format('YYYY-MM-DD')
                } else {
                    if (firstRun) {
                        dateId.push(resultGetRestriction[i].restriction_id)
                    }
                    restrictDate.push({ startDate, endDate, dateIds: dateId })
                    dayCount = 0
                    startDate = moment(resultGetRestriction[i + 1].restriction_date).format('YYYY-MM-DD')
                    endDate = ''
                    dateId = []
                    firstRun = 1
                }
            } else {
                if (firstRun) {
                    dateId.push(resultGetRestriction[i].restriction_id)
                }
                restrictDate.push({ startDate, endDate, dateIds: dateId })
                dayCount = 0
                startDate = moment(resultGetRestriction[i].restriction_date).format('YYYY-MM-DD')
                endDate = ''
                dateId = []
            }

        }
        return res.status(200).json({ status: 'success', message: 'success', date: restrictDate });
    } catch (error) {
        return res.status(500).json({ status: 'failed', message: 'Something went wrong' });
    }
}

exports.deleteRestrictionDate = async(req, res) => {
    if (!req.body.restriction_id) {
        return res.status(400).send({ status: 'error', message: 'restriction_id is missing' });
    }
    try {
        for (let i = 0; i < req.body.restriction_id.length; i++) {
            const id = req.body.restriction_id[i];
            sqlDeleteRestriction = `delete from business_booking_restriction where id = ${id}`
            resultDeleteRestriction = await exports.run_query(sqlDeleteRestriction)
        }
        return res.status(200).json({ status: 'success', message: 'Deleted successfull' });
    } catch (error) {
        return res.status(500).json({ status: 'failed', message: 'Something went wrong' });
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