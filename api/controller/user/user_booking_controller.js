var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var moment = require('moment');
const e = require('express');
const async = require('async');
const { reset } = require('google-distance-matrix');

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

exports.getBookingVerbose = async(req, res, next) => {
    if (!req.body.business_id) {
        return res.status(400).send({ status: 'error', message: 'Business id is missing' });
    }
    business_id = req.body.business_id
    var sql_booking_setting = "SELECT start_time,end_time,slot_length,booking_per_slot,advance_booking_end_days,advance_booking_start_days FROM business_booking_setting WHERE business_id='" + business_id + "'";
    var sql_occasion = 'SELECT * FROM occasion_master'
    try {
        result_occasion = await exports.run_query(sql_occasion)
        result_booking_setting = await exports.run_query(sql_booking_setting)
        if (result_booking_setting[0].slot_length > 24) {
            return res.status(200).send({ status: 'success', message: 'Slot length in business booking setting should be less than 24 hour' });
        }
        available_dates = []
        for (let j = 1; j < result_booking_setting[0].advance_booking_end_days; j++) {
            date = moment().add(j, 'd').toDate()
            available_dates.push([moment(date).format('YYYY-MM-DD'), getDayNameByDate(moment(date).format('YYYY-MM-DD'))])
        }

        today_date = moment().format('YYYY-MM-DD')

        // if req has date then slot is according to the date or it will return today dates

        if (req.body.date) {
            date = req.body.date
        } else {
            date = today_date
        }

        if (result_booking_setting[0].start_time == null || result_booking_setting[0].end_time == null) {
            return res.status(500).send({ status: 'error', message: 'Start time or end time of business is not set' });
        }

        slots_data = await exports.createSlotWithDate(result_booking_setting, date)

        slot_with_detail = new Promise(async(resolve, reject) => {
            available_slot = []
            let count_loop = 0
            for (let i = 0; i < slots_data.slots.length; i++) {
                const slot = slots_data.slots[i];

                count_loop++;
                const time_1 = `${slot.slot[0]}:00:00`
                const time_2 = `${slot.slot[1]}:00:00`
                const start_slot = `${date} ${time_1}`
                const end_slot = `${date} ${time_2}`

                sql_count_booking = `SELECT COUNT(user_id) as count FROM business_booking WHERE business_id = '${business_id}'  AND created_datetime >= '${start_slot}' AND created_datetime < '${end_slot}' AND deleted_at IS NULL   `
                try {
                    result_count_booking = await exports.run_query(sql_count_booking)
                    if (result_count_booking[0].count < result_booking_setting[0].booking_per_slot) {
                        available_slot.push([time_1, time_2])
                    }
                    if (count_loop == slots_data.slots.length) {
                        resolve(available_slot)
                    }

                } catch (error) {
                    return res.status(400).send({ status: 'error', message: 'Something went wrong', error });
                }
            }
        })

        available_slots = await slot_with_detail
        return res.status(200).json({ status: 'success', message: 'success', data: { available_dates, date: date, slots: available_slots, occasion: result_occasion } });
    } catch (error) {
        return res.status(400).send({ status: 'error', message: 'Something went wrong', error });
    }
}

// table name business_booking set and update
exports.setBookTable = async function(req, res, next) {
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

        if (req.body.occasion_id != '') {
            data_to_insert.occasion_id = req.body.occasion_id
        }

        sql_booking_setting = `SELECT business_id,start_time,end_time,advance_booking_start_days,advance_booking_hours,slot_length,booking_per_slot,booking_per_day FROM business_booking_setting WHERE business_id = '${business_id}'`
        result_booking_setting = await exports.run_query(sql_booking_setting)
        if (req.body.date_time) {
            try {
                date_time = parseInt(req.body.date_time.substring(10, 13))
                start_time = parseInt(result_booking_setting[0].start_time.substring(0, 2))
                end_time = parseInt(result_booking_setting[0].end_time.substring(0, 2))
                console.log(date_time, start_time, end_time)
            } catch (error) {
                return res.status(500).send({ status: "failed", message: "Something went wrong", error: error })
            }
            if (date_time >= start_time && date_time <= end_time) {
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
            } else {
                res.status(200).send({ status: "success", message: "Business is not available at this time" })
            }
        }
    } catch (error) {
        res.status(500).send({ status: "failed", message: "Something went wrong", error: error })
    }
}

