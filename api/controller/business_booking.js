var db = require('../config/db');

var today = new Date();
var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();

/**
 * FETCH ALL BUSINESS BOOKING
 */
exports.all_business_booking = async function (req, res, next) {
    try {
        var today_date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        var business_id = req.userdata.business_id;

        var Condition = " business_id='" + business_id + "' AND deleted_at IS NULL ";

        if (req.body.booking_date != '' && req.body.booking_date != 'undefined' && req.body.booking_date != null) {
            today_date = req.body.booking_date
        }
        Condition += " AND DATE(created_datetime) = '" + today_date + "' ";

        var slots = await exports.getBookingSlots(business_id, today_date);
        
		var sql1 = "SELECT start_time,end_time,slot_length FROM business_booking_setting WHERE business_id='"+ business_id + "'";
        
		db.query(sql1, function (err, result) {
			if (err){
				return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
			}
            var slot_lenght=result[0].slot_length;
            var starttime=result[0].start_time;
            var endtime=result[0].end_time;
			
			var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
						DATE_FORMAT(created_datetime, '%d %b') AS created_date, \n\
						DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
						FROM business_booking WHERE " + Condition;
			db.query(sql, function (err, result) {
				if (err) {
					return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
				}else{
					if(result!=null && result!=''){
					   return res.status(200).json({ status: 'success', message: 'success', slot_lenght:slot_lenght, starttime:starttime,endtime:endtime, slots: slots});	
					}else{
						return res.status(200).json({ status: 'success', message: 'No Data Found',starttime:starttime,endtime:endtime,slot_lenght:slot_lenght, slots:[]});
					}
				}
			});
		});
        
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * FIND BUSINESS BOOKING BY ID
 */
exports.find_business_booking = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        if (req.body.booking_id == '' || req.body.booking_id == 'undefined' || req.body.booking_id == null) {
            return res.status(403).json({ status: 'error', message: 'Booking id not found.' });
        }
        var booking_id = req.body.booking_id;
        var sql = "SELECT id,`name`,contact,no_of_person,special_notes, \n\
                    DATE_FORMAT(created_datetime, '%d-%m-%Y') AS created_date, \n\
                    DATE_FORMAT(created_datetime, '%H:%i') AS created_time  \n\
                    FROM business_booking WHERE id='"+ booking_id + "' AND business_id='" + business_id + "' AND deleted_at IS NULL";
        db.query(sql, function (err, result) {
            if (err) {
                return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
            }
			if(result.length>0){
				return res.status(200).json({ status: 'success', message: 'success', data: result[0] });
			}else{
				return res.status(200).json({ status: 'success', message: 'No data found for this Booking', data:[] });
			}
            
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
};


/**
 * EDIT BUSINESS BOOKING BY ID
 */
exports.edit_business_booking = function (req, res, next) {
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
        db.query(sql, function (err, result) {
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
exports.create_manual_booking = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.name == '' || req.body.name == 'undefined' || req.body.name == null) {
            return res.status(403).json({ status: 'error', message: 'Name not found.' });
        } else if (req.body.contact == '' || req.body.contact == 'undefined' || req.body.contact == null) {
            return res.status(403).json({ status: 'error', message: 'Contact not found.' });
        } else if (req.body.no_of_person == '' || req.body.no_of_person == 'undefined' || req.body.no_of_person == null) {
            return res.status(403).json({ status: 'error', message: 'Number of person not found.' });
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
            no_of_person: req.body.no_of_person,
            special_notes: req.body.special_notes,
            created_datetime: req.body.created_date + ' ' + req.body.created_time,
        };

        var sql = "INSERT INTO business_booking SET ?";
        db.query(sql, postval, function (err, result) {
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
exports.delete_manual_booking = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;

        if (req.body.booking_id == '' || req.body.booking_id == 'undefined' || req.body.booking_id == null) {
            return res.status(403).json({ status: 'error', message: 'Booking id not found.' });
        }

        var booking_id = req.body.booking_id;

        var sql = "UPDATE business_booking SET deleted_at = NOW() WHERE id='" + booking_id + "'";
        db.query(sql, function (err, result) {
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

        var sql = "UPDATE business_booking_setting SET " + update_column + " WHERE business_id='" + business_id + "'";
        db.query(sql, function (err, result) {
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
exports.get_setting = function (req, res, next) {
    try {
        var business_id = req.userdata.business_id;
        var sql = "SELECT start_time,end_time,advance_booking_start_days,advance_booking_end_days, \n\
                    advance_booking_hours,slot_length,booking_per_slot,booking_per_day,announcement \n\
                    FROM business_booking_setting WHERE business_id='"+ business_id + "'";
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
 * GET THE BOOKING SLOTS
 */
exports.getBookingSlots = async function (business_id, date) {
    try {
        return new Promise(function (resolve, reject) {
            var sql = "SELECT start_time,end_time,slot_length \n\
                        FROM business_booking_setting WHERE business_id='"+ business_id + "'";
            db.query(sql, function (err, result) {
                if (err) {
                    return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
                }
                var starttime = result[0].start_time;
                var endtime = result[0].end_time;
                var interval = result[0].slot_length;
                var timeslots = [];
				
                while (starttime <= endtime) {
                    var start_datetime = date + ' ' + starttime;
                    starttime = addMinutes(starttime, interval);
                    var end_datetime = date + ' ' + starttime;

                    var sql = "SELECT id,`name`,contact,no_of_person,special_notes,DATE_FORMAT(created_datetime, '%d %b') AS created_date, DATE_FORMAT(created_datetime, '%H:%i') AS created_time , DATE_FORMAT('" + start_datetime + "','%H:%i') AS start_time, DATE_FORMAT('"+ end_datetime + "','%H:%i') AS end_time FROM business_booking WHERE business_id='" + business_id + "' \n\
                    AND created_datetime>='" + start_datetime + "' AND created_datetime <'" + end_datetime + "' \n\
                    AND deleted_at IS NULL";
                    db.query(sql, function (e, r) {
						if(r.length>0){
							var resultArray = JSON.parse(JSON.stringify(r));
                            timeslots.push(resultArray);							
						}
                    });
                }
                resolve(timeslots);
				
            });
        });
    } catch (e) {
        return res.status(500).json({ status: 'error', message: 'Something went wrong.' });
    }
}

/**
 * FETCH BOOKING DATA AS PER TIME SLOT
 */
    async function getBusinessBookingData(business_id,date,start_time,end_time) {
		var start_datetime = date + ' ' + start_time;
        var end_datetime = date + ' ' + end_time;
		return new Promise(function(resolve, reject){
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
    var date = new Date(new Date(today_date + ' ' + time).getTime() + minutes * 60000);
    var tempTime = ((date.getHours().toString().length == 1) ? '0' + date.getHours() : date.getHours()) + ':' +
        ((date.getMinutes().toString().length == 1) ? '0' + date.getMinutes() : date.getMinutes()) + ':' +
        ((date.getSeconds().toString().length == 1) ? '0' + date.getSeconds() : date.getSeconds());
    return tempTime;
}