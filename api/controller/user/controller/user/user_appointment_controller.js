var db = require('../../config/db');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';
var moment = require('moment');
var today = new Date();




exports.verboseService = async(req, res) => {
    if (!req.body.business_id) {
        return res.status(400).send({ status: 'error', message: 'Business id is missing' });
    } else {
        business_id = req.body.business_id
    }

    // if (!req.body.date) {
    //     return res.status(400).send({ status: 'error', message: 'date is missing' });
    // } else {
    //     date = req.body.date
    // }
    try {
        sqlGetService = `select id, service_name,is_active as status from business_appointment_service where business_id = '${business_id}'`
        //  and is_active = 1`

        resultGetService = await exports.run_query(sqlGetService)

        // sqlSelectRestriction = `select id,service_id,start_datetime,end_datetime from business_appointment_restriction where business_id = '${business_id}' and ( (DATE('${date}') > DATE(start_datetime) and DATE(end_datetime) > DATE('${date}')) or (DATE('${date}') = DATE(start_datetime) or (DATE('${date}') = DATE(end_datetime)))) and deleted_at is null group by service_id `

        // resultRestriction = await exports.run_query(sqlSelectRestriction)


        // for (let i = 0; i < resultRestriction.length; i++) {
        //     const res = resultRestriction[i];
        //     for (let j = 0; j < resultGetService.length; j++) {
        //         const ser = resultGetService[j];
        //         if (res.service_id == ser.id) {
        //             resultGetService.splice(j, 1)
        //         }
        //     }
        // }
        // return res.send({ resultRestriction, resultGetService })

        // var sqlService = "SELECT bas.id as id, bar.id as idr,bas.service_name,bas.is_active as status FROM business_appointment_service bas \n\
        // left join business_appointment_restriction as bar on bas.id = bar.service_id WHERE ((DATE(NOW()) < DATE(bar.start_datetime) or DATE(bar.end_datetime) < DATE(NOW())) AND bas.business_id='" + business_id + "') OR ((DATE(NOW()) < DATE(bar.start_datetime) or DATE(bar.end_datetime) < DATE(NOW())) AND bas.business_id='" + business_id + "' AND bas.id is null) group by bas.id";

        // var sqlService = "SELECT bas.id as ids, bar.id as idr,bas.service_name,bas.is_active as status FROM business_appointment_service bas \n\
        // left join business_appointment_restriction as bar on bas.id = bar.service_id WHERE (DATE(NOW()) < DATE(bar.start_datetime) or DATE(bar.end_datetime) < DATE(NOW())) AND bas.business_id='" + business_id + "' group by bas.id";
        // resultGetService = await exports.run_query(sqlService)
        sqlGetSetting = `select booking_per_slot, advance_booking_start_days,advance_booking_end_days, advance_booking_hours from business_appointment_setting where business_id = '${business_id}'`

        resultGetSetting = await exports.run_query(sqlGetSetting)

        return res.status(200).send({ status: 'success', message: 'success', data: [{ service: resultGetService, setting: resultGetSetting }] });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong', error });
    }
}

