var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var moment = require('moment');
const e = require('express');
const async = require('async');
// const { reset } = require('google-distance-matrix');


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

// exports.getBookingVerbose = async(req, res, next) => {
//     if (!req.body.business_id) {
//         return res.status(400).send({ status: 'error', message: 'Business id is missing' });
//     }
//     business_id = req.body.business_id
//     var sql_booking_setting = "SELECT start_time,end_time,slot_length,booking_per_slot,advance_booking_end_days,advance_booking_hours,advance_booking_start_days FROM business_booking_setting WHERE business_id='" + business_id + "'";
//     var sql_occasion = 'SELECT * FROM occasion_master'
//     var sql_business_name = `SELECT business_name FROM business_master WHERE business_id = '${business_id}'`
//     try {
//         var result_business_name = await exports.run_query(sql_business_name)
//         result_occasion = await exports.run_query(sql_occasion)
//         result_booking_setting = await exports.run_query(sql_booking_setting)

//         available_dates = []
//         for (let j = 0; j < result_booking_setting[0].advance_booking_end_days; j++) {
//             date = moment().add(j, 'd').toDate()
//             available_dates.push({ date: moment(date).format('YYYY-MM-DD'), day: getDayNameByDate(moment(date).format('YYYY-MM-DD')) })
//         }

//         today_date = moment().format('YYYY-MM-DD')

//         // if req has date then slot is according to the date or it will return today dates

//         advance_booking_time = null
//         if (req.body.date) {
//             date = req.body.date
//         } else {
//             date = today_date
//         }
//         // check if the date required is today date then set the advance booking time if not then keep the ad null
//         let requiredDate = moment(date)
//         let isToday = false
//         if (requiredDate.isSame(today_date, 'day')) {
//             advance_booking_time = result_booking_setting[0].advance_booking_hours
//             isToday = true
//         }


//         if (result_booking_setting[0].start_time == null || result_booking_setting[0].end_time == null) {
//             return res.status(500).send({ status: 'error', message: 'Booking not available' });
//         }

//         // console.log(advance_booking_time)
//         slots_data = await exports.createSlotWithDate(result_booking_setting, date, advance_booking_time, isToday)

//         slot_with_detail = new Promise(async(resolve, reject) => {
//             available_slot = []
//             let count_loop = 0
//             for (let i = 0; i < slots_data.slots.length; i++) {
//                 const slot = slots_data.slots[i];

//                 count_loop++;
//                 const time_1 = `${slot.slot[0]}:00`
//                 const time_2 = `${slot.slot[1]}:00`
//                 const start_slot = `${date} ${time_1}`
//                 const end_slot = `${date} ${time_2}`

//                 sql_count_booking = `SELECT COUNT(user_id) as count FROM business_booking WHERE business_id = '${business_id}'  AND created_datetime >= '${start_slot}' AND created_datetime < '${end_slot}' AND deleted_at IS NULL   `
//                 try {
//                     result_count_booking = await exports.run_query(sql_count_booking)
//                     if (result_count_booking[0].count < result_booking_setting[0].booking_per_slot) {
//                         available_slot.push({ start_time: time_1, end_time: time_2 })
//                     }
//                     if (count_loop == slots_data.slots.length) {
//                         resolve(available_slot)
//                     }

//                 } catch (error) {
//                     return res.status(400).send({ status: 'error', message: 'Something went wrong', error });
//                 }
//             }
//         })

//         available_slots = await slot_with_detail
//         return res.status(200).json({ status: 'success', message: 'success', data: { business_name: result_business_name[0].business_name, available_dates, date: date, slots: available_slots, occasion: result_occasion } });
//     } catch (error) {
//         return res.status(400).send({ status: 'error', message: 'Something went wrong', error });
//     }
// }

