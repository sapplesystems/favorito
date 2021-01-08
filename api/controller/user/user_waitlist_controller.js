var db = require('../../config/db');
var moment = require('moment');
const { end } = require('../../config/db');
const { now } = require('moment');
var img_path = process.env.BASE_URL + ':' + process.env.APP_PORT + '/uploads/';


// get all waitlist by business_id
exports.get_waitlist = async function(req, res, next) {
    if (req.body.business_id == '' || req.body.business_id == null || req.body.business_id == undefined) {
        return res.status(400).json({ status: 'error', message: 'business_id is required.' });
    } else if (req.userdata.id == '' || req.userdata.id == null || req.userdata.id == undefined) {
        return res.status(400).json({ status: 'error', message: 'user_id is required.' });
    }
    sql_waitlist = `SELECT id, user_id, business_id,no_of_person, waitlist_status, DATE_FORMAT(created_at ,"%Y-%m-%d %H:%i:%s") as booked_slot ,DATE_FORMAT(updated_at ,"%Y-%m-%d %H:%i:%s") as updated_at FROM business_waitlist WHERE user_id = '${req.userdata.id}' AND business_id = '${req.body.business_id}' AND deleted_at IS NULL`

    sql_business_detail = `SELECT business_name FROM business_master WHERE business_id = '${req.body.business_id}'`
    sql_business_waitlist_setting = `SELECT slot_length, minium_wait_time FROM business_waitlist_setting WHERE business_id = '${req.body.business_id}'`
    try {
        result_business_waitlist_setting = await exports.run_query(sql_business_waitlist_setting)
        result_waitlist = await exports.run_query(sql_waitlist)
        if (result_waitlist == '') {
            return res.status(200).json({ status: 'success', message: 'Waitlist is not saved yet', date: [] });
        }

        slot_length = result_business_waitlist_setting[0].slot_length
        time_1 = result_waitlist[0].booked_slot
        added_time = parseInt(result_waitlist[0].booked_slot.substring(11, 13)) + parseInt(slot_length)
        time_2 = time_1.substring(0, 11) + added_time + time_1.substring(13);
        sql_count_total_waitlist = `SELECT COUNT(business_id) as count FROM business_waitlist \n\
        WHERE business_id = '${req.body.business_id}' \n\
        AND deleted_at IS NULL \n\
        AND created_at >= '${time_1}'
        AND created_at < '${time_2}'`
        result_count_total_waitlist = await exports.run_query(sql_count_total_waitlist)
        console.log();
        result_business_name = await exports.run_query(sql_business_detail)
        data = []
        data_object = {}

        data_object.waitlist_id = result_waitlist[0].id
        data_object.created_at = result_waitlist[0].booked_slot
        data_object.updated_at = result_waitlist[0].updated_at
        data_object.user_id = result_waitlist[0].user_id
        data_object.waitlist_status = result_waitlist[0].waitlist_status
        data_object.business_name = result_business_name[0].business_name
        data_object.booked_slot = result_waitlist[0].booked_slot.substring(11, 16)
        data_object.no_of_person = result_waitlist[0].no_of_person
        data_object.minimum_wait_time = result_business_waitlist_setting[0].minium_wait_time
        data_object.parties_before_you = parseInt(result_count_total_waitlist[0].count) - 1
        res.status(200).send({ status: 'success', message: 'success', data: [data_object] })
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
    }
};