exports.getPersonByServiceId = async(req, res) => {
    if (!req.body.business_id) {
        return res.status(400).send({ status: 'error', message: 'Business id is missing' });
    } else {
        business_id = req.body.business_id
    }

    if (!req.body.service_id) {
        return res.status(400).json({ status: 'failed', message: 'service_id is missing' });
    } else {
        var service_id = req.body.service_id
    }

    // if (!req.body.date) {
    //     return res.status(400).json({ status: 'failed', message: 'date is missing' });
    // } else {
    //     var date = req.body.date
    // }

    var sql_get_person_by_service = `SELECT id, business_id, person_name FROM business_appointment_person WHERE service_id = ${service_id} and business_id = '${business_id}'`
    // and is_active = 1

    try {
        var result_get_persons = await exports.run_query(sql_get_person_by_service)

        // sqlSelectRestriction = `select id as restriction_id,person_id,start_datetime,end_datetime from business_appointment_restriction where business_id = '${business_id}' and ( (DATE('${date}') > DATE(start_datetime) and DATE(end_datetime) > DATE('${date}')) or (DATE('${date}') = DATE(start_datetime) or (DATE('${date}') = DATE(end_datetime)))) and deleted_at is null group by person_id `

        // restriction date by range manage in this query
        // sqlSelectRestriction = `select id as restriction_id,person_id,start_datetime,end_datetime from business_appointment_restriction where business_id = '${business_id}' and ( (DATE(NOW()) > DATE(start_datetime) and DATE(end_datetime) > DATE(NOW())) or (DATE(NOW()) = DATE(start_datetime) or (DATE(NOW()) = DATE(end_datetime)))) and deleted_at is null group by person_id `

        // resultRestriction = await exports.run_query(sqlSelectRestriction)

        // return res.send(resultRestriction)

        // for (let i = 0; i < resultRestriction.length; i++) {
        //     const res = resultRestriction[i];
        //     for (let j = 0; j < result_get_persons.length; j++) {
        //         const per = result_get_persons[j];
        //         if (res.person_id == per.id) {
        //             result_get_persons.splice(j, 1)
        //         }
        //     }
        // }



        if (result_get_persons == '') {
            return res.status(200).json({ status: 'success', message: 'There is no person by this service id', data: [] });
        }
        return res.status(200).json({ status: 'success', message: 'success', data: result_get_persons });
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'Something went wrong' });
    }
}


exports.restrictedPersonDateTime = async(req, res) => {
    if (!req.body.business_id) {
        return res.status(400).send({ status: 'error', message: 'Business id is missing' });
    } else {
        business_id = req.body.business_id
    }
    if (!req.body.person_id) {
        return res.status(400).send({ status: 'error', message: 'Person id is missing' });
    } else {
        person_id = req.body.person_id
    }
    try {
        // get restricted date 
        sqlGetRestrictedDateTime = `select DATE_FORMAT( start_datetime, '%Y-%m-%d') as start_datetime,DATE_FORMAT( end_datetime, '%Y-%m-%d') as end_datetime from business_appointment_restriction where business_id = '${business_id}' and person_id = '${person_id}'`
        resultGetRestrictedDateTime = await exports.run_query(sqlGetRestrictedDateTime)

        var sql_booking_setting = "SELECT start_time,end_time,slot_length,booking_per_slot,advance_booking_end_days,booking_per_day,advance_booking_start_days FROM business_appointment_setting WHERE business_id='" + business_id + "'";
        var result_appointment_setting = await exports.run_query(sql_booking_setting)
        restrictedDates = []

        for (let j = 0; j <= result_appointment_setting[0].advance_booking_end_days; j++) {
            date = moment().add(j, 'd').toDate()

            console.log(moment(date).format('YYYY-MM-DD'))
            sqlCountAppointment = `select count(*) as count from business_appointment where business_id = '${business_id}' and  deleted_at is null and date(created_datetime) =  date('${moment(date).format('YYYY-MM-DD')}')`

            resultCountAppointment = await exports.run_query(sqlCountAppointment)

            if (result_appointment_setting[0].booking_per_day <= resultCountAppointment[0].count) {
                restrictedDates.push({ date: moment(date).format('YYYY-MM-DD') })
            }

        }

        return res.status(200).send({ status: 'success', message: 'success', data: [{ restrictedDateTime: resultGetRestrictedDateTime, restrictedDates: restrictedDates }] });
    } catch (error) {
        return res.status(500).send({ status: 'error', message: 'Something went wrong', error });
    }
}