exports.getBookingVerbose = async(req, res, next) => {
    if (!req.body.business_id) {
        return res.status(400).send({ status: 'error', message: 'Business id is missing' });
    }
    business_id = req.body.business_id
    var sql_booking_setting = "SELECT business_id,start_time,end_time,slot_length,booking_per_slot,booking_per_day, advance_booking_end_days,advance_booking_hours,advance_booking_start_days FROM business_booking_setting WHERE business_id='" + business_id + "'";
    var sql_occasion = 'SELECT * FROM occasion_master'
    var sql_business_name = `SELECT business_name FROM business_master WHERE business_id = '${business_id}'`
    try {
        var result_business_name = await exports.run_query(sql_business_name)
        result_occasion = await exports.run_query(sql_occasion)
        result_booking_setting = await exports.run_query(sql_booking_setting)
        available_dates = []
        for (let j = 0; j <= result_booking_setting[0].advance_booking_end_days; j++) {
            date = moment().add(j, 'd').toDate()

            // checking the count from the date.

            sqlCheckCountDate = `select count(*) as count from business_booking where business_id = '${business_id}' and date(created_datetime) = '${moment(date).format('YYYY-MM-DD')}' and deleted_at is null`

            resultCheckCountDate = await exports.run_query(sqlCheckCountDate)
            if (resultCheckCountDate[0].count < result_booking_setting[0].booking_per_day) {
                available_dates.push({ date: moment(date).format('YYYY-MM-DD'), day: getDayNameByDate(moment(date).format('YYYY-MM-DD')) })
            }
        }
        today_date = moment().format('YYYY-MM-DD')

        // if req has date then slot is according to the date or it will return today dates
        advance_booking_time = null
        if (req.body.date) {
            date = req.body.date
        } else {
            date = available_dates[0].date
        }
        // check if the date required is today date then set the advance booking time if not then keep the ad null
        let requiredDate = moment(date)
        let isToday = false
        if (requiredDate.isSame(today_date, 'day')) {
            advance_booking_time = result_booking_setting[0].advance_booking_hours
            isToday = true
        }


        if (result_booking_setting[0].start_time == null || result_booking_setting[0].end_time == null) {
            return res.status(500).send({ status: 'error', message: 'Booking not available' });
        }

        // console.log(advance_booking_time)
        slots_data = await exports.createSlotWithDate(result_booking_setting, date, advance_booking_time, isToday)
        slot_with_detail = new Promise(async(resolve, reject) => {
            available_slot = []
            let count_loop = 0
            for (let i = 0; i < slots_data.slots.length; i++) {
                const slot = slots_data.slots[i];

                count_loop++;
                const time_1 = `${slot.slot[0]}:00`
                const time_2 = `${slot.slot[1]}:00`
                const start_slot = `${date} ${time_1}`
                const end_slot = `${date} ${time_2}`

                sql_count_booking = `SELECT COUNT(user_id) as count FROM business_booking WHERE business_id = '${business_id}'  AND created_datetime >= '${start_slot}' AND created_datetime < '${end_slot}' AND deleted_at IS NULL   `
                try {
                    result_count_booking = await exports.run_query(sql_count_booking)
                    if (result_count_booking[0].count < result_booking_setting[0].booking_per_slot) {
                        available_slot.push({ start_time: time_1, end_time: time_2 })
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

        return res.status(200).json({ status: 'success', message: 'success', data: { business_name: result_business_name[0].business_name, available_dates, date: date, slots: available_slots, occasion: result_occasion } });
    } catch (error) {
        return res.status(400).send({ status: 'error', message: 'Something went wrong', error });
    }
}

// table name business_booking set and update
exports.setBookTable = async function(req, res, next) {
    try {
        console.log(req.body)
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
                        return res.status(200).send({ status: "success", message: "Booking successfull" })
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
exports.getBookingAndAppointment = async function(req, res, next) {
    // getting the all appointment detail
    var business_id = null
    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
        user_id = req.body.user_id
    } else {
        user_id = req.userdata.id
    }
    if (req.body.business_id) {
        business_id = req.body.business_id
    }

    if (business_id != null) {
        var sql_get_appointment = "SELECT b_a.id, b_a.business_id, IFNULL(b_m.business_name,'') as business_name, IFNULL(b_m.business_phone,'') as business_phone, IFNULL(b_a_p.person_email,'') as person_email , b_a.special_notes,if(b_a.created_datetime < NOW() ,'completed', if(b_a.deleted_at IS NOT NULL,'cancelled','upcoming'))  as status ,DATE_FORMAT(b_a.created_datetime , '%Y%m%d%h%i%s') as time, DATE_FORMAT(b_a.created_datetime , '%Y-%m-%d %h:%i:%s') AS created_datetime\n\
        FROM business_appointment as b_a \n\
        JOIN business_appointment_person as b_a_p \n\
        JOIN business_master as b_m \n\
        ON b_m.business_id= b_a.business_id \n\
        AND b_a.person_id = b_a_p.id \n\
        WHERE b_a.user_id = '" + user_id + "' AND b_a.business_id = '" + business_id + "' GROUP BY id ORDER BY b_a.created_datetime DESC"
        appointment_data = await exports.run_query(sql_get_appointment);
    } else {
        var sql_get_appointment = "SELECT b_a.id, b_a.business_id, IFNULL(b_m.business_name,'') as business_name, IFNULL(b_m.business_phone,'') as business_phone, IFNULL(b_a_p.person_email,'') as person_email , b_a.special_notes,if(b_a.created_datetime < NOW() ,'completed', if(b_a.deleted_at IS NOT NULL,'cancelled','upcoming'))  as status ,DATE_FORMAT(b_a.created_datetime , '%Y%m%d%h%i%s') as time, DATE_FORMAT(b_a.created_datetime , '%Y-%m-%d %h:%i:%s') AS created_datetime\n\
        FROM business_appointment as b_a \n\
        JOIN business_appointment_person as b_a_p \n\
        JOIN business_master as b_m \n\
        ON b_m.business_id= b_a.business_id \n\
        AND b_a.person_id = b_a_p.id \n\
        WHERE b_a.user_id = '" + user_id + "' GROUP BY id ORDER BY b_a.created_datetime DESC"
        appointment_data = await exports.run_query(sql_get_appointment);
    }
    // getting the all booking detail

    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
        if (business_id != null) {
            var condition = " WHERE b_b.user_id = '" + req.body.user_id + "' AND b_b.business_id = '" + business_id + "' AND b_b.deleted_at IS NULL GROUP BY b_b.id ORDER BY created_datetime DESC"
        } else {
            var condition = " WHERE b_b.user_id = '" + req.body.user_id + "' AND b_b.deleted_at IS NULL GROUP BY b_b.id ORDER BY created_datetime DESC"
        }
    } else if (req.userdata.id) {
        if (business_id != null) {
            var condition = " WHERE b_b.user_id = '" + req.userdata.id + "' AND b_b.business_id = '" + business_id + "' GROUP BY b_b.id ORDER BY created_datetime DESC"
        } else {
            var condition = " WHERE b_b.user_id = '" + req.userdata.id + "' GROUP BY b_b.id ORDER BY created_datetime DESC"
        }
    } else {
        return res.status(400).json({ status: 'failed', message: 'user_id is missing' });
    }

    var sql = "SELECT b_b.id, IF(b_b.user_id = b_b.business_id,1,0) as walk_in, b_m.business_name, IFNULL(AVG(b_r.rating),0) as avg_rating,b_m.business_phone,b_b.special_notes as special_notes, b_b.business_id,b_b.no_of_person,if(b_b.created_datetime < NOW() ,'rejected', if(b_b.deleted_at IS NOT NULL,'cancelled','upcoming'))  as status ,DATE_FORMAT(b_b.created_datetime , '%Y%m%d%h%i%s') as time,DATE_FORMAT(b_b.created_datetime , '%Y-%m-%d %h:%i:%s') AS created_datetime\n\
    FROM business_booking AS b_b \n\
    JOIN business_master AS b_m \n\
    LEFT JOIN business_ratings AS b_r \n\
    ON b_m.business_id = b_b.business_id \n\
    AND b_r.business_id = b_b.business_id" + condition;


    try {
        result = await exports.run_query(sql)
        if (result == '') {
            return res.status(200).send({ status: 'success', message: 'Data not found', data: [] })
        }
        var sql_booking_setting = "SELECT slot_length FROM business_booking_setting WHERE business_id='" + result[0].business_id + "'";
        booking_Data = []
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
                    // data.slot_date = moment(data.created_datetime).format('Do MMMM')
                    // data.slot_start_time = `${data.created_datetime.substring(11, 13)}:00`
                    // data.slot_end_time = `${(parseInt(data.created_datetime.substring(11, 13))+parseInt(result_booking_setting[0].slot_length))}:00`
                booking_Data.push(data)
                return
            });
        }, function(err, results) {
            final_array = []
            if (booking_Data != '') {
                booking_Data_length = booking_Data.length
            }
            if (appointment_data != '') {
                appointment_data_length = appointment_data.length
            }
            final_length = booking_Data.length > appointment_data.length ? booking_Data.length : appointment_data.length

            // return res.send({ t: appointment_data[appointment_data_length] })

            for (let i = 0; i < final_length; i++) {
                if (booking_Data[i] != undefined) {
                    final_array.push(booking_Data[i])
                }
                if (appointment_data[i] != undefined) {
                    final_array.push(appointment_data[i])
                }
            }

            final_array.sort(function(a, b) { return b.time - a.time });
            if (final_array == '') {
                return res.status(200).send({ status: 'success', message: 'Data not found', data: final_array })
            }
            return res.status(200).send({ status: 'success', message: 'Success', data: final_array })
        });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong.', error });
    }
}

// get all booking by user_id

exports.getBookTable = async function(req, res, next) {
    var business_id = null
    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
        user_id = req.body.user_id
    } else {
        user_id = req.userdata.id
    }
    if (req.body.business_id) {
        business_id = req.body.business_id
    }
    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
        if (business_id != null) {
            var condition = " WHERE b_b.user_id = '" + req.body.user_id + "' AND b_b.business_id = '" + business_id + "' GROUP BY b_b.id ORDER BY created_datetime DESC"
                // var condition = " WHERE b_b.user_id = '" + req.body.user_id + "' AND b_b.business_id = '" + business_id + "' AND b_b.deleted_at IS NULL GROUP BY b_b.id ORDER BY created_datetime DESC"
        } else {
            var condition = " WHERE b_b.user_id = '" + req.body.user_id + "' GROUP BY b_b.id ORDER BY created_datetime DESC"
        }
    } else if (req.userdata.id) {
        if (business_id != null) {
            var condition = " WHERE b_b.user_id = '" + req.userdata.id + "' AND b_b.business_id = '" + business_id + "' GROUP BY b_b.id ORDER BY created_datetime DESC"
        } else {
            var condition = " WHERE b_b.user_id = '" + req.userdata.id + "' GROUP BY b_b.id ORDER BY created_datetime DESC"
        }
    } else {
        return res.status(400).json({ status: 'failed', message: 'user_id is missing' });
    }

    var sql = "SELECT b_b.id,b_b.name as name, IF(b_b.user_id = b_b.business_id,1,0) as walk_in, b_m.business_name, IFNULL(AVG(b_r.rating),0) as avg_rating,b_m.business_phone,if(b_b.created_datetime < NOW() ,'completed', if(b_b.deleted_at IS NOT NULL,'cancelled','upcoming'))  as status, b_b.special_notes as special_notes, b_b.business_id,b_b.no_of_person,DATE_FORMAT(b_b.created_datetime , '%Y%m%d%H%i%s') as time,DATE_FORMAT(b_b.created_datetime , '%Y-%m-%d %H:%i:%s') AS created_datetime\n\
    FROM business_booking AS b_b \n\
    JOIN business_master AS b_m \n\
    LEFT JOIN business_ratings AS b_r \n\
    ON b_m.business_id = b_b.business_id \n\
    AND b_r.business_id = b_b.business_id" + condition;

    try {
        result = await exports.run_query(sql)
        if (result == '') {
            return res.status(200).send({ status: 'success', message: 'Data not found', data: [] })
        }
        var sql_booking_setting = "SELECT slot_length FROM business_booking_setting WHERE business_id='" + result[0].business_id + "'";
        final_data = []

        for (let i = 0; i < result.length; i++) {
            var result_booking_setting = await exports.run_query(sql_booking_setting)
            sql1 = `SELECT reviews FROM business_reviews WHERE user_id = '${result[i].user_id}' AND business_id = '${result[i].business_id}' LIMIT 1`

            sql_business_detail = `select business_name,business_phone from business_master where business_id = '${result[i].business_id}'`
            result_business_detail = await exports.run_query(sql_business_detail)

            results1 = await exports.run_query(sql1)
            if (results1 && results1[0] && results1[0].reviews) {
                result[i].review = results1[0].reviews
            } else {
                result[i].review = ''
            }
            result[i].slot_length = result_booking_setting[0].slot_length
            result[i].business_name = result_business_detail[0].business_name
            result[i].business_phone = result_business_detail[0].business_phone
            final_data.push(result[i])
        }
        if (final_data == '') {
            return res.status(200).send({ status: 'success', message: 'Data not found', data: final_data })
        }
        return res.status(200).send({ status: 'success', message: 'Success', data: final_data })
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


// exports.createSlotWithDate = async(result_booking_setting, date, advance_booking_hours, isToday) => {
//     return new Promise(async(resolve, reject) => {
//         // create object with date and slots of that date
//         temp_slot_detail = {}
//         date_1 = moment(date).format('YYYY-MM-DD');
//         // creating slot 
//         const get_slot = await exports.createSlots(result_booking_setting[0].start_time, result_booking_setting[0].end_time, result_booking_setting[0].slot_length, advance_booking_hours, isToday)
//         temp_slot_detail.date = date_1
//         temp_slot_detail.slots = get_slot
//         resolve(temp_slot_detail)
//     })

// }

exports.createSlotWithDate = async(result_booking_setting, date, advance_booking_hours, isToday) => {
    return new Promise(async(resolve, reject) => {
        // create object with date and slots of that date
        temp_slot_detail = {}
        date_1 = moment(date).format('YYYY-MM-DD');
        // creating slot 
        const get_slot = await exports.createSlots(result_booking_setting[0].start_time, result_booking_setting[0].end_time, result_booking_setting[0].slot_length, advance_booking_hours, isToday, result_booking_setting, date_1)
        temp_slot_detail.date = date_1
        temp_slot_detail.slots = get_slot
        resolve(temp_slot_detail)
    })
}

// exports.createSlots = function(starttime, endtime, interval, advance_booking_hours, isToday) {
//     return new Promise((resolve, reject) => {
//         array_slots = []
//         start_time = starttime
//         end_time = endtime
//         current_time = moment()
//         if (isToday && moment(`${moment(current_time)}`).isAfter(moment(`${moment(current_time).format('YYYY-MM-DD')} ${start_time}`)) && moment(`${moment(current_time)}`).isBefore(moment(`${moment(current_time).format('YYYY-MM-DD')} ${end_time}`))) {
//             start_time = current_time.format('HH:mm:ss')
//         }
//         start_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${start_time}`)
//         if (advance_booking_hours) {
//             start_time = moment(start_time, 'HH:mm').add(advance_booking_hours, 'minutes')
//         }
//         end_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${end_time}`)
//         while (start_time.isBefore(end_time)) {
//             // adding the minutes
//             array_slots.push({
//                 slot: [start_time.format('HH:mm'), moment(start_time, 'HH:mm').add(interval, 'minutes').format('HH:mm')]
//             })
//             start_time = moment(start_time, 'HH:mm').add(interval, 'minutes')
//         }
//         resolve(array_slots)
//     })
// }


exports.createSlots = async function(starttime, endtime, interval, advance_booking_hours, isToday, result_booking_setting, data_1) {
    return new Promise(async(resolve, reject) => {
        array_slots = []
        array_slots_final = []
        start_time = starttime
        end_time = endtime
        current_time = moment()

        start_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${start_time}`)
        if (advance_booking_hours) {
            start_time = moment(start_time, 'HH:mm').add(advance_booking_hours, 'minutes')
        }
        end_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${end_time}`)
        while (start_time.isBefore(end_time)) {
            // adding the minutes
            array_slots.push({
                slot: [start_time.format('HH:mm'), moment(start_time, 'HH:mm').add(interval, 'minutes').format('HH:mm')]
            })
            start_time = moment(start_time, 'HH:mm').add(interval, 'minutes')
        }

        if (isToday) {
            for (let i = 0; i < array_slots.length; i++) {
                current_time = moment()
                const slot = array_slots[i];
                start_slot_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${slot.slot[0]}`)

                // getting the count between the slot by substracting the 1 minute to manage the duplicate data

                // start time slot
                s_slot = `${date_1} ${slot.slot[0]}`

                // end time slot
                e_slot = moment(`${date_1} ${slot.slot[1]}`).subtract(1, 'minutes').format('YYYY-MM-DD HH:mm:ss')

                sqlGetCountBookedSlot = `select count(*) as count from business_booking where business_id = '${result_booking_setting[0].business_id}' and created_datetime between '${s_slot}' and '${e_slot}' and deleted_at is null`

                resultGetCountBookedSlot = await exports.run_query(sqlGetCountBookedSlot)

                // select query to get the slot lenght
                if (current_time.isBefore(start_slot_time) && result_booking_setting[0].booking_per_slot > resultGetCountBookedSlot[0].count) {
                    array_slots_final.push(slot)
                }
            }
        } else {
            // select query to get the slot lenght
            array_slots_final = [...array_slots]

        }

        resolve(array_slots_final)
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