exports.get_waitlist = async function(req, res, next) {
    if (req.body.business_id == '' || req.body.business_id == null || req.body.business_id == undefined) {
        return res.status(400).json({ status: 'error', message: 'business_id is required.' });
    } else if (req.userdata.id == '' || req.userdata.id == null || req.userdata.id == undefined) {
        return res.status(400).json({ status: 'error', message: 'user_id is required.' });
    }
    sql_waitlist = `SELECT id, user_id, business_id,no_of_person, waitlist_status, DATE_FORMAT(created_at ,"%Y-%m-%d %H:%i:%s") as booked_slot ,DATE_FORMAT(updated_at ,"%Y-%m-%d %H:%i:%s") as updated_at FROM business_waitlist WHERE user_id = '${req.userdata.id}' AND business_id = '${req.body.business_id}' AND deleted_at IS NULL`

    sql_business_detail = `SELECT business_name FROM business_master WHERE business_id = '${req.body.business_id}'`
    sql_business_waitlist_setting = `SELECT slot_length, minium_wait_time FROM business_waitlist_setting WHERE business_id = '${req.body.business_id}'`
    try {
        result_business_waitlist_setting = await exports.run_query(sql_business_waitlist_setting)
        result_waitlist = await exports.run_query(sql_waitlist)
            // return res.send(result_waitlist)

        if (result_waitlist == '') {
            return res.status(200).json({ status: 'success', message: 'Waitlist is not saved yet', date: [] });
        }

        slot_length = result_business_waitlist_setting[0].slot_length
        time_1 = result_waitlist[0].booked_slot.substring(0, 14) + "00:00"
        added_time = parseInt(result_waitlist[0].booked_slot.substring(11, 13)) + parseInt(slot_length)
        time_2 = time_1.substring(0, 11) + added_time + time_1.substring(13);



        // checking if the time slot is ended then return wait list is not available and deleted that waitlist
        is_slot_still_exist = await exports.isSlotStillExist(time_2, result_waitlist[0].id, res)
            // return res.send(is_slot_still_exist)
        if (is_slot_still_exist == false) {
            return res.status(200).json({ status: 'success', message: 'Your Waitlist timie slot is over', date: [] });
        }
        // return res.send({ is_slot_still_exist })
        // sql_count_total_waitlist = `SELECT COUNT(business_id) as count FROM business_waitlist \n\
        // WHERE business_id = '${req.body.business_id}' \n\
        // AND deleted_at IS NULL \n\
        // AND created_at >= '${time_1}'
        // AND created_at < '${time_2}'`

        sql_count_total_waitlist = `SELECT id, user_id, DATE_FORMAT(created_at ,"%Y-%m-%d %H:%i:%s") as created_at, @curRank := @curRank + 1 AS rank FROM business_waitlist p, (SELECT @curRank := 0) r \n\
        WHERE business_id = '${req.body.business_id}' \n\
        AND deleted_at IS NULL \n\
        AND created_at >= '${time_1}'
        AND created_at < '${time_2}'
        AND waitlist_status != 'rejected'
        ORDER BY created_at`
        result_count_total_waitlist = await exports.run_query(sql_count_total_waitlist)
        position = 0
        result_count_total_waitlist.map(element => {
            if (element.user_id == req.userdata.id) {
                position = element.rank
            }
        });

        // return res.send({ position, result_count_total_waitlist })
        result_business_name = await exports.run_query(sql_business_detail)
        data = []
        data_object = {}

        data_object.waitlist_id = result_waitlist[0].id
        data_object.created_at = result_waitlist[0].booked_slot
        data_object.updated_at = result_waitlist[0].updated_at
        if (data_object.updated_at != null) {
            var duration = moment.duration(moment(data_object.updated_at).diff(moment(data_object.created_at)));
            duration = `${duration.asMinutes()} min`
        }

        data_object.user_id = result_waitlist[0].user_id
        data_object.waitlist_status = result_waitlist[0].waitlist_status
        data_object.business_name = result_business_name[0].business_name
        data_object.booked_slot = result_waitlist[0].booked_slot.substring(11, 16)
        data_object.no_of_person = result_waitlist[0].no_of_person
        data_object.minimum_wait_time = result_business_waitlist_setting[0].minium_wait_time
        data_object.duration_updated_and_created = duration
        if (position == 0) {
            data_object.parties_before_you = position
        } else {
            data_object.parties_before_you = position - 1
        }
        res.status(200).send({ status: 'success', message: 'success', data: [data_object] })
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
    }
};

// return false if slot_time is over and delete the waitlist 
exports.isSlotStillExist = async(time_2, waitlist_id, res) => {
    return new Promise(async(resolve, reject) => {
        current_time = moment().format('YYYY MM DD hh:mm:ss')
        duration_slot_n_current = moment.duration(moment(time_2).diff(moment(current_time)));
        if (duration_slot_n_current.asMinutes() < 0 || duration_slot_n_current.asMinutes() == 0) {
            sql = `UPDATE business_waitlist SET deleted_at = NOW() WHERE id = ${waitlist_id}`
            result = await exports.run_query(sql)
            if (result.affectedRows > 0) {
                resolve(false)
            } else {
                resolve(true)
            }
        } else {
            resolve(true)
        }
    })
}