// get verbose appointment function 
exports.getVerboseAppointment = async(req, res, next) => {
    if (!req.body.business_id) {
        return res.status(400).send({ status: 'error', message: 'Business id is missing' });
    }
    business_id = req.body.business_id
    var sql_booking_setting = "SELECT start_time,end_time,slot_length,booking_per_slot,advance_booking_end_days,advance_booking_start_days FROM business_appointment_setting WHERE business_id='" + business_id + "'";
    var sql_get_all_service = `SELECT id,business_id,service_name FROM business_appointment_service WHERE is_active = 1 AND business_id = '${business_id}'`;

    var sql_business_name = `SELECT business_name FROM business_master WHERE business_id = '${business_id}'`
    try {
        var result_business_name = await exports.run_query(sql_business_name)
        var result_get_all_service = await exports.run_query(sql_get_all_service)
        var result_appointment_setting = await exports.run_query(sql_booking_setting)
        available_dates = []
        for (let j = 0; j < result_appointment_setting[0].advance_booking_end_days; j++) {
            date = moment().add(j, 'd').toDate()
            available_dates.push({ date: moment(date).format('YYYY-MM-DD'), day: getDayNameByDate(moment(date).format('YYYY-MM-DD')) })
        }
        today_date = moment().format('YYYY-MM-DD')

        // if req has date then slot is according to the date or it will return today dates

        if (req.body.date) {
            date = req.body.date
        } else {
            date = today_date
        }

        if (result_appointment_setting[0].start_time == null || result_appointment_setting[0].end_time == null) {
            return res.status(500).send({ status: 'error', message: 'Start time or end time of business is not set' });
        }

        slots_data = await exports.createSlotWithDate(result_appointment_setting, date)

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

                sql_count_appointment = `SELECT COUNT(user_id) as count FROM business_appointment WHERE business_id = '${business_id}'  AND created_datetime >= '${start_slot}' AND created_datetime < '${end_slot}' AND deleted_at IS NULL   `
                try {
                    result_count_appointment = await exports.run_query(sql_count_appointment)
                    if (result_count_appointment[0].count < result_appointment_setting[0].booking_per_slot) {
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
        return res.status(200).json({ status: 'success', message: 'success', data: { business_name: result_business_name[0].business_name, available_dates, date: date, slots: available_slots, all_services: result_get_all_service } });
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'Something went wrong', error });
    }
}

exports.getsSlots = async(req, res) => {
    if (!req.body.business_id) {
        return res.status(400).send({ status: 'error', message: 'Business id is missing' });
    } else {
        business_id = req.body.business_id
    }

    if (!req.body.date) {
        return res.status(400).send({ status: 'error', message: 'date is missing' });
    } else {
        date = req.body.date
    }
    if (!req.body.services_id) {
        return res.status(400).send({ status: 'error', message: 'Please Select Service id' });
    } else {
        serviceid = req.body.services_id
    }
    if (!req.body.person_id) {
        return res.status(400).send({ status: 'error', message: 'Please Select Person' });
    } else {
        personid = req.body.person_id
    }

    try {
        let sqlDateCheck=`SELECT * FROM business_appointment_restriction WHERE business_id='${business_id}'
 AND ((person_id=${personid} AND service_id='0') OR (person_id='0' AND service_id =${serviceid}) 
OR (person_id=${personid} AND service_id=${serviceid})) AND '${date}' BETWEEN  DATE(start_datetime) AND DATE(end_datetime) AND deleted_at IS NULL`
        let resultDate = await exports.run_query(sqlDateCheck);
        if(resultDate=='' || resultDate==null || resultDate==undefined){
            let sqlGetCountByDate = `select count(id) as count from business_appointment where business_id = '${business_id}' and date(created_datetime) = '${date}'`
            let resultGetCountByDate = await exports.run_query(sqlGetCountByDate)

            let sqlBookingPerDay = `select booking_per_day from business_appointment_setting where business_id = '${business_id}'`
            let resultBookingPerDay = await exports.run_query(sqlBookingPerDay)

            if (resultBookingPerDay[0].booking_per_day <= resultGetCountByDate[0].count) {
                return res.status(200).json({ status: 'success', message: 'Maximum limit has reached for this day', data: { date: date, slots: [] } });
            }

            var sql_booking_setting = "SELECT business_id,start_time,end_time,slot_length,booking_per_slot,advance_booking_hours,advance_booking_end_days,advance_booking_start_days FROM business_appointment_setting WHERE business_id='" + business_id + "'";
            var result_appointment_setting = await exports.run_query(sql_booking_setting)

            slots_data = await exports.createSlotWithDate(result_appointment_setting, date)

            if (slots_data == '') {
                return res.status(200).json({ status: 'success', message: 'No slot is available', data: slots_data });
            }
            return res.status(200).json({ status: 'success', message: 'success ', data: slots_data });
        }else{
            return res.status(200).json({ status: 'success', message: 'Service/person are restricted for this date',data: { date: date, slots: [] } });
        }
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'Something went wrong', error });
    }

}

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

