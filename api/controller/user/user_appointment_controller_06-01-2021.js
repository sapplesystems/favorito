var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var moment = require('moment');
var today = new Date();

exports.setAppointment = function(req, res, next) {
    try {

        if (req.body.user_id == '' || req.body.user_id == 'undefined' || req.body.user_id == null) {
            return res.status(403).json({ status: 'error', message: 'user_id not found.' });
        } else if (req.body.service_id == '' || req.body.service_id == 'undefined' || req.body.service_id == null) {
            return res.status(403).json({ status: 'error', message: 'Service type is not found.' });
        } else if (req.body.person_id == '' || req.body.person_id == 'undefined' || req.body.person_id == null) {
            return res.status(403).json({ status: 'error', message: 'Person is not found.' });
        } else if (req.body.date_time == '' || req.body.date_time == 'undefined' || req.body.date_time == null) {
            return res.status(403).json({ status: 'error', message: 'Date time is not found.' });
        } else if (req.body.business_id == '' || req.body.business_id == 'undefined' || req.body.business_id == null) {
            return res.status(403).json({ status: 'error', message: 'Business id is not found.' });
        } else if (req.body.phone == '' || req.body.phone == 'undefined' || req.body.phone == null) {
            return res.status(403).json({ status: 'error', message: 'Phone number is not found.' });
        }

        dataToInsert = {
            user_id: req.body.user_id,
            service_id: req.body.service_id,
            person_id: req.body.person_id,
            created_datetime: req.body.date_time,
            name: req.body.name,
            contact: req.body.phone,
            business_id: req.body.business_id,
        }

        if (req.body.special_notes != '') {
            dataToInsert.special_notes = req.body.special_notes
        }

        var sql = "INSERT INTO business_appointment SET ?";
        db.query(sql, dataToInsert, function(error, result) {
            if (error) {
                return res.status(500).send({ status: "failed", message: "Something went wrong", error: error })
            } else {
                return res.status(200).send({ status: "success", message: "Appointment is booked" })
            }
        })
    } catch (error) {
        res.status(500).send({ status: "failed", message: "Something went wrong", error: error })
    }
}

// exports.allAppointments = async function(req, res, next) {
//     try {
//         var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
//         var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//         var today_day = days[today.getDay()];
//         var business_id = req.userdata.business_id;

//         var Condition = " business_id='" + business_id + "' AND deleted_at IS NULL ";

//         if (req.body.booking_date != '' && req.body.booking_date != 'undefined' && req.body.booking_date != null) {
//             today_date = req.body.booking_date
//         }
//         Condition += " AND DATE(created_datetime) = '" + today_date + "' ";

//         var sql1 = "SELECT start_time,end_time,slot_length,booking_per_slot FROM business_booking_setting WHERE business_id='" + business_id + "'";

//         db.query(sql1, function(err, result) {
//             if (err) {
//                 return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//             }
//             var slot_lenght = result[0].slot_length;
//             var count_per_slot = result[0].booking_per_slot;
//             var starttime = result[0].start_time;
//             var endtime = result[0].end_time;
//             if (starttime == null && endtime == null) {
//                 var sql2 = "SELECT * FROM `business_master` AS bm  WHERE bm.`business_id` = '" + business_id + "'";
//                 db.query(sql2, async function(err, result1) {
//                     if (err) {
//                         return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//                     } else {
//                         if (result1[0].working_hours == 'Select Hours') {
//                             var sql3 = "SELECT start_hours,end_hours FROM `business_hours` WHERE `business_id` ='" + business_id + "' AND `day`='" + today_day + "'";
//                             db.query(sql3, async function(err, result2) {
//                                 if (result2.length > 0) {
//                                     var slots = await exports.getBookingSlots(business_id, today_date, result2[0].start_hours, result2[0].end_hours, slot_lenght);
//                                     return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: result2[0].start_hours, endtime: result2[0].end_hours, slots: slots });
//                                 } else {
//                                     return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: '00:00:00', endtime: '00:00:00', slots: [] });
//                                 }
//                             });
//                         } else {
//                             var slots = await exports.getBookingSlots(business_id, today_date, '00:00:00', '23:59:59', slot_lenght);
//                             return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: '00:00:00', endtime: '23:59:59', slots: slots });
//                         }
//                     }
//                 });
//             } else {

//                 var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
//                 DATE_FORMAT(created_datetime, '%d %b') AS created_date, \n\
//                 DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
//                 FROM business_booking WHERE " + Condition;
//                 db.query(sql, async function(err, result) {
//                     var slots = await exports.getBookingSlots(business_id, today_date, starttime, endtime, slot_lenght);
//                     if (err) {
//                         return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//                     } else {
//                         if (result != null && result != '') {
//                             return res.status(200).json({ status: 'success', message: 'success', count_per_slot: count_per_slot, slot_lenght: slot_lenght, starttime: starttime, endtime: endtime, slots: slots });
//                         } else {
//                             return res.status(200).json({ status: 'success', message: 'No Data Found', count_per_slot: count_per_slot, starttime: starttime, endtime: endtime, slot_lenght: slot_lenght, slots: [] });
//                         }
//                     }
//                 });
//             }
//         });

//     } catch (e) {
//         return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//     }
// };


// exports.getBookingSlots = async function(business_id, date, starttime, endtime, interval) {
//     try {
//         return new Promise(async function(resolve, reject) {
//             var timeslots = [];
//             var startdate_time = date + ' ' + starttime;
//             var enddate_time = date + ' ' + endtime;
//             var parsestart = Date.parse(startdate_time);
//             var parseend = Date.parse(enddate_time);
//             while (parsestart <= parseend) {
//                 var timestart = startdate_time;
//                 startdate_time = newstarttime(startdate_time, interval);
//                 var timeend = startdate_time;

//                 var timeslotarray = await timeslotdata(business_id, timestart, timeend);
//                 if (timeslotarray != 'undefined' && timeslotarray != null && timeslotarray != '') {
//                     var startDate = new Date(new Date(timestart).getTime());
//                     var endDate = new Date(new Date(timeend).getTime());
//                     var data = {
//                         "slot_start": ((startDate.getHours().toString().length == 1) ? '0' + startDate.getHours() : startDate.getHours()) + ':' +
//                             ((startDate.getMinutes().toString().length == 1) ? '0' + startDate.getMinutes() : startDate.getMinutes()),
//                         "slot_end": ((endDate.getHours().toString().length == 1) ? '0' + endDate.getHours() : endDate.getHours()) + ':' +
//                             ((endDate.getMinutes().toString().length == 1) ? '0' + endDate.getMinutes() : endDate.getMinutes()),
//                         "slot_data": timeslotarray
//                     };
//                     timeslots.push(data);
//                 }
//                 parsestart = Date.parse(startdate_time);
//             }
//             resolve(timeslots);
//         });
//     } catch (e) {
//         return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
//     }
// };

// async function timeslotdata(business_id, startdate_time, timeend) {
//     return new Promise(function(resolve, reject) {
//         var sql = "SELECT id,`name`,contact,no_of_person,special_notes,DATE_FORMAT(created_datetime, '%Y-%m-%d') AS created_date, DATE_FORMAT(created_datetime, '%H:%i') AS created_time FROM business_booking WHERE business_id='" + business_id + "' \n\
//                 AND created_datetime>='" + startdate_time + "' AND created_datetime <'" + timeend + "' \n\
//                 AND deleted_at IS NULL";
//         db.query(sql, function(err, result) {
//             resolve(result);
//         });
//     });
// }