exports.business_waitlist_verbose = async function(req, res, next) {
    try {
        var business_id = req.body.business_id;
        current_time = moment(new Date(), 'HHmmss').format('YYYY-MM-DD HH:MM:SS')
        sql_get_slot_setting = `SELECT start_time,end_time , slot_length,booking_per_slot,minium_wait_time FROM business_waitlist_setting \n\
            WHERE business_id = '${business_id}' \n\
            AND NOW() > start_time AND NOW() < end_time`
        result_get_slot_setting = await exports.run_query(sql_get_slot_setting)
        if (result_get_slot_setting == '') {
            return res.status(200).send({ status: 'success', message: 'Waitlist is not available', data: [] });
        }
        sql_business_name = `SELECT business_name FROM business_master WHERE business_id = '${business_id}'`
        result_business_name = await exports.run_query(sql_business_name)
        business_name = result_business_name[0].business_name
            // creating slots in array
        array_slots = []
        start_time = result_get_slot_setting[0].start_time
        end_time = result_get_slot_setting[0].end_time
        available_time = current_time
        available_time = available_time.substring(0, 14) + '00' + available_time.substring(16);
        available_time_current_hour = parseInt(available_time.substring(11, 13))

        // making the slot after the current time
        for (i = parseInt(start_time.substring(0, 2)); i < parseInt(end_time.substring(0, 2)); i = i + result_get_slot_setting[0].slot_length) {
            available_time_slots = available_time.substring(0, 11) + i + available_time.substring(13);
            if (available_time_current_hour <= i) {
                array_slots.push(available_time_slots)
            }
        }

        // check business is available or not at this time
        if (result_get_slot_setting.length > 0) {
            for (i = 0; i < array_slots.length - 1; i++) {
                time_1 = array_slots[i]
                time_2 = array_slots[i + 1]
                sql_count_total_waitlist = `SELECT COUNT(business_id) as count FROM business_waitlist \n\
                WHERE business_id = '${business_id}' \n\
                AND deleted_at IS NULL \n\
                AND created_at > '${time_1}'
                AND created_at < '${time_2}'
                AND waitlist_status != 'rejected'`

                result_count_total_waitlist = await exports.run_query(sql_count_total_waitlist)
                if (result_count_total_waitlist[0].count < result_get_slot_setting[0].booking_per_slot) {
                    parties_before = result_count_total_waitlist[0].count
                    vacant_time_slot = time_1.substring(11, 16)
                    vacant_time_slot_check = vacant_time_slot.split(':')
                    if (vacant_time_slot_check[0].length == 1) {
                        vacant_time_slot = "0" + vacant_time_slot.substring(0, vacant_time_slot.length - 1)
                    }
                    break
                }
            }
            data = []
            data_object = {}
            data_object.parties_before_you = parties_before
            data_object.business_name = business_name
            data_object.available_time_slots = vacant_time_slot
            data_object.minimum_wait_time = result_get_slot_setting[0].minium_wait_time
            data.push(data_object)
            return res.status(200).json({ status: 'success', message: 'success', data: data });
        } else {
            return res.status(200).send({ status: 'success', message: 'Business is not available at this time', data: [] });
        }
    } catch (error) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.', error });
    }
};

exports.set_waitlist = async function(req, res, next) {
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

    if (req.body.no_of_person == '' || req.body.no_of_person == null || req.body.no_of_person == undefined) {
        return res.status(403).json({ status: 'error', message: 'Number of person is required.' });
    } else {
        data_to_insert.no_of_person = req.body.no_of_person
    }

    if (req.body.special_notes != '' && req.body.special_notes != null && req.body.special_notes != undefined) {
        data_to_insert.special_notes = req.body.special_notes
    }

    if (req.body.contact != '' && req.body.contact != null && req.body.contact != undefined) {
        data_to_insert.contact = req.body.contact
    } else {
        if (req.userdata.phone) {
            data_to_insert.contact = req.userdata.phone
        }
    }

    if (req.body.slot != '' && req.body.slot != null && req.body.slot != undefined) {
        slot_time = moment(new Date(), 'HHmmss').format('YYYY-MM-DD HH:mm:ss')
        time_slot_final = slot_time.substring(0, 11) + parseInt(req.body.slot) + slot_time.substring(13);
        data_to_insert.created_at = time_slot_final
    }
    // return res.send(data_to_insert)
    if (req.body.name != '' && req.body.name != null && req.body.name != undefined) {
        data_to_insert.name = req.body.name
    } else {
        data_to_insert.name = ''
    }



    if (req.body.waitlist_id != '' && req.body.waitlist_id != null && req.body.waitlist_id != undefined) {
        var sql = `UPDATE business_waitlist SET updated_at = NOW(), ? WHERE id = ${req.body.waitlist_id}`;
    } else {
        var sql = "INSERT INTO business_waitlist SET ?";
    }
    try {
        result = await exports.run_query(sql, data_to_insert)
        if (result.affectedRows > 0) {
            return res.status(200).json({ status: 'success', message: 'Waitlist is set' });
        } else {
            return res.status(400).json({ status: 'failed', message: 'Something went wrong' });
        }
    } catch (error) {
        return res.status(400).json({ status: 'failed', message: 'Something went wrong', error });
    }
}

exports.cancel_waitlist = async function(req, res, next) {
    if (req.body.waitlist_id == null || req.body.waitlist_id == undefined || req.body.waitlist_id == '') {
        return res.status(500).json({ status: 'error', message: 'waitlist_id is missing' });
    } else {
        try {
            sql = `UPDATE business_waitlist SET deleted_at = NOW() WHERE id = ${req.body.waitlist_id}`
            result = await exports.run_query(sql)
            if (result.affectedRows > 0) {
                return res.status(200).json({ status: 'success', message: 'Waitlist is deleted.' });
            }
            return res.status(200).json({ status: 'success', message: 'Waitlist is deleted' });
        } catch (error) {
            return res.status(400).json({ status: 'error', message: 'Something went wrong', error });
        }
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