exports.setAppointmentNote = async function(req, res, next) {
    if (req.body.appointment_id != null && req.body.appointment_id != undefined && req.body.appointment_id != '') {
        var condition = " WHERE id = '" + req.body.appointment_id + "'"
    } else {
        return res.status(403).send({ status: 'failed', message: 'appointment_id is missing' })
    }
    if (req.body.user_notes == null || req.body.user_notes == undefined || req.body.user_notes == '') {
        return res.status(403).send({ status: 'failed', message: 'user_notes is missing' })
    }

    var sql = "UPDATE business_appointment SET updated_at = NOW(), special_notes = '" + req.body.user_notes + "'" + condition;

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

exports.createSlotWithDate = async(result_appointment_setting, date) => {
    return new Promise(async(resolve, reject) => {
        // create object with date and slots of that date
        temp_slot_detail = {}
        date_1 = moment(date).format('YYYY-MM-DD');
        // creating slot 

        today_date = moment().format('YYYY-MM-DD')
        let requiredDate = moment(date)
        let isToday = false
        advance_booking_time = null
        if (requiredDate.isSame(today_date, 'day')) {
            advance_booking_time = result_appointment_setting[0].advance_booking_hours
            isToday = true
        }
        const get_slot = await exports.createSlots(result_appointment_setting[0].start_time, result_appointment_setting[0].end_time, result_appointment_setting[0].slot_length, advance_booking_time, isToday, result_appointment_setting, date_1)
        temp_slot_detail.date = date_1
        temp_slot_detail.slots = get_slot
        resolve(temp_slot_detail)
    })
}


exports.createSlots = async function(starttime, endtime, interval, advance_booking_hours, isToday, result_appointment_setting, data_1) {
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
                current_time = moment().add(advance_booking_hours, 'minutes')
                    // current_time = moment()
                const slot = array_slots[i];
                start_slot_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${slot.slot[0]}`)

                // getting the count between the slot by substracting the 1 minute to manage the duplicate data

                // start time slot
                s_slot = `${date_1} ${slot.slot[0]}`

                // end time slot
                e_slot = moment(`${date_1} ${slot.slot[1]}`).subtract(1, 'minutes').format('YYYY-MM-DD HH:mm:ss')

                sqlGetCountAppointmentSlot = `select count(*) as count from business_appointment where business_id = '${result_appointment_setting[0].business_id}' and created_datetime between '${s_slot}' and '${e_slot}' and deleted_at is null`

                resultGetCountBookedSlot = await exports.run_query(sqlGetCountAppointmentSlot)

                // select query to get the slot lenght
                if (current_time.isBefore(start_slot_time) && result_appointment_setting[0].booking_per_slot > resultGetCountBookedSlot[0].count) {
                    array_slots_final.push({ start_time: slot.slot[0], end_time: slot.slot[1] })
                }
            }
        } else {
            // select query to get the slot lenght
            for (let i = 0; i < array_slots.length; i++) {
                // current_time = moment()
                const slot = array_slots[i];
                // start_slot_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${slot.slot[0]}`)

                // getting the count between the slot by substracting the 1 minute to manage the duplicate data

                // start time slot
                s_slot = `${date_1} ${slot.slot[0]}`

                // end time slot
                e_slot = moment(`${date_1} ${slot.slot[1]}`).subtract(1, 'minutes').format('YYYY-MM-DD HH:mm:ss')

                sqlGetCountAppointmentSlot = `select count(*) as count from business_appointment where business_id = '${result_appointment_setting[0].business_id}' and created_datetime between '${s_slot}' and '${e_slot}' and deleted_at is null`

                resultGetCountBookedSlot = await exports.run_query(sqlGetCountAppointmentSlot)

                // select query to get the slot lenght
                if (result_appointment_setting[0].booking_per_slot > resultGetCountBookedSlot[0].count) {
                    array_slots_final.push({ start_time: slot.slot[0], end_time: slot.slot[1] })
                }
            }

        }

        resolve(array_slots_final)
    })
}