// get all booking by user_id
exports.getBookTable = async function(req, res, next) {
    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
        var condition = " WHERE b_b.user_id = '" + req.body.user_id + "' AND b_b.deleted_at IS NULL GROUP BY b_b.id"
    } else if (req.userdata.id) {
        var condition = " WHERE b_b.user_id = '" + req.userdata.id + "' AND b_b.deleted_at IS NULL GROUP BY b_b.id"
    } else {
        return res.status(400).json({ status: 'failed', message: 'user_id is missing' });
    }

    var sql = "SELECT b_b.id,b_b.user_id, IF(b_b.user_id = b_b.business_id,1,0) as walk_in,'500' as price, b_m.business_name, IFNULL(AVG(b_r.rating),0) as avg_rating,b_m.business_phone, b_b.business_id,b_b.user_id,b_b.no_of_person,DATE_FORMAT(b_b.created_datetime , '%Y-%m-%d %h:%i:%s') AS created_datetime\n\
    FROM business_booking AS b_b \n\
    JOIN business_master AS b_m \n\
    LEFT JOIN business_ratings AS b_r \n\
    ON b_m.business_id = b_b.business_id \n\
    AND b_r.business_id = b_b.business_id" + condition;


    try {
        result = await exports.run_query(sql)
        var sql_booking_setting = "SELECT slot_length FROM business_booking_setting WHERE business_id='" + result[0].business_id + "'";
        // return res.send(result_booking_setting)
        final_data = []
        async.eachSeries(result, async function(data, callback) {
            var result_booking_setting = await exports.run_query(sql_booking_setting)
            db.query(`SELECT reviews FROM business_reviews WHERE user_id = '${data.user_id}' AND business_id = '${data.business_id}' LIMIT 1`, function(error, results1) {
                if (error) {
                    return res.status(500).send({ status: 'error', message: 'Something went wrong.' });
                }
                if (results1 && results1[0] && results1[0].reviews) {
                    data.review = results1[0].reviews
                } else {
                    data.review = ''
                }
                data.slot_length = result_booking_setting[0].slot_length
                data.slot_date = moment(data.created_datetime).format('Do MMMM')
                data.slot_start_time = `${data.created_datetime.substring(11, 13)}:00`
                data.slot_end_time = `${(parseInt(data.created_datetime.substring(11, 13))+parseInt(result_booking_setting[0].slot_length))}:00`
                final_data.push(data)
                return
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

// making slot of the booking verbose start

getDayNameByDate = (date = false) => {
    if (date) {
        var d = new Date(date);
    } else {
        var d = new Date();
    }
    var weekday = new Array(7);
    weekday[0] = "Sunday";
    weekday[1] = "Monday";
    weekday[2] = "Tuesday";
    weekday[3] = "Wednesday";
    weekday[4] = "Thursday";
    weekday[5] = "Friday";
    weekday[6] = "Saturday";
    var day = weekday[d.getDay()].substring(0, 3);
    return day
}

// exports.getBookingVerbose = async(req, res, next) => {
//     if (!req.body.business_id) {
//         return res.status(400).send({ status: 'error', message: 'Business id is missing' });
//     }
//     business_id = req.body.business_id
//     var sql_booking_setting = "SELECT start_time,end_time,slot_length,booking_per_slot,advance_booking_end_days,advance_booking_start_days FROM business_booking_setting WHERE business_id='" + business_id + "'";

//     try {
//         result_booking_setting = await exports.run_query(sql_booking_setting)
//         today_date = moment().format('yyyy-mm-DD')
//         date = today_date
//         slots_data = await exports.createSlotWithDate(result_booking_setting, date)

//         slot_with_detail = new Promise((resolve, reject) => {
//             available_slot = []
//             let count_loop = 0
//             slots_data.slots.forEach(async(slot, index, array) => {
//                 count_loop++;
//                 const time_1 = `${slot.slot[0]}:00:00`
//                 const time_2 = `${slot.slot[1]}:00:00`
//                 const start_slot = `${date} ${time_1}`
//                 const end_slot = `${date} ${time_2}`

//                 sql_count_booking = `SELECT COUNT(user_id) as count FROM business_booking WHERE business_id = '${business_id}'  AND created_datetime >= '${start_slot}' AND created_datetime < '${end_slot}' AND deleted_at IS NULL   `
//                 try {
//                     result_count_booking = await exports.run_query(sql_count_booking)
//                     console.log(result_booking_setting[0].booking_per_slot)

//                     if (result_count_booking[0].count < result_booking_setting[0].booking_per_slot) {
//                         available_slot.push([time_1, time_2])
//                     }
//                     if (count_loop == array.length) {
//                         resolve(available_slot)
//                     }
//                 } catch (error) {
//                     return res.status(400).send({ status: 'error', message: 'Something went wrong', error });
//                 }
//             });
//         })

//         available_slots = await slot_with_detail
//         setTimeout(() => {
//             return res.status(200).json({ status: 'success', message: 'success', data: { date: date, slots: available_slots } });
//         }, 500);
//     } catch (error) {
//         return res.status(400).send({ status: 'error', message: 'Something went wrong', error });
//     }
// }

// exports.getNumberOfBookingBySlot = async(date, slot) => {
//     return new Promise(async(resolve, reject) => {
//         sql = `SELECT COUNT(user_id) FROM business_booking WHERE user_id = 3`
//         result_count = await exports.run_query(sql)
//         return resolve(result_count)
//     })
// }

exports.createSlotWithDate = async(result_booking_setting, date) => {
    return new Promise(async(resolve, reject) => {
        // create object with date and slots of that date
        temp_slot_detail = {}
        date_1 = moment(date).format('YYYY-MM-DD');
        // creating slot 
        const get_slot = await exports.createSlots(result_booking_setting[0].start_time, result_booking_setting[0].end_time, result_booking_setting[0].slot_length)
        temp_slot_detail.date = date_1
        temp_slot_detail.slots = get_slot
        resolve(temp_slot_detail)
    })

    // return new Promise(async(resolve, reject) => {
    //         // create object with date and slots of that date
    //     for (let i = 0; i < result_booking_setting[0].advance_booking_end_days; i++) {
    //         temp_slot_detail = {}
    //         var date = moment().add(i, 'd').toDate();
    //         date = moment(date).format('YYYY-MM-DD');
    //         // creating slot 
    //         const get_slot = await exports.createSlots(result_booking_setting[0].start_time, result_booking_setting[0].end_time, result_booking_setting[0].slot_length)
    //         temp_slot_detail.date = date
    //         temp_slot_detail.slots = get_slot
    //         final_data_slots.push(temp_slot_detail)
    //     }
    //     resolve(final_data_slots)
    // })
}

exports.createSlots = function(starttime, endtime, interval) {
    return new Promise((resolve, reject) => {
        array_slots = []
        start_time = starttime
        end_time = endtime
        for (let i = parseInt(start_time.substring(0, 2)); i < parseInt(end_time.substring(0, 2)) - interval; i = i + interval) {
            array_slots.push({ slot: [i, i + interval] })
        }
        resolve(array_slots)
    })
}


function newstarttime(datetime, minutes) {
    var date = new Date(new Date(datetime).getTime() + minutes * 60000);
    var tempTime = ((date.getFullYear().toString().length == 1) ? '0' + date.getFullYear() : date.getFullYear()) + '-' + (((date.getMonth() + 1).toString().length == 1) ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1)) + '-' + ((date.getDate().toString().length == 1) ? '0' + date.getDate() : date.getDate()) + ' ' + ((date.getHours().toString().length == 1) ? '0' + date.getHours() : date.getHours()) + ':' +
        ((date.getMinutes().toString().length == 1) ? '0' + date.getMinutes() : date.getMinutes()) + ':' +
        ((date.getSeconds().toString().length == 1) ? '0' + date.getSeconds() : date.getSeconds());
    return tempTime;
}

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

// making slot of the booking verbose end


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