// exports.createSlots = function(starttime, endtime, interval, date) {
//     if( )
//     return new Promise((resolve, reject) => {
//         array_slots = []
//         start_time = starttime
//         end_time = endtime
//         current_time = moment()
//         start_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${start_time}`)
//         end_time = moment(`${moment(current_time).format('YYYY-MM-DD')} ${end_time}`)
//         while (start_time.isBefore(end_time)) {
//             // adding the minutes
//             array_slots.push({ start_time: start_time.format('HH:mm'), end_time: moment(start_time, 'HH:mm').add(interval, 'minutes').format('HH:mm') })
//             start_time = moment(start_time, 'HH:mm').add(interval, 'minutes')
//         }
//         resolve(array_slots)
//     })
// }



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

    if (req.body.name != null && req.body.name != undefined && req.body.name != '') {
        data_to_insert.name = req.body.name
    }

    if (req.body.contact != null && req.body.contact != undefined && req.body.contact != '') {
        data_to_insert.contact = req.body.contact
    } else {
        data_to_insert.contact = req.userdata.phone
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

    if (req.body.date_time != null && req.body.date_time != undefined && req.body.date_time != '') {
        data_to_insert.created_datetime = req.body.date_time
    }

    if (req.body.business_appointment_id != '' && req.body.business_appointment_id != null && req.body.business_appointment_id != undefined) {
        var sql = `UPDATE business_appointment SET updated_at = NOW(), ? WHERE id = ${req.body.business_appointment_id}`;
    } else {
        var sql = "INSERT INTO business_appointment SET created_at = NOW(), ?";
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
    if (req.body.user_id != null && req.body.user_id != undefined && req.body.user_id != '') {
        user_id = req.body.user_id
    } else if (req.userdata.id != null && req.userdata.id != undefined && req.userdata.id != '') {
        user_id = req.userdata.id
    } else {
        return res.status(400).json({ status: 'failed', message: 'user_id is missing' });
    }
    var business_id = null

    if (req.body.business_id) {
        business_id = req.body.business_id
    }

    if (business_id != null) {
        var sql = "SELECT b_a.id, b_a.business_id, IFNULL(b_m.business_name,'') as business_name, IFNULL(b_m.business_phone,'') as business_phone, IFNULL(b_a_p.person_email,'') as person_email , b_a.special_notes,if(b_a.created_datetime < NOW() ,'completed', if(b_a.deleted_at IS NOT NULL,'cancelled','upcoming'))  as status ,DATE_FORMAT(b_a.created_datetime , '%Y%m%d%H%i%s') as time, DATE_FORMAT(b_a.created_datetime , '%Y-%m-%d %H:%i:%s') AS created_datetime\n\
        FROM business_appointment as b_a \n\
        JOIN business_appointment_person as b_a_p \n\
        JOIN business_master as b_m \n\
        ON b_m.business_id= b_a.business_id \n\
        AND b_a.person_id = b_a_p.id \n\
        WHERE b_a.user_id = '" + user_id + "' AND b_a.business_id = '" + business_id + "' GROUP BY id ORDER BY b_a.created_datetime DESC"
        appointment_data = await exports.run_query(sql);
    } else {

        var sql = "SELECT b_a.id,b_a.user_id, b_a.business_id, IFNULL(b_m.business_name,'') as business_name, IFNULL(b_m.business_phone,'') as business_phone, IFNULL(b_a_p.person_email,'') as person_email , b_a.special_notes,b_a.special_notes,if(b_a.created_datetime < NOW() ,'completed', if(b_a.deleted_at IS NOT NULL,'cancelled','upcoming'))  as status ,DATE_FORMAT(b_a.created_datetime , '%Y%m%d%H%i%s') as time, DATE_FORMAT(b_a.created_datetime , '%Y-%m-%d %H:%i:%s') AS created_datetime\n\
        FROM business_appointment as b_a \n\
        JOIN business_appointment_person as b_a_p \n\
        JOIN business_master as b_m \n\
        ON b_m.business_id= b_a.business_id \n\
        AND b_a.person_id = b_a_p.id \n\
        WHERE b_a.user_id = '" + user_id + "' GROUP BY id ORDER BY b_a.created_datetime DESC"
        appointment_data = await exports.run_query(sql);
    }
    result = await exports.run_query(sql);
    try {
        if (result == '') {
            return res.status(200).send({ status: 'success', message: 'Data not found', data: result })
